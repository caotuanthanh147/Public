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
local RemotesFolder = RS:FindFirstChild("Remotes") or RS:WaitForChild("Remotes", 15)
local AsmrData = nil
pcall(function() AsmrData = require(RS:WaitForChild("Asmr", 5).Config.AsmrItemData) end)
local PlacementUtil = nil
pcall(function() PlacementUtil = require(RS:WaitForChild("Shared", 5).PlacementUtil) end)
local Templates = nil
pcall(function() Templates = RS:WaitForChild("Asmr", 5):WaitForChild("Templates", 5) end)
local _evtCache = {}
local function GetRemote(name)
    if _evtCache[name] ~= nil then return _evtCache[name] end
    local r = RemotesFolder and (RemotesFolder:FindFirstChild(name) or RemotesFolder:WaitForChild(name, 5))
    _evtCache[name] = r
    return r
end
local function FireRemote(name, ...)
    local r = GetRemote(name)
    if not r then return false end
    local args = {...}
    return pcall(function() r:FireServer(unpack(args)) end)
end
local function GetCash()
    return tonumber(Plr:GetAttribute("Cash")) or 0
end
local GAMEMODES = {
    "BobaNeedoh", "DiamondBeacon", "EmeraldBeacon", "GlazedButter", "GoldBeacon",
    "GoldCap", "Grasscap", "HeldSign", "HoneyCap", "Huge", "IronBeacon",
    "KeycapCrate", "Knockback", "Mailbox", "Massive", "MechanicCap",
    "Paintbrush", "PrismaticBeacon", "ProPack", "Punch", "RewardEvent",
    "Snowcap", "Spleef", "StarterPack", "TimerPack", "Tiny", "VoidBeacon",
    "VoidCap", "WaterCap"
}
local _invItems = {}
local _stock = {}
task.spawn(function()
    local Remotes = RS:WaitForChild("Remotes", 15)
    if not Remotes then notyuri("[Init] Remotes folder not found") return end
    local invRemote = Remotes:WaitForChild("InventoryChanged", 15)
    local stockRemote = Remotes:WaitForChild("StockChanged", 15)
    local syncRemote = Remotes:FindFirstChild("RequestSync")
    if invRemote then
        invRemote.OnClientEvent:Connect(function(p1)
            if type(p1) == "table" then
                _invItems = p1
                notyuri("[InvChanged] received", #p1, "items")
            end
        end)
        notyuri("[Init] InventoryChanged connected")
    else
        notyuri("[Init] InventoryChanged remote not found")
    end
    if stockRemote then
        stockRemote.OnClientEvent:Connect(function(p1)
            if type(p1) == "table" then
                _stock = {}
                for k, v in pairs(p1) do _stock[k] = v end
                notyuri("[StockChanged] received", #p1 or 0, "stock entries")
            end
        end)
        notyuri("[Init] StockChanged connected")
    else
        notyuri("[Init] StockChanged remote not found")
    end
    if syncRemote then
        notyuri("[Init] firing RequestSync")
        pcall(function() syncRemote:FireServer() end)
    else
        notyuri("[Init] RequestSync remote not found, firing RequestStock instead")
        local stockReq = Remotes:FindFirstChild("RequestStock")
        if stockReq then pcall(function() stockReq:FireServer() end) end
    end
end)
local RARITY_ORDER = { Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5, Divine=6, Mythic=7, Secret=8 }
local function BuildAsmrItemList()
    local list = {}
    if not AsmrData or not AsmrData.Items then return { "Any" } end
    for name, data in pairs(AsmrData.Items) do
        if type(data) == "table" and data.Cost and data.Cost > 0 then
            local rarity = data.Rarity or "?"
            table.insert(list, { label = name .. " | " .. rarity, name = name, rarity = rarity })
        end
    end
    table.sort(list, function(a, b)
        local ra = RARITY_ORDER[a.rarity] or 0
        local rb = RARITY_ORDER[b.rarity] or 0
        if ra ~= rb then return ra < rb end
        return a.name < b.name
    end)
    local result = { "Any" }
    for _, item in ipairs(list) do table.insert(result, item.label) end
    return result
end
local function BuildAsmrCraftList()
    local list = {}
    if not AsmrData or not AsmrData.Items then return { "Any" } end
    for name, data in pairs(AsmrData.Items) do
        if type(data) == "table" and data.Craft then
            table.insert(list, name)
        end
    end
    table.sort(list)
    local result = { "Any" }
    for _, name in ipairs(list) do table.insert(result, name) end
    return result
end
local function GetPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local oid = plot:GetAttribute("OwnerId")
            if oid == Plr.UserId then
            notyuri("[Debug] OriginAttr:", plot:GetAttribute("OriginCFrame"), "BuildZone:", plot.BuildZone and plot.BuildZone.CFrame, "Pivot:", plot:GetPivot(), "Name:", plot.Name)
            return plot end
        end
    end
    return nil
end
local function GetPlotCFrame()
    local plot = GetPlot()
    if not plot then return nil end
    local originAttr = plot:GetAttribute("OriginCFrame")
    if typeof(originAttr) == "CFrame" then return originAttr end
    if plot:IsA("BasePart") then return plot.CFrame end
    if plot:IsA("Model") then
        local buildZone = plot:FindFirstChild("BuildZone")
        if buildZone and buildZone:IsA("BasePart") then return buildZone.CFrame end
        return plot:GetPivot()
    end
    return nil
end
local function GetOriginCFrame()
    local plot = GetPlot()
    if not plot then return nil end
    local cf = plot:GetAttribute("OriginCFrame")
    if typeof(cf) ~= "CFrame" then return nil end
    return cf
end
local OS_BLOCK_SIZE = 3
local OS_PLOT_CELLS = 20
local _packCurX = 0   
local _packCurZ = 0   
local _packRowH = 0   
local _packLayerY = 0
local function ResetSpiral()
    _packCurX = 0
    _packCurZ = 0
    _packRowH = 0
    _packLayerY = 0
end
local function NextSpiralPosOS(gx, gy, gz)
    if _packCurX + gx > OS_PLOT_CELLS then
        _packCurX = 0
        _packCurZ = _packCurZ + _packRowH
        _packRowH = 0
    end
    if _packCurZ + gz > OS_PLOT_CELLS then
        _packCurX = 0
        _packCurZ = 0
        _packRowH = 0
        _packLayerY = _packLayerY + gy * OS_BLOCK_SIZE
    end
    local startX = math.min(_packCurX, OS_PLOT_CELLS - gx)
    local startZ = math.min(_packCurZ, OS_PLOT_CELLS - gz)
    local ox = (startX * 2 + gx - 1) * OS_BLOCK_SIZE / 2
    local oy = _packLayerY + (gy - 1) * OS_BLOCK_SIZE / 2
    local oz = (startZ * 2 + gz - 1) * OS_BLOCK_SIZE / 2
    _packCurX = _packCurX + gx
    if gz > _packRowH then _packRowH = gz end
    return Vector3.new(ox, oy, oz)
end
local function BuildCandidateOBB(originCF, osPos, gx, gy, gz)
    local worldCF = originCF * CFrame.new(osPos)
    local hx = (gx * OS_BLOCK_SIZE) / 2
    local hy = (gy * OS_BLOCK_SIZE) / 2
    local hz = (gz * OS_BLOCK_SIZE) / 2
    local pos = worldCF.Position
    local right = worldCF.RightVector
    local look = worldCF.LookVector
    return {
        cx = pos.X, cz = pos.Z, cy = pos.Y, hy = hy,
        ax = right.X, az = right.Z, ha = hx,
        bx = look.X, bz = look.Z, hb = hz,
    }
end
local function OverlapsPlacedBlocks(candidateOBB, placedBlocks)
    if not PlacementUtil or not PlacementUtil.obbOverlap or not PlacementUtil.modelOBB then
        return false
    end
    for _, block in ipairs(placedBlocks) do
        if block.model and block.model.Parent then
            local ok, obb = pcall(PlacementUtil.modelOBB, block.model)
            if ok and obb and PlacementUtil.obbOverlap(candidateOBB, obb) then
                return true
            end
        end
    end
    return false
end
local function ModelForItem(itemKey)
    if not Templates or not itemKey then return nil end
    local found = Templates:FindFirstChild(itemKey, true)
    if found and found:IsA("Model") then return found end
    return nil
end
local function IsBlockPlacedAt(itemKey, worldCF, placedBlocks)
    if not PlacementUtil or not PlacementUtil.modelOBB or not PlacementUtil.obbOverlap then
        return false
    end
    local template = ModelForItem(itemKey)
    if not template then return false end
    local ghost = template:Clone()
    ghost.Name = "LoadBuildGhost"
    for _, d in ipairs(ghost:GetDescendants()) do
        if d:IsA("BasePart") then
            d.CanCollide = false
            d.CanQuery = false
            d.CanTouch = false
        end
    end
    ghost:PivotTo(worldCF)
    ghost.Parent = workspace
    local ok, candidateOBB = pcall(PlacementUtil.modelOBB, ghost)
    local overlapped = false
    if ok and candidateOBB then
        overlapped = OverlapsPlacedBlocks(candidateOBB, placedBlocks)
    end
    ghost:Destroy()
    return overlapped
end
local function GenerateAsmrSlotsOS(items)
    local slots = {}
    local curX = 0  
    local curZ = 0  
    local rowMaxZ = 0  
    for _, entry in ipairs(items) do
        local gs = { 1, 1, 1 }
        if AsmrData and AsmrData.Items and AsmrData.Items[entry.key] then
            gs = AsmrData.Items[entry.key].GridSize or gs
        end
        local gx = gs[1] or 1  
        local gz = gs[3] or 1  
        if curX + gx > OS_PLOT_CELLS then
            curX = 0
            curZ = curZ + rowMaxZ
            rowMaxZ = 0
        end
        local startX = math.min(curX, OS_PLOT_CELLS - gx)
        local startZ = math.min(curZ, OS_PLOT_CELLS - gz)
        local ox = (startX * 2 + gx - 1) * OS_BLOCK_SIZE / 2
        local oz = (startZ * 2 + gz - 1) * OS_BLOCK_SIZE / 2
        table.insert(slots, Vector3.new(ox, 0, oz))
        curX = curX + gx
        if gz > rowMaxZ then rowMaxZ = gz end
    end
    return slots
end
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local selected = Options.UpgradeSelected and Options.UpgradeSelected.Value or {}
        local toUpgrade = {}
        if next(selected) == nil then
            toUpgrade = { "MaxItems", "BankStorage", "ExpandTower" }
        else
            for label in pairs(selected) do table.insert(toUpgrade, label) end
        end
        for _, id in ipairs(toUpgrade) do
            if not Toggles.AutoUpgrade.Value then break end
            FireRemote("BuyUpgrade", id)
            task.wait(0.1)
        end
        task.wait(.1)
    end
end
local function GetCardStock(itemName)
    local screenGui = PGui:FindFirstChild("ScreenGui")
    if not screenGui then
        return nil
    end
    local shopUI = screenGui:FindFirstChild("ShopUI")
    if not shopUI then
        return nil
    end
    local sf = shopUI:FindFirstChild("ScrollingFrame")
    if not sf then
        return nil
    end
    local card = sf:FindFirstChild("Card_" .. itemName)
    if not card then
        return 0
    end
    local info = card:FindFirstChild("Info")
    if not (info and info:IsA("TextLabel")) then
        return nil
    end
    local text = info.Text
    local n = tonumber(text:match("^(%d+)"))
    if n then
        return n
    end
    return 0
end
local function CanBuyItem(itemName)
    local data = AsmrData and AsmrData.Items and AsmrData.Items[itemName]
    if not data then
        return false
    end
    local cost = data.Cost or 0
    if cost <= 0 then
        return false
    end
    local cash = GetCash()
    if cash < cost then
        return false
    end
    local stock = GetCardStock(itemName)
    if stock == nil then
        stock = _stock[itemName]
    end
    if stock ~= nil and stock <= 0 then
        return false
    end
    return true
end
local function TPShop()
    local shopTouch = workspace:FindFirstChild("Map") and
        workspace.Map:FindFirstChild("Buildings") and
        workspace.Map.Buildings:FindFirstChild("ASMR SHOP") and
        workspace.Map.Buildings["ASMR SHOP"]:FindFirstChild("Buy") and
        workspace.Map.Buildings["ASMR SHOP"].Buy:FindFirstChild("Touch")
    if shopTouch and shopTouch:IsA("BasePart") then
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local distance = (hrp.Position - shopTouch.Position).Magnitude
            if distance > 10 then
                hrp.CFrame = shopTouch.CFrame * CFrame.new(0, 3, 0)
                task.wait(0.175)
            end
        end
    end
end
local function Func_AutoBuy()
    while Toggles.AutoBuy.Value do
        local selected = Options.BuySelected and Options.BuySelected.Value or {}
        if next(selected) == nil then task.wait(3) continue end
        if selected["Any"] and AsmrData and AsmrData.Items then
            for itemName, data in pairs(AsmrData.Items) do
                if not Toggles.AutoBuy.Value then break end
                if type(data) == "table" and CanBuyItem(itemName) then
                    TPShop()
                    FireRemote("BuyItem", itemName, 1)
                    task.wait(.1)
                end
            end
        else
            for label in pairs(selected) do
                if not Toggles.AutoBuy.Value then break end
                local itemName = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                if CanBuyItem(itemName) then
                    TPShop()
                    FireRemote("BuyItem", itemName, 1)
                    task.wait(.1)
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoCraft()
    while Toggles.AutoCraft.Value do
        local selected = Options.CraftSelected and Options.CraftSelected.Value or {}
        if next(selected) == nil then task.wait(3) continue end
        if selected["Any"] and AsmrData and AsmrData.Items then
            for name, data in pairs(AsmrData.Items) do
                if not Toggles.AutoCraft.Value then break end
                if type(data) == "table" and data.Craft then
                    FireRemote("CraftItem", name)
                    task.wait(0.5)
                end
            end
        else
            for label in pairs(selected) do
                if not Toggles.AutoCraft.Value then break end
                local name = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                FireRemote("CraftItem", name)
                task.wait(0.5)
            end
        end
        task.wait(2)
    end
end
local function Func_AutoGemShopBuy()
    while Toggles.AutoGemShopBuy.Value do
        local key = (Options.GemShopKeyInput and Options.GemShopKeyInput.Value) or ""
        if key ~= "" then
            FireRemote("GemShopBuy", key)
        end
        task.wait(2)
    end
end
local function Func_AutoRedeemCode()
    while Toggles.AutoRedeemCode.Value do
        local code = (Options.CodeInput and Options.CodeInput.Value) or ""
        if code ~= "" then
            FireRemote("RedeemCode", code)
        end
        task.wait(30)
    end
end
local function Func_AutoRequestSync()
    while Toggles.AutoRequestSync.Value do
        FireRemote("RequestSync")
        task.wait(30)
    end
end
local function Func_AutoRequestStock()
    while Toggles.AutoRequestStock.Value do
        FireRemote("RequestStock")
        task.wait(30)
    end
end
local function Func_AutoRequestSaves()
    while Toggles.AutoRequestSaves.Value do
        FireRemote("RequestSaves")
        task.wait(60)
    end
end
local function Func_AutoDropPlushie()
    while Toggles.AutoDropPlushie.Value do
        FireRemote("DropPlushie")
        task.wait(5)
    end
end
local function Func_AutoMMJoinQueue()
    while Toggles.AutoMMJoinQueue.Value do
        local mode = (Options.GamemodeDropdown and Options.GamemodeDropdown.Value) or "StarterPack"
        FireRemote("MMJoinQueue", mode, false, true)
        task.wait(10)
    end
end
local function Func_AutoMMLeaveQueue()
    while Toggles.AutoMMLeaveQueue.Value do
        FireRemote("MMLeaveQueue")
        task.wait(30)
    end
end
local function Func_AutoRewardBoxOpen()
    while Toggles.AutoRewardBoxOpen.Value do
        FireRemote("RewardBoxOpen")
        task.wait(5)
    end
end
local function DoRedeemCode()
    local code = (Options.CodeInput and Options.CodeInput.Value) or ""
    code = code:gsub("%s+", "")
    if code == "" then
        Library:Notify("Enter a code first.", 3)
        return
    end
    FireRemote("RedeemCode", code)
    Library:Notify("Redeeming code: " .. code, 3)
end
local function DoMMJoinQueue()
    local mode = (Options.GamemodeDropdown and Options.GamemodeDropdown.Value) or "StarterPack"
    FireRemote("MMJoinQueue", mode, false, true)
    Library:Notify("Joined queue: " .. mode, 3)
end
local function DoMMLeaveQueue()
    FireRemote("MMLeaveQueue")
    Library:Notify("Left queue.", 3)
end
local function DoRequestSync()
    FireRemote("RequestSync")
    Library:Notify("Sync requested.", 3)
end
local function DoRequestStock()
    FireRemote("RequestStock")
    Library:Notify("Stock requested.", 3)
end
local function DoDropPlushie()
    FireRemote("DropPlushie")
    Library:Notify("Plushie dropped.", 3)
end
local function DoBuyUpgrade()
    local id = (Options.UpgradeIdInput and Options.UpgradeIdInput.Value) or "MaxItems"
    FireRemote("BuyUpgrade", id)
    Library:Notify("Upgrade bought: " .. id, 3)
end
local function DoBuyItem()
    local item = (Options.BuyItemInput and Options.BuyItemInput.Value) or ""
    if item == "" then
        Library:Notify("Enter an item key.", 3)
        return
    end
    FireRemote("BuyItem", item, 1)
    Library:Notify("Item bought: " .. item, 3)
end
local function DoCraft()
    local recipe = (Options.CraftItemInput and Options.CraftItemInput.Value) or ""
    if recipe == "" then
        Library:Notify("Enter a recipe key.", 3)
        return
    end
    FireRemote("CraftItem", recipe)
    Library:Notify("Crafting: " .. recipe, 3)
end
local function DoSaveLayout()
    FireRemote("SaveLayout", {}, "")
    Library:Notify("Layout saved.", 3)
end
local function DoLoadSave()
    local slot = (Options.LoadSaveInput and Options.LoadSaveInput.Value) or "1"
    local n = tonumber(slot) or 1
    FireRemote("LoadSave", n)
    Library:Notify("Loading save slot: " .. n, 3)
end
local BUILD_SAVE_FOLDER = "Yuri/AsmrTower/Build"
local function CFrameToTable(cf)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function TableToCFrame(t)
    if type(t) ~= "table" or #t < 12 then return CFrame.new() end
    return CFrame.new(t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
end
local function GetPlacedBlocks()
    local plot = GetPlot()
    if not plot then return {} end
    local placedItems = plot:FindFirstChild("PlacedItems")
    if not placedItems then return {} end
    local blocks = {}
    for _, child in ipairs(placedItems:GetChildren()) do
        if child:IsA("Model") then
            local cellKey = child:GetAttribute("CellKey")
            local itemKey = child:GetAttribute("ItemKey") or child:GetAttribute("itemKey")
            if cellKey or itemKey then
                local bbCF = child:GetBoundingBox()
                local pivot = child:GetPivot()
                local cf = pivot.Rotation + bbCF.Position
                table.insert(blocks, { model = child, cellKey = cellKey, itemKey = itemKey, cf = cf })
            end
        end
    end
    return blocks
end
local function GetAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return {} end
    local out = {}
    local ourPlot = GetPlot()
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local ownerName = "Unknown"
            pcall(function()
                ownerName = plot:GetAttribute("OwnerName") or plot.Name or "Unknown"
            end)
            table.insert(out, { plot = plot, ownerName = ownerName, isOurs = (plot == ourPlot) })
        end
    end
    return out
end
local function GetPlacedBlocksFromPlot(plot)
    if not plot then return {} end
    local blocks = {}
    local placedItems = plot:FindFirstChild("PlacedItems")
    if not placedItems then return blocks end
    for _, child in ipairs(placedItems:GetChildren()) do
        if child:IsA("Model") then
            local cellKey = child:GetAttribute("CellKey")
            local itemKey = child:GetAttribute("ItemKey") or child:GetAttribute("itemKey")
            if cellKey or itemKey then
                local bbCF = child:GetBoundingBox()
                local pivot = child:GetPivot()
                local cf = pivot.Rotation + bbCF.Position
                table.insert(blocks, { cellKey = cellKey, itemKey = itemKey, cf = cf })
            end
        end
    end
    return blocks
end
local function GetPlotCFrameOf(plot)
    if not plot then return nil end
    local originAttr = plot:GetAttribute("OriginCFrame")
    if typeof(originAttr) == "CFrame" then return originAttr end
    if plot:IsA("BasePart") then return plot.CFrame end
    if plot:IsA("Model") then
        local buildZone = plot:FindFirstChild("BuildZone")
        if buildZone and buildZone:IsA("BasePart") then return buildZone.CFrame end
        return plot:GetPivot()
    end
    return nil
end
local function SerializeBlocks(blocks, plotCF)
    if not plotCF or #blocks == 0 then return nil end
    local relative = plotCF:Inverse()
    local data = { version = 1, count = #blocks, blocks = {} }
    for _, b in ipairs(blocks) do
        local relCF = relative * b.cf
        table.insert(data.blocks, { cellKey = b.cellKey, itemKey = b.itemKey, cf = CFrameToTable(relCF) })
    end
    return HttpService:JSONEncode(data)
end
local function CopyBuildToJSON()
    local plotCF = GetPlotCFrame()
    if not plotCF then return nil end
    local blocks = GetPlacedBlocks()
    if #blocks == 0 then return nil end
    return SerializeBlocks(blocks, plotCF)
end
local function LoadBuildJSON(json)
    if not json or json == "" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" or type(data.blocks) ~= "table" then return nil end
    return data
end
local function ListBuildFiles()
    local files = {}
    if not Support.FileIO or not isfolder then return files end
    pcall(function()
        if not isfolder(BUILD_SAVE_FOLDER) then return end
        for _, name in ipairs(listfiles(BUILD_SAVE_FOLDER)) do
            if name:sub(-5) == ".json" then
                local short = name:match("([^/\\]+)%.json$")
                if short then table.insert(files, short) end
            end
        end
    end)
    table.sort(files)
    return files
end
local _buildSourcesLookup = {}
local MatLabel = nil
local UpdateBuildLabel
local RefreshBuildSourcesDropdown
local function SaveBuildToFile(saveName)
    if not saveName or saveName == "" then
        Library:Notify("Enter a file name first.", 3)
        return
    end
    if not Support.FileIO then
        Library:Notify("File IO not supported.", 4)
        return
    end
    local json = CopyBuildToJSON()
    if not json then
        Library:Notify("No placed items to save.", 4)
        return
    end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    pcall(function()
        if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
        writefile(path, json)
    end)
    Library:Notify("Build saved: " .. saveName, 5)
    if RefreshBuildSourcesDropdown then RefreshBuildSourcesDropdown() end
end
local function LoadBuildFromFile(saveName)
    if not saveName or saveName == "" then return nil end
    if not Support.FileIO then return nil end
    local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
    if not isfile(path) then return nil end
    local ok, json = pcall(readfile, path)
    if not ok or not json then return nil end
    return LoadBuildJSON(json)
end
RefreshBuildSourcesDropdown = function()
    if not Options.BuildSource then return end
    local plots = GetAllPlots()
    local files = ListBuildFiles()
    local values = {}
    _buildSourcesLookup = {}
    local worldPlot = workspace:FindFirstChild("WorldPlot")
    if worldPlot then
        local display = "[World Plot]"
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "plot", plot = worldPlot, ownerName = "WorldPlot" }
    end
    for _, p in ipairs(plots) do
        local prefix = p.isOurs and "[My Plot] " or "[Plot] "
        local display = prefix .. p.ownerName
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "plot", plot = p.plot, ownerName = p.ownerName }
    end
    for _, fname in ipairs(files) do
        local display = "[File] " .. fname
        table.insert(values, display)
        _buildSourcesLookup[display] = { type = "file", name = fname }
    end
    Options.BuildSource:SetValues(values)
end
local function LoadSelectedBuildSource()
    local sel = Options.BuildSource and Options.BuildSource.Value
    if not sel or sel == "" then
        Library:Notify("Select a base or file first.", 3)
        return nil
    end
    local entry = _buildSourcesLookup[sel]
    if not entry then
        Library:Notify("Unknown source: " .. sel, 4)
        return nil
    end
    if entry.type == "plot" then
        local blocks = GetPlacedBlocksFromPlot(entry.plot)
        if #blocks == 0 then
            Library:Notify("That plot has no placed blocks.", 4)
            return nil
        end
        local plotCF = GetPlotCFrameOf(entry.plot)
        if not plotCF then return nil end
        local json = SerializeBlocks(blocks, plotCF)
        return LoadBuildJSON(json)
    elseif entry.type == "file" then
        return LoadBuildFromFile(entry.name)
    end
    return nil
end
local function GetBuildRequirements(data)
    local reqs = {}
    for _, entry in ipairs(data.blocks) do
        local k = entry.itemKey
        if k then reqs[k] = (reqs[k] or 0) + 1 end
    end
    return reqs
end
local function GetInventoryCount(itemKey)
    local count = 0
    for _, item in ipairs(_invItems) do
        if type(item) == "table" and item.Key == itemKey and item.Guid then
            count = count + 1
        end
    end
    return count
end
local function ComputeMissingMaterials(reqs)
    local missing = {}
    local parts = {}
    for itemKey, need in pairs(reqs) do
        local have = GetInventoryCount(itemKey)
        if have < need then
            local short = need - have
            missing[itemKey] = short
            table.insert(parts, itemKey .. "(x" .. short .. ")")
        end
    end
    table.sort(parts)
    local display
    if #parts == 0 then
        display = "Ready"
    else
        display = "Missing: " .. table.concat(parts, ", ")
    end
    return missing, display
end
UpdateBuildLabel = function()
    if not MatLabel then return end
    local data = LoadSelectedBuildSource()
    if not data then
        MatLabel:SetText("No build selected.")
        return
    end
    local reqs = GetBuildRequirements(data)
    local _, display = ComputeMissingMaterials(reqs)
    MatLabel:SetText(display)
end
local function GetInventoryGuid(itemKey)
    for _, item in ipairs(_invItems) do
        if type(item) == "table" and item.Key == itemKey and item.Guid then
            return item.Guid
        end
    end
    return nil
end
local function RunBuildFromSelectedSource()
    local data = LoadSelectedBuildSource()
    if not data then
        Library:Notify("Select a build file first.", 3)
        return
    end
    local plotCF = GetPlotCFrame()
    if not plotCF then
        Library:Notify("No plot found.", 4)
        return
    end
    local plot = GetPlot()
    if not plot then
        Library:Notify("No plot found.", 4)
        return
    end
    local MaxPending = 5
    local Timeout = 0.5
    local MaxRetries = 2
    local pending = {}
    local placed, skipped, confirmed = 0, 0, 0
    notyuri("[LoadBuild] starting, blocks:", #data.blocks, "plotCF:", tostring(plotCF.Position))
    local function CheckPendingConfirmations()
        if #pending == 0 then return end
        local placedBlocks = GetPlacedBlocks()
        for i = #pending, 1, -1 do
            local p = pending[i]
            if IsBlockPlacedAt(p.itemKey, p.worldCF, placedBlocks) then
                table.remove(pending, i)
                confirmed = confirmed + 1
                notyuri("[LoadBuild] confirmed:", p.itemKey, "pending:", #pending, "total confirmed:", confirmed)
            end
        end
    end
    for idx, entry in ipairs(data.blocks) do
        if not Toggles.LoadBuild.Value then
            notyuri("[LoadBuild] toggle off, stopping at block", idx)
            break
        end
        local itemKey = entry.itemKey
        local count = itemKey and GetInventoryCount(itemKey) or 0
        if count > 0 then
            local relCF = TableToCFrame(entry.cf)
            local worldCF = plotCF * relCF
            local guid = GetInventoryGuid(itemKey)
            if guid then
                local yaw = 0
                if PlacementUtil and PlacementUtil.yawUnits then
                    local ok, y = pcall(PlacementUtil.yawUnits, relCF)
                    if ok and y then yaw = y end
                end
                notyuri("[LoadBuild] placing", itemKey, "block", idx, "pos:", tostring(worldCF.Position), "yaw:", yaw, "inv:", count)
                table.insert(pending, { itemKey = itemKey, worldCF = worldCF, relCF = relCF, yaw = yaw, retries = 0 })
                FireRemote("PlaceFree", guid, relCF.X, relCF.Y, relCF.Z, yaw)
                placed = placed + 1
                local t0 = tick()
                while #pending > MaxPending do
                    CheckPendingConfirmations()
                    if #pending <= MaxPending then break end
                    if tick() - t0 > Timeout then
                        local oldest = table.remove(pending, 1)
                        if oldest.retries < MaxRetries then
                            oldest.retries = oldest.retries + 1
                            local og = GetInventoryGuid(oldest.itemKey)
                            if og then
                                notyuri("[LoadBuild] throttle timeout, retrying", oldest.itemKey, "attempt", oldest.retries, "/", MaxRetries)
                                FireRemote("PlaceFree", og, oldest.relCF.X, oldest.relCF.Y, oldest.relCF.Z, oldest.yaw)
                                table.insert(pending, oldest)
                            else
                                notyuri("[LoadBuild] throttle timeout, no inv for retry:", oldest.itemKey)
                            end
                        else
                            notyuri("[LoadBuild] throttle timeout, giving up on", oldest.itemKey, "after", MaxRetries, "retries")
                        end
                        t0 = tick()
                    end
                    task.wait()
                end
            else
                notyuri("[LoadBuild] skipping", itemKey, "block", idx, "- no inventory guid")
                skipped = skipped + 1
            end
        else
            notyuri("[LoadBuild] skipping", itemKey or "?", "block", idx, "- no inventory")
            skipped = skipped + 1
        end
    end
    notyuri("[LoadBuild] main loop done. placed:", placed, "skipped:", skipped, "confirmed:", confirmed, "pending:", #pending)
    local t0 = tick()
    while #pending > 0 do
        CheckPendingConfirmations()
        if #pending == 0 then break end
        if tick() - t0 > Timeout then
            local oldest = table.remove(pending, 1)
            if oldest.retries < MaxRetries then
                oldest.retries = oldest.retries + 1
                local og = GetInventoryGuid(oldest.itemKey)
                if og then
                    notyuri("[LoadBuild] drain timeout, retrying", oldest.itemKey, "attempt", oldest.retries, "/", MaxRetries)
                    FireRemote("PlaceFree", og, oldest.relCF.X, oldest.relCF.Y, oldest.relCF.Z, oldest.yaw)
                    table.insert(pending, oldest)
                else
                    notyuri("[LoadBuild] drain timeout, no inv for retry:", oldest.itemKey)
                end
            else
                notyuri("[LoadBuild] drain timeout, giving up on", oldest.itemKey, "after", MaxRetries, "retries")
            end
            t0 = tick()
        end
        task.wait()
    end
    if #pending == 0 then
        notyuri("[LoadBuild] all confirmed ok")
    end
    pending = {}
    Toggles.LoadBuild:SetValue(false)
    Library:Notify(("Build loaded: %d placed, %d skipped."):format(placed, skipped), 5)
    UpdateBuildLabel()
end
local function CopyBuildToClipboard()
    local json = CopyBuildToJSON()
    if not json then
        Library:Notify("No placed items to copy.", 4)
        return
    end
    if setclipboard then
        pcall(setclipboard, json)
        Library:Notify("Build copied to clipboard.", 5)
    end
end
local function Func_AutoCollect()
    while Toggles.AutoCollect.Value do
        local plot = GetPlot()
        local collectZone = plot and plot:FindFirstChild("CollectZone")
        if collectZone and collectZone:IsA("BasePart") then
            local bank = tonumber(collectZone:GetAttribute("Bank")) or 0
            local bankCap = tonumber(collectZone:GetAttribute("BankCap")) or 0
            local thresholdPct = (Options.AutoCollectThreshold and Options.AutoCollectThreshold.Value) or 0
            local threshold = bankCap * (thresholdPct / 100)
            if bank >= threshold then
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = collectZone.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.175)
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoPickup()
    while Toggles.AutoPickup.Value do
        local selected = Options.PickupSelected and Options.PickupSelected.Value or {}
        local blocks = GetPlacedBlocks()
        for _, block in ipairs(blocks) do
            if not Toggles.AutoPickup.Value then break end
            if block.cellKey then
                local matches = next(selected) == nil or selected["Any"]
                if not matches then
                    for label in pairs(selected) do
                        local key = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                        if key == block.itemKey then matches = true break end
                    end
                end
                if matches then
                    FireRemote("PickupItem", block.cellKey)
                    task.wait(0.1)
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local selected = Options.PlaceSelected and Options.PlaceSelected.Value or {}
        if next(selected) == nil then
            notyuri("[AutoPlace] waiting - no items selected in Place List")
            task.wait(2) continue
        end
        local plot = GetPlot()
        if not plot then
            notyuri("[AutoPlace] GetPlot() returned nil - no plot with OwnerId", Plr.UserId, "found in workspace.Plots")
            task.wait(2) continue
        end
        notyuri("[AutoPlace] plot:", plot.Name)
        local originCF = GetOriginCFrame()
        if not originCF then
            notyuri("[AutoPlace] GetOriginCFrame() returned nil - BuildZone missing or OriginCFrame attribute not set on plot", plot.Name)
            task.wait(2) continue
        end
        notyuri("[AutoPlace] originCF pos:", tostring(originCF.Position))
        if not PlacementUtil then
            notyuri("[AutoPlace] WARNING - PlacementUtil failed to load, overlap checking disabled")
        end
        notyuri("[AutoPlace] _invItems count:", #_invItems)
        if #_invItems == 0 then
            notyuri("[AutoPlace] _invItems is empty - InventoryChanged not fired yet?")
        end
        local guidsToPlace = {}
        local invSkipped = 0
        for _, item in ipairs(_invItems) do
            if type(item) ~= "table" then invSkipped = invSkipped + 1 continue end
            if not item.Guid then invSkipped = invSkipped + 1 notyuri("[AutoPlace] inv item missing Guid:", item.Key or "?") continue end
            if not item.Key then invSkipped = invSkipped + 1 notyuri("[AutoPlace] inv item missing Key, Guid:", item.Guid) continue end
            local matches = selected["Any"]
            if not matches then
                for label in pairs(selected) do
                    local key = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                    if key == item.Key then matches = true break end
                end
            end
            if matches then
                table.insert(guidsToPlace, { guid = item.Guid, key = item.Key })
            end
        end
        notyuri("[AutoPlace] matched", #guidsToPlace, "items to place, skipped", invSkipped, "invalid inv entries")
        if #guidsToPlace == 0 then
            notyuri("[AutoPlace] nothing matched - selected keys:")
            for label in pairs(selected) do
                local key = (label:match("^([^|]+)") or label):match("^%s*(.-)%s*$")
                notyuri("  selected key:", key)
            end
            notyuri("[AutoPlace] inv keys present:")
            for _, item in ipairs(_invItems) do
                if type(item) == "table" and item.Key then
                    notyuri("  inv key:", item.Key, "guid:", item.Guid or "nil")
                end
            end
            task.wait(2) continue
        end
        ResetSpiral()
        local placed = 0
        for i, entry in ipairs(guidsToPlace) do
            if not Toggles.AutoPlace.Value then
                notyuri("[AutoPlace] toggle off mid-loop at item", i)
                break
            end
            local gs = { 1, 1, 1 }
            if AsmrData and AsmrData.Items and AsmrData.Items[entry.key] then
                gs = AsmrData.Items[entry.key].GridSize or gs
            end
            local gx = gs[1] or 1
            local gy = gs[2] or 1
            local gz = gs[3] or 1
            local success = false
            for attempt = 1, 2 do
                local osPos = NextSpiralPosOS(gx, gy, gz)
                local placedBefore = GetPlacedBlocks()
                local skipCount = 0
                while PlacementUtil and OverlapsPlacedBlocks(BuildCandidateOBB(originCF, osPos, gx, gy, gz), placedBefore) do
                    skipCount = skipCount + 1
                    if skipCount > OS_PLOT_CELLS * OS_PLOT_CELLS then
                        notyuri("[AutoPlace] no free non-overlapping slot found for key:", entry.key)
                        break
                    end
                    osPos = NextSpiralPosOS(gx, gy, gz)
                end
                if skipCount > 0 and skipCount <= OS_PLOT_CELLS * OS_PLOT_CELLS then
                    notyuri("[AutoPlace] skipped", skipCount, "overlapping slot(s) for key:", entry.key)
                end
                local countBefore = #placedBefore
                FireRemote("PlaceFree", entry.guid, osPos.X, osPos.Y, osPos.Z, 0)
                task.wait()
                if #GetPlacedBlocks() > countBefore then
                    notyuri("[AutoPlace] confirmed place key:", entry.key, "at attempt", attempt)
                    placed = placed + 1
                    success = true
                    break
                end
                notyuri("[AutoPlace] no confirm, trying next pos (attempt", attempt, ")")
            end
            if not success then
                notyuri("[AutoPlace] FAILED to place key:", entry.key, "after", 2, "attempts")
            end
        end
        notyuri("[AutoPlace] cycle done - placed:", placed)
        task.wait(.1)
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
    Build = Window:AddTab("Build"),
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
        T1     = TB.Main.Left.Autofarm:AddTab("Autofarm"),
    },
    Autofarm2 = {
        T1     = TB.Main.Right.Autofarm:AddTab("Config"),
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
local _asmrItemList = BuildAsmrItemList()
local _asmrCraftList = BuildAsmrCraftList()
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeSelected", { Text = "Upgrade List", Values = { "MaxItems", "BankStorage", "ExpandTower" }, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("BuySelected", { Text = "Buy List", Values = _asmrItemList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("CraftSelected", { Text = "Craft List", Values = _asmrCraftList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("PlaceSelected", { Text = "Place List", Values = _asmrItemList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("PickupSelected", { Text = "Pickup List", Values = _asmrItemList, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", { Text = "Auto Buy", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCraft", { Text = "Auto Craft", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", { Text = "Auto Place", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Collect Money", Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("AutoCollectThreshold", { Text = "Collect Threshold", Default = 100, Min = 0, Max = 100, Rounding = 0, Compact = true })
local A1 = Tabs.Build:AddLeftGroupbox("Build")
local A2 = Tabs.Build:AddRightGroupbox("Material")
A1:AddDropdown("BuildSource", {
    Text = "Select Build to Load",
    Values = {},
    Default = "",
    Multi = false,
    Searchable = true,
    Callback = function()
        UpdateBuildLabel()
    end,
})
MatLabel = A2:AddLabel("No build selected.", true)
A1:AddButton({
    Text = "Buy Missing Items",
    Func = function()
        local data = LoadSelectedBuildSource()
        if not data then
            Library:Notify("Select a build source first.", 3)
            return
        end
        local reqs = GetBuildRequirements(data)
        local missing, display = ComputeMissingMaterials(reqs)
        local anyMissing = false
        for _ in pairs(missing) do anyMissing = true break end
        if not anyMissing then
            Library:Notify("No missing items", 4)
            return
        end
        local bought = 0
        for itemKey, shortage in pairs(missing) do
            for _ = 1, shortage do
                FireRemote("BuyItem", itemKey)
                bought = bought + 1
                task.wait(0.15)
            end
        end
        Library:Notify(("Buy Missing: bought %d items."):format(bought), 5)
        UpdateBuildLabel()
    end,
})
A1:AddToggle("LoadBuild", {
    Text = "Load Build",
    Default = false,
    Callback = function(state)
        if state then
            local t = task.spawn(function()
                while Toggles.LoadBuild.Value do
                    RunBuildFromSelectedSource()
                    task.wait(5)
                end
            end)
            Flags.LoadBuild = t
        else
            if Flags.LoadBuild and typeof(Flags.LoadBuild) == "thread" then
                task.cancel(Flags.LoadBuild)
                Flags.LoadBuild = nil
            end
        end
    end,
})
A1:AddInput("BuildSaveName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
    Callback = function() end,
})
A1:AddButton({
    Text = "Save Build",
    Func = function()
        SaveBuildToFile(Options.BuildSaveName and Options.BuildSaveName.Value or "")
    end,
})
A1:AddButton({
    Text = "Save Selected",
    Func = function()
        local saveName = Options.BuildSaveName and Options.BuildSaveName.Value or ""
        if not saveName or saveName == "" then Library:Notify("Enter a file name first.", 3) return end
        if not Support.FileIO then Library:Notify("File IO not supported by executor.", 4) return end
        local data = LoadSelectedBuildSource()
        if not data then return end
        local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
        if not ok or not json then Library:Notify("Failed to encode build data.", 4) return end
        local path = BUILD_SAVE_FOLDER .. "/" .. saveName .. ".json"
        pcall(function()
            if makefolder then pcall(makefolder, BUILD_SAVE_FOLDER) end
            writefile(path, json)
        end)
        local count = type(data.blocks) == "table" and #data.blocks or 0
        Library:Notify(("Selected build saved to %s (%d blocks)"):format(saveName, count), 5)
        notyuri("[CopyBuild] selected saved to", path)
        RefreshBuildSourcesDropdown()
    end,
})
task.spawn(function()
    task.wait(2)
    RefreshBuildSourcesDropdown()
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
Toggles.AutoUpgrade:OnChanged(function(v) Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v) end)
Toggles.AutoBuy:OnChanged(function(v) Thread("AutoBuy", SafeLoop("AutoBuy", Func_AutoBuy), v) end)
Toggles.AutoCraft:OnChanged(function(v) Thread("AutoCraft", SafeLoop("AutoCraft", Func_AutoCraft), v) end)
Toggles.AutoPlace:OnChanged(function(v) Thread("AutoPlace", SafeLoop("AutoPlace", Func_AutoPlace), v) end)
Toggles.AutoPickup:OnChanged(function(v) Thread("AutoPickup", SafeLoop("AutoPickup", Func_AutoPickup), v) end)
Toggles.AutoCollect:OnChanged(function(v) Thread("AutoCollect", SafeLoop("AutoCollect", Func_AutoCollect), v) end)
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
SaveManager:SetFolder("Yuri/AsmrTower")
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