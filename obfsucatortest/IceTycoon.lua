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
    GetPlayerData = RS:FindFirstChild("GetPlayerData") or RS:WaitForChild("GetPlayerData", 10),
    ClientEvent   = RS:FindFirstChild("ClientEvent") or RS:WaitForChild("ClientEvent", 10),
}
local Modules = {
}
local function GetCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local function GetHRP()
    local char = Plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end
local function TouchPart(part)
    if not part or not part:IsA("BasePart") then return false end
    local hrp = GetHRP()
    if not hrp then return false end
    if firetouchinterest then
        pcall(function()
            firetouchinterest(hrp, part, 0)
            task.wait()
            firetouchinterest(hrp, part, 1)
        end)
        return true
    end
    pcall(function()
        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
    end)
    return true
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
                hrp.CFrame = partCFrame * CFrame.new(0, 5, 0)
                task.wait(0.175)
            end
        end
    end
    fireproximityprompt(target)
end
local function GetCoins()
    local v = Plr:FindFirstChild("Coins")
    return v and v.Value or 0
end
local function GetPlayerData()
    if not Remotes.GetPlayerData then return nil end
    local ok, data = pcall(function() return Remotes.GetPlayerData:InvokeServer() end)
    if ok then return data end
    return nil
end
local function GetTycoon()
    return workspace:FindFirstChild("Tycoon")
end
local CATEGORY_COLORS = {
    ["Decorative"] = Color3.fromRGB(196, 40, 28),   
    ["Progress"]   = Color3.fromRGB(75, 151, 75),   
    ["Expansion"]  = Color3.fromRGB(13, 105, 172),  
    ["Achievement"]= Color3.fromRGB(200, 200, 0),   
}
local function GetButtonCategory(color)
    for cat, catColor in pairs(CATEGORY_COLORS) do
        if math.abs(color.R - catColor.R) < 0.01
        and math.abs(color.G - catColor.G) < 0.01
        and math.abs(color.B - catColor.B) < 0.01 then
            return cat
        end
    end
    return nil
end
local function GetAllTouchParts()
    local parts = {}
    local tycoon = GetTycoon()
    if not tycoon then return parts end
    local selectedCats = Options.AutoBuyFilter.Value 
    local function ScanButtonFolder(folder)
        if not folder then return end
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") then
                local touch = model:FindFirstChild("Touch")
                if touch and touch:IsA("BasePart") and touch:FindFirstChild("TouchInterest") then
                    local cat = GetButtonCategory(touch.Color)
                    local anySelected = selectedCats["Any"]
                    local catSelected = cat and selectedCats[cat]
                    if anySelected or catSelected then
                        table.insert(parts, touch)
                    end
                end
            end
        end
    end
    ScanButtonFolder(tycoon:FindFirstChild("Buttons"))
    ScanButtonFolder(tycoon:FindFirstChild("ExtraButtons"))
    return parts
end
local function Func_AutoCollect()
    while Toggles.AutoCollect.Value do
        if GetCharacter() then
            local tycoon = GetTycoon()
            local collector = tycoon and tycoon:FindFirstChild("Essentials")
                and tycoon.Essentials:FindFirstChild("Factory")
                and tycoon.Essentials.Factory:FindFirstChild("Collector")
            if collector then
                local main = collector:FindFirstChild("Main")
                if main then
                    TouchPart(main)
                end
            end
        end
        task.wait(0.175)
    end
end
local function Func_AutoCollectCrate()
    while Toggles.AutoCollectCrate.Value do
        local crates = workspace:FindFirstChild("Map")
            and workspace.Map:FindFirstChild("DrawBridge")
            and workspace.Map.DrawBridge:FindFirstChild("Crates")
        if crates then
            local root = GetHRP()
            local savedCF = root and root.CFrame
            for _, crate in ipairs(crates:GetChildren()) do
                if not Toggles.AutoCollectCrate.Value then break end
                root = GetHRP()
                if not root then break end
                local hull = crate:FindFirstChild("Hull")
                if hull then
                    root.CFrame = hull.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.2)
                end
            end
            root = GetHRP()
            if root and savedCF then
                root.CFrame = savedCF
            end
        end
        task.wait(.175)
    end
end
local function Func_AutoCollectGems()
    local pedestals = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Troops")
        and workspace.Map.Troops:FindFirstChild("GemPedestals")
    if pedestals then
        for _, pedestal in ipairs(pedestals:GetChildren()) do
            local hitbox = pedestal:FindFirstChild("Hitbox")
            if hitbox then
                TouchPart(hitbox)
            end
        end
    end
end
local function Func_AutoTrophy()
    local hotelHitbox = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("HotelHitbox")
    if hotelHitbox then
        TouchPart(hotelHitbox)
        task.wait(1)
        local tycoon = GetTycoon()
        local collector = tycoon and tycoon:FindFirstChild("Essentials")
            and tycoon.Essentials:FindFirstChild("Factory")
            and tycoon.Essentials.Factory:FindFirstChild("Collector")
        if collector then
            local main = collector:FindFirstChild("Main")
            if main then
                TouchPart(main)
            end
        end
    end
    local squarePP = GetObject(workspace, "Map.Pedestals.SquarePedestal.Union.ProximityPrompt")
    if squarePP then FirePP(squarePP, true) end
    local circlePP = GetObject(workspace, "Map.Pedestals.CirclePedestal.Union.ProximityPrompt")
    if circlePP then FirePP(circlePP, true) end
    local trianglePP = GetObject(workspace, "Map.Pedestals.TrianglePedestal.Union.ProximityPrompt")
    if trianglePP then FirePP(trianglePP, true) end
end
local DOME_PATHS = { "Farm.Dome", "Dome2", "Dome3", "Dome4" }
local function GetContainer()
    for _, tool in ipairs(Plr.Backpack:GetChildren()) do
        if (tool:IsA("Tool") or tool:IsA("HopperBin")) and tool.ToolTip == "Scoop the water." then
            return tool
        end
    end
    local char = Plr.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if (tool:IsA("Tool") or tool:IsA("HopperBin")) and tool.ToolTip == "Scoop the water." then
                return tool
            end
        end
    end
    return nil
end
local function GetWaterLevel()
    local water = PGui:FindFirstChild("ScreenGui")
        and PGui.ScreenGui:FindFirstChild("Water")
    local label = water and water:FindFirstChild("TextLabel")
    if not label then return nil, nil end
    local cur, max = label.Text:match("(%d+)%s*/%s*(%d+)")
    return tonumber(cur), tonumber(max)
end
local function GetWater()
    local canteen = GetContainer()
    if not canteen then return false end
    local char = Plr.Character
    if char then
        canteen.Parent = char
        task.wait(.1)
    end
    local tubPP = GetObject(workspace, "Tycoon.ExtraBought.WaterTub.Bucket.ProximityPrompt")
    if tubPP and tubPP.Enabled then
        FirePP(tubPP, true)
        task.wait()
        return true
    end
    local waters = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Waters")
    if waters then
        for _, waterSrc in ipairs(waters:GetChildren()) do
            local pp = waterSrc:FindFirstChild("ProximityPrompt")
            if pp and pp.Enabled then
                FirePP(pp, true)
                task.wait()
                return true
            end
        end
    end
    return false
end
local function Func_AutoPump()
    while Toggles.AutoFill.Value do
        local cur, max = GetWaterLevel()
        local threshold = Options.FillWhen.Value / 100
        if cur and max and max > 0 and (cur / max) <= threshold then
            if not GetWater() then
                task.wait(1)
                continue
            end
            local pumpPP = GetObject(workspace, "Tycoon.Essentials.Pump.Main.ProximityPrompt")
            if pumpPP then
                FirePP(pumpPP, true)
                task.wait()
            end
        end
        task.wait(.5)
    end
end
local function Func_AutoClean()
    while Toggles.AutoClean.Value do
        local waterButtons = GetObject(workspace, "Tycoon.Essentials.Factory.WaterButtons")
        if waterButtons then
            for _, desc in ipairs(waterButtons:GetDescendants()) do
                if not Toggles.AutoClean.Value then break end
                if desc:IsA("ProximityPrompt") and desc.ActionText == "Clean" and desc.Enabled then
                    if not GetWater() then
                        task.wait(1)
                        continue
                    end
                    FirePP(desc, true)
                    task.wait()
                end
            end
        end
        task.wait(.5)
    end
end
local function Func_AutoDropper()
    while Toggles.AutoDropper.Value do
        local bought = GetTycoon() and GetTycoon():FindFirstChild("Bought")
        if bought then
            for _, floor in ipairs(bought:GetChildren()) do
                if not Toggles.AutoDropper.Value then break end
                local dropper = floor:FindFirstChild("Dropper")
                if dropper then
                    local title = dropper:FindFirstChild("ui")
                        and dropper.ui:FindFirstChild("Code")
                        and dropper.ui.Code:FindFirstChild("Title")
                    local pp = dropper:FindFirstChild("Start")
                        and dropper.Start:FindFirstChild("Button")
                        and dropper.Start.Button:FindFirstChild("ProximityPrompt")
                    if title and pp then
                        local cur, max = title.Text:match("(%d+)%s*/%s*(%d+)")
                        cur, max = tonumber(cur), tonumber(max)
                        if cur and max and cur < max then
                            FirePP(pp, true)
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoHarvest()
    while Toggles.AutoHarvest.Value do
        local bought = GetTycoon() and GetTycoon():FindFirstChild("Bought")
        if bought then
            for _, domePath in ipairs(DOME_PATHS) do
                if not Toggles.AutoHarvest.Value then break end
                local dome = GetObject(bought, domePath)
                if dome then
                    local ground = dome:FindFirstChild("Ground")
                    local pp = ground and ground:FindFirstChild("ProximityPrompt")
                    if pp and pp.ActionText == "Harvest" and pp.Enabled then
                        FirePP(pp, true)
                        task.wait()
                    end
                end
            end
        end
        task.wait(.175)
    end
end
local function Func_AutoMine()
    while Toggles.AutoMine.Value do
        local bought = GetTycoon() and GetTycoon():FindFirstChild("Bought")
        if bought then
            for _, child in ipairs(bought:GetChildren()) do
                if not Toggles.AutoMine.Value then break end
                if child:IsA("Model") and child.Name:lower():find("mine") then
                    for _, pp in ipairs(child:GetDescendants()) do
                        if not Toggles.AutoMine.Value then break end
                        if pp:IsA("ProximityPrompt") and pp.ActionText == "Mine" and pp.Enabled then
                            FirePP(pp, true)
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(0.175)
    end
end
local function Func_AutoBuy()
    while Toggles.AutoBuy.Value do
        local parts = GetAllTouchParts()
        for _, part in ipairs(parts) do
            if not Toggles.AutoBuy.Value then break end
            TouchPart(part)
            task.wait(0.1)
        end
        task.wait()
    end
end
local function Func_AutoMapBuy()
    while Toggles.AutoMapBuy.Value do
        local filter = Options.ToolList.Value
        local mapPPs = {
            { key = "Tool",    pp = GetObject(workspace, "Map.BuyTool.ProximityPrompt") },
            { key = "Crystal", pp = GetObject(workspace, "Map.BuyCrystal.ProximityPrompt") },
        }
        for _, entry in ipairs(mapPPs) do
            if not Toggles.AutoMapBuy.Value then break end
            local pp = entry.pp
            if not pp or not pp.Enabled then continue end
            if not filter["Any"] and not filter[entry.key] then continue end
            local cost = pp.ActionText:match("(%d[%d,]*)%$")
            cost = cost and tonumber((cost:gsub(",", "")))
            if cost and GetCoins() < cost then continue end
            FirePP(pp, true)
            task.wait()
        end
        task.wait(.5)
    end
end
local function Func_LoopUpgraders()
    while Toggles.LoopUpgraders.Value do
        local tycoon = GetTycoon()
        local partsFolder = tycoon and tycoon:FindFirstChild("Parts")
        local bought = tycoon and tycoon:FindFirstChild("Bought")
        if partsFolder and bought then
            local ores = partsFolder:GetChildren()
            for _, upgraderModel in ipairs(bought:GetChildren()) do
                if not Toggles.LoopUpgraders.Value then break end
                local upgraderPart = upgraderModel:FindFirstChild("Part")
                if upgraderPart and upgraderPart:IsA("BasePart") and upgraderPart:FindFirstChild("TouchInterest") then
                    for _, orePart in ipairs(ores) do
                        if not Toggles.LoopUpgraders.Value then break end
                        if orePart:IsA("BasePart") and firetouchinterest then
                            pcall(function()
                                firetouchinterest(orePart, upgraderPart, 0)
                                task.wait()
                                firetouchinterest(orePart, upgraderPart, 1)
                            end)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoTouchAll()
    while Toggles.AutoTouchAll.Value do
        local tycoon = GetTycoon()
        if tycoon then
            for _, desc in ipairs(tycoon:GetDescendants()) do
                if not Toggles.AutoTouchAll.Value then break end
                local ti = desc:IsA("BasePart") and desc:FindFirstChild("TouchInterest")
                if ti then
                    TouchPart(desc)
                    task.wait(0.05)
                end
            end
        end
        task.wait(2)
    end
end
local function TeleportToTycoon()
    local tycoon = GetTycoon()
    if not tycoon then return end
    local hrp = GetHRP()
    if not hrp then return end
    local spawnPart = tycoon:FindFirstChild("Essentials") and tycoon.Essentials:FindFirstChild("Conveyor")
    if spawnPart and spawnPart:IsA("Model") then
        local part = spawnPart:FindFirstChildWhichIsA("BasePart")
        if part then
            hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
            return
        end
    end
    pcall(function()
        hrp.CFrame = tycoon:GetPivot() + Vector3.new(0, 5, 0)
    end)
end
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
        T2 = TB.Main.Left.Autofarm:AddTab("Badge"),
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
TB_Tabs.Autofarm.T1:AddToggle("AutoCollect", { Text = "Auto Coins", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectCrate", { Text = "Auto Crates", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoFill", { Text = "Auto Fill", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoClean", { Text = "Auto Clean", Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("FillWhen", { Text = "Fill When %", Default = 50, Min = 1, Max = 100, Rounding = 0, Compact = true })
TB_Tabs.Autofarm.T1:AddToggle("AutoHarvest", { Text = "Auto Harvest", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMine", { Text = "Auto Mine", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoDropper", { Text = "Auto Dropper", Default = false })
TB_Tabs.Autofarm.T2:AddButton({ Text = "Collect Gems", Func = function() task.spawn(Func_AutoCollectGems) end })
TB_Tabs.Autofarm.T2:AddButton({ Text = "Collect Trophies", Func = function() task.spawn(Func_AutoTrophy) end })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", { Text = "Auto Buy", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("AutoBuyFilter", {
    Text = "Buy List",
    Values = { "Any", "Decorative", "Progress", "Expansion", "Achievement" },
    Default = { "Any" },
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoMapBuy", { Text = "Auto Buy Tool", Default = false })
TB_Tabs.Autofarm2.T1:AddDropdown("ToolList", {
    Text = "Tool List",
    Values = { "Any", "Tool", "Crystal" },
    Default = { "Any" },
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddButton({
    Text = "Teleport to Tycoon",
    Func = function() TeleportToTycoon() end,
})
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
Toggles.AutoCollect:OnChanged(function(v)
    Thread("AutoCollect", SafeLoop("AutoCollect", Func_AutoCollect), v)
end)
Toggles.AutoCollectCrate:OnChanged(function(v)
    Thread("AutoCollectCrate", SafeLoop("AutoCollectCrate", Func_AutoCollectCrate), v)
end)
Toggles.AutoBuy:OnChanged(function(v)
    Thread("AutoBuy", SafeLoop("AutoBuy", Func_AutoBuy), v)
end)
Toggles.AutoMapBuy:OnChanged(function(v)
    Thread("AutoMapBuy", SafeLoop("AutoMapBuy", Func_AutoMapBuy), v)
end)
Toggles.AutoFill:OnChanged(function(v)
    Thread("AutoFill", SafeLoop("AutoFill", Func_AutoPump), v)
end)
Toggles.AutoClean:OnChanged(function(v)
    Thread("AutoClean", SafeLoop("AutoClean", Func_AutoClean), v)
end)
Toggles.AutoHarvest:OnChanged(function(v)
    Thread("AutoHarvest", SafeLoop("AutoHarvest", Func_AutoHarvest), v)
end)
Toggles.AutoMine:OnChanged(function(v)
    Thread("AutoMine", SafeLoop("AutoMine", Func_AutoMine), v)
end)
Toggles.AutoDropper:OnChanged(function(v)
    Thread("AutoDropper", SafeLoop("AutoDropper", Func_AutoDropper), v)
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
SaveManager:SetFolder("Yuri/IceTycoon2")
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
