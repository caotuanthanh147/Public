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
local Lighting = game:GetService('Lighting')
local CoreGui = Services.CoreGui
local TweenService = Services.TweenService
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
local Flags = {}
local Connections = {}
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
    repeat task.wait() until result ~= nil or (tick() - start) > 0.001
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
local Remotes = setmetatable({}, {
    __index = function(self, key)
        local paths = {
            DamageEvent    = "RSAssets.Events.DamageEvent",
            CreateEvent    = "RSAssets.Events.CreateEvent",
            GatherFunction = "RSAssets.Events.GatherFunction",
            JobFunction       = "RSAssets.Events.JobFunction",
            JobEvent          = "RSAssets.Events.JobEvent",
            ServerGameEvent   = "RSAssets.Events.ServerGameEvent",
            UpdateUiEvent     = "RSAssets.Events.UpdateUiEvent",
            ShopFunction      = "RSAssets.Events.ShopFunction",
            QuestEvent        = "RSAssets.Events.QuestEvent",
        }
        local path = paths[key]
        if not path then return nil end
        local obj = GetObject(RS, path)
        if obj then rawset(self, key, obj) end
        return obj
    end,
})
local Modules = {
}
local Flags = {}
local Shared = {
    JobActive = false,
}
local Tables = {
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local ESPFolder = Instance.new("Folder")
ESPFolder.Name   = HttpService:GenerateGUID(false)
ESPFolder.Parent = CoreGui
local ESPConnections = {}
local AllHighlights  = {}
local ESPConfig = {
    {
        Id      = "ESPEnemies",
        Group   = "left",
        Text    = "Enemy ESP",
        Display = "Enemy",
        Fill    = Color3.fromRGB(255, 60, 60),
        Outline = Color3.fromRGB(0, 0, 0),
        GetItems = function()
            local items = {}
            for _, model in pairs(workspace:GetChildren()) do
                if model:IsA("Model") and model:GetAttribute("EnemyName") then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        table.insert(items, model)
                    end
                end
            end
            return items
        end,
        GetDisplay = function(item)
            return item:GetAttribute("EnemyName") or item.Name
        end,
        GetAdornee = function(item)
            return item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item:FindFirstChildWhichIsA("BasePart")
        end,
        IsAlive = function(item)
            if not item.Parent then return false end
            local hum = item:FindFirstChildOfClass("Humanoid")
            return hum ~= nil and hum.Health > 0
        end,
        Watch = function(onAdded, onRemoved)
            local a = workspace.ChildAdded:Connect(function(c)
                if c:IsA("Model") and c:GetAttribute("EnemyName") then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then onAdded(c) end
                end
            end)
            local r = workspace.ChildRemoved:Connect(onRemoved)
            return a, r
        end,
    },
    {
        Id      = "ESPInteractables",
        Group   = "right",
        Text    = "Interactable ESP",
        Display = "Interactable",
        Fill = Color3.fromRGB(70, 130, 180),
        Outline = Color3.fromRGB(0, 0, 0),
        GetItems = function()
            local items = {}
            for _, desc in pairs(workspace:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and desc.Parent and desc.Parent:IsA("BasePart") then
                    table.insert(items, desc)
                end
            end
            return items
        end,
        GetDisplay = function(item)
            local cur = item.Parent
            while cur and cur ~= workspace do
                if cur:IsA("Model") then return cur.Name end
                cur = cur.Parent
            end
            return "Interactable"
        end,
        GetAdornee = function(item)
            return item.Parent
        end,
        IsAlive = function(item)
            return item.Parent ~= nil and item.Parent.Parent ~= nil
        end,
        Watch = function(onAdded, onRemoved)
            local a = workspace.DescendantAdded:Connect(function(d)
                if d:IsA("ProximityPrompt") and d.Parent and d.Parent:IsA("BasePart") then onAdded(d) end
            end)
            local r = workspace.DescendantRemoving:Connect(function(d)
                if d:IsA("ProximityPrompt") then onRemoved(d) end
            end)
            return a, r
        end,
    },
}
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
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
    elseif target:IsA("TouchTransmitter") then
        part = target:FindFirstAncestorWhichIsA("BasePart")
    else
        part = target:FindFirstAncestorWhichIsA("BasePart")
    end
    if not part then
        return
    end
    task.spawn(function()
        firetouchinterest(part, root, 1)
        task.wait(.1)
        firetouchinterest(part, root, 0)
    end)
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
for _, cfg in ipairs(ESPConfig) do AllHighlights[cfg.Id] = {} end
local function makeESPLabel(text, sizeY, posY, bold, textColor)
    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, 0, sizeY, 0)
    lbl.Position               = UDim2.new(0, 0, posY, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = text
    lbl.TextColor3             = textColor or Color3.new(1, 1, 1)
    lbl.TextStrokeColor3       = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextScaled             = true
    lbl.Font                   = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextXAlignment         = Enum.TextXAlignment.Center
    return lbl
end
local function MakeEsp(item, cfg)
    local part = cfg.GetAdornee(item)
    if not part then return nil end
    local fillColor    = Options[cfg.Id .. "Color"] and Options[cfg.Id .. "Color"].Value or cfg.Fill
    local outlineColor = Options[cfg.Id .. "Outline"] and Options[cfg.Id .. "Outline"].Value or cfg.Outline
    local displayName  = cfg.GetDisplay and cfg.GetDisplay(item) or cfg.Display
    local h = Instance.new("Highlight")
    h.Adornee             = (part:IsA("BasePart") or part:IsA("Model")) and part or nil
    h.FillColor           = fillColor
    h.OutlineColor        = outlineColor
    h.FillTransparency    = 0.4
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent              = ESPFolder
    local bb = Instance.new("BillboardGui")
    bb.Name         = HttpService:GenerateGUID(false)
    bb.Adornee      = part:IsA("BasePart") and part or (part:IsA("Model") and (part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart")))
    bb.Size         = UDim2.new(0, 100, 0, 22)
    bb.StudsOffset  = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop  = true
    bb.ResetOnSpawn = false
    bb.Parent       = ESPFolder
    local nameLbl = makeESPLabel(displayName, 0.55, 0, true, fillColor)
    nameLbl.Parent = bb
    local distLbl = makeESPLabel("", 0.45, 0.55, false, fillColor)
    local distKey = HttpService:GenerateGUID(false)
    distLbl.Name   = distKey
    distLbl.Parent = bb
    bb:SetAttribute("DistLabel", distKey)
    return { highlight = h, billboard = bb }
end
local function RemEsp(tbl, key)
    local entry = tbl[key]
    if not entry then return end
    if entry.highlight then entry.highlight:Destroy() end
    if entry.billboard then entry.billboard:Destroy() end
    tbl[key] = nil
end
local function RefEsp(cfg)
    local tbl = AllHighlights[cfg.Id]
    for k in pairs(tbl) do RemEsp(tbl, k) end
    if not Toggles[cfg.Id] or not Toggles[cfg.Id].Value then return end
    for _, item in ipairs(cfg.GetItems()) do
        tbl[item] = MakeEsp(item, cfg)
    end
end
local function WatchEsp(cfg)
    local addKey = cfg.Id .. "Added"
    local remKey = cfg.Id .. "Removed"
    if ESPConnections[addKey] then ESPConnections[addKey]:Disconnect() end
    if ESPConnections[remKey] then ESPConnections[remKey]:Disconnect() end
    if not Toggles[cfg.Id] or not Toggles[cfg.Id].Value then return end
    local a, r = cfg.Watch(
        function(item) AllHighlights[cfg.Id][item] = MakeEsp(item, cfg) end,
        function(item) RemEsp(AllHighlights[cfg.Id], item) end
    )
    ESPConnections[addKey] = a
    ESPConnections[remKey] = r
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
local function Func_DealDamage()
    while Toggles.KillAura.Value do
        local char = GetCharacter()
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if char and myRoot then
            local range = tonumber(Options.KillRange.Value) or 999
            for _, model in pairs(workspace:GetChildren()) do
                if model:IsA("Model") and workspace.EnemyList:FindFirstChild(model.Name) then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local root = model:FindFirstChild("HumanoidRootPart")
                    local effects = model:FindFirstChild("Effects")
                    if hum and hum.Health > 0 and root and effects then
                        local dist = (root.Position - myRoot.Position).Magnitude
                        if dist <= range then
                            local timestamp = tostring(tick())
                            Remotes.DamageEvent:FireServer("BlastIt", 99999999, model, timestamp)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoLoot()
    while Toggles.AutoLoot.Value do
        local spots = GetObject(workspace, "Map.GeneratedGatheringSpots")
        if spots then
            for _, spot in pairs(spots:GetChildren()) do
                if not Toggles.AutoLoot.Value then break end
                local prompt = GetObject(spot, "PromptPoint.ProximityPrompt")
                if prompt then
                    SafeInvoke(Remotes.GatherFunction, prompt)
                    task.wait()
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        local data = Plr:FindFirstChild("Data")
        if data then
            local itemInventory = data:FindFirstChild("ItemInventory")
            if itemInventory then
                local selected = Options.SellItems.Value
                local hasSelection = false
                for _, v in pairs(selected) do if v then hasSelection = true break end end
                for _, itemInstance in pairs(itemInventory:GetChildren()) do
                    if not Toggles.AutoSell.Value then break end
                    if hasSelection and not selected[itemInstance.Name] then continue end
                    SafeInvoke(Remotes.ShopFunction, "Sell", {
                        "ITEM",
                        itemInstance.Name,
                        "Scavenger",
                        itemInstance
                    })
                    task.wait()
                end
            end
            local weaponInventory = data:FindFirstChild("WeaponInventory")
            if weaponInventory then
                local selected = Options.SellWeapons.Value
                local hasSelection = false
                for _, v in pairs(selected) do if v then hasSelection = true break end end
                for _, itemInstance in pairs(weaponInventory:GetChildren()) do
                    if not Toggles.AutoSell.Value then break end
                    if hasSelection and not selected[itemInstance.Name] then continue end
                    SafeInvoke(Remotes.ShopFunction, "Sell", {
                        "WEAPON",
                        itemInstance.Name,
                        "WeaponStore",
                        itemInstance
                    })
                    task.wait()
                end
            end
            local outfitInventory = data:FindFirstChild("OutfitInventory")
            if outfitInventory then
                local selected = Options.SellCostumes.Value
                local hasSelection = false
                for _, v in pairs(selected) do if v then hasSelection = true break end end
                for _, itemInstance in pairs(outfitInventory:GetChildren()) do
                    if not Toggles.AutoSell.Value then break end
                    if hasSelection and not selected[itemInstance.Name] then continue end
                    SafeInvoke(Remotes.ShopFunction, "Sell", {
                        "EQUIPMENT",
                        itemInstance.Name,
                        "ClothingStore",
                        itemInstance
                    })
                    task.wait()
                end
            end
        end
        task.wait()
    end
end
local DifficultyGrade = {
    ["Canard"] = 9,
    ["Urban Myth"] = 8,
    ["Urban Legend"] = 7,
    ["Urban Plague"] = 6,
    ["Urban Nightmare"] = 4,
    ["Star of the City"] = 2,
    ["Impuritas Civitatis"] = 1,
}
local FarmDist = 5
local FarmPos = "Above"
local DiffLabelToName = {}
local function GetAllDifficultyNames()
    local ServerInfo = workspace:FindFirstChild("ServerInfo")
    local GameInfo = workspace:FindFirstChild("GameInfo")
    if not ServerInfo or not GameInfo then return {} end
    local hostKey = ServerInfo:GetAttribute("HostKey")
    if not hostKey then return {} end
    local officeInfo = GameInfo:FindFirstChild("OfficeInfo")
    if not officeInfo then return {} end
    local hostFolder = officeInfo:FindFirstChild(hostKey)
    if not hostFolder then return {} end
    local jobList = hostFolder:FindFirstChild("JobList")
    if not jobList then return {} end
    table.clear(DiffLabelToName)
    local entries = {}
    for _, diffFolder in ipairs(jobList:GetChildren()) do
        local grade = DifficultyGrade[diffFolder.Name]
        local label = grade and (diffFolder.Name .. " (Grade " .. tostring(grade) .. ")") or diffFolder.Name
        DiffLabelToName[label] = diffFolder.Name
        table.insert(entries, { label = label, grade = grade or 99 })
    end
    table.sort(entries, function(a, b) return a.grade > b.grade end)
    local diffs = {}
    for _, e in ipairs(entries) do
        table.insert(diffs, e.label)
    end
    return diffs
end
local function GetPos(targetRoot)
    if FarmPos == "Above" then
        return Vector3.new(0, FarmDist, 0)
    elseif FarmPos == "Below" then
        return Vector3.new(0, -FarmDist, 0)
    elseif FarmPos == "Behind" then
        return targetRoot.CFrame.LookVector * -FarmDist
    end
    return Vector3.new(0, FarmDist, 0)
end
SafeConnect("JobActiveListener", function()
    return Remotes.UpdateUiEvent.OnClientEvent
end, function(action, state)
    if action == "JobInfo" then
        if state == "Enable" then
            task.delay(2, function() Shared.JobActive = true end)
        elseif state == "Disable" then
            Shared.JobActive = false
        end
    end
end)
local function Func_AutoFarm()
    local lastFire = 0
    local FarmCon
    FarmCon = RunService.Heartbeat:Connect(function()
        if not Toggles.AutoFarm.Value then
            FarmCon:Disconnect()
            return
        end
        local char = GetCharacter()
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not myRoot then return end
        local nearest, nearestDist = nil, math.huge
        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model") and workspace.EnemyList:FindFirstChild(model.Name) then
                local hum = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart")
                local effects = model:FindFirstChild("Effects")
                if hum and hum.Health > 0 and root and effects then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = model
                    end
                end
            end
        end
        if not nearest then
            if Shared.JobActive then
                local mapName = workspace.Map.CurrentMap.Value
                local mapFolder = mapName and workspace.Map:FindFirstChild(mapName)
                local escortAreas = mapFolder and GetObject(mapFolder, "SpawnAreas.Escort.Areas")
                local activeLeaveArea
                if escortAreas then
                    for _, area in pairs(escortAreas:GetChildren()) do
                        if area:FindFirstChild("TouchInterest") and area:FindFirstChild("EscortAreaEffect") then
                            activeLeaveArea = area
                            break
                        end
                    end
                end
                if activeLeaveArea then
                    myRoot.CFrame = CFrame.new(activeLeaveArea.Position + Vector3.new(0, 3, 0))
                else
                    local catPrompt = workspace:FindFirstChild("Cat") and workspace.Cat:FindFirstChild("Model") and workspace.Cat.Model:FindFirstChild("ProximityPrompt")
                    if catPrompt and catPrompt.Enabled then
                        local now = tick()
                        if not Flags.LastCatFire or (now - Flags.LastCatFire) >= 1 then
                            local ServerInfo = workspace:FindFirstChild("ServerInfo")
                            local GameInfo = workspace:FindFirstChild("GameInfo")
                            local hostKey = ServerInfo and ServerInfo:GetAttribute("HostKey")
                            local officeInfo = GameInfo and GameInfo:FindFirstChild("OfficeInfo")
                            local hostInfo = officeInfo and hostKey and officeInfo:FindFirstChild(hostKey)
                            local timeVal = hostInfo and hostInfo:FindFirstChild("Time")
                            if timeVal then
                                Flags.LastCatFire = now
                                Remotes.JobEvent:FireServer("Cat", timeVal.Value)
                            end
                        end
                    end
                end
            end
            return
        end
        local targetRoot = nearest:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end
        local desiredPos = targetRoot.Position + GetPos(targetRoot)
        myRoot.CFrame = CFrame.new(desiredPos)
        local now = tick()
        if now - lastFire >= 0.1 then
            lastFire = now
            local killRange = tonumber(Options.KillRange.Value) or 999
            local timestamp = tostring(now)
            for _, model in pairs(workspace:GetChildren()) do
                if model:IsA("Model") and workspace.EnemyList:FindFirstChild(model.Name) then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    local root = model:FindFirstChild("HumanoidRootPart")
                    local effects = model:FindFirstChild("Effects")
                    if hum and hum.Health > 0 and root and effects then
                        local dist = (root.Position - myRoot.Position).Magnitude
                        if dist <= killRange then
                            Remotes.DamageEvent:FireServer("BlastIt", 99999999, model, timestamp)
                        end
                    end
                end
            end
        end
    end)
    while Toggles.AutoFarm.Value do
        task.wait(0.1)
    end
    if FarmCon then FarmCon:Disconnect() end
end
local function Func_MaxSanity()
    while Toggles.MaxSanity.Value do
        local char = Plr.Character
        local sanity = char and char:FindFirstChild("Sanity")
        if sanity then
            local max = sanity:GetAttribute("MaxSanity")
            if max and sanity.Value < max then
                Remotes.CreateEvent:FireServer("AddSanity", max - sanity.Value)
            end
        end
        task.wait(0.1)
    end
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
local function Func_AutoQuest()
    while Toggles.AutoQuest.Value do
        local ServerInfo = workspace:WaitForChild("ServerInfo", 1)
        local GameInfo = workspace:WaitForChild("GameInfo", 1)
        local GameState = GameInfo:WaitForChild("GameState", 1)
        local OfficeInfo = GameInfo:WaitForChild("OfficeInfo", 1):WaitForChild(ServerInfo:GetAttribute("HostKey"), 1)
        local JobLisT1 = OfficeInfo and OfficeInfo:WaitForChild("JobList", 1)
        local state = GameState.Value
        if state == "Office" then
            local timeVal = OfficeInfo:FindFirstChild("Time")
            local currentTime = timeVal and timeVal.Value or 0
            if currentTime <= 0 then
                Remotes.ServerGameEvent:FireServer("SkipWeek")
                task.wait(3)
                continue
            end
            local selectedLabels = Options.DifficultySelected.Value
            local hasSelection = false
            local selectedDiffs = {}
            for label, active in pairs(selectedLabels) do
                if active then
                    hasSelection = true
                    local realName = DiffLabelToName[label] or label
                    selectedDiffs[realName] = true
                end
            end
            local validJobs = {}
            for _, diffFolder in ipairs(JobLisT1:GetChildren()) do
                if hasSelection and not selectedDiffs[diffFolder.Name] then continue end
                local grade = DifficultyGrade[diffFolder.Name] or 0
                for _, job in ipairs(diffFolder:GetChildren()) do
                    local req = job:GetAttribute("RequiredTime")
                    local isPresc = job:GetAttribute("Prescript") == true
                    if not isPresc and (req == nil or req <= currentTime) then
                        table.insert(validJobs, { job = job, diff = diffFolder.Name, grade = grade, req = req or 0 })
                    end
                end
            end
            if #validJobs == 0 then
                Remotes.ServerGameEvent:FireServer("SkipWeek")
                task.wait(3)
                continue
            end
            local priority = Options.QuestPriority and Options.QuestPriority.Value or "Highest Grade"
            table.sort(validJobs, function(a, b)
                if priority == "Highest Payment" then
                    local moneyA = tonumber(a.job:GetAttribute("Money")) or 0
                    local moneyB = tonumber(b.job:GetAttribute("Money")) or 0
                    return moneyA > moneyB
                else
                    return a.grade > b.grade
                end
            end)
            local best = validJobs[1]
            SafeInvoke(Remotes.JobFunction, "AcceptJob", best.job.Name)
            local leaveArea = workspace.Office:FindFirstChild("LeaveArea", true)
            if leaveArea then
                FireTI(leaveArea)
            end
            local stateTimeout = tick() + 5
            repeat task.wait(0.2) until GameState.Value ~= "Office" or tick() > stateTimeout
        elseif state == "Intermission" then
            Remotes.UpdateUiEvent:FireServer("Skip")
            task.wait(.5)
        else
        task.wait(1)
        end
    end
end
local function Func_AutoHanaSimulation()
    while Toggles.AutoHanaSimulation.Value do
        local ServerInfo = workspace:WaitForChild("ServerInfo", 1)
        local GameInfo = workspace:WaitForChild("GameInfo", 1)
        local GameState = GameInfo:WaitForChild("GameState", 1)
        local OfficeInfo = GameInfo:WaitForChild("OfficeInfo", 1):WaitForChild(ServerInfo:GetAttribute("HostKey"), 1)
        local state = GameState.Value
        if state == "Office" then
            local timeVal = OfficeInfo:FindFirstChild("Time")
            local currentTime = timeVal and timeVal.Value or 0
            if currentTime <= 0 then
                Remotes.ServerGameEvent:FireServer("SkipWeek")
                task.wait(3)
                continue
            end
            local enemy = Options.HanaEnemy.Value
            local diff = Options.HanaDifficulty.Value
            local Flags = OfficeInfo:FindFirstChild("Flags")
            local SimModule = require(RS:WaitForChild("RSAssets"):WaitForChild("SimulationModule"))
            local available = SimModule.GetAvailableEnemies()
            if not table.find(available, enemy) then
                notyuri("[HanaSimulation] Enemy not available:", enemy)
                task.wait(2)
                continue
            end
            local result = SafeInvoke(Remotes.JobFunction, "HanaSimulation", { enemy, diff })
            if result then
                local leaveArea = workspace.Office:FindFirstChild("LeaveArea", true)
                if leaveArea then
                    FireTI(leaveArea)
                end
                local stateTimeout = tick() + 5
                repeat task.wait(0.2) until GameState.Value ~= "Office" or tick() > stateTimeout
            else
                notyuri("[HanaSimulation] Invoke failed or returned false")
                task.wait(2)
            end
        elseif state == "Intermission" then
            Remotes.UpdateUiEvent:FireServer("Skip")
            task.wait(.5)
        else
            task.wait(1)
        end
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
local ESPGroupboxes = {
    left  = Tabs.ESP:AddLeftGroupbox("ESP"),
    right = Tabs.ESP:AddRightGroupbox("ESP"),
}
for _, cfg in ipairs(ESPConfig) do
    local gb = ESPGroupboxes[cfg.Group]
    gb:AddToggle(cfg.Id, { Text = cfg.Text, Default = false })
    gb:AddLabel("Fill Color"):AddColorPicker(cfg.Id .. "Color", {
        Title   = cfg.Text .. " Fill",
        Default = cfg.Fill,
    })
    gb:AddLabel("Outline Color"):AddColorPicker(cfg.Id .. "Outline", {
        Title   = cfg.Text .. " Outline",
        Default = cfg.Outline,
    })
end
TB_Tabs.Autofarm.T1:AddToggle("KillAura", { Text = "Kill Aura" })
TB_Tabs.Autofarm.T1:AddToggle("NoCooldown", { Text = "No Cooldown" })
TB_Tabs.Autofarm2.T1:AddInput("KillRange", {
    Text = "Kill Range",
    Default = "999",
    Numeric = true,
    Finished = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoFarm", { Text = "Auto Farm" })
TB_Tabs.Autofarm.T1:AddToggle("AutoLoot", { Text = "Auto Loot" })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell" })
TB_Tabs.Autofarm2.T1:AddDropdown("SellItems", {
    Text = "Sell Items",
    Values = (function()
        local items = {}
        local rsItems = GetObject(RS, "RSAssets.Items")
        for _, v in pairs(rsItems and rsItems:GetChildren() or {}) do
            table.insert(items, v.Name)
        end
        table.sort(items)
        return items
    end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SellWeapons", {
    Text = "Sell Weapons",
    Values = (function()
        local items = {}
        local rsWeapons = GetObject(RS, "RSAssets.WeaponScripts")
        for _, v in pairs(rsWeapons and rsWeapons:GetChildren() or {}) do
            table.insert(items, v.Name)
        end
        table.sort(items)
        return items
    end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SellCostumes", {
    Text = "Sell Costumes",
    Values = (function()
        local items = {}
        local rsOutfits = GetObject(RS, "RSAssets.PlayerOutfits")
        for _, v in pairs(rsOutfits and rsOutfits:GetChildren() or {}) do
            if v:IsA("Folder") then
                for _, outfit in pairs(v:GetChildren()) do
                    table.insert(items, outfit.Name)
                end
            end
        end
        table.sort(items)
        return items
    end)(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm2.T1:AddInput("Distance", {
    Text = "Distance",
    Default = "7",
    Numeric = true,
    Finished = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("Position", {
    Text = "Position",
    Values = { "Above", "Below", "Behind" },
    Default = "Above",
})
TB_Tabs.Autofarm.T1:AddToggle("AutoQuest", { Text = "Auto Quest" })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Accept Side Quests", Func = function()
    local quests = { "IvanDelivery", "OrganCollection", "SecuringTheGoods", "Scavenging" }
    for _, questName in ipairs(quests) do
        Remotes.QuestEvent:FireServer("AcceptQuest", questName)
        task.wait(0.1)
    end
end })
TB_Tabs.Autofarm2.T1:AddDropdown("DifficultySelected", {
    Text = "Difficulty",
    Values = GetAllDifficultyNames(),
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("QuestPriority", {
    Text = "Quest Priority",
    Values = { "Highest Grade", "Highest Payment" },
    Default = "Highest Grade",
})
Toggles.AutoQuest:OnChanged(function(state)
    Thread("AutoQuest", Func_AutoQuest, state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoHanaSimulation", { Text = "Auto Hana Simulation" })
TB_Tabs.Autofarm2.T1:AddDropdown("HanaEnemy", {
    Text = "Hana Enemy",
    Values = { "Butcher", "Maya" },
    Default = "Butcher",
})
TB_Tabs.Autofarm2.T1:AddSlider("HanaDifficulty", {
    Text = "Hana Difficulty",
    Default = 1,
    Min = 1,
    Max = 3,
    Rounding = 0,
})
Toggles.AutoHanaSimulation:OnChanged(function(state)
    Thread("AutoHanaSimulation", Func_AutoHanaSimulation, state)
end)
local CachedDash = nil
local CachedMainCombat = nil
local function GetMainCombat()
    if CachedMainCombat and CachedMainCombat.Parent then return CachedMainCombat end
    CachedMainCombat = nil
    CachedDash = nil
    local ok, mc = pcall(function()
        return workspace:WaitForChild(Plr.Name, 5):WaitForChild("MainScript", 5):WaitForChild("MainCombat", 5)
    end)
    if ok and mc then
        CachedMainCombat = mc
        mc.AncestryChanged:Connect(function()
            if not mc.Parent then
                CachedMainCombat = nil
                CachedDash = nil
            end
        end)
    end
    return CachedMainCombat
end
local function GetDashFunc()
    if CachedDash then return CachedDash end
    local mainCombat = GetMainCombat()
    if not mainCombat then
        notyuri("[Dodge] MainCombat not found")
        return
    end
    local islclosureFn = islclosure or is_l_closure or function() return true end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    if not (getgc and dbgGetUpvals) then
        notyuri("[Dodge] Missing getgc or getupvalues")
        return
    end
    local ok, gc = pcall(getgc, false)
    if not ok or not gc then
        notyuri("[Dodge] getgc failed")
        return
    end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        if not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or not env then continue end
        if rawget(env, "script") ~= mainCombat then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or not uvs or #uvs ~= 20 then continue end
        local ok5 = typeof(uvs[5]) == "Instance" and uvs[5].ClassName == "RunService"
        local ok7 = typeof(uvs[7]) == "Instance" and uvs[7].ClassName == "Player"
        if ok5 and ok7 then
            CachedDash = fn
            return fn
        end
    end
    notyuri("[Dodge] Dash not found in MainCombat env")
end
local AutoDodgeConnection = nil
local AutoDodgeEnemyConns = {}
local function WatchDodge(enemy)
    local conditionals = enemy:FindFirstChild("Conditionals")
    if not conditionals then return end
    local conn = conditionals.ChildAdded:Connect(function(child)
        if child.Name ~= "AIDodge" then return end
        notyuri("[AutoDodge] AIDodge on enemy:", enemy.Name)
        local dash = GetDashFunc()
        if dash then
            dash()
        else
            notyuri("[AutoDodge] dash not found")
        end
    end)
    AutoDodgeEnemyConns[enemy] = conn
end
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
Toggles.KillAura:OnChanged(function(state)
    Thread("KillAura", Func_DealDamage, state)
end)
local NoCooldownConn = nil
Toggles.NoCooldown:OnChanged(function(state)
    if state then
        local lp = Players.LocalPlayer
        local function connectCooldowns(char)
            if NoCooldownConn then NoCooldownConn:Disconnect() NoCooldownConn = nil end
            local cdFolder = char:FindFirstChild("Cooldowns")
            if cdFolder then
                for _, v in ipairs(cdFolder:GetChildren()) do v:Destroy() end
                NoCooldownConn = cdFolder.ChildAdded:Connect(function(v) v:Destroy() end)
            end
            char.ChildAdded:Connect(function(child)
                if not Toggles.NoCooldown.Value then return end
                if child.Name == "Cooldowns" then
                    if NoCooldownConn then NoCooldownConn:Disconnect() end
                    for _, v in ipairs(child:GetChildren()) do v:Destroy() end
                    NoCooldownConn = child.ChildAdded:Connect(function(v) v:Destroy() end)
                end
            end)
        end
        if lp.Character then connectCooldowns(lp.Character) end
        lp.CharacterAdded:Connect(function(char)
            if Toggles.NoCooldown.Value then connectCooldowns(char) end
        end)
    else
        if NoCooldownConn then
            NoCooldownConn:Disconnect()
            NoCooldownConn = nil
        end
    end
end)
Toggles.AutoFarm:OnChanged(function(state)
    Thread("AutoFarm", Func_AutoFarm, state)
end)
Toggles.AutoLoot:OnChanged(function(state)
    Thread("AutoLoot", Func_AutoLoot, state)
end)
Toggles.AutoSell:OnChanged(function(state)
    Thread("AutoSell", Func_AutoSell, state)
end)
Options.Distance:OnChanged(function()
    local n = tonumber(Options.Distance.Value)
    if n then FarmDist = n end
end)
Options.Position:OnChanged(function()
    FarmPos = Options.Position.Value
end)
for _, cfg in ipairs(ESPConfig) do
    Toggles[cfg.Id]:OnChanged(function()
        RefEsp(cfg)
        WatchEsp(cfg)
    end)
    Options[cfg.Id .. "Color"]:OnChanged(function()
        local v = Options[cfg.Id .. "Color"].Value
        for _, entry in pairs(AllHighlights[cfg.Id]) do
            if entry.highlight then entry.highlight.FillColor = v end
            if entry.billboard then
                for _, lbl in ipairs(entry.billboard:GetChildren()) do
                    if lbl:IsA("TextLabel") then lbl.TextColor3 = v end
                end
            end
        end
    end)
    Options[cfg.Id .. "Outline"]:OnChanged(function()
        local v = Options[cfg.Id .. "Outline"].Value
        for _, entry in pairs(AllHighlights[cfg.Id]) do
            if entry.highlight then entry.highlight.OutlineColor = v end
        end
    end)
end
Connections.ESPDistUpdate = RunService.Heartbeat:Connect(function()
    local myChar = GetCharacter()
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    for _, cfg in ipairs(ESPConfig) do
        local tbl = AllHighlights[cfg.Id]
        for item, entry in pairs(tbl) do
            if not cfg.IsAlive(item) then
                RemEsp(tbl, item)
                continue
            end
            if entry.billboard and entry.billboard.Adornee then
                local dist = math.floor((entry.billboard.Adornee.Position - myRoot.Position).Magnitude)
                local lbl  = entry.billboard:FindFirstChild(entry.billboard:GetAttribute("DistLabel"))
                if lbl then lbl.Text = dist .. " studs" end
            end
        end
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
    for _, cfg in ipairs(ESPConfig) do
        local tbl = AllHighlights[cfg.Id]
        for item in pairs(tbl) do RemEsp(tbl, item) end
    end
    ESPFolder:Destroy()
    Cleanup(ESPConnections)
    Cleanup(Connections)
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/Purgatorio")
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
    notyuri("ERROR: " .. tostring(err))
end