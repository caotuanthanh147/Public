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
local funcition notyuri()
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
local function WaitPlayerData(name)
    local charOk = pcall(function() return Plr.Character or Plr.CharacterAdded:Wait() end)
    if not charOk then
        notyuri("[WaitPlayerData] character wait failed")
        return nil
    end
    local dataOk, Data = pcall(function() return PGui:WaitForChild("Data", 10) end)
    if not dataOk or not Data then
        notyuri("[WaitPlayerData] PlayerGui.Data not found")
        return nil
    end
    local childOk, child = pcall(function() return Data:WaitForChild(name, 10) end)
    if not childOk or not child then
        notyuri("[WaitPlayerData] Data." .. tostring(name) .. " not found")
        return nil
    end
    return child
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
local RemotesFolder = RS:FindFirstChild("Remotes") or RS:WaitForChild("Remotes", 15)
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
local function InvokeRemote(name, ...)
    local r = GetRemote(name)
    if not r then return nil end
    local args = {...}
    local ok, res = pcall(function() return r:InvokeServer(unpack(args)) end)
    if ok then return res end
    return nil
end
local ConfigFolder = RS:FindFirstChild("Config") or RS:WaitForChild("Config", 15)
local ResEgg = GetSafeModule(ConfigFolder, "ResEgg")
local ResCapsule = GetSafeModule(ConfigFolder, "ResCapsule")
local ResBoost = GetSafeModule(ConfigFolder, "ResBoost")
local ResItem = GetSafeModule(ConfigFolder, "ResItem")
local ResFood = GetSafeModule(ConfigFolder, "ResFood")
local ResGun = GetSafeModule(ConfigFolder, "ResGun")
local ResNpc = GetSafeModule(ConfigFolder, "ResNpc")
local ResMap = GetSafeModule(ConfigFolder, "ResMap")
local function BuildEggList()
    local list = {}
    if ResEgg and ResEgg.__index then
        for _, id in ipairs(ResEgg.__index) do
            local def = ResEgg[id]
            if def and def.ID then
                table.insert(list, def.ID)
            end
        end
    end
    if #list == 0 then list = { "Egg01" } end
    return list
end
local function BuildCapsuleList()
    local list = {}
    if ResCapsule then
        if ResCapsule.__index then
            for _, id in ipairs(ResCapsule.__index) do
                local def = ResCapsule[id]
                if def and def.ID then
                    table.insert(list, def.ID)
                end
            end
        else
            for id, def in pairs(ResCapsule) do
                if type(def) == "table" and def.ID and id ~= "__index" then
                    table.insert(list, def.ID)
                end
            end
            table.sort(list)
        end
    end
    if #list == 0 then list = { "Capsule01" } end
    return list
end
local function BuildBoostList()
    local list = {}
    if ResBoost and ResBoost.__index then
        for _, id in ipairs(ResBoost.__index) do
            table.insert(list, id)
        end
    end
    if #list == 0 then list = { "DMG" } end
    return list
end
local function BuildPotionList()
    local list = {}
    if ResItem and ResItem.__index then
        for _, id in ipairs(ResItem.__index) do
            local def = ResItem[id]
            if type(def) == "table" and def.ProductID then
                table.insert(list, id)
            end
        end
    end
    if #list == 0 then list = { "LuckPotion" } end
    return list
end
local function BuildFoodList()
    local list = {}
    if ResFood then
        if ResFood.__index then
            for _, id in ipairs(ResFood.__index) do
                if type(ResFood[id]) == "table" then
                    table.insert(list, tostring(id))
                end
            end
        else
            for id, def in pairs(ResFood) do
                if type(def) == "table" and id ~= "__index" then
                    table.insert(list, tostring(id))
                end
            end
            table.sort(list)
        end
    end
    if #list == 0 then list = { "Food01" } end
    return list
end
local function BuildGunList()
    local list = {}
    if ResGun then
        if ResGun.__index then
            for _, id in ipairs(ResGun.__index) do
                if type(ResGun[id]) == "table" then
                    table.insert(list, tostring(id))
                end
            end
        else
            for id, def in pairs(ResGun) do
                if type(def) == "table" and id ~= "__index" then
                    table.insert(list, tostring(id))
                end
            end
            table.sort(list)
        end
    end
    if #list == 0 then list = { "CrossBow02" } end
    return list
end
local EggList = BuildEggList()
local CapsuleList = BuildCapsuleList()
local BoostList = BuildBoostList()
local PotionList = BuildPotionList()
local FoodList = BuildFoodList()
local GunList = BuildGunList()
local function GetCurrencyAmount(assetType)
    local asset = Plr:FindFirstChild("Asset")
    if not asset then return 0 end
    return tonumber(asset:GetAttribute(assetType)) or 0
end
local function CanAfford(price, assetType)
    return GetCurrencyAmount(assetType or "Coins") >= (price or 0)
end
local function GetNearestNpc()
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local worldZone = workspace:FindFirstChild("WorldZone")
    if not worldZone then return nil end
    local bestNpc, bestDist = nil, math.huge
    for _, zone in ipairs(worldZone:GetChildren()) do
        if zone:IsA("Folder") or zone:IsA("Configuration") then
            for _, npc in ipairs(zone:GetChildren()) do
                if npc:IsA("BasePart") and npc.Name:match("^Npc") then
                    local dist = (npc.Position - hrp.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        bestNpc = npc
                    end
                end
            end
        end
    end
    return bestNpc
end
local function Func_AutoFire()
    while Toggles.AutoFire.Value do
        local char = Plr.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local npc = GetNearestNpc()
            if tool and hrp and npc then
                FireRemote("FireRE", "Fire", {
                    npcInstance = npc,
                    player = Plr,
                    toolInstance = tool,
                    origin = hrp.Position,
                    destination = npc.Position,
                    hitPosition = npc.Position
                })
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoRebirth()
    while Toggles.AutoRebirth.Value do
        FireRemote("RebirthRE")
        task.wait(5)
    end
end
local function Func_AutoEquip()
    while Toggles.AutoEquip.Value do
        FireRemote("MountEquipBestRE")
        task.wait(5)
    end
end
local function Func_AutoCraftMount()
    while Toggles.AutoCraftMount.Value do
        local MountRoot = WaitPlayerData("Mount")
        if not MountRoot then
            notyuri("[AutoCraftMount] WaitPlayerData('Mount') returned nil")
        else
            local mounts = MountRoot:GetChildren()
            notyuri("AutoCraftMount: scanning " .. tostring(#mounts) .. " mounts")
            local firedCount = 0
            for _, mountInst in ipairs(mounts) do
                if not Toggles.AutoCraftMount.Value then break end
                local ok = FireRemote("MountCraftRE", mountInst.Name)
                firedCount = firedCount + 1
                notyuri("AutoCraftMount: fired MountCraftRE key=" .. tostring(mountInst.Name) .. " ok=" .. tostring(ok))
                task.wait(.1)
            end
            if firedCount == 0 then
                notyuri("AutoCraftMount: no mounts found this pass")
            end
        end
        task.wait(3)
    end
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        FireRemote("MountSellRE", "")
        task.wait(3)
    end
end
local function Func_AutoEvolve()
    while Toggles.AutoEvolve.Value do
        if not ResNpc then
            notyuri("[AutoEvolve] ResNpc module not loaded")
        else
            local MountRoot = WaitPlayerData("Mount")
            if not MountRoot then
                notyuri("[AutoEvolve] WaitPlayerData('Mount') returned nil")
            else
                local mounts = MountRoot:GetChildren()
                notyuri("AutoEvolve: scanning " .. tostring(#mounts) .. " mounts")
                local firedCount = 0
                for _, mountInst in ipairs(mounts) do
                    if not Toggles.AutoEvolve.Value then break end
                    local mountID = tostring(mountInst:GetAttribute("ID") or "")
                    local mountLV = math.max(1, math.floor(tonumber(mountInst:GetAttribute("LV")) or 1))
                    local npcDef = mountID ~= "" and ResNpc[mountID]
                    if not npcDef then
                        notyuri("AutoEvolve: mount " .. tostring(mountInst.Name) .. " has no ResNpc entry for ID='" .. mountID .. "'")
                    else
                        local evoID = tostring(npcDef.EvoID or "")
                        local evoLevel = math.max(1, math.floor(tonumber(npcDef.EvoLevel) or 100))
                        if evoID == "" or not ResNpc[evoID] then
                            notyuri("AutoEvolve: mount " .. tostring(mountInst.Name) .. " (" .. mountID .. ") has no evolution target")
                        elseif mountLV < evoLevel then
                            notyuri("AutoEvolve: mount " .. tostring(mountInst.Name) .. " (" .. mountID .. ") LV=" .. tostring(mountLV) .. " below required EvoLevel=" .. tostring(evoLevel))
                        else
                            local ok = FireRemote("MountEvolveRE", mountInst.Name)
                            firedCount = firedCount + 1
                            notyuri("AutoEvolve: fired MountEvolveRE key=" .. tostring(mountInst.Name) .. " id=" .. mountID .. " LV=" .. tostring(mountLV) .. " ok=" .. tostring(ok))
                            task.wait(.1)
                        end
                    end
                end
                if firedCount == 0 then
                    notyuri("AutoEvolve: no mounts eligible to evolve this pass")
                end
            end
        end
        task.wait(3)
    end
end
local function Func_AutoCapture()
    while Toggles.AutoCapture.Value do
        FireRemote("CapsuleRE", "Capture", { target = nil })
        task.wait(1)
    end
end
local function GetMultiSelection(dropdown, fullList)
    local sel = dropdown and dropdown.Value or {}
    if type(sel) ~= "table" then return {} end
    if sel["Any"] then return fullList end
    local list = {}
    for name, active in pairs(sel) do
        if active and name ~= "Any" then table.insert(list, name) end
    end
    return list
end
local function Func_AutoBuy()
    while Toggles.AutoBuyCapsule.Value do
        local selected = GetMultiSelection(Options.CapsuleDropdown, CapsuleList)
        for _, id in ipairs(selected) do
            if not Toggles.AutoBuyCapsule.Value then break end
            local def = ResCapsule and ResCapsule[id]
            if def then
                FireRemote("CapsuleRE", "Buy", { ID = id })
            end
            task.wait(.1)
        end
        task.wait()
    end
end
local function Func_AutoBuyFood()
    while Toggles.AutoBuyFood.Value do
        local selected = GetMultiSelection(Options.FoodDropdown, FoodList)
        local count = tonumber(Options.FoodBuyCount and Options.FoodBuyCount.Value) or 1
        count = math.max(1, math.floor(count))
        for _, id in ipairs(selected) do
            if not Toggles.AutoBuyFood.Value then break end
            local def = ResFood and ResFood[id]
            if def then
                FireRemote("FoodShopRE", "Buy", { ID = id, Count = count })
            end
            task.wait(.1)
        end
        task.wait()
    end
end
local function Func_AutoBuyGun()
    while Toggles.AutoBuyGun.Value do
        local selected = GetMultiSelection(Options.GunDropdown, GunList)
        for _, id in ipairs(selected) do
            if not Toggles.AutoBuyGun.Value then break end
            local def = ResGun and ResGun[id]
            if def then
                FireRemote("ToolRE", "Buy", { ID = id })
            end
            task.wait(.1)
        end
        task.wait()
    end
end
local function Func_AutoBuyMap()
    while Toggles.AutoBuyMap.Value do
        if not ResMap or not ResMap.__index then
            notyuri("[AutoBuyMap] ResMap module not loaded")
        else
            local UserFlag = WaitPlayerData("UserFlag")
            if not UserFlag then
                notyuri("[AutoBuyMap] WaitPlayerData('UserFlag') returned nil")
            else
                local order = ResMap.__index
                local firedCount = 0
                for i = 1, #order - 1 do
                    if not Toggles.AutoBuyMap.Value then break end
                    local sourceMapId = order[i]
                    local targetMapId = order[i + 1]
                    local isUnlocked = targetMapId == "Map01" or UserFlag:GetAttribute("MapUnlocked_" .. tostring(targetMapId)) == true
                    if not isUnlocked then
                        local result = InvokeRemote("MapDoorRF", sourceMapId, targetMapId)
                        firedCount = firedCount + 1
                        notyuri("AutoBuyMap: invoked MapDoorRF source=" .. tostring(sourceMapId) .. " target=" .. tostring(targetMapId) .. " ok=" .. tostring(result and result.ok) .. " message=" .. tostring(result and result.message))
                        task.wait(.3)
                    end
                end
                if firedCount == 0 then
                    notyuri("AutoBuyMap: no locked maps found this pass")
                end
            end
        end
        task.wait(3)
    end
end
local function Func_AutoHatch()
    while Toggles.AutoHatch.Value do
        local selected = GetMultiSelection(Options.EggDropdown, EggList)
        for _, eggName in ipairs(selected) do
            if not Toggles.AutoHatch.Value then break end
            local def = ResEgg and ResEgg[eggName]
            if def then
                FireRemote("EggHatchRE", eggName, false)
            end
            task.wait(.1)
        end
        task.wait(1)
    end
end
local function Func_AutoAccelerate()
    while Toggles.AutoAccelerate.Value do
        local selected = GetMultiSelection(Options.EggDropdown, EggList)
        for _, eggName in ipairs(selected) do
            if not Toggles.AutoAccelerate.Value then break end
            local def = ResEgg and ResEgg[eggName]
            if def then
                FireRemote("EggAccelerateRE", eggName, true)
            end
            task.wait(.1)
        end
        task.wait(2)
    end
end
local function Func_AutoPoint()
    while Toggles.AutoPoint.Value do
        local selected = GetMultiSelection(Options.BoostDropdown, BoostList)
        for _, id in ipairs(selected) do
            if not Toggles.AutoPoint.Value then break end
            FireRemote("BoostRE", "AddPoint", { ID = id })
            task.wait(.1)
        end
        task.wait(1)
    end
end
local function Func_AutoUsePotion()
    while Toggles.AutoPotion.Value do
        local selected = GetMultiSelection(Options.PotionDropdown, PotionList)
        for _, potion in ipairs(selected) do
            if not Toggles.AutoPotion.Value then break end
            FireRemote("ShopRE", "UsePotion", potion)
            task.wait(0.5)
        end
        task.wait(5)
    end
end
local function Func_AutoCraft()
    while Toggles.AutoCraftEquip.Value do
        local EquipmentRoot = WaitPlayerData("Equipment")
        if not EquipmentRoot then
            notyuri("[AutoCraftEquip] WaitPlayerData('Equipment') returned nil")
        else
            local entries = EquipmentRoot:GetChildren()
            notyuri("AutoCraftEquip: scanning " .. tostring(#entries) .. " equipment entries")
            local firedCount = 0
            for _, target in ipairs(entries) do
                if not Toggles.AutoCraftEquip.Value then break end
                local targetID = tostring(target:GetAttribute("ID") or target.Name or "")
                local targetRank = math.max(0, math.floor(tonumber(target:GetAttribute("Rank")) or 0))
                if targetID ~= "" and not (target:GetAttribute("Locked") == true) then
                    local matchCount = 0
                    for _, other in ipairs(entries) do
                        if other ~= target then
                            local otherID = tostring(other:GetAttribute("ID") or other.Name or "")
                            local otherRank = math.max(0, math.floor(tonumber(other:GetAttribute("Rank")) or 0))
                            local otherEquipped = other:GetAttribute("EquippedMountKey")
                            local otherLocked = other:GetAttribute("Locked") == true
                            if otherID == targetID and otherRank == targetRank and not otherLocked
                                and (otherEquipped == nil or otherEquipped == "") then
                                matchCount = matchCount + 1
                                if matchCount >= 2 then break end
                            end
                        end
                    end
                    if matchCount >= 2 then
                        local ok = FireRemote("EquipmentCraftRE", target.Name)
                        firedCount = firedCount + 1
                        notyuri("AutoCraftEquip: fired EquipmentCraftRE uid=" .. tostring(target.Name) .. " id=" .. targetID .. " rank=" .. tostring(targetRank) .. " ok=" .. tostring(ok))
                        task.wait(.1)
                    end
                end
            end
            if firedCount == 0 then
                notyuri("AutoCraftEquip: no eligible items found (need 2+ unlocked, unequipped duplicates of same ID+Rank)")
            end
        end
        task.wait(3)
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
        T1      = TB.Main.Left.Autofarm:AddTab("Autofarm"),
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
TB_Tabs.Autofarm.T1:AddToggle("AutoFire", { Text = "Auto Fire", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCapture", { Text = "Auto Capture", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPotion", { Text = "Auto Potion", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEquip", { Text = "Auto Equip", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCraftMount", { Text = "Auto Craft Mount", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoEvolve", { Text = "Auto Evolve", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCraftEquip", { Text = "Auto Craft Equiment", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPoint", { Text = "Auto Point", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoHatch", { Text = "Auto Egg", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAccelerate", { Text = "Auto Accelerate", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyCapsule", { Text = "Auto Buy Capsule", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyFood", { Text = "Auto Buy Food", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyGun", { Text = "Auto Buy Gun", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyMap", { Text = "Auto Buy Map", Default = false })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Inf Money", Func = function()
    FireRemote("FoodShopRE", "Buy", { ID = "Food01", Count = 0/0 })
end })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Teleport to Map 2", Func = function()
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(2036, 315, 1403)
    end
end })
local PotionListWithAny = {"Any"}
for _, v in ipairs(PotionList) do table.insert(PotionListWithAny, v) end
local BoostListWithAny = {"Any"}
for _, v in ipairs(BoostList) do table.insert(BoostListWithAny, v) end
local EggListWithAny = {"Any"}
for _, v in ipairs(EggList) do table.insert(EggListWithAny, v) end
local CapsuleListWithAny = {"Any"}
for _, v in ipairs(CapsuleList) do table.insert(CapsuleListWithAny, v) end
local FoodListWithAny = {"Any"}
for _, v in ipairs(FoodList) do table.insert(FoodListWithAny, v) end
local GunListWithAny = {"Any"}
for _, v in ipairs(GunList) do table.insert(GunListWithAny, v) end
TB_Tabs.Autofarm2.T1:AddDropdown("PotionDropdown", { Text = "Potion", Values = PotionListWithAny, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("BoostDropdown", { Text = "Boost ID", Values = BoostListWithAny, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("EggDropdown", { Text = "Egg", Values = EggListWithAny, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("CapsuleDropdown", { Text = "Capsule", Values = CapsuleListWithAny, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddDropdown("FoodDropdown", { Text = "Food", Values = FoodListWithAny, Default = {}, Multi = true, Searchable = true })
TB_Tabs.Autofarm2.T1:AddInput("FoodBuyCount", { Text = "Food Buy Count", Default = "1", Placeholder = "e.g. 100" })
TB_Tabs.Autofarm2.T1:AddDropdown("GunDropdown", { Text = "Gun", Values = GunListWithAny, Default = {}, Multi = true, Searchable = true })
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
Toggles.AutoFire:OnChanged(function(v) Thread("AutoFire", SafeLoop("AutoFire", Func_AutoFire), v) end)
Toggles.AutoRebirth:OnChanged(function(v) Thread("AutoRebirth", SafeLoop("AutoRebirth", Func_AutoRebirth), v) end)
Toggles.AutoEquip:OnChanged(function(v) Thread("AutoEquip", SafeLoop("AutoEquip", Func_AutoEquip), v) end)
Toggles.AutoCraftMount:OnChanged(function(v) Thread("AutoCraftMount", SafeLoop("AutoCraftMount", Func_AutoCraftMount), v) end)
Toggles.AutoSell:OnChanged(function(v) Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), v) end)
Toggles.AutoEvolve:OnChanged(function(v) Thread("AutoEvolve", SafeLoop("AutoEvolve", Func_AutoEvolve), v) end)
Toggles.AutoCapture:OnChanged(function(v) Thread("AutoCapture", SafeLoop("AutoCapture", Func_AutoCapture), v) end)
Toggles.AutoBuyCapsule:OnChanged(function(v) Thread("AutoBuyCapsule", SafeLoop("AutoBuyCapsule", Func_AutoBuy), v) end)
Toggles.AutoBuyFood:OnChanged(function(v) Thread("AutoBuyFood", SafeLoop("AutoBuyFood", Func_AutoBuyFood), v) end)
Toggles.AutoBuyGun:OnChanged(function(v) Thread("AutoBuyGun", SafeLoop("AutoBuyGun", Func_AutoBuyGun), v) end)
Toggles.AutoBuyMap:OnChanged(function(v) Thread("AutoBuyMap", SafeLoop("AutoBuyMap", Func_AutoBuyMap), v) end)
Toggles.AutoHatch:OnChanged(function(v) Thread("AutoHatch", SafeLoop("AutoHatch", Func_AutoHatch), v) end)
Toggles.AutoAccelerate:OnChanged(function(v) Thread("AutoAccelerate", SafeLoop("AutoAccelerate", Func_AutoAccelerate), v) end)
Toggles.AutoPoint:OnChanged(function(v) Thread("AutoPoint", SafeLoop("AutoPoint", Func_AutoPoint), v) end)
Toggles.AutoPotion:OnChanged(function(v) Thread("AutoPotion", SafeLoop("AutoPotion", Func_AutoUsePotion), v) end)
Toggles.AutoCraftEquip:OnChanged(function(v) Thread("AutoCraftEquip", SafeLoop("AutoCraftEquip", Func_AutoCraft), v) end)
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
SaveManager:SetFolder("Yuri/DinoHunters")
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