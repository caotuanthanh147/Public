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
local l,f={},"1log.txt";if isfile and isfile(f)then delfile(f)end;if writefile then writefile(f,"")end;function notyuri(...)local t=table.create(select("#",...))for i=1,select("#",...)do t[i]=tostring(select(i,...))end local s=("[%s] %s"):format(os.date("%H:%M:%S"),table.concat(t," "));l[#l+1]=s;if appendfile then appendfile(f,s.."\n")end end
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
local Remotes = {}
local RemoteFns = {}
local Modules = {}
local GameValues = {}
local MinigameHits = {
    Yuta = { Remote = "YutaMinigameEvent", Args = { "LaserSuccess" } },
    Mahoraga = { Remote = "MahoragaMinigameEvent", Args = { "AdaptSuccess" } },
    Sukuna1 = { Remote = "Sukuna1MinigameEvent", Args = { "RitualSuccess" } },
    Toji = { Remote = "TojiMinigameEvent", Args = { "Hit" } },
    Choso = { Remote = "ChosoMinigameEvent", Args = { "LaserDodge" } },
    Nanami = { Remote = "NanamiMinigameEvent", Args = { "Hit", true } },
    Hanami = { Remote = "HanamiMinigameEvent", Args = { "CollectFlower", "Purple" } },
    John = { Remote = "JohnMinigameEvent", Args = { "WalkComplete" } },
    Naoya = { Remote = "NaoyaIncomeEvent", Args = { "UpdateMultiplier", 100 } },
    Hakari = { Remote = "HakariSlotSpin", Args = { "\xF0\x9F\x8E\xB0" } },
    Ryu = { Remote = "RyuBeamEvent", Args = { "BeamClick", 1 } },
    Subaru = { Remote = "SubaruMinigameEvent", Args = { "UpdateMultiplier", 100 } },
    Rabbit273 = { Remote = "Rabbit273MinigameEvent", Args = { "Catch", "Diamond" } },
    Gojo = { Remote = "GojoMinigameEvent", Args = { "Success", 0.25, 1 } },
    Sukuna = { Remote = "SukunaMinigameEvent", Args = { "Hit", true } },
    Inumaki = { Remote = "InumakiMinigameEvent", Args = { "WordSuccess", 12 } },
    Megumi = { Remote = "MegumiMinigameEvent", Args = { "RollPotential", 50 } },
    Todo = { Remote = "TodoMinigameEvent", Args = { "Boost", 2, 5 } },
    Kenjaku = { Remote = "KenjakuMinigameEvent", Args = { "Success", 1.5, 3 } },
    Takaba = { Remote = "TakabaMinigameEvent", Args = { "Success", 0.5, 5 } },
    Kashimo = { Remote = "KashimoMinigameEvent", Args = { "Hit", true } },
    HeianSukuna = { Remote = "HeianSukunaMinigameEvent", Args = { "Hit", true } },
    Kurourushi = { Remote = "KurourushiMinigameEvent", Args = { "Hit", true } },
    MeiMei = { Remote = "MeiMeiMinigameEvent", Args = { "Hit", true } },
    Yuki = { Remote = "YukiMinigameEvent", Args = { "Move" } },
    Maki = { Remote = "MakiMinigameEvent", Args = { "HitSuccess", 1, true } },
    Mahito = { Remote = "MahitoMinigameEvent", Args = { "Hit", 10 } },
    Jogo = { Remote = "JogoBeatHit", Args = { "Tick", 1, 0.1 } },
    Panda = { Remote = "PandaMinigameEvent", Args = { "HeightUpdate", 100 } },
    Charles = { Remote = "CharlesMinigameEvent", Args = { "Spam" } },
    Higuruma = { Remote = "HigurumaMinigameEvent", Args = { "Result", true } },
    Dagon = { Remote = "DagonMinigameEvent", Args = { "Result", true } },
    Uro = { Remote = "UroMinigameEvent", Args = { "Hit", true } },
    Reggie = { Remote = "ReggieMinigameEvent", Args = { "Hit", true } },
    Mechamaru = { Remote = "MechamaruMinigameEvent", Args = { "Repair", true } },
}
local YujiCombo = 0
local FollowBoostIds = { "Owner", "CoOwner" }
local OrbState = { CashRun = false, GemRun = false }
local FollowBoostDone = false
local UpgradeGetSelection = nil
local CharUpgradeGetSelection = nil
local function LoadLarpGame()
    for _, name in ipairs({ "Money", "Gems", "Rebirths", "IsEmoting", "CurrentCharacter", "Duration", "Cooldown", "MoneyPerSec", "UI_Multiplier", "Upgrades", "CharUpgrades", "OwnedCharacters", "RotationQuests", "ActiveQuests", "CompletedQuests" }) do
        local v = Plr:WaitForChild(name, 10)
        if v then GameValues[name] = v end
    end
    for _, name in ipairs({ "EmoteEvent", "RebirthEvent", "UpgradeEvent", "CharacterUpgradeEvent", "AcceptQuestEvent", "QuestLarpComplete", "BuyCrateEvent", "ClaimOfflineEvent", "OfflineRewardEvent", "SyncEvent", "YutaMinigameEvent", "MahoragaMinigameEvent", "Sukuna1MinigameEvent", "TojiMinigameEvent", "ChosoMinigameEvent", "NanamiMinigameEvent", "HanamiMinigameEvent", "JohnMinigameEvent", "YujiBeatHit", "YujiMinigameEvent", "NaoyaIncomeEvent", "HakariMinigameEvent", "HakariSlotSpin", "RyuBeamEvent", "SubaruMinigameEvent", "Rabbit273MinigameEvent", "GojoMinigameEvent", "SukunaMinigameEvent", "InumakiMinigameEvent", "MegumiMinigameEvent", "TodoMinigameEvent", "KenjakuMinigameEvent", "TakabaMinigameEvent", "KashimoMinigameEvent", "HeianSukunaMinigameEvent", "KurourushiMinigameEvent", "MeiMeiMinigameEvent", "YukiMinigameEvent", "MakiMinigameEvent", "MahitoMinigameEvent", "JogoBeatHit", "PandaMinigameEvent", "CharlesMinigameEvent", "HigurumaMinigameEvent", "DagonMinigameEvent", "UroMinigameEvent", "ReggieMinigameEvent", "MechamaruMinigameEvent" }) do
        local r = GetSafeRemote(RS, name)
        if not r then r = RS:WaitForChild(name, 5) end
        if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then Remotes[name] = r end
    end
    local rr = RS:WaitForChild("RewardRemotes", 5)
    if rr then
        for _, name in ipairs({ "ClaimReward", "ClaimIndexReward", "CheckIndexRewards" }) do
            local r = GetSafeRemote(rr, name)
            if not r then r = rr:WaitForChild(name, 3) end
            if r and r:IsA("RemoteFunction") then RemoteFns[name] = r end
        end
    end
    for _, name in ipairs({ "ClaimCashRunOrb", "ClaimGemRunOrb", "ClaimFollowBoost" }) do
        local r = GetSafeRemote(RS, name)
        if not r then r = RS:WaitForChild(name, 5) end
        if r and r:IsA("RemoteFunction") then RemoteFns[name] = r end
    end
    Modules.Character = GetSafeModule(RS, "CharacterModule")
    Modules.Upgrade = GetSafeModule(RS, "UpgradeModule")
    Modules.Crate = GetSafeModule(RS, "CrateModule")
    Modules.Rebirth = GetSafeModule(RS, "RebirthModule")
    Modules.Quest = GetSafeModule(RS, "QuestModule")
    Modules.Rewards = GetSafeModule(RS, "RewardsConfig")
    Modules.Title = GetSafeModule(RS, "TitleModule")
end
local function GetMoney()
    local v = GameValues.Money
    return v and tonumber(v.Value) or 0
end
local function GetGems()
    local v = GameValues.Gems
    return v and tonumber(v.Value) or 0
end
local function GetCurrentCharacter()
    local v = GameValues.CurrentCharacter
    return v and v.Value or ""
end
local function IsLarping()
    local v = GameValues.IsEmoting
    return v and v.Value or false
end
local function FuncAutoLarp()
    while true do
        task.wait(1)
        if Plr:GetAttribute("TutorialLocked") ~= true and not IsLarping() and GetCurrentCharacter() ~= "" then
            FireRemote(Remotes.EmoteEvent)
            YujiCombo = 0
        end
    end
end
local function FuncAutoMinigame()
    while true do
        task.wait()
        if IsLarping() then
            local char = GetCurrentCharacter()
            if char == "Yuji" then
                if Remotes.YujiBeatHit and Remotes.YujiMinigameEvent then
                    YujiCombo = YujiCombo + 1
                    FireRemote(Remotes.YujiBeatHit, true, YujiCombo)
                    FireRemote(Remotes.YujiMinigameEvent, "BeatHit")
                end
            else
                local hit = MinigameHits[char]
                if hit then
                    local r = Remotes[hit.Remote]
                    if r then FireRemote(r, table.unpack(hit.Args)) end
                end
            end
        end
    end
end
local function FuncAutoRebirth()
    while true do
        task.wait(.1)
        if not Modules.Rebirth then break end
        local rebirths = GameValues.Rebirths
        if rebirths and rebirths.Value < 250 then
            local cost = Modules.Rebirth.GetCost(rebirths.Value) or math.huge
            if GetMoney() >= cost then
                FireRemote(Remotes.RebirthEvent)
            end
        end
    end
end
local function FuncAutoQuest()
    while true do
        task.wait(.5)
        if Modules.Quest and GameValues.RotationQuests and GameValues.CompletedQuests and GameValues.ActiveQuests then
            for questId in pairs(Modules.Quest.Quests) do
                if not GameValues.CompletedQuests:FindFirstChild(questId)
                    and not GameValues.ActiveQuests:FindFirstChild(questId)
                    and GameValues.RotationQuests:FindFirstChild(questId) then
                    FireRemote(Remotes.AcceptQuestEvent, questId)
                end
            end
        end
    end
end
local function FuncAutoQuestComplete()
    while true do
        task.wait(10)
        local char = GetCurrentCharacter()
        local duration = GameValues.Duration
        if char ~= "" and duration then
            FireRemote(Remotes.QuestLarpComplete, char, duration.Value)
        end
    end
end
local function FuncAutoUpgrade()
    while true do
        task.wait(.1)
        if Modules.Upgrade and GameValues.Upgrades and Options.UpgradeSelect then
            local mode = Options.UpgradeMode.Value
            local sel = UpgradeGetSelection()
            local money, gems = GetMoney(), GetGems()
            for name in pairs(sel) do
                local data = Modules.Upgrade.Upgrades[name]
                local stat = GameValues.Upgrades:FindFirstChild(name)
                if data and stat then
                    local maxed = data.MaxLevel and stat.Value >= data.MaxLevel
                    if not maxed then
                        local currency = data.Currency or "Money"
                        local balance = currency == "Gems" and gems or money
                        if mode == "Max" then
                            local count = Modules.Upgrade.GetMaxUpgradeInfo(name, stat.Value, balance)
                            if count > 0 then FireRemote(Remotes.UpgradeEvent, name, "Max") end
                        else
                            local price = Modules.Upgrade.GetPrice(name, stat.Value) or math.huge
                            if price <= balance then FireRemote(Remotes.UpgradeEvent, name, 1) end
                        end
                    end
                end
            end
        end
    end
end
local function FuncAutoCharUpgrade()
    while true do
        task.wait(.1)
        if Modules.Character and GameValues.CharUpgrades and GameValues.OwnedCharacters and Options.CharUpgradeSelect then
            local sel = CharUpgradeGetSelection()
            local money = GetMoney()
            for char in pairs(sel) do
                local data = Modules.Character.Characters[char]
                local noUpgrade = data and data.NoUpgrade
                if not noUpgrade then
                    local stat = GameValues.CharUpgrades:FindFirstChild(char)
                    local owned = GameValues.OwnedCharacters:FindFirstChild(char)
                    if stat and owned then
                        local cashCost, cloneCost = Modules.Character.GetUpgradePrice(char, stat.Value)
                        if (cashCost or math.huge) <= money and (cloneCost or 0) <= owned.Value then
                            FireRemote(Remotes.CharacterUpgradeEvent, char)
                        end
                    end
                end
            end
        end
    end
end
local function GetCrateInfo(name)
    if not (Modules.Crate and Modules.Crate.Crates) then return nil end
    return Modules.Crate.Crates[name]
end
local function FuncAutoCrate()
    while true do
        task.wait(.5)
        local crateName = Options.CrateSelect and Options.CrateSelect.Value
        local info = crateName and GetCrateInfo(crateName)
        if info then
            local currency = Options.CrateCurrency.Value
            local amountMode = Options.CrateAmount.Value
            local balance = currency == "Gems" and GetGems() or GetMoney()
            local unit = currency == "Gems" and (info.GemsPrice or math.huge) or info.Price
            if unit and unit > 0 then
                local amount = amountMode == "1x" and 1 or amountMode == "3x" and 3 or math.min(math.floor(balance / unit), 10000)
                if amount > 0 and unit * amount <= balance then
                    FireRemote(Remotes.BuyCrateEvent, crateName, amount, currency)
                end
            end
        end
    end
end
local function ClaimAllRewards()
    if not (RemoteFns.ClaimReward and Modules.Rewards) then return end
    for _, category in ipairs({ "Daily", "Playtime" }) do
        local list = category == "Daily" and Modules.Rewards.DailyRewards or Modules.Rewards.PlaytimeRewards
        for _, reward in ipairs(list or {}) do
            task.spawn(function()
                pcall(function() RemoteFns.ClaimReward:InvokeServer(category, reward.ID) end)
            end)
            task.wait(0.1)
        end
    end
end
local function ClaimAllIndexRewards()
    if not (RemoteFns.CheckIndexRewards and RemoteFns.ClaimIndexReward) then return end
    local ok, result = pcall(function() return RemoteFns.CheckIndexRewards:InvokeServer() end)
    if not (ok and type(result) == "table") then return end
    local unclaimed = false
    for _, entry in ipairs(result) do
        if not entry.claimed then unclaimed = true break end
    end
    if not unclaimed then return end
    if Modules.Character and Modules.Character.Characters then
        for name in pairs(Modules.Character.Characters) do
            task.spawn(function()
                pcall(function() RemoteFns.ClaimIndexReward:InvokeServer(name, "Larp") end)
            end)
        end
    end
    if Modules.Title and Modules.Title.Titles then
        for name in pairs(Modules.Title.Titles) do
            task.spawn(function()
                pcall(function() RemoteFns.ClaimIndexReward:InvokeServer(name, "Title") end)
            end)
        end
    end
end
local function FuncAutoRewards()
    while true do
        task.wait(60)
        if not (Toggles.AutoClaimRewards and Toggles.AutoClaimRewards.Value) then break end
        ClaimAllRewards()
    end
end
local function FuncAutoIndexRewards()
    while true do
        task.wait(60)
        if not (Toggles.AutoIndexRewards and Toggles.AutoIndexRewards.Value) then break end
        ClaimAllIndexRewards()
    end
end
local function FuncAutoOrbs()
    while true do
        task.wait(.1)
        if OrbState.CashRun and RemoteFns.ClaimCashRunOrb then
            task.spawn(function() pcall(function() RemoteFns.ClaimCashRunOrb:InvokeServer() end) end)
        end
        if OrbState.GemRun and RemoteFns.ClaimGemRunOrb then
            task.spawn(function() pcall(function() RemoteFns.ClaimGemRunOrb:InvokeServer() end) end)
        end
    end
end
local function RunFollowBoosts()
    if FollowBoostDone then return end
    FollowBoostDone = true
    for _, id in ipairs(FollowBoostIds) do
        if RemoteFns.ClaimFollowBoost then
            pcall(function() RemoteFns.ClaimFollowBoost:InvokeServer(id) end)
            task.wait(1)
        end
    end
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
local CrateBaseValues = {}
local CrateOrder = {}
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
local function TPTo(target, offset)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
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
    if not cframe then return false end
    if offset then
        cframe = cframe * CFrame.new(offset)
    end
    hrp.CFrame = cframe
    return true
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
GB.Player.Left.Server:AddToggle("AntiKick", { Text = "Anti Kick (Client)", Disabled = not Support.HookMeta })
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
TB_Tabs.Autofarm.T1:AddToggle("AutoLarp", { Text = "Auto Larp", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMinigame", { Text = "Auto Minigame", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCharUpgrade", { Text = "Auto Character Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoOrbCollect", { Text = "Auto Collect Run Orbs", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCrate", { Text = "Auto Crate", Default = false })
local UpgradeBaseValues = { "MoneyPerSec", "Duration", "Cooldown", "WalkSpeed", "ExtraLuck", "AirJumps" }
local UpgradeGetSel, UpgradeRefresh = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "UpgradeSelect", { Text = "Upgrades", Values = UpgradeBaseValues, Default = { MoneyPerSec = true, Duration = true, Cooldown = true } })
UpgradeGetSelection = UpgradeGetSel
local CharUpgradeBaseValues = {}
local CharUpgradeGetSel, CharUpgradeRefresh = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "CharUpgradeSelect", { Text = "Characters To Upgrade", Values = CharUpgradeBaseValues, Default = {} })
CharUpgradeGetSelection = CharUpgradeGetSel
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeMode", { Text = "Buy Mode", Values = { "1x", "Max" }, Default = "1x" })
TB_Tabs.Autofarm2.T1:AddDropdown("CrateSelect", { Text = "Crate", Values = { "Wooden" }, Default = "Wooden" })
TB_Tabs.Autofarm2.T1:AddDropdown("CrateCurrency", { Text = "Currency", Values = { "Money", "Gems" }, Default = "Money" })
TB_Tabs.Autofarm2.T1:AddDropdown("CrateAmount", { Text = "Amount", Values = { "1x", "3x", "Max" }, Default = "1x" })
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
            task.wait(.5)
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
task.spawn(function()
    LoadLarpGame()
    if Modules.Upgrade and Modules.Upgrade.Upgrades then
        table.clear(UpgradeBaseValues)
        for name in pairs(Modules.Upgrade.Upgrades) do
            table.insert(UpgradeBaseValues, name)
        end
        table.sort(UpgradeBaseValues)
        UpgradeRefresh()
    end
    if Modules.Character and Modules.Character.Characters then
        table.clear(CharUpgradeBaseValues)
        for name in pairs(Modules.Character.Characters) do
            table.insert(CharUpgradeBaseValues, name)
        end
        table.sort(CharUpgradeBaseValues)
        CharUpgradeRefresh()
    end
    if Modules.Crate and Modules.Crate.Crates then
        table.clear(CrateOrder)
        for name, data in pairs(Modules.Crate.Crates) do
            table.insert(CrateOrder, { Name = name, Order = data.DisplayOrder or 999 })
        end
        table.sort(CrateOrder, function(a, b) return a.Order < b.Order end)
        local names = {}
        for _, entry in ipairs(CrateOrder) do
            table.insert(names, entry.Name)
        end
        if #names > 0 and Options.CrateSelect then
            Options.CrateSelect:SetValues(names)
            Options.CrateSelect:SetValue(names[1])
        end
    end
    if Remotes.SyncEvent then
        Connections.LarpSync = Remotes.SyncEvent.OnClientEvent:Connect(function(active)
            OrbState.CashRun = false
            OrbState.GemRun = false
            if type(active) == "table" then
                for _, entry in ipairs(active) do
                    if type(entry) == "table" then
                        if entry.name == "CashRun" then OrbState.CashRun = true end
                        if entry.name == "GemRun" then OrbState.GemRun = true end
                    end
                end
            end
        end)
    end
    if Modules.Character and Modules.Character.Characters then
        local supported = {}
        for name in pairs(MinigameHits) do table.insert(supported, name) end
        table.insert(supported, "Yuji")
        table.sort(supported)
        notyuri("[Larp] Auto Minigame supports:", table.concat(supported, ", "))
    end
end)
Toggles.AutoLarp:OnChanged(function(state)
    Thread("AutoLarp", FuncAutoLarp, state)
end)
Toggles.AutoMinigame:OnChanged(function(state)
    Thread("AutoMinigame", FuncAutoMinigame, state)
end)
Toggles.AutoRebirth:OnChanged(function(state)
    Thread("AutoRebirth", FuncAutoRebirth, state)
end)
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", FuncAutoUpgrade, state)
end)
Toggles.AutoCharUpgrade:OnChanged(function(state)
    Thread("AutoCharUpgrade", FuncAutoCharUpgrade, state)
end)
Toggles.AutoCrate:OnChanged(function(state)
    Thread("AutoCrate", FuncAutoCrate, state)
end)
Toggles.AutoOrbCollect:OnChanged(function(state)
    Thread("AutoOrbs", FuncAutoOrbs, state)
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
SaveManager:SetFolder("Yuri/Larp")
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
