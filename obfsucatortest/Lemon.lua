if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
    return
end
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.GameId ~= 0
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
local function yuri()
end
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
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
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
local executorName = (identifyexecutor and identifyexecutor() or "Unknown"):lower()
local isXeno = string.find(executorName, "xeno") ~= nil
local LimitedExecutors = {"xeno"}
local isLimitedExecutor = false
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local isLimitedExecutor = executorDisplayName:lower():find("xeno") ~= nil
for _, name in ipairs(LimitedExecutors) do
    if string.find(executorName, name) then
        isLimitedExecutor = true
        break
    end
end
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
        yuri("Your executor does not support firesignal or getconnections.")
    end
end
local _FS = (_DR and _DR.FireServer)
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
            yuri("Error in ["..name.."]: "..tostring(err))
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
local function FirePP(target, teleport)
    if not fireproximityprompt then
        return
    end
    if not target or not target:IsA("ProximityPrompt") then
        return
    end
    local prevDist = target.MaxActivationDistance
    target.MaxActivationDistance = math.huge
    if teleport then
        local hrp = Char and Char:FindFirstChild("HumanoidRootPart")
        local part = target.Parent
        if hrp and part and part:IsA("BasePart") then
            hrp.CFrame = part.CFrame * CFrame.new(0, 0, -3)
            task.wait()
        end
    end
    fireproximityprompt(target)
    task.delay(0.5, function()
        if target and target.Parent then
            target.MaxActivationDistance = prevDist
        end
    end)
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
local CollectionService = Services.CollectionService
local function GetOwnedTycoon()
    for _, tycoon in ipairs(CollectionService:GetTagged("Tycoon")) do
        local owner = tycoon:FindFirstChild("Owner")
        if owner and owner.Value == Plr then
            return tycoon
        end
    end
    return nil
end
local function AutoCollectLoop()
    local cashDrops = workspace:FindFirstChild("CashDrops")
    if not cashDrops then
        yuri("[AutoCollect] workspace.CashDrops not found")
        return
    end
    while Toggles.AutoCollect.Value do
        for _, drop in ipairs(cashDrops:GetChildren()) do
            if not Toggles.AutoCollect.Value then break end
            if drop:IsA("BasePart") then
                FireTI(drop)
            end
        end
        task.wait()
    end
end
local function AutoClickLemonLoop()
    local cds = {}
    local cdsConns = {}
    local function rebuildCds()
        table.clear(cds)
        for _, tycoon in ipairs(CollectionService:GetTagged("Tycoon")) do
            local trees = tycoon:FindFirstChild("Constant") and tycoon.Constant:FindFirstChild("Trees")
            if not trees then continue end
            for _, tree in ipairs(trees:GetChildren()) do
                for _, child in ipairs(tree:GetChildren()) do
                    local clickPart = child:FindFirstChild("ClickPart")
                    if not clickPart then continue end
                    local cd = clickPart:FindFirstChildWhichIsA("ClickDetector")
                    if not cd then continue end
                    table.insert(cds, {cd = cd, part = clickPart})
                end
            end
        end
        for _, obj in ipairs(workspace:GetChildren()) do
            for _, child in ipairs(obj:GetChildren()) do
                local clickPart = child:FindFirstChild("ClickPart")
                if not clickPart then continue end
                local cd = clickPart:FindFirstChildWhichIsA("ClickDetector")
                if not cd then continue end
                table.insert(cds, {cd = cd, part = clickPart})
            end
        end
    end
    rebuildCds()
    table.insert(cdsConns, workspace.DescendantAdded:Connect(function(d)
        if d.Name == "ClickPart" or d:IsA("ClickDetector") then rebuildCds() end
    end))
    table.insert(cdsConns, workspace.DescendantRemoving:Connect(function(d)
        if d.Name == "ClickPart" or d:IsA("ClickDetector") then rebuildCds() end
    end))
    while Toggles.AutoClickLemon.Value do
        local hrp = Char and Char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, entry in ipairs(cds) do
                if not Toggles.AutoClickLemon.Value then break end
                hrp.CFrame = entry.part.CFrame
                task.wait()
                FireCD(entry.cd)
            end
        end
        task.wait(.175)
    end
    for _, conn in ipairs(cdsConns) do conn:Disconnect() end
end
local function AutoBuyLoop()
    local tycoon = GetOwnedTycoon()
    if not tycoon then
        yuri("[AutoBuy] Could not find owned tycoon — aborting loop")
        return
    end
    local remotes = {}
    local conns = {}
    local function rebuildRemotes()
        table.clear(remotes)
        for _, v in ipairs(tycoon:GetDescendants()) do
            if v.Name == "Purchase" and v:IsA("RemoteFunction") then
                table.insert(remotes, v)
            end
        end
    end
    rebuildRemotes()
    table.insert(conns, tycoon.DescendantAdded:Connect(function(v)
        if v.Name == "Purchase" and v:IsA("RemoteFunction") then rebuildRemotes() end
    end))
    table.insert(conns, tycoon.DescendantRemoving:Connect(function(v)
        if v.Name == "Purchase" and v:IsA("RemoteFunction") then rebuildRemotes() end
    end))
    while Toggles.AutoBuyAll.Value do
        for _, v in ipairs(remotes) do
            if not Toggles.AutoBuyAll.Value then break end
            local enabled = v.Parent:GetAttribute("Enabled")
            if enabled == false then
                continue
            end
            local purchased = v.Parent:GetAttribute("Purchased")
            if purchased == true then
                continue
            end
            yuri("[AutoBuy] Invoking: " .. v:GetFullName())
            local ok, result = pcall(function() return v:InvokeServer() end)
            if not ok then
                yuri("[AutoBuy] Error: " .. tostring(result))
            end
            task.wait()
        end
        task.wait()
    end
    for _, c in ipairs(conns) do c:Disconnect() end
end
local function AutoUpgradeLoop()
    local tycoon = GetOwnedTycoon()
    if not tycoon then
        yuri("[AutoUpgrade] Could not find owned tycoon — aborting loop")
        return
    end
    local remotes = {}
    local conns = {}
    local function rebuildRemotes()
        table.clear(remotes)
        for _, v in ipairs(tycoon:GetDescendants()) do
            if v.Name == "Upgrade" and v:IsA("RemoteFunction") then
                table.insert(remotes, v)
            end
        end
    end
    rebuildRemotes()
    table.insert(conns, tycoon.DescendantAdded:Connect(function(v)
        if v.Name == "Upgrade" and v:IsA("RemoteFunction") then rebuildRemotes() end
    end))
    table.insert(conns, tycoon.DescendantRemoving:Connect(function(v)
        if v.Name == "Upgrade" and v:IsA("RemoteFunction") then rebuildRemotes() end
    end))
    while Toggles.AutoUpgrade.Value do
        for _, v in ipairs(remotes) do
            if not Toggles.AutoUpgrade.Value then break end
            yuri("[AutoUpgrade] Invoking: " .. v:GetFullName())
            pcall(function() v:InvokeServer(tonumber(Options.UpgradeStackCount.Value) or 10) end)
            task.wait()
        end
        task.wait()
    end
    for _, c in ipairs(conns) do c:Disconnect() end
end
local Boot = RS.Core.Boot
local RebirthThreshold = {investors = 0, multiplier = nil} 
local function readInvestors()
    local tycoon = GetOwnedTycoon()
    if not tycoon then return 0 end
    local valFolder = tycoon:FindFirstChild("Values")
    if not valFolder then return 0 end
    local valCfg = valFolder:FindFirstChild("Values")
    if not valCfg then return 0 end
    local raw = valCfg:GetAttribute("Investors")
    if not raw or raw == "0" or raw == "" then return 0 end
    local n = tonumber(raw)
    return n or math.huge 
end
local H_ZERO = -math.huge
local H_ONE  = 0
local function hAdd(a, b)
    if a < b then a, b = b, a end
    if b == H_ZERO then return a end
    return a + math.log10(math.pow(10, b - a) + 1)
end
local function hMul(a, b) return a + b end
local function hDiv(a, b) return a - b end
local function hPow(a, e) return a * e end  
local function hExp10(e) return e end        
local function hToHuge(n)
    if n == 0 then return H_ZERO end
    return math.log10(n)
end
local function hLt(a, b) return a < b end
local RI_A = hToHuge(1.8e17)   
local RI_E = 0.44              
local function cashToNewInvestors(totalCash, totalInvestors)
    if totalInvestors == H_ZERO then
        return hPow(hDiv(totalCash, RI_A), RI_E)
    end
    local v1 = hDiv(hDiv(totalCash, RI_A), hPow(totalInvestors, 1 / RI_E))
    local THRESH = hExp10(-8)  
    if hLt(v1, THRESH) then
        return hMul(hMul(totalInvestors, hToHuge(RI_E)), v1)
    else
        local inner = math.pow(10, hAdd(H_ONE, v1)) 
        local powered = math.pow(inner, RI_E)
        local subtracted = powered - 1
        if subtracted <= 0 then return H_ZERO end
        return hMul(totalInvestors, math.log10(subtracted))
    end
end
local function readPotentialInvestors()
    local tycoon = GetOwnedTycoon()
    if not tycoon then return H_ZERO end
    local valFolder = tycoon:FindFirstChild("Values")
    if not valFolder then return H_ZERO end
    local valCfg = valFolder:FindFirstChild("Values")
    if not valCfg then return H_ZERO end
    local function readAttr(key)
        local raw = valCfg:GetAttribute(key)
        if not raw or raw == "0" or raw == "" then return H_ZERO end
        return tonumber(raw) or H_ZERO
    end
    local cash         = readAttr("Cash")
    local cashSpent    = readAttr("CashSpent")
    local investors    = readAttr("Investors")
    local invSpent     = readAttr("InvestorsSpent")
    local invSpentCap = hMul(investors, hExp10(1))  
    if hLt(invSpentCap, invSpent) then invSpent = invSpentCap end
    local totalCash = hAdd(cash, cashSpent)
    local totalInv  = hAdd(investors, invSpent)
    return cashToNewInvestors(totalCash, totalInv)
end
local function AutoRebirthLoop()
    local tycoon = GetOwnedTycoon()
    if not tycoon then
        yuri("[AutoRebirth] Could not find owned tycoon — aborting loop")
        return
    end
    local rebirthRemote = tycoon:WaitForChild("Remotes"):WaitForChild("Rebirth")
    while Toggles.AutoRebirth.Value do
        local potential = readPotentialInvestors()
        local threshold
        if RebirthThreshold.multiplier and RebirthThreshold.multiplier > 0 then
            local currentInvLog = readInvestors() 
            threshold = currentInvLog + math.log10(RebirthThreshold.multiplier)
        else
            threshold = RebirthThreshold.investors or 1
        end
        if potential >= threshold then
            local ok, result = pcall(function()
                return rebirthRemote:InvokeServer()
            end)
            if ok and result then
                yuri("[AutoRebirth] Rebirth successful: " .. tostring(result))
                Library:Notify("Rebirth!", 3)
            elseif ok then
                yuri("[AutoRebirth] Rebirth returned nil (server rejected)")
            else
                yuri("[AutoRebirth] Error: " .. tostring(result))
            end
        else
            yuri(string.format("[AutoRebirth] Waiting — potential %.0f < threshold %.0f", math.pow(10, potential), math.pow(10, threshold)))
        end
        task.wait(1)
    end
end
local function AutoEvolveLoop()
    local tycoon = GetOwnedTycoon()
    if not tycoon then
        yuri("[AutoEvolve] Could not find owned tycoon — aborting loop")
        return
    end
    local evolveRemote = tycoon:WaitForChild("Remotes"):WaitForChild("Evolve")
    while Toggles.AutoEvolve.Value do
        local limitVal = tonumber(Options.EvolveLimitInput.Value)
        if limitVal and limitVal > 0 then
            local valFolder = tycoon:FindFirstChild("Values")
            local valCfg = valFolder and valFolder:FindFirstChild("Values")
            local currentEvo = (valCfg and valCfg:GetAttribute("Evolution")) or 0
            if currentEvo >= limitVal then
                yuri("[AutoEvolve] Limit reached (" .. currentEvo .. "/" .. limitVal .. "), waiting")
                task.wait(1)
                continue
            end
        end
        local ok, result = pcall(function()
            return evolveRemote:InvokeServer()
        end)
        if ok and result then
            yuri("[AutoEvolve] Evolve successful: " .. tostring(result))
            Library:Notify("Evolved!", 3)
        elseif ok then
            yuri("[AutoEvolve] Evolve returned nil (not ready yet)")
        else
            yuri("[AutoEvolve] Error: " .. tostring(result))
        end
        task.wait(1)
    end
end
local function AutoAscendLoop()
    local tycoon = GetOwnedTycoon()
    if not tycoon then
        yuri("[AutoAscend] Could not find owned tycoon — aborting loop")
        return
    end
    local ascendRemote = tycoon:WaitForChild("Remotes"):WaitForChild("Ascend")
    while Toggles.AutoAscend.Value do
        local ok, result = pcall(function()
            return ascendRemote:InvokeServer()
        end)
        if ok and result then
            yuri("[AutoAscend] Ascend successful: " .. tostring(result))
            Library:Notify("Ascended!", 3)
        elseif ok then
            yuri("[AutoAscend] Ascend returned nil (not ready yet)")
        else
            yuri("[AutoAscend] Error: " .. tostring(result))
        end
        task.wait(1)
    end
end
local GameConfig = require(RS.Config)
local PowersList = {}
for key, data in pairs(GameConfig.Powers) do
    table.insert(PowersList, { key = key, title = data.Display.Title, order = data.Display.Order })
end
table.sort(PowersList, function(a, b) return a.order < b.order end)
local PowerTitles = {}
for _, p in ipairs(PowersList) do
    table.insert(PowerTitles, p.title)
end
local PowerTitleToKey = {}
for _, p in ipairs(PowersList) do
    PowerTitleToKey[p.title] = p.key
end
local SelectedPowers = {}
local function AutoBuyPowersLoop()
    local tycoon = GetOwnedTycoon()
    if not tycoon then
        yuri("[AutoBuyPowers] Could not find owned tycoon — aborting loop")
        return
    end
    local upgradeRemote = tycoon:WaitForChild("Remotes"):WaitForChild("UpgradePowerLevel")
    local powersFolder = tycoon:WaitForChild("Values"):WaitForChild("Powers")
    while Toggles.AutoBuyPowers.Value do
        for _, powerKey in ipairs(SelectedPowers) do
            if not Toggles.AutoBuyPowers.Value then break end
            local powerData = GameConfig.Powers[powerKey]
            local title = powerData.Display.Title
            local maxLevel = #powerData.Prices
            local currentLevel = powersFolder:GetAttribute(powerKey) or 0
            if currentLevel >= maxLevel then
                yuri("[AutoBuyPowers] " .. title .. " already max (" .. currentLevel .. "/" .. maxLevel .. ")")
                continue
            end
            yuri("[AutoBuyPowers] Upgrading " .. title .. " (level " .. currentLevel .. " -> " .. (currentLevel + 1) .. ")")
            local ok, result = pcall(function() return upgradeRemote:InvokeServer(powerKey) end)
            if ok then
                yuri("[AutoBuyPowers] " .. title .. " result: " .. tostring(result))
            else
                yuri("[AutoBuyPowers] " .. title .. " error: " .. tostring(result))
            end
            task.wait(0.5)
        end
        task.wait(2)
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
    Main   = Window:AddTab("Main"),
    Player = Window:AddTab("Player"),
    Config = Window:AddTab("Config"),
}
local PlayerGroup = Tabs.Player:AddRightGroupbox("Player")
local ServerGroup = Tabs.Player:AddLeftGroupbox("Server")
local AB_Left  = Tabs.Main:AddLeftGroupbox("Auto Buy")
local AB_Right = Tabs.Main:AddRightGroupbox("Farm")
local Config = Tabs.Main:AddRightGroupbox("Config")
AB_Left:AddToggle("AutoBuyAll", {
    Text    = "Auto Buy All",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.All", AutoBuyLoop, state)
    end,
})
AB_Left:AddToggle("AutoUpgrade", {
    Text    = "Auto Upgrade",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.Upgrade", AutoUpgradeLoop, state)
    end,
})
AB_Left:AddToggle("AutoRebirth", {
    Text    = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.Rebirth", AutoRebirthLoop, state)
    end,
})
Config:AddInput("UpgradeStackCount", {
    Text     = "Upgrade Stack",
    Default  = "10",
    Numeric  = true,
    Finished = true,
})
Config:AddInput("RebirthThresholdInput", {
    Text        = "Rebirth when Investors >=",
    Default     = "1",
    Numeric     = true,
    Callback    = function(Value)
        local n = tonumber(Value)
        if n and n > 0 then
            RebirthThreshold.investors = math.log10(n) 
        end
    end,
})
Config:AddInput("RebirthMultiplierInput", {
    Text = "Rebirth at Current Investors × X",
    Default     = "",
    Numeric     = true,
    Callback    = function(Value)
        local n = tonumber(Value)
        if n and n >= 1 then
            RebirthThreshold.multiplier = n
            yuri("[AutoRebirth] Multiplier mode set: x" .. n)
        else
            RebirthThreshold.multiplier = nil
            yuri("[AutoRebirth] Multiplier mode cleared, using absolute threshold")
        end
    end,
})
Config:AddInput("EvolveLimitInput", {
    Text    = "Stop Evolve at Evolution",
    Default = "",
    Numeric = true,
})
AB_Left:AddDivider()
AB_Left:AddToggle("AutoEvolve", {
    Text    = "Auto Evolve",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.Evolve", AutoEvolveLoop, state)
    end,
})
AB_Left:AddDivider()
AB_Left:AddToggle("AutoAscend", {
    Text    = "Auto Ascend",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.Ascend", AutoAscendLoop, state)
    end,
})
AB_Left:AddDivider()
AB_Left:AddDropdown("PowersToBuy", {
    Text   = "Powers",
    Values = PowerTitles,
    Default = {},
    Multi  = true,
})
Options.PowersToBuy:OnChanged(function()
    table.clear(SelectedPowers)
    for name, active in pairs(Options.PowersToBuy.Value) do
        if active then table.insert(SelectedPowers, PowerTitleToKey[name]) end
    end
end)
AB_Left:AddToggle("AutoBuyPowers", {
    Text    = "Auto Buy Powers",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.Powers", AutoBuyPowersLoop, state)
    end,
})
AB_Right:AddToggle("AutoCollect", {
    Text    = "Auto Collect Cash",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.Collect", AutoCollectLoop, state)
    end,
})
AB_Right:AddToggle("AutoClickLemon", {
    Text    = "Auto Click Lemon",
    Default = false,
    Callback = function(state)
        Thread("AutoBuy.ClickLemon", AutoClickLemonLoop, state)
    end,
})
AddSliderToggle({ Group = PlayerGroup, Id = "WS", Text = "WalkSpeed", Default = 16, Min = 16, Max = 250 })
local TPW_T, TPW_S = AddSliderToggle({ Group = PlayerGroup, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
AddSliderToggle({ Group = PlayerGroup, Id = "JP", Text = "JumpPower", Default = 50, Min = 0, Max = 500 })
AddSliderToggle({ Group = PlayerGroup, Id = "HH", Text = "HipHeight", Default = 2, Min = 0, Max = 10, Rounding = 1 })
PlayerGroup:AddToggle("Noclip2", { Text = "Noclip" })
PlayerGroup:AddToggle("AntiKnockback", { Text = "Anti Knockback", Default = false })
AddSliderToggle({ Group = PlayerGroup, Id = "Grav", Text = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 1 })
AddSliderToggle({ Group = PlayerGroup, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = PlayerGroup, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
AddSliderToggle({ Group = PlayerGroup, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
PlayerGroup:AddToggle("Fullbright2", { Text = "Fullbright" })
PlayerGroup:AddToggle("NoFog2", { Text = "No Fog" })
PlayerGroup:AddToggle("InstantPP2", { Text = "Instant Prompt" })
PlayerGroup:AddToggle("SkipCutscenes", { Text = "Skip Cutscenes", Default = false })
ServerGroup:AddToggle("AntiAFK2", { Text = "Anti AFK", Default = true })
ServerGroup:AddToggle("AntiKick2", { Text = "Anti Kick (Client)" })
ServerGroup:AddToggle("AutoReconnect2", { Text = "Auto Reconnect" })
ServerGroup:AddToggle("NoGameplayPaused2", { Text = "No Gameplay Paused" })
ServerGroup:AddButton({ Text = "Serverhop", Func = function()
    local ok, res = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)
    if not ok or not res or not res.data then
        return
    end
    local currentId = game.JobId
    for _, server in ipairs(res.data) do
        if server.id ~= currentId and server.playing < server.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
            return
        end
    end
end })
ServerGroup:AddButton({ Text = "Rejoin", Func = function()
    TeleportService:Teleport(game.PlaceId, Plr)
end })
ServerGroup:AddToggle("AutoServerhop2", { Text = "Auto Serverhop" })
ServerGroup:AddSlider("AutoHopMins2", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
RunService.Stepped:Connect(function()
    local hum = Plr.Character and Plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if Toggles.WS.Value then hum.WalkSpeed = Options.WSValue.Value end
        if Toggles.JP.Value then hum.JumpPower = Options.JPValue.Value; hum.UseJumpPower = true end
        if Toggles.HH.Value then hum.HipHeight = Options.HHValue.Value end
    end
    Workspace.Gravity = Toggles.Grav.Value and Options.GravValue.Value or 196
    if Toggles.FOV.Value then Workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value end
    if Toggles.Zoom.Value then Plr.CameraMaxZoomDistance = Options.ZoomValue.Value end
end)
local function FuncTPW()
    while Toggles.TPW.Value do
        local delta = RunService.Heartbeat:Wait()
        local char = Plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and hum and hum.Health > 0 and hum.MoveDirection.Magnitude > 0 then
            char:TranslateBy(hum.MoveDirection * Options.TPWValue.Value * delta * 10)
        end
    end
end
Toggles.TPW:OnChanged(function(v)
    if v then task.spawn(FuncTPW) end
end)
Toggles.Noclip2:OnChanged(function(v)
    if not v then return end
    task.spawn(function()
        local parts = {}
        local partConn
        local charConn
        local function rebuildParts(char)
            table.clear(parts)
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then table.insert(parts, p) end
            end
        end
        local function onCharAdded(char)
            if partConn then partConn:Disconnect() end
            rebuildParts(char)
            partConn = char.DescendantAdded:Connect(function(p)
                if p:IsA("BasePart") then table.insert(parts, p) end
            end)
        end
        if Plr.Character then onCharAdded(Plr.Character) end
        charConn = Plr.CharacterAdded:Connect(onCharAdded)
        while Toggles.Noclip2.Value do
            RunService.Stepped:Wait()
            for _, part in ipairs(parts) do
                if part.CanCollide then part.CanCollide = false end
            end
        end
        charConn:Disconnect()
        if partConn then partConn:Disconnect() end
    end)
end)
local _knockbackConns = {}
local _cutsceneConns = {}
local function ApplyAntiKB(char)
    if not char then return end
    local root = char:WaitForChild("HumanoidRootPart", 10)
    if root then
        local conn = root.ChildAdded:Connect(function(child)
            if not Toggles.AntiKnockback.Value then return end
            if child:IsA("BodyVelocity") and child.MaxForce == Vector3.new(40000, 40000, 40000) then
                child:Destroy()
            end
        end)
        table.insert(_knockbackConns, conn)
    end
end
Toggles.AntiKnockback:OnChanged(function(state)
    for _, c in ipairs(_knockbackConns) do if c then c:Disconnect() end end
    table.clear(_knockbackConns)
    if not state then return end
    if Plr.Character then ApplyAntiKB(Plr.Character) end
    local charConn = Plr.CharacterAdded:Connect(function(c) ApplyAntiKB(c) end)
    table.insert(_knockbackConns, charConn)
end)
local function SkipIntroLetter()
    local CS = Services.CollectionService
    local function trySkip(gui)
        task.spawn(function()
            task.wait(1.5)
            if not Toggles.SkipCutscenes.Value then return end
            local clickArea = gui:FindFirstChild("ClickArea", true)
            if not clickArea then return end
            fire_event(clickArea.MouseEnter)
            task.wait(0.05)
            fire_event(clickArea.MouseButton1Up)
        end)
    end
    for _, gui in ipairs(CS:GetTagged("UI.IntroLetter")) do
        trySkip(gui)
    end
    local conn = CS:GetInstanceAddedSignal("UI.IntroLetter"):Connect(trySkip)
    table.insert(_cutsceneConns, conn)
end
Toggles.SkipCutscenes:OnChanged(function(state)
    for _, c in ipairs(_cutsceneConns) do c:Disconnect() end
    table.clear(_cutsceneConns)
    if not state then return end
    local ok, PS = pcall(require, RS.Core.PlayerSettings)
    local ok2, LPMod = pcall(require, RS.Core.LocalPlayer)
    if ok and ok2 then
        local psComp = LPMod.get():GetComponent(PS)
        local flags = {"InvestorsRevealed", "EvolutionRevealed", "SpaceRevealed", "StaircaseRevealed", "StaircaseUnlocked"}
        for _, flag in ipairs(flags) do
            pcall(function() psComp:SetLocal(flag, true) end)
        end
        yuri("[SkipCutscenes] PlayerSettings cinematic flags set locally")
    else
        yuri("[SkipCutscenes] Could not require PlayerSettings or LocalPlayer: " .. tostring(not ok and PS or LPMod))
    end
    SkipIntroLetter()
end)
task.spawn(function()
    while true do
        task.wait(0.5)
        if Toggles.Fullbright2.Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime.Value then
            Lighting.ClockTime = Options.OverrideTimeValue.Value
        end
        if Toggles.NoFog2.Value then Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantPP2 and Toggles.InstantPP2.Value then
        prompt.HoldDuration = 0
    end
end)
local function DisableIdled2()
    pcall(function()
        local cons = getconnections or get_signal_cons
        if cons then
            for _, v in ipairs(cons(Plr.Idled)) do
                if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end
            end
        end
    end)
end
task.spawn(function()
    DisableIdled2()
    while true do
        task.wait(60)
        if Toggles.AntiAFK2 and Toggles.AntiAFK2.Value then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                task.wait(0.2)
                VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not Toggles.AntiKick2.Value then return oldNamecall(self, ...) end
        if getnamecallmethod() == "Kick" and self == Plr then
            return
        end
        return oldNamecall(self, ...)
    end)
end)
local function Func_AutoReconnect2()
    if _G._autoReconnectConn then _G._autoReconnectConn:Disconnect() end
    _G._autoReconnectConn = game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        if not Toggles.AutoReconnect2.Value then return end
        task.delay(2, function()
            pcall(function()
                local overlay = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                if overlay then
                    local errPrompt = overlay.promptOverlay:FindFirstChild("ErrorPrompt")
                    if errPrompt and errPrompt.Visible then
                        task.wait(5)
                        TeleportService:Teleport(game.PlaceId, Plr)
                    end
                end
            end)
        end)
    end)
end
Toggles.AutoReconnect2:OnChanged(function(state)
    if state then Func_AutoReconnect2() end
end)
Toggles.NoGameplayPaused2:OnChanged(function(state)
    if not state then return end
    task.spawn(function()
        while Toggles.NoGameplayPaused2.Value do
            pcall(function()
                local pauseGui = game:GetService("CoreGui").RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
                if pauseGui then pauseGui:Destroy() end
            end)
            task.wait(1)
        end
    end)
end)
task.spawn(function()
    while true do
        task.wait(60)
        if Toggles.AutoServerhop2 and Toggles.AutoServerhop2.Value then
            local mins = Options.AutoHopMins2.Value
            if mins > 0 then
                task.wait((mins - 1) * 60)
            end
            if Toggles.AutoServerhop2.Value then
                local ok, res = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(
                        "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                    ))
                end)
                if ok and res and res.data then
                    local currentId = game.JobId
                    for _, server in ipairs(res.data) do
                        if server.id ~= currentId and server.playing < server.maxPlayers then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr)
                            return
                        end
                    end
                end
            end
        end
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
SaveManager:SetFolder("Yuri/Lemon")
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
end
