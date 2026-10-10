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
checkcaller = missing("function", checkcaller, function() return true end)
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
local assetName = "Uma Tower Defense"
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
    Hook = (typeof(hookmetamethod) == "function" and typeof(getnamecallmethod) == "function" and typeof(newcclosure) == "function"),
}
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
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2026/02/01/15/33/44/140636490_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2022/08/15/23/52/23/100515820_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2025/07/22/17/09/45/132989170_p0_master1200.jpg",
    "https://i.pximg.net/c/1200x1200_80_webp/img-master/img/2019/12/01/21/59/30/78092730_p0_master1200.jpg",
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
local repo         = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
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
            local inviteCode = "6pCsSbVd3E"
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
local SignalR = RS:WaitForChild("SignalR", 15)
local SignalE = RS:WaitForChild("SignalE", 15)
local initStart = tick()
repeat
    task.wait()
until workspace:GetAttribute("FinishedInitialize") or (tick() - initStart) > 1
local GameRemoteSignal = nil
pcall(function()
    GameRemoteSignal = require(game:GetService("ReplicatedFirst").Initialize.Initialize.Addons.GrapeSalt.GrapeModules.RemoteSignal)
end)
notyuri("[DEBUG] GameRemoteSignal:", typeof(GameRemoteSignal), "OnEvent:", tostring(GameRemoteSignal and typeof(GameRemoteSignal.OnEvent)))
local function SafeInvoke(name, ...)
    local args = { ... }
    local done = false
    local result = nil
    task.spawn(function()
        local ok, res = nil, nil
        if GameRemoteSignal and GameRemoteSignal.InvokeServer then
            ok, res = pcall(GameRemoteSignal.InvokeServer, GameRemoteSignal, name, table.unpack(args))
        elseif SignalR then
            ok, res = pcall(function()
                return SignalR:InvokeServer(name, {}, table.unpack(args))
            end)
        end
        if ok then
            result = res
        end
        done = true
    end)
    local start = tick()
    while not done and (tick() - start) < 5 do
        task.wait()
    end
    return result
end
local function SafeFire(name, ...)
    local args = { ... }
    if GameRemoteSignal and GameRemoteSignal.FireServer then
        pcall(GameRemoteSignal.FireServer, GameRemoteSignal, name, table.unpack(args))
    elseif SignalE then
        pcall(function()
            SignalE:FireServer(name, {}, table.unpack(args))
        end)
    end
end
local function OnGameEvent(name, handler)
    if not (GameRemoteSignal and GameRemoteSignal.OnEvent) then
        notyuri("[DEBUG] OnGameEvent early-out:", name, "GameRemoteSignal:", typeof(GameRemoteSignal))
        return false
    end
    local ok, err = pcall(GameRemoteSignal.OnEvent, GameRemoteSignal, name, handler)
    if not ok then
        notyuri("[DEBUG] OnGameEvent pcall failed:", name, "err:", tostring(err))
    end
    return ok
end
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
local Flags = {}
local Shared = {}
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
        elseif typeof(value) == "thread" then
            task.cancel(value)
            tbl[key] = nil
        elseif type(value) == "table" then
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
        if activeThread and typeof(activeThread) == "thread" then
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
local function InMatch()
    return workspace:GetAttribute("Gameplay") == true
end
local function GetStateFolder()
    return RS:FindFirstChild("State")
end
local function GetWave()
    local state = GetStateFolder()
    local wave = state and state:FindFirstChild("Wave")
    return wave and wave.Value or 0
end
local function GetWaveFinal()
    local state = GetStateFolder()
    local wave = state and state:FindFirstChild("Wave")
    local final = wave and wave:FindFirstChild("Final")
    return final and final.Value or 0
end
local function GetRemainingTime()
    local state = GetStateFolder()
    local timer = state and state:FindFirstChild("Timer")
    return timer and timer.Value or nil
end
local function GetCashValue()
    local rt = Plr:FindFirstChild("RuntimeData")
    return rt and rt:FindFirstChild("Cash") or nil
end
local function GetCash()
    local cv = GetCashValue()
    return cv and cv.Value or 0
end
local function GetSpendingMult()
    local state = GetStateFolder()
    local m = state and state:FindFirstChild("SpendingMultiplier")
    return m and m.Value or 1
end
local function GetMatchLabel()
    local state = GetStateFolder()
    local ms = state and state:FindFirstChild("MatchState")
    if not ms then return "Unknown" end
    local parts = {}
    for _, k in ipairs({"Scenario", "Chapter", "Episode", "Difficulty"}) do
        local val = ms:FindFirstChild(k)
        if val then table.insert(parts, tostring(val.Value)) end
    end
    if #parts == 0 then return "Unknown" end
    return table.concat(parts, " / ")
end
local function GetTowersFolder()
    local state = workspace:FindFirstChild("State")
    return state and state:FindFirstChild("Towers") or nil
end
local function IsOwnedTower(model)
    return model ~= nil and model:IsA("Model") and model:GetAttribute("Owner") == Plr.UserId
end
local function CountPlacedByName(unitName)
    local folder = GetTowersFolder()
    if not folder then return 0 end
    local count = 0
    for _, model in ipairs(folder:GetChildren()) do
        if model.Name == unitName and IsOwnedTower(model) then
            count = count + 1
        end
    end
    return count
end
local function GetTowerLevel(tower)
    local total = 0
    for i = 1, 5 do
        local pl = tower:GetAttribute("PathLevel" .. i)
        if type(pl) == "number" then
            total = total + (pl - 1)
        end
    end
    return total
end
local DataCache = { Data = nil, Time = 0 }
local function GetData(force)
    if not force and DataCache.Data and (tick() - DataCache.Time) < 1 then
        return DataCache.Data
    end
    local res = SafeInvoke("Get Data")
    if type(res) == "table" then
        DataCache.Data = res
        DataCache.Time = tick()
    end
    return DataCache.Data
end
local function Func_RemoveDuplicates()
    local data = GetData(true)
    if type(data) ~= "table" then
        Library:Notify("Failed to fetch data", 4)
        return
    end
    local equipTowers = type(data.Equipment) == "table" and data.Equipment.Towers or nil
    local invTowers = type(data.UnitInventory) == "table" and data.UnitInventory.Towers or nil
    if type(equipTowers) ~= "table" or type(invTowers) ~= "table" then
        Library:Notify("Unexpected data shape, aborted", 4)
        return
    end
    local equipped = {}
    for _, guid in pairs(equipTowers) do
        equipped[guid] = true
    end
    local groups = {}
    for guid, unit in pairs(invTowers) do
        if type(unit) == "table" and type(unit.Name) == "string" then
            local key = unit.Name .. tostring(unit.Costume)
            groups[key] = groups[key] or {}
            table.insert(groups[key], guid)
        end
    end
    local toSell = {}
    for _, guids in pairs(groups) do
        if #guids > 1 then
            local kept = false
            for _, guid in ipairs(guids) do
                if equipped[guid] then
                    kept = true
                end
            end
            for _, guid in ipairs(guids) do
                if kept then
                    if not equipped[guid] then
                        table.insert(toSell, guid)
                    end
                else
                    if not kept then
                        table.insert(toSell, guid)
                        kept = true
                    end
                end
            end
        end
    end
    notyuri("[RemoveDuplicates] ToSell count:", #toSell)
    if #toSell > 0 then
        local result = SafeInvoke("Bulk Sell Unit Items", { Items = toSell })
        notyuri("[RemoveDuplicates] Sell result:", tostring(result))
        Library:Notify("Sold " .. #toSell .. " duplicate unit(s)", 4)
    else
        Library:Notify("No duplicates found", 3)
    end
end
local function GetLoadout()
    local data = GetData()
    if type(data) ~= "table" then return {} end
    local equip = data.Equipment
    equip = type(equip) == "table" and equip.Towers or nil
    local inv = data.UnitInventory
    inv = type(inv) == "table" and inv.Towers or nil
    if type(equip) ~= "table" or type(inv) ~= "table" then return {} end
    local list = {}
    for slot, key in pairs(equip) do
        if type(slot) == "number" then
            local entry = inv[key]
            if type(entry) == "table" and type(entry.Name) == "string" then
                table.insert(list, {
                    Slot = slot,
                    Key = key,
                    Name = entry.Name,
                    Costume = type(entry.Costume) == "string" and entry.Costume or "Default",
                    StarLevel = type(entry.StarLevel) == "number" and entry.StarLevel or 1,
                })
            end
        end
    end
    table.sort(list, function(a, b) return a.Slot < b.Slot end)
    return list
end
local function GetSlotByTowerName(unitName)
    for _, entry in ipairs(GetLoadout()) do
        if entry.Name == unitName then
            return entry.Slot
        end
    end
    return nil
end
local function GetSlotDisplayNames()
    local names = {}
    for _, entry in ipairs(GetLoadout()) do
        table.insert(names, "Slot " .. entry.Slot .. " (" .. entry.Name .. ")")
    end
    return names
end
local function SlotDisplayToNumber(display)
    local n = display and display:match("^Slot (%d+)")
    return n and tonumber(n) or nil
end
local function GetTowerAssetStats(towerName, costume)
    local assets = RS:FindFirstChild("Assets")
    local towers = assets and assets:FindFirstChild("Towers")
    local base = towers and towers:FindFirstChild(towerName)
    local statsModule = base and base:FindFirstChild("Stats")
    if not (statsModule and statsModule:IsA("ModuleScript")) then return nil end
    local ok, mod = pcall(require, statsModule)
    if not ok or type(mod) ~= "table" then return nil end
    local stats = (costume and costume ~= "Default" and mod[costume]) or mod.Default
    if typeof(stats) == "Instance" then
        local ok2, res = pcall(require, stats)
        if ok2 and type(res) == "table" then
            stats = res
        end
    end
    if type(stats) ~= "table" then return nil end
    return stats
end
local function GetTowerUpgrades(tower)
    local statsModule = tower:FindFirstChild("Stats")
    if not (statsModule and statsModule:IsA("ModuleScript")) then return nil end
    local ok, stats = pcall(require, statsModule)
    if not ok or type(stats) ~= "table" or type(stats.Upgrades) ~= "table" then return nil end
    return stats
end
local function GetUpgradeCost(tower, pathIndex)
    local stats = GetTowerUpgrades(tower)
    if not stats then return nil end
    local path = stats.Upgrades[pathIndex]
    if type(path) ~= "table" then return nil end
    local nextUp = path[(tower:GetAttribute("PathLevel" .. pathIndex) or 1) + 1]
    if type(nextUp) ~= "table" or type(nextUp.Cost) ~= "number" then return nil end
    local hint = tower:GetAttribute("HintLvl") or 0
    return math.floor(nextUp.Cost * (1 - 0.05 * hint))
end
local Spiral = { Points = {}, X = 0, Z = 0, DX = 1, DZ = 0, SegLen = 1, Stepped = 0, Turns = 0 }
local function GetSpiralOffset(index)
    while #Spiral.Points < index do
        table.insert(Spiral.Points, { Spiral.X, Spiral.Z })
        Spiral.X = Spiral.X + Spiral.DX
        Spiral.Z = Spiral.Z + Spiral.DZ
        Spiral.Stepped = Spiral.Stepped + 1
        if Spiral.Stepped == Spiral.SegLen then
            Spiral.Stepped = 0
            Spiral.DX, Spiral.DZ = -Spiral.DZ, Spiral.DX
            Spiral.Turns = Spiral.Turns + 1
            if Spiral.Turns % 2 == 0 then
                Spiral.SegLen = Spiral.SegLen + 1
            end
        end
    end
    local p = Spiral.Points[index]
    return p[1], p[2]
end
local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude
local function RaycastPlacement(pos)
    local exclude = {}
    local state = workspace:FindFirstChild("State")
    if state then table.insert(exclude, state) end
    local char = Plr.Character
    if char then table.insert(exclude, char) end
    RayParams.FilterDescendantsInstances = exclude
    return workspace:Raycast(pos + Vector3.new(0, 25, 0), Vector3.new(0, -100, 0), RayParams)
end
local AP = {
    SlotCursor = {},
    SlotsLabelRef = nil,
    SlotPositions = {},
    PosLabelRef = nil,
}
local function PosText(mapName)
    if not mapName or not AP.SlotPositions[mapName] then return "No positions set" end
    local lines = {}
    for slot, cf in pairs(AP.SlotPositions[mapName]) do
        local unitName
        for _, entry in ipairs(GetLoadout()) do
            if entry.Slot == slot then unitName = entry.Name end
        end
        table.insert(lines, "Slot " .. slot .. (unitName and (" (" .. unitName .. ")") or "") .. ": set")
    end
    if #lines == 0 then return "No positions set" end
    table.sort(lines)
    return table.concat(lines, "\n")
end
local function UpdatePosLabels()
    local mapName = GetMatchLabel()
    if AP.PosLabelRef then
        pcall(function()
            AP.PosLabelRef:SetText(PosText(mapName))
        end)
    end
end
local function HandleSlotPos(act, slot)
    local mapName = GetMatchLabel()
    if not mapName or mapName == "Unknown" then
        Library:Notify("Not in a match — map not detected", 3)
        return
    end
    if act == "reset" then
        if slot then
            if AP.SlotPositions[mapName] then AP.SlotPositions[mapName][slot] = nil end
            Library:Notify("Slot " .. slot .. " position cleared (" .. mapName .. ")", 3)
            notyuri("[AutoPlay] ResetPos slot=" .. slot .. " map=" .. mapName)
        else
            AP.SlotPositions[mapName] = nil
            Library:Notify("All positions cleared (" .. mapName .. ")", 3)
            notyuri("[AutoPlay] ResetPos all map=" .. mapName)
        end
        UpdatePosLabels()
        return
    end
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Library:Notify("Character not found", 3)
        return
    end
    local cf = CFrame.new(hrp.Position)
    if not AP.SlotPositions[mapName] then AP.SlotPositions[mapName] = {} end
    if act == "set" then
        AP.SlotPositions[mapName][slot] = cf
        Library:Notify("Slot " .. slot .. " position saved (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] SetPos slot=" .. slot .. " map=" .. mapName)
    elseif act == "massset" then
        for _, entry in ipairs(GetLoadout()) do
            AP.SlotPositions[mapName][entry.Slot] = cf
        end
        Library:Notify("All slots saved (" .. mapName .. ")", 3)
        notyuri("[AutoPlay] MassSetPos map=" .. mapName)
    end
    UpdatePosLabels()
end
local function SetPos(slot) HandleSlotPos("set", slot) end
local function MassSetPos() HandleSlotPos("massset") end
local function ResetPos(slot) HandleSlotPos("reset", slot) end
local function TryPlaceSlot(entry, stats)
    local map = workspace:FindFirstChild("Map")
    local placements = map and map:FindFirstChild("Placements")
    if not placements then return false end
    local placementType = type(stats) == "table" and stats.PlacementType or "Ground"
    local area = placements:FindFirstChild(placementType)
    if not area then return false end
    local hover = (type(stats) == "table" and type(stats.Hover) == "number" and stats.Hover) or 2
    local spacing = (type(stats) == "table" and type(stats.PlacementHitbox) == "number" and stats.PlacementHitbox or 3) + 1.5
    local mapName = GetMatchLabel()
    local savedCF = mapName and AP.SlotPositions[mapName] and AP.SlotPositions[mapName][entry.Slot]
    if savedCF then
        local res = SafeInvoke("Place Tower", {
            Tower = entry.Name,
            TowerKey = entry.Slot,
            Costume = entry.Costume,
            SpawnPoint = savedCF * CFrame.new(0, hover, 0),
        })
        if res == true then return true end
    end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local cursor = AP.SlotCursor[entry.Slot] or 0
    local tried = 0
    while tried < 8 do
        cursor = cursor + 1
        tried = tried + 1
        local ox, oz = GetSpiralOffset(cursor)
        local pos = Vector3.new(hrp.Position.X + ox * spacing, hrp.Position.Y, hrp.Position.Z + oz * spacing)
        local hit = RaycastPlacement(pos)
        if hit and hit.Instance:IsDescendantOf(area) then
            local spawnCF = CFrame.new(hit.Position) * CFrame.new(0, hover, 0)
            local res = SafeInvoke("Place Tower", {
                Tower = entry.Name,
                TowerKey = entry.Slot,
                Costume = entry.Costume,
                SpawnPoint = spawnCF,
            })
            AP.SlotCursor[entry.Slot] = cursor
            return res == true
        end
    end
    AP.SlotCursor[entry.Slot] = cursor
    return false
end
local function GetSlotPlaceLimit(slot, towerName, costume)
    local stats = GetTowerAssetStats(towerName, costume)
    local gameLimit = 8
    if type(stats) == "table" then
        gameLimit = stats.PlacementLimit or stats.GlobalPlacementLimit or 8
    end
    local opt = Options["PlaceLimit" .. slot]
    local userLimit = opt and tonumber(opt.Value) or 0
    if userLimit > 0 then
        return math.min(userLimit, gameLimit)
    end
    return gameLimit
end
local function PlacePhase()
    if not InMatch() then return false end
    local folder = GetTowersFolder()
    if not folder then return false end
    local loadout = GetLoadout()
    if #loadout == 0 then return false end
    local order = {}
    for _, entry in ipairs(loadout) do
        local orderOpt = Options["APPlaceOrder" .. entry.Slot]
        table.insert(order, { Entry = entry, Order = (orderOpt and tonumber(orderOpt.Value)) or entry.Slot })
    end
    table.sort(order, function(a, b) return a.Order < b.Order end)
    local allPlaced = true
    for _, item in ipairs(order) do
        if not Toggles.AutoPlay.Value then break end
        local entry = item.Entry
        local waveOpt = Options["APPlaceWave" .. entry.Slot]
        local waveGate = (waveOpt and tonumber(waveOpt.Value)) or 0
        if GetWave() < waveGate then
            allPlaced = false
            continue
        end
        local limit = GetSlotPlaceLimit(entry.Slot, entry.Name, entry.Costume)
        local placed = CountPlacedByName(entry.Name)
        if placed >= limit then
            continue
        end
        local stats = GetTowerAssetStats(entry.Name, entry.Costume)
        local cost = type(stats) == "table" and type(stats.PlacementCost) == "number" and (stats.PlacementCost * GetSpendingMult()) or nil
        if not cost then
            continue
        end
        if GetCash() < cost then
            allPlaced = false
            continue
        end
        TryPlaceSlot(entry, stats)
        allPlaced = false
    end
    return allPlaced
end
local function DoUpgradePhase()
    if not InMatch() then return false end
    local folder = GetTowersFolder()
    if not folder then return false end
    local didAny = false
    for _, tower in ipairs(folder:GetChildren()) do
        if not (Toggles.AutoUpgrade.Value or (Toggles.PlaceAndUpgrade and Toggles.PlaceAndUpgrade.Value)) then break end
        if not IsOwnedTower(tower) then continue end
        local slot = GetSlotByTowerName(tower.Name)
        if slot then
            local upOpt = Options["UpgradeLimit" .. slot]
            local upLimit = (upOpt and tonumber(upOpt.Value)) or 0
            if upLimit > 0 and GetTowerLevel(tower) >= upLimit then
                continue
            end
        end
        local stats = GetTowerUpgrades(tower)
        if not stats then continue end
        for i = 1, #stats.Upgrades do
            local path = stats.Upgrades[i]
            if type(path) ~= "table" then continue end
            local nextUp = path[(tower:GetAttribute("PathLevel" .. i) or 1) + 1]
            if type(nextUp) == "table" and type(nextUp.Cost) == "number" then
                local hint = tower:GetAttribute("HintLvl") or 0
                local cost = math.floor(nextUp.Cost * (1 - 0.05 * hint))
                if cost <= GetCash() then
                    local res = SafeInvoke("Upgrade Tower", tower, i)
                    if res and type(res) ~= "string" then
                        didAny = true
                    end
                end
            end
        end
    end
    return didAny
end
local function Func_AutoPlay()
    while Toggles.AutoPlay.Value do
        if not InMatch() then
            task.wait()
        else
            local allPlaced = PlacePhase()
            if Toggles.PlaceAndUpgrade.Value or (Toggles.AutoUpgrade.Value and allPlaced) then
                local didUpgrade = DoUpgradePhase()
                if not didUpgrade then
                    task.wait()
                end
            end
            task.wait()
        end
    end
end
local MDir = "Yuri/UmaTD/Macros"
local MState = {
    Rec = false,
    Rep = false,
    Cur = nil,
    Load = nil,
    Step = 0,
    Total = 0,
    LabelRef = nil,
    Hooked = false,
    CurWave = 0,
    WaveStartClock = 0,
    PendingLabel = nil,
}
local function GetCurrentWave()
    return GetWave()
end
local function GetTimeString()
    local remaining = GetRemainingTime()
    return tostring(GetCurrentWave()) .. " " .. tostring(remaining or 0)
end
local function UpdateLabel(suffix, elapsed)
    if not (MState.LabelRef and MState.LabelRef.SetText) then return end
    local txt
    local timeStr = ""
    if type(elapsed) == "number" then
        timeStr = string.format(" [%.2fs]", elapsed)
    elseif type(elapsed) == "string" then
        timeStr = " [" .. elapsed .. "]"
    end
    if MState.Rec then
        if suffix then
            txt = string.format("Recording [%d] %s%s", MState.Step, suffix, timeStr)
        else
            txt = string.format("Recording [%d]", MState.Step)
        end
    elseif MState.Rep then
        txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
        if suffix then txt = txt .. " | " .. suffix .. timeStr end
    else
        txt = "Idle"
        if suffix then txt = txt .. " | " .. suffix end
    end
    if MState.Rec then
        MState.PendingLabel = txt
    else
        local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
        if not ok then
            MState.PendingLabel = txt
        end
    end
end
local function LabelPump()
    while MState.Rec do
        if MState.PendingLabel then
            local txt = MState.PendingLabel
            MState.PendingLabel = nil
            pcall(function() MState.LabelRef:SetText(txt) end)
        end
        task.wait()
    end
end
local function CommitEntry(entry, labelSuffix)
    if not MState.Rec or not MState.Cur then return end
    MState.Step = MState.Step + 1
    MState.Cur[MState.Step] = entry
    UpdateLabel(labelSuffix or entry.Type, entry.Time)
end
local function GetTowerRef(model)
    local folder = GetTowersFolder()
    if not folder then return tostring(model) end
    local name = model.Name
    local idx = 0
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name == name and IsOwnedTower(child) then
            idx = idx + 1
            if child == model then
                return name .. " - " .. idx
            end
        end
    end
    return name .. " - 1"
end
local function FindTowerByRef(ref)
    if type(ref) ~= "string" then return nil end
    local name, idxStr = ref:match("^(.+)%s%-%s(%d+)$")
    if not name or not idxStr then return nil end
    local folder = GetTowersFolder()
    if not folder then return nil end
    local targetIdx = tonumber(idxStr)
    local count = 0
    for _, child in ipairs(folder:GetChildren()) do
        if child.Name == name and IsOwnedTower(child) then
            count = count + 1
            if count == targetIdx then return child end
        end
    end
    return nil
end
local function LoadMDir()
    if not writefile then return end
    pcall(function()
        if not isfolder(MDir) then
            makefolder(MDir)
        end
    end)
end
local function ListMacros()
    local names = {}
    if not listfiles then return names end
    local ok, files = pcall(listfiles, MDir)
    if not ok or type(files) ~= "table" then return names end
    for _, path in ipairs(files) do
        if type(path) == "string" and path:sub(-5):lower() == ".json" then
            local fname = path:match("([^/\\]+)%.json$")
            if fname and fname ~= "" then table.insert(names, fname) end
        end
    end
    table.sort(names)
    return names
end
local function LoadMacro(name)
    if not name or name == "" or not readfile then return nil end
    local path = MDir .. "/" .. name .. ".json"
    if not isfile(path) then return nil end
    local ok, raw = pcall(readfile, path)
    if not ok or type(raw) ~= "string" or raw == "" then return nil end
    local data
    pcall(function() data = HttpService:JSONDecode(raw) end)
    if type(data) ~= "table" then return nil end
    return data
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    local path = MDir .. "/" .. name .. ".json"
    local ok = pcall(function()
        writefile(path, HttpService:JSONEncode(macro))
    end)
    return ok
end
local function StartRec()
    if MState.Hooked then return end
    if not Support.Hook then
        Library:Notify("Executor does not support hookmetamethod, macro recording unavailable", 6)
        return
    end
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local self = ...
        local Method = getnamecallmethod()
        local ret = table.pack(originalNamecall(...))
        if MState.Rec and not checkcaller() then
            if Method == "InvokeServer" and rawequal(self, SignalR) then
                local name = select(2, ...)
                if name == "Place Tower" then
                    local placeArgs = select(4, ...)
                    if type(placeArgs) == "table" and type(placeArgs.Tower) == "string"
                        and typeof(placeArgs.SpawnPoint) == "CFrame" and ret[1] == true then
                        local comps = table.pack(placeArgs.SpawnPoint:GetComponents())
                        local cf = {}
                        for i = 1, comps.n do
                            cf[i] = comps[i]
                        end
                        CommitEntry({
                            Type = "Place",
                            Time = GetTimeString(),
                            Tower = placeArgs.Tower,
                            Key = placeArgs.TowerKey,
                            Costume = placeArgs.Costume,
                            CF = cf,
                        }, "Place " .. placeArgs.Tower)
                    end
                elseif name == "Upgrade Tower" then
                    local model = select(4, ...)
                    local path = select(5, ...)
                    if typeof(model) == "Instance" and ret[1] and type(ret[1]) ~= "string" then
                        local ref = GetTowerRef(model)
                        CommitEntry({
                            Type = "Upgrade",
                            Time = GetTimeString(),
                            Ref = ref,
                            Path = path,
                        }, "Upgrade " .. ref)
                    end
                elseif name == "Sell Tower" then
                    local model = select(4, ...)
                    if typeof(model) == "Instance" and ret[1] then
                        local ref = GetTowerRef(model)
                        task.delay(0.3, function()
                            if not MState.Rec then return end
                            if model.Parent then return end
                            CommitEntry({
                                Type = "Sell",
                                Time = GetTimeString(),
                                Ref = ref,
                            }, "Sell " .. ref)
                        end)
                    end
                elseif name == "Activate Ability" then
                    local model = select(4, ...)
                    local ability = select(5, ...)
                    if typeof(model) == "Instance" and type(ability) == "string"
                        and ret[1] and type(ret[1]) ~= "string" then
                        local ref = GetTowerRef(model)
                        CommitEntry({
                            Type = "Ability",
                            Time = GetTimeString(),
                            Ref = ref,
                            Ability = ability,
                        }, "Ability " .. ability)
                    end
                end
            elseif Method == "FireServer" and rawequal(self, SignalE) then
                local name = select(2, ...)
                if name == "Change Tower Target" then
                    local model = select(4, ...)
                    if typeof(model) == "Instance" then
                        local target = model:GetAttribute("TargetType")
                        if type(target) == "string" then
                            local ref = GetTowerRef(model)
                            CommitEntry({
                                Type = "Target",
                                Time = GetTimeString(),
                                Ref = ref,
                                Target = target,
                            }, "Target " .. target)
                        end
                    end
                end
            end
        end
        return table.unpack(ret, 1, ret.n)
    end))
    MState.Hooked = true
end
local function Func_MacRec(state)
    if state then
        if Toggles.LoadMacro and Toggles.LoadMacro.Value then
            Toggles.LoadMacro:SetValue(false)
        end
        MState.Rec = true
        MState.Rep = false
        MState.Step = 0
        MState.CurWave = GetCurrentWave()
        MState.WaveStartClock = os.clock()
        MState.Cur = {}
        MState.CurName = "Macro_" .. os.date("%Y%m%d_%H%M%S")
        StartRec()
        UpdateLabel()
        task.spawn(LabelPump)
        task.spawn(function()
            while MState.Rec do
                local w = GetCurrentWave()
                if w ~= MState.CurWave then
                    MState.CurWave = w
                    MState.WaveStartClock = os.clock()
                end
                task.wait()
            end
        end)
    else
        MState.Rec = false
        if MState.Cur and #MState.Cur > 0 then
            local fname = (Options.FileName and Options.FileName.Value) or ""
            if fname == "" then fname = MState.CurName end
            fname = fname:gsub("[^A-Za-z0-9_%-]", "_")
            if SaveMacro(fname, MState.Cur) then
                Library:Notify("Saved: " .. fname .. " (" .. #MState.Cur .. " steps)", 5)
            end
            if Options.MacroSelected then
                Options.MacroSelected:SetValues(ListMacros())
            end
        end
        MState.Cur = nil
        MState.CurName = nil
        MState.Step = 0
        UpdateLabel()
    end
end
local function WaitCredits(amount)
    if not amount or amount <= 0 then return true end
    if GetCash() >= amount then return true end
    local cv = GetCashValue()
    if not (cv and cv.Changed) then
        while Toggles.LoadMacro.Value and GetCash() < amount do
            task.wait()
        end
        return Toggles.LoadMacro.Value and GetCash() >= amount
    end
    while Toggles.LoadMacro.Value and cv.Parent and cv.Value < amount do
        cv.Changed:Wait()
    end
    return Toggles.LoadMacro.Value and GetCash() >= amount
end
local function GetAbilityCost(model, abilityName)
    local list = model:FindFirstChild("AbilityList")
    local ab = list and list:FindFirstChild(abilityName)
    if not (ab and ab:IsA("ModuleScript")) then return nil end
    local ok, info = pcall(require, ab)
    if not ok or type(info) ~= "table" then return nil end
    return type(info.Cost) == "number" and info.Cost or 0
end
local function GetMacroEntryCost(entry)
    if entry.Type == "Place" then
        local stats = GetTowerAssetStats(entry.Tower, entry.Costume)
        if type(stats) == "table" and type(stats.PlacementCost) == "number" then
            return stats.PlacementCost * GetSpendingMult()
        end
        return nil
    elseif entry.Type == "Upgrade" then
        local model = FindTowerByRef(entry.Ref)
        if not model then return nil end
        return GetUpgradeCost(model, entry.Path)
    elseif entry.Type == "Ability" then
        local model = FindTowerByRef(entry.Ref)
        if not model then return nil end
        return GetAbilityCost(model, entry.Ability)
    end
    return nil
end
local function ParseMacroTime(action)
    local tWave, tElapsed
    if type(action.Time) == "string" then
        local wStr, eStr = action.Time:match("^(%d+)%s+(.+)$")
        tWave = tonumber(wStr)
        tElapsed = tonumber(eStr)
    end
    return tWave or 0, tElapsed or 0
end
local function SortMacroEntries(macro)
    table.sort(macro, function(a, b)
        local wa, ea = ParseMacroTime(a)
        local wb, eb = ParseMacroTime(b)
        if wa ~= wb then return wa < wb end
        return ea > eb
    end)
end
local function DoMacroAction(action)
    if action.Type == "Place" then
        local cfData = action.CF
        if type(cfData) ~= "table" or #cfData ~= 12 then return end
        local spawnCF = CFrame.new(table.unpack(cfData))
        local result
        for attempt = 1, 3 do
            if not Toggles.LoadMacro.Value then break end
            result = SafeInvoke("Place Tower", {
                Tower = action.Tower,
                TowerKey = action.Key,
                Costume = action.Costume,
                SpawnPoint = spawnCF,
            })
            if result == true then break end
            if attempt < 3 then
                local cost = GetMacroEntryCost(action)
                notyuri("[Macro Load] Place rejected, waiting for cash, attempt", attempt, "of 3")
                if not WaitCredits(cost) then break end
            end
        end
        if result ~= true then
            notyuri("[Macro Load] Place SKIP: server rejected after 3 attempts", tostring(action.Tower))
        end
    elseif action.Type == "Upgrade" then
        local model = FindTowerByRef(action.Ref)
        if not model then
            notyuri("[Macro Load] Upgrade SKIP: no tower resolved for ref", tostring(action.Ref))
            return
        end
        local result
        for attempt = 1, 3 do
            if not Toggles.LoadMacro.Value then break end
            result = SafeInvoke("Upgrade Tower", model, action.Path)
            if result and type(result) ~= "string" then break end
            if attempt < 3 then
                local cost = GetMacroEntryCost(action)
                notyuri("[Macro Load] Upgrade rejected for ref", tostring(action.Ref), "waiting for cash, attempt", attempt, "of 3")
                if not WaitCredits(cost) then break end
            end
        end
        if not (result and type(result) ~= "string") then
            notyuri("[Macro Load] Upgrade SKIP: server rejected for ref after 3 attempts", tostring(action.Ref))
        end
    elseif action.Type == "Sell" then
        local model = FindTowerByRef(action.Ref)
        if not model then
            notyuri("[Macro Load] Sell SKIP: no tower resolved for ref", tostring(action.Ref))
            return
        end
        SafeInvoke("Sell Tower", model)
    elseif action.Type == "Ability" then
        local model = FindTowerByRef(action.Ref)
        if not model then
            notyuri("[Macro Load] Ability SKIP: no tower resolved for ref", tostring(action.Ref))
            return
        end
        SafeInvoke("Activate Ability", model, action.Ability)
    elseif action.Type == "Target" then
        local model = FindTowerByRef(action.Ref)
        if model and type(action.Target) == "string" then
            pcall(function() model:SetAttribute("TargetType", action.Target) end)
            SafeFire("Change Tower Target", model)
        else
            notyuri("[Macro Load] Target SKIP: no tower resolved for ref", tostring(action.Ref))
        end
    end
end
local function Func_LoadMacro()
    while Toggles.LoadMacro.Value do
        local macro = MState.Load
        if not macro or #macro == 0 then
            Toggles.LoadMacro:SetValue(false)
            Library:Notify("No macro loaded", 3)
            return
        end
        MState.Rep = true
        MState.Total = #macro
        MState.Step = 0
        SortMacroEntries(macro)
        UpdateLabel()
        while Toggles.LoadMacro.Value and not InMatch() do
            task.wait()
        end
        if not Toggles.LoadMacro.Value then break end
        for i, action in ipairs(macro) do
            if not Toggles.LoadMacro.Value then break end
            if not InMatch() then
                notyuri("[Macro Load] match ended mid-pass, aborting pass")
                break
            end
            MState.Step = i
            UpdateLabel(action.Type, action.Time)
            local replayMode = (Options.ReplayMode and Options.ReplayMode.Value) or "Time"
            local skipStep = false
            if replayMode == "Money" then
                if action.Type == "Place" or action.Type == "Upgrade" or action.Type == "Ability" then
                    local cost = GetMacroEntryCost(action)
                    if cost and cost > 0 then
                        if not WaitCredits(cost) then
                            notyuri("[Macro Load] money wait aborted")
                        end
                    end
                end
            else
                local tWave, tElapsed = ParseMacroTime(action)
                while Toggles.LoadMacro.Value and GetCurrentWave() < tWave do
                    if not InMatch() then break end
                    task.wait()
                end
                if not Toggles.LoadMacro.Value then break end
                if GetCurrentWave() > tWave + 1 then
                    skipStep = true
                else
                    local remaining = GetRemainingTime()
                    if remaining and remaining > tElapsed then
                        while Toggles.LoadMacro.Value and InMatch() and GetCurrentWave() == tWave do
                            remaining = GetRemainingTime()
                            if not remaining or remaining <= tElapsed then break end
                            task.wait()
                        end
                    end
                end
            end
            if not Toggles.LoadMacro.Value then break end
            if skipStep then
                UpdateLabel("skipped")
                notyuri("[Macro Load] skipped stale entry", action.Type, tostring(action.Time))
            else
                UpdateLabel(action.Type, action.Time)
                local ok, err = pcall(DoMacroAction, action)
                if not ok then
                    notyuri("[Macro Load] action failed:", tostring(err))
                end
                task.wait()
            end
        end
        MState.Rep = false
        MState.Step = 0
        UpdateLabel("Finished")
        if Toggles.LoadMacro.Value then
            UpdateLabel("Waiting")
            while Toggles.LoadMacro.Value and InMatch() do
                task.wait()
            end
            while Toggles.LoadMacro.Value and not InMatch() do
                task.wait()
            end
        end
    end
    MState.Rep = false
    MState.Step = 0
    UpdateLabel()
end
local function Func_AutoSkip()
    while Toggles.AutoSkip.Value do
        if InMatch() then
            local ok, vis = pcall(function()
                local gui = Plr:FindFirstChild("PlayerGui")
                local gp = gui and gui:FindFirstChild("Gameplay")
                local skip = gp and gp:FindFirstChild("Skip")
                return skip and skip.Visible or false
            end)
            if ok and vis then
                SafeFire("Skip Wave Vote")
                task.wait(1)
            end
        end
        task.wait(0.25)
    end
end
local function Func_AutoTimeMultiplier()
    while Toggles.AutoTimeMultiplier.Value do
        if InMatch() then
            local want = tonumber(Options.TimeMultiplierSpeed and Options.TimeMultiplierSpeed.Value) or 3
            local state = GetStateFolder()
            local tm = state and state:FindFirstChild("TimeMultiplier")
            if not tm or tm.Value ~= want then
                SafeFire("Update Time Multiplier", want)
            end
        end
        task.wait(2)
    end
end
local function GetGameTimeValue(cd)
    if type(cd) ~= "number" then return 5 end
    local ok, res = pcall(function()
        return shared.GameTime(cd)
    end)
    if ok and type(res) == "number" then return res end
    return cd
end
local AbilityRetry = {}
local function Func_AutoAbility()
    while Toggles.AutoAbility.Value do
        local folder = GetTowersFolder()
        if folder then
            for _, tower in ipairs(folder:GetChildren()) do
                if not Toggles.AutoAbility.Value then break end
                if IsOwnedTower(tower) then
                    local list = tower:FindFirstChild("AbilityList")
                    if list then
                        for _, ab in ipairs(list:GetChildren()) do
                            if not Toggles.AutoAbility.Value then break end
                            if ab and ab:IsA("ModuleScript") then
                                local key = GetTowerRef(tower) .. "|" .. ab.Name
                                local retry = AbilityRetry[key] or 0
                                if tick() >= retry then
                                    local ok, info = pcall(require, ab)
                                    if ok and type(info) == "table" then
                                        local cost = type(info.Cost) == "number" and info.Cost or 0
                                        local cd = GetGameTimeValue(info.Cooldown)
                                        local last = tower:GetAttribute("LastAbility_" .. ab.Name) or 0
                                        local ready = true
                                        if last > 0 then
                                            ready = (workspace:GetServerTimeNow() - last) >= cd
                                        end
                                        if ready and GetCash() >= cost then
                                            local res = SafeInvoke("Activate Ability", tower, ab.Name)
                                            if res and type(res) ~= "string" then
                                                AbilityRetry[key] = tick() + math.max(cd, 1)
                                            else
                                                AbilityRetry[key] = tick() + 5
                                            end
                                        end
                                    else
                                        AbilityRetry[key] = tick() + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoHint()
    while Toggles.AutoHint.Value do
        local folder = GetTowersFolder()
        if folder then
            for _, tower in ipairs(folder:GetChildren()) do
                if not Toggles.AutoHint.Value then break end
                if IsOwnedTower(tower) then
                    local wit = tower:GetAttribute("Wit") or 0
                    local maxWit = tower:GetAttribute("MaxWit") or 1
                    local hintLvl = tower:GetAttribute("HintLvl") or 0
                    if wit >= maxWit and hintLvl < 5 then
                        SafeInvoke("Upgrade Hint Lvl", tower)
                    end
                end
            end
        end
        task.wait()
    end
end
local function SendWebhook(title, description)
    if not (typeof(request) == "function" or typeof(http_request) == "function") then return end
    local url = (Options.WebhookURL and Options.WebhookURL.Value) or ""
    if url == "" then return end
    local img = yuri[math.random(1, #yuri)]
    pcall(function()
        request({
            Url = url,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                username = "Yuri",
                avatar_url = img,
                embeds = {
                    {
                        title = title,
                        description = description,
                        color = 0xFFB6C1,
                        thumbnail = { url = img },
                    },
                },
            }),
        })
    end)
end
local ResultsHooked = false
local MatchEnded = false
local LastMatchResults = {
    Victory = nil,
    Wave = 0,
    WaveFinal = 0,
    RewardLines = {},
}
local function SendMatchEndWebhook()
    if not MatchEnded then return end
    if not (Toggles.WHMatchEnd and Toggles.WHMatchEnd.Value) then return end
    local outcome = (LastMatchResults.Victory == true) and "Victory" or "Defeat"
    local desc = string.format(
        "**%s - %s**\n- Wave: %d/%d\n- Player: ||%s||\n- Rewards:\n%s",
        GetMatchLabel(), outcome, LastMatchResults.Wave, LastMatchResults.WaveFinal, Plr.Name,
        #LastMatchResults.RewardLines > 0 and table.concat(LastMatchResults.RewardLines, "\n") or "None"
    )
    SendWebhook("Match Finished", desc)
end
local function AutoNextEpisode()
    while MatchEnded and Toggles.AutoNext and Toggles.AutoNext.Value do
        SafeFire("Next Episode")
        task.wait(1)
    end
end
local function AutoReplayMatch()
    while MatchEnded and Toggles.AutoReplay and Toggles.AutoReplay.Value do
        SafeFire("Replay")
        task.wait(1)
    end
end
local function HookGameResults()
    if ResultsHooked then return end
    local ok = OnGameEvent("Game Results", function(victory, rewards)
        local rewardLines = {}
        if type(rewards) == "table" then
            for k, val in pairs(rewards) do
                if k ~= "TowerLevelUps" and type(val) == "number" then
                    table.insert(rewardLines, string.format("+%s %s", tostring(val), tostring(k)))
                end
            end
        end
        LastMatchResults.Victory = victory
        LastMatchResults.Wave = GetWave()
        LastMatchResults.WaveFinal = GetWaveFinal()
        LastMatchResults.RewardLines = rewardLines
        MatchEnded = true
        SendMatchEndWebhook()
        if Toggles.AutoNext and Toggles.AutoNext.Value and workspace:GetAttribute("NextEpisode") then
            Thread("AutoNextEpisode", AutoNextEpisode, true)
        elseif Toggles.AutoReplay and Toggles.AutoReplay.Value then
            Thread("AutoReplayMatch", AutoReplayMatch, true)
        end
    end)
    if ok then
        ResultsHooked = true
    else
        Library:Notify("Failed to hook Game Results event", 5)
    end
end
local function GetOpenPortal()
    local portals = workspace:FindFirstChild("Portals")
    if not portals then return nil end
    local best, bestCurrent
    for _, p in ipairs(portals:GetChildren()) do
        if not p:GetAttribute("Locked") then
            local label = p:FindFirstChild("Info")
                and p.Info:FindFirstChild("Base")
                and p.Info.Base:FindFirstChild("Map")
                and p.Info.Base.Map:FindFirstChild("Icon")
                and p.Info.Base.Map.Icon:FindFirstChild("Players")
            local current, max
            if label and label:IsA("TextLabel") then
                current, max = label.Text:match("^(%d+)/(%d+)")
                current, max = tonumber(current), tonumber(max)
            end
            if current and max and current < max then
                if not bestCurrent or current < bestCurrent then
                    best = p
                    bestCurrent = current
                end
            end
        end
    end
    return best
end
local function GetScenarioNames()
    local scenarios = RS:FindFirstChild("Resources") and RS.Resources:FindFirstChild("Scenarios")
    local names = {}
    if scenarios then
        for _, child in ipairs(scenarios:GetChildren()) do
            table.insert(names, child.Name)
        end
    end
    table.sort(names)
    return names
end
local function GetChapterNames(scenarioName)
    local scenarios = RS:FindFirstChild("Resources") and RS.Resources:FindFirstChild("Scenarios")
    local scenario = scenarios and scenarioName and scenarios:FindFirstChild(scenarioName)
    local names = {}
    if scenario then
        for _, child in ipairs(scenario:GetChildren()) do
            table.insert(names, child.Name)
        end
    end
    table.sort(names)
    return names
end
local function GetEpisodeNames(scenarioName, chapterName)
    local scenarios = RS:FindFirstChild("Resources") and RS.Resources:FindFirstChild("Scenarios")
    local scenario = scenarios and scenarioName and scenarios:FindFirstChild(scenarioName)
    local chapter = scenario and chapterName and scenario:FindFirstChild(chapterName)
    local names = {}
    if chapter then
        for _, child in ipairs(chapter:GetChildren()) do
            table.insert(names, child.Name)
        end
    end
    table.sort(names)
    return names
end
local function FireUpdatePortalStats()
    local scenario = Options.JoinScenario and Options.JoinScenario.Value
    local chapter = Options.JoinChapter and Options.JoinChapter.Value
    local episode = Options.JoinEpisode and Options.JoinEpisode.Value
    local difficulty = Options.JoinDifficulty and Options.JoinDifficulty.Value
    if not (scenario and chapter and episode and difficulty) then return end
    SafeFire("Update Portal Stats", {
        Privacy = "Public",
        PlayerNames = { Plr.Name },
        Episode = episode,
        Difficulty = difficulty,
        Chapter = chapter,
        Host = Plr.UserId,
        Players = { Plr },
        Gameplay = true,
        Scenario = scenario,
        MaxPlayers = 1,
    })
    notyuri("[AutoJoin] Update Portal Stats", scenario, chapter, episode, difficulty)
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        if not InMatch() then
            local inLobby = Plr:FindFirstChild("InLobby")
            if not (inLobby and inLobby.Value) then
                local portal = GetOpenPortal()
                local region = portal and portal:FindFirstChild("Region")
                local char = Plr.Character
                if region and char and char:FindFirstChild("HumanoidRootPart") then
                    pcall(function() char:PivotTo(region.CFrame) end)
                    task.wait(1)
                    FireUpdatePortalStats()
                end
            end
        end
        task.wait(3)
    end
end
local function Func_AutoSummon()
    while Toggles.AutoSummon.Value do
        local banner = Options.SummonBanner and Options.SummonBanner.Value
        if banner and banner ~= "" then
            local result = SafeInvoke("Scout", banner, 11)
            notyuri("[AutoSummon] Scout", banner, "x9", "result:", tostring(result))
        end
        task.wait(.1)
    end
end
local function GetLoadoutText()
    local loadout = GetLoadout()
    if #loadout == 0 then return "No loadout found" end
    local lines = {}
    for _, entry in ipairs(loadout) do
        table.insert(lines, string.format("Slot %d: %s [%s]", entry.Slot, entry.Name, entry.Costume))
    end
    return table.concat(lines, "\n")
end
local function Serverhop()
    local hopSuccess, hopErr = pcall(function()
        local baseUrl = 'https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'
        local servers = {}
        local cursor = ''
        for _ = 1, 3 do
            local url = baseUrl
            if cursor ~= '' then url = url .. '&cursor=' .. cursor end
            local pages = game:HttpGet(url)
            local data = HttpService:JSONDecode(pages)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server)
                end
            end
            cursor = data.nextPageCursor
            if not cursor or cursor == '' then break end
        end
        table.sort(servers, function(a, b) return a.playing < b.playing end)
        if #servers == 0 then
            return
        end
        local best = servers[1]
        for _, server in ipairs(servers) do
            if server.playing > 0 then
                best = server
                break
            end
        end
        TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Plr)
    end)
    if not hopSuccess then
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
        AutoPlay = Window:AddTab("Auto Play"),
        Player = Window:AddTab("Player"),
        Webhook = Window:AddTab("Webhook"),
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
        T1 = TB.Main.Left.Autofarm:AddTab("Macro"),
        T2 = TB.Main.Left.Autofarm:AddTab("Game"),
        T3 = TB.Main.Left.Autofarm:AddTab("Lobby"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
        T2 = TB.Main.Right.Autofarm:AddTab("LobbyConfig"),
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
local AP_Left  = Tabs.AutoPlay:AddLeftGroupbox("Auto Play")
local AP_Right = Tabs.AutoPlay:AddRightGroupbox("Limits")
AP_Left:AddToggle("AutoPlay", {
    Text    = "Auto Play",
    Default = false,
})
AP_Left:AddDivider()
AP_Left:AddToggle("AutoUpgrade", {
    Text    = "Auto Upgrade",
    Default = false,
})
AP_Left:AddToggle("PlaceAndUpgrade", {
    Text    = "Place and Upgrade",
    Default = false,
})
AP.PosLabelRef = AP_Left:AddLabel("No positions set", true)
AP_Left:AddDropdown("APSetSlotSelect", {
    Text    = "Set Slot Position",
    Values  = GetSlotDisplayNames(),
    Default = GetSlotDisplayNames()[1] or "",
})
AP_Left:AddButton({
    Text = "Set Slot Position",
    Func = function()
        local val = Options.APSetSlotSelect and Options.APSetSlotSelect.Value or ""
        local slot = SlotDisplayToNumber(val)
        if slot then
            SetPos(slot)
        else
            Library:Notify("Select a slot first", 3)
        end
    end,
})
AP_Left:AddButton({ Text = "Save Position for All Slots", Func = function() MassSetPos() end })
AP_Left:AddDivider()
AP_Left:AddDropdown("APResetSlotSelect", {
    Text    = "Reset Slot Position",
    Values  = (function() local v = GetSlotDisplayNames() table.insert(v, "All Slots") return v end)(),
    Default = "All Slots",
})
AP_Left:AddButton({
    Text = "Reset Position",
    Func = function()
        local val = Options.APResetSlotSelect and Options.APResetSlotSelect.Value or "All Slots"
        if val == "All Slots" then
            ResetPos(nil)
        else
            ResetPos(SlotDisplayToNumber(val))
        end
    end,
})
UpdatePosLabels()
AP_Right:AddLabel("Place Order per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("APPlaceOrder" .. i, {
        Text     = "Slot " .. i,
        Default  = i,
        Min      = 1,
        Max      = 6,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Place Wave per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("APPlaceWave" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 50,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Place Limit per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("PlaceLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 10,
        Rounding = 0,
        Compact  = true,
    })
end
AP_Right:AddDivider()
AP_Right:AddLabel("Upgrade Limit per Slot", true)
for i = 1, 6 do
    AP_Right:AddSlider("UpgradeLimit" .. i, {
        Text     = "Slot " .. i,
        Default  = 0,
        Min      = 0,
        Max      = 30,
        Rounding = 0,
        Compact  = true,
    })
end
TB_Tabs.Autofarm.T1:AddDropdown("MacroSelected", {
    Text    = "Select File",
    Values  = ListMacros(),
    Default = ListMacros()[1] or "",
})
Options.MacroSelected:OnChanged(function(v)
    if v and v ~= "" then
        MState.Load = LoadMacro(v)
        if not MState.Load then
            Library:Notify("Failed to load macro: " .. v, 4)
        end
    end
end)
TB_Tabs.Autofarm.T1:AddInput("FileName", {
    Text        = "File Name",
    Default     = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.T1:AddToggle("RecordMacro", {
    Text    = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddDropdown("ReplayMode", {
    Text    = "Replay Mode",
    Values  = { "Time", "Money" },
    Default = "Time",
})
TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", {
    Text    = "Load Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
Toggles.RecordMacro:OnChanged(function(v)
    Func_MacRec(v)
end)
Toggles.LoadMacro:OnChanged(function(v)
    if v then
        if not MState.Load then
            local name = Options.MacroSelected and Options.MacroSelected.Value or ""
            if name and name ~= "" then
                MState.Load = LoadMacro(name)
            end
        end
        if not MState.Load then
            Library:Notify("No macro selected", 3)
            Toggles.LoadMacro:SetValue(false)
            return
        end
    end
    Thread("LoadMacro", SafeLoop("LoadMacro", Func_LoadMacro), v)
end)
TB_Tabs.Autofarm.T2:AddToggle("AutoReplay", {
    Text    = "Auto Replay",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoNext", {
    Text    = "Auto Next",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoSkip", {
    Text    = "Auto Skip",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoTimeMultiplier", {
    Text    = "Auto Time Multiplier",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("TimeMultiplierSpeed", {
    Text    = "Game Speed",
    Values  = { "1", "2", "3", "4" },
    Default = "3",
})
TB_Tabs.Autofarm.T2:AddToggle("AutoAbility", {
    Text    = "Auto Ability",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoHint", {
    Text    = "Auto Hint",
    Default = false,
})
TB_Tabs.Autofarm.T3:AddToggle("AutoJoin", {
    Text    = "Auto Join",
    Default = false,
})
TB_Tabs.Autofarm2.T2:AddDropdown("JoinScenario", {
    Text    = "Scenario",
    Values  = GetScenarioNames(),
    Default = GetScenarioNames()[1] or "",
})
TB_Tabs.Autofarm2.T2:AddDropdown("JoinChapter", {
    Text    = "Chapter",
    Values  = GetChapterNames(Options.JoinScenario and Options.JoinScenario.Value),
    Default = GetChapterNames(Options.JoinScenario and Options.JoinScenario.Value)[1] or "",
})
TB_Tabs.Autofarm2.T2:AddDropdown("JoinEpisode", {
    Text    = "Episode",
    Values  = GetEpisodeNames(Options.JoinScenario and Options.JoinScenario.Value, Options.JoinChapter and Options.JoinChapter.Value),
    Default = GetEpisodeNames(Options.JoinScenario and Options.JoinScenario.Value, Options.JoinChapter and Options.JoinChapter.Value)[1] or "",
})
TB_Tabs.Autofarm2.T2:AddDropdown("JoinDifficulty", {
    Text    = "Difficulty",
    Values  = { "Haru", "Daiwa", "Teio", "Golshi" },
    Default = "Daiwa",
})
TB_Tabs.Autofarm.T3:AddButton({
    Text = "Remove Duplicate Units",
    Func = function() Func_RemoveDuplicates() end,
})
TB_Tabs.Autofarm2.T2:AddDropdown("SummonBanner", {
    Text    = "Summon Banner",
    Values  = { "SpecialWeek", "SilenceSuzuka", "TokaiTeio" },
    Default = "SpecialWeek",
})
TB_Tabs.Autofarm.T3:AddToggle("AutoSummon", {
    Text    = "Auto Summon",
    Default = false,
})
Toggles.AutoPlay:OnChanged(function(v)
    if not v then
        AP.SlotCursor = {}
    end
    Thread("AutoPlay", SafeLoop("AutoPlay", Func_AutoPlay), v)
end)
Toggles.AutoSkip:OnChanged(function(v)
    Thread("AutoSkip", SafeLoop("AutoSkip", Func_AutoSkip), v)
end)
Toggles.AutoTimeMultiplier:OnChanged(function(v)
    Thread("AutoTimeMultiplier", SafeLoop("AutoTimeMultiplier", Func_AutoTimeMultiplier), v)
end)
Toggles.AutoAbility:OnChanged(function(v)
    Thread("AutoAbility", SafeLoop("AutoAbility", Func_AutoAbility), v)
end)
Toggles.AutoHint:OnChanged(function(v)
    Thread("AutoHint", SafeLoop("AutoHint", Func_AutoHint), v)
end)
Toggles.AutoJoin:OnChanged(function(v)
    Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), v)
end)
Toggles.AutoSummon:OnChanged(function(v)
    Thread("AutoSummon", SafeLoop("AutoSummon", Func_AutoSummon), v)
end)
Toggles.AutoReplay:OnChanged(function(v)
    if v then HookGameResults() end
end)
Toggles.AutoNext:OnChanged(function(v)
    if v then HookGameResults() end
end)
LoadMDir()
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
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused"})
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function() Serverhop() end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() Services.TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
Toggles.AntiKnockback:OnChanged(function(state)
    Thread("AntiKnockback", SafeLoop("AntiKnockback", Func_AntiKnockback), state)
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
Toggles.AutoServerhop:OnChanged(function(state)
    Thread("AutoServerhop", function()
        local lastHop = tick()
        while Toggles.AutoServerhop.Value do
            task.wait(5)
            if not Toggles.AutoServerhop.Value then break end
            if (tick() - lastHop) >= (Options.AutoHopMins.Value * 60) then
                Serverhop()
                break
            end
        end
    end, state)
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
local WH1 = Tabs.Webhook:AddLeftGroupbox("Webhook")
WH1:AddInput("WebhookURL", { Text = "Webhook URL", Default = "" })
WH1:AddToggle("WHMatchEnd", { Text = "Match Finished", Default = false })
Toggles.WHMatchEnd:OnChanged(function(v)
    if v then
        HookGameResults()
    end
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
SaveManager:SetFolder("Yuri/UmaTD")
SaveManager:SetLoadingOrder(true, {"Dropdown", "Slider", "ColorPicker", "KeyPicker", "Input", "Toggle"})
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