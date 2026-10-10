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
local VIM = game:GetService("VirtualInputManager")
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
local WDOReplicatedStorage = game:GetService("ReplicatedStorage"):WaitForChild("WDOReplicatedStorage")
local damageEnemy = WDOReplicatedStorage.Events.damageEnemy
local Ability = WDOReplicatedStorage.Events.Ability
local mapVote = WDOReplicatedStorage.Events.mapVote
local SetAFK = WDOReplicatedStorage.Events:FindFirstChild("setAFK")
local ClientApp = WDOReplicatedStorage.Events:FindFirstChild("clientApplication")
local SetTimer = WDOReplicatedStorage.Events:FindFirstChild("setTimer")
local MapInfo = require(WDOReplicatedStorage.MapInfo)
local Debris = game:GetService("Debris")
local WeaponInfoData, EnemyInfoData
pcall(function() WeaponInfoData = require(WDOReplicatedStorage.Weapons.WeaponInfo) end)
pcall(function() EnemyInfoData = require(WDOReplicatedStorage.Enemies.EnemyInfo) end)
local function getWeaponInfo() return WeaponInfoData end
local function getEnemyInfo() return EnemyInfoData end
local ParryEvent = WDOReplicatedStorage.Events:FindFirstChild("Parry")
local SuccessfulParryEvent = WDOReplicatedStorage.Events:FindFirstChild("successfulParry")
local DashEvent = WDOReplicatedStorage.Events:WaitForChild("Dash")
local EnemyHitboxEvent = WDOReplicatedStorage.Events:WaitForChild("enemyHitbox")
local ClientEffectEvent = WDOReplicatedStorage.Events:WaitForChild("ClientEffect")
local autoParry = false
local autoParrySuccess = 100
local autoDodge = false
local lastDashFire = 0
local 5 = 20
local parryMode = "Blalant"
local isVelocity = string.find(executorName, "velocity") ~= nil
local warnedVelocityParry = false
local parryAnims = setmetatable({}, { __mode = "k" })
local lastParryFire = 0
local parrySuccessCount = 0
local autoExecute = false
local executingPrompts = setmetatable({}, { __mode = "k" })
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
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
    InvincibleToggle = nil,
}
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
local latestCode = nil
RS.WDOReplicatedStorage.Events.applyClientStuff.OnClientEvent:Connect(function(code)
    latestCode = code
end)
local function GetClientCode()
    return latestCode
end
local function canParryNow()
    local char = Plr.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if char:GetAttribute("ParryCooldown") == true then return false end
    if char:GetAttribute("NoParry") == true then return false end
    if char:GetAttribute("Binded") == true then return false end
    if char:GetAttribute("Ragdolled") == true then return false end
    if char:GetAttribute("Weapon") == nil then return false end
    local cooldowns = char:FindFirstChild("Cooldowns")
    local parryNode = cooldowns and cooldowns:FindFirstChild("Parry")
    if parryNode then
        local u = parryNode:GetAttribute("Uses")
        if type(u) == "number" and u <= 0 then return false end
    end
    return true
end
local function GetAttack(enemy, attackName)
    if not (enemy and attackName) then return nil end
    local enemyInfo = getEnemyInfo()
    if not enemyInfo then return nil end
    local ok, eType = pcall(function() return enemy:GetAttribute("Type") end)
    if not ok then return nil end
    local eData = eType and enemyInfo[eType]
    return eData and eData.AttackInfo and eData.AttackInfo[attackName]
end
local attemptParry
local function quickDash()
    if tick() - lastDashFire < 0.3 then return end
    local char = Plr.Character
    if not char then return end
    local cd = char:FindFirstChild("Cooldowns")
    local dashNode = cd and cd:FindFirstChild("Dash")
    local dashUses = dashNode and dashNode:GetAttribute("Uses")
    if dashNode and dashUses ~= nil and dashUses <= 0 then return end
    if char:GetAttribute("DashCooldown") == true then return end
    lastDashFire = tick()
    local dashType = char:GetAttribute("DashType") or "Default"
    pcall(function() DashEvent:FireServer(char, dashType) end)
end
local function DoDodge(enemy, attackName)
    local enemyInfo = getEnemyInfo()
    local attackData = nil
    if enemyInfo and enemy then
        local ok, eType = pcall(function() return enemy:GetAttribute("Type") end)
        if ok and eType and enemyInfo[eType] and enemyInfo[eType].AttackInfo then
            attackData = enemyInfo[eType].AttackInfo[attackName]
        end
    end
    local avoid = attackData and attackData.AvoidStatus
    if not (autoDodge and avoid and avoid.Dodge == true and avoid.Parry == false) then return end
    pcall(function()
        local char = Plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cdContainer = char:FindFirstChild("Cooldowns")
        local dashNode = cdContainer and cdContainer:FindFirstChild("Dash")
        local dashUses = dashNode and dashNode:GetAttribute("Uses")
        local canDash = (not dashNode or dashUses == nil or dashUses > 0)
            and char:GetAttribute("DashCooldown") ~= true
        if not canDash then return end
        local dashType = char:GetAttribute("DashType") or "Default"
        pcall(function() DashEvent:FireServer(char, dashType) end)
        if not hrp then return end
        local excludeList = { char }
        for _, name in ipairs({"AlivePlayers","SpawnedEnemies","ClientStuff","NPCS","Projectiles"}) do
            local f = workspace:FindFirstChild(name)
            if f then table.insert(excludeList, f) end
        end
        local attackVec = hrp.CFrame.LookVector
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            attackVec = (hrp.Position - enemy.HumanoidRootPart.Position).Unit
        end
        attackVec = Vector3.new(attackVec.X, 0, attackVec.Z).Unit
        local attackRight = Vector3.new(-attackVec.Z, 0, attackVec.X)
        local attackLeft  = Vector3.new( attackVec.Z, 0, -attackVec.X)
        local directions = {
            { vec = attackVec,   bonus = 60 },
            { vec = attackRight, bonus = 40 },
            { vec = attackLeft,  bonus = 40 },
            { vec = -attackVec,  bonus = -10 },
        }
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = excludeList
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.RespectCanCollide = true
        local bestScore, safeDir = -1, nil
        for _, dir in ipairs(directions) do
            local wallRes  = workspace:Raycast(hrp.Position, dir.vec * 30, rayParams)
            local safeDist = wallRes and (wallRes.Position - hrp.Position).Magnitude or 30
            if safeDist > 10 then
                local floorRes = workspace:Raycast(hrp.Position + dir.vec * safeDist, Vector3.new(0,-15,0), rayParams)
                if floorRes then
                    local score = safeDist + dir.bonus
                    if score > bestScore then bestScore = score; safeDir = dir.vec end
                end
            end
        end
        local hum = char:FindFirstChild("Humanoid")
        if safeDir and hum and hrp then
            hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + safeDir)
            hum:Move(safeDir, false)
            task.spawn(function()
                local speed = math.min(50 * (hum.WalkSpeed / 16), 100)
                local body = char:FindFirstChild("Torso") or hrp
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(100000, 200, 100000)
                bv.Velocity  = safeDir * speed
                bv.Parent = body
                task.wait(0.3)
                bv:Destroy()
            end)
        end
    end)
end
local function FireExecute(prompt)
    if not prompt:IsA("ProximityPrompt") then return end
    if executingPrompts[prompt] then return end
    executingPrompts[prompt] = true
    task.spawn(function()
        local enemy = prompt:FindFirstAncestorWhichIsA("Model")
        for _ = 1, 12 do
            if not prompt.Parent then break end
            if enemy and not enemy.Parent then break end
            FirePP(prompt, true)
            task.wait(0.12)
        end
        executingPrompts[prompt] = nil
    end)
end
local function Func_KillAura()    
    local lastAbility = tick()
    repeat task.wait(.5) Ability:FireServer(1) until GetClientCode() ~= nil
    if not GetClientCode() then
        notyuri("[AutoDamage] initial code seed timed out")
    end
    local hitCount = {}
    local lastHP = {}
    while Toggles.KillAura.Value do
        local char = GetCharacter()
        if char then
            local enemies = workspace:FindFirstChild("SpawnedEnemies")
            if enemies then
                local code = GetClientCode()
                if not code and (tick() - lastAbility) >= 3 then
                    notyuri("[AutoDamage] code stale, re-seeding Ability")
                    Ability:FireServer(1)
                    lastAbility = tick()
                    repeat task.wait() until GetClientCode() ~= nil or not Toggles.KillAura.Value
                    code = GetClientCode()
                end
                if code then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        if not Toggles.KillAura.Value then break end
                        if enemy:FindFirstChild("Humanoid") and enemy:GetAttribute("Enemy") then
                            local id = enemy
                            local hp = enemy.Humanoid.Health
                            if lastHP[id] ~= hp then
                                lastHP[id] = hp
                                hitCount[id] = 0
                            end
                            if enemy:GetAttribute("Invulnerable") == true or (enemy:GetAttribute("IFrames") or 0) > 0 then
                                continue
                            end
                            pcall(function()
                                damageEnemy:FireServer(1, enemy, code, nil, nil, false)
                            end)
                            hitCount[id] = (hitCount[id] or 0) + 1
                            if (hitCount[id] or 0) >= 5 and (tick() - lastAbility) >= 3 then
                                notyuri("[AutoDamage] code stale, re-seeding Ability")
                                Ability:FireServer(1)
                                lastAbility = tick()
                                hitCount[id] = 0
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
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
local function FireCD(target)
    if not fireclickdetector then
        return
    end
    if not target or not target:IsA("ClickDetector") then
        return
    end
    fireclickdetector(target)
end
FirePP = function(target, teleport)
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
    },
}
local TB_Tabs = {
    Autofarm = {
        T1 = TB.Main.Left.Autofarm:AddTab("Autofarm"),
    },
}
local MapNames = {}
for name in MapInfo do
    table.insert(MapNames, name)
end
table.sort(MapNames)
TB_Tabs.Autofarm.T1:AddDropdown("MapVoteSelect", {
    Text = "Select Map",
    Values = MapNames,
    Default = MapNames[1],
    AllowNull = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteMap", { Text = "Auto Vote Map" })
TB_Tabs.Autofarm.T1:AddToggle("KillAura", { Text = "Kill Aura" })
TB_Tabs.Autofarm.T1:AddToggle("InvincibleToggle", { Text = "Invincible" })
TB_Tabs.Autofarm.T1:AddToggle("AutoParry", { Text = "Auto Parry", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoExecute", { Text = "Auto Execute", Default = false })
local function Func_AutoVoteMap()
    while Toggles.AutoVoteMap.Value do
        local map = Options.MapVoteSelect.Value
        if map then
            mapVote:FireServer(map)
        end
        task.wait(1)
    end
end
Toggles.AutoVoteMap:OnChanged(function(state)
    Thread("AutoVoteMap", Func_AutoVoteMap, state)
end)
Toggles.KillAura:OnChanged(function(state)
    Thread("KillAura", Func_KillAura, state)
end)
local enemyDamageRemote = WDOReplicatedStorage.Events.enemyDamage
Toggles.InvincibleToggle:OnChanged(function(state)
    if state then
        if not hookmetamethod then
            return
        end
        if Connections.InvincibleToggle then return end
        Connections.InvincibleToggle = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if (getnamecallmethod() == "FireServer") and self == enemyDamageRemote then
                return
            end
            return Connections.InvincibleToggle(self, ...)
        end))
    else
        if Connections.InvincibleToggle then
            hookmetamethod(game, "__namecall", Connections.InvincibleToggle)
            Connections.InvincibleToggle = nil
        end
    end
end)
local parryOldNamecall
if type(hookmetamethod) == "function" and type(newcclosure) == "function" and type(getnamecallmethod) == "function" then
    parryOldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() then
            if method == "FireServer" then
                if self.Name == "enemyDamage" or self.Name == "trapDamage" then
                    if autoParry or autoDodge then
                        local atk = GetAttack(select(1, ...), select(2, ...))
                        local avoid = atk and atk.AvoidStatus
                        local unavoidable = atk and atk.Unavoidable == true
                        if not unavoidable then
                            local parryable = not (avoid and avoid.Parry == false)
                            if autoParry and parryable then
                                pcall(attemptParry)
                            elseif autoDodge and avoid and avoid.Parry == false and avoid.Dodge == true then
                                pcall(quickDash)
                            end
                        end
                    end
                end
            end
        end
        return parryOldNamecall(self, ...)
    end))
end
function attemptParry()
    if math.random(1, 100) > autoParrySuccess then return false end
    if tick() - lastParryFire < 0.25 then return false end
    if not canParryNow() then return false end
    lastParryFire = tick()
    pcall(function()
        local char = Plr.Character
        local weapon = char and char:GetAttribute("Weapon")
        local WInfo = getWeaponInfo()
        local startupName = weapon and WInfo and WInfo[weapon] and WInfo[weapon].Startup
        if char and startupName then
            local hum = char:FindFirstChild("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            local assets = WDOReplicatedStorage:FindFirstChild("Assets")
            local animFolder = assets and assets:FindFirstChild("Animations")
            local animInst = animFolder and animFolder:FindFirstChild(startupName)
            if animator and animInst then
                parryAnims[char] = parryAnims[char] or {}
                if not parryAnims[char][weapon] then
                    parryAnims[char][weapon] = animator:LoadAnimation(animInst)
                end
                pcall(function() parryAnims[char][weapon]:Play() end)
            end
        end
        ParryEvent:FireServer(Plr)
    end)
    return true
end
if SuccessfulParryEvent then
    SuccessfulParryEvent.OnClientEvent:Connect(function(plr)
        if plr == nil or plr == Plr then
            parrySuccessCount = parrySuccessCount + 1
        end
    end)
end
Toggles.AutoParry:OnChanged(function(state)
    autoParry = state
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoDodge", { Text = "Auto Dodge", Default = false })
Toggles.AutoDodge:OnChanged(function(state)
    autoDodge = state
end)
EnemyHitboxEvent.OnClientEvent:Connect(function(enemy, size, cframe, attackName)
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if typeof(cframe) == "CFrame" and typeof(size) == "Vector3" then
        local expandedSize = size + Vector3.new(5, 5, 5)
        local params = OverlapParams.new()
        params.FilterDescendantsInstances = { char }
        params.FilterType = Enum.RaycastFilterType.Include
        local bounds = workspace:GetPartBoundsInBox(cframe, expandedSize, params)
        if #bounds > 0 then
            task.spawn(DoDodge, enemy, attackName)
        end
    end
end)
ClientEffectEvent.OnClientEvent:Connect(function(effectName, enemy, attackName)
    if effectName == "DirectEnemyAttack" then
        task.spawn(DoDodge, enemy, attackName)
    end
end)
local function Func_AutoExecute()
    while Toggles.AutoExecute.Value do
        pcall(function()
            local container = workspace:FindFirstChild("SpawnedEnemies")
            if container then
                for _, enemy in ipairs(container:GetChildren()) do
                    for _, prompt in ipairs(enemy:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and
                            (prompt.ActionText == "Execute") then
                            FireExecute(prompt)
                        end
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end
Toggles.AutoExecute:OnChanged(function(state)
    autoExecute = state
    Thread("AutoExecute", Func_AutoExecute, state)
end)
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
        for _, v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"] then v["Disable"](v)
            elseif v["Disconnect"] then v["Disconnect"](v) end
        end
    end
    task.spawn(function()
        while Toggles.AntiAFK.Value do
            pcall(function()
                if SetAFK then SetAFK:FireServer(false) end
                if ClientApp then ClientApp:FireServer() end
                if SetTimer then SetTimer:FireServer() end
                if not GC then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
            task.wait(math.random(3, 6))
        end
    end)
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
SaveManager:SetFolder("Yuri/WDO")
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