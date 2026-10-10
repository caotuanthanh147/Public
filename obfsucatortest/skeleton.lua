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
            local inviteCode = "uuza7nsPq"
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
    else
        warn("Your executor does not support firesignal or getconnections.")
    end
end
local _FS = (_DR and _DR.FireServer)
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local Shared = { 
    Farm = false, 
    LastSwitch = {}, 
    RevertAmount = 0,
    FarmPos = "Above",
    ShopAmount = 0,
    FarmDist = 7,
    ScanInterval = 0.25,
    TweenConnection = nil,
    CurrentTarget = nil,
    LastScan = 0,
    LastClick = 0,
    IsBusy = false,
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
function AddMultiDropdown(group, id, config)
    if type(group) == "string" then
        local selected = {}
        local dropdown = Options[group]
        local values = dropdown and dropdown.Values or {}
        local chosen = dropdown and dropdown.Value or {}
        if chosen["All"] then
            for _, label in ipairs(values) do
                if label ~= "All" then selected[label] = true end
            end
        else
            for label, active in pairs(chosen) do
                if active and label ~= "All" then selected[label] = true end
            end
        end
        return selected
    end
    config = config or {}
    local values = { "All" }
    for _, v in ipairs(config.Values or {}) do
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
    return Options[id]
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
local function ApplyFPSBoost()
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
    if not fireproximityprompt then
        return
    end
    if not target or not target:IsA("ProximityPrompt") then
        return
    end
    local prevDist = target.MaxActivationDistance
    if teleport then
        local char = GetCharacter()  
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        if part and not part:IsA("BasePart") then
            part = target:FindFirstAncestorWhichIsA("BasePart")
        end
        if hrp and part then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist > (prevDist - 2) then
                hrp.CFrame = part.CFrame * CFrame.new(0, 0, -3)
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
            MiscAuto = Tabs.Main:AddLeftTabbox(),
        },
        Right = {
            Autofarm = Tabs.Main:AddRightTabbox(),
            MiscAuto = Tabs.Main:AddRightTabbox(),
        },
    },
}
local TB_Tabs = {
    Autofarm = {
        T1 = TB.Main.Left.Autofarm:AddTab("Combat"),
        T3 = TB.Main.Left.Autofarm:AddTab("Misc"),
    },
    Autofarm2 = {
        T1 = TB.Main.Right.Autofarm:AddTab("Config"),
    },
}
local GB = {
    Player = {
        Left = {
            General = Tabs.Player:AddLeftGroupbox("General"),
            Server = Tabs.Player:AddLeftGroupbox("Server"),
        },
        Right = {
            Game = Tabs.Player:AddRightGroupbox("Game"),
        },
    },
}
local function notify(title, message, time)
    Library:Notify(tostring(title) .. " — " .. tostring(message), tonumber(time) or 3)
end
local function getRoot()
    local char = Plr.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
end
local touchInterestConnection = nil
local NoHitConnection   = nil
local WEAPON_ABILITIES = {
    ["Reaper Scythe"] = {
        {slot = 1, name = "Wrathful Rot", key = "Z"},
    },
    ["Bone Mirage"] = {
        {slot = 1, name = "Round Trip", key = "Z"},
    },
    ["Murasama"] = {
        {slot = 1, name = "Aerial Sweep", key = "Z"},
        {slot = 2, name = "Sawdust", key = "X"},
    },
    ["Banana Gun"] = {
        {slot = 1, name = "Airsnipe", key = "Z"},
    },
    ["Extracted Bluescreen"] = {
        {slot = 1, name = "Crash", key = "Z"},
        {slot = 2, name = "EXTRACTION", key = "-"},
    },
    ["Steak Knife"] = {
        {slot = 1, name = "Emotions", key = "Z"},
        {slot = 2, name = "Red Hand", key = "X"},
    },
    ["Ilia Topuria Gloves"] = {
        {slot = 1, name = "K.O COUNTER", key = "Z"},
    },
    ["Microphone Throw"] = {
        {slot = 2, name = "BEAR5 POWER", key = "-"},
    },
    ["Guitar"] = {
        {slot = 1, name = "Bash Jam", key = "Z"},
    },
    ["WHITE CIRCLE"] = {
        {slot = 1, name = "MY VERY OWN COMBO.", key = "-"},
    },
    ["Backbone"] = {
        {slot = 1, name = "Block", key = "Z"},
    },
    ["Paint Brush"] = {
        {slot = 1, name = "Shield", key = "Z"},
    },
}
local AbilitySlot = {"Ability1", "Ability2", "Ability3"}
local function getAbilityRemote(slot)
    local remote = PGui
        and PGui:FindFirstChild("GuisNoReset")
        and PGui.GuisNoReset:FindFirstChild("InventoryFrame")
        and PGui.GuisNoReset.InventoryFrame:FindFirstChild("Abilityframe")
        and PGui.GuisNoReset.InventoryFrame.Abilityframe:FindFirstChild(AbilitySlot[slot])
    return remote and remote:FindFirstChild("RllyAbility")
end
local function autoAbilityLoop()
    while Toggles.AutoAbility.Value do
        local character = Plr.Character
        local tool = character and character:FindFirstChildOfClass("Tool")
        if tool then
            local chars = workspace:FindFirstChild("PlayerChars") and workspace.PlayerChars:FindFirstChild("Chars")
            local playerFolder = chars and chars:FindFirstChild(Plr.Name)
            local toolFolder = playerFolder and playerFolder:FindFirstChild(tool.Name)
            local abilityFolder = toolFolder and toolFolder:FindFirstChild("Ability")
            if abilityFolder then
                local target = Shared.CurrentTarget
                local targetPos = target and resolvePosition(target) or nil
                for _, remote in ipairs(abilityFolder:GetChildren()) do
                    pcall(function()
                        remote:FireServer(targetPos)
                    end)
                end
            end
        end
        task.wait(1)
    end
end
local function resolvePosition(target)
    if typeof(target) == "CFrame" then
        return target.Position
    end
    if typeof(target) == "table" and target.x and target.y and target.z then
        return Vector3.new(target.x, target.y, target.z)
    end
    if typeof(target) == "Vector3" then
        return target
    elseif typeof(target) == "Instance" then
        if target:IsA("Model") then
            return target:GetPivot().Position
        elseif target:IsA("BasePart") then
            return target.Position
        end
    end
    return nil
end
local function lookAt(target, part)
    local targetPos = resolvePosition(target)
    local lookPart = part or (Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart"))
    if lookPart and targetPos then
        lookPart.CFrame = CFrame.lookAt(lookPart.Position, targetPos)
    end
end
local function findTarget()
    if not Plr or not Plr.Character then return nil, math.huge end
    local hrp   = Plr.Character:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position or Vector3.new(0, 0, 0)
    local highestRarity = -math.huge
    local bestEntity    = nil
    local nearestDist   = math.huge
    local searchCollection = workspace:FindFirstChild("Entities") or workspace
    for _, entity in ipairs(searchCollection:GetChildren()) do
        local rarityValue = entity:FindFirstChild("Rarity")
        if rarityValue then
            local rarity    = rarityValue.Value
            local entityHRP = entity:FindFirstChild("HumanoidRootPart")
            local humanoid  = entity:FindFirstChildWhichIsA("Humanoid")
            if entityHRP and humanoid and humanoid.Health < humanoid.MaxHealth then
                local d = (entityHRP.Position - myPos).Magnitude
                if rarity > highestRarity then
                    highestRarity = rarity
                    bestEntity    = entityHRP
                    nearestDist   = d
                elseif rarity == highestRarity and d < nearestDist then
                    bestEntity  = entityHRP
                    nearestDist = d
                end
            end
        end
    end
    return bestEntity, nearestDist
end
local function getSansTitle(targetModel)
    if not targetModel then
        notyuri("getSansTitle: targetModel is nil")
        return nil
    end
    local modelFolder = targetModel:FindFirstChild("Model")
    local main = modelFolder and modelFolder:FindFirstChild("Main")
    local billboard = main and main:FindFirstChild("BillboardGui")
    local titleLabel = billboard and billboard:FindFirstChild("Title")
    notyuri("getSansTitle:", targetModel.Name,
        "Model=", modelFolder and "found" or "MISSING",
        "Main=", main and "found" or "MISSING",
        "BillboardGui=", billboard and "found" or "MISSING",
        "Title=", titleLabel and "found" or "MISSING",
        "Text=", titleLabel and titleLabel.Text or "nil")
    return titleLabel and titleLabel.Text or nil
end
local function isTitleExcluded(title)
    if not title then return false end
    local dropdown = Options.ExcludeClick
    local labels = dropdown and dropdown.Value
    if not labels then return false end
    if labels["All"] then return true end
    return labels[title] == true
end
local function clickTarget(targetModel)
    if not targetModel then return end
    local title = getSansTitle(targetModel)
    local excluded = isTitleExcluded(title)
    notyuri("clickTarget:", targetModel.Name, "title=", tostring(title), "excluded=", tostring(excluded))
    if excluded then return false end
    local clickDetector = targetModel:FindFirstChild("ClickDetector")
    if not clickDetector then
        for _, descendant in ipairs(targetModel:GetDescendants()) do
            if descendant:IsA("ClickDetector") then clickDetector = descendant; break end
        end
    end
    if clickDetector then fireclickdetector(clickDetector); return true end
    return false
end
local function Func_NoHit()
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("MeshPart") or child:IsA("Model") or child:IsA("Part") then
            for _, descendant in pairs(child:GetDescendants()) do
                if descendant.Name == "TouchInterest" then
                    local parent = descendant.Parent
                    if parent then parent:Destroy() end
                end
            end
        end
    end
    touchInterestConnection = workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "TouchInterest" then
            local parent = descendant.Parent
            if parent then parent:Destroy() end
        end
    end)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Part") then
            obj.CanTouch = false
        end
    end
    NoHitConnection = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") or obj:IsA("Part") then
            obj.CanTouch = false
        end
    end)
    repeat task.wait(1) until not Toggles.Invincible.Value
    if touchInterestConnection then touchInterestConnection:Disconnect(); touchInterestConnection = nil end
    if NoHitConnection   then NoHitConnection:Disconnect();   NoHitConnection   = nil end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Part") then
            obj.CanTouch = true
        end
    end
end
TB_Tabs.Autofarm.T1:AddToggle("Invincible", {
    Text    = "(Partial) Invincible",
    Default = false,
})
local function Func_AutoUseWeapon()
    while Toggles.AutoWeapon.Value do
        local character = Plr.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if not tool then
                local backpackTool = Plr.Backpack:FindFirstChildOfClass("Tool")
                if backpackTool then
                    backpackTool.Parent = character
                    task.wait(0.1)
                    tool = character:FindFirstChildOfClass("Tool")
                end
            end
            if tool then
                local remote = tool:FindFirstChild("RemoteEvent")
                pcall(function()
                    if remote then
                        local target = Shared.CurrentTarget
                        local targetPos = target and resolvePosition(target) or nil
                        remote:FireServer(targetPos)
                    else
                        tool:Activate()
                    end
                end)
            end
        end
        task.wait(0.1)
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoWeapon", {
    Text    = "Auto Weapon",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoAbility", {
    Text    = "Auto Ability",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddInput("FarmDist", {
    AllowNull = true,
    Numeric   = false,
    Finished  = false,
    Text      = "Distance",
    Callback = function(Value)
        local number = tonumber(Value)
        if number then
            Shared.FarmDist = number
        end
    end,
})
TB_Tabs.Autofarm2.T1:AddDropdown("FarmPos", {
    Text    = "Position",
    Values  = {"Above", "Below", "Behind", "Front"},
    Multi   = false,
    AllowNull = true,
    Callback = function(Value)
        Shared.FarmPos = Value
    end,
})
local excludeTargetsList = {
    "SANS",
    "SWAP SANS",
    "SWAP PAPYRUS",
    "FELL SANS",
    "OUTER SANS",
    "STORYSHIFT CHARA",
    "SWAPSWAP SANS",
    "TSUNDERSWAP PAPYRUS",
    "HORROR SANS",
    "HARDTALE SANS",
    "DUST SANS",
    "PHOTONEGATIVE SANS",
    "KILLER SANS",
    "FALLEN STARS SANS",
    "DREAM SANS",
    "GENO SANS",
    "TOXIC GAS SANS",
    "SCIENCE SANS",
    "MAFIA SANS",
    "FLAME SANS",
    "CROSS SANS",
    "DELTA SANS",
    "ANTIVIRUS SANS",
    "DUSTFELL SANS",
    "DETERMINED GENO SANS",
    "NIGHTMARE SANS",
    "CHARA",
    "THE J",
    "EVAN DUST",
    "FRESH SANS",
    "EPIC SANS",
    "VENOM SANS",
    "DANCETALE SANS",
    "GANS",
    "HYPER DUST",
    "HORRORFELL",
    "ENTITY LEVEL KILLER",
    "DELTA SANS - PHASE 2",
    "CROSS CHARA",
    "MAFIA SANS - LEVEL 100",
    "SAND UNDERMAN BUT HE HAS A GUN",
    "REVERTDUST",
    "VIRUS SANS",
    "RED",
    "SHATTERED DREAM",
    "ZOMBIE SANS",
    "TSUNDERSWAP PAPYRUS - PHASE 2",
    "ICE SANS",
    "PIRATE SANS",
    "ZINSANITY",
    "DUSTSHIFT CHARA",
    "INK SANS",
    "SANSENBERG",
    "ERROR SANS",
    "CHICA",
    "SWAPFELL PAPYRUS",
    "BONNIE",
    "BONELY ONE",
    "ABYSS SANS",
    "BLUESCREEN SANS",
    "CHROMATIC SANS",
    "REAPER SANS",
    "DUSTDUST SANS",
    "ANNOYING ORANGE",
    "GODSPEED",
    "DISBELIEF PAPYRUS",
    "DUSTSWAP PAPYRUS",
    "UNDERWORLD SANS",
    "AXETALE SANS",
    "TRUE DUST",
    "FATAL ERROR SANS",
    "FREDDY FAZBEAR SANS2",
    "BEAR5",
    "PARASITIC FRESH SANS",
    "HYPERDUSTFELL SANS",
    "HORRORDUSTSWAPFELL PAPYRUS",
    "ROTTEN ORANGE",
    "SIX FEET UNDER",
    "GRU2",
    "VIRUS404",
    "ARANEA",
    "the streetman",
    "TRUE PAIN",
    "SP!DUST SANS",
    "SAVE ME IM STUCK ON THE BASEPLATE",
    "SANSKUNA",
    "WEATHERGIRL",
    "MAFIOSO",
    "CHROMATIC - CHRYSALIS",
    "SAVE STAR",
    "SYNO SANS",
    "CHOMIK",
    "RED SANS",
    "YAMATO",
    "LEBRANS",
    "MYDOOM",
    "CSB DUST",
    "TORNADO SANS",
    "DUST RED SANS",
    "OMORI",
    "WHITE SANS",
    "LIMBO SANS.",
}
AddMultiDropdown(TB_Tabs.Autofarm2.T1, "ExcludeClick", {
    Text   = "Exclude Click",
    Values = excludeTargetsList,
})
local function Func_AutoIsolatedSoul()
    while Toggles.AutoIsolatedSoul.Value do
        local model = workspace:FindFirstChild("Isolatedsoul")
        local pp = model
            and model:FindFirstChild("Main")
            and model.Main:FindFirstChild("ProximityPrompt")
        if pp then
            Shared.IsBusy = true
            FirePP(pp, true)
            task.wait(2)
            Shared.IsBusy = false
        end
        task.wait(1)
    end
    Shared.IsBusy = false
end
local function Func_AutoTween()
    if Shared.TweenConnection then 
        Shared.TweenConnection:Disconnect() 
        Shared.TweenConnection = nil 
    end
    Shared.CurrentTarget = nil
    Shared.TweenConnection = RunService.Heartbeat:Connect(function(dt)
        if not Plr or not Plr.Character or not Toggles.AutoTween.Value or Shared.IsBusy then return end
        local hrp = Plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        Shared.LastScan  = Shared.LastScan  + dt
        Shared.LastClick = Shared.LastClick + dt
        local needScan = (not Shared.CurrentTarget) or (not Shared.CurrentTarget.Parent) or (not Shared.CurrentTarget.Parent:FindFirstChildWhichIsA("Humanoid"))
        if Shared.CurrentTarget and Shared.CurrentTarget.Parent then
            local hum = Shared.CurrentTarget.Parent:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health >= hum.MaxHealth then 
                needScan = true
                Shared.CurrentTarget = nil 
            end
        end
        if needScan and Shared.LastScan >= Shared.ScanInterval then
            Shared.LastScan = 0
            Shared.CurrentTarget = findTarget()
        end
        if Shared.CurrentTarget and Shared.CurrentTarget.Parent then
            local hum = Shared.CurrentTarget.Parent:FindFirstChildWhichIsA("Humanoid")
            if not hum or hum.Health >= hum.MaxHealth then 
                Shared.CurrentTarget = nil
                return 
            end
            if not Shared.CurrentTarget:IsDescendantOf(workspace) then 
                Shared.CurrentTarget = nil
                return 
            end
            local targetPos = resolvePosition(Shared.CurrentTarget)
            if not targetPos then return end
            local offset = Vector3.zero
            if Shared.FarmPos == "Above" then
                offset = Vector3.new(0, Shared.FarmDist, 0)
            elseif Shared.FarmPos == "Below" then
                offset = Vector3.new(0, -Shared.FarmDist, 0)
            elseif Shared.FarmPos == "Behind" then
                if Shared.CurrentTarget:IsA("BasePart") then
                    offset = Shared.CurrentTarget.CFrame.LookVector * -Shared.FarmDist
                else
                    offset = Vector3.new(0, 0, -Shared.FarmDist)
                end
            elseif Shared.FarmPos == "Front" then
                if Shared.CurrentTarget:IsA("BasePart") then
                    offset = Shared.CurrentTarget.CFrame.LookVector * Shared.FarmDist
                else
                    offset = Vector3.new(0, 0, Shared.FarmDist)
                end
            else
                offset = Vector3.new(0, -Shared.FarmDist, 0)
            end
            local desiredPos = targetPos + offset
            hrp.CFrame = CFrame.new(desiredPos)
            lookAt(Shared.CurrentTarget, hrp)
            clickTarget(Shared.CurrentTarget.Parent)
        end
    end)
    repeat task.wait(1) until not Toggles.AutoTween.Value
    if Shared.TweenConnection then 
        Shared.TweenConnection:Disconnect()
        Shared.TweenConnection = nil 
    end
    Shared.CurrentTarget = nil
end
TB_Tabs.Autofarm.T1:AddToggle("AutoTween", {
    Text    = "Autofarm",
    Default = false,
})
local function Func_AutoBuy()
    while Toggles.AutoBuy.Value do
        local itemName = Options.BuyItem.Value
        if itemName and itemName ~= "" then
            local item = workspace.MapLayer2:FindFirstChild(itemName)
            if item then
                local pp = item:FindFirstChild("Prompt") and item.Prompt:FindFirstChild("ProximityPrompt")
                if pp then
                    FirePP(pp, true)
                    if not item:FindFirstChild("Purchase") then
                        local ConsumableBuy = Plr:WaitForChild("PlayerGui"):WaitForChild("ConsumableBuy", 1):WaitForChild("Frame")
                        if ConsumableBuy then
                            ConsumableBuy.Quantity.RemoteEvent:FireServer(Shared.ShopAmount)
                            task.wait(0.1)
                            ConsumableBuy.Accept.RemoteEvent:FireServer()
                            Shared.RevertAmount = Shared.ShopAmount
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local consumableList = {}
do
    local oneUseItem = Plr:FindFirstChild("OneUseItem")
    if oneUseItem then
        for _, v in ipairs(oneUseItem:GetChildren()) do
            if v:IsA("NumberValue") then
                table.insert(consumableList, v.Name)
            end
        end
    end
end
local function isBuffActive(name)
    local items = workspace:FindFirstChild("GlobalCooldowns")
        and workspace.GlobalCooldowns:FindFirstChild("ServerStatEff")
        and workspace.GlobalCooldowns.ServerStatEff:FindFirstChild("SurfaceGui")
        and workspace.GlobalCooldowns.ServerStatEff.SurfaceGui:FindFirstChild("Frame")
        and workspace.GlobalCooldowns.ServerStatEff.SurfaceGui.Frame:FindFirstChild("Contents")
        and workspace.GlobalCooldowns.ServerStatEff.SurfaceGui.Frame.Contents:FindFirstChild("Items")
    if not items then return false end
    local upperName = name:upper()
    for _, child in ipairs(items:GetChildren()) do
        local statName = child:FindFirstChild("Values") and child.Values:FindFirstChild("StatName")
        if statName and statName.Text == upperName then
            return true
        end
    end
    return false
end
local function Func_AutoConsumable()
    while Toggles.AutoConsumable.Value do
        local consumables = PGui
            and PGui:FindFirstChild("GuisNoReset")
            and PGui.GuisNoReset:FindFirstChild("InventoryFrame")
            and PGui.GuisNoReset.InventoryFrame:FindFirstChild("Consumables")
        if consumables then
            for name in pairs(AddMultiDropdown("ConsumableSelect")) do
                local oneUseItem = Plr:FindFirstChild("OneUseItem")
                local countVal = oneUseItem and oneUseItem:FindFirstChild(name)
                if countVal and countVal.Value > 0 and not isBuffActive(name) then
                    local itemFrame = consumables:FindFirstChild(name)
                    local remote = itemFrame
                        and itemFrame:FindFirstChild("Frame")
                        and itemFrame.Frame:FindFirstChild("EQUIP")
                        and itemFrame.Frame.EQUIP:FindFirstChild("RemoteEvent")
                    if remote then
                        pcall(function()
                            remote:FireServer(Plr)
                        end)
                    end
                end
            end
        end
        task.wait(1)
    end
end
local cotvItemsFolder = workspace:FindFirstChild("GASTERSHOP")
    and workspace.GASTERSHOP:FindFirstChild("COTVStand")
    and workspace.GASTERSHOP.COTVStand:FindFirstChild("Items")
local cotvItemList = {}
if cotvItemsFolder then
    for _, v in ipairs(cotvItemsFolder:GetChildren()) do
        table.insert(cotvItemList, v.Name)
    end
end
local function Func_AutoCOTV()
    while Toggles.AutoCOTV.Value do
        if cotvItemsFolder and not Shared.IsBusy then
            for name in pairs(AddMultiDropdown("COTVItems")) do
                local item = cotvItemsFolder:FindFirstChild(name)
                local pp = item and item:FindFirstChild("ProximityPrompt")
                if pp and pp.Enabled then
                    local hrp = getRoot()
                    local returnCF = hrp and hrp.CFrame
                    Shared.IsBusy = true
                    FirePP(pp, true)
                    task.wait(0.5)
                    hrp = getRoot()
                    if hrp and returnCF then
                        hrp.CFrame = returnCF
                    end
                    Shared.IsBusy = false
                end
            end
        end
        task.wait(1)
    end
    Shared.IsBusy = false
end
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
Toggles.Invincible:OnChanged(function(state)
    Thread("Invincible", Func_NoHit, state)
end)
Toggles.AutoWeapon:OnChanged(function(state)
    Thread("AutoWeapon", Func_AutoUseWeapon, state)
end)
Toggles.AutoAbility:OnChanged(function(state)
    Thread("AutoAbility", autoAbilityLoop, state)
end)
Toggles.AutoTween:OnChanged(function(state)
    Thread("AutoTween", Func_AutoTween, state)
end)
TB_Tabs.Autofarm.T3:AddToggle("AutoIsolatedSoul", {
    Text = "Auto Isolated Soul",
    Default = false,
})
Toggles.AutoIsolatedSoul:OnChanged(function(state)
    if not state then Shared.IsBusy = false end
    Thread("AutoIsolatedSoul", Func_AutoIsolatedSoul, state)
end)
AddMultiDropdown(TB_Tabs.Autofarm.T3, "ConsumableSelect", {
    Text = "Select Consumables",
    Values = consumableList,
    Default = {},
})
TB_Tabs.Autofarm.T3:AddToggle("AutoConsumable", {
    Text = "Auto Use Consumable",
    Default = false,
})
Toggles.AutoConsumable:OnChanged(function(state)
    Thread("AutoConsumable", Func_AutoConsumable, state)
end)
AddMultiDropdown(TB_Tabs.Autofarm.T3, "COTVItems", {
    Text = "COTV Items",
    Values = cotvItemList,
    Default = {},
})
TB_Tabs.Autofarm.T3:AddToggle("AutoCOTV", {
    Text = "Auto COTV",
    Default = false,
})
Toggles.AutoCOTV:OnChanged(function(state)
    if not state then Shared.IsBusy = false end
    Thread("AutoCOTV", Func_AutoCOTV, state)
end)
TB_Tabs.Autofarm.T3:AddButton({
    Text = "Teleport To Gaster",
    Func = function()
        local hrp = getRoot()
        local tpPart = workspace:FindFirstChild("GASTERSHOP")
            and workspace.GASTERSHOP:FindFirstChild("GasterPortalPOSITIONTP")
        if hrp and tpPart then
            hrp.CFrame = tpPart.CFrame
        end
    end,
})
TB_Tabs.Autofarm.T3:AddButton({
    Text = "Collect Chomiks",
    Func = function()
        local chomiks = workspace:FindFirstChild("UniqueSystems")
            and workspace.UniqueSystems:FindFirstChild("ChomikSystem")
            and workspace.UniqueSystems.ChomikSystem:FindFirstChild("Chomiks")
        if not chomiks then
            return
        end
        local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
        for _, chomik in ipairs(chomiks:GetChildren()) do
            local cd = chomik:FindFirstChildOfClass("ClickDetector")
            if cd then
                if hrp then
                    hrp.CFrame = chomik:IsA("BasePart") and chomik.CFrame or (chomik:FindFirstChildOfClass("BasePart") and chomik:FindFirstChildOfClass("BasePart").CFrame) or hrp.CFrame
                    task.wait(0.175)
                end
                pcall(fireclickdetector, cd)
            end
        end
    end,
})
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
    Thread("FPSBoost", ApplyFPSBoost, state)
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
SaveManager:SetFolder("Yuri/CSR")
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
end
