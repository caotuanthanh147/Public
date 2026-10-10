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
local SharedFolder = RS:FindFirstChild("Shared") or RS:WaitForChild("Shared", 10)
local RemotesFolder = RS:WaitForChild("Remotes", 10)
notyuri("[Remotes] folder:", RemotesFolder and "found" or "MISSING")
local function NetFire(category, remoteName, ...)
    if not RemotesFolder then return end
    local remote = RemotesFolder:FindFirstChild(remoteName)
    if not remote then notyuri("[NetFire] missing remote:", remoteName) return end
    local args = { ... }
    pcall(function() remote:FireServer(table.unpack(args)) end)
end
local function NetInvoke(category, remoteName, ...)
    if not RemotesFolder then return nil end
    local remote = RemotesFolder:FindFirstChild(remoteName)
    if not remote then notyuri("[NetInvoke] missing remote:", remoteName) return nil end
    local args = { ... }
    local result = nil
    local done = false
    task.spawn(function()
        local ok, res = pcall(function() return remote:InvokeServer(table.unpack(args)) end)
        result = ok and res or nil
        done = true
    end)
    local start = tick()
    while not done and (tick() - start) < 5 do task.wait() end
    return result
end
local function GetGameConfig()
    if SharedFolder then
        local cfgFolder = SharedFolder:FindFirstChild("Config")
        if cfgFolder then
            local ok, cfg = pcall(function() return require(cfgFolder:WaitForChild("GameConfig", 5)) end)
            if ok then return cfg end
        end
    end
    return nil
end
local function GetCash()
    local ls = Plr:FindFirstChild("leaderstats")
    local cash = ls and ls:FindFirstChild("Cash")
    return cash and cash.Value or 0
end
local function GetSquishies()
    local ls = Plr:FindFirstChild("leaderstats")
    local sq = ls and ls:FindFirstChild("Squishies")
    return sq and sq.Value or 0
end
local function FindFloorSquishies(maxDist)
    local list = {}
    local floor = workspace:FindFirstChild("Floor")
    if not floor then return list end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    for _, child in ipairs(floor:GetChildren()) do
        if child:IsA("BasePart") and child:GetAttribute("SquishyId") and child.CanQuery == true then
            if not maxDist or not hrp then
                table.insert(list, child)
            else
                local dist = (child.Position - hrp.Position).Magnitude
                if dist <= maxDist then
                    table.insert(list, child)
                end
            end
        end
    end
    if hrp then
        table.sort(list, function(a, b) return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude end)
    end
    return list
end
local function FindPositions(squishyType)
    local list = {}
    local positions = workspace:FindFirstChild("Positions")
    if not positions then return list end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    for _, part in ipairs(positions:GetChildren()) do
        if part:IsA("BasePart") and part.Name == squishyType and part.CanQuery then
            table.insert(list, part)
        end
    end
    if hrp then
        table.sort(list, function(a, b)
            return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
        end)
    end
    return list
end
local InventoryController = nil
local function GetInventoryController()
    if InventoryController then return InventoryController end
    local ok, ctrl = pcall(function()
        return require(Plr:WaitForChild("PlayerScripts", 5):WaitForChild("Client", 5):WaitForChild("Input", 5):WaitForChild("InventoryController", 5))
    end)
    if ok and type(ctrl) == "table" then
        InventoryController = ctrl
        notyuri("[InventoryController] loaded")
        return ctrl
    end
    notyuri("[InventoryController] failed to load:", tostring(ctrl))
    return nil
end
local function GetHeldCount()
    local ctrl = GetInventoryController()
    if ctrl and type(ctrl.count) == "function" then
        return ctrl.count()
    end
    return 0
end
local function IsInventoryFull()
    local ctrl = GetInventoryController()
    if ctrl and type(ctrl.isFull) == "function" then
        return ctrl.isFull()
    end
    return false
end
local function GetActiveSquishy()
    local ctrl = GetInventoryController()
    if ctrl and type(ctrl.getActive) == "function" then
        return ctrl.getActive()
    end
    return nil
end
local function ClientPickup(sqId, sqType)
    local ctrl = GetInventoryController()
    if ctrl and type(ctrl.add) == "function" then
        pcall(ctrl.add, sqId, sqType, nil)
    end
end
local function ClientRemoveActive()
    local ctrl = GetInventoryController()
    if ctrl and type(ctrl.removeActive) == "function" then
        pcall(ctrl.removeActive)
    end
end
local function Func_AutoStock()
    local stockFailCount = 0
    local lastStockSlot = nil
    local function ForcedCycle(hrp, sq, slot)
        local sqId = sq:GetAttribute("SquishyId")
        local sqType = sq:GetAttribute("SquishyType")
        hrp.CFrame = sq.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.175)
        NetFire("Main", "PickupSquishy", sqId)
        ClientPickup(sqId, sqType)
        local t0 = tick()
        repeat task.wait() until GetActiveSquishy() or (tick() - t0 > 2)
        if not GetActiveSquishy() then return end
        hrp.CFrame = slot.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.175)
        NetFire("Main", "PlaceSquishy", GetActiveSquishy().id, slot)
        ClientRemoveActive()
        local t1 = tick()
        repeat task.wait() until not slot.CanQuery or (tick() - t1 > 0.5)
        if not slot.CanQuery then
            stockFailCount = 0
            lastStockSlot = nil
        end
    end
    while Toggles.AutoStock.Value do
        local ok, err = pcall(function()
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local active = GetActiveSquishy()
            if active and active.id and active.type then
                local positions = FindPositions(active.type)
                local slot = positions[1]
                if not slot then return end
                if slot == lastStockSlot and stockFailCount >= 1 then
                    local squishies = FindFloorSquishies(9999)
                    for _, sq in ipairs(squishies) do
                        if sq:GetAttribute("SquishyType") == active.type then
                            NetFire("Main", "DropSquishy", active.id)
                            ClientRemoveActive()
                            local t0 = tick()
                            repeat task.wait() until not GetActiveSquishy() or (tick() - t0 > 1)
                            ForcedCycle(hrp, sq, slot)
                            return
                        end
                    end
                end
                NetFire("Main", "PlaceSquishy", active.id, slot)
                ClientRemoveActive()
                local t1 = tick()
                repeat task.wait() until not slot.CanQuery or (tick() - t1 > 0.5)
                if slot.CanQuery then
                    stockFailCount = (slot == lastStockSlot) and (stockFailCount + 1) or 1
                    lastStockSlot = slot
                else
                    stockFailCount = 0
                    lastStockSlot = nil
                end
                return
            end
            if IsInventoryFull() then return end
            local positionsFolder = workspace:FindFirstChild("Positions")
            if not positionsFolder then return end
            local squishies = FindFloorSquishies(9999)
            local bestSlot = nil
            local bestSq = nil
            local bestDist = math.huge
            for _, part in ipairs(positionsFolder:GetChildren()) do
                if part:IsA("BasePart") and part.CanQuery then
                    local slotDist = (part.Position - hrp.Position).Magnitude
                    for _, sq in ipairs(squishies) do
                        if sq:GetAttribute("SquishyType") == part.Name and sq:GetAttribute("SquishyId") then
                            local sqDist = (sq.Position - hrp.Position).Magnitude
                            local combined = slotDist + sqDist
                            if combined < bestDist then
                                bestDist = combined
                                bestSlot = part
                                bestSq = sq
                            end
                            break
                        end
                    end
                end
            end
            if not bestSlot or not bestSq then return end
            if bestSlot == lastStockSlot and stockFailCount >= 1 then
                ForcedCycle(hrp, bestSq, bestSlot)
            else
                local sqId = bestSq:GetAttribute("SquishyId")
                local sqType = bestSq:GetAttribute("SquishyType")
                NetFire("Main", "PickupSquishy", sqId)
                ClientPickup(sqId, sqType)
                local t0 = tick()
                repeat task.wait() until GetActiveSquishy() or (tick() - t0 > 2)
            end
        end)
        if not ok then end
        task.wait()
    end
end
local function Func_AutoPickup()
    while Toggles.AutoPickup.Value do
        local ok, err = pcall(function()
            if IsInventoryFull() then return end
            local squishies = FindFloorSquishies(9999)
            if #squishies > 0 then
                local target = squishies[1]
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0)
                    task.wait()
                end
                local sqId = target:GetAttribute("SquishyId")
                local sqType = target:GetAttribute("SquishyType")
                if sqId then
                    NetFire("Main", "PickupSquishy", sqId)
                    ClientPickup(sqId, sqType)
                    notyuri("[AutoPickup] picked up:", sqType or "?")
                end
            end
        end)
        if not ok then notyuri("[AutoPickup] error:", err) end
        task.wait()
    end
end
local function Func_AutoPlace()
    local placeFailCount = 0
    local lastTargetSlot = nil
    while Toggles.AutoPlace.Value do
        local ok, err = pcall(function()
            local active = GetActiveSquishy()
            if not active or not active.id or not active.type then return end
            local positions = FindPositions(active.type)
            local placedSlot = positions[1]
            if not placedSlot then
                NetFire("Main", "DropSquishy", active.id)
                ClientRemoveActive()
                notyuri("[AutoPlace] no position for:", active.type, "- dropped")
                local t0 = tick()
                repeat task.wait() until not GetActiveSquishy() or (tick() - t0 > 0.5)
                return
            end
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if placedSlot == lastTargetSlot and placeFailCount >= 3 then
                    notyuri("[AutoPlace] 3 failures on slot, teleporting to:", active.type)
                    hrp.CFrame = placedSlot.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.1)
                    placeFailCount = 0
                else
                    hrp.CFrame = placedSlot.CFrame * CFrame.new(0, 3, 0)
                    task.wait()
                end
            end
            NetFire("Main", "PlaceSquishy", active.id, placedSlot)
            ClientRemoveActive()
            notyuri("[AutoPlace] placed:", active.type)
            local t0 = tick()
            repeat task.wait() until not GetActiveSquishy() or (tick() - t0 > 0.5)
            local t1 = tick()
            repeat task.wait() until not placedSlot.CanQuery or (tick() - t1 > 1)
            if placedSlot.CanQuery then
                if placedSlot == lastTargetSlot then
                    placeFailCount = placeFailCount + 1
                else
                    placeFailCount = 1
                end
                lastTargetSlot = placedSlot
                notyuri("[AutoPlace] placement may have failed, fail count:", placeFailCount)
            else
                placeFailCount = 0
                lastTargetSlot = nil
            end
        end)
        if not ok then notyuri("[AutoPlace] error:", err) end
        task.wait()
    end
end
local function Func_AutoDrop()
    while Toggles.AutoDrop.Value do
        local ok, err = pcall(function()
            local active = GetActiveSquishy()
            if active and active.id then
                NetFire("Main", "DropSquishy", active.id)
                ClientRemoveActive()
                notyuri("[AutoDrop] dropped:", active.type or "?")
            end
        end)
        if not ok then notyuri("[AutoDrop] error:", err) end
        task.wait()
    end
end
local function Func_AutoAbility()
    while Toggles.AutoAbility.Value do
        local ok, err = pcall(function()
            NetFire("Main", "ActivateAbility")
            notyuri("[AutoAbility] activated")
        end)
        if not ok then notyuri("[AutoAbility] error:", err) end
        task.wait()
    end
end
local function Func_AutoUpgrades()
    while Toggles.AutoUpgrades.Value do
        local ok, err = pcall(function()
            local cfg = GetGameConfig()
            if not cfg or not cfg.upgrades then return end
            local cash = GetCash()
            for upgId, upg in pairs(cfg.upgrades) do
                if not Toggles.AutoUpgrades.Value then break end
                local level = Plr:GetAttribute("Upgrade_" .. upgId) or 0
                if upg.maxLevel and level < upg.maxLevel then
                    local cost = math.floor((upg.baseCost or 0) * (upg.costGrowth or 1) ^ level)
                    if cash >= cost then
                        NetFire("Main", "BuySessionUpgrade", upgId)
                        notyuri("[AutoUpgrades] bought:", upgId, "for:", cost)
                        cash = cash - cost
                        task.wait()
                    end
                end
            end
        end)
        if not ok then notyuri("[AutoUpgrades] error:", err) end
        task.wait()
    end
end
local function Func_AutoBuyBuff()
    while Toggles.AutoBuyBuff.Value do
        local ok, err = pcall(function()
            NetFire("Lobby", "BuyPermanentBuff", "cashPerPlacement")
            notyuri("[AutoBuyBuff] bought cashPerPlacement buff")
        end)
        if not ok then notyuri("[AutoBuyBuff] error:", err) end
        task.wait()
    end
end
local function RedeemCode(code)
    if not code or code == "" then return end
    local ok, res = pcall(function() return NetInvoke("Common", "RedeemCode", code) end)
    notyuri("[RedeemCode] code:", code, "result:", tostring(res))
    Library:Notify(ok and ("Redeemed: " .. tostring(res)) or "Redeem failed", 4)
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
TB_Tabs.Autofarm.T1:AddToggle("AutoStock", { Text = "Auto Stock", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAbility", { Text = "Auto Ability", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrades", { Text = "Auto Upgrades", Default = false })
Toggles.AutoStock:OnChanged(function(v) Thread("AutoStock", Func_AutoStock, v) end)
Toggles.AutoAbility:OnChanged(function(v) Thread("AutoAbility", Func_AutoAbility, v) end)
Toggles.AutoUpgrades:OnChanged(function(v) Thread("AutoUpgrades", Func_AutoUpgrades, v) end)
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
SaveManager:SetFolder("Yuri/Squishy")
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