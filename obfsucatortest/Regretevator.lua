if getgenv().ayasemiyatongekissazumirisa then
    warn("watch more yuri")
    return
end
getgenv().ayasemiyatongekissazumirisa = true
repeat task.wait() until game:IsLoaded()
local cloneref = (cloneref or clonereference or function(i) return i end)
local function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
Services = setmetatable({}, {
    __index = function(self, name)
        local ok, svc = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if ok then
            rawset(self, name, svc)
            return svc
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})
local Players          = Services.Players
local Workspace        = Services.Workspace
local RS               = Services.ReplicatedStorage
local RunService       = Services.RunService
local GuiService       = Services.GuiService
local TeleportService  = Services.TeleportService
local VirtualUser      = Services.VirtualUser
local Lighting         = Services.Lighting
local vim              = Services.VirtualInputManager
local Plr              = Players.LocalPlayer
local Support = {
    FPS         = (typeof(setfpscap) == "function"),
    Connections = (typeof(getconnections) == "function" or typeof(get_signal_cons) == "function"),
}
task.spawn(function()
    local ok, err = pcall(function()
        local function UIR(guiObject)
            if not guiObject or not guiObject:IsA("GuiObject") then return false end
            if not guiObject.Visible or not guiObject.Active then return false end
            local parent = guiObject.Parent
            while parent and parent:IsA("GuiObject") do
                if not parent.Visible then return false end
                parent = parent.Parent
            end
            return true
        end
        
        while true do
            local playerGui = Plr:FindFirstChild("PlayerGui")
            local startGui = playerGui and playerGui:FindFirstChild("Start")
            local startFrame = startGui and startGui:FindFirstChild("start")
            local showcase = startFrame and startFrame:FindFirstChild("showcase")
            local play = showcase and showcase:FindFirstChild("play")
            local quick = play and play:FindFirstChild("quick")
            
            if quick then
                
            end
            if UIR(quick) then
                
                local ok2 = pcall(function() GuiService.SelectedObject = quick end)
                
                if ok2 and GuiService.SelectedObject == quick then
                    task.wait(0.3)
                    local retries = 0
                    while quick.Visible and retries < 10 do
                        
                        vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game) task.wait(0.1)
                        vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game) task.wait(0.3)
                        retries = retries + 1
                    end
                    if not quick.Visible then
                        
                        break
                    end
                end
            end
            task.wait(0.1)
        end
    end)
    if not ok then end
end)
local Char        = Plr.Character or Plr.CharacterAdded:Wait()
local Shared = {
    Reset         = true,
    Tickets       = true,
    Floppies      = true,
    CoinFarm      = true,
    Emotes        = false,
    StopFarm = false,
    bodyPos       = nil,
    GASA4CanSteal     = false,
    GASA4ListenerSet  = false,
    StatsDomainCDs    = {},
    StatsDomainLastRun = 0,
}
local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles
local Window = Library:CreateWindow({
    Title      = "Lesbian",
    Center     = true,
    AutoShow   = true,
    Resizable  = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})
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
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
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
AddInfo(Window)
local Tabs = {
    Main   = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local GB = {
    Main = {
        Left  = Tabs.Main:AddLeftGroupbox("Automation"),
    },
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
GB.Main.Left:AddToggle("StopFarm", {
    Text    = "Stop Farm",
    Default = Shared.StopFarm,
    Callback = function(v) Shared.StopFarm = v end,
})
GB.Main.Left:AddToggle("Reset", {
    Text    = "Faster Farm (Reset)",
    Default = Shared.Reset,
    Callback = function(v) Shared.Reset = v end,
})
GB.Main.Left:AddToggle("CoinFarm", {
    Text    = "Coin Farm",
    Default = Shared.CoinFarm,
    Callback = function(v) Shared.CoinFarm = v end,
})
GB.Main.Left:AddToggle("Tickets", {
    Text    = "Auto Ticket Printer",
    Default = Shared.Tickets,
    Callback = function(v) Shared.Tickets = v end,
})
GB.Main.Left:AddToggle("Floppies", {
    Text    = "Floppy Collector",
    Default = Shared.Floppies,
    Callback = function(v) Shared.Floppies = v end,
})
GB.Main.Left:AddToggle("Emotes", {
    Text    = "Buy all Emotes",
    Default = Shared.Emotes,
    Callback = function(v) Shared.Emotes = v end,
})
local function AddSliderToggle(Config)
    local Toggle = Config.Group:AddToggle(Config.Id, {
        Text = Config.Text,
        Default = Config.DefaultToggle or false,
        Disabled = Config.Disabled,
    })
    local Slider = Config.Group:AddSlider(Config.Id .. "Value", {
        Text = Config.Text,
        Default = Config.Default,
        Min = Config.Min,
        Max = Config.Max,
        Rounding = Config.Rounding or 0,
        Compact = true,
        Visible = false,
    })
    Toggle:OnChanged(function()
        Slider:SetVisible(Toggle.Value)
    end)
    return Toggle, Slider
end
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
GB.Player.Left.General:AddToggle("Noclip", { Text = "Noclip" })
GB.Player.Left.General:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
GB.Player.Left.General:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = GB.Player.Left.General, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
GB.Player.Left.General:AddToggle("FPSBoost", { Text = "FPS Boost" })
GB.Player.Left.Server:AddToggle("AntiAFK", { Text = "Anti AFK", Default = true, Disabled = not Support.Connections })
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)" })
GB.Player.Left.Server:AddToggle("AutoReconnect", { Text = "Auto Reconnect" })
GB.Player.Left.Server:AddToggle("NoGameplayPaused", { Text = "No Gameplay Paused" })
GB.Player.Left.Server:AddButton({ Text = "Serverhop", Func = function()
    local ok, result = pcall(function()
        local data = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local parsed = game:GetService("HttpService"):JSONDecode(data)
        if parsed and parsed.data then
            for _, server in ipairs(parsed.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                    return
                end
            end
        end
    end)
    if not ok then Library:Notify("Serverhop failed.", 4) end
end })
GB.Player.Left.Server:AddButton({ Text = "Rejoin", Func = function() TeleportService:Teleport(game.PlaceId, Plr) end })
GB.Player.Left.Server:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
GB.Player.Left.Server:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu")
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/Regretevator")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
local noCollisionConnection = nil
local function getChar()
    return Plr.Character or Plr.CharacterAdded:Wait()
end
local function setBodyLock(y)
    local root = getChar():FindFirstChild("HumanoidRootPart")
    if not root then return end
    if Shared.bodyPos and Shared.bodyPos.Parent then
        Shared.bodyPos.Position = Vector3.new(root.Position.X, y, root.Position.Z)
        return
    end
    Shared.bodyPos          = Instance.new("BodyPosition")
    Shared.bodyPos.MaxForce = Vector3.new(0, math.huge, 0)
    Shared.bodyPos.P        = 1e5
    Shared.bodyPos.D        = 1e3
    Shared.bodyPos.Position = Vector3.new(root.Position.X, y, root.Position.Z)
    Shared.bodyPos.Parent   = root
end
local function clearBodyLock()
    if Shared.bodyPos then Shared.bodyPos:Destroy() Shared.bodyPos = nil end
end
task.spawn(function()
    while true do
        task.wait(0.05)
        local farming = Shared.Reset or Shared.Tickets or Shared.Floppies or Shared.CoinFarm
        if farming then
            local root = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            if root then setBodyLock(root.Position.Y) end
        else
            clearBodyLock()
        end
    end
end)
local function touchPart(part, root)
    if not part or not part:IsA("BasePart") then return end
    if not root or not root:IsA("BasePart") then return end
    if firetouchinterest then
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end
end
local function getLocalHRP(timeoutSeconds)
    local char = Plr.Character or Plr.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp or not timeoutSeconds then return hrp end
    local ok, obj = pcall(char.WaitForChild, char, "HumanoidRootPart", timeoutSeconds)
    return ok and obj or nil
end
local function getCharacter()
    local c = Plr.Character
    return (c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
end
local Timers = {}
local function smartTimer(name, delay)
    local now = tick()
    if now - (Timers[name] or 0) >= delay then
        Timers[name] = now
        return true
    end
    return false
end
local function inLob()
    local character = Plr.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root and (root.Position - Vector3.new(1054, 1394, -25)).Magnitude <= 50 then
            return true
        end
    end
    local lobby = workspace:FindFirstChild("Lobby")
    if not lobby then return false end
    local centerLobby = lobby:FindFirstChild("CenterLobby")
    if not centerLobby then return false end
    local props = centerLobby:FindFirstChild("Props")
    if not props then return false end
    return props:FindFirstChild("MagicPainting") ~= nil
end
local function r()
    if not Shared.Reset then return end
    if inLob() then return end
    local character = Plr.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid:ChangeState(Enum.HumanoidStateType.Dead)
end
local function findInstances(targetName, className)
    local results = {}
    local searchRoot = workspace
    if targetName then
        local obj = workspace:FindFirstChild(targetName)
        if obj and obj:IsA("Folder") then searchRoot = obj end
    end
    for _, descendant in ipairs(searchRoot:GetDescendants()) do
        if descendant:IsA(className) and (not targetName or descendant.Name == targetName or descendant.Parent.Name == targetName) then
            table.insert(results, descendant)
        end
    end
    return results
end
local function getRefPartFromPrompt(prompt)
    local parent = prompt and prompt.Parent
    if not parent then return nil end
    if parent:IsA("BasePart") then return parent
    elseif parent:IsA("Model") then return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function teleportToTarget(targetName, offsetY)
    local parts = findInstances(targetName, "BasePart")
    if #parts == 0 then
        local models = findInstances(targetName, "Model")
        for _, model in ipairs(models) do
            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if part then parts = {part} break end
        end
    end
    if #parts == 0 then return false end
    local hrp = getLocalHRP()
    if not hrp then return false end
    hrp.CFrame = parts[1].CFrame * CFrame.new(0, offsetY or 3, 0)
    return true
end
local function fireProximityPrompts(targetName, offsetY, opts)
    opts = opts or {}
    offsetY = type(offsetY) == "number" and offsetY or 3
    local prompts = findInstances(targetName, "ProximityPrompt")
    if #prompts == 0 then return false end
    local root = getLocalHRP(opts.hrpTimeout or 3)
    if not root then
        if fireproximityprompt then fireproximityprompt(prompts[1]) end
        return true
    end
    local closestPrompt, closestPart, closestDist = nil, nil, math.huge
    for _, prompt in ipairs(prompts) do
        local refPart = getRefPartFromPrompt(prompt)
        if refPart then
            local dist = (refPart.Position - root.Position).Magnitude
            if dist < closestDist then closestDist = dist closestPrompt = prompt closestPart = refPart end
        end
    end
    if not closestPrompt then closestPrompt = prompts[1] closestPart = getRefPartFromPrompt(closestPrompt) end
    if closestPrompt and closestPart then
        local tgt = closestPrompt.Parent
        if tgt then teleportToTarget(tgt.Name, offsetY) task.wait(opts.postTeleportWait or 0.3)
        else root.CFrame = closestPart.CFrame + Vector3.new(0, offsetY, 0) task.wait(opts.postTeleportWait or 0.08) end
        if fireproximityprompt then
            fireproximityprompt(closestPrompt)
            task.wait(opts.afterFireWait or 0.05)
        end
        return true
    end
    return false
end
local function fireClickDetectors(targetName)
    local detectors = findInstances(targetName, "ClickDetector")
    if #detectors == 0 then return false end
    for _, detector in ipairs(detectors) do
        if fireclickdetector then fireclickdetector(detector) task.wait(0.05) end
    end
    return true
end
local function fireTouchInterests(targetName, opts)
    opts = opts or {}
    local root = getLocalHRP(opts.hrpTimeout or 3)
    if not root then return false end
    local maxWait = opts.maxWait or 5
    local elapsed = 0
    while elapsed <= maxWait do
        local transmitters = findInstances(targetName, "TouchTransmitter")
        if #transmitters > 0 then
            for _, tx in ipairs(transmitters) do
                local part = tx:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    pcall(function()
                        if firetouchinterest then
                            firetouchinterest(part, root, 1) task.wait() firetouchinterest(part, root, 0)
                        else
                            local origCF = part.CFrame
                            part.CFrame = root.CFrame task.wait(0.05) part.CFrame = origCF
                        end
                    end)
                    task.wait(0.05)
                end
            end
            return true
        end
        task.wait(opts.interval or 0.15)
        elapsed = elapsed + (opts.interval or 0.15)
    end
    return false
end
local CoinFails   = {}
local Blacklisted = {}
local function isValidCoin(obj)
    return obj and obj.Parent and obj:IsA("MeshPart") and obj:FindFirstChild("ProjectileHitTrigger")
end
local function getCoins()
    local coins, added = {}, {}
    for _, d in pairs(workspace:GetDescendants()) do
        if d.Name == "Coins" then
            for _, coin in pairs(d:GetChildren()) do
                if isValidCoin(coin) and not added[coin] and not Blacklisted[coin] then
                    table.insert(coins, coin) added[coin] = true
                end
            end
        end
        if d:IsA("MeshPart") and d.Name:lower() == "coin" and d:FindFirstChild("ProjectileHitTrigger")
            and not added[d] and not Blacklisted[d] then
            table.insert(coins, d) added[d] = true
        end
    end
    return coins
end
local function coinsRemaining() return #getCoins() > 0 end
local function equipMagnet()
    local backpack = Plr:FindFirstChildOfClass("Backpack")
    if not backpack then return false end
    local magnet = backpack:FindFirstChild("Magnet") or backpack:FindFirstChild("Mini-Magnet")
    if magnet and magnet:IsA("Tool") then
        magnet.Parent = Plr.Character
        task.wait(0.1)
        return true
    end
    return false
end
local function collectCoins()
    local character = Plr.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = character:FindFirstChildWhichIsA("Humanoid")
    if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end
    equipMagnet()
    repeat
        for _, coin in pairs(getCoins()) do
            if isValidCoin(coin) and not Blacklisted[coin] then
                local existedBefore = coin.Parent ~= nil
                hrp.CFrame = coin.CFrame
                task.wait(0.25)
                if existedBefore and coin.Parent ~= nil then
                    CoinFails[coin] = (CoinFails[coin] or 0) + 1
                    if CoinFails[coin] >= 10 then Blacklisted[coin] = true end
                else
                    CoinFails[coin] = nil
                end
            end
        end
    until not coinsRemaining()
    local roof = workspace:FindFirstChild("Elevator") and workspace.Elevator:FindFirstChild("Roof")
    if roof then hrp.CFrame = roof.CFrame
   end
end
local elevator = workspace:WaitForChild("Elevator")
local FloorActions = {
    ["MozelleSquidGames"] = function() fireTouchInterests("Winner") end,
    ["StanelyRoom"] = function() fireTouchInterests("EndTouch") end,
    ["TheBackrooms"] = function()
        local build = workspace:WaitForChild("TheBackrooms")
        local hrp = Plr.Character:WaitForChild("HumanoidRootPart")
        for _, v in ipairs(build:GetDescendants()) do
            if v.Name == "AvaliableIcon" and v.Active then
                local collide = v:FindFirstAncestor("Collide")
                if collide and collide:IsA("BasePart") then hrp.CFrame = collide.CFrame break end
            end
        end
    end,
    ["Splitsville_Wipeout"] = function() fireTouchInterests("EndCheckpoint") end,
    ["Obby"] = function() fireTouchInterests("EndPart") end,
    ["IntenseObby"] = function() fireTouchInterests("ENDBLOCK") end,
    ["FindThePath"] = function() fireTouchInterests("win_zone") end,
    ["Minefield"] = function() fireTouchInterests("WinPart") end,
    ["WhoKilledYouObby"] = function() fireTouchInterests("WinPart") end,
    ["GumballMachine"] = function() fireTouchInterests("WinPart") end,
    ["3008_Room"] = function() fireClickDetectors("Lampert") end,
    ["Superhighway"] = function() fireTouchInterests("WinPoint") end,
    ["SuperDropper"] = function()
        fireTouchInterests("WinPool") task.wait(0.5) fireTouchInterests("ReturnPortal")
    end,
    ["RandomMazeWindows"] = function() fireTouchInterests("Build") end,
    ["Jeremy"] = function()
        local char = Plr.Character or Plr.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local button = workspace:WaitForChild("Jeremy"):WaitForChild("Build"):WaitForChild("Button")
        local clicker = button:WaitForChild("Clicker")
        root.CFrame = clicker.CFrame * CFrame.new(0, 0.5, 0)
    end,
    ["BrokenSchool"] = function() r() teleportToTarget("Roof", 3) end,
    ["SnowySlope"] = function() fireTouchInterests("WinPart") end,
    ["Forest_TwoStudCamp"] = function()
        local root = getLocalHRP()
        if not root then return end
        local build = workspace:WaitForChild("Forest_TwoStudCamp"):WaitForChild("Build")
        local firePrompt = build:WaitForChild("Firewood"):FindFirstChildWhichIsA("ProximityPrompt", true)
        if firePrompt and firePrompt.Enabled and firePrompt.Parent and firePrompt.Parent:IsA("BasePart") then
            root.CFrame = firePrompt.Parent.CFrame * CFrame.new(0, 0, -3)
            task.wait(0.175)
            if fireproximityprompt then fireproximityprompt(firePrompt) end
            task.wait(0.25)
        end
        local cauldronPart = build:WaitForChild("Cauldron"):WaitForChild("PromptPart")
        local cauldronPrompt = cauldronPart:FindFirstChildWhichIsA("ProximityPrompt", true)
        if cauldronPrompt and cauldronPrompt.Enabled then
            root.CFrame = cauldronPart.CFrame * CFrame.new(0, 0, -3)
            task.wait(0.175)
            if fireproximityprompt then fireproximityprompt(cauldronPrompt) end
            task.wait(0.25)
        end
    end,
    ["FunnyMaze"] = function()
        local finalNotes = workspace.FunnyMaze.Build.FinalNotes
        for _, child in pairs(finalNotes:GetChildren()) do
            local detector = child:FindFirstChildOfClass("ClickDetector")
            if detector and fireclickdetector then fireclickdetector(detector) task.wait(0.05) end
        end
    end,
    ["UES"] = function() fireProximityPrompts("cardboard_box", 3) task.wait(4) end,
    ["ButtonCompetition"] = function()
        local buttonsFolder = workspace:WaitForChild("ButtonCompetition"):WaitForChild("Build"):WaitForChild("Buttons")
        for _, child in pairs(buttonsFolder:GetDescendants()) do
            local detector = child:FindFirstChildOfClass("ClickDetector")
            if detector and fireclickdetector then fireclickdetector(detector) end
        end
    end,
    ["ElevatorShaft"] = function()
        local root = getLocalHRP()
        if not root then return end
        local leversFolder = workspace:WaitForChild("ElevatorShaft"):WaitForChild("Build"):WaitForChild("Levers")
        for _, obj in pairs(leversFolder:GetDescendants()) do
            if obj.Name == "ClickPart" and obj:IsA("BasePart") then
                local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    root.CFrame = obj.CFrame
                    if fireproximityprompt then fireproximityprompt(prompt) end
                    task.wait(1)
                    return
                end
            end
        end
    end,
    ["SurvivalTheArea51"] = function()
        local root = getLocalHRP()
        local build = workspace:WaitForChild("SurvivalTheArea51"):WaitForChild("Build")
        local gens = {
            build:WaitForChild("JeremyRoom"):WaitForChild("Generator"),
            build:WaitForChild("KillerRoom"):WaitForChild("Generator"),
            build:WaitForChild("DougRoom"):WaitForChild("Generator"),
            build:WaitForChild("AngryWallRoom"):WaitForChild("Generator"),
            build:WaitForChild("Generator"),
            build:WaitForChild("EndRoom"):WaitForChild("Generator"),
        }
        for _, part in ipairs(gens) do
            local prompt = part and part:FindFirstChildOfClass("ProximityPrompt")
            if prompt and prompt.Enabled then
                root.CFrame = part.CFrame * CFrame.new(0, 0, -3)
                task.wait(0.2)
                if fireproximityprompt then fireproximityprompt(prompt) end
                task.wait(1)
                return
            end
        end
    end,
    ["WALL_OF"] = function() fireTouchInterests("EndCheckpoint") end,
    ["Normal_Dance"] = function() r() end,
    ["SLIDE_9999999999_FEET_DOWN_RAINBOW"] = function() fireTouchInterests("MiddleRing") end,
    ["CliffsideChaos"] = function() teleportToTarget("Roof", 3) end,
    ["bugbo"] = function()
        task.wait(10)
        local rocks = workspace:WaitForChild("bugbo"):WaitForChild("Build"):WaitForChild("Rocks")
        for _, child in pairs(rocks:GetDescendants()) do
            local detector = child:FindFirstChildOfClass("ClickDetector")
            if detector and fireclickdetector then fireclickdetector(detector) task.wait(0.05) end
        end
    end,
    ["InfectedRacing"] = function() r() end,
    ["SuspiciouslyLongRoom"] = function() fireTouchInterests("WinPool") end,
    ["TeapotDodgeball"] = function() fireTouchInterests("Finish") task.wait(0.5) end,
    ["SlimYim"] = function() r() end,
    ["JermpopFactory"] = function()
        local hrp = getLocalHRP(3)
        if not hrp then return end
        local cleanupButtons = workspace:WaitForChild("JermpopFactory"):WaitForChild("Build"):WaitForChild("CleanupButtons")
        for _, obj in ipairs(cleanupButtons:GetDescendants()) do
            local prim = obj:FindFirstChild("Prim")
            if prim and prim:IsA("BasePart") then
                local prompt = prim:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt and prompt.Enabled then
                    hrp.CFrame = prim.CFrame
                    task.wait(0.175)
                    if fireproximityprompt then fireproximityprompt(prompt) end
                    return
                end
            end
        end
    end,
    ["RedBallTemple"] = function() r() end,
    ["RedballDiner"] = function()
        local prompt = workspace:WaitForChild("RedballDiner"):WaitForChild("Build")
            :WaitForChild("Animatronics"):WaitForChild("Reddy")
            :WaitForChild("HumanoidRootPart"):WaitForChild("ResetPrompt")
        local targetHRP = prompt.Parent
        local playerHRP = Plr.Character:WaitForChild("HumanoidRootPart")
        local function firePrompt()
            if prompt and prompt.Enabled then fireproximityprompt(prompt) return true end
            return false
        end
        playerHRP.CFrame = targetHRP.CFrame
        if firePrompt() then
            teleportToTarget("Roof", 3) task.wait(0.1)
            playerHRP.CFrame = targetHRP.CFrame
            firePrompt()
        end
    end,
    ["OldRobloxHouse"] = function() r() end,
    ["PetCaptureDeluxe"] = function()
        local activeMonsters = workspace:WaitForChild("PetCaptureDeluxe"):WaitForChild("Build"):WaitForChild("ActiveMonsters")
        if activeMonsters then
            local descendant = activeMonsters:FindFirstChildWhichIsA("ProximityPrompt", true)
            if descendant and fireproximityprompt then
                local part = descendant.Parent
                if part then
                    local hrp = getLocalHRP(3)
                    if hrp then hrp.CFrame = part.CFrame task.wait(0.175) end
                end
                fireproximityprompt(descendant)
            end
        end
    end,
    ["UnsteadyFloor"] = function() fireTouchInterests("END") end,
    ["THEROCK"] = function() end,
    ["ElevatorInsideAx5"] = function() r() end,
    ["FunTimesAtSquishyFlood"] = function()
        task.wait(20)
        local root = getLocalHRP(3)
        local tar = workspace:WaitForChild("FunTimesAtSquishyFlood"):WaitForChild("Build"):WaitForChild("Winparts")
        for _, obj in pairs(tar:GetDescendants()) do
            if obj:IsA("TouchTransmitter") then touchPart(obj.Parent, root) task.wait(0.05) end
        end
    end,
    ["PizzaDelivery"] = function()
        local root = getLocalHRP(3)
        if not root then return end
        local build = workspace:WaitForChild("PizzaDelivery"):WaitForChild("Build")
        for _, pizza in pairs(build:WaitForChild("PizzaBoxes"):GetChildren()) do
            if pizza:IsA("BasePart") and pizza:FindFirstChild("TouchInterest") then touchPart(pizza, root) end
        end
        for _, door in pairs(build:WaitForChild("PizzaDoors"):GetDescendants()) do
            if door:IsA("BasePart") and door:FindFirstChild("TouchInterest") then touchPart(door, root) end
        end
    end,
    ["Birthday"] = function()
        local destructibles = workspace:WaitForChild("Birthday"):WaitForChild("Build"):WaitForChild("destructible")
        for _, obj in pairs(destructibles:GetDescendants()) do
            if obj:IsA("ClickDetector") and fireclickdetector then fireclickdetector(obj) end
        end
    end,
    ["CardboardRoom"] = function()
        local doors = workspace:WaitForChild("CardboardRoom"):WaitForChild("Build"):WaitForChild("Doors")
        for _, d in pairs(doors:GetDescendants()) do
            if d:IsA("ClickDetector") and fireclickdetector then fireclickdetector(d) end
        end
    end,
    ["InfectionApartment"] = function()
        local hrp = getLocalHRP(1)
        if not hrp then return end
        local valves = workspace:WaitForChild("InfectionApartment"):WaitForChild("Immune"):WaitForChild("Valves")
        for _, child in ipairs(valves:GetChildren()) do
            local valve = child and child:FindFirstChild("Valve")
            if valve then
                local availableIcon = valve:FindFirstChild("AvaliableIcon")
                if availableIcon and availableIcon.Enabled then
                    local valvePrompt = valve:FindFirstChild("ValvePrompt")
                    local prompt = valvePrompt and valvePrompt:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and fireproximityprompt then
                        hrp.CFrame = valve.CFrame * CFrame.new(0, 0, -3)
                        task.wait(0.25)
                        fireproximityprompt(prompt)
                        task.wait(0.2)
                        return
                    end
                end
            end
        end
    end,
    ["MozellesCastle"] = function() end,
    ["HotelFloor6"] = function() r() end,
    ["ColorTheTiles"] = function() r() end,
    ["FourCorners"] = function() r() end,
    ["FloodFillMine"] = function()
        local hrp = getLocalHRP(1)
        if not hrp then return end
        local build = workspace:WaitForChild("FloodFillMine"):WaitForChild("Build")
        local blocksFolder = build:WaitForChild("Blocks")
        local currentRoom = workspace:WaitForChild("Values"):WaitForChild("CurrentRoom").Value
        local breakRemote = currentRoom:WaitForChild("BreakBlock")
        local brokeAny = false
        for _, block in ipairs(blocksFolder:GetChildren()) do
            if block and block:IsA("BasePart") and block.Name == "CoinBlock" then
                brokeAny = true
                hrp.CFrame = block.CFrame task.wait(0.08)
                breakRemote:FireServer(block.Position) task.wait(0.12)
            end
        end
        if not brokeAny then fireTouchInterests("Bubble") end
    end,
    ["KnowledgeOffice"] = function()
        local knowledgeOffice = workspace:WaitForChild("KnowledgeOffice"):WaitForChild("Build"):WaitForChild("Folder")
        local targetBoard, targetPrompt = nil, nil
        for _, obj in pairs(knowledgeOffice:GetDescendants()) do
            if obj.Name == "ProblemBoard" then
                local pp = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                if pp then targetBoard = obj targetPrompt = pp break end
            end
        end
        if not targetBoard or not targetPrompt then return end
        if fireproximityprompt then fireproximityprompt(targetPrompt) end
        local playerGui = Plr:WaitForChild("PlayerGui")
        local questionLabel = playerGui:WaitForChild("FloorGUI"):WaitForChild("QuestionFrame")
            :WaitForChild("QuestionFrame"):WaitForChild("Question"):WaitForChild("TextLabel")
        local questionText = questionLabel.Text
        if not questionText or questionText == "" then return end
        local function solveArithmetic(expr)
            expr = tostring(expr):gsub("%s+",""):gsub("=",""):gsub("[×xX]","*"):gsub("÷","/")
            if expr:find("[^%d%+%-%*/%(%).]") then return nil end
            local ok, result = pcall(function() return loadstring("return "..expr)() end)
            if not ok or result == nil then return nil end
            return tostring(math.abs(result - math.floor(result)) < 1e-9 and math.floor(result) or result)
        end
        local answer = solveArithmetic(questionText)
        if not answer then return end
        local answersFrame = questionLabel.Parent.Parent:FindFirstChild("Answers")
        if not answersFrame then return end
        for _, button in ipairs(answersFrame:GetChildren()) do
            if button:IsA("TextButton") then
                local answerLabel = button:FindFirstChild("AnswerText")
                if answerLabel and answerLabel.Text == answer then
                    GuiService.SelectedObject = button
                    task.wait(0.1)
                    vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait(0.3)
                    vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    break
                end
            end
        end
    end,
    ["TNTRun"] = function() r() end,
    ["MarkApartmentHideAndSeek"] = function()
        local char = Plr.Character or Plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local floor = workspace:WaitForChild("MarkApartmentHideAndSeek")
        for _, v in ipairs(floor:GetDescendants()) do
            if v:IsA("Humanoid") and v.Parent ~= char then
                local targetHRP = v.Parent:FindFirstChild("HumanoidRootPart")
                if targetHRP then hrp.CFrame = targetHRP.CFrame break end
            end
        end
    end,
    ["GASA4"] = function()
        local function setupGASA4Listener()
            if Shared.GASA4ListenerSet then return end
            Shared.GASA4ListenerSet = true
            local stateEvent = workspace:WaitForChild("GASA4"):WaitForChild("RoomScript"):WaitForChild("StateChange")
            stateEvent.OnClientEvent:Connect(function(state)
                Shared.GASA4CanSteal = (state == true)
            end)
        end
        setupGASA4Listener()
        if not Shared.GASA4CanSteal then return end
        local root = getLocalHRP(3)
        if not root then return end
        local build = workspace:WaitForChild("GASA4"):WaitForChild("Build")
        local collectables = build:WaitForChild("Collectables")
        local stealables = build:WaitForChild("Stealables")
        local extractionBox = build:WaitForChild("ExtractionBox")
        local function handleCandidate(obj)
            if not obj then return false end
            local prompt, basepart
            if obj:IsA("ProximityPrompt") then prompt = obj basepart = obj.Parent
            elseif obj:IsA("BasePart") then basepart = obj prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            else prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true) if prompt then basepart = prompt.Parent end end
            if not prompt or not basepart or not basepart:IsA("BasePart") then return false end
            if not prompt.Enabled or not fireproximityprompt then return false end
            root.CFrame = basepart.CFrame task.wait(0.175) fireproximityprompt(prompt)
            return true
        end
        for _, item in ipairs(collectables:GetChildren()) do
            if handleCandidate(item) then touchPart(extractionBox, root) return end
        end
        for _, item in ipairs(stealables:GetChildren()) do
            local thingBtn = item:FindFirstChild("ThingButton")
            if thingBtn and handleCandidate(thingBtn) then touchPart(extractionBox, root) return end
            if handleCandidate(item) then touchPart(extractionBox, root) return end
        end
    end,
    ["StatsDomain"] = function()
        local PER_PROMPT_COOLDOWN = 0.5
        if not smartTimer("StatsDomain_Main", 0.2) then return end
        local root = getLocalHRP(3)
        if not root then return end
        local build = workspace:WaitForChild("StatsDomain"):WaitForChild("Build")
        local ok, doorButton = pcall(function() return build:WaitForChild("DoorButton"):WaitForChild("Button") end)
        if ok and doorButton then
            local doorPrompt = doorButton:FindFirstChildWhichIsA("ProximityPrompt", true)
            if doorPrompt and doorPrompt.Enabled and fireproximityprompt then
                local key = tostring(doorPrompt)
                if not Shared.StatsDomainCDs[key] or os.clock() - Shared.StatsDomainCDs[key] >= PER_PROMPT_COOLDOWN then
                    Shared.StatsDomainCDs[key] = os.clock()
                    root.CFrame = doorButton.CFrame task.wait(0.175) fireproximityprompt(doorPrompt)
                end
            end
        end
        local function findEnabledBigOrbs()
            local results = {}
            local activeUnits = build:FindFirstChild("ActiveUnits")
            if not activeUnits then return results end
            for _, v in ipairs(activeUnits:GetDescendants()) do
                if v.Name and v.Name:lower():find("bigorb") then
                    local pp = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if pp and pp.Enabled then table.insert(results, {prompt = pp, part = pp.Parent}) end
                end
            end
            return results
        end
        local function isAntennaAvailable()
            local activeUnits = build:FindFirstChild("ActiveUnits")
            if not activeUnits then return false end
            for _, ch in ipairs(activeUnits:GetChildren()) do
                local avail = ch:FindFirstChild("Antenna") and ch.Antenna:FindFirstChild("AvailableIcon")
                if avail and avail.Enabled then return true end
            end
            return false
        end
        local bigOrbs = findEnabledBigOrbs()
        if #bigOrbs > 0 and isAntennaAvailable() then
            for _, entry in ipairs(bigOrbs) do
                local key = tostring(entry.prompt)
                local last = Shared.StatsDomainCDs[key] or 0
                if os.clock() - last >= PER_PROMPT_COOLDOWN then
                    root.CFrame = entry.part.CFrame task.wait(0.175)
                    fireproximityprompt(entry.prompt)
                    Shared.StatsDomainCDs[key] = os.clock()
                    return
                end
            end
        end
        local machinePart = build:FindFirstChild("TheMachine") and build.TheMachine:FindFirstChild("MachinePrompt")
        if machinePart then
            local machinePrompt = machinePart:FindFirstChildWhichIsA("ProximityPrompt", true)
            if machinePrompt and machinePrompt.Enabled and fireproximityprompt then
                local key = tostring(machinePrompt)
                local last = Shared.StatsDomainCDs[key] or 0
                if os.clock() - last >= PER_PROMPT_COOLDOWN then
                    root.CFrame = machinePart.CFrame task.wait(0.175)
                    fireproximityprompt(machinePrompt)
                    Shared.StatsDomainCDs[key] = os.clock()
                end
            end
        end
    end,
    ["SuperTunnel"] = function()
        local clickPart = workspace:WaitForChild("SuperTunnel"):WaitForChild("Build"):WaitForChild("EndArea"):WaitForChild("ClickPart")
        local prompt = clickPart:WaitForChild("ProximityPrompt")
        local hrp = Plr.Character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = clickPart.CFrame
        task.wait(0.2)
        fireproximityprompt(prompt)
    end,
}
local function isDead()
    local ok, result = pcall(function()
        return Plr:WaitForChild("PlayerGui"):WaitForChild("DeathScreen").Enabled
    end)
    return ok and result == true
end
local function start()
    RS.RE.PutInElevator:FireServer()
end
local function respawn()
    RS.RE.Respawn:FireServer()
end
local re = RS
local p = re.RE.Cosmetics.PurchaseCosmetic
if Shared.Emotes then
    for i in pairs(require(re.Modules.Databases.Emotes):GetEntries()) do
        pcall(function() p:InvokeServer("Emotes", i) end)
        task.wait()
    end
end
Toggles.Emotes:OnChanged(function(v) Shared.Emotes = v end)
task.spawn(function()
    while task.wait(3) do
        if inLob() then start() end
    end
end)
task.spawn(function()
    while task.wait(3) do
        if isDead() then respawn() end
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if Shared.CoinFarm and coinsRemaining() then collectCoins() end
    end
end)
local function getFloor()
    local currentRoom = workspace.Values.CurrentRoom.Value
    if currentRoom and currentRoom ~= elevator then
        if Shared.StopFarm then return end
        local floorName = currentRoom.Name
        local character = Plr.Character
        task.wait(3)
        if Shared.CoinFarm then collectCoins() end
        while Shared.CoinFarm and coinsRemaining() do task.wait(1) end
        if Shared.Tickets then
            while true do
                local floor = workspace:FindFirstChild(floorName)
                if not floor then break end
                local printer, prompt = nil, nil
                for _, obj in ipairs(floor:GetDescendants()) do
                    if obj.Name:lower():match("ticketprinter") and obj:IsA("Model") then
                        for _, p in ipairs(obj:GetDescendants()) do
                            if p:IsA("ProximityPrompt") and p.Enabled then
                                printer = obj prompt = p break
                            end
                        end
                        if prompt then break end
                    end
                end
                if not prompt then break end
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root then root.CFrame = printer:GetPivot() end
                task.wait(0.3)
                fireproximityprompt(prompt)
                task.wait(0.5)
            end
        end
        if Shared.Floppies then
            while true do
                local floppiesFolder = workspace[floorName] and workspace[floorName]:FindFirstChild("Floppies")
                if not floppiesFolder then break end
                local normalFloppy = floppiesFolder:FindFirstChild("Normal")
                if not normalFloppy then break end
                local prompt = nil
                for _, p in ipairs(normalFloppy:GetChildren()) do
                    if p:IsA("ProximityPrompt") then prompt = p break end
                end
                if not prompt or not prompt.Enabled then break end
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root then root.CFrame = normalFloppy:GetPivot() end
                task.wait(0.175)
                fireproximityprompt(prompt)
                task.wait(0.3)
            end
        end
        local action = FloorActions[floorName]
        if action then
            while workspace.Values.CurrentRoom.Value == currentRoom do
                action()
                task.wait(0.3)
            end
        end
    end
end
getFloor()
workspace.Values.CurrentRoom:GetPropertyChangedSignal("Value"):Connect(function()
    task.wait(0.1)
    getFloor()
end)
local Connections = { Knockback = {} }
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
                char:TranslateBy(hum.MoveDirection * Options.TPWValue.Value * delta * 10)
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
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end
end
local function Func_AntiKnockback()
    if type(Connections.Knockback) == "table" then
        for _, conn in pairs(Connections.Knockback) do if conn then conn:Disconnect() end end
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
                if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then child:Destroy() end
            end)
            table.insert(Connections.Knockback, conn)
        end
    end
    if Plr.Character then ApplyAntiKB(Plr.Character) end
    local charAddedConn = Plr.CharacterAdded:Connect(function(newChar) ApplyAntiKB(newChar) end)
    table.insert(Connections.Knockback, charAddedConn)
    repeat task.wait(1) until not Toggles.AntiKnockback.Value
    for _, conn in pairs(Connections.Knockback) do if conn then conn:Disconnect() end end
    table.clear(Connections.Knockback)
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
                    if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.CastShadow = false
                    elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy()
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled = false end
                end)
                if i % 500 == 0 then task.wait() end
            end
        end)
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
                        task.wait(5)
                        TeleportService:Teleport(game.PlaceId, Plr)
                    end
                end
            end)
        end)
    end)
end
local function Func_NoGameplayPaused()
    while Toggles.NoGameplayPaused.Value do
        pcall(function()
            local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
            if pauseGui then pauseGui:Destroy() end
        end)
        task.wait(1)
    end
end
Toggles.TPW:OnChanged(function(v)
    TPW_S:SetVisible(TPW_T.Value)
    Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v) Thread("Noclip", FuncNoclip, v) end)
Toggles.AntiKnockback:OnChanged(function(state) Thread("AntiKnockback", Func_AntiKnockback, state) end)
Toggles.Disable3DRender:OnChanged(function(v) RunService:Set3dRenderingEnabled(not v) end)
Toggles.FPSBoost:OnChanged(function(state) ApplyFPSBoost(state) end)
Toggles.AutoReconnect:OnChanged(function(state) if state then Func_AutoReconnect() end end)
Toggles.NoGameplayPaused:OnChanged(function(state) Thread("NoGameplayPaused", SafeLoop("Anti-Pause", Func_NoGameplayPaused), state) end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP and Toggles.InstantPP.Value then prompt.HoldDuration = 0 end
end)
RunService.Stepped:Connect(function()
    local Hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if Hum then
        if Toggles.WS.Value then Hum.WalkSpeed = Options.WSValue.Value end
        if Toggles.JP.Value then Hum.JumpPower = Options.JPValue.Value Hum.UseJumpPower = true end
        if Toggles.HH.Value then Hum.HipHeight = Options.HHValue.Value end
    end
    workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 196
    if Toggles.FOV.Value then workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
    if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
task.spawn(function()
    while task.wait() do
        if Toggles.Fullbright.Value then
            Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime.Value then
            Lighting.ClockTime = Options.OverrideTimeValue.Value
        end
        if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
if Support.FPS then
    Options.LimitFPSValue:OnChanged(function()
        if FPS_T.Value then setfpscap(FPS_S.Value) end
    end)
    Toggles.LimitFPS:OnChanged(function(v)
        FPS_S:SetVisible(FPS_T.Value)
        if not v then setfpscap(999) end
    end)
end
task.spawn(function()
    pcall(function()
        local cons = getconnections or get_signal_cons
        if cons then
            for _, v in pairs(cons(Plr.Idled)) do
                if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
            end
        end
    end)
    while true do
        task.wait(60)
        if Toggles.AntiAFK and Toggles.AntiAFK.Value then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(0.2)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)
Toggles.AntiKick:OnChanged(function(v)
    if v then
        if not Connections.AntiKick then
            Connections.AntiKick = Plr.AncestryChanged:Connect(function()
                if not Plr:IsDescendantOf(game) then
                    pcall(function() Plr.Parent = game:GetService("Players") end)
                end
            end)
        end
    else
        if Connections.AntiKick then Connections.AntiKick:Disconnect() Connections.AntiKick = nil end
    end
end)
task.spawn(function()
    while true do
        task.wait(60)
        if Toggles.AutoServerhop and Toggles.AutoServerhop.Value then
            local mins = Options.AutoHopMins and Options.AutoHopMins.Value or 30
            task.wait(mins * 60 - 60)
            if not Toggles.AutoServerhop.Value then continue end
            pcall(function()
                local data = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                local parsed = game:GetService("HttpService"):JSONDecode(data)
                if parsed and parsed.data then
                    for _, server in ipairs(parsed.data) do
                        if server.id ~= game.JobId and server.playing < server.maxPlayers then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                            return
                        end
                    end
                end
            end)
        end
    end
end)
Library:Notify("Regretevator loaded.", 3)
