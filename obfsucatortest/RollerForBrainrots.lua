if getgenv().ayasemiyatongekissazumirisa then
    warn("watch more yuri")
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
local Players = Services.Players
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local PGui = Plr:WaitForChild("PlayerGui")
local Lighting = game:GetService('Lighting');
local RS = Services.ReplicatedStorage
local CollectionService = Services.CollectionService
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
local assetName = "sailor piece"
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
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
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
local Tabs = {
	Main = Window:AddTab("Main"),
    Config = Window:AddTab("Config"),
}
local Yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
}
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
        warn("Your executor does not support firesignal or getconnections.")
    end
end
local _FS = (_DR and _DR.FireServer)
local Remotes = {
}
local Modules = {
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
local Flags = {}
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
local BrainrotsConfig = nil
pcall(function()
    BrainrotsConfig = require(RS:WaitForChild("Shared"):WaitForChild("Configs"):WaitForChild("BrainrotsConfig"))
end)
local function AB_getCPS(name)
    if BrainrotsConfig and BrainrotsConfig.Brainrots and BrainrotsConfig.Brainrots[name] then
        return BrainrotsConfig.Brainrots[name].CashPerSecond or 0
    end
    return 0
end
local function AB_getHRP()
    local c = Plr.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function AB_tpTo(cf)
    local hrp = AB_getHRP()
    if hrp then hrp.CFrame = cf end
end
local function AB_isCarrying()
    return Plr:GetAttribute("Carrying") == true
end
local function AB_hasBrainrotTool()
    local char = Plr.Character
    if char then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Tool") and v:GetAttribute("BrainrotTool") then
                return true
            end
        end
    end
    local bp = Plr:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") and v:GetAttribute("BrainrotTool") then
                return true
            end
        end
    end
    return false
end
local function AB_getMyPlot()
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return nil end
    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:GetAttribute("OccupiedByUserId") == Plr.UserId then
            return plot
        end
    end
    return nil
end
local function AB_findBestBrainrot()
    local SpawnedBrainrots = workspace:FindFirstChild("SpawnedBrainrots")
    if not SpawnedBrainrots then return nil end
    local bestCPS, bestModel = -1, nil
    for _, obj in ipairs(SpawnedBrainrots:GetDescendants()) do
        if obj:IsA("Model") then
            local cps = AB_getCPS(obj.Name)
            if cps > bestCPS then
                bestCPS   = cps
                bestModel = obj
            end
        end
    end
    if not bestModel then return nil end
    return { model = bestModel, name = bestModel.Name, cps = bestCPS }
end
local function AB_findPickupPromptInModel(model)
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
            local pp = part:FindFirstChildOfClass("ProximityPrompt")
            if pp then return pp end
        end
    end
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then return desc end
    end
    return nil
end
local function AB_findEmptySlotPrompt(plot)
    for _, pp in ipairs(CollectionService:GetTagged("SlotPlacePrompt")) do
        if pp:IsA("ProximityPrompt") then
            local ancestor = pp.Parent
            while ancestor do
                if ancestor == plot then
                    return pp, pp.Parent
                end
                ancestor = ancestor.Parent
            end
        end
    end
    for _, desc in ipairs(plot:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc:FindFirstAncestor("FreeBrainrot") then
            return desc, desc.Parent
        end
    end
    return nil, nil
end
local function AB_getCFofInstance(inst)
    if inst:IsA("BasePart") then
        return inst.CFrame
    end
    local ok, cf = pcall(function() return inst:GetPivot() end)
    if ok then return cf end
    return nil
end
local function Func_AutoBestBrainrot()
    while Toggles.AutoBestBrainrot.Value do
        local hrp = AB_getHRP()
        if not hrp then task.wait(1); continue end
        local isCarrying   = AB_isCarrying()
        local hasTool      = AB_hasBrainrotTool()
        if isCarrying then
            local plot = AB_getMyPlot()
            if not plot then
                warn("[AB] No plot found while Carrying — waiting")
                task.wait(1); continue
            end
            local plotCF = AB_getCFofInstance(plot)
            if plotCF then
                AB_tpTo(plotCF * CFrame.new(0, 5, 0))
            end
            local t0 = tick()
            repeat task.wait(0.1) until not AB_isCarrying() or (tick() - t0) > 8
            task.wait(0.2)
            continue
        end
        if hasTool then
            local plot = AB_getMyPlot()
            if not plot then
                warn("[AB] No plot found while holding tool — waiting")
                task.wait(1); continue
            end
            local pp, slotObj = AB_findEmptySlotPrompt(plot)
            if not pp then
                warn("[AB] No empty slot prompt — plot may be full, waiting")
                task.wait(2); continue
            end
            local slotCF = slotObj and AB_getCFofInstance(slotObj)
            if slotCF then
                AB_tpTo(slotCF * CFrame.new(0, 3, 0))
            end
            task.wait(0.3)
            pp.Enabled = true
            fireproximityprompt(pp)
            local t0 = tick()
            repeat task.wait(0.1) until not AB_hasBrainrotTool() or (tick() - t0) > 5
            task.wait(0.5)
            continue
        end
        local entry = AB_findBestBrainrot()
        if not entry then
            task.wait(1); continue
        end
        local model = entry.model
        AB_tpTo(model:GetPivot() * CFrame.new(0, 3, 0))
        task.wait(0.3)
        local pp = AB_findPickupPromptInModel(model)
        if pp then
            fireproximityprompt(pp)
            local t0 = tick()
            repeat task.wait(0.1) until AB_isCarrying() or AB_hasBrainrotTool() or (tick() - t0) > 5
        else
            warn("[AB] No pickup prompt found in model:", model.Name)
        end
        task.wait(0.5)
    end
end
local NetRE_Root = RS:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")
local function NetFireRE(eventName, ...)
    local args = {...}
    local ok, err = pcall(function()
        NetRE_Root:WaitForChild("RE/" .. eventName):FireServer(table.unpack(args))
    end)
    if not ok then
        warn("[NetFireRE] Failed to fire RE/" .. eventName .. ":", err)
    end
end
local function Func_AutoUpgradeBrainrot()
    local MAX_HARD = 500
    while Toggles.AutoUpgradeBrainrot.Value do
        local plot = AB_getMyPlot()
        if not plot then task.wait(0.1); continue end
        local Slots = plot:FindFirstChild("Slots")
        if not Slots then task.wait(0.1); continue end
        local userMax = tonumber(Options.UpgradeMaxLevel and Options.UpgradeMaxLevel.Value) or MAX_HARD
        local capLevel = math.min(userMax, MAX_HARD)
        local fired = false
        for _, floor in ipairs(Slots:GetChildren()) do
            for _, slot in ipairs(floor:GetChildren()) do
                if not slot:IsA("BasePart") then continue end
                local upgradeButton = slot:FindFirstChild("UpgradeButton")
                local gui = upgradeButton and upgradeButton:FindFirstChild("BrainrotUpgradeGui")
                local btn = gui and gui:FindFirstChild("BrainrotUpgradeButton")
                local label = btn and btn:FindFirstChild("CurrentLevelLabel")
                if not label then continue end
                local level = tonumber(label.Text:match("%d+"))
                if not level then continue end
                if level >= capLevel then
                    continue
                end
                NetFireRE("UpgradeBrainrot", slot)
                fired = true
                task.wait(0.1)
            end
        end
        if not fired then
        end
        task.wait()
    end
end
local function Func_AutoUpgradeBase()
    while Toggles.AutoUpgradeBase.Value do
        local plot = AB_getMyPlot()
        if not plot then task.wait(1); continue end
        NetFireRE("UpgradeBase", plot)
        task.wait(0.5)
    end
end
-- Auto Buy Upgrades: Boost, Carry, Speed all in one toggle
local function Func_AutoBuyUpgrades()
    print("[ABU] Loop started")
    while Toggles.AutoBuyUpgrades.Value do
        print("[ABU] Firing: Boost, Carry, Speed")
        NetFireRE("BuyUpgrade", "Boost", 1)
        NetFireRE("BuyUpgrade", "Carry", 1)
        NetFireRE("BuyUpgrade", "Speed", 1)
        task.wait(0.1)
    end
end
local function Func_AutoBuyBestRoller()
    local RollersConfig = nil
    pcall(function()
        RollersConfig = require(RS:WaitForChild("Shared"):WaitForChild("Configs"):WaitForChild("RollersConfig"))
    end)
    while Toggles.AutoBuyBestRoller.Value do
        local owned = {}
        local ownedStr = Plr:GetAttribute("OwnedRollers") or ""
        for r in ownedStr:gmatch("[^,]+") do owned[r] = true end
        local equipped = Plr:GetAttribute("EquippedRoller") or "DefaultRollers"
        local rollerOrder = {}
        if RollersConfig and RollersConfig.Rollers then
            local list = {}
            for name, data in pairs(RollersConfig.Rollers) do
                table.insert(list, { Name = name, Speed = data.Speed or 0 })
            end
            table.sort(list, function(a, b) return a.Speed > b.Speed end)
            for _, e in ipairs(list) do table.insert(rollerOrder, e.Name) end
        else
            rollerOrder = { "GoldRollers", "SilverRollers", "DefaultRollers" }
        end
        local bestUnowned = nil
        local bestOwned = nil
        for _, name in ipairs(rollerOrder) do
            if owned[name] then
                if not bestOwned then bestOwned = name end
            else
                if not bestUnowned then bestUnowned = name end
            end
        end
        if bestUnowned then
            NetFireRE("BuyRoller", bestUnowned)
            task.wait(0.3)
        end
        local toEquip = bestOwned or bestUnowned
        if toEquip and toEquip ~= equipped then
            NetFireRE("EquipRoller", toEquip)
        end
        task.wait(1)
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        local rebirths = Plr:GetAttribute("Rebirths") or 0
        NetFireRE("RequestRebirth")
        task.wait(2)
    end
end
local function Func_AutoCollectMoney()
    while Toggles.AutoCollectMoney.Value do
        local hrp = AB_getHRP()
        if not hrp then task.wait(1); continue end
        if not firetouchinterest then
            warn("[ACM] firetouchinterest not available on this executor")
            task.wait(1); continue
        end
        local plot = AB_getMyPlot()
        if not plot then task.wait(1); continue end
        local Slots = plot:FindFirstChild("Slots")
        if not Slots then task.wait(1); continue end
        local fired = 0
        for _, floor in ipairs(Slots:GetChildren()) do
            for _, slot in ipairs(floor:GetChildren()) do
                local cashButton = slot:FindFirstChild("CashButton")
                if cashButton then
                    local floor_part = cashButton:FindFirstChild("CashButtonFloor")
                    if floor_part and floor_part:IsA("BasePart") then
                        pcall(function()
                            firetouchinterest(floor_part, hrp, 0) 
                            task.wait()
                            firetouchinterest(floor_part, hrp, 1) 
                        end)
                        fired = fired + 1
                    end
                end
            end
        end
        task.wait(0.5)
    end
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
local function DisableIdled()
    pcall(function()
        local cons = getconnections or get_signal_cons
        if cons then
            for _, v in pairs(cons(Plr.Idled)) do
                if v.Disable then v:Disable()
                elseif v.Disconnect then v:Disconnect() end
            end
        end
    end)
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
local BrainrotGroup = Tabs.Main:AddLeftGroupbox("Main Features")
BrainrotGroup:AddToggle("AutoBestBrainrot", {
    Text    = "Auto Best Brainrot",
    Default = false,
    Callback = function(state)
        Thread("AutoBestBrainrot", Func_AutoBestBrainrot, state)
    end
})
BrainrotGroup:AddToggle("AutoCollectMoney", {
    Text    = "Auto Collect Money",
    Default = false,
    Callback = function(state)
        Thread("AutoCollectMoney", Func_AutoCollectMoney, state)
    end
})
BrainrotGroup:AddToggle("AutoUpgradeBrainrot", {
    Text    = "Auto Upgrade Brainrot",
    Default = false,
    Callback = function(state)
        Thread("AutoUpgradeBrainrot", Func_AutoUpgradeBrainrot, state)
    end
})
BrainrotGroup:AddInput("UpgradeMaxLevel", {
    Text     = "Max Upgrade Level",
    AllowNull = true,
})
BrainrotGroup:AddToggle("AutoUpgradeBase", {
    Text    = "Auto Upgrade Base",
    Default = false,
    Callback = function(state)
        Thread("AutoUpgradeBase", Func_AutoUpgradeBase, state)
    end
})
BrainrotGroup:AddToggle("AutoBuyUpgrades", {
    Text    = "Auto Buy All Upgrades",
    Default = false,
    Callback = function(state)
        print("[ABU] Toggle:", state)
        Thread("AutoBuyUpgrades", Func_AutoBuyUpgrades, state)
    end
})
BrainrotGroup:AddToggle("AutoBuyBestRoller", {
    Text    = "Auto Buy Best Roller",
    Default = false,
    Callback = function(state)
        Thread("AutoBuyBestRoller", Func_AutoBuyBestRoller, state)
    end
})
BrainrotGroup:AddToggle("AutoRebirth", {
    Text    = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        Thread("AutoRebirth", Func_AutoRebirth, state)
    end
})
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
SaveManager:SetIgnoreIndexes({ "SelectedIsland" })
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/Roller")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
Library:Notify("Script loaded.", 2)
Library:Notify("Report bug and give suggestion in Discord!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
end