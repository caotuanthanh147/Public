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
    ResearchToken = nil,
    PTToken = nil,
    UpgradeToken = nil,
    STToken = nil,
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
local RemotesFolder = RS:FindFirstChild("remotes") or RS:WaitForChild("remotes", 10)
local Remotes = {
    upgrade = GetObject(RemotesFolder, "upgrade"),
    excavate = GetObject(RemotesFolder, "excavate"),
    GetPlayerUniqueSession = GetObject(RemotesFolder, "GetPlayerUniqueSession"),
    setting = GetObject(RemotesFolder, "setting"),
    challenge = GetObject(RemotesFolder, "challenge"),
    bonus_maxout = GetObject(RemotesFolder, "bonus") and GetObject(RemotesFolder:FindFirstChild("bonus"), "maxout"),
    research_upgrade = GetObject(RemotesFolder, "research_upgrade"),
    research_convert = GetObject(RemotesFolder, "research_convert"),
    astronomy_flight = GetObject(RemotesFolder, "astronomy") and GetObject(RemotesFolder:FindFirstChild("astronomy"), "flight"),
    astronomy_main = GetObject(RemotesFolder, "astronomy") and GetObject(RemotesFolder:FindFirstChild("astronomy"), "main"),
    astronomy_star = GetObject(RemotesFolder, "astronomy") and GetObject(RemotesFolder:FindFirstChild("astronomy"), "star"),
    ore_reset = GetObject(RemotesFolder, "ore_reset"),
    pt_upgrade = GetObject(RemotesFolder, "pt_upgrade"),
    click_xp = GetObject(RemotesFolder, "click_xp"),
    upgboard = GetObject(RemotesFolder, "upgboard"),
    enhancematerial = RemotesFolder:FindFirstChild("masteryenhance") and RemotesFolder.masteryenhance:FindFirstChild("enhancematerial"),
    depthchange = GetObject(RemotesFolder, "depthchange"),
    equipment = GetObject(RemotesFolder, "equipment"),
    materials = GetObject(RemotesFolder, "materials"),
    startree_upgrade = GetObject(RemotesFolder, "startree_upgrade"),
}
local ModulesFolder = RS:FindFirstChild("modules")
local function RequireMod(name)
    local m = ModulesFolder and ModulesFolder:FindFirstChild(name)
    if m and m:IsA("ModuleScript") then
        local ok, res = pcall(require, m)
        if ok then return res end
    end
    return nil
end
local function RequireNestedMod(...)
    local m = ModulesFolder
    for _, name in ipairs({...}) do
        m = m and m:FindFirstChild(name)
    end
    if m and m:IsA("ModuleScript") then
        local ok, res = pcall(require, m)
        if ok then return res end
    end
    return nil
end
local Game = {
    gfuncs = RequireMod("gfuncs"),
    en = RequireMod("en"),
    game_data = RequireNestedMod("libraries", "game_data"),
}
local function GetStats()
    return RS:FindFirstChild("stats")
end
local function GetUpgradeLevel(name)
    local stats = GetStats()
    local ups = stats and stats:FindFirstChild("upgrades")
    local val = ups and ups:FindFirstChild(name)
    if not val then return 0 end
    return val.Value
end
local function GetResearchLevel(name)
    local stats = GetStats()
    local rups = stats and stats:FindFirstChild("research_upgrades")
    local val = rups and rups:FindFirstChild(name)
    if not val then return 0 end
    return val.Value
end
local function GetUpgradeToken()
    if Shared.UpgradeToken and type(Shared.UpgradeToken) == "string" and #Shared.UpgradeToken > 0 then
        return Shared.UpgradeToken
    end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then return nil end
    local targetScript
    pcall(function()
        targetScript = Plr:WaitForChild("PlayerScripts", 3):FindFirstChild("mouse_behaviour")
    end)
    if not targetScript then return nil end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        if not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or type(env) ~= "table" then continue end
        if rawget(env, "script") ~= targetScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or type(uvs) ~= "table" then continue end
        for _, v in pairs(uvs) do
            if type(v) == "string" and #v > 0 then
                Shared.UpgradeToken = v
                notyuri("[UpgradeToken] extracted via getfenv(mouse_behaviour):", #v)
                return Shared.UpgradeToken
            end
        end
    end
    return nil
end
local function GetResearchToken()
    if Shared.ResearchToken and type(Shared.ResearchToken) == "string" and #Shared.ResearchToken > 0 then
        return Shared.ResearchToken
    end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then return nil end
    local targetScript
    pcall(function()
        targetScript = workspace:WaitForChild("objects", 3)
            and workspace.objects:FindFirstChild("research_center")
            and workspace.objects.research_center:FindFirstChild("research_handler")
    end)
    if not targetScript then
        notyuri("[ResearchToken] research_handler script not found")
        return nil
    end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        if not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or type(env) ~= "table" then continue end
        if rawget(env, "script") ~= targetScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or type(uvs) ~= "table" then continue end
        for _, v in pairs(uvs) do
            if type(v) == "string" and #v > 0 then
                Shared.ResearchToken = v
                notyuri("[ResearchToken] extracted via getfenv(research_handler):", #v)
                return Shared.ResearchToken
            end
        end
    end
    return nil
end
local function GetPTToken()
    if Shared.PTToken and type(Shared.PTToken) == "string" and #Shared.PTToken > 0 then
        return Shared.PTToken
    end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then return nil end
    local targetScript
    pcall(function()
        targetScript = workspace:FindFirstChild("objects")
            and workspace.objects:FindFirstChild("periodic_table")
            and workspace.objects.periodic_table:FindFirstChild("periodic_handler")
    end)
    if not targetScript then
        notyuri("[PTToken] periodic_handler script not found")
        return nil
    end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        if not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or type(env) ~= "table" then continue end
        if rawget(env, "script") ~= targetScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or type(uvs) ~= "table" then continue end
        for _, v in pairs(uvs) do
            if type(v) == "string" and #v > 0 then
                Shared.PTToken = v
                notyuri("[PTToken] extracted via getfenv(periodic_handler):", #v)
                return Shared.PTToken
            end
        end
    end
    return nil
end
local function GetSTToken()
    if Shared.STToken and type(Shared.STToken) == "string" and #Shared.STToken > 0 then
        return Shared.STToken
    end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    if not (getgc and dbgGetUpvals) then return nil end
    local targetScript
    pcall(function()
        targetScript = workspace:FindFirstChild("objects")
            and workspace.objects:FindFirstChild("star_tree")
            and workspace.objects.star_tree:FindFirstChild("startree_handler")
    end)
    if not targetScript then
        notyuri("[STToken] startree_handler script not found")
        return nil
    end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        if not islclosureFn(fn) then continue end
        local ok2, env = pcall(getfenv, fn)
        if not ok2 or type(env) ~= "table" then continue end
        if rawget(env, "script") ~= targetScript then continue end
        local ok3, uvs = pcall(dbgGetUpvals, fn)
        if not ok3 or type(uvs) ~= "table" then continue end
        for _, v in pairs(uvs) do
            if type(v) == "string" and #v > 0 then
                Shared.STToken = v
                notyuri("[STToken] extracted via getfenv(startree_handler):", #v)
                return Shared.STToken
            end
        end
    end
    return nil
end
task.spawn(function()
    while true do
        if not Shared.UpgradeToken or #Shared.UpgradeToken == 0 then
            GetUpgradeToken()
        end
        if not Shared.ResearchToken or #Shared.ResearchToken == 0 then
            GetResearchToken()
        end
        if not Shared.PTToken or #Shared.PTToken == 0 then
            GetPTToken()
        end
        if not Shared.STToken or #Shared.STToken == 0 then
            GetSTToken()
        end
        task.wait(2)
    end
end)
local function CanBuyUpgrade(name, upgradesFolder, statsUpgrades, ModuleCache)
    local model = upgradesFolder:FindFirstChild(name)
    if not model then return false, "locked" end
    local levelVal = statsUpgrades:FindFirstChild(name)
    if not levelVal then return false, "no level value" end
    local module = ModuleCache[name]
    if module == nil then
        local ok, m = pcall(require, model.config)
        module = (ok and m) or false
        ModuleCache[name] = module
    end
    if not module then return false, "no config module" end
    if module.tags and (table.find(module.tags, "mechanic") or table.find(module.tags, "resetlayer")) then
        return false, "excluded tag"
    end
    local max = type(module.max) == "function" and module.max() or module.max
    if levelVal.Value >= max then return false, "maxed" end
    local canBuy = false
    pcall(function() canBuy = module.can_buy(levelVal.Value, max, nil, nil, Players.LocalPlayer) end)
    return canBuy, canBuy and "ok" or "cannot afford"
end
local function GetAllUpgradeNames()
    local upgradesFolder = workspace:FindFirstChild("upgrades")
    if not upgradesFolder then return {} end
    local list = {}
    for _, child in ipairs(upgradesFolder:GetChildren()) do
        if child:IsA("Model") then table.insert(list, child.Name) end
    end
    table.sort(list)
    return list
end
local function GetAllResearchNames()
    local stats = GetStats()
    local rups = stats and stats:FindFirstChild("research_upgrades")
    if not rups then return {} end
    local list = {}
    for _, child in ipairs(rups:GetChildren()) do
        if child:IsA("IntValue") then table.insert(list, child.Name) end
    end
    table.sort(list)
    return list
end
local function GetOres(maxDist)
    local ores = {}
    local ok, tagged = pcall(function() return CollectionService:GetTagged("ore") end)
    if not ok or not tagged then return ores end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hpos = hrp and hrp.Position
    for _, ore in ipairs(tagged) do
        if ore:IsA("Model") or ore:IsA("BasePart") then
            if maxDist and hpos then
                local opos = ore:IsA("Model") and (ore:GetPivot().Position) or ore.Position
                if (opos - hpos).Magnitude <= maxDist then
                    table.insert(ores, ore)
                end
            else
                table.insert(ores, ore)
            end
        end
    end
    return ores
end
local function Func_AutoBuyUpgrades()
    local firedLevel = {}
    local conns = {}
    local ModuleCache = {}
    local Blacklist = {
        ["0d"] = true,
        ["20"] = true,
        ["23t"] = true,
        ["24t"] = true,
        ["15x"] = true,       
    }
    while Toggles.E_AutoBuyUpgrades.Value do
        if not Shared.UpgradeToken or #Shared.UpgradeToken == 0 then
            notyuri("[AutoBuyUpgrades] no session token yet (waiting for game to load)")
            repeat task.wait(0.5) until (Shared.UpgradeToken and #Shared.UpgradeToken > 0) or not Toggles.E_AutoBuyUpgrades.Value
            if not Toggles.E_AutoBuyUpgrades.Value then break end
        end
        if Remotes.upgrade then
            local upgradesFolder = workspace:FindFirstChild("upgrades")
            local statsUpgrades = RS.stats and RS.stats:FindFirstChild("upgrades")
            if not upgradesFolder or not statsUpgrades then task.wait(0.1) continue end
            local names = GetAllUpgradeNames()
            for _, name in ipairs(names) do
                if not Toggles.E_AutoBuyUpgrades.Value then break end
                if Blacklist[name] then continue end
                local currentLevel = GetUpgradeLevel(name)
                local canBuy, buyReason = CanBuyUpgrade(name, upgradesFolder, statsUpgrades, ModuleCache)
                if not canBuy then
                    notyuri("[AutoBuyUpgrades] cannotBuy", name, "reason:", buyReason)
                end
                if canBuy then
                    pcall(function() Remotes.upgrade:FireServer(name, Shared.UpgradeToken) end)
                    task.wait(0.05)
                    local newLevel = GetUpgradeLevel(name)
                    if newLevel > currentLevel then
                        local stillBuy = CanBuyUpgrade(name, upgradesFolder, statsUpgrades, ModuleCache)
                        if stillBuy then
                            pcall(function() Remotes.upgrade:FireServer(name, Shared.UpgradeToken) end)
                            task.wait()
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoOreReset()
    local oreStatus = RS.stats:FindFirstChild("ore")
    if not oreStatus then
        warn("[AutoOreReset] RS.stats.ore not found")
        return
    end
    local timestamp = oreStatus:FindFirstChild("timestamp")
    if not timestamp then
        warn("[AutoOreReset] RS.stats.ore.timestamp not found")
        return
    end
    local lastChange = os.clock()
    local conn = timestamp.Changed:Connect(function()
        lastChange = os.clock()
    end)
    while Toggles.E_AutoOreReset.Value do
        local delay = Options.E_OreResetDelay and Options.E_OreResetDelay.Value or 10
        if os.clock() - lastChange >= delay then
            if Remotes.ore_reset then
                pcall(function() Remotes.ore_reset:InvokeServer() end)
                notyuri("[AutoOreReset] ore stuck, reset fired")
                lastChange = os.clock()
            else
                warn("[AutoOreReset] ore_reset remote not found")
            end
        end
        task.wait(0.5)
    end
    conn:Disconnect()
end
local function Func_AutoExcavate()
    while Toggles.E_AutoExcavate.Value do
        if Remotes.excavate then
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local oreFolder = workspace.objects:FindFirstChild("harvestingbaseplate")
                and workspace.objects.harvestingbaseplate:FindFirstChild("miningbase")
                and workspace.objects.harvestingbaseplate.miningbase:FindFirstChild("_ore")
            local nearOre = false
            if hrp and oreFolder then
                local hrpPos = hrp.Position
                for _, ore in ipairs(oreFolder:GetChildren()) do
                    if ore:IsA("Model") then
                        local orePos = ore:GetPivot().Position
                        if (hrpPos - orePos).Magnitude <= 30 then
                            nearOre = true
                            break
                        end
                    end
                end
            end
            if not nearOre then
                task.wait(0.1)
                continue
            end
            local backpack = Plr:FindFirstChildOfClass("Backpack")
            local pickaxe = (char and char:FindFirstChildOfClass("Tool"))
                or (backpack and backpack:FindFirstChildOfClass("Tool"))
            if pickaxe then
                local ok, result = pcall(function() return Remotes.excavate:InvokeServer("mine", pickaxe) end)
                if ok and result then
                    notyuri("[AutoExcavate] mined")
                end
            else
                notyuri("[AutoExcavate] no pickaxe tool found in character or backpack")
            end
        else
            notyuri("[AutoExcavate] excavate remote not found")
        end
        task.wait(0.1)
    end
end
local function Func_AutoHighestDepth()
    local other = RS.stats.server_settings.other
    local pref_dlvl = other and other:FindFirstChild("pref_dlvl")
    local max_dlvl = other and other:FindFirstChild("max_dlvl")
    while Toggles.E_AutoHighestDepth.Value do
        if Remotes.depthchange then
            if pref_dlvl and max_dlvl then
                if pref_dlvl.Value < max_dlvl.Value then
                    pcall(function() Remotes.depthchange:FireServer("next") end)
                    notyuri("[AutoHighestDepth] depth", pref_dlvl.Value, "->", pref_dlvl.Value + 1, "/ max", max_dlvl.Value)
                end
            else
                notyuri("[AutoHighestDepth] pref_dlvl or max_dlvl not found")
            end
        else
            notyuri("[AutoHighestDepth] depthchange remote not found")
        end
        task.wait(0.5)
    end
end
local function Func_AutoSellMaterials()
    while Toggles.E_AutoSellMaterials.Value do
        if Remotes.materials then
            local selected = Options.E_SellMaterialsList and Options.E_SellMaterialsList.Value
            if selected then
                for matName, active in pairs(selected) do
                    if not Toggles.E_AutoSellMaterials.Value then break end
                    if not active then continue end
                    local matSV = RS.stats.materials:FindFirstChild(matName)
                    if matSV then
                        local qty = matSV.Value
                        if qty and qty ~= "" and qty ~= "0" then
                            pcall(function() Remotes.materials:FireServer("sell", matName, qty) end)
                            notyuri("[AutoSellMaterials] sold", matName, qty)
                        end
                    end
                    task.wait(0.1)
                end
            end
        else
            notyuri("[AutoSellMaterials] materials remote not found")
        end
        task.wait(1)
    end
end
local function Func_AutoSmeltOre()
    while Toggles.E_AutoSmeltOre.Value do
        if Remotes.equipment then
            local forge_module = require(RS.modules.libraries.game_data.forge)
            local activeforges = RS.stats.activeforges
            for k, v in pairs(forge_module) do
                if not Toggles.E_AutoSmeltOre.Value then break end
                if v.section == "pickaxes" or v.section == "gear" then continue end
                local qty = (Options.E_SmeltQty and Options.E_SmeltQty.Value) or "0;1"
                local forgeEntry = activeforges:FindFirstChild(k)
                if forgeEntry then
                    local tr = forgeEntry:FindFirstChild("tr")
                    if tr and tonumber(tr.Value) <= 0 then
                        pcall(function() Remotes.equipment:FireServer("forgeclaim", k) end)
                        notyuri("[AutoSmelt] forgeclaim", k)
                    end
                else
                    pcall(function() Remotes.equipment:FireServer("forge", k, qty) end)
                    notyuri("[AutoSmelt] forge", k, qty)
                end
                task.wait(0.1)
            end
        else
            notyuri("[AutoSmelt] equipment remote not found")
        end
        task.wait()
    end
end
local function Func_AutoChallenge()
    while Toggles.E_AutoChallenge.Value do
        if Remotes.challenge then
            local sel = Options.E_ChallengeName and Options.E_ChallengeName.Value or ""
            if sel and sel ~= "" then
                pcall(function() Remotes.challenge:FireServer("initiate", sel) end)
                notyuri("[AutoChallenge] initiate", sel)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoMaxout()
    while Toggles.E_AutoMaxout.Value do
        if Remotes.bonus_maxout then
            pcall(function() Remotes.bonus_maxout:FireServer() end)
            notyuri("[AutoMaxout] fired bonus.maxout")
        end
        task.wait(.2)
    end
end
local function Func_AutoResearch()
    while Toggles.E_AutoResearch.Value do
        if Remotes.research_upgrade and Game.game_data then
            if not Shared.ResearchToken or #Shared.ResearchToken == 0 then
                notyuri("[AutoResearch] no research token yet (waiting for game to load)")
                repeat task.wait(0.5) until (Shared.ResearchToken and #Shared.ResearchToken > 0) or not Toggles.E_AutoResearch.Value
                if not Toggles.E_AutoResearch.Value then break end
            end
            local stats = GetStats()
            local rups = stats and stats:FindFirstChild("research_upgrades")
            if rups then
                for name, data in pairs(Game.game_data.research) do
                    if not Toggles.E_AutoResearch.Value then break end
                    local ok, show = pcall(function() return data.when_to_show() end)
                    if not ok or not show then continue end
                    local val = rups:FindFirstChild(name)
                    if not val then continue end
                    local currentLevel = val.Value
                    local max = type(data.max) == "function" and data.max() or data.max
                    if max <= currentLevel then continue end
                    local canBuy = false
                    pcall(function() canBuy = data.can_buy(currentLevel, max) end)
                    if not canBuy then continue end
                    pcall(function() Remotes.research_upgrade:FireServer(name, nil, Shared.ResearchToken) end)
                    notyuri("[AutoResearch] bought", name)
                    task.wait(0.05)
                end
            end
        end
        task.wait(0.1)
    end
end
local function MakeAutoResetFunc(toggleId, upgradeId, gainKey, thresholdId)
    return function()
        while Toggles[toggleId].Value do
            if Game.en then
                local thresholdRaw = tonumber(Options[thresholdId] and Options[thresholdId].Value) or 0
                if thresholdRaw > 0 then
                    local threshold = Game.en.convert(thresholdRaw)
                    local gainVal = RS:FindFirstChild("temp") and RS.temp:FindFirstChild(gainKey)
                    if gainVal and Game.en.meeq(Game.en.convert(gainVal.Value), threshold) then
                        local model = (workspace:FindFirstChild("upgrades") and workspace.upgrades:FindFirstChild(upgradeId))
                            or (RS:FindFirstChild("locked_upgs") and RS.locked_upgs:FindFirstChild(upgradeId))
                        local voteRequest = model and model:FindFirstChild("vote_request")
                        if voteRequest then
                            pcall(function() voteRequest:FireServer(true) end)
                            notyuri("[AutoReset] voted", upgradeId, "gain:", gainKey)
                        end
                    end
                end
            end
            task.wait(1)
        end
    end
end
local Func_AutoResetGold  = MakeAutoResetFunc("E_AutoResetGold",  "0g", "g_gain_reset", "E_ResetThresholdGold")
local Func_AutoResetTrans = MakeAutoResetFunc("E_AutoResetTrans", "0t", "t_gain_reset", "E_ResetThresholdTrans")
local Func_AutoResetPres  = MakeAutoResetFunc("E_AutoResetPres",  "0p", "r_gain_reset", "E_ResetThresholdPres")
local function Func_AutoPTUpgrade()
    local elementsData = require(RS.modules.libraries.game_data.elements)
    while Toggles.E_AutoPTUpgrade.Value do
        if not Shared.PTToken or #Shared.PTToken == 0 then
            notyuri("[AutoPTUpgrade] no PT token yet (waiting)")
            repeat task.wait(0.5) until (Shared.PTToken and #Shared.PTToken > 0) or not Toggles.E_AutoPTUpgrade.Value
            if not Toggles.E_AutoPTUpgrade.Value then break end
        end
        if Remotes.pt_upgrade then
            local elementsFolder = RS.stats.elements
            for _, child in ipairs(elementsFolder:GetChildren()) do
                if not Toggles.E_AutoPTUpgrade.Value then break end
                local sym = child.Name
                if child.Value then continue end 
                local config = elementsData[sym]
                if not config then continue end
                local ok, cost, currencyObj, canBuy = pcall(config.purchase, sym, false)
                if not ok then
                    notyuri("[AutoPTUpgrade] purchase check error for", sym, tostring(cost))
                    continue
                end
                if not canBuy then continue end
                notyuri("[AutoPTUpgrade] buying", sym)
                pcall(function() Remotes.pt_upgrade:FireServer(sym, Shared.PTToken) end)
                task.wait(0.5)
            end
        end
        task.wait(.2)
    end
end
local function Func_AutoSTUpgrade()
    local startreeData = RequireNestedMod("libraries", "game_data", "startree")
    while Toggles.E_AutoSTUpgrade.Value do
        if not Shared.STToken or #Shared.STToken == 0 then
            notyuri("[AutoSTUpgrade] no ST token yet (waiting)")
            repeat task.wait(0.5) until (Shared.STToken and #Shared.STToken > 0) or not Toggles.E_AutoSTUpgrade.Value
            if not Toggles.E_AutoSTUpgrade.Value then break end
        end
        if Remotes.startree_upgrade and startreeData then
            local startreeFolder = RS.stats:FindFirstChild("startree")
            for upgName, upgConfig in pairs(startreeData.startree) do
                if not Toggles.E_AutoSTUpgrade.Value then break end
                local valObj = startreeFolder and startreeFolder:FindFirstChild(upgName)
                if not valObj then continue end
                local currentLevel = valObj.Value
                local maxLevel = type(upgConfig.max) == "function" and upgConfig.max() or upgConfig.max
                if currentLevel >= maxLevel then continue end
                local canBuy = false
                local ok, result = pcall(upgConfig.can_buy, currentLevel, maxLevel, false, nil)
                if ok then canBuy = result end
                if not canBuy then continue end
                notyuri("[AutoSTUpgrade] buying", upgName)
                pcall(function() Remotes.startree_upgrade:FireServer(upgName, nil, Shared.STToken) end)
                task.wait(0.5)
            end
        end
        task.wait(0.2)
    end
end
local function Func_AutoAstronomy()
    while Toggles.E_AutoAstronomy.Value do
        if Remotes.astronomy_main then
            local en = Game.en
            local gfuncs = Game.gfuncs
            local stats = GetStats()
            if en and gfuncs and stats then
                local gammaVal = en.fromString(stats.currencies.gamma.Value)
                local starCount = #stats.stars:GetChildren()
                if starCount < 100 then
                    local price = starCount < 1 and en.zero or gfuncs.dynamic_management.get_star_price(starCount)
                    if en.meeq(gammaVal, price) then
                        pcall(function() Remotes.astronomy_main:InvokeServer("star_buy", "") end)
                        task.wait(0.3)
                        stats = GetStats()
                        gammaVal = en.fromString(stats.currencies.gamma.Value)
                    end
                end
                local constellationCap = stats.astronomy.constellation_cap.Value
                local constellationPrice = gfuncs.dynamic_management.get_constellation_price(constellationCap)
                if en.meeq(gammaVal, constellationPrice) then
                    pcall(function() Remotes.astronomy_main:InvokeServer("constellation_buy", "") end)
                    task.wait(0.3)
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoConstellation()
    while Toggles.E_AutoConstellation.Value do
        if Remotes.astronomy_star then
            local stats = GetStats()
            if stats then
                local allStars = stats.stars:GetChildren()
                local usedStars = {}
                for _, c in ipairs(stats.constellations:GetChildren()) do
                    for _, name in ipairs(c.Value:split("/")) do
                        usedStars[name] = true
                    end
                end
                local free = {}
                for _, star in ipairs(allStars) do
                    if not usedStars[star.Name] then
                        table.insert(free, tonumber(star.Name))
                    end
                end
                if #free >= 3 then
                    local cap = math.min(#free, 7)
                    local t = {}
                    for i = 1, cap do
                        table.insert(t, free[i])
                    end
                    pcall(function() Remotes.astronomy_star:InvokeServer("constellation", t) end)
                    task.wait(0.5)
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoUpgBoard()
    while Toggles.E_AutoUpgBoard.Value do
        if Remotes.upgboard then
            pcall(function() Remotes.upgboard:FireServer("recovery", "sync_pd", "max") end)
            pcall(function() Remotes.upgboard:FireServer("recovery", "sync_dt", "max") end)
            pcall(function() Remotes.upgboard:FireServer("recovery", "sync_eos", "max") end)
            notyuri("[AutoUpgBoard] fired recovery upgrades")
            local ok, upgBoardData = pcall(function() return require(RS.modules.libraries.game_data.upgrade_boards) end)
            if ok and upgBoardData then
                local boardUpgrades = {
                    star_booster = {"px", "axp", "mass", "exp"},
                    star_modifier = {"mass", "temp", "homage"},
                    everything_board = {
                        "newoffline", "ultimate", "points", "prestige", "rp", "bits", "ptsx", "sm",
                        "tpts", "ions", "depth", "euros", "qubits", "gamma", "starscore", "stardust",
                        "cube", "alpha", "chips", "beta", "mspoints", "cash", "gold",
                    },
                    mango = {"more_alpha", "more_beta", "mango_multi", "mango_cap", "theupgradethatdoesnothing"},
                    minesweeper = {
                        "more_mspts", "mines_reduction", "mines_reduction_perc", "more_alpha", "more_beta",
                        "mango_multi", "mango_cap", "more_density", "more_mistakes", "more_safe_plots", "board_size",
                    },
                    autocollector = {"fastercollection", "bulkcollection", "duplication"},
                }
                local statsBoards = RS:FindFirstChild("stats") and RS.stats:FindFirstChild("upgrade_boards")
                if statsBoards then
                    for boardName, upgradeIds in pairs(boardUpgrades) do
                        local boardModule = upgBoardData[boardName]
                        local boardStats = statsBoards:FindFirstChild(boardName)
                        if boardModule and boardStats then
                            for _, upgradeId in ipairs(upgradeIds) do
                                local upgradeTable = boardModule[upgradeId]
                                local levelVal = boardStats:FindFirstChild(upgradeId)
                                if upgradeTable and levelVal then
                                    local currentLevel = levelVal.Value
                                    local maxLevel = 0
                                    pcall(function()
                                        maxLevel = type(upgradeTable.maximum) == "function" and upgradeTable.maximum() or upgradeTable.maximum
                                    end)
                                    if currentLevel < maxLevel then
                                        local canBuy = false
                                        pcall(function()
                                            canBuy = upgradeTable.can_buy(upgradeTable, currentLevel, maxLevel, "1")
                                        end)
                                        if canBuy then
                                            pcall(function() Remotes.upgboard:FireServer(boardName, upgradeId, "max") end)
                                            notyuri("[AutoUpgBoard] bought " .. boardName .. "/" .. upgradeId)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoMechanic_0qa()
    while Toggles.E_AutoMechanic_0qa.Value do
        if not Shared.UpgradeToken or #Shared.UpgradeToken == 0 then
            notyuri("[AutoMechanic_0qa] waiting for session token")
            repeat task.wait(0.5) until (Shared.UpgradeToken and #Shared.UpgradeToken > 0) or not Toggles.E_AutoMechanic_0qa.Value
            if not Toggles.E_AutoMechanic_0qa.Value then break end
        end
        local temp = RS:FindFirstChild("temp")
        local stats = RS:FindFirstChild("stats")
        local bits = stats and stats:FindFirstChild("currencies") and stats.currencies:FindFirstChild("bits")
        local en = Game.en
        if en and bits and en.billion <= en.convert(bits.Value) then
            notyuri("[AutoMechanic_0qa] buying bits->qubits convert")
            pcall(function() Remotes.upgrade:FireServer("0qa", Shared.UpgradeToken) end)
        end
        task.wait(1)
    end
end
local function Func_AutoMechanic_0bplus()
    while Toggles.E_AutoMechanic_0bplus.Value do
        if not Shared.UpgradeToken or #Shared.UpgradeToken == 0 then
            notyuri("[AutoMechanic_0bplus] waiting for session token")
            repeat task.wait(0.5) until (Shared.UpgradeToken and #Shared.UpgradeToken > 0) or not Toggles.E_AutoMechanic_0bplus.Value
            if not Toggles.E_AutoMechanic_0bplus.Value then break end
        end
        local temp = RS:FindFirstChild("temp")
        local beta_cooldown = temp and temp:FindFirstChild("beta_cooldown")
        if beta_cooldown and beta_cooldown.Value == 0 then
            notyuri("[AutoMechanic_0bplus] buying alpha->beta convert")
            pcall(function() Remotes.upgrade:FireServer("0b+", Shared.UpgradeToken) end)
        end
        task.wait(1)
    end
end
local function Func_AutoMechanic_1xb()
    while Toggles.E_AutoMechanic_1xb.Value do
        if not Shared.UpgradeToken or #Shared.UpgradeToken == 0 then
            notyuri("[AutoMechanic_1xb] waiting for session token")
            repeat task.wait(0.5) until (Shared.UpgradeToken and #Shared.UpgradeToken > 0) or not Toggles.E_AutoMechanic_1xb.Value
            if not Toggles.E_AutoMechanic_1xb.Value then break end
        end
        local temp = RS:FindFirstChild("temp")
        local ptsx_cooldown = temp and temp:FindFirstChild("ptsx_cooldown")
        local x13active = temp and temp:FindFirstChild("13xactive")
        if ptsx_cooldown and ptsx_cooldown.Value == 0 then
            local blocked = x13active and x13active.Value and GetUpgradeLevel("35t") < 1
            if not blocked then
                notyuri("[AutoMechanic_1xb] buying xp->darkxp convert")
                pcall(function() Remotes.upgrade:FireServer("1xb", Shared.UpgradeToken) end)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoMechanic_1x()
    while Toggles.E_AutoMechanic_1x.Value do
        if not Shared.UpgradeToken or #Shared.UpgradeToken == 0 then
            notyuri("[AutoMechanic_1x] waiting for session token")
            repeat task.wait(0.5) until (Shared.UpgradeToken and #Shared.UpgradeToken > 0) or not Toggles.E_AutoMechanic_1x.Value
            if not Toggles.E_AutoMechanic_1x.Value then break end
        end
        local temp = RS:FindFirstChild("temp")
        local ptsx_cooldown = temp and temp:FindFirstChild("ptsx_cooldown")
        if ptsx_cooldown and ptsx_cooldown.Value == 0 then
            notyuri("[AutoMechanic_1x] buying pts->ptsx convert")
            pcall(function() Remotes.upgrade:FireServer("1x", Shared.UpgradeToken) end)
        end
        task.wait(1)
    end
end
local function Func_AutoClickXP()
    while Toggles.E_AutoClickXP.Value do
        if Remotes.click_xp then
            pcall(function() Remotes.click_xp:FireServer() end)
        end
        task.wait()
    end
end
local function Func_AutoEnhanceMastery()
    local materialsModule = RequireNestedMod("libraries", "game_data", "materials")
    while Toggles.E_AutoEnhanceMastery.Value do
        if Remotes.enhancematerial and materialsModule then
            local stats = GetStats()
            local buymax = stats and stats:FindFirstChild("settings") and stats.settings:FindFirstChild("buymax")
            local buymaxVal = buymax and buymax.Value or false
            for name, data in pairs(materialsModule.materials) do
                if not Toggles.E_AutoEnhanceMastery.Value then break end
                if data.can_master then
                    pcall(function() Remotes.enhancematerial:FireServer(name, buymaxVal) end)
                    task.wait(0.1)
                end
            end
        end
        task.wait(1)
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
        T2 = TB.Main.Left.Autofarm:AddTab("Mechanic"),
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
TB_Tabs.Autofarm.T1:AddToggle("E_AutoBuyUpgrades", {
    Text = "Auto Buy Upgrades",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoPTUpgrade", {
    Text = "Auto PT Upgrade",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoSTUpgrade", {
    Text = "Auto Star Upgrade",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoAstronomy", {
    Text = "Auto Astronomy",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoConstellation", {
    Text = "Auto Constellation",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoUpgBoard", {
    Text = "Auto Upgrade Board",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoResearch", {
    Text = "Auto Buy Research Upgrade",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoClickXP", {
    Text = "Auto Click XP",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("E_AutoChallenge", {
    Text = "Auto Start Challenge",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("E_ChallengeName", {
    Text = "Challenge",
    Values = {
        "point_deduction",
        "science_extinction",
        "double_trouble",
        "cash_challenge",
        "get_funky",
        "fast_transcend",
        "change_of_pace",
        "everything_deduction",
        "hardcore_challenge",
        "real_timed-challenge",
    },
    Default = "point_deduction",
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoResetPres", {
    Text = "Auto Prestige Reset",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddInput("E_ResetThresholdPres", {
    Text = "Prestige Threshold",
    Default = "1e16",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoResetGold", {
    Text = "Auto Goldify Reset",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddInput("E_ResetThresholdGold", {
    Text = "Goldify Threshold",
    Default = "5000",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoResetTrans", {
    Text = "Auto Transcend Reset",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddInput("E_ResetThresholdTrans", {
    Text = "Transcend Threshold",
    Default = "1e9",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T2:AddToggle("E_AutoMechanic_0qa", {
    Text = "Auto Bits to Qubits",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("E_AutoMechanic_0bplus", {
    Text = "Auto Alpha to Beta",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("E_AutoMechanic_1xb", {
    Text = "Auto XP to DarkXP",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("E_AutoMechanic_1x", {
    Text = "Auto Pts to PtsX",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoEnhanceMastery", {
    Text = "Auto Enhance Mastery",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoExcavate", {
    Text = "Auto Excavate",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("E_AutoOreReset", {
    Text = "Auto Ore Reset",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddSlider("E_OreResetDelay", {
    Text = "Ore Reset Delay",
    Default = 10,
    Min = 3,
    Max = 180,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoHighestDepth", {
    Text = "Auto Highest Depth",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoSmeltOre", {
    Text = "Auto Smelt Ore",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddInput("E_SmeltQty", {
    Text = "Smelt Quantity",
    Default = "0;1",
    ClearTextOnFocus = false,
})
TB_Tabs.Autofarm.T1:AddToggle("E_AutoSellMaterials", {
    Text = "Auto Sell Materials",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("E_SellMaterialsList", {
    Text = "Materials List",
    Values = {},
    Default = {},
    Multi = true,
    Searchable = true,
})
task.delay(3, function()
    local matNames = {}
    for _, child in ipairs(RS.stats.materials:GetChildren()) do
        if child:IsA("StringValue") then
            table.insert(matNames, child.Name)
        end
    end
    table.sort(matNames)
    Options.E_SellMaterialsList:SetValues(matNames)
end)
Toggles.E_AutoChallenge:OnChanged(function(v) Thread("E_AutoChallenge", Func_AutoChallenge, v) end)
Toggles.E_AutoBuyUpgrades:OnChanged(function(v) Thread("E_AutoBuyUpgrades", Func_AutoBuyUpgrades, v) end)
Toggles.E_AutoExcavate:OnChanged(function(v) Thread("E_AutoExcavate", Func_AutoExcavate, v) end)
Toggles.E_AutoOreReset:OnChanged(function(v) Thread("E_AutoOreReset", Func_AutoOreReset, v) end)
Toggles.E_AutoHighestDepth:OnChanged(function(v) Thread("E_AutoHighestDepth", Func_AutoHighestDepth, v) end)
Toggles.E_AutoSmeltOre:OnChanged(function(v) Thread("E_AutoSmeltOre", Func_AutoSmeltOre, v) end)
Toggles.E_AutoResearch:OnChanged(function(v) Thread("E_AutoResearch", Func_AutoResearch, v) end)
Toggles.E_AutoResetGold:OnChanged(function(v) Thread("E_AutoResetGold", Func_AutoResetGold, v) end)
Toggles.E_AutoResetTrans:OnChanged(function(v) Thread("E_AutoResetTrans", Func_AutoResetTrans, v) end)
Toggles.E_AutoResetPres:OnChanged(function(v) Thread("E_AutoResetPres", Func_AutoResetPres, v) end)
Toggles.E_AutoMechanic_0qa:OnChanged(function(v) Thread("E_AutoMechanic_0qa", Func_AutoMechanic_0qa, v) end)
Toggles.E_AutoMechanic_0bplus:OnChanged(function(v) Thread("E_AutoMechanic_0bplus", Func_AutoMechanic_0bplus, v) end)
Toggles.E_AutoMechanic_1xb:OnChanged(function(v) Thread("E_AutoMechanic_1xb", Func_AutoMechanic_1xb, v) end)
Toggles.E_AutoMechanic_1x:OnChanged(function(v) Thread("E_AutoMechanic_1x", Func_AutoMechanic_1x, v) end)
Toggles.E_AutoPTUpgrade:OnChanged(function(v) Thread("E_AutoPTUpgrade", Func_AutoPTUpgrade, v) end)
Toggles.E_AutoSTUpgrade:OnChanged(function(v) Thread("E_AutoSTUpgrade", Func_AutoSTUpgrade, v) end)
Toggles.E_AutoAstronomy:OnChanged(function(v) Thread("E_AutoAstronomy", Func_AutoAstronomy, v) end)
Toggles.E_AutoConstellation:OnChanged(function(v) Thread("E_AutoConstellation", Func_AutoConstellation, v) end)
Toggles.E_AutoUpgBoard:OnChanged(function(v) Thread("E_AutoUpgBoard", Func_AutoUpgBoard, v) end)
Toggles.E_AutoClickXP:OnChanged(function(v) Thread("E_AutoClickXP", Func_AutoClickXP, v) end)
Toggles.E_AutoEnhanceMastery:OnChanged(function(v) Thread("E_AutoEnhanceMastery", Func_AutoEnhanceMastery, v) end)
Toggles.E_AutoSellMaterials:OnChanged(function(v) Thread("E_AutoSellMaterials", Func_AutoSellMaterials, v) end)
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
SaveManager:SetFolder("Yuri/EUT")
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