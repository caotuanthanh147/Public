print("a")
if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
    return
end
print("b")
function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
getgc = missing("function", getgc or get_gc_objects)
getconnections = missing("function", getconnections or get_signal_cons)
print("c")
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
print("d")
local Players = Services.Players
local Plr = Players.LocalPlayer
local PGui = Plr.PlayerGui
local PlayerData = Plr.PlayerData
print("e")
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
print("f")
local repo = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
print("g")
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
print("h")
getgenv().ayasemiyatongekissazumirisa = true
print("i")
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
    print("x")
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
        Events = RS.Events,
        RemoteEvents = RS.Events.RemoteEvents,
        RemoteFunction = RS.Events.RemoteFunction,
        PlayerSpawn = RS.Events.RemoteFunction.PlayerSpawn,
        StartBattle = RS.Events.RemoteFunction.StartBattle,
        BattleInfo = RS.Events.RemoteEvents.BattleInfo,
        WinOrLose = RS.Events.RemoteEvents.WinOrLose,
        GiveUp = RS.Events.RemoteEvents.GiveUp,
    }
    local Modules = {
        GameValues = require(RS.Modules.GameValues),
    }
    local Flags = {}
    local Shared = {
        Farm = false,
    }
    local Tables = {
    }
    local MDir = "Yuri/TBB/Macros"
    local MState = {
        Rec          = false,
        Rep          = false,
        Cur          = nil,
        Load         = nil,
        Hooked       = false,
        Step         = 0,
        Total        = 0,
        LabelRef     = nil,
        PendingLabel = nil,
        StartRelay   = false,
    }
    local StageSwitch = {
        Active      = false,
        ReplayCount = 0,
        OrigChapter = nil,
        OrigStage   = nil,
        OrigDiff    = nil,
        OrigStars   = nil,
        OrigLimit   = nil,
        OrigDXP     = nil,
        OrigMult    = nil,
    }
    local Connections = {
        Player_General = nil,
        Knockback = {},
        Reconnect = nil,
        Macro = {},
        AutoReplay = nil,
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
    function AddSliderToggle(Config, ...)
        if type(Config) == "string" then
            return Toggles[Config], Options[Config .. "Value"]
        end
        local Handlers = {...}
        local Toggle, Slider
        Toggle = Config.Group:AddToggle(Config.Id, {
            Text = Config.Text,
            Default = Config.DefaultToggle or false,
            Disabled = Config.Disabled,
            Callback = function(state)
                if Slider then Slider:SetVisible(state) end
                for _, Handler in ipairs(Handlers) do
                    Handler(state, Toggle, Slider)
                end
            end,
        })
        Slider = Config.Group:AddSlider(Config.Id .. "Value", {
            Text = Config.Text,
            Default = Config.Default,
            Min = Config.Min,
            Max = Config.Max,
            Rounding = Config.Rounding or 0,
            Compact = true,
            Visible = false
        })
        return Toggles[Config.Id], Options[Config.Id .. "Value"]
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
    local function GetElapsedBattleTime()
        local startTime = workspace:GetAttribute("StartTime")
        if not startTime then return nil end
        return (DateTime.now().UnixTimestampMillis / 1000) - startTime
    end
    local function LoadMDir()
        if not writefile then return end
        pcall(function()
            local built = ""
            for _, part in ipairs(MDir:split("/")) do
                built = (built == "") and part or (built .. "/" .. part)
                if not isfolder(built) then
                    makefolder(built)
                end
            end
        end)
    end
    LoadMDir()
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
        local entries = {}
        local i = 1
        while data[tostring(i)] do
            entries[i] = data[tostring(i)]
            i = i + 1
        end
        return { entries = entries }
    end
    local function SaveMacro(name, macro)
        if not name or name == "" or not writefile then return false end
        LoadMDir()
        local path = MDir .. "/" .. name .. ".json"
        local out = {}
        for i, entry in ipairs(macro.entries) do
            out[tostring(i)] = entry
        end
        local ok = pcall(function()
            writefile(path, HttpService:JSONEncode(out))
        end)
        return ok
    end
    local function UpdateLabel(suffix, elapsed)
        if MState.LabelRef and MState.LabelRef.SetText then
            local txt
            local timeStr = elapsed and string.format(" [%.2fs]", elapsed) or ""
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
            notyuri("[Macro Rec] UpdateLabel called, txt=", txt, "LabelRef exists=", MState.LabelRef ~= nil)
            if MState.Rec then
                MState.PendingLabel = txt
            else
                local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
                if not ok then
                    notyuri("[Macro Rec] SetText FAILED:", tostring(err))
                    MState.PendingLabel = txt
                end
            end
        end
    end
    local function LabelPump()
        while MState.Rec do
            if MState.PendingLabel then
                local txt = MState.PendingLabel
                MState.PendingLabel = nil
                local ok, err = pcall(function() MState.LabelRef:SetText(txt) end)
                if not ok then
                    notyuri("[Macro Rec] LabelPump SetText FAILED:", tostring(err))
                end
            end
            task.wait()
        end
    end
    local function HandleRecordedAction(kind, slotName, capturedElapsed)
        if not MState.Rec or not MState.Cur then return end
        local elapsed = capturedElapsed
        if not elapsed then return end
        MState.Step = MState.Step + 1
        table.insert(MState.Cur.entries, {
            Type = kind,
            Slot = slotName,
            Elapsed = elapsed,
        })
        UpdateLabel(kind, elapsed)
        notyuri("[Macro Rec] recorded", kind, slotName or "", string.format("%.2f", elapsed))
    end
    local function InstallMacroHook()
        if MState.Hooked then return end
        local originalNamecall
        originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
            local self = ...
            local Method = getnamecallmethod()
            local ret = table.pack(originalNamecall(...))
            if MState.Rec and Method == "InvokeServer" and rawequal(self, Remotes.PlayerSpawn) then
                local arg2 = select(2, ...)
                local capturedElapsed = GetElapsedBattleTime()
                local success = ret[1] ~= nil
                task.defer(function()
                    if not success then
                        notyuri("[Macro Rec] skip record - InvokeServer returned nil (failure)", tostring(arg2))
                        return
                    end
                    if type(arg2) == "string" then
                        if arg2 == "Bank" then
                            HandleRecordedAction("Bank", nil, capturedElapsed)
                        elseif arg2 == "Cannon" then
                            HandleRecordedAction("Cannon", nil, capturedElapsed)
                        elseif arg2:match("^Slot%d$") then
                            HandleRecordedAction("Unit", arg2, capturedElapsed)
                        end
                    end
                end)
            end
            return table.unpack(ret, 1, ret.n)
        end))
        MState.Hooked = true
        notyuri("[Macro] __namecall hook installed")
    end
    local function Func_MacroRecord(state)
        if not state then return end
        if Toggles.LoadMacro and Toggles.LoadMacro.Value then
            Toggles.LoadMacro:SetValue(false)
        end
        InstallMacroHook()
        MState.Cur = { entries = {} }
        MState.Step = 0
        UpdateLabel("Waiting")
        notyuri("[Macro Rec] waiting for StartTime change")
        MState.StartRelay = false
        while Toggles.MacroRecord.Value and not MState.StartRelay do
            task.wait()
        end
        if not Toggles.MacroRecord.Value then
            MState.Cur = nil
            MState.Step = 0
            UpdateLabel()
            return
        end
        MState.StartRelay = false
        MState.Rec = true
        UpdateLabel()
        task.spawn(LabelPump)
        notyuri("[Macro Rec] recording started")
        while Toggles.MacroRecord.Value do
            task.wait()
        end
        MState.Rec = false
        notyuri("[Macro Rec] recording stopped,", #MState.Cur.entries, "actions")
        local fname = (Options.FileName and Options.FileName.Value) or ""
        if fname == "" then fname = "Macro_" .. os.date("%Y%m%d_%H%M%S") end
        if SaveMacro(fname, MState.Cur) then
            Library:Notify("Macro saved:" .. fname, 4)
            if Options.MacroSelected then
                Options.MacroSelected:SetValues(ListMacros())
            end
        else
            Library:Notify("Failed to save macro (writefile unsupported?)", 4)
        end
        MState.Cur = nil
        MState.Step = 0
        UpdateLabel()
    end
    local function GetActiveSpawnMenu()
        local battleGui = PGui:FindFirstChild("BattleScreen")
        if not battleGui then return nil end
        local settings = PlayerData and PlayerData:FindFirstChild("Settings")
        local unitSwitch = settings and settings:FindFirstChild("UnitSwitch")
        if unitSwitch and unitSwitch.Value == false then
            return battleGui:FindFirstChild("MobileSpawnMenu") or battleGui:FindFirstChild("SpawnMenu")
        end
        return battleGui:FindFirstChild("SpawnMenu") or battleGui:FindFirstChild("MobileSpawnMenu")
    end
    local function DoMacroAction(entry)
        if entry.Type == "Unit" then
            local spawnMenu = GetActiveSpawnMenu()
            local slotBtn = spawnMenu and spawnMenu:FindFirstChild(entry.Slot, true)
            if slotBtn and slotBtn.Active == false then
                notyuri("[Macro Rep] skip", entry.Slot, "- not active")
                return
            end
            Remotes.PlayerSpawn:InvokeServer(entry.Slot)
        elseif entry.Type == "Bank" then
            Remotes.PlayerSpawn:InvokeServer("Bank")
        elseif entry.Type == "Cannon" then
            Remotes.PlayerSpawn:InvokeServer("Cannon", {
                CameraPosition = workspace.CurrentCamera.CFrame.Position
            })
        end
    end
    local function Func_MacroReplay()
        local macro = MState.Load
        if not macro or not macro.entries or #macro.entries == 0 then
            Toggles.LoadMacro:SetValue(false)
            Library:Notify("No macro loaded", 3)
            return
        end
        MState.Rep = true
        MState.Total = #macro.entries
        MState.Step = 0
        UpdateLabel()
        while Toggles.LoadMacro.Value do
            if StageSwitch.Active then
                task.wait()
            elseif not Modules.GameValues.InStage then
                task.wait()
            else
                local battleGui = PGui:FindFirstChild("BattleScreen")
                if not battleGui then
                    task.wait()
                else
                    if not MState.StartRelay then
                        UpdateLabel("Waiting")
                        while Toggles.LoadMacro.Value and Modules.GameValues.InStage and PGui:FindFirstChild("BattleScreen") and not MState.StartRelay and not StageSwitch.Active do
                            task.wait()
                        end
                    end
                    local started = MState.StartRelay
                        and Toggles.LoadMacro.Value
                        and Modules.GameValues.InStage
                        and PGui:FindFirstChild("BattleScreen") ~= nil
                        and not StageSwitch.Active
                    if started then
                        MState.StartRelay = false
                        notyuri("[Macro Rep] relay consumed, starting replay")
                        for i, entry in ipairs(macro.entries) do
                            if not Toggles.LoadMacro.Value then break end
                            if not Modules.GameValues.InStage or not PGui:FindFirstChild("BattleScreen") or StageSwitch.Active then
                                break
                            end
                            MState.Step = i
                            UpdateLabel(entry.Type, entry.Elapsed)
                            while Toggles.LoadMacro.Value do
                                if StageSwitch.Active then break end
                                local elapsed = GetElapsedBattleTime()
                                if elapsed and elapsed >= entry.Elapsed then break end
                                task.wait()
                            end
                            if Toggles.LoadMacro.Value and not StageSwitch.Active then
                                local ok, err = pcall(DoMacroAction, entry)
                                if not ok then
                                    notyuri("[Macro Rep] action failed:", tostring(err))
                                end
                            end
                        end
                        UpdateLabel("Finished")
                        notyuri("[Macro Rep] pass complete, waiting for next stage")
                    end
                    while Toggles.LoadMacro.Value and Modules.GameValues.InStage and PGui:FindFirstChild("BattleScreen") and not StageSwitch.Active do
                        task.wait()
                    end
                end
            end
        end
        MState.Rep = false
        MState.Step = 0
        UpdateLabel()
    end
    local function Func_AutoReplay()
        Connections.AutoReplay = Remotes.WinOrLose.OnClientEvent:Connect(function(won)
            if not Toggles.AutoReplay.Value then return end
            if StageSwitch.Active then
                notyuri("[AutoReplay] WinOrLose fired during stage switch, won=", tostring(won), "- reverting to original stage")
                StageSwitch.Active = false
                task.defer(function()
                    game:GetService("ReplicatedStorage").Events.RemoteEvents.Cleanup:FireServer()
                    local ok, result = pcall(function()
                        return Remotes.StartBattle:InvokeServer(
                            StageSwitch.OrigChapter,
                            StageSwitch.OrigStage,
                            StageSwitch.OrigDiff,
                            StageSwitch.OrigStars,
                            false,
                            StageSwitch.OrigLimit,
                            StageSwitch.OrigDXP,
                            StageSwitch.OrigMult
                        )
                    end)
                    if not ok then
                        notyuri("[AutoReplay] Revert StartBattle invoke failed:", tostring(result))
                    elseif not result then
                        notyuri("[AutoReplay] Revert StartBattle returned falsy (rejected)")
                    else
                        notyuri("[AutoReplay] Revert StartBattle accepted")
                    end
                end)
                return
            end
            notyuri("[AutoReplay] WinOrLose fired, won=", tostring(won), "- restarting battle")
            if Toggles.SwitchStageWhen and Toggles.SwitchStageWhen.Value then
                StageSwitch.ReplayCount = StageSwitch.ReplayCount + 1
                local threshold = tonumber(Options.SwitchStageEvery and Options.SwitchStageEvery.Value) or 0
                if threshold > 0 and StageSwitch.ReplayCount >= threshold then
                    notyuri("[AutoReplay] Switch-stage threshold reached (", StageSwitch.ReplayCount, "/", threshold, ") - switching stage")
                    StageSwitch.ReplayCount = 0
                    StageSwitch.OrigChapter = Modules.GameValues.Chapter
                    StageSwitch.OrigStage   = Modules.GameValues.Stage
                    StageSwitch.OrigDiff    = Modules.GameValues.Difficulty
                    StageSwitch.OrigStars   = Modules.GameValues.Stars
                    StageSwitch.OrigLimit   = Modules.GameValues.LevelLimit
                    StageSwitch.OrigDXP     = Modules.GameValues.EnableDoubleXP
                    StageSwitch.OrigMult    = Modules.GameValues.EnemyMultiplier
                    StageSwitch.Active = true
                    task.defer(function()
                        game:GetService("ReplicatedStorage").Events.RemoteEvents.Cleanup:FireServer()
                        local ok, result = pcall(function()
                            return Remotes.StartBattle:InvokeServer(
                                "Chapter1", 1, 2, 1, false, {}, false, 1
                            )
                        end)
                        if not ok then
                            notyuri("[AutoReplay] Switch StartBattle invoke failed:", tostring(result))
                            StageSwitch.Active = false
                            return
                        elseif not result then
                            notyuri("[AutoReplay] Switch StartBattle returned falsy (rejected)")
                            StageSwitch.Active = false
                            return
                        else
                            notyuri("[AutoReplay] Switch StartBattle accepted")
                        end
                        task.defer(function()
                            Remotes.GiveUp:FireServer()
                            notyuri("[AutoReplay] GiveUp fired for switch stage")
                        end)
                    end)
                    return
                end
            end
            task.defer(function()
                game:GetService("ReplicatedStorage").Events.RemoteEvents.Cleanup:FireServer()
                local ok, result = pcall(function()
                    return Remotes.StartBattle:InvokeServer(
                        Modules.GameValues.Chapter,
                        Modules.GameValues.Stage,
                        Modules.GameValues.Difficulty,
                        Modules.GameValues.Stars,
                        false,
                        Modules.GameValues.LevelLimit,
                        Modules.GameValues.EnableDoubleXP,
                        Modules.GameValues.EnemyMultiplier
                    )
                end)
                if not ok then
                    notyuri("[AutoReplay] StartBattle invoke failed:", tostring(result))
                elseif not result then
                    notyuri("[AutoReplay] StartBattle returned falsy (rejected)")
                else
                    notyuri("[AutoReplay] StartBattle accepted")
                end
            end)
        end)
    end
    local function GetSelectedSlots()
        local slots = {}
        local values = Options.AutoSpawnSlots and Options.AutoSpawnSlots.Value
        if type(values) == "table" then
            for slotName, isSelected in pairs(values) do
                if isSelected then table.insert(slots, slotName) end
            end
        end
        return slots
    end
    local function Func_AutoSpawn()
        while Toggles.AutoSpawn.Value do
            local slots = GetSelectedSlots()
            if #slots == 0 then
                task.wait()
            else
                local spawnMenu = GetActiveSpawnMenu()
                if not spawnMenu then
                    task.wait()
                else
                    for _, slotName in ipairs(slots) do
                        if not Toggles.AutoSpawn.Value then break end
                        local slotBtn = spawnMenu:FindFirstChild(slotName, true)
                        if slotBtn and slotBtn.Active == true then
                            Remotes.PlayerSpawn:InvokeServer(slotName)
                        end
                    end
                    task.wait()
                end
            end
        end
    end
    local function Func_SpamAll()
        while Toggles.SpamAll.Value do
            local elapsed = GetElapsedBattleTime()
            local threshold = tonumber(Options.SpamThreshold.Value) or 0
            if elapsed and elapsed >= threshold then
                local spawnMenu = GetActiveSpawnMenu()
                if not spawnMenu then
                    task.wait()
                else
                    for i = 1, 8 do
                        if not Toggles.SpamAll.Value then break end
                        local slotName = "Slot" .. i
                        local slotBtn = spawnMenu:FindFirstChild(slotName, true)
                        if slotBtn and slotBtn.Active == true then
                            Remotes.PlayerSpawn:InvokeServer(slotName)
                        end
                    end
                    task.wait()
                end
            else
                task.wait()
            end
        end
    end
    local function Func_AutoCannon()
        while Toggles.AutoCannon.Value do
            local battleGui = PGui:FindFirstChild("BattleScreen")
            local cannonBtn = battleGui and battleGui:FindFirstChild("CannonButton")
            if cannonBtn and cannonBtn.Active == true then
                Remotes.PlayerSpawn:InvokeServer("Cannon", {
                    CameraPosition = Vector3.new(-20, 5, -24.999998092651)
                })
            end
            task.wait()
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
    print("y")
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
            T1 = TB.Main.Left.Autofarm:AddTab("Macro"),
            T2 = TB.Main.Left.Autofarm:AddTab("AutoPlay"),
        },
        Autofarm2 = {
            T1 = TB.Main.Right.Autofarm:AddTab("Config"),
        },
    }
    TB_Tabs.Autofarm.T1:AddInput("FileName", {
        Text = "File Name",
        Default = "",
        Placeholder = "yuriyuri",
    })
    TB_Tabs.Autofarm.T1:AddToggle("MacroRecord", { Text = "Record Macro" })
    TB_Tabs.Autofarm.T1:AddDivider()
    TB_Tabs.Autofarm.T1:AddDropdown("MacroSelected", {
        Values = ListMacros(),
        Default = ListMacros()[1] or "",
        Text = "Macro List",
    })
    TB_Tabs.Autofarm.T1:AddToggle("LoadMacro", { Text = "Load Macro" })
    MState.LabelRef = TB_Tabs.Autofarm.T1:AddLabel("Idle", true)
    TB_Tabs.Autofarm.T2:AddToggle("AutoReplay", { Text = "Auto Replay" })
    TB_Tabs.Autofarm.T2:AddToggle("SwitchStageWhen", { Text = "Switch Stage" })
    TB_Tabs.Autofarm.T2:AddInput("SwitchStageEvery", {
        Default = "3",
        Text = "Switch Every n Replays",
    })
    TB_Tabs.Autofarm.T2:AddDivider()
    TB_Tabs.Autofarm.T2:AddDropdown("AutoSpawnSlots", {
        Text = "Select Slot(s)",
        Values = { "Slot1", "Slot2", "Slot3", "Slot4", "Slot5", "Slot6", "Slot7", "Slot8" },
        Default = {},
        Multi = true,
    })
    TB_Tabs.Autofarm.T2:AddToggle("AutoSpawn", { Text = "Auto Spawn" })
    TB_Tabs.Autofarm.T2:AddInput("SpamThreshold", {
        Default = "0",
        Text = "Spam When(s)",
    })
    TB_Tabs.Autofarm.T2:AddToggle("SpamAll", { Text = "Spam All" })
    TB_Tabs.Autofarm.T2:AddToggle("AutoCannon", { Text = "Auto Cannon" })
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
    AddSliderToggle({ Group = GB.Player.Left.General, Id = "TPW", Text = "TPWalk", Default = 1, Min = 1, Max = 10, Rounding = 1 })
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
    AddSliderToggle({ Group = GB.Player.Left.General, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
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
    AddSliderToggle({ Group = GB.Player.Left.Server, Id = "AutoServerhop", Text = "Auto Serverhop (Minutes)", Default = 30, Min = 0, Max = 300 }, function(state)
        Thread("AutoServerhop", function()
            local lastHop = tick()
            while Toggles.AutoServerhop.Value do
                task.wait(5)
                if not Toggles.AutoServerhop.Value then break end
                if (tick() - lastHop) >= (Options.AutoServerhopValue.Value * 60) then
                    Serverhop()
                    break
                end
            end
        end, state)
    end)
    AddSliderToggle({ Group = GB.Player.Left.Server, Id = "AutoRejoin", Text = "Auto Rejoin (Minutes)", Default = 30, Min = 0, Max = 300 }, function(state)
        Thread("AutoRejoin", function()
            local lastRejoin = tick()
            while Toggles.AutoRejoin.Value do
                task.wait(5)
                if not Toggles.AutoRejoin.Value then break end
                if (tick() - lastRejoin) >= (Options.AutoRejoinValue.Value * 60) then
                    TeleportService:Teleport(game.PlaceId, Plr)
                    break
                end
            end
        end, state)
    end)
    GB.Player.Right.Game:AddToggle("InstantPP", { Text = "Instant Prompt" })
    GB.Player.Right.Game:AddToggle("Fullbright", { Text = "Fullbright" })
    GB.Player.Right.Game:AddToggle("NoFog", { Text = "No Fog" })
    AddSliderToggle({ Group = GB.Player.Right.Game, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
    Toggles.AntiKnockback:OnChanged(function(state)
        Thread("AntiKnockback", Func_AntiKnockback, state)
    end)
    Toggles.TPW:OnChanged(function(v)
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
    workspace:GetAttributeChangedSignal("StartTime"):Connect(function()
        MState.StartRelay = true
        notyuri("[Macro Rep] StartTime changed, relay armed")
    end)
    Options.LimitFPSValue:OnChanged(function()
        if Toggles.LimitFPS.Value then
            setfpscap(Options.LimitFPSValue.Value)
        end
    end)
    Toggles.LimitFPS:OnChanged(function(v)
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
    Toggles.MacroRecord:OnChanged(function(state)
        Func_MacroRecord(state)
    end)
    Options.MacroSelected:OnChanged(function(v)
        MState.Load = LoadMacro(v)
        if MState.Load then
            notyuri("[Macro Rep] loaded", v, "-", #MState.Load.entries, "actions")
        end
    end)
    Toggles.LoadMacro:OnChanged(function(state)
        if state then
            MState.Load = LoadMacro(Options.MacroSelected.Value)
            if not MState.Load then
                Library:Notify("Select a valid macro first", 3)
                Toggles.LoadMacro:SetValue(false)
                return
            end
        end
        Thread("LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), state)
    end)
    Toggles.AutoReplay:OnChanged(function(state)
        if state then
            if not Connections.AutoReplay then
                Func_AutoReplay()
            end
        else
            if Connections.AutoReplay then
                Connections.AutoReplay:Disconnect()
                Connections.AutoReplay = nil
            end
        end
    end)
    Toggles.AutoSpawn:OnChanged(function(state)
        Thread("AutoSpawn", SafeLoop("Auto Spawn", Func_AutoSpawn), state)
    end)
    Toggles.SpamAll:OnChanged(function(state)
        Thread("SpamAll", SafeLoop("Spam All", Func_SpamAll), state)
    end)
    Toggles.AutoCannon:OnChanged(function(state)
        Thread("AutoCannon", SafeLoop("Auto Cannon", Func_AutoCannon), state)
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
    SaveManager:SetFolder("Yuri/TBB")
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
    print("z")
    Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
    notyuri("ERROR: " .. tostring(err))
end