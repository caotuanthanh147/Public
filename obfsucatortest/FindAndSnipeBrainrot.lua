if getgenv().ayasemiyatongekissazumirisa then
    warn("watch more yuri")
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
local yuri = {
    "https://mangadex.org/covers/5311ac6f-3651-43a8-bb9c-b40dea7ab72d/062845cb-4498-4499-a23a-89ecac694ea9.jpg",
    "https://mangadex.org/covers/df01a222-faeb-4952-84ac-d6040815e2dd/ec777628-a5d7-4d5f-92f5-11a8a746427e.jpg",
    "https://cdn.donmai.us/original/dc/0e/__hayafuji_kasane_and_aoyama_meguru_keiyaku_shimai_drawn_by_hijiki_hijikini__dc0e2235f2ca00dcb06aa3db2999bd1f.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/233/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/328/thumbnail.jpg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1339/thumbnail.jpeg",
    "https://db.Yurigarden.com/storage/v1/object/public/Yuri-garden-store/comics/1268/thumbnail.jpeg",
    "https://dynasty-scans.com/system/releases/000/040/979/001.webp",
    "https://dynasty-scans.com/system/images_images/000/031/460/full/GErfQqXagAA4mk7-orig.webp",
}
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
        warn("Your executor does not support firesignal or getconnections.")
    end
end
local _FS = (_DR and _DR.FireServer)
local Remote     = RS:WaitForChild("Remote")
local DecoRE     = Remote:WaitForChild("Decoration")
local DecoFRE    = Remote:WaitForChild("DecorationF")
local ShootEvent = Remote:WaitForChild("ShootEvent")
local ReloadEvent= Remote:WaitForChild("ReloadEvent")
local AmmoSync   = Remote:WaitForChild("AmmoSyncEvent")
local AttackRE   = Remote:WaitForChild("Attack")
local BackpackRE = Remote:WaitForChild("Backpack")
local FloorRE    = Remote:WaitForChild("Floor")
local RebirthRE  = Remote:WaitForChild("Rebirth")
local PlayerRE   = Remote:WaitForChild("Player")
local PlayerFRE  = Remote:WaitForChild("PlayerF")
local SellFRE    = Remote:WaitForChild("SellF")
local Remotes = {}
local Modules = {}
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
local SLOT_FOLDER = "\232\132\145\232\133\144\230\148\190\231\189\174"
local function getNormalizeQuality()
    local ok, DQA = pcall(function()
        return require(RS:WaitForChild("ToolScripts"):WaitForChild("DecorationQualityAppearance"))
    end)
    return ok and DQA and DQA.NormalizeQuality or function(q) return q end
end
local NormalizeQuality = getNormalizeQuality()
local curAmmo     = 999
local magSize     = 999
local isReloading = false
AmmoSync.OnClientEvent:Connect(function(data)
    if type(data) ~= "table" then return end
    curAmmo     = math.max(0, math.floor((tonumber(data.currentAmmo)  or curAmmo)  + 0.5))
    magSize     = math.max(1, math.floor((tonumber(data.magazineSize) or magSize)  + 0.5))
    isReloading = data.isReloading == true
end)
local function getBrainrots()
    local out = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:GetAttribute("HeadInfoRarity") ~= nil then
            table.insert(out, obj)
        end
    end
    return out
end
local function getHitPos(model)
    local root = model:FindFirstChild("HumanoidRootPart")
               or model:FindFirstChildWhichIsA("BasePart")
    return root and root.Position or nil
end
local function getBackpackDecoFrames()
    local gui = Plr:FindFirstChild("PlayerGui")
    if not gui then return {} end
    local HUD = gui:FindFirstChild("HUD")
    if not HUD then return {} end
    local frames = {}
    for _, frame in ipairs(HUD:GetDescendants()) do
        if frame:IsA("Frame")
            and frame:GetAttribute("Type") == "Decoration"
            and frame:GetAttribute("UID") ~= nil
        then
            table.insert(frames, frame)
        end
    end
    return frames
end
local Convert = nil
local function getConvert()
    if Convert then return Convert end
    local ok, result = pcall(function()
        return require(RS:WaitForChild("ToolScripts"):WaitForChild("Convert"))
    end)
    if ok and result then
        Convert = result
    end
    return Convert
end
local function unAbb(text)
    if not text then return 0 end
    -- Strip leading $ and trailing /s (e.g. "$2.06M/s" -> "2.06M", "60/s" -> "60")
    local cleaned = text:gsub("^%$", ""):gsub("/s$", ""):match("^%s*(.-)%s*$")
    if not cleaned or cleaned == "" then return 0 end
    local conv = getConvert()
    if conv and conv.Num and conv.Num.UnAbb then
        local ok, val = pcall(conv.Num.UnAbb, cleaned)
        if ok and val then return tonumber(val) or 0 end
    end
    -- Fallback: parse suffix manually if Convert unavailable
    local suffixes = { K = 1e3, M = 1e6, B = 1e9, T = 1e12 }
    local num, suffix = cleaned:match("^([%d%.]+)([KMBTkmbt]?)$")
    if num then
        local n = tonumber(num) or 0
        local mult = suffixes[suffix:upper()] or 1
        return n * mult
    end
    return tonumber(cleaned) or 0
end
local function getMoneyScore(frame)
    -- Read the Money TextLabel text from the backpack frame (e.g. "$2.06M/s")
    local moneyLabel = frame:FindFirstChild("Money")
    if moneyLabel and moneyLabel:IsA("TextLabel") then
        return unAbb(moneyLabel.Text)
    end
    return 0
end
local function getBestDecoFromBag()
    local best = nil
    local bestScore = -1
    for _, frame in ipairs(getBackpackDecoFrames()) do
        local s = getMoneyScore(frame)
        if s > bestScore then
            bestScore = s
            best = {
                id      = frame:GetAttribute("Id"),
                quality = frame:GetAttribute("Quality"),
                uid     = frame:GetAttribute("UID"),
                score   = s,
            }
        end
    end
    return best
end
local function getOwnBlock()
    local player = (shared and shared.Player) or Plr
    local blockId = player:GetAttribute("BlockId")
    if not blockId then return nil end
    local pb = workspace:FindFirstChild("PlayerBlock")
    return pb and pb:FindFirstChild(tostring(blockId))
end
local function getAllSlots()
    local block = getOwnBlock()
    if not block then return {} end
    local slots = {}
    for _, floorFolder in ipairs(block:GetChildren()) do
        if tonumber(floorFolder.Name) then
            local slotContainer = floorFolder:FindFirstChild(SLOT_FOLDER)
            if slotContainer then
                for _, slot in ipairs(slotContainer:GetChildren()) do
                    if slot:IsA("Model") and slot:GetAttribute("Lock") ~= true then
                        table.insert(slots, slot)
                    end
                end
            end
        end
    end
    return slots
end
local function getSlotDecoScore(slot)
    if not slot:GetAttribute("HasDecoration") then return -1 end
    -- Find the placed deco model by matching UID in workspace.PlayerBlock.<blockId>.Decoration,
    -- then walk its descendants for a TextLabel whose text ends in "/s" (e.g. "60/s").
    local uid = slot:GetAttribute("DecorationUID")
    if not uid then return -1 end
    local blockId = (shared and shared.Player or Plr):GetAttribute("BlockId")
    if not blockId then return -1 end
    local pb = workspace:FindFirstChild("PlayerBlock")
    local block = pb and pb:FindFirstChild(tostring(blockId))
    local decoFolder = block and block:FindFirstChild("Decoration")
    if not decoFolder then return -1 end
    for _, model in ipairs(decoFolder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("UID") == uid then
            -- Walk all descendants looking for a TextLabel with income text ("60/s")
            for _, desc in ipairs(model:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Name == "BuffText" then
                    local val = unAbb(desc.Text)
                    if val > 0 then return val end
                end
            end
            -- BuffText not yet visible; return 0 so we don't treat it as empty (-1)
            return 0
        end
    end
    -- Model not yet replicated; treat as empty so placement is allowed
    return -1
end
local function getPlayerData()
    local ok, data = pcall(function()
        return PlayerFRE:InvokeServer("GetPlayerData")
    end)
    return ok and data or nil
end
local function canRebirth()
    local data = getPlayerData()
    if not data then return false end
    -- shared.RS.ConfigData uses a __index metamethod that auto-requires ModuleScripts,
    -- so use it directly instead of FindFirstChild (which returns the raw ModuleScript instance).
    local RebirthConfig = shared and shared.RS and shared.RS.ConfigData and shared.RS.ConfigData.Rebirth
    if not RebirthConfig then
        -- Fallback: manually require the ModuleScript
        local configData = RS:FindFirstChild("ConfigData")
        local rebirthModule = configData and configData:FindFirstChild("Rebirth")
        if rebirthModule and rebirthModule:IsA("ModuleScript") then
            local ok, result = pcall(require, rebirthModule)
            RebirthConfig = ok and result or nil
        end
    end
    if not RebirthConfig or type(RebirthConfig.GetVauleByName) ~= "function" then return false end
    local nextRebirth = (tonumber(data.rebirth) or 0) + 1
    local entry = RebirthConfig.GetVauleByName("Rebirth", nextRebirth)
    if not entry then return false end
    local need = tonumber(entry.NeedLevel)
    if not need then return false end
    return (tonumber(data.attackLevel) or 0) >= need
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
    Config = Window:AddTab("Config"),
}
local TB = {
    Main = {
        Left = {
            Autofarm = Tabs.Main:AddLeftGroupbox("hsjhbdjnwjsbsjjan"),
        },
    },
}
local LeftBox  = TB.Main.Left.Autofarm
LeftBox:AddToggle("AutoKillAll", { Text = "Auto Kill Brainrots", Default = false })
LeftBox:AddToggle("AutoPlace",   { Text = "Auto Place",             Default = false })
LeftBox:AddToggle("AutoClaim",   { Text = "Auto Claim Money",       Default = false })
LeftBox:AddToggle("AutoUpgrade", { Text = "Auto Upgrade",           Default = false })
LeftBox:AddToggle("AutoRebirth", { Text = "Auto Rebirth",           Default = false })
LeftBox:AddToggle("AutoSellAll",  { Text = "Auto Sell All",          Default = false })
Toggles.AutoKillAll:OnChanged(function(state)
    Thread("AutoKillAll", function()
        ReloadEvent:FireServer("RequestState")
        while Toggles.AutoKillAll.Value do
            local myRoot = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
            for _, model in ipairs(getBrainrots()) do
                if not Toggles.AutoKillAll.Value then break end
                local hitPos = getHitPos(model)
                if hitPos then
                    if curAmmo <= 0 then
                        ReloadEvent:FireServer("Reload")
                        local t0 = tick()
                        repeat task.wait(0.1) until (not isReloading and curAmmo > 0) or (tick() - t0) > 5
                    end
                    ShootEvent:FireServer(hitPos, (hitPos - (myRoot and myRoot.Position or hitPos)).Unit)
                    curAmmo = math.max(0, curAmmo - 1)
                    task.wait(0.05)
                end
            end
            task.wait(0.1)
        end
    end, state)
end)
Toggles.AutoPlace:OnChanged(function(state)
    Thread("AutoPlace", function()
        repeat task.wait(0.5)
        until Plr:GetAttribute("BlockId") ~= nil
            and Plr:FindFirstChild("PlayerGui")
        while Toggles.AutoPlace.Value do
            local best = getBestDecoFromBag()
            if best and best.id and best.quality and best.uid then
                -- Check if all occupied slots already have score >= best; if so, nothing to do
                local slots = getAllSlots()
                local allOptimal = true
                for _, slot in ipairs(slots) do
                    local hasDecoration = slot:GetAttribute("HasDecoration")
                    if not hasDecoration then
                        allOptimal = false
                        break
                    end
                    local currentScore = getSlotDecoScore(slot)
                    if best.score > currentScore then
                        allOptimal = false
                        break
                    end
                end
                if not allOptimal then
                    for _, slot in ipairs(slots) do
                        if not Toggles.AutoPlace.Value then break end
                        local floorId = tonumber(slot.Parent.Parent.Name)
                        local slotId  = tonumber(slot.Name)
                        if floorId and slotId then
                            local hasDecoration = slot:GetAttribute("HasDecoration")
                            if not hasDecoration then
                                DecoRE:FireServer(
                                    "PutDecoration",
                                    floorId,
                                    slotId,
                                    best.id,
                                    best.quality,
                                    best.uid
                                )
                                task.wait(0.175)
                                best = getBestDecoFromBag()
                                if not (best and best.id) then break end
                            else
                                local currentScore = getSlotDecoScore(slot)
                                if best.score > currentScore then
                                    local currentUid = slot:GetAttribute("DecorationUID")
                                    if currentUid then
                                        DecoRE:FireServer("PickUpDecoration", currentUid)
                                        task.wait(0.175)
                                        best = getBestDecoFromBag()
                                        if best and best.id then
                                            DecoRE:FireServer(
                                                "PutDecoration",
                                                floorId,
                                                slotId,
                                                best.id,
                                                best.quality,
                                                best.uid
                                            )
                                            task.wait(0.175)
                                            best = getBestDecoFromBag()
                                            if not (best and best.id) then break end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(2)
        end
    end, state)
end)
Toggles.AutoClaim:OnChanged(function(state)
    Thread("AutoClaim", function()
        while Toggles.AutoClaim.Value do
            pcall(function()
                PlayerRE:FireServer("OfflineReware")
            end)
            task.wait()
        end
    end, state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", function()
        while Toggles.AutoUpgrade.Value do
            pcall(function() AttackRE:FireServer("UpgradeAttack", 5) end)
            task.wait()
            pcall(function() BackpackRE:FireServer("UpgradeBackpack") end)
            task.wait()
            pcall(function() FloorRE:FireServer("UpgradeFloor") end)
            task.wait()
        end
    end, state)
end)
Toggles.AutoRebirth:OnChanged(function(state)
    Thread("AutoRebirth", function()
        while Toggles.AutoRebirth.Value do
            if canRebirth() then
                pcall(function()
                    RebirthRE:FireServer("Rebirth")
                end)
                task.wait()
            end
            task.wait()
        end
    end, state)
end)
Toggles.AutoSellAll:OnChanged(function(state)
    Thread("AutoSellAll", function()
        while Toggles.AutoSellAll.Value do
            pcall(function()
                SellFRE:InvokeServer("SellAll")
            end)
            task.wait(3)
        end
    end, state)
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
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/FindSnipeBrainrot")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
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
