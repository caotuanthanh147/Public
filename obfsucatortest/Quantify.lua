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
hookfunction = missing("function", hookfunction or hookfunc or replaceclosure)
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
local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local function GetObject(parent, pathString)
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
    local gotResult = false
    task.spawn(function()
        local packed = table.pack(pcall(function()
            return remote:InvokeServer(unpack(args))
        end))
        local success = packed[1]
        if success then
            result = table.pack(unpack(packed, 2, packed.n))
        else
            result = table.pack()
        end
        gotResult = true
    end)
    local start = tick()
    repeat task.wait() until gotResult or (tick() - start) > 2
    if not result then return nil end
    return unpack(result, 1, result.n)
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
        notyuri("Your executor does not support firesignal or getconnections.")
    end
end
local RemotesFolder = RS:WaitForChild("Remotes")
local Remotes = {
    Network = GetObject(RemotesFolder, "Network"),
    GameEvent = GetObject(RemotesFolder, "GameEvent"),
    Cards = GetObject(RemotesFolder, "Cards"),
    BoughtItem = GetObject(RemotesFolder, "BoughtItem"),
    Inventory = GetObject(RemotesFolder, "Inventory"),
    Difficulty = GetObject(RemotesFolder, "Difficulty"),
    GameEndedEvent = GetObject(RemotesFolder, "GameEndedEvent"),
    GetOtherData = GetObject(RemotesFolder, "GetOtherData"),
}
local MDir = "Yuri/Quantify/Macros"
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
}
local Modules = {
}
local SharedFolder = RS:FindFirstChild("Shared")
local _CHH = nil
local function GetPlayerOb()
    if not _CHH then
        local ok, result = pcall(require, SharedFolder:WaitForChild("ClientHumanoidHandler", 5))
        if ok and result then _CHH = result end
    end
    if not _CHH then return nil end
    return _CHH.Players[Plr]
end
local function OpenInventory()
    local pOb = GetPlayerOb()
    if not pOb or not pOb.gui then
        notyuri("[OpenInventory] pOb or gui not found")
        return
    end
    local ok, err = pcall(function() pOb.gui:OpenGui("Inventory") end)
    if not ok then
        notyuri("[OpenInventory] OpenGui failed:", err)
    else
        notyuri("[OpenInventory] OpenGui called ok")
    end
end
local GameData = {

    ItemData = GetSafeModule(SharedFolder, "ItemData"),
    UpgradeData = GetSafeModule(SharedFolder, "UpgradeData"),
    MapData = GetSafeModule(SharedFolder, "MapData"),
    DifficultyData = GetSafeModule(SharedFolder, "DifficultyData"),
    ModifierData = GetSafeModule(SharedFolder, "ModifierData"),
}
local Flags = {}
local Shared = {
    selectedCards = {},
    selectedBuyItems = {},
    selectedPlaceItems = {},
    availableCards = {},
}
local Tables = {
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local function LoadMDir()
    if not writefile then return end
    pcall(function()
        if not isfolder(MDir) then
            makefolder(MDir)
        end
    end)
end
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
    if type(data) ~= "table" or type(data.actions) ~= "table" then return nil end
    return data
end
local function SaveMacro(name, macro)
    if not name or name == "" or not writefile then return false end
    LoadMDir()
    macro.name = name
    macro.v = 1
    local path = MDir .. "/" .. name .. ".json"
    local ok = pcall(function()
        local raw = HttpService:JSONEncode(macro)
        writefile(path, raw)
    end)
    return ok
end
local function DeleteMacro(name)
    if not name or name == "" or not delfile then return false end
    local path = MDir .. "/" .. name .. ".json"
    if isfile(path) then pcall(delfile, path) return true end
    return false
end
local function CFrameToArr(cf)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function ArrToCFrame(arr)
    if type(arr) ~= "table" or #arr < 12 then return CFrame.new() end
    return CFrame.new(
        arr[1], arr[2], arr[3],
        arr[4], arr[5], arr[6],
        arr[7], arr[8], arr[9],
        arr[10], arr[11], arr[12]
    )
end
local function UpdateLabel(suffix)
    if MState.LabelRef and MState.LabelRef.SetText then
        local txt
        if MState.Rec then
            txt = string.format("Recording [%d]", MState.Step)
        elseif MState.Rep then
            txt = string.format("Replaying [%d / %d]", MState.Step, MState.Total)
        else
            txt = "Idle"
        end
        if suffix then txt = txt .. " | " .. suffix end
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
local function InstallMacroHook()
    if not Remotes.Network then return end
    if MState.Hooked then return end
    local originalNamecall
    originalNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local self = ...
        local Method = getnamecallmethod()
        local ret = table.pack(originalNamecall(...))
        if MState.Rec
            and Method == "FireServer"
            and rawequal(self, Remotes.Network) then
            local a1 = select(2, ...)
            local a2 = select(3, ...)
            local a3 = select(4, ...)
            task.defer(function()
                if type(a1) == "string" and a1 == "place"
                    and typeof(a2) == "Instance" and typeof(a3) == "CFrame" then
                    local now = os.clock()
                    local delay = MState.Cur and (now - (MState.Cur.lastT or now)) or 0
                    if MState.Cur then
                        table.insert(MState.Cur.actions, {
                            item = a2.Name,
                            cf = CFrameToArr(a3),
                            d = math.min(delay, 10),
                        })
                        MState.Cur.lastT = now
                        MState.Step = #MState.Cur.actions
                        UpdateLabel(a2.Name)
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
    if state then
        if Toggles.LoadMacro and Toggles.LoadMacro.Value then
            Toggles.LoadMacro:SetValue(false)
        end
        InstallMacroHook()
        MState.Rec = true
        MState.Rep = false
        MState.Step = 0
        MState.Cur = { name = "Macro_" .. os.date("%Y%m%d_%H%M%S"), actions = {}, lastT = os.clock() }
        UpdateLabel()
        task.spawn(LabelPump)
        notyuri("[Macro Rec] recording started")
    else
        MState.Rec = false
        notyuri("[Macro Rec] recording stopped,", MState.Cur and #MState.Cur.actions or 0, "actions")
        if MState.Cur and #MState.Cur.actions > 0 then
            local fname = (Options.FileName and Options.FileName.Value) or ""
            if fname == "" then fname = MState.Cur.name end
            fname = fname:gsub("[^A-Za-z0-9_%-]", "_")
            if SaveMacro(fname, MState.Cur) then
                Library:Notify("Saved: " .. fname .. " (" .. #MState.Cur.actions .. " steps)", 5)
            end
            if Options.MacroSelected then Options.MacroSelected:SetValues(ListMacros()) end
        end
        MState.Cur = nil
        MState.Step = 0
        UpdateLabel()
    end
end
local function GetInput()
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    local islclosureFn = islclosure or is_l_closure or function() return true end
    local getscriptclosureFn = getscriptclosure or getscriptfunction
    notyuri("[GetInput] dbgGetUpvals:", dbgGetUpvals ~= nil, "getscriptclosureFn:", getscriptclosureFn ~= nil, "getgc:", getgc ~= nil)
    if dbgGetUpvals then
        local clientScript
        pcall(function()
            clientScript = Plr:WaitForChild("PlayerScripts", 3)
                :WaitForChild("Client", 3):WaitForChild("Client", 3)
        end)
        notyuri("[GetInput] clientScript:", clientScript)
        if clientScript then
            local mainClosure
            if getscriptclosureFn then
                local ok, fn = pcall(getscriptclosureFn, clientScript)
                notyuri("[GetInput] getscriptclosure ok:", ok, "fn:", fn)
                if ok and fn then mainClosure = fn end
            end
            if not mainClosure and getgc then
                local ok, gc = pcall(getgc, false)
                notyuri("[GetInput] getgc ok:", ok, "count:", gc and #gc)
                if ok and gc then
                    for _, fn in ipairs(gc) do
                        if type(fn) ~= "function" then continue end
                        if not islclosureFn(fn) then continue end
                        local ok2, env = pcall(getfenv, fn)
                        if not ok2 or not env then continue end
                        if rawget(env, "script") == clientScript then
                            mainClosure = fn
                            break
                        end
                    end
                end
            end
            notyuri("[GetInput] mainClosure:", mainClosure)
            if mainClosure then
                local ok3, uvs = pcall(dbgGetUpvals, mainClosure)
                notyuri("[GetInput] getupvals ok:", ok3, "count:", uvs and #uvs)
                if ok3 and uvs then
                    for i, v in pairs(uvs) do
                        if type(v) ~= "table" then continue end
                        local charOb = rawget(v, "charOb")
                        if type(charOb) ~= "table" then
                            notyuri("[GetInput] uv[" .. tostring(i) .. "] has no charOb, keys:", (function() local k={} for kk in pairs(v) do k[#k+1]=tostring(kk) end return table.concat(k,",") end)())
                            continue
                        end
                        local inp = rawget(charOb, "input")
                        notyuri("[GetInput] charOb found, inp:", inp, "type:", type(inp))
                        if type(inp) == "table" and type(rawget(inp, "StartPlacingObject")) == "function" then
                            notyuri("[GetInput] SUCCESS via getgc path")
                            return inp
                        end
                    end
                end
            end
        end
    end
    local ok, CHH = pcall(require, RS:WaitForChild("Shared").ClientHumanoidHandler)
    notyuri("[GetInput] CHH ok:", ok, "CHH:", CHH ~= nil)
    if ok and CHH then
        local pOb = CHH.Players[Plr]
        notyuri("[GetInput] pOb:", pOb, "charOb:", pOb and pOb.charOb)
        if pOb and pOb.charOb then
            local inp = pOb.charOb.input
            notyuri("[GetInput] CHH inp:", inp, "StartPlacingObject:", inp and inp.StartPlacingObject)
            if inp and inp.StartPlacingObject then
                notyuri("[GetInput] SUCCESS via CHH path")
                return inp
            end
        end
    end
    notyuri("[GetInput] FAILED, returning nil")
    return nil
end
local function Func_MacroReplay()
    while Toggles.LoadMacro.Value do
        local macro = MState.Load
        if not macro or not macro.actions or #macro.actions == 0 then
            Toggles.LoadMacro:SetValue(false)
            break
        end
        if Toggles.AutoPlace and Toggles.AutoPlace.Value then
            Toggles.AutoPlace:SetValue(false)
        end
        if Toggles.AutoBuy and Toggles.AutoBuy.Value then
            Toggles.AutoBuy:SetValue(false)
        end
        MState.Rep = true
        MState.Total = #macro.actions
        for i, action in ipairs(macro.actions) do
            if not Toggles.LoadMacro.Value then break end
            MState.Step = i
            local key = action.item
            local targetCF = ArrToCFrame(action.cf)
            UpdateLabel(key or "?")
            local id = GameData.ItemData
            local itemData = id and (
                (id.Items and id.Items[key])
                or (id.CrownItems and id.CrownItems[key])
                or (id.TutorialItemData and id.TutorialItemData[key])
            )
            local price = itemData and itemData.Price
            local alreadyOwned = false
            if price then
                while Toggles.LoadMacro.Value do
                    local invOk, invList = pcall(function() return Remotes.GetOtherData:InvokeServer("Inventory") end)
                    if invOk and type(invList) == "table" and invList[key] and invList[key] > 0 then
                        alreadyOwned = true
                        break
                    end
                    local cash = Plr:GetAttribute("Cash") or 0
                    if cash >= price then break end
                    task.wait(0.5)
                end
                if not Toggles.LoadMacro.Value then break end
            end
            if not alreadyOwned then
                SafeInvoke(Remotes.BoughtItem, key, nil)
            end
            local input = GetInput()
            if not input then
                repeat task.wait(0.1) input = GetInput() until input or not Toggles.LoadMacro.Value
            end
            if not Toggles.LoadMacro.Value then break end
            OpenInventory()
            local holder, click
            repeat
                task.wait(0.1)
                holder = PGui:FindFirstChild("HUD")
                    and PGui.HUD:FindFirstChild("Inventory")
                    and PGui.HUD.Inventory:FindFirstChild("Back")
                    and PGui.HUD.Inventory.Back:FindFirstChild("Holder")
                local slot = holder and holder:FindFirstChild(key, true)
                click = slot and slot:FindFirstChild("Click")
            until (click) or not Toggles.LoadMacro.Value
            if not Toggles.LoadMacro.Value then break end
            if input.state ~= "idle" then
                repeat task.wait(0.1) until input.state == "idle" or not Toggles.LoadMacro.Value
            end
            if not Toggles.LoadMacro.Value then break end
            fire_event(click.Activated)
            local waitStart = tick()
            repeat task.wait(0.05) until (input.object and input.object.PrimaryPart) or (tick() - waitStart > 3) or not Toggles.LoadMacro.Value
            if input.object and input.object.PrimaryPart then
                pcall(function() input.object:PivotTo(targetCF) end)
                input.moving = true
                pcall(function() input:OnGrabEnded() end)
            else
                if input.state == "building" then
                    input.moving = true
                    pcall(function() input:OnGrabEnded() end)
                end
            end
            task.wait(0.2)
        end
        MState.Rep = false
        MState.Step = 0
        UpdateLabel("done")
    end
    MState.Rep = false
    UpdateLabel()
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
            notyuri("Error in ["..name.."]: "..tostring(err))
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
local function GetSeller()
    local buildingParts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("BuildingParts")
    if not buildingParts then return nil end
    for _, child in ipairs(buildingParts:GetChildren()) do
        if string.find(child.Name, "Seller") then
            local sellPart = child:FindFirstChild("Sell")
            if sellPart and sellPart:IsA("BasePart") then
                return sellPart
            end
        end
    end
    return nil
end
local function IsValidPart(model)
    if not model:IsA("Model") then return false end
    if not model.PrimaryPart then return false end
    if model:GetAttribute("type") ~= "part" then return false end
    if model:GetAttribute("sold") then return false end
    if model:GetAttribute("destroyed") then return false end
    return true
end
local function GetCurrentRound()
    local map = workspace:FindFirstChild("Map")
    return (map and tonumber(map:GetAttribute("round"))) or 0
end
local function GetGameState()
    local map = workspace:FindFirstChild("Map")
    return map and map:GetAttribute("state") or nil
end
local function GetCurrentMap()
    local map = workspace:FindFirstChild("Map")
    return map and map:GetAttribute("Map") or nil
end
local function MovePart(part, targetCFrame)
    if not (part and part.PrimaryPart) then return end
    pcall(function() Remotes.Network:FireServer("pickup", part) end)
    task.wait()
    pcall(function() part:PivotTo(targetCFrame) end)
    task.wait()
    pcall(function() Remotes.Network:FireServer("drop", part) end)
end
local function GetUpgraders()
    local list = {}
    local function scan(folder)
        if not folder then return end
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("Model") and string.find(child.Name, "Upgrader") then
                local hit = child:FindFirstChild("Hitbox")
                if hit and hit:IsA("BasePart") then
                    table.insert(list, { name = child.Name, hitbox = hit })
                end
            end
        end
    end
    scan(workspace:FindFirstChild("BuildingParts"))
    local map = workspace:FindFirstChild("Map")
    if map then scan(map:FindFirstChild("BuildingParts")) end
    return list
end
local function Func_AutoSell()
    while Toggles.AutoSell.Value do
        local sellPart = GetSeller()
        if sellPart then
            local sellCFrame = sellPart.CFrame
            local partsFolder = GetObject(workspace, "Parts") 
            if partsFolder then
                local upgraders = GetUpgraders()
                for _, model in ipairs(partsFolder:GetChildren()) do
                    if not Toggles.AutoSell.Value then break end
                    if IsValidPart(model) and model.PrimaryPart then
                        for _, upg in ipairs(upgraders) do
                            if not Toggles.AutoSell.Value then break end
                            if not IsValidPart(model) then break end
                            MovePart(model, upg.hitbox.CFrame * CFrame.new(0, 2, 0))
                            task.wait()
                        end
                        if IsValidPart(model) then
                            MovePart(model, sellCFrame)
                            task.wait()
                        end
                    end
                end
            else
                notyuri("[AutoSell] workspace.Parts not found yet")
            end
        else
            notyuri("[AutoSell] Seller not found in workspace.Map.BuildingParts")
        end
        task.wait(0.1)
    end
end
local function Func_AutoSkipRound()
    while Toggles.AutoSkipRound.Value do
        local state = GetGameState()
        if state == "playing" or state == "starting" then
            local cur = GetCurrentRound()
            local minRound = 1
            if Options.MinRoundToSkip and Options.MinRoundToSkip.Value then
                minRound = tonumber(Options.MinRoundToSkip.Value) or 1
            end
            if cur >= minRound then
                SafeInvoke(Remotes.GameEvent, "skipRound")
            end
        end
        task.wait(1)
    end
end
local function Func_AutoNextRound()
    while Toggles.AutoNextRound.Value do
        local state = GetGameState()
        if state ~= "playing" and state ~= "starting" then
            SafeInvoke(Remotes.GameEvent, "nextRound")
        end
        task.wait(1)
    end
end
local RARITY_ORDER_FALLBACK = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Winter" }
local function GetRarityRank(rarityName)
    local order = (GameData.Rarity and GameData.Rarity.RarityOrder) or RARITY_ORDER_FALLBACK
    for i, name in ipairs(order) do
        if name == rarityName then return i end
    end
    return 0
end
local function GetCardRarity(cardKey)
    local ud = GameData.UpgradeData
    if ud and ud.Upgrades then
        local data = ud.Upgrades[cardKey]
        if type(data) == "table" and data.Rarity then return data.Rarity end
    end
    return nil
end
local _cardsHookInstalled = false
local _origLoadCards = nil
local function InstallLoadCardsHook()
    if _cardsHookInstalled then return end
    if not hookfunction then
        notyuri("[Cards] hookfunction not available")
        return
    end
    local pOb = GetPlayerOb()
    if not pOb or not pOb.gui or type(pOb.gui.LoadCards) ~= "function" then
        notyuri("[Cards] pOb.gui.LoadCards not found, cannot hook")
        return
    end
    local ok, err = pcall(function()
        _origLoadCards = hookfunction(pOb.gui.LoadCards, newcclosure(function(p1, p2, p3)
            Shared.availableCards = {}
            if type(p2) == "table" then
                for _, v in ipairs(p2) do
                    table.insert(Shared.availableCards, v)
                end
            end
            return _origLoadCards(p1, p2, p3)
        end))
    end)
    if ok then
        _cardsHookInstalled = true
        notyuri("[Cards] LoadCards hook installed")
    else
        notyuri("[Cards] LoadCards hook failed:", err)
    end
end
local function GetAvailableCards()
    InstallLoadCardsHook()
    return Shared.availableCards
end
local function Func_AutoVoteCards()
    while Toggles.AutoVoteCards.Value do
        local available = GetAvailableCards()
        if #available > 0 then
            local voteKey = nil
            for _, card in ipairs(Shared.selectedCards) do
                local key = card:match("^([^|]+)") or card
                if key ~= "" then
                    for _, name in ipairs(available) do
                        if name == key then
                            voteKey = key
                            break
                        end
                    end
                end
                if voteKey then break end
            end
            if not voteKey then
                local best, bestRank = nil, -1
                for _, name in ipairs(available) do
                    local rarity = GetCardRarity(name)
                    local rank = rarity and GetRarityRank(rarity) or 0
                    if rank > bestRank then
                        bestRank = rank
                        best = name
                    end
                end
                voteKey = best
                if voteKey then
                end
            end
            if voteKey then
                SafeInvoke(Remotes.Cards, "vote", voteKey)
            end
        end
        task.wait(2)
    end
end
local function Func_AutoRetry()
    while Toggles.AutoRetry.Value do
        local state = GetGameState()
        if state == "ended" or state == nil then
            pcall(function() Remotes.GameEndedEvent:FireServer("Again") end)
        end
        task.wait(2)
    end
end
local function Func_AutoBuy()
    while Toggles.AutoBuy.Value do
        for _, item in ipairs(Shared.selectedBuyItems) do
            if not Toggles.AutoBuy.Value then break end
            if item and item ~= "" then
                local key = item:match("^([^|]+)") or item
                SafeInvoke(Remotes.BoughtItem, key, nil)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoPlace()
    while Toggles.AutoPlace.Value do
        local input
        repeat 
            input = GetInput()
            task.wait(0.1)  
        until input
        OpenInventory()
        -- wait for inventory panel to be open
        local t = tick()
        repeat task.wait(0.05) until
            (PGui:FindFirstChild("HUD")
                and PGui.HUD:FindFirstChild("Inventory")
                and PGui.HUD.Inventory:FindFirstChild("Back")
                and PGui.HUD.Inventory.Back:FindFirstChild("Holder"))
            or (tick() - t > 3)
        for _, item in ipairs(Shared.selectedPlaceItems) do
            if not Toggles.AutoPlace.Value then break end
            if not (item and item ~= "") then continue end
            local key = item:match("^([^|]+)") or item
            local sellPart = GetSeller()
            if not sellPart then
                continue
            end
            local targetCF = sellPart.CFrame * CFrame.new(0, 10, 0)
            local holder = PGui:FindFirstChild("HUD")
                and PGui.HUD:FindFirstChild("Inventory")
                and PGui.HUD.Inventory:FindFirstChild("Back")
                and PGui.HUD.Inventory.Back:FindFirstChild("Holder")
            local slot = holder and holder:FindFirstChild(key, true)
            local click = slot and slot:FindFirstChild("Click")
            if input and click then
                if input.state ~= "idle" then
                    notyuri("[AutoPlace] input busy, skipping:", key)
                    task.wait(0.5)
                    continue
                end
                fire_event(click.Activated)
                local waitStart = tick()
                repeat task.wait(0.05)
                until (input.object and input.object.PrimaryPart) or (tick() - waitStart > 3) or not Toggles.AutoPlace.Value
                if input.object and input.object.PrimaryPart then
                    pcall(function() input.object:PivotTo(targetCF) end)
                    input.moving = true
                    pcall(function() input:OnGrabEnded() end)
                    notyuri("[AutoPlace] placed at seller:", key)
                end
            end
            task.wait(0.3)
        end
        task.wait(0.3)
    end
end
local function Func_AutoVoteDifficulty()
    while Toggles.AutoVoteDifficulty.Value do
        local mode = Options.VoteDifficulty and Options.VoteDifficulty.Value or nil
        if mode and mode ~= "" then
            SafeInvoke(Remotes.Difficulty, "vote", mode)
        end
        task.wait(2)
    end
end
local function Func_AutoDropper()
    while Toggles.AutoDropper.Value do
        local bp = workspace:FindFirstChild("BuildingParts")
        if bp then
            local dropperModel = bp:FindFirstChild("Dropper")
            local dropperPart = dropperModel and dropperModel:FindFirstChild("Dropper")
            local pp = dropperPart and dropperPart:FindFirstChildOfClass("ProximityPrompt")
            if pp and pp.Enabled then
                FirePP(pp, true)
            else
                for _, child in ipairs(bp:GetChildren()) do
                    if child:IsA("Model") and string.find(child.Name, "Dropper") then
                        local part = child:FindFirstChild("Dropper") or child.PrimaryPart
                        local p = part and part:FindFirstChildOfClass("ProximityPrompt")
                        if p and p.Enabled then FirePP(p, true) end
                    end
                end
            end
        end
        task.wait(0.3)
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
        Macro = TB.Main.Left.Autofarm:AddTab("Macro"),
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
local function BuildItemList()
    local list = {}
    local id = GameData.ItemData
    if id then
        local function add(from)
            if not from then return end
            for name, data in pairs(from) do
                local rarity = (type(data) == "table" and data.Rarity) or "?"
                table.insert(list, name .. "|" .. rarity)
            end
        end
        add(id.Items)
        add(id.CrownItems)
        add(id.TutorialItemData)
    end
    table.sort(list)
    return list
end
local function BuildCardList()
    local list = {}
    local ud = GameData.UpgradeData
    if ud and ud.Upgrades then
        for name, data in pairs(ud.Upgrades) do
            local rarity = (type(data) == "table" and data.Rarity) or "?"
            table.insert(list, name .. "|" .. rarity)
        end
    end
    table.sort(list)
    return list
end
local function BuildMapList()
    local list = {}
    local md = GameData.MapData
    if md and md.Maps then
        for name in pairs(md.Maps) do
            if name ~= "Tutorial" then table.insert(list, name) end
        end
    end
    table.sort(list)
    return list
end
local function BuildDifficultyList()
    local list = {}
    local dd = GameData.DifficultyData
    if dd and dd.ModesList then
        for _, mode in ipairs(dd.ModesList) do table.insert(list, mode) end
    end
    return list
end
local function BuildModifierList()
    local list = {}
    local md = GameData.ModifierData
    if md and md.ModifiersList then
        for _, mod in ipairs(md.ModifiersList) do table.insert(list, mod) end
    end
    return list
end
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", {
    Text = "Auto Sell",
    Default = false,
})
Toggles.AutoSell:OnChanged(function(v)
    Thread("AutoSell", Func_AutoSell, v)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoSkipRound", {
    Text = "Skip Round",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddInput("MinRoundToSkip", {
    Text = "Min Round to Skip",
    Default = "1",
    Numeric = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoNextRound", {
    Text = "Next Round",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoRetry", {
    Text = "Auto Retry",
    Default = false,
})
Toggles.AutoSkipRound:OnChanged(function(v) Thread("AutoSkipRound", Func_AutoSkipRound, v) end)
Toggles.AutoNextRound:OnChanged(function(v) Thread("AutoNextRound", Func_AutoNextRound, v) end)
Toggles.AutoRetry:OnChanged(function(v) Thread("AutoRetry", Func_AutoRetry, v) end)
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteCards", {
    Text = "Auto Vote Cards",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("VoteCard", {
    Text = "Cards",
    Values = BuildCardList(),
    Default = {},
    Multi = true,
    Searchable = true,
})
Options.VoteCard:OnChanged(function()
    Shared.selectedCards = {}
    for name, active in pairs(Options.VoteCard.Value) do
        if active then table.insert(Shared.selectedCards, name) end
    end
end)
Toggles.AutoVoteCards:OnChanged(function(v) Thread("AutoVoteCards", Func_AutoVoteCards, v) end)
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", {
    Text = "Auto Buy",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("BuyItem", {
    Text = "Buy",
    Values = BuildItemList(),
    Default = {},
    Multi = true,
    Searchable = true,
})
Options.BuyItem:OnChanged(function()
    Shared.selectedBuyItems = {}
    for name, active in pairs(Options.BuyItem.Value) do
        if active then table.insert(Shared.selectedBuyItems, name) end
    end
end)
Toggles.AutoBuy:OnChanged(function(v) Thread("AutoBuy", Func_AutoBuy, v) end)
TB_Tabs.Autofarm.T1:AddToggle("AutoPlace", {
    Text = "Auto Place",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("PlaceItem", {
    Text = "Builds",
    Values = BuildItemList(),
    Default = {},
    Multi = true,
    Searchable = true,
})
Options.PlaceItem:OnChanged(function()
    Shared.selectedPlaceItems = {}
    for name, active in pairs(Options.PlaceItem.Value) do
        if active then table.insert(Shared.selectedPlaceItems, name) end
    end
end)
Toggles.AutoPlace:OnChanged(function(v) Thread("AutoPlace", Func_AutoPlace, v) end)
TB_Tabs.Autofarm.T1:AddToggle("AutoVoteDifficulty", {
    Text = "Auto Vote Difficulty",
    Default = false,
})
TB_Tabs.Autofarm2.T1:AddDropdown("VoteDifficulty", {
    Text = "Difficulty",
    Values = BuildDifficultyList(),
    Default = BuildDifficultyList()[1] or "",
    Searchable = true,
})
Toggles.AutoVoteDifficulty:OnChanged(function(v) Thread("AutoVoteDifficulty", Func_AutoVoteDifficulty, v) end)
TB_Tabs.Autofarm.T1:AddToggle("AutoDropper", {
    Text = "Auto Dropper",
    Default = false,
})
Toggles.AutoDropper:OnChanged(function(v) Thread("AutoDropper", Func_AutoDropper, v) end)
TB_Tabs.Autofarm.Macro:AddDropdown("MacroSelected", {
    Text = "Select File",
    Values = ListMacros(),
    Default = ListMacros()[1] or "",
})
Options.MacroSelected:OnChanged(function(v)
    if v and v ~= "" then
        MState.Load = LoadMacro(v)
        if not MState.Load then
            Library:Notify("Failed to load macro: " .. v, 4)
        end
    end
end)
TB_Tabs.Autofarm.Macro:AddInput("FileName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
})
TB_Tabs.Autofarm.Macro:AddToggle("MacroRecord", {
    Text = "Record Macro",
    Default = false,
})
TB_Tabs.Autofarm.Macro:AddToggle("LoadMacro", {
    Text = "Load Macro",
    Default = false,
})
MState.LabelRef = TB_Tabs.Autofarm.Macro:AddLabel("Idle", true)
Toggles.LoadMacro:OnChanged(function(v)
    if v then
        if not MState.Load then
            local name = Options.MacroSelected and Options.MacroSelected.Value or ""
            if name and name ~= "" then
                MState.Load = LoadMacro(name)
            end
        end
        if not MState.Load then
            Library:Notify("No macro selected", 3)
            Toggles.LoadMacro:SetValue(false)
            return
        end
    end
    Thread("LoadMacro", SafeLoop("Macro Replay", Func_MacroReplay), v)
end)
Toggles.MacroRecord:OnChanged(function(v)
    Func_MacroRecord(v)
end)
LoadMDir()
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
SaveManager:SetFolder("Yuri/Quantify")
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
