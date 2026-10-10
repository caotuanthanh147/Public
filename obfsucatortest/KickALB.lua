if getgenv().yuriStart then
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
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")
local RS = Services.ReplicatedStorage
local RunService = Services.RunService
local HttpService = Services.HttpService
local GuiService = Services.GuiService
local TeleportService = Services.TeleportService
local Marketplace = Services.MarketplaceService
local UIS = Services.UserInputService
local VirtualUser = Services.VirtualUser
local VIM = Services.VirtualInputManager
local TweenService = Services.TweenService
local v, Asset = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "kick a lucky block"
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
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().yuriStart = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true 
Library.ShowCustomCursor = true 
Library.NotifySide = "Left"
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
    end
end
local Shared     = RS:WaitForChild("Shared")
local Packages   = Shared:WaitForChild("Packages")
local Data       = Shared:WaitForChild("Data")
local Modules_RS = RS:WaitForChild("Modules")
local Services   = Modules_RS:WaitForChild("ServicesLoader")
local Controllers = Modules_RS:WaitForChild("ControllerLoader")
local Handlers   = Modules_RS:WaitForChild("HandlerLoader")
local Modules = {
    Network              = GetSafeModule(Packages, "Network"),
    WeatherData          = GetSafeModule(Data, "WeatherData"),
    WeightsData          = GetSafeModule(Data, "WeightsData"),
    RebirthData          = GetSafeModule(Data, "RebirthData"),
    KickData             = GetSafeModule(Data, "KickData"),
    SpeedData            = GetSafeModule(Data, "SpeedData"),
    EntitiesData         = GetSafeModule(Data, "EntitiesData"),
    ValidShops           = GetSafeModule(Data, "ValidShops"),
    WeightServiceClient  = GetSafeModule(Services, "WeightServiceClient"),
    RebirthServiceClient = GetSafeModule(Services, "RebirthServiceClient"),
    KickServiceClient    = GetSafeModule(Services, "KickServiceClient"),
    SpeedServiceClient   = GetSafeModule(Services, "SpeedServiceClient"),
    ClientBalanceService = GetSafeModule(Services, "ClientBalanceService"),
    ClientPlotService         = GetSafeModule(Services, "ClientPlotService"),
    BaseUpgradesServiceClient = GetSafeModule(Services, "BaseUpgradesServiceClient"),
    ShopController       = GetSafeModule(Controllers, "ShopController"),
    WeightController     = GetSafeModule(Controllers, "WeightController"),
    KickController       = GetSafeModule(Controllers, "KickController"),
    ZoneController       = GetSafeModule(Controllers, "ZoneController"),
    GameHandler          = GetSafeModule(Handlers, "GameHandler"),
}
local SharedBC = {
    BVelName = "a",
    BGName   = "b",
    BV       = nil,
    BG       = nil,
    BOrg     = {},
}
local kickMinigame = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("KickMinigame")
kickMinigame:Destroy()
local function NetFire(eventName, ...)
    if Modules.Network then
        local args = {...}
        pcall(function() Modules.Network.FireServer(eventName, table.unpack(args)) end)
    end
end
local function NetInvoke(eventName, ...)
    if Modules.Network then
        local args = {...}
        local result
        pcall(function() result = Modules.Network.InvokeServer(eventName, table.unpack(args)) end)
        return result
    end
end
local WeightOrder = {}
if Modules.WeightsData then
    local list = {}
    for name, data in pairs(Modules.WeightsData.Weights) do
        table.insert(list, { Name = name, Weight = data.Weight or 0 })
    end
    table.sort(list, function(a, b) return a.Weight < b.Weight end)
    for _, entry in ipairs(list) do
        table.insert(WeightOrder, entry.Name)
    end
end
local function SafeClick(obj, timeout)
    timeout = timeout or 8
    local deadline = tick() + timeout
    while tick() < deadline do
        if obj and obj.Parent then
            local ready = true
            if obj:IsA("GuiObject") and not obj.Visible then ready = false end
            if ready and obj:IsA("GuiButton") and not obj.Active then ready = false end
            if ready then
                local p = obj.Parent
                while p and p:IsA("GuiObject") do
                    if not p.Visible then ready = false break end
                    p = p.Parent
                end
            end
            if ready then break end
        end
        task.wait(0.05)
    end
    if tick() >= deadline then return false end
    local ok = pcall(function() GuiService.SelectedObject = obj end)
    if not ok or GuiService.SelectedObject ~= obj then return false end
    task.wait(0.08)
    VIM:SendKeyEvent(true,  Enum.KeyCode.Return, false, game)
    task.wait(0.08)
    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    task.wait(0.08)
    pcall(function() GuiService.SelectedObject = nil end)
    return true
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
            task.wait(1)
        end
    end
end
local function getChar()
    return Plr.Character
end
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
    SharedBC.BV.Name = SharedBC.BVelName
    SharedBC.BV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    SharedBC.BV.Velocity = Vector3.zero
    SharedBC.BV.Parent = hrp
    SharedBC.BG = Instance.new("BodyGyro")
    SharedBC.BG.Name = SharedBC.BGName
    SharedBC.BG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    SharedBC.BG.CFrame = hrp.CFrame
    SharedBC.BG.Parent = hrp
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
local function HybridMove(targetCF)
    local char = getChar()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local distance = (root.Position - targetCF.Position).Magnitude
    local tweenSpeed = Options.TweenSpeed and Options.TweenSpeed.Value or 180
    if distance > tonumber(Options.TargetDistTP and Options.TargetDistTP.Value or 50) then
        local oldNoclip = Toggles.Noclip and Toggles.Noclip.Value or false
        if Toggles.Noclip then Toggles.Noclip:SetValue(true) end
        local tweenTarget = targetCF * CFrame.new(0, 0, 150)
        local tweenDist = (root.Position - tweenTarget.Position).Magnitude
        local duration = tweenDist / tweenSpeed
        enableBodyControl(root)
        local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            CFrame = tweenTarget
        })
        tween:Play()
        tween.Completed:Wait()
        disableBodyControl(root)
        if Toggles.Noclip then Toggles.Noclip:SetValue(oldNoclip) end
        task.wait(0.1)
    end
    root.CFrame = targetCF
    root.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
    task.wait(0.2)
end
local function TeleportNear(targetPart, radius)
    radius = radius or 6
    local char = getChar()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not targetPart then return end
    local targetPos
    if typeof(targetPart) == "Instance" then
        if targetPart:IsA("BasePart") then
            targetPos = targetPart.Position
        else
            local ok, pv = pcall(function() return targetPart:GetPivot().Position end)
            targetPos = ok and pv or nil
        end
    elseif typeof(targetPart) == "Vector3" then
        targetPos = targetPart
    end
    if not targetPos then return end
    local dist = (root.Position - targetPos).Magnitude
    if dist <= radius then
        return
    end
    local offset = Vector3.new(radius * 0.5, 0, radius * 0.5)
    root.CFrame = CFrame.new(targetPos + offset)
    root.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
    task.wait(0.15)
end
local MoveMutex = {
    _holder   = nil,
    _priority = 99,
}
function MoveMutex:Acquire(name, priority)
    while self._holder ~= nil and self._holder ~= name do
        if priority < self._priority then
            break
        end
        task.wait(0.05)
    end
    self._holder   = name
    self._priority = priority
end
function MoveMutex:Release(name)
    if self._holder == name then
        self._holder   = nil
        self._priority = 99
    end
end
local function TweenToKickReady()
    local char = getChar()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local KickReady = workspace:FindFirstChild("Areas") and workspace.Areas:FindFirstChild("KickReady")
    if not KickReady then return end
    if Modules.ZoneController and Modules.ZoneController.Zone == "KickReady" then return end
    root.CFrame = KickReady.CFrame
    root.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
    task.wait(0.2)
end
local EquipMutex = {
    _holder   = nil,
    _priority = nil,
}
function EquipMutex:Lock(name, priority)
    while self._holder ~= nil and self._holder ~= name do
        task.wait(0.05)
    end
    self._holder = name
    self._priority = priority
end
function EquipMutex:Unlock(name)
    if self._holder == name then
        self._holder = nil
        self._priority = nil
    end
end
function EquipMutex:IsHeldBy(name)
    return self._holder == name
end
local function DoAutoPopUp()
    local KickUpgrades = PGui:FindFirstChild("KickUpgrades") or PGui:WaitForChild("KickUpgrades", 10)
    if not KickUpgrades then return end
    while true do
        for _, child in ipairs(KickUpgrades:GetChildren()) do
            if child:IsA("ImageButton") then
                task.spawn(SafeClick, child)
            end
        end
        local backpack = Plr:FindFirstChild("Backpack")
        local weightsData = Modules.WeightsData and Modules.WeightsData.Weights
        if backpack and weightsData then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and weightsData[tool.Name] then
                    local hum = getChar() and getChar():FindFirstChildOfClass("Humanoid")
                    if hum then
                        EquipMutex:Lock("weight", 1)
                        hum:EquipTool(tool)
                        task.wait(0.3)
                        EquipMutex:Unlock("weight")
                    end
                    break
                end
            end
        end
        task.wait(0.1)
    end
end
local function DoAutoKick()
    if not Modules.KickController then return end
    local HUD = PGui:FindFirstChild("HUD") or PGui:WaitForChild("HUD", 10)
    if not HUD then return end
    local KickButton = HUD:WaitForChild("KickButton", 10)
    if not KickButton then return end
    while true do
        local gh = Modules.GameHandler
        if gh and not gh.InGame then
            if Modules.ZoneController and Modules.ZoneController.Zone ~= "KickReady" then
                TweenToKickReady()
            end
        end
        if KickButton.Visible and not Plr:GetAttribute("KickDebounced") then
            local clicked = SafeClick(KickButton)
            if clicked then
                task.wait(0.1)
                NetFire("KickEvent", 1)
                task.wait()
            end
        end
        task.wait(0.1)
    end
end
local function DoTsunamiRun()
    local char = getChar()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local CollectZone = workspace:FindFirstChild("Zones") and workspace.Zones:FindFirstChild("CollectZone")
    if not CollectZone then return end
    local dist = (root.Position - CollectZone.Position).Magnitude
    local hum = char:FindFirstChild("Humanoid")
    local speed = (hum and hum.WalkSpeed > 0) and hum.WalkSpeed or 16
    local duration = math.max(0.5, dist / speed)
    enableBodyControl(root)
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        CFrame = CollectZone.CFrame
    })
    tween:Play()
    tween.Completed:Wait()
    disableBodyControl(root)
end
if Modules.GameHandler then
    Modules.GameHandler.StatusChanged:Connect(function()
        local status = Modules.GameHandler.Status
        if status == "Tsunami" and Toggles.AutoKick.Value then
            task.spawn(DoTsunamiRun)
        end
    end)
end
local function DoAutoClaim()
    NetFire("ClaimFree")
    NetFire("GroupClaim")
    while true do
        NetFire("Offline_Claim")
        local Char2 = Plr.Character
        if Char2 then
            local CollectZone = workspace:FindFirstChild("Zones") and workspace.Zones:FindFirstChild("CollectZone")
            if CollectZone then
                local op = OverlapParams.new()
                op.FilterDescendantsInstances = { Char2 }
                op.FilterType = Enum.RaycastFilterType.Include
                if #workspace:GetPartsInPart(CollectZone, op) > 0 then
                    NetFire("KickCollect")
                end
            end
        end
        task.wait(0.3)
    end
end
local function DoAutoCollectBrainrot()
    while true do
        local char = getChar()
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not root then
            task.wait(1)
            continue
        end
        if not firetouchinterest then
            task.wait(1)
            continue
        end
        if not Modules.ClientPlotService then
            task.wait(1)
            continue
        end
        local Plot = Modules.ClientPlotService.Model
        if not Plot then
            task.wait(1)
            continue
        end
        local Buttons = Plot:FindFirstChild("Buttons")
        if not Buttons then
            task.wait(1)
            continue
        end
        local buttonList = Buttons:GetChildren()
        local fired = 0
        for _, button in ipairs(buttonList) do
            if button:IsA("BasePart") then
                if MoveMutex._holder == nil then
                    TeleportNear(button, 6)
                end
                local ok = pcall(function()
                    firetouchinterest(button, root, 1)
                    task.wait()
                    firetouchinterest(button, root, 0)
                end)
                if ok then
                    fired += 1
                end
                task.wait(0.1)
            end
        end
        task.wait(0.5)
    end
end
local BrainrotOrder = {}
if Modules.EntitiesData and Modules.EntitiesData.Brainrots then
    local list = {}
    for name, data in pairs(Modules.EntitiesData.Brainrots) do
        if data.CPS then
            table.insert(list, { Name = name, CPS = data.CPS })
        end
    end
    table.sort(list, function(a, b) return a.CPS > b.CPS end)
    for _, entry in ipairs(list) do
        table.insert(BrainrotOrder, entry.Name)
    end
end
local function GetSlotPlacedID(slot)
    for _, child in ipairs(slot:GetChildren()) do
        if child:IsA("BasePart") then
            local id = child:GetAttribute("ID")
            if id then return id end
        end
    end
    return nil
end
local function DoAutoPlaceBrainrot()
    local BrainrotRank = {}
    for i, name in ipairs(BrainrotOrder) do
        BrainrotRank[name] = i
    end
    while true do
        local char = getChar()
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not char or not root or not hum then
            task.wait(1)
            continue
        end
        if not fireproximityprompt or not Modules.ClientPlotService then
            task.wait(1)
            continue
        end
        local Plot = Modules.ClientPlotService.Model
        if not Plot then
            task.wait(1)
            continue
        end
        local Slots = Plot:FindFirstChild("Slots")
        if not Slots then
            task.wait(1)
            continue
        end
        local allSlots = Slots:GetChildren()
        if #allSlots == 0 then
            task.wait(1)
            continue
        end
        local bestOwned = nil
        for _, brainrotName in ipairs(BrainrotOrder) do
            local t = Plr.Backpack:FindFirstChild(brainrotName)
                or (char:FindFirstChildOfClass("Tool")
                    and char:FindFirstChildOfClass("Tool").Name == brainrotName
                    and char:FindFirstChildOfClass("Tool"))
            if t then
                bestOwned = brainrotName
                break
            end
        end
        if not bestOwned then
            task.wait(2)
            continue
        end
        local bestOwnedRank = BrainrotRank[bestOwned]
        local slotsNeedingPlace = 0
        for _, slot in ipairs(allSlots) do
            local placedID = GetSlotPlacedID(slot)
            local placedRank = placedID and BrainrotRank[placedID] or math.huge
            if placedRank > bestOwnedRank then
                slotsNeedingPlace += 1
            end
        end
        if slotsNeedingPlace == 0 then
            task.wait(1)
            continue
        end
        EquipMutex:Lock("brainrot", 2)
        for _, slot in ipairs(allSlots) do
            local placedRank = placedID and BrainrotRank[placedID] or math.huge
            if placedRank > bestOwnedRank then
                local attachment = slot:FindFirstChild("Attachment")
                local prompt = attachment and attachment:FindFirstChild("CustomPrompt")
                if not attachment or not prompt then
                    continue
                end
                local toolToEquip = nil
                for _, brainrotName in ipairs(BrainrotOrder) do
                    local t = Plr.Backpack:FindFirstChild(brainrotName)
                        or (char:FindFirstChildOfClass("Tool")
                            and char:FindFirstChildOfClass("Tool").Name == brainrotName
                            and char:FindFirstChildOfClass("Tool"))
                    if t then
                        toolToEquip = t
                        break
                    end
                end
                if not toolToEquip then
                    break
                end
                local toolRank = BrainrotRank[toolToEquip.Name] or math.huge
                if toolRank >= placedRank then
                    continue
                end
                if toolToEquip.Parent ~= char then
                    hum:EquipTool(toolToEquip)
                    task.wait(0.2)
                end
                root.CFrame = CFrame.new(slot:IsA("BasePart") and slot.Position or slot:GetPivot().Position)
                root.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
                task.wait(0.1)
                fireproximityprompt(prompt)
                task.wait(0.3)
            end
        end
        hum:UnequipTools()
        EquipMutex:Unlock("brainrot")
        task.wait(1)
    end
end
local function DoAutoUpgradeBrainrot()
    local function getUpgradeableSlotsSorted(Slots, ed, userMaxLevel)
        local results = {}
        for _, slot in ipairs(Slots:GetChildren()) do
            local slotNum = tonumber((slot.Name:gsub("Slot", "")))
            if not slotNum then continue end
            local placedPart = slot:FindFirstChild("PlacedPart")
            if not placedPart then continue end
            local id = placedPart:GetAttribute("ID")
            if not id then continue end
            local level = placedPart:GetAttribute("Level") or 1
            local hardMax = ed and ed.MAX_LEVEL or 75
            local capLevel = math.min(userMaxLevel, hardMax)
            if level >= capLevel then continue end
            local mutation = placedPart:GetAttribute("Mutation")
            local cost = ed and ed.GetCostForUpgrade and ed.GetCostForUpgrade(id, level, mutation)
            if not cost then continue end
            table.insert(results, { slotNum = slotNum, slotPart = slot, cost = cost })
        end
        table.sort(results, function(a, b) return a.slotNum < b.slotNum end)
        return results
    end
    while true do
        local Plot = Modules.ClientPlotService and Modules.ClientPlotService.Model
        if not Plot then task.wait(1) continue end
        local Slots = Plot:FindFirstChild("Slots")
        if not Slots then task.wait(1) continue end
        local ed = Modules.EntitiesData
        local userMaxLevel = tonumber(Options.UpgradeMaxLevel and Options.UpgradeMaxLevel.Value) or 75
        print("[AutoUpgrade] Max level cap:", userMaxLevel)
        local upgradeableSlots = getUpgradeableSlotsSorted(Slots, ed, userMaxLevel)
        if #upgradeableSlots == 0 then
            task.wait(1)
            continue
        end
        local target = upgradeableSlots[1]
        local targetSlotNum = target.slotNum
        local targetSlotPart = target.slotPart
        local targetCost = target.cost
        MoveMutex:Acquire("upgrade", 1)
        TeleportNear(targetSlotPart, 6)
        while true do
            local userMaxLevel = tonumber(Options.UpgradeMaxLevel and Options.UpgradeMaxLevel.Value) or 75
            local placedPart = targetSlotPart:FindFirstChild("PlacedPart")
            if not placedPart then
                break
            end
            local currentLevel = placedPart:GetAttribute("Level") or 1
            local hardMax = ed and ed.MAX_LEVEL or 75
            local capLevel = math.min(userMaxLevel, hardMax)
            if currentLevel >= capLevel then
                break
            end
            local balance = Modules.ClientBalanceService and Modules.ClientBalanceService.Balance
            if balance and targetCost > balance then
                task.wait(0.3)
                local id = placedPart:GetAttribute("ID")
                local mutation = placedPart:GetAttribute("Mutation")
                local newCost = ed and ed.GetCostForUpgrade and ed.GetCostForUpgrade(id, currentLevel, mutation)
                if newCost then targetCost = newCost end
                continue
            end
            NetFire("B_Upgrade", targetSlotNum)
            task.wait(0.1)
            local newLevel = placedPart:GetAttribute("Level") or 1
            local id2 = placedPart:GetAttribute("ID")
            local mutation2 = placedPart:GetAttribute("Mutation")
            local newCost = ed and ed.GetCostForUpgrade and ed.GetCostForUpgrade(id2, newLevel, mutation2)
            if newCost then
                targetCost = newCost
            end
        end
        MoveMutex:Release("upgrade")
        task.wait(0.1)
    end
end
local function DoAutoRebirth()
    while true do
        NetFire("RebirthRequest")
        task.wait(2)
    end
end
local function DoAutoWeight()
    while true do
        local owned = (Modules.WeightServiceClient and Modules.WeightServiceClient.Owned) or {}
        local bestOwned = nil
        for i = #WeightOrder, 1, -1 do
            if table.find(owned, WeightOrder[i]) then
                bestOwned = WeightOrder[i]
                break
            end
        end
        local targetWeight = nil
        for _, weightName in ipairs(WeightOrder) do
            if not table.find(owned, weightName) then
                targetWeight = weightName
                break
            end
        end
        if targetWeight then
            NetFire("Shop_Buy", "WeightShop", targetWeight)
            task.wait(0.3)
        end
        if bestOwned then
            NetFire("WeightEquip", bestOwned)
        elseif targetWeight then
            NetFire("WeightEquip", targetWeight)
        end
        task.wait(0.3)
    end
end
local function DoAutoUpgradeSlot()
    while true do
        local buc = Modules.BaseUpgradesServiceClient
        if buc and buc.AddedSlots < buc.MAX_SLOTS then
            NetFire("bs_upgrade")
        end
        task.wait(0.3)
    end
end
local function DoAutoUpgradeSpeed()
    while true do
        NetFire("SPEED_UPGRADE", 1)
        task.wait(0.3)
    end
end
local ValidEvents = (Modules.WeatherData and Modules.WeatherData.ValidEvents) or {}
local autoKickOnEventConns = {}
local pausedByEvent = {} 
local OtherAutoToggles = {
    "AutoPopUp",
    "AutoClaim",
    "AutoCollectBrainrot",
    "AutoPlaceBrainrot",
    "AutoRebirth",
    "AutoWeight",
    "AutoUpgradeBrainrot",
    "AutoUpgradeSlot",
    "AutoUpgradeSpeed",
}
local function PauseForKick()
    if next(pausedByEvent) ~= nil then
        return
    end
    for _, key in ipairs(OtherAutoToggles) do
        if Toggles[key] and Toggles[key].Value then
            pausedByEvent[key] = true
            Toggles[key]:SetValue(false)
        end
    end
    if not Toggles.AutoKick.Value then
        Toggles.AutoKick:SetValue(true)
    end
end
local function RestoreAfterKick()
    if Toggles.AutoKick.Value then
        Toggles.AutoKick:SetValue(false)
    end
    for _, key in ipairs(OtherAutoToggles) do
        if pausedByEvent[key] and Toggles[key] then
            Toggles[key]:SetValue(true)
        end
    end
    pausedByEvent = {}
end
local function SetupAutoKickOnEvent()
    for _, conn in ipairs(autoKickOnEventConns) do
        conn:Disconnect()
    end
    autoKickOnEventConns = {}
    if not Toggles.AutoKickOnEvent.Value then
        RestoreAfterKick()
        return
    end
    local wsc = Modules.WeatherService_Client
    if not wsc then
        local ok, m = pcall(function()
            return require(RS:WaitForChild("Modules")
                :WaitForChild("ServicesLoader")
                :WaitForChild("WeatherService_Client"))
        end)
        if ok and m then wsc = m end
    end
    if not wsc then
        return
    end
    table.insert(autoKickOnEventConns, wsc.WeatherAdded:Connect(function(eventName, _endTime)
        local selected = Options.SelectedWeathers.Value
        if selected[eventName] then
            PauseForKick()
        end
    end))
    table.insert(autoKickOnEventConns, wsc.WeatherRemoved:Connect(function(eventName)
        local selected = Options.SelectedWeathers.Value
        if selected[eventName] then
            RestoreAfterKick()
        end
    end))
    local selected = Options.SelectedWeathers.Value
    if wsc.Events then
        for eventName, endTime in pairs(wsc.Events) do
            if selected[eventName] then
                PauseForKick()
                break 
            end
        end
    end
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
    Config = Window:AddTab("Config"),
}
local Main = Tabs.Main:AddLeftGroupbox("Main Features")
local Settings = Tabs.Main:AddRightGroupbox("Weather Settings")
Main:AddToggle("AutoPopUp", {
    Text    = "Auto Pop Up",
    Default = false,
})
Toggles.AutoPopUp:OnChanged(function(state)
    Thread("AutoPopUp", SafeLoop("AutoPopUp", DoAutoPopUp), state)
end)
Main:AddToggle("AutoKick", {
    Text    = "Auto Perfect Kick",
    Default = false,
})
Toggles.AutoKick:OnChanged(function(state)
    Thread("AutoKick", SafeLoop("AutoKick", DoAutoKick), state)
end)
Main:AddToggle("AutoClaim", {
    Text    = "Auto Claim",
    Default = false,
})
Toggles.AutoClaim:OnChanged(function(state)
    Thread("AutoClaim", SafeLoop("AutoClaim", DoAutoClaim), state)
end)
Main:AddToggle("AutoCollectBrainrot", {
    Text    = "Auto Collect Money",
    Default = false,
})
Toggles.AutoCollectBrainrot:OnChanged(function(state)
    Thread("AutoCollectBrainrot", SafeLoop("AutoCollectBrainrot", DoAutoCollectBrainrot), state)
end)
Main:AddToggle("AutoPlaceBrainrot", {
    Text    = "Auto Place Best Brainrot",
    Default = false,
})
Toggles.AutoPlaceBrainrot:OnChanged(function(state)
    Thread("AutoPlaceBrainrot", SafeLoop("AutoPlaceBrainrot", DoAutoPlaceBrainrot), state)
end)
Main:AddToggle("AutoRebirth", {
    Text    = "Auto Rebirth",
    Default = false,
})
Toggles.AutoRebirth:OnChanged(function(state)
    Thread("AutoRebirth", SafeLoop("AutoRebirth", DoAutoRebirth), state)
end)
Main:AddToggle("AutoWeight", {
    Text    = "Auto Buy Weight",
    Default = false,
})
Toggles.AutoWeight:OnChanged(function(state)
    Thread("AutoWeight", SafeLoop("AutoWeight", DoAutoWeight), state)
end)
Main:AddToggle("AutoUpgradeBrainrot", {
    Text    = "Auto Upgrade Brainrot",
    Default = false,
})
Toggles.AutoUpgradeBrainrot:OnChanged(function(state)
    Thread("AutoUpgradeBrainrot", SafeLoop("AutoUpgradeBrainrot", DoAutoUpgradeBrainrot), state)
end)
Main:AddToggle("AutoUpgradeSlot", {
    Text    = "Auto Upgrade Slot",
    Default = false,
})
Toggles.AutoUpgradeSlot:OnChanged(function(state)
    Thread("AutoUpgradeSlot", SafeLoop("AutoUpgradeSlot", DoAutoUpgradeSlot), state)
end)
Main:AddToggle("AutoUpgradeSpeed", {
    Text    = "Auto Upgrade Speed",
    Default = false,
})
Toggles.AutoUpgradeSpeed:OnChanged(function(state)
    Thread("AutoUpgradeSpeed", SafeLoop("AutoUpgradeSpeed", DoAutoUpgradeSpeed), state)
end)
Settings:AddDropdown("SelectedWeathers", {
    Text    = "Select Weather(s)",
    Values  = ValidEvents,
    AllowNull = true,
    Searchable = true,
    Multi   = true,
})
Settings:AddToggle("AutoKickOnEvent", {
    Text    = "Auto Kick on Weather",
    Default = false,
})
Toggles.AutoKickOnEvent:OnChanged(function(state)
    SetupAutoKickOnEvent()
end)
Options.SelectedWeathers:OnChanged(function()
    if Toggles.AutoKickOnEvent.Value then
        SetupAutoKickOnEvent()
    end
end)
Settings:AddDivider()
Settings:AddInput("UpgradeMaxLevel", {
    Text        = "Upgrade Max Level",
    Numeric     = true,
    Finished    = false,
    AllowNull = true,
})
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
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI    = true,
    Text    = "Menu keybind",
})
MenuGroup:AddButton({
    Text = "Unload",
    Func = function()
        getgenv().yuriStart = false
        Library:Unload()
    end,
})
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("kick-alb")
SaveManager:SetFolder("kick-alb/configs")
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
