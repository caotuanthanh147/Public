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
local Support = {
    Webhook = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard = (typeof(setclipboard) == "function"),
    FileIO = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    QueueOnTeleport = (typeof(queue_on_teleport) == "function" or typeof(queueonteleport) == "function"),
    Connections = (typeof(getconnections) == "function"),
    FPS = (typeof(setfpscap) == "function"),
    Proximity = (typeof(fireproximityprompt) == "function"),
    HookMeta = (typeof(hookmetamethod) == "function"),
    Firesignal = (typeof(firesignal) == "function"),
}
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
local assetName = "game name"
if v and Asset then
    assetName = Asset.Name
end
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
local repo = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
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
local function LoadModuleAsync(parent, name, onLoaded)
    if not Support.FileIO then return end
    task.spawn(function()
        local obj = parent:FindFirstChild(name)
        local waited = 0
        while not obj and waited < 30 do
            obj = parent:WaitForChild(name, 1)
            waited = waited + 1
            if obj then break end
        end
        if not obj or not obj:IsA("ModuleScript") then return end
        local success, result = pcall(require, obj)
        if success and type(result) == "table" then
            pcall(onLoaded, result)
        end
    end)
end
local function GetSafeRemote(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
        return obj
    end
    return nil
end
local function FireRemote(remote, ...)
    if not remote then return false end
    local args = {...}
    local ok, err = pcall(function()
        remote:FireServer(unpack(args))
    end)
    if not ok then notyuri("FireRemote error:", tostring(remote), tostring(err)) end
    return ok
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
local function AddMultiDropdown(group, id, config)
    config = config or {}
    local labelId = config.label
    local baseValues = config.Values or {}
    local values = { "All" }
    for _, v in ipairs(baseValues) do
        table.insert(values, v)
    end
    group:AddDropdown(id, {
        Text = config.Text,
        Values = values,
        Default = config.Default or {},
        Multi = true,
        Searchable = true,
        Callback = config.Callback,
    })
    local function getSelection()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        if labels["All"] then
            for _, label in ipairs(baseValues) do
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
            return ids
        end
        for label, active in pairs(labels) do
            if active and label ~= "All" then
                if labelId then
                    local mappedId = labelId[label]
                    if mappedId then ids[mappedId] = true end
                else
                    ids[label] = true
                end
            end
        end
        return ids
    end
    local function refresh()
        local newValues = { "All" }
        for _, v in ipairs(baseValues) do
            table.insert(newValues, v)
        end
        if Options[id] then
            Options[id]:SetValues(newValues)
        end
    end
    return getSelection, refresh, baseValues
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
        local args = {...}
        for _, connection in ipairs(getconnections(signal)) do
            if connection.Fire then
                pcall(function() connection:Fire(unpack(args)) end)
            elseif connection.Function then
                task.spawn(connection.Function, unpack(args))
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
            currentTable[flagKey] = task.spawn(featureFunc, ...)
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
local TPTO_BODY_VEL_NAME = "b"
local TPTO_BODY_GYRO_NAME = "a"
local ActiveOrg = nil
local ActiveOrgRefCount = 0
local function EnableBC(hrp)
    local existingVel = hrp:FindFirstChild(TPTO_BODY_VEL_NAME)
    local existingGyro = hrp:FindFirstChild(TPTO_BODY_GYRO_NAME)
    local origins = ActiveOrg or {}
    local char = hrp.Parent
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if origins[part] == nil then
                    origins[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end
    ActiveOrg = origins
    if existingVel and existingGyro then
        return origins
    end
    for _, name in ipairs({TPTO_BODY_VEL_NAME, TPTO_BODY_GYRO_NAME}) do
        local obj = hrp:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
    local bv = Instance.new("BodyVelocity")
    bv.Name = TPTO_BODY_VEL_NAME
    bv.MaxForce = Vector3.new(0, 0, 0)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    local bg = Instance.new("BodyGyro")
    bg.Name = TPTO_BODY_GYRO_NAME
    bg.MaxTorque = Vector3.new(0, 0, 0)
    bg.P = 1000
    bg.D = 50
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    return origins
end
local function AcquireBC(hrp)
    ActiveOrgRefCount = ActiveOrgRefCount + 1
    return EnableBC(hrp)
end
local function ReleaseBC(origins)
    ActiveOrgRefCount = math.max(ActiveOrgRefCount - 1, 0)
    if ActiveOrgRefCount > 0 then
        notyuri("veil TPTo: ReleaseBC skipped, still owned", "refCount="..tostring(ActiveOrgRefCount))
        return
    end
    local char = GetCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and origins[part] ~= nil then
                part.CanCollide = origins[part]
            end
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, name in ipairs({TPTO_BODY_VEL_NAME, TPTO_BODY_GYRO_NAME}) do
                local obj = hrp:FindFirstChild(name)
                if obj then obj:Destroy() end
            end
        end
    end
    ActiveOrg = nil
end
local function TPTo(target, offset, shouldContinue, nearDistance)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        notyuri("veil TPTo abort: no HumanoidRootPart at call time")
        return false
    end
    local cframe
    if typeof(target) == "CFrame" then
        cframe = target
    elseif typeof(target) == "Vector3" then
        cframe = CFrame.new(target)
    elseif typeof(target) == "Instance" then
        if target:IsA("BasePart") then
            cframe = target.CFrame
        elseif target:IsA("Model") then
            cframe = target:GetPivot()
        end
    end
    if not cframe then
        notyuri("veil TPTo abort: could not resolve target to CFrame", tostring(target), typeof(target))
        return false
    end
    if offset then
        cframe = cframe * CFrame.new(offset)
    end
    local destination = cframe
    local stopDistance = 2
    local brakeDistance = math.max(nearDistance or 10, stopDistance)
    local v3inf = Vector3.new(1e99, 1e99, 1e99)
    local v3zero = Vector3.new(0, 0, 0)
    local origins = AcquireBC(hrp)
    local startTick = os.clock()
    local lastLog = startTick
    local function ArriveAtDestination()
        char = GetCharacter()
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            notyuri("veil TPTo stop: HumanoidRootPart lost mid-move (arrive)", "elapsed="..tostring(os.clock() - startTick))
            ReleaseBC(origins)
            return false
        end
        local VelocityHandler = hrp:FindFirstChild(TPTO_BODY_VEL_NAME)
        local GyroHandler = hrp:FindFirstChild(TPTO_BODY_GYRO_NAME)
        if VelocityHandler then
            VelocityHandler.MaxForce = v3zero
            VelocityHandler.Velocity = v3zero
        end
        if GyroHandler then
            GyroHandler.MaxTorque = v3zero
        end
        hrp.CFrame = destination
        notyuri("veil TPTo done: arrived at destination", "elapsed="..tostring(os.clock() - startTick))
        ReleaseBC(origins)
        return true
    end
    notyuri("veil TPTo start", tostring(destination.Position), "hasShouldContinue="..tostring(shouldContinue ~= nil))
    while true do
        if shouldContinue and not shouldContinue() then
            notyuri("veil TPTo stop: shouldContinue returned false", "elapsed="..tostring(os.clock() - startTick))
            ReleaseBC(origins)
            return false
        end
        char = GetCharacter()
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            notyuri("veil TPTo stop: HumanoidRootPart lost mid-move", "elapsed="..tostring(os.clock() - startTick))
            ReleaseBC(origins)
            return false
        end
        origins = EnableBC(hrp)
        local VelocityHandler = hrp:FindFirstChild(TPTO_BODY_VEL_NAME)
        local GyroHandler = hrp:FindFirstChild(TPTO_BODY_GYRO_NAME)
        if not (VelocityHandler and GyroHandler) then
            notyuri("veil TPTo stop: BodyVelocity/BodyGyro missing", "elapsed="..tostring(os.clock() - startTick))
            ReleaseBC(origins)
            return false
        end
        local current = hrp.CFrame
        local remaining = (destination.Position - current.Position).Magnitude
        if remaining <= stopDistance then
            return ArriveAtDestination()
        end
        if os.clock() - lastLog >= 2 then
            notyuri("veil TPTo still moving", "remaining="..tostring(remaining), "elapsed="..tostring(os.clock() - startTick))
            lastLog = os.clock()
        end
        local speed = (Options.TweenSpeed and Options.TweenSpeed.Value) or 10
        local direction = (destination.Position - current.Position).Unit
        local brakeAlpha = math.clamp(remaining / brakeDistance, 0.05, 1)
        VelocityHandler.MaxForce = v3inf
        GyroHandler.MaxTorque = v3inf
        GyroHandler.CFrame = CFrame.new(current.Position, current.Position + direction)
        VelocityHandler.Velocity = direction * (speed * 10 * brakeAlpha)
        RunService.Heartbeat:Wait()
    end
end
local function GetNearest(list, filterFn)
    local char = GetCharacter()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, inst in ipairs(list) do
        if not filterFn or filterFn(inst) then
            local part = inst:IsA("BasePart") and inst or (inst:IsA("Model") and inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart"))
            if part then
                local dist = (part.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = inst
                end
            end
        end
    end
    return best, bestDist
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
        firetouchinterest(part, root, true)
        task.wait()
        firetouchinterest(part, root, false)
    end)
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
            Library:Notify("No servers found to hop to.", 3)
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
        Library:Notify("Serverhop failed: " .. tostring(hopErr), 5)
    end
end
local function QueueOnTeleportExec(code)
    if typeof(queue_on_teleport) == "function" then
        queue_on_teleport(code)
    elseif typeof(queueonteleport) == "function" then
        queueonteleport(code)
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
        T1 = TB.Main.Left.Autofarm:AddTab("Farm"),
        T2 = TB.Main.Left.Autofarm:AddTab("Combat"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("FarmConfig"),
        T2 = TB.Main.Right.Autofarm:AddTab("CombatConfig"),
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
AddSliderToggle({ Group = GB.Player.Left.General, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 1000 })
local TPW_T, TPW_S = AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 30, Rounding = 1 })
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
    Thread("AntiKnockback", Func_AntiKnockback, state)
end)

Toggles.TPW:OnChanged(function(v)
    TPW_S:SetVisible(TPW_T.Value)
    Thread("TPW", FuncTPW, v)
end)
Toggles.Noclip:OnChanged(function(v)
    Thread("Noclip", FuncNoclip, v)
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
    end
end)
Options.LimitFPSValue:OnChanged(function()
    if FPS_T.Value then
        setfpscap(FPS_S.Value)
    end
end)
Toggles.LimitFPS:OnChanged(function(v)
    FPS_S:SetVisible(FPS_T.Value)
    if not v and Support.FPS then
        setfpscap(2000)
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
local RemotesFolder = GetObject(RS, "Remotes")
Remotes.RAbility = GetSafeRemote(RemotesFolder, "RAbilityEvent")
Remotes.TAbility = GetSafeRemote(RemotesFolder, "TAbilityEvent")
Remotes.VAbility = GetSafeRemote(RemotesFolder, "VAbilityEvent")
Remotes.YAbility = GetSafeRemote(RemotesFolder, "YAbilityEvent")
Remotes.UAbility = GetSafeRemote(RemotesFolder, "UAbilityEvent")
Remotes.ClassAbility = GetSafeRemote(RemotesFolder, "ClassAbilityEvent")
Remotes.Awakening = GetSafeRemote(RemotesFolder, "AwakeningEvent")
Remotes.Aura = GetSafeRemote(RemotesFolder, "AuraEvent")
Remotes.Weave = GetSafeRemote(RemotesFolder, "WeaveEvent")
Remotes.QuickDrink = GetSafeRemote(RemotesFolder, "QuickDrinkEvent")
Remotes.InteractPrompt = GetSafeRemote(RemotesFolder, "InteractPromptEvent")
Remotes.SellItems = GetSafeRemote(RemotesFolder, "SellItemsEvent")
Remotes.ClaimDailyReward = GetSafeRemote(RemotesFolder, "ClaimDailyReward")
Remotes.DailySync = GetSafeRemote(RemotesFolder, "DailyRewardsSync")
Remotes.TeleportToWaypoint = GetSafeRemote(RemotesFolder, "TeleportToWaypoint")
Remotes.AbilityCooldown = GetSafeRemote(RemotesFolder, "AbilityCooldownEvent")
Remotes.QuestSync = GetSafeRemote(RemotesFolder, "QuestSync")
Remotes.QuestAction = GetSafeRemote(RemotesFolder, "QuestAction")
Remotes.Dialog = GetSafeRemote(RemotesFolder, "DialogEvent")
Remotes.RegisterNPCInteraction = GetSafeRemote(RemotesFolder, "RegisterNPCInteraction")
Remotes.UpdateInsanity = GetSafeRemote(RemotesFolder, "UpdateInsanity")
local ScriptsFolder = GetObject(RS, "Assets.Scripts")
local CombatFolder = GetObject(RS, "Assets.Scripts.Combat")
Modules.ClientDataCache = GetSafeModule(ScriptsFolder, "ClientDataCache")
Modules.MasteryGate = GetSafeModule(ScriptsFolder, "MasteryGate")
Modules.WeaponCategory = GetSafeModule(ScriptsFolder, "WeaponCategory")
Modules.ItemStacking = GetSafeModule(ScriptsFolder, "ItemStacking")
Modules.AbilitiesModule = GetSafeModule(ScriptsFolder, "AbilitiesModule")
Modules.StatCaps = GetSafeModule(ScriptsFolder, "StatCaps")
Modules.WaypointClientHandler = GetSafeModule(ScriptsFolder, "WaypointClientHandler")
Modules.EnhancementConfig = GetSafeModule(ScriptsFolder, "EnhancementConfig")
Modules.WeaveConfig = GetSafeModule(CombatFolder, "WeaveConfig")
Modules.BeastiaryConfig = GetSafeModule(ScriptsFolder, "BeastiaryConfig")
Modules.DirectionalDash = GetSafeModule(ScriptsFolder, "DirectionalDash")
Support.HookFn = (typeof(hookfunction) == "function" and typeof(clonefunction) == "function")
Support.DebugUpval = (typeof(debug.getupvalue) == "function" and typeof(debug.setupvalue) == "function")
local VE = {
    AbilityCd = {},
    Daily = nil,
    WaypointMap = {},
    WeaveLock = 0,
    LastAura = 0,
    LastCA = 0,
    LastAwaken = 0,
    LastSwap = 0,
    StartKills = nil,
    Quest = nil,
    DialogClicked = nil,
    Session = { Sold = 0, Picked = 0 },
    Busy = { Selling = false, Looting = false },
}
local INVENTORY_GAMEPASS_ID = 1574928871
local INVENTORY_BASE_CAP = 150
local INVENTORY_GAMEPASS_CAP = 250
local function GetInventoryCap()
    if Modules.ClientDataCache and Modules.ClientDataCache.HasEntitlement and Modules.ClientDataCache.HasEntitlement(INVENTORY_GAMEPASS_ID) then
        return INVENTORY_GAMEPASS_CAP
    end
    return INVENTORY_BASE_CAP
end
local function CountInventory()
    local count = 0
    local backpack = Plr:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, v in ipairs(backpack:GetChildren()) do
            if v:IsA("Tool") then
                count = count + 1
            end
        end
    end
    local character = Plr.Character
    if character then
        for _, v in ipairs(character:GetChildren()) do
            if v:IsA("Tool") then
                count = count + 1
            end
        end
    end
    return count
end
local function IsInventoryFull()
    return CountInventory() >= GetInventoryCap()
end
local SellCategories = { "Weapons", "Potions", "Gems", "Accessories", "Outfits", "Summons", "Tomes", "Trinkets", "Items" }
local function GetToolCategory(tool)
    if tool:FindFirstChild("IsEnchant") then
        return "Gems"
    end
    if Modules.ItemStacking and Modules.ItemStacking.IsSword and Modules.ItemStacking.IsSword(tool) then
        return "Weapons"
    end
    if tool:FindFirstChild("IsAccessory") then
        return "Accessories"
    end
    if tool:FindFirstChild("IsOutfit") then
        return "Outfits"
    end
    if tool:FindFirstChild("IsPotion") then
        return "Potions"
    end
    if Modules.ItemStacking and Modules.ItemStacking.IsCastWeapon and Modules.ItemStacking.IsCastWeapon(tool) then
        return "Weapons"
    end
    if tool:FindFirstChild("IsSummonItem") then
        return "Summons"
    end
    if tool:FindFirstChild("EnhancementId") or string.find(tool.Name, "Enhancement Tome", 1, true) then
        return "Tomes"
    end
    if tool:FindFirstChild("IsItem") then
        return "Items"
    end
    local isTrinket = tool:FindFirstChild("IsTrinket")
    if isTrinket and isTrinket:IsA("BoolValue") and isTrinket.Value then
        return "Trinkets"
    end
    return "Items"
end
local RarityRank = {}
local SkillKeys = { "R", "T", "V", "Y", "U" }
local Selections = {
    AbilityGet = nil,
    FarmTarget = nil,
    PickupRarity = nil,
    SellCategory = nil,
    RefreshPickupRarity = nil,
    EspRarity = nil,
    RefreshEspRarity = nil,
    PickupAuraRarity = nil,
    RefreshPickupAuraRarity = nil,
    MeleeAuraTarget = nil,
    StaffAuraTarget = nil,
}
local SilverLabel, KillsLabel, RankLabel, IchorLabel
local HealthLabel, WeaponLabel, CombatLabel, SessionLabel
local function BuildRarityRank()
    table.clear(RarityRank)
    if not (Modules.EnhancementConfig and Modules.EnhancementConfig.RarityOrder) then
        return
    end
    local order = Modules.EnhancementConfig.RarityOrder
    for i, name in ipairs(order) do
        RarityRank[name] = i
    end
    RarityRank.Mythic = #order + 1
    RarityRank.Godly = #order + 2
end
BuildRarityRank()
local MonsterNameWords = {
    "Hiveling", "Skeleton", "Wisp", "Mushling", "Duskwing", "Crusader", "Florist", "Sentinel",
    "Veilborne", "Warden", "Monarch", "Stag", "Lantern", "Effigy", "Pilgrim", "Shade",
    "Behemoth", "Drifter", "Protector", "Mourner", "Sovereign", "Outlaw", "Mender", "Specter",
    "Wanderer", "Champion", "Savior", "Renegade", "Soul", "Gladiator", "Cultist", "Imp",
    "Golem", "Probe", "Disciple", "Vigilante", "Runner", "Dissonant", "Goblin", "Alien",
    "Mimic", "Demon", "Husk", "Dummy", "Wraith", "Minotaur", "Necromancer", "Clown",
    "Cambion", "Nimbus", "Draco", "Saucer", "Gigazapper", "Beholder", "Puppeteer", "Stormcaller",
    "Apparition", "Shard", "Smelter", "Hammer", "Sword", "Archer", "Sorcerer", "Warlock",
    "Warrior", "Thief", "Engineer", "Gunner", "Bones", "Fool", "Merchant", "Blacksmith",
    "Throne", "Titan", "Brute", "Oarsman", "Stranger", "Emperor", "Keeper", "Tamer", "Eye",
}
local function BuildFarmTargetWords()
    local words = {}
    local seen = {}
    for _, word in ipairs(MonsterNameWords) do
        local lower = word:lower()
        if not seen[lower] then
            seen[lower] = lower
            table.insert(words, word)
        end
    end
    if Modules.BeastiaryConfig and Modules.BeastiaryConfig.GetAllMonsterNames then
        local ok, names = pcall(function()
            return Modules.BeastiaryConfig:GetAllMonsterNames()
        end)
        if ok and type(names) == "table" then
            for _, name in ipairs(names) do
                local lower = name:lower()
                local covered = false
                for _, existingLower in pairs(seen) do
                    if existingLower == lower or lower:find(existingLower, 1, true) or existingLower:find(lower, 1, true) then
                        covered = true
                        break
                    end
                end
                if not covered then
                    seen[lower] = lower
                    table.insert(words, name)
                end
            end
        end
    end
    return words
end
local function RarityValues()
    local values = {}
    if Modules.EnhancementConfig and Modules.EnhancementConfig.RarityOrder then
        for _, name in ipairs(Modules.EnhancementConfig.RarityOrder) do
            table.insert(values, name)
        end
        table.insert(values, "Mythic")
        table.insert(values, "Godly")
    end
    return values
end
local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = Services.CoreGui
local AllHighlights = { Monster = {}, Item = {}, NPC = {}, Player = {} }
local ESPPool = { Free = {}, Active = {} }
local function GetAdornee(target)
    if target:IsA("BasePart") then return target end
    if target:IsA("Model") then
        return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function MakeESPLabel(text, sizeY, posY, bold, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, sizeY, 0)
    lbl.Position = UDim2.new(0, 0, posY, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.new(1, 1, 1)
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextScaled = true
    lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    return lbl
end
local function ESPAcq(fillColor, outlineColor, label, textColor)
    local entry = table.remove(ESPPool.Free)
    if not entry then
        local h = Instance.new("Highlight")
        h.FillTransparency = 0.4
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 80, 0, 24)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.ResetOnSpawn = false
        local nameLbl = MakeESPLabel("", 0.55, 0, true, Color3.new(1,1,1))
        nameLbl.Parent = bb
        local distLbl = MakeESPLabel("", 0.45, 0.55, false, Color3.new(1,1,1))
        distLbl.Parent = bb
        entry = { highlight = h, billboard = bb, nameLbl = nameLbl, distLbl = distLbl }
    end
    entry.highlight.FillColor = fillColor
    entry.highlight.OutlineColor = outlineColor
    entry.highlight.Parent = ESPFolder
    entry.nameLbl.Text = label
    entry.nameLbl.TextColor3 = textColor or Color3.new(1,1,1)
    entry.distLbl.TextColor3 = textColor or Color3.new(1,1,1)
    entry.billboard.Parent = ESPFolder
    ESPPool.Active[entry] = true
    return entry
end
local function ESPRelease(entry)
    if not entry or not ESPPool.Active[entry] then return end
    ESPPool.Active[entry] = nil
    entry.highlight.Adornee = nil
    entry.highlight.Parent = nil
    entry.billboard.Adornee = nil
    entry.billboard.Parent = nil
    table.insert(ESPPool.Free, entry)
end
local function ApplyESP(target, fillColor, outlineColor, label, textColor)
    local part = GetAdornee(target)
    if not part then return nil end
    local entry = ESPAcq(fillColor, outlineColor, label, textColor)
    entry.highlight.Adornee = target
    entry.billboard.Adornee = part
    entry.part = part
    return entry
end
local function RemoveESPEntry(tbl, key)
    if tbl[key] then
        ESPRelease(tbl[key])
        tbl[key] = nil
    end
end
local function GetESPMonsters()
    local list = {}
    local folder = workspace:FindFirstChild("Monsters")
    if not folder then return list end
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local enemy = model:FindFirstChild("Enemy")
            if enemy and enemy:IsA("Humanoid") and enemy.Health > 0 then
                local stats = model:FindFirstChild("Stats")
                local basic = stats and stats:FindFirstChild("BasicStats")
                local follow = basic and basic:FindFirstChild("FriendlyFollow")
                local friendly = follow and follow:IsA("BoolValue") and follow.Value
                if not friendly then
                    list[model] = model.Name
                end
            end
        end
    end
    return list
end
local function GetESPItems()
    local list = {}
    local folder = workspace:FindFirstChild("Drops")
    if not folder then return list end
    local rarityFilter = Selections.EspRarity and Selections.EspRarity()
    for _, drop in ipairs(folder:GetChildren()) do
        if drop:IsA("Model") or drop:IsA("BasePart") then
            if not rarityFilter or next(rarityFilter) == nil or rarityFilter[drop:GetAttribute("Rarity") or "Common"] then
                local model = drop:IsA("Model") and drop or drop:FindFirstAncestorOfClass("Model")
                local label = model and model.Name or drop.Name
                local part = GetAdornee(drop)
                if part then
                    list[drop] = label
                end
            end
        end
    end
    return list
end
local function GetESPNPCs()
    local list = {}
    local folder = workspace:FindFirstChild("Monsters")
    if folder then
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") then
                local enemy = model:FindFirstChild("Enemy")
                if enemy and enemy:IsA("Humanoid") and enemy.Health > 0 then
                    local stats = model:FindFirstChild("Stats")
                    local basic = stats and stats:FindFirstChild("BasicStats")
                    local follow = basic and basic:FindFirstChild("FriendlyFollow")
                    if follow and follow:IsA("BoolValue") and follow.Value then
                        list[model] = model.Name
                    end
                end
            end
        end
    end
    local npcFolder = workspace:FindFirstChild("NPCs")
    if npcFolder then
        for _, model in ipairs(npcFolder:GetChildren()) do
            if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
                list[model] = model.Name
            end
        end
    end
    return list
end
local function GetESPPlayers()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Plr then
            local character = plr.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    list[character] = plr.Name
                end
            end
        end
    end
    return list
end
local ESPTargetConfig = {
    { Id = "Monster", Get = GetESPMonsters, Color = Color3.fromRGB(255, 60, 60)  },
    { Id = "Item",    Get = GetESPItems,    Color = Color3.fromRGB(80, 255, 120) },
    { Id = "NPC",     Get = GetESPNPCs,     Color = Color3.fromRGB(255, 200, 60) },
    { Id = "Player",  Get = GetESPPlayers,  Color = Color3.fromRGB(60, 160, 255) },
}
local function RefreshESPGroup(cfg)
    local tbl = AllHighlights[cfg.Id]
    if not Toggles[cfg.Id .. "ESP"].Value then
        for k in pairs(tbl) do RemoveESPEntry(tbl, k) end
        return
    end
    local fillColor = Options[cfg.Id .. "ESPColor"].Value
    local outlineColor = Options[cfg.Id .. "ESPOutline"].Value
    local current = cfg.Get()
    for obj in pairs(tbl) do
        if not current[obj] or not obj.Parent then
            RemoveESPEntry(tbl, obj)
        end
    end
    for obj, label in pairs(current) do
        if not tbl[obj] then
            tbl[obj] = ApplyESP(obj, fillColor, outlineColor, label, fillColor)
        end
    end
end
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        for _, cfg in ipairs(ESPTargetConfig) do
            if Toggles[cfg.Id .. "ESP"] and Toggles[cfg.Id .. "ESP"].Value then
                RefreshESPGroup(cfg)
            end
        end
        task.wait(0.3)
    end
end)
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        local char = Plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local origin = hrp.Position
            for entry in pairs(ESPPool.Active) do
                if entry.part and entry.part.Parent then
                    local dist = math.floor((entry.part.Position - origin).Magnitude)
                    entry.distLbl.Text = dist .. " studs"
                end
            end
        end
        task.wait(0.05)
    end
end)
local ESPGroupLeft  = Tabs.ESP:AddLeftGroupbox("ESP")
local ESPGroupRight = Tabs.ESP:AddRightGroupbox("ESP")
local ESPGroupSides = { ESPGroupLeft, ESPGroupRight }
for i, cfg in ipairs(ESPTargetConfig) do
    local grp = ESPGroupSides[((i - 1) % 2) + 1]
    grp:AddToggle(cfg.Id .. "ESP", { Text = cfg.Id, Default = false })
    grp:AddLabel("Fill"):AddColorPicker(cfg.Id .. "ESPColor", {
        Title = cfg.Id .. " Fill",
        Default = cfg.Color,
    })
    grp:AddLabel("Outline"):AddColorPicker(cfg.Id .. "ESPOutline", {
        Title = cfg.Id .. " Outline",
        Default = Color3.fromRGB(0, 0, 0),
    })
    if cfg.Id == "Item" then
        Selections.EspRarity, Selections.RefreshEspRarity = AddMultiDropdown(grp, "EspRarity", { Text = "Rarity", Values = RarityValues() })
    end
    Toggles[cfg.Id .. "ESP"]:OnChanged(function()
        RefreshESPGroup(cfg)
    end)
end
local function MonsterList(nameFilter)
    local folder = workspace:FindFirstChild("Monsters")
    if not folder then
        return nil
    end
    local hasFilter = nameFilter and next(nameFilter) ~= nil
    local list = {}
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local enemy = model:FindFirstChild("Enemy")
            if enemy and enemy:IsA("Humanoid") and enemy.Health > 0 then
                local friendly = false
                local stats = model:FindFirstChild("Stats")
                local basic = stats and stats:FindFirstChild("BasicStats")
                local follow = basic and basic:FindFirstChild("FriendlyFollow")
                if follow and follow:IsA("BoolValue") and follow.Value then
                    friendly = true
                end
                local matches = true
                if hasFilter then
                    matches = false
                    local lowerName = model.Name:lower()
                    for word in pairs(nameFilter) do
                        if lowerName:find(word:lower(), 1, true) then
                            matches = true
                            break
                        end
                    end
                end
                if not friendly and matches then
                    table.insert(list, model)
                end
            end
        end
    end
    return list
end
local function AimAt(position)
    local camera = workspace.CurrentCamera
    if not (camera and position) then
        return nil
    end
    local origin = camera.CFrame.Position
    if (position - origin).Magnitude < 0.1 then
        return nil
    end
    return CFrame.lookAt(origin, position)
end
local function ActionBlocked(character)
    if Modules.ClientDataCache and Modules.ClientDataCache.IsInPrison and Modules.ClientDataCache.IsInPrison() then
        return true
    end
    if character:GetAttribute("PlayingSong") then
        return true
    end
    if character:GetAttribute("SpawnProtected") then
        return true
    end
    return false
end
local function AbilityReady(key)
    local info = VE.AbilityCd[key]
    if not info then
        return true
    end
    local duration = tonumber(info.duration) or 0
    local startTime = tonumber(info.startTime)
    if not startTime then
        return true
    end
    return workspace:GetServerTimeNow() - startTime >= duration
end
local function EquipBest()
    local character = GetCharacter()
    if not character then
        notyuri("veil equip debug: no character")
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        notyuri("veil equip debug: no humanoid")
        return
    end
    if character:GetAttribute("EquipLocked") or character:GetAttribute("Ragdolled") then
        notyuri("veil equip debug: blocked", "EquipLocked=" .. tostring(character:GetAttribute("EquipLocked")), "Ragdolled=" .. tostring(character:GetAttribute("Ragdolled")))
        return
    end
    if tick() - VE.LastSwap < 0.8 then
        return
    end
    local backpack = Plr:FindFirstChildOfClass("Backpack")
    if not backpack then
        notyuri("veil equip debug: no backpack")
        return
    end
    if not Modules.WeaponCategory then
        notyuri("veil equip debug: no WeaponCategory module")
        return
    end
    local best, bestDamage, bestCategory = nil, -1, nil
    local function consider(tool, category)
        if Modules.MasteryGate and Modules.MasteryGate.IsLocked(tool) then
            return
        end
        local values = tool:FindFirstChild("Values")
        local stats = values and values:FindFirstChild("Stats")
        local base = stats and stats:FindFirstChild("BaseDamage")
        local damage = base and base:IsA("NumberValue") and base.Value or 0
        if damage > bestDamage then
            best, bestDamage, bestCategory = tool, damage, category
        end
    end
    for _, preferred in ipairs({ "Melee", "Cast", "Summon" }) do
        for _, container in ipairs({ backpack, character }) do
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and Modules.WeaponCategory.Classify(tool) == preferred then
                    consider(tool, preferred)
                end
            end
        end
        if best then
            break
        end
    end
    if not best then
        notyuri("veil equip debug: no eligible weapon found")
        return
    end
    if best.Parent == character then
        return
    end
    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool then
        local values = currentTool:FindFirstChild("Values")
        local stats = values and values:FindFirstChild("Stats")
        local base = stats and stats:FindFirstChild("BaseDamage")
        local currentDamage = base and base:IsA("NumberValue") and base.Value or 0
        if currentDamage == bestDamage then
            return
        end
    end
    notyuri("veil equip debug: equipping", best.Name, bestCategory, "damage=" .. tostring(bestDamage))
    humanoid:EquipTool(best)
    VE.LastSwap = tick()
end
local function AutoEquipLoop()
    while Toggles.AutoEquip.Value do
        local ok, err = pcall(function()
            EquipBest()
        end)
        if not ok then
            Library:Notify("Error in [AutoEquip]: " .. tostring(err), 8)
            notyuri("Error in [AutoEquip]: " .. tostring(err))
        end
        task.wait(0.25)
    end
end
local FarmMoving = false
local function FarmTick()
    local ok, err = pcall(function()
        if VE.Busy.Selling or VE.Busy.Looting or FarmMoving then
            notyuri("veil farm blocked", "Selling="..tostring(VE.Busy.Selling), "Looting="..tostring(VE.Busy.Looting), "FarmMoving="..tostring(FarmMoving))
            return
        end
        local character = GetCharacter()
        if not character then
            notyuri("veil farm blocked: no character")
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not (humanoid and root and humanoid.Health > 0) then
            notyuri("veil farm blocked: humanoid/root/health check failed", "humanoid="..tostring(humanoid ~= nil), "root="..tostring(root ~= nil), "health="..tostring(humanoid and humanoid.Health))
            return
        end
        local list = MonsterList(Selections.FarmTarget and Selections.FarmTarget())
        if not list or #list == 0 then
            notyuri("veil farm blocked: no monsters in target list")
            return
        end
        local target, targetDist = GetNearest(list)
        if not target then
            notyuri("veil farm blocked: GetNearest returned no target")
            return
        end
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        if not targetRoot then
            notyuri("veil farm blocked: target has no HumanoidRootPart", tostring(target.Name))
            return
        end
        local maxDist = Options.FarmMaxDistance and Options.FarmMaxDistance.Value or 1000
        if targetDist and targetDist > maxDist then
            notyuri("veil farm blocked: target beyond FarmMaxDistance", tostring(targetDist), tostring(maxDist))
            return
        end
        local distance = Options.FarmDistance and tonumber(Options.FarmDistance.Value) or 3
        local position = Options.FarmPosition and Options.FarmPosition.Value or "Below"
        local targetPos = targetRoot.Position
        local offset
        if position == "Below" then
            offset = Vector3.new(0, -distance, 0)
        elseif position == "Behind" then
            offset = targetRoot.CFrame.LookVector * -distance
        else
            offset = Vector3.new(0, distance, 0)
        end
        local desiredPos = targetPos + offset
        local distToDesired = (desiredPos - root.Position).Magnitude
        if distToDesired <= 0.5 then
            notyuri("veil farm already in position, skipping TPTo", "distToDesired="..tostring(distToDesired))
            return
        end
        FarmMoving = true
        notyuri("veil farm move start", tostring(target.Name), "distance="..tostring(distance), "targetDist="..tostring(targetDist))
        task.spawn(function()
            local moveOk, moveErr = pcall(function()
                local result = TPTo(CFrame.lookAt(targetPos + offset, targetPos), nil, function()
                    if not Toggles.AutoFarm.Value then
                        return false
                    end
                    if target.Parent == nil then
                        return false
                    end
                    local enemy = target:FindFirstChild("Enemy")
                    if enemy and enemy:IsA("Humanoid") and enemy.Health <= 0 then
                        return false
                    end
                    return true
                end)
                notyuri("veil farm move result", tostring(result))
            end)
            if not moveOk then
                notyuri("veil farm move error", tostring(moveErr))
            end
            FarmMoving = false
        end)
        pcall(function()
            local tool = character:FindFirstChildOfClass("Tool")
            tool:Activate()
        end)
    end)
    if not ok then
        Library:Notify("Error in [AutoFarm]: " .. tostring(err), 8)
        notyuri("veil attack error", tostring(err))
    end
end
local function ResolveWaypointSpec(spec)
    if type(spec) ~= "table" then
        return nil
    end
    local kind = spec.Kind
    if kind == "Position" then
        return spec.Position
    end
    if kind == "NearestPosition" then
        local positions = spec.Positions
        if type(positions) ~= "table" then
            return nil
        end
        local character = GetCharacter()
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local bestPos, bestDist = nil, math.huge
        for _, pos in ipairs(positions) do
            local dist = root and (pos - root.Position).Magnitude or 0
            if dist < bestDist then
                bestDist = dist
                bestPos = pos
            end
        end
        return bestPos
    end
    if kind == "Instance" then
        local current = workspace
        for _, name in ipairs(spec.Path or {}) do
            current = current and current:FindFirstChild(name)
        end
        if current and current:IsA("BasePart") then
            return current
        end
        if typeof(spec.Fallback) == "Vector3" then
            return spec.Fallback
        end
        return nil
    end
    if kind == "Multi" then
        for _, sub in ipairs(spec.Targets or {}) do
            local resolved = ResolveWaypointSpec(sub)
            if resolved then
                return resolved
            end
        end
    end
    return nil
end
local function QuestTarget()
    local payload = VE.Quest
    if not payload or payload.State == "Complete" then
        return nil
    end
    return ResolveWaypointSpec(payload.Waypoint)
end
local function GetDialogueGui()
    local playerGui = Plr:FindFirstChild("PlayerGui")
    return playerGui and playerGui:FindFirstChild("DialogueGui")
end
local function AdvanceDialogue()
    local gui = GetDialogueGui()
    if not (gui and gui.Enabled) then
        VE.DialogClicked = nil
        return false
    end
    local mainFrame = gui:FindFirstChild("MainFrame")
    local optionFrame = mainFrame and mainFrame:FindFirstChild("OptionFrame")
    local selection = optionFrame and optionFrame:FindFirstChild("OptionSelectionFrame")
    if not (optionFrame and optionFrame.Visible and selection) then
        return false
    end
    for _, child in ipairs(selection:GetChildren()) do
        if child:IsA("TextButton") and child.Visible then
            if VE.DialogClicked == child then
                return false
            end
            VE.DialogClicked = child
            fire_event(child.MouseButton1Click)
            return true
        end
    end
    return false
end
local function QuestDialogNPC(target, targetPos)
    local folder = workspace:FindFirstChild("NPCs")
    if not folder then
        return nil
    end
    if typeof(target) == "Instance" then
        for _, npc in ipairs(folder:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("NPCDialogueConfig") and target:IsDescendantOf(npc) then
                return npc
            end
        end
    end
    local best, bestDist = nil, 14
    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("DialogPart") and npc:FindFirstChild("NPCDialogueConfig") then
            local dist = (npc.DialogPart.Position - targetPos).Magnitude
            if dist <= bestDist then
                best, bestDist = npc, dist
            end
        end
    end
    return best
end
local function QuestLoop()
    local lastSync = 0
    local lastDialog = 0
    while Toggles.AutoQuest.Value do
        local ok, err = pcall(function()
            local character = GetCharacter()
            if not character then
                task.wait(1)
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not (humanoid and humanoid.Health > 0) then
                task.wait(0.5)
                return
            end
            AdvanceDialogue()
            local gui = GetDialogueGui()
            if gui and gui.Enabled then
                task.wait(0.3)
                return
            end
            local payload = VE.Quest
            local target = QuestTarget()
            if not payload or payload.State == "Complete" then
                if tick() - lastSync > 4 then
                    FireRemote(Remotes.QuestAction, "RequestSync")
                    lastSync = tick()
                end
                task.wait(1)
                return
            end
            if not target then
                task.wait(1)
                return
            end
            local root = character:FindFirstChild("HumanoidRootPart")
            if not root then
                task.wait(0.5)
                return
            end
            local targetPos
            if typeof(target) == "Instance" then
                targetPos = target.Position
            else
                targetPos = target
            end
            local dist = (targetPos - root.Position).Magnitude
            if dist > 10 then
                notyuri("veil quest: moving to target", "dist="..tostring(dist))
                local questArrived = TPTo(target, nil, function()
                    return Toggles.AutoQuest.Value
                end)
                notyuri("veil quest: TPTo result", tostring(questArrived))
                task.wait(0.25)
            end
            if tick() - lastDialog > 2 then
                local npc = QuestDialogNPC(target, targetPos)
                if npc then
                    FireRemote(Remotes.RegisterNPCInteraction, npc.Name)
                    FireRemote(Remotes.Dialog, "start", npc, 1)
                    lastDialog = tick()
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [AutoQuest]: " .. tostring(err), 8)
            notyuri("veil quest error", tostring(err))
        end
        task.wait(0.3)
    end
end
local function WeaveLoop()
    while Toggles.AutoWeave.Value do
        local ok, err = pcall(function()
            local character = GetCharacter()
            if not character then
                task.wait(1)
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not (humanoid and humanoid.Health > 0) then
                task.wait(0.5)
                return
            end
            if ActionBlocked(character) then
                task.wait(0.3)
                return
            end
            local now = workspace:GetServerTimeNow()
            local cooldown = character:GetAttribute("WeaveCdUntil")
            if (not cooldown) or now >= cooldown then
                if now >= VE.WeaveLock then
                    if Modules.WeaveConfig then
                        VE.WeaveLock = now + (Modules.WeaveConfig.WINDOW or 0) + (Modules.WeaveConfig.RELOCK or 0)
                    end
                    FireRemote(Remotes.Weave)
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [AutoWeave]: " .. tostring(err), 8)
            notyuri("veil weave error", tostring(err))
        end
        task.wait(0.1)
    end
end
local function PotionLoop()
    while Toggles.AutoPotion.Value do
        local ok, err = pcall(function()
            local character = GetCharacter()
            if not character then
                task.wait(1)
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not (humanoid and humanoid.MaxHealth > 0) then
                task.wait(0.5)
                return
            end
            if ActionBlocked(character) then
                task.wait(1)
                return
            end
            local threshold = tonumber(Options.PotionHP and Options.PotionHP.Value or 50) or 50
            if humanoid.Health / humanoid.MaxHealth * 100 <= threshold then
                FireRemote(Remotes.QuickDrink, "AllHealth")
                task.wait(1)
            end
        end)
        if not ok then
            Library:Notify("Error in [AutoPotion]: " .. tostring(err), 8)
            notyuri("veil potion error", tostring(err))
        end
        task.wait(0.25)
    end
end
local function AbilityLoop()
    while Toggles.AutoSkill.Value do
        local ok, err = pcall(function()
            if not Modules.AbilitiesModule then
                task.wait(2)
                return
            end
            local character = GetCharacter()
            if not character then
                task.wait(1)
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not (humanoid and humanoid.Health > 0) then
                task.wait(0.5)
                return
            end
            if ActionBlocked(character) then
                task.wait(0.3)
                return
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if not tool then
                task.wait(0.4)
                return
            end
            if Modules.MasteryGate and Modules.MasteryGate.IsLocked(tool) then
                task.wait(1)
                return
            end
            local weapon = Modules.AbilitiesModule.Weapons and Modules.AbilitiesModule.Weapons[tool.Name]
            if not weapon then
                task.wait(0.5)
                return
            end
            local selection = Selections.AbilityGet and Selections.AbilityGet() or {}
            if not next(selection) then
                task.wait(0.5)
                return
            end
            local aim = nil
            local list = MonsterList()
            if list and #list > 0 then
                local target = GetNearest(list)
                if target then
                    aim = AimAt(target:GetPivot().Position)
                end
            end
            for key, active in pairs(selection) do
                if active then
                    local hasKey = false
                    for _, entry in ipairs(weapon) do
                        if entry.key == key then
                            hasKey = true
                            break
                        end
                    end
                    if hasKey and AbilityReady(key) then
                        local remote = Remotes[key .. "Ability"]
                        if remote then
                            VE.AbilityCd[key] = { startTime = workspace:GetServerTimeNow(), duration = 1 }
                            FireRemote(remote, tool, aim)
                        end
                    end
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [AutoSkill]: " .. tostring(err), 8)
            notyuri("veil abilities error", tostring(err))
        end
        task.wait(0.15)
    end
end
local function SpecialLoop()
    while Toggles.AutoCA.Value or Toggles.AutoAwaken.Value or Toggles.AutoAura.Value do
        local ok, err = pcall(function()
            if not Modules.ClientDataCache then
                task.wait(2)
                return
            end
            local character = GetCharacter()
            if not character then
                task.wait(1)
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not (humanoid and humanoid.Health > 0) then
                task.wait(0.5)
                return
            end
            if ActionBlocked(character) then
                task.wait(0.5)
                return
            end
            local equipped = Modules.ClientDataCache.Get().Equipped
            if not equipped then
                task.wait(1)
                return
            end
            local aim = nil
            local list = MonsterList()
            if list and #list > 0 then
                local target = GetNearest(list)
                if target then
                    aim = AimAt(target:GetPivot().Position)
                end
            end
            local now = workspace:GetServerTimeNow()
            if Toggles.AutoCA.Value then
                local name = equipped.ClassAbility
                if name and name ~= "" and name ~= "DefaultCA" and name ~= "No Ability" and name ~= "None" then
                    local info = Modules.AbilitiesModule and Modules.AbilitiesModule.ClassAbilities and Modules.AbilitiesModule.ClassAbilities[name]
                    local cooldown = info and tonumber(info.cooldown)
                    if cooldown and cooldown > 0 and now - VE.LastCA >= cooldown then
                        FireRemote(Remotes.ClassAbility, name, aim)
                        VE.LastCA = now
                    end
                end
            end
            if Toggles.AutoAwaken.Value then
                local name = equipped.Awakening
                if name and name ~= "" then
                    local info = Modules.AbilitiesModule and Modules.AbilitiesModule.Awakenings and Modules.AbilitiesModule.Awakenings[name]
                    local cooldown = info and tonumber(info.cooldown)
                    if cooldown and cooldown > 0 and now - VE.LastAwaken >= cooldown then
                        FireRemote(Remotes.Awakening, name, aim)
                        VE.LastAwaken = now
                    end
                end
            end
            if Toggles.AutoAura.Value then
                local key = equipped.Aura
                if key and key ~= "" and key ~= "DefaultAura" and key ~= "None" then
                    local info = Modules.AbilitiesModule and Modules.AbilitiesModule.Auras and Modules.AbilitiesModule.Auras[key]
                    local cooldown = info and tonumber(info.cooldown)
                    if cooldown and cooldown > 0 and now - VE.LastAura >= cooldown then
                        FireRemote(Remotes.Aura, key, aim)
                        VE.LastAura = now
                    end
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [Class Kit]: " .. tostring(err), 8)
            notyuri("veil specials error", tostring(err))
        end
        task.wait(0.2)
    end
end
local function PickupLoop()
    while Toggles.AutoPickup.Value do
        local ok, err = pcall(function()
            if VE.Busy.Selling then
                VE.Busy.Looting = false
                task.wait(0.2)
                return
            end
            if IsInventoryFull() then
                VE.Busy.Looting = false
                notyuri("veil pickup skipped inventory full")
                Library:Notify("inventory full", 8)
                task.wait(4)
                return
            end
            local character = GetCharacter()
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then
                task.wait(1)
                return
            end
            local folder = workspace:FindFirstChild("Drops")
            if not folder then
                task.wait(1)
                return
            end
            local rarityFilter = Selections.PickupRarity and Selections.PickupRarity()
            local candidates = {}
            for _, drop in ipairs(folder:GetChildren()) do
                local argument = drop:FindFirstChild("Argument")
                if argument and argument:IsA("StringValue") and drop:FindFirstChild("IsInteractable") then
                    local playerID = drop:FindFirstChild("PlayerID")
                    if playerID and playerID:IsA("StringValue") and tonumber(playerID.Value) ~= Plr.UserId then
                        continue
                    end
                    if not rarityFilter or next(rarityFilter) == nil or rarityFilter[drop:GetAttribute("Rarity") or "Common"] then
                        table.insert(candidates, drop)
                    end
                end
            end
            if #candidates == 0 then
                VE.Busy.Looting = false
                task.wait(0.5)
                return
            end
            
            local target, dist = GetNearest(candidates)
            if not target then
                task.wait()
                return
            end
            local pickupRange = 10
            if not dist or dist > pickupRange then
                if VE.Busy.Selling then
                    VE.Busy.Looting = false
                    task.wait(0.2)
                    return
                end
                VE.Busy.Looting = true
                notyuri("veil pickup: moving to drop", tostring(target.Name), "dist="..tostring(dist))
                task.spawn(function()
                    TPTo(target, Vector3.new(0, 2, 0), function()
                        return Toggles.AutoPickup.Value and not VE.Busy.Selling and target.Parent ~= nil
                    end)
                end)
                local arrived = false
                while Toggles.AutoPickup.Value and not VE.Busy.Selling do
                    if target.Parent == nil then
                        notyuri("veil pickup: target disappeared while approaching", tostring(target.Name))
                        break
                    end
                    local ch = GetCharacter()
                    local rt = ch and ch:FindFirstChild("HumanoidRootPart")
                    if not rt then
                        break
                    end
                    local part = target:IsA("BasePart") and target or target:FindFirstChildWhichIsA("BasePart")
                    if not part then
                        break
                    end
                    local liveDist = (part.Position - rt.Position).Magnitude
                    if liveDist <= pickupRange then
                        arrived = true
                        break
                    end
                    task.wait()
                end
                if not arrived then
                    notyuri("veil pickup move failed or interrupted")
                    VE.Busy.Looting = false
                    task.wait(0.2)
                    return
                end
                task.wait()
            end
            if target.Parent == nil then
                VE.Busy.Looting = false
                task.wait(0.1)
                return
            end
            local argument = target:FindFirstChild("Argument")
            if argument and argument:IsA("StringValue") and argument.Value ~= "" then
                FireRemote(Remotes.InteractPrompt, argument.Value, target)
                local confirmStart = os.clock()
                while target.Parent ~= nil and os.clock() - confirmStart < 2 do
                    task.wait()
                end
                if target.Parent == nil then
                    VE.Session.Picked = VE.Session.Picked + 1
                    notyuri("veil pickup: confirmed picked up", tostring(target.Name))
                else
                    notyuri("veil pickup: interact fired but item still present", tostring(target.Name))
                end
            end
            VE.Busy.Looting = false
            task.wait()
        end)
        if not ok then
            Library:Notify("Error in [AutoPickup]: " .. tostring(err), 8)
            notyuri("veil pickup error", tostring(err))
        end
        task.wait()
    end
    VE.Busy.Looting = false
end
local function PickupAuraLoop()
    while Toggles.PickupAura.Value do
        local ok, err = pcall(function()
            if IsInventoryFull() then
                notyuri("veil pickup aura skipped inventory full")
                task.wait(1)
                return
            end
            local character = GetCharacter()
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then
                task.wait(1)
                return
            end
            local folder = workspace:FindFirstChild("Drops")
            if not folder then
                task.wait(1)
                return
            end
            local range = (Options.PickupAuraRange and Options.PickupAuraRange.Value) or 15
            local rarityFilter = Selections.PickupAuraRarity and Selections.PickupAuraRarity()
            for _, drop in ipairs(folder:GetChildren()) do
                local argument = drop:FindFirstChild("Argument")
                if argument and argument:IsA("StringValue") and drop:FindFirstChild("IsInteractable") then
                    local playerID = drop:FindFirstChild("PlayerID")
                    if playerID and playerID:IsA("StringValue") and tonumber(playerID.Value) ~= Plr.UserId then
                        continue
                    end
                    if not rarityFilter or next(rarityFilter) == nil or rarityFilter[drop:GetAttribute("Rarity") or "Common"] then
                        local part = GetAdornee(drop)
                        if part and (part.Position - root.Position).Magnitude <= range then
                            if argument.Value ~= "" then
                                FireRemote(Remotes.InteractPrompt, argument.Value, drop)
                                VE.Session.Picked = VE.Session.Picked + 1
                            end
                        end
                    end
                end
            end
            task.wait(0.3)
        end)
        if not ok then
            Library:Notify("Error in [PickupAura]: " .. tostring(err), 8)
            notyuri("veil pickup aura error", tostring(err))
        end
        task.wait()
    end
end
local function SellLoop()
    while Toggles.AutoSell.Value do
        local ok, err = pcall(function()
            if not (Modules.StatCaps and Modules.EnhancementConfig) then
                VE.Busy.Selling = false
                task.wait(1)
                return
            end
            local backpack = Plr:FindFirstChildOfClass("Backpack")
            if not backpack then
                VE.Busy.Selling = false
                task.wait(1)
                return
            end
            local maxRank = RarityRank[Options.SellRarity and Options.SellRarity.Value]
            if not maxRank then
                VE.Busy.Selling = false
                task.wait(1)
                return
            end
            local leaderstats = Plr:FindFirstChild("leaderstats")
            if not leaderstats then
                VE.Busy.Selling = false
                task.wait(1)
                return
            end
            local silver = leaderstats:FindFirstChild("Silver")
            if not silver then
                VE.Busy.Selling = false
                task.wait(1)
                return
            end
            local cap = Modules.StatCaps.Get("Silver", leaderstats) or Modules.StatCaps.SilverBase
            local containers = { backpack }
            local character = Plr.Character
            if character then
                table.insert(containers, character)
            end
            local categoryFilter = Selections.SellCategory and Selections.SellCategory()
            local list, sum = {}, 0
            for _, container in ipairs(containers) do
                for _, tool in ipairs(container:GetChildren()) do
                    if tool:IsA("Tool") and not tool:GetAttribute("Favorited") then
                        local enhancement = tool:GetAttribute("Enhancements")
                        local rarityChild = tool:FindFirstChild("Rarity")
                        local rarity = rarityChild and rarityChild:IsA("StringValue") and rarityChild.Value or "Common"
                        local rank = RarityRank[rarity]
                        local price = tool:FindFirstChild("SellPrice")
                        local categoryOk = not categoryFilter or next(categoryFilter) == nil or categoryFilter[GetToolCategory(tool)]
                        if rank and rank <= maxRank and price and price:IsA("NumberValue") and price.Value > 0 and (not enhancement or enhancement == "") and categoryOk then
                            table.insert(list, tool)
                            sum = sum + price.Value
                        end
                    end
                end
            end
            if #list > 0 then
                VE.Busy.Selling = true
                local merchant = workspace.NPCs:FindFirstChild("Clement, Merchant")
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if merchant and hrp and (hrp.Position - merchant:GetPivot().Position).Magnitude > 20 then
                    notyuri("veil sell: moving to merchant", "listCount="..tostring(#list))
                    local sellArrived = TPTo(merchant, nil, function()
                        return Toggles.AutoSell.Value
                    end)
                    notyuri("veil sell: TPTo result", tostring(sellArrived))
                    task.wait(0.2)
                end
                if silver.Value + sum > cap then
                    notyuri("veil sell skipped cap", tostring(silver.Value), tostring(sum), tostring(cap))
                else
                    for _, tool in ipairs(list) do
                        if tool.Parent == character then
                            tool.Parent = backpack
                        end
                    end
                    FireRemote(Remotes.SellItems, list)
                    VE.Session.Sold = VE.Session.Sold + #list
                    notyuri("veil sell: fired SellItems", "count="..tostring(#list))
                end
            else
                VE.Busy.Selling = false
            end
        end)
        if not ok then
            Library:Notify("Error in [AutoSell]: " .. tostring(err), 8)
            notyuri("veil sell error", tostring(err))
        end
        task.wait(1)
    end
    VE.Busy.Selling = false
end
local function FaceTarget(hrp, position)
    if not (hrp and position) then
        return
    end
    local origin = hrp.Position
    local flatTarget = Vector3.new(position.X, origin.Y, position.Z)
    if (flatTarget - origin).Magnitude < 0.1 then
        return
    end
    hrp.CFrame = CFrame.lookAt(origin, flatTarget)
end
local function GetAuraTargets(targetSelection)
    local selection = targetSelection and targetSelection() or nil
    local includeMonsters = not selection or next(selection) == nil or selection["Monsters"]
    local includePlayers = selection and selection["Players"]
    local list = {}
    if includeMonsters then
        local monsters = MonsterList()
        if monsters then
            for _, model in ipairs(monsters) do
                table.insert(list, model)
            end
        end
    end
    if includePlayers then
        for character in pairs(GetESPPlayers()) do
            table.insert(list, character)
        end
    end
    return list
end
local function MeleeAuraLoop()
    local lastActivate = 0
    while Toggles.MeleeAura.Value do
        local ok, err = pcall(function()
            local character = GetCharacter()
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if not (humanoid and root and humanoid.Health > 0) then
                return
            end
            if ActionBlocked(character) then
                return
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if not (tool and Modules.ItemStacking and Modules.ItemStacking.IsSword and Modules.ItemStacking.IsSword(tool)) then
                return
            end
            local range = (Options.MeleeAuraRange and Options.MeleeAuraRange.Value) or 10
            local list = GetAuraTargets(Selections.MeleeAuraTarget)
            local target, dist = GetNearest(list)
            if target and dist and dist <= range then
                local targetPart = target:FindFirstChild("HumanoidRootPart") or (target:IsA("Model") and target.PrimaryPart) or target:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    FaceTarget(root, targetPart.Position)
                end
                if tick() - lastActivate >= 0.15 then
                    tool:Activate()
                    lastActivate = tick()
                    notyuri("veil melee aura: activated", tostring(target.Name), "dist="..tostring(dist))
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [MeleeAura]: " .. tostring(err), 8)
            notyuri("veil melee aura error", tostring(err))
        end
        RunService.Heartbeat:Wait()
    end
end
local function StaffAuraLoop()
    local lastActivate = 0
    while Toggles.StaffAura.Value do
        local ok, err = pcall(function()
            local character = GetCharacter()
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if not (humanoid and root and humanoid.Health > 0) then
                return
            end
            if ActionBlocked(character) then
                return
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if not (tool and Modules.ItemStacking and Modules.ItemStacking.IsCastWeapon and Modules.ItemStacking.IsCastWeapon(tool)) then
                return
            end
            local range = (Options.StaffAuraRange and Options.StaffAuraRange.Value) or 30
            local list = GetAuraTargets(Selections.StaffAuraTarget)
            local target, dist = GetNearest(list)
            if target and dist and dist <= range then
                local targetPart = target:FindFirstChild("HumanoidRootPart") or (target:IsA("Model") and target.PrimaryPart) or target:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    FaceTarget(root, targetPart.Position)
                end
                if tick() - lastActivate >= 0.15 then
                    tool:Activate()
                    lastActivate = tick()
                    notyuri("veil staff aura: activated", tostring(target.Name), "dist="..tostring(dist))
                end
            end
        end)
        if not ok then
            Library:Notify("Error in [StaffAura]: " .. tostring(err), 8)
            notyuri("veil staff aura error", tostring(err))
        end
        RunService.Heartbeat:Wait()
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoFarm", { Text = "Auto Farm", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoSkill", { Text = "Auto Skill", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoEquip", { Text = "Auto Equip Weapon", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoWeave", { Text = "Auto Weave", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoPotion", { Text = "Auto Potions", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("AutoCA", { Text = "Auto Class Ability", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAwaken", { Text = "Auto Awakening", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAura", { Text = "Auto Aura", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("PickupAura", { Text = "Pickup Aura", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("MeleeAura", { Text = "Melee Aura", Default = false })
TB_Tabs.Autofarm.T2:AddToggle("StaffAura", { Text = "Staff Aura", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell Items", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoQuest", { Text = "Auto Quest", Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("TweenSpeed", { Text = "Tween Speed", Default = 10, Min = 1, Max = 50, Rounding = 0 })
Selections.AbilityGet = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "SkillKeys", { Text = "Skill Keys", Values = SkillKeys, Default = { R = true } })
Selections.FarmTarget = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "FarmTargets", { Text = "Farm Targets", Values = BuildFarmTargetWords() })
TB_Tabs.Autofarm2.T1:AddDropdown("FarmPosition", { Text = "Farm Position", Values = { "Above", "Below", "Behind" }, Default = "Below" })
TB_Tabs.Autofarm2.T1:AddInput("FarmDistance", { Text = "Farm Distance", Default = "7" })
TB_Tabs.Autofarm2.T1:AddSlider("FarmMaxDistance", { Text = "Farm Max Distance", Default = 1000, Min = 0, Max = 10000, Rounding = 0 })
TB_Tabs.Autofarm2.T2:AddInput("PotionHP", { Text = "Drink Below", Default = "50" })
TB_Tabs.Autofarm2.T1:AddDropdown("SellRarity", { Text = "Max Rarity To Sell", Values = RarityValues(), Default = "Common" })
Selections.SellCategory = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "SellCategory", { Text = "Sell Categories", Values = SellCategories })
Selections.PickupRarity, Selections.RefreshPickupRarity = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PickupRarity", { Text = "Pickup Rarity", Values = RarityValues() })
TB_Tabs.Autofarm2.T1:AddSlider("PickupAuraRange", { Text = "Pickup Aura Range", Default = 15, Min = 1, Max = 200, Rounding = 0 })
TB_Tabs.Autofarm2.T2:AddSlider("MeleeAuraRange", { Text = "Melee Aura Range", Default = 10, Min = 1, Max = 100, Rounding = 0 })
Selections.MeleeAuraTarget = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "MeleeAuraTargets", { Text = "Melee Aura Targets", Values = { "Monsters", "Players" }, Default = { Monsters = true } })
TB_Tabs.Autofarm2.T2:AddSlider("StaffAuraRange", { Text = "Staff Aura Range", Default = 30, Min = 1, Max = 200, Rounding = 0 })
Selections.StaffAuraTarget = AddMultiDropdown(TB_Tabs.Autofarm2.T2, "StaffAuraTargets", { Text = "Staff Aura Targets", Values = { "Monsters", "Players" }, Default = { Monsters = true } })
Selections.PickupAuraRarity, Selections.RefreshPickupAuraRarity = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "PickupAuraRarity", { Text = "Pickup Aura Rarity", Values = RarityValues() })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Teleport To Quest", Func = function()
    local target = QuestTarget()
    if not target then
        FireRemote(Remotes.QuestAction, "RequestSync")
        task.wait(1)
        target = QuestTarget()
    end
    if not target then
        Library:Notify("No main quest.", 3)
        return
    end
    TPTo(target)
end })
local function SpecialThreadState()
    return (Toggles.AutoCA and Toggles.AutoCA.Value) or (Toggles.AutoAwaken and Toggles.AutoAwaken.Value) or (Toggles.AutoAura and Toggles.AutoAura.Value)
end
Toggles.AutoFarm:OnChanged(function(state)
    if Connections.Farm then
        Connections.Farm:Disconnect()
        Connections.Farm = nil
    end
    if state then
        Connections.Farm = RunService.Heartbeat:Connect(FarmTick)
    else
        FarmMoving = false
    end
end)
Toggles.AutoWeave:OnChanged(function(state)
    Thread(".Weave", WeaveLoop, state)
end)
Toggles.AutoPotion:OnChanged(function(state)
    Thread(".Potion", PotionLoop, state)
end)
Toggles.AutoEquip:OnChanged(function(state)
    Thread(".Equip", AutoEquipLoop, state)
end)
Toggles.AutoSkill:OnChanged(function(state)
    Thread(".Abilities", AbilityLoop, state)
end)
Toggles.AutoCA:OnChanged(function(state)
    Thread(".Specials", SpecialLoop, SpecialThreadState())
end)
Toggles.AutoAwaken:OnChanged(function(state)
    Thread(".Specials", SpecialLoop, SpecialThreadState())
end)
Toggles.AutoAura:OnChanged(function(state)
    Thread(".Specials", SpecialLoop, SpecialThreadState())
end)
Toggles.AutoPickup:OnChanged(function(state)
    if not state then
        VE.Busy.Looting = false
    end
    Thread(".Pickup", PickupLoop, state)
end)
Toggles.PickupAura:OnChanged(function(state)
    Thread(".PickupAura", PickupAuraLoop, state)
end)
Toggles.MeleeAura:OnChanged(function(state)
    Thread(".MeleeAura", MeleeAuraLoop, state)
end)
Toggles.StaffAura:OnChanged(function(state)
    Thread(".StaffAura", StaffAuraLoop, state)
end)
Toggles.AutoSell:OnChanged(function(state)
    if not state then
        VE.Busy.Selling = false
    end
    Thread(".Sell", SellLoop, state)
end)
Toggles.AutoQuest:OnChanged(function(state)
    Thread(".Quest", QuestLoop, state)
end)
SafeConnect("_AbilityCooldown", function()
    return Remotes.AbilityCooldown and Remotes.AbilityCooldown.OnClientEvent
end, function(key, info)
    if type(key) == "string" then
        if type(info) == "table" then
            VE.AbilityCd[key] = info
        elseif type(info) == "number" then
            VE.AbilityCd[key] = { startTime = workspace:GetServerTimeNow(), duration = info }
        end
    end
end)
SafeConnect("_DailySync", function()
    return Remotes.DailySync and Remotes.DailySync.OnClientEvent
end, function(data)
    if type(data) == "table" then
        VE.Daily = data
    end
end)
SafeConnect("_QuestSync", function()
    return Remotes.QuestSync and Remotes.QuestSync.OnClientEvent
end, function(payload)
    if type(payload) == "table" then
        VE.Quest = payload
    else
        VE.Quest = nil
    end
end)
if Remotes.QuestAction then
    FireRemote(Remotes.QuestAction, "RequestSync")
end
SafeConnect("_CharacterAdded", function()
    return Plr.CharacterAdded
end, function()
    VE.AbilityCd = {}
    VE.WeaveLock = 0
    VE.DialogClicked = nil
end)
if not Modules.EnhancementConfig then
    LoadModuleAsync(ScriptsFolder, "EnhancementConfig", function(module)
        Modules.EnhancementConfig = module
        BuildRarityRank()
        if Options.SellRarity then
            Options.SellRarity:SetValues(RarityValues())
        end
        if Selections.RefreshPickupRarity then
            Selections.RefreshPickupRarity()
        end
        if Selections.RefreshPickupAuraRarity then
            Selections.RefreshPickupAuraRarity()
        end
    end)
end
if not Modules.WaypointClientHandler then
    LoadModuleAsync(ScriptsFolder, "WaypointClientHandler", function(module)
        Modules.WaypointClientHandler = module
        RefreshWaypoints()
    end)
end
if not Modules.AbilitiesModule then
    LoadModuleAsync(ScriptsFolder, "AbilitiesModule", function(module)
        Modules.AbilitiesModule = module
    end)
end
if not Modules.ClientDataCache then
    LoadModuleAsync(ScriptsFolder, "ClientDataCache", function(module)
        Modules.ClientDataCache = module
    end)
end
if not Modules.WeaveConfig then
    LoadModuleAsync(CombatFolder, "WeaveConfig", function(module)
        Modules.WeaveConfig = module
    end)
end
local antiAFKConn = nil
local function RunAntiAFK()
    if antiAFKConn then antiAFKConn:Enable() return end
    local GC = getconnections or get_signal_cons
    if GC then
        local conns = GC(Players.LocalPlayer.Idled)
        local target = conns and conns[1]
        if target and target.Disable then
            target:Disable()
            antiAFKConn = target
            return
        end
        for _, c in pairs(conns or {}) do
            if c.Disable then
                c:Disable()
                antiAFKConn = c
                return
            elseif c.Disconnect then
                c:Disconnect()
                return
            end
        end
    end
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
Toggles.AntiAFK:OnChanged(function(state)
    if state then
        RunAntiAFK()
    elseif antiAFKConn and antiAFKConn.Enable then
        antiAFKConn:Enable()
    end
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
    if antiAFKConn and antiAFKConn.Enable then pcall(function() antiAFKConn:Enable() end) end
    if Support.FPS then pcall(function() setfpscap(2000) end) end
    Cleanup(Connections)
    Cleanup(Flags)
        Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/Veil")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
task.defer(function()
    SaveManager:LoadAutoloadConfig()
end)
SaveManager:SetLoadingOrder(true, {"Dropdown", "Slider", "ColorPicker", "KeyPicker", "Input", "Toggle"})
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
