if getgenv().ayasemiyakissazumirsa then
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
local productInfoOk, productInfo = pcall(function()
    return Marketplace:GetProductInfo(game.PlaceId)
end)
local assetName = "game name"
if productInfoOk and productInfo then
    assetName = productInfo.Name
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
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local executorName = executorDisplayName:lower()
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
getgenv().ayasemiyakissazumirsa = true
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
local scriptLoadOk, scriptLoadErr = pcall(function()
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
local Remotes = {
}
local Flags = {}
local Constants = {
    SupportedFoodTypes = { Waffle = true, Pancake = true, Coffee = true, ["Decaf Coffee"] = true, ["Creamer Coffee"] = true, ["Iced Creamer Coffee"] = true, Milkshake = true, ["Orange Juice"] = true, ["Banana Juice"] = true, ["Apple Juice"] = true, Croissant = true },
    DirtyPlate = "Dirty Plate",
    PAN_TOOL_NAMES = { "Pan", "Seasoned Pan" },
    SUGAR_TOOL_NAMES = { "Sugar Bag", "Sugar Cube" },
    TT = "Tea Cup",
    FOG_END_DISTANCE = 9e9,
    ANTI_KB_MAX_FORCE = Vector3.new(40000, 40000, 40000),
    FPS_CAP_FALLBACK = 999,
    MinigameCompletePayloads = {
        PowerBreaker = {
            Multiplier = 1,
            ResultData = {
                Success = true,
                Matches = 4,
            },
        },
        CryoRepair = {
            Multiplier = 1,
            ResultData = {
                Success = true,
                GoodHits = 2,
                Tries = 2,
            },
        },
        Milkshake = {
            Multiplier = 2.5,
        },
        Knife = {
            Multiplier = 2.5,
        },
        CleanPlates = {
            Multiplier = 1,
            ResultData = {
                Success = true,
            },
        },
        Coffee = {
            Multiplier = 2.5,
            ResultData = {
                Tries = 3,
                BadCount = 0,
            },
        },
        Croissant = {
            Multiplier = 1,
            ResultData = {
                Success = true,
            },
        },
    },
    MAX_CONCURRENT_ORDERS = 3,
}
local State = {
    BowlsInUse = {},
    CustomerESPPool = {
        Free = {},
        Active = {},
    },
    CustomerESPHighlights = {},
    HandledMinigameRequestIds = {},
    CroissantMinigameLastFired = 0,
    InFlightOrderIds = {},
    InFlightCount = 0,
    CookingMinigameStartRefCount = 0,
}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
    AutoSkipDialogue = nil,
}
local function AddMultiDropdown(group, id, config)
    config = config or {}
    local labelId = config.label
    group:AddDropdown(id, {
        Text = config.Text,
        Values = config.Values,
        Default = config.Default or {},
        Multi = true,
        Searchable = true,
        Callback = config.Callback,
    })
    return function()
        local labels = (Options[id] and Options[id].Value) or {}
        local ids = {}
        for label, active in pairs(labels) do
            if active then
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
        notyuri("Your executor does not support firesignal or getconnections.")
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
    return (c and GetObject(c, "HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid")) and c or nil
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
                if child:IsA("BodyVelocity") and child.MaxForce == Constants.ANTI_KB_MAX_FORCE then
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
                local promptOverlay = GetObject(game:GetService("CoreGui"), "RobloxPromptGui")
                if promptOverlay then
                    local errorPrompt = GetObject(promptOverlay.promptOverlay, "ErrorPrompt")
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
        local ok, err = pcall(function()
            local pauseGui = GetObject(game:GetService("CoreGui").RobloxGui, "CoreScripts/NetworkPause")
            if pauseGui then
                pauseGui:Destroy()
            end
        end)
        if not ok then
            notyuri("NoGameplayPaused error: " .. tostring(err))
        end
        task.wait(1)
    end
end
local function ApplyFPSBoost(state)
    if not state then return end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = Constants.FOG_END_DISTANCE
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
function GamepadSelectAndConfirm(guiObject)
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
    if teleport then
        local char = GetCharacter()
        local hrp = char and GetObject(char, "HumanoidRootPart")
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
            local pos = isModel and part:GetPivot().Position or part.Position
            if (hrp.Position - pos).Magnitude > target.MaxActivationDistance then
                TPTo(part)
                task.wait(0.2)
            end
        end
    end
    fireproximityprompt(target)
end
local function FireTI(target)
    if not firetouchinterest then
        return
    end
    local root = Plr.Character and GetObject(Plr.Character, "HumanoidRootPart")
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
local function LoadModule(parent, name, warnMessage)
    local mod = parent and GetSafeModule(parent, name) or nil
    if not mod and warnMessage then
        notyuri(warnMessage)
    end
    return mod
end
local Parents = {
    SharedConfig = GetObject(RS, "Shared.Config"),
    SharedConstants = GetObject(RS, "Shared.Constants"),
    SharedModules = GetObject(RS, "Shared.Modules"),
    ClientModules = GetObject(Plr, "PlayerScripts.Client.Modules"),
    PackagesFolder = GetObject(RS, "Packages"),
}
local Modules = {
    CafeOrderGuideConfig = LoadModule(Parents.SharedConfig, "CafeOrderGuideConfig"),
    CafeConfig = LoadModule(Parents.SharedConfig, "CafeConfig"),
    UpgradesConfig = LoadModule(Parents.SharedConfig, "Upgrades"),
    RunState = LoadModule(Parents.SharedConstants, "RunState"),
    BackpackUtil = LoadModule(Parents.SharedModules, "BackpackUtil"),
    CafeOrderGuideResolver = LoadModule(Parents.ClientModules, "CafeOrderGuideResolver"),
    BridgeNet2 = LoadModule(Parents.PackagesFolder, "BridgeNet2"),
    PartyGameModes = LoadModule(Parents.SharedConfig, "PartyGameModes"),
}
local BridgeNet2 = Modules.BridgeNet2
local PartyGameModes = Modules.PartyGameModes
local function GetSessionUpgrades()
    if not Modules.UpgradesConfig then return {} end
    local raw = RS:GetAttribute("CafeUpgrades")
    if typeof(raw) ~= "string" then
        return Modules.UpgradesConfig.GetDefaultLevels()
    end
    local ok, result = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if ok and typeof(result) == "table" then
        return result
    end
    return Modules.UpgradesConfig.GetDefaultLevels()
end
local function SafeReferenceBridge(name)
    if not BridgeNet2 then return nil end
    local ok, result = pcall(BridgeNet2.ReferenceBridge, name)
    if ok then
        return result
    end
    notyuri("BridgeNet2.ReferenceBridge(\"" .. name .. "\") failed/timed out - skipping: " .. tostring(result))
    return nil
end
local _bridgeCache = {}
local function GetBridge(name)
    if _bridgeCache[name] then
        return _bridgeCache[name]
    end
    local bridge = SafeReferenceBridge(name)
    if bridge then
        _bridgeCache[name] = bridge
    end
    return bridge
end
local Scriptables = GetObject(workspace, "Scriptables")
local function ReadOrderState(orderFrame)
    local toppings = {}
    if Modules.CafeOrderGuideConfig then
        for _, toppingName in ipairs(Modules.CafeOrderGuideConfig.ToppingAttributes) do
            toppings[toppingName] = orderFrame:GetAttribute("Topping_" .. toppingName) == true
        end
    end
    return {
        OrderId = orderFrame:GetAttribute("OrderId"),
        CustomerId = orderFrame:GetAttribute("CustomerId"),
        RecipeId = orderFrame:GetAttribute("RecipeId"),
        RecipeName = orderFrame:GetAttribute("RecipeName"),
        FoodType = orderFrame:GetAttribute("FoodType") or orderFrame:GetAttribute("RecipeId"),
        Doneness = orderFrame:GetAttribute("Doneness"),
        Flavor = orderFrame:GetAttribute("Flavor"),
        Plate = orderFrame:GetAttribute("Plate"),
        Syrup = orderFrame:GetAttribute("Syrup"),
        WhippedCream = orderFrame:GetAttribute("WhippedCream"),
        Toppings = toppings,
    }
end
local function GetOrderBoard()
    local ordersModel = GetObject(Scriptables, "Orders")
    return ordersModel and GetObject(ordersModel, "OrderFrame.SurfaceGui.OrderBoard")
end
local function GetSupportedOrders(excludeOrderIds)
    local list = {}
    local OrderBoard = GetOrderBoard()
    if not OrderBoard then return list end
    for _, child in ipairs(OrderBoard:GetChildren()) do
        if child:IsA("Frame") and child.Name:sub(1, 6) == "Order_" then
            local state = ReadOrderState(child)
            if state.FoodType and Constants.SupportedFoodTypes[state.FoodType] then
                if not (excludeOrderIds and excludeOrderIds[state.OrderId]) then
                    table.insert(list, state)
                end
            end
        end
    end
    return list
end
local function ForEachOwnedTool(predicateFn)
    local char = Plr.Character
    local held = char and char:FindFirstChildOfClass("Tool")
    if held then
        local a, b = predicateFn(held)
        if a then return a, b end
    end
    local backpack = Plr:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local a, b = predicateFn(tool)
                if a then return a, b end
            end
        end
    end
    return nil
end
local function GetTool(name)
    return ForEachOwnedTool(function(tool)
        if not name or tool.Name == name then
            return tool
        end
        return nil
    end)
end
local function CanHoldMore(count)
    if not Modules.BackpackUtil then return true end 
    return Modules.BackpackUtil.CanAddTools(Plr, count or 1)
end
local function EquipTool(tool)
    if not tool then return end
    local char = Plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:EquipTool(tool)
    end
end
local function PlaceToolWithRetry(toolName, station, placePrompt, maxAttempts)
    maxAttempts = maxAttempts or 5
    local tool = GetTool(toolName)
    if not tool then
        notyuri("Not holding " .. toolName .. ", cannot place on " .. station.Name)
        return false
    end
    for attempt = 1, maxAttempts do
        if station:GetAttribute("Occupied") == true then
            return true
        end
        tool = GetTool(toolName)
        if not tool then
            notyuri("Lost " .. toolName .. " mid-placement (attempt " .. attempt .. ")")
            return false
        end
        EquipTool(tool)
        task.wait(0.1)
        FirePP(placePrompt, true)
        task.wait(0.25)
        if station:GetAttribute("Occupied") == true then
            return true
        end
        if attempt < maxAttempts then
            notyuri("" .. toolName .. " not placed on " .. station.Name .. ", retrying (" .. attempt .. "/" .. maxAttempts .. ")")
            task.wait(0.2)
        end
    end
    notyuri("Failed to place " .. toolName .. " on " .. station.Name .. " after " .. maxAttempts .. " attempts")
    return false
end
local function NewLock()
    local busy = false
    local lock
    lock = {
        wait = function()
            while busy do task.wait() end
            busy = true
        end,
        release = function()
            busy = false
        end,
        withLock = function(fn, ...)
            lock.wait()
            local results = table.pack(pcall(fn, ...))
            lock.release()
            if not results[1] then
                error(results[2], 0)
            end
            return table.unpack(results, 2, results.n)
        end,
    }
    return lock
end
local CharacterLock = NewLock()
local function RequireOrderGuideConfig(warnMessage)
    if not Modules.CafeOrderGuideConfig then
        notyuri(warnMessage)
        return false
    end
    return true
end
local function FindPickupPrompt(toolGivenName)
    local foodInteractables = GetObject(Scriptables, "Food Interactables")
    local PickupFolder = foodInteractables and GetObject(foodInteractables, "Pickup")
    if not PickupFolder then return nil end
    for _, model in ipairs(PickupFolder:GetChildren()) do
        local interactable = GetObject(model, "Interactable") or model
        if interactable:GetAttribute("ToolGiven") == toolGivenName then
            local prompt = interactable:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then return prompt end
        end
    end
    return nil
end
local function FindApplyPrompt(appliedIngredient, foodType)
    local foodInteractables = GetObject(Scriptables, "Food Interactables")
    local ApplyFolder = foodInteractables and GetObject(foodInteractables, "ApplyToHeldFood")
    if not ApplyFolder then return nil end
    for _, model in ipairs(ApplyFolder:GetChildren()) do
        local interactable = GetObject(model, "Interactable") or model
        if interactable:GetAttribute("AppliedIngredient") == appliedIngredient then
            local prompt = interactable:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then return prompt end
        end
    end
    return nil
end
local function ApplyIngredientToOrder(ingredientName, foodType)
    local applied = false
    CharacterLock.withLock(function()
        if not CanHoldMore(1) then
            notyuri("Backpack full (5/5), cannot apply " .. ingredientName)
            return
        end
        local prompt = FindApplyPrompt(ingredientName, foodType)
        if not prompt then
            notyuri("No apply prompt found for: " .. ingredientName)
            return
        end
        FirePP(prompt, true)
        task.wait(0.2)
        applied = true
    end)
    return applied
end
local function AcquireTool(toolName, noBackpackMsg, noPromptMsg, notReceivedMsg)
    local tool = GetTool(toolName)
    if tool then
        return tool
    end
    if not CanHoldMore(1) then
        notyuri(noBackpackMsg)
        return nil, "BackpackFull"
    end
    local pickupPrompt = FindPickupPrompt(toolName)
    if not pickupPrompt then
        notyuri(noPromptMsg)
        return nil, "NoPickupPrompt"
    end
    FirePP(pickupPrompt, true)
    task.wait(0.3)
    tool = GetTool(toolName)
    if not tool then
        notyuri(notReceivedMsg)
        return nil, "NotReceived"
    end
    return tool
end
local function GetBowlMissingIngredients(bowl)
    local required = (Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.RequiredBowlIngredients)
        or { "Scoop of Flour", "Egg", "Sugar Cube", "Uncapped Milk" }
    local attrMap = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.BowlIngredientAttributes or {}
    local missingIngredients = {}
    local debugGui = GetObject(bowl, "CookingBowlDebug")
    local bg = debugGui and GetObject(debugGui, "Background")
    for _, ingName in ipairs(required) do
        local attrName = attrMap[ingName]
        if attrName then
            if bowl:GetAttribute(attrName) ~= true then
                table.insert(missingIngredients, ingName)
            end
        elseif bg then
            local img = bg:FindFirstChild(ingName)
            if img and img:IsA("ImageLabel") then
                if img.ImageTransparency >= 0.5 and img.ImageTransparency <= 0.6 then
                    table.insert(missingIngredients, ingName)
                end
            else
                table.insert(missingIngredients, ingName)
            end
        else
            table.insert(missingIngredients, ingName) 
        end
    end
    return missingIngredients
end
local function FindFreeBatterBowl()
    if not Scriptables then return nil end
    for _, obj in ipairs(Scriptables:GetChildren()) do
        if obj.Name:sub(1, 10) == "BatterBowl" and not State.BowlsInUse[obj] then
            return obj
        end
    end
    return nil
end
local function WithBowlReservation(bowl, fn)
    State.BowlsInUse[bowl] = true
    local ok, err = pcall(fn)
    State.BowlsInUse[bowl] = nil
    return ok, err
end
local function FillBowl(bowl)
    local bowlPrompt = GetObject(bowl, "CookingPrompt")
    if not bowlPrompt then
        notyuri("BatterBowl CookingPrompt not found")
        return false
    end
    local missingIngredients = GetBowlMissingIngredients(bowl)
    for _, ingName in ipairs(missingIngredients) do
        if bowl:GetAttribute("Ready") == true then break end
        local shouldStop = false
        CharacterLock.withLock(function()
            local tool, failReason = AcquireTool(
                ingName,
                "Backpack full (5/5), cannot pick up ingredient: " .. ingName,
                "No pickup prompt found for ingredient: " .. ingName,
                "Did not receive expected tool: " .. ingName
            )
            if tool then
                EquipTool(tool)
                task.wait(0.1)
                FirePP(bowlPrompt, true)
                task.wait(0.3)
            elseif failReason == "BackpackFull" then
                shouldStop = true
            end
        end)
        if shouldStop then break end
    end
    return bowl:GetAttribute("Ready") == true
end
local function FillBowlAndGetBatter(bowl)
    if not FillBowl(bowl) then
        return nil
    end
    local batterName = Modules.CafeOrderGuideConfig.BatterTool or "Batter"
    local batterTool
    CharacterLock.withLock(function()
        if not CanHoldMore(1) then
            notyuri("Backpack full (5/5), cannot pick up Batter")
            return
        end
        local bowlPrompt = GetObject(bowl, "CookingPrompt")
        if bowlPrompt then
            FirePP(bowlPrompt, true)
            task.wait(0.3)
        end
        batterTool = GetTool(batterName)
    end)
    if not batterTool then
        notyuri("Failed to pick up " .. batterName .. " after filling bowl")
        return nil
    end
    return batterTool
end
local BridgeNetPackage = RS:FindFirstChild("ffrostflame_bridgenet2@1.0.0")
local DataRemoteEvent = BridgeNetPackage and GetObject(BridgeNetPackage, "dataRemoteEvent")
local function PollUntilTimeout(checkFn, timeoutSec, defaultTimeoutSec)
    local start = tick()
    repeat
        local result = checkFn()
        if result then
            return result
        end
        task.wait()
    until (tick() - start) > (timeoutSec or defaultTimeoutSec)
    return false
end
local function WaitForGrillCooked(grillPart, timeoutSec)
    return PollUntilTimeout(function()
        return grillPart:GetAttribute("CookingStage") == "Cooked"
    end, timeoutSec, 60)
end
local function WaitForPancakeFlipReady(grillPart, timeoutSec)
    local start = tick()
    local meter
    repeat
        local billboard = GetObject(grillPart, "CookingMeterBillboard")
        meter = billboard and GetObject(billboard, "PancakeMeterProgress")
        if meter then break end
        task.wait()
    until (tick() - start) > (timeoutSec or 60)
    if not meter then
        notyuri("PancakeMeterProgress not found on " .. grillPart.Name)
        return false
    end
    local lastValue = meter.Value
    repeat
        local currentValue = meter.Value
        if currentValue < lastValue then
            return true
        end
        lastValue = currentValue
        task.wait()
    until (tick() - start) > (timeoutSec or 60)
    return false
end
local function FindGrillInstances(grillName)
    local list = {}
    local GrillsFolder = GetObject(Scriptables, "Grills")
    if not GrillsFolder or not grillName then return list end
    for _, child in ipairs(GrillsFolder:GetChildren()) do
        if child.Name == grillName or child.Name:sub(1, #grillName) == grillName then
            table.insert(list, child)
        end
    end
    return list
end
local function FindFreeGrillInstance(grillName)
    for _, grillPart in ipairs(FindGrillInstances(grillName)) do
        if grillPart:GetAttribute("Occupied") ~= true then
            return grillPart
        end
    end
    return nil
end
local function FindGrillPromptByAction(grillPart, action)
    for _, child in ipairs(grillPart:GetChildren()) do
        if child.Name == "CookingPrompt" and child:GetAttribute("CookingGrillAction") == action then
            return child
        end
    end
    return nil
end
local function PlaceBatterOnGrill(foodType)
    if not RequireOrderGuideConfig("Modules.CafeOrderGuideConfig not loaded, cannot resolve grill/batter tool") then
        return nil
    end
    local recipeCfg = Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes[foodType]
    if not recipeCfg or not recipeCfg.GrillName then
        notyuri("No grill recipe config for FoodType: " .. tostring(foodType))
        return nil
    end
    local grillPart = FindFreeGrillInstance(recipeCfg.GrillName)
    if not grillPart then
        return nil
    end
    local takePrompt = FindGrillPromptByAction(grillPart, "Take")
    if not takePrompt then
        notyuri("Grill CookingPrompt (Take) not found on " .. grillPart.Name)
        return nil
    end
    local flipPrompt = FindGrillPromptByAction(grillPart, "Flip")
    if foodType == "Pancake" and not flipPrompt then
        notyuri("Grill CookingPrompt (Flip) not found on " .. grillPart.Name)
        return nil
    end
    local batterName = Modules.CafeOrderGuideConfig.BatterTool or "Batter"
    local placed = false
    CharacterLock.withLock(function()
        placed = PlaceToolWithRetry(batterName, grillPart, takePrompt)
    end)
    if not placed then
        return nil
    end
    return grillPart, takePrompt, flipPrompt
end
local function CollectWithBackpackGuard(pickupPrompt, fullMessage)
    local ok = true
    CharacterLock.withLock(function()
        if not CanHoldMore(1) then
            notyuri(fullMessage)
            ok = false
            return
        end
        FirePP(pickupPrompt, true)
        task.wait(0.2)
    end)
    return ok
end
local function WaitAndCollectFromGrill(grillPart, takePrompt, flipPrompt, foodType)
    if foodType == "Pancake" then
        local flipReady = WaitForPancakeFlipReady(grillPart, 90)
        if flipReady then
            CharacterLock.withLock(function()
                FirePP(flipPrompt, true)
                task.wait(0.2)
            end)
        end
    end
    local cooked = WaitForGrillCooked(grillPart, 90)
    if not cooked then
        notyuri("Timed out waiting for cook-complete on " .. grillPart.Name)
        return false
    end
    task.wait(0.2)
    return CollectWithBackpackGuard(takePrompt, "Backpack full (5/5), cannot pick up cooked food from grill")
end
local function FindStationInstance(stationName, free)
    if not Scriptables or not stationName then return nil end
    for _, descendant in ipairs(Scriptables:GetDescendants()) do
        if descendant.Name == stationName and descendant:GetAttribute("Occupied") ~= nil then
            local occupied = descendant:GetAttribute("Occupied") == true
            if free then
                if not occupied then return descendant end
            else
                if occupied then return descendant end
            end
        end
    end
    return nil
end
local function FindCroissantStations(nameList, attrName, freeOnly)
    local PromptsFolder = GetObject(workspace, "Main.Prompts")
    local list = {}
    local seen = {}
    if PromptsFolder and nameList then
        for _, name in ipairs(nameList) do
            local inst = PromptsFolder:FindFirstChild(name)
            if inst and not seen[inst] and (not freeOnly or inst:GetAttribute("Occupied") ~= true) then
                seen[inst] = true
                table.insert(list, inst)
            end
        end
    end
    return list
end
local function FindFreeCroissantPinBoard()
    local recipeCfg = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes["Croissant"]
    local nameList = recipeCfg and recipeCfg.PinBoardNames
    return FindCroissantStations(nameList, "CroissantPinBoardSubject")[1]
end
local function FindFreeCroissantOven()
    local recipeCfg = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes["Croissant"]
    local nameList = recipeCfg and recipeCfg.OvenNames
    return FindCroissantStations(nameList, "CroissantOvenSubject", true)[1]
end
local function WaitForCroissantOvenCooked(ovenPart, timeoutSec)
    local start = tick()
    local result = PollUntilTimeout(function()
        local stage = ovenPart:GetAttribute("CookingStage")
        if stage == "Cooked" then
            return "Cooked"
        elseif stage == "Burnt" then
            return "Burnt"
        end
        if ovenPart:GetAttribute("Occupied") ~= true and (tick() - start) > 2 then
            return "TimedOutUnoccupied"
        end
        return false
    end, timeoutSec, 90)
    if result == "TimedOutUnoccupied" then
        return nil
    end
    return result or nil
end
local function PlaceBatterOnPinBoard()
    if not RequireOrderGuideConfig("Modules.CafeOrderGuideConfig not loaded, cannot resolve pin board/batter tool") then
        return nil
    end
    local pinBoard = FindFreeCroissantPinBoard()
    if not pinBoard then
        return nil
    end
    local rollPrompt = GetObject(pinBoard, "default.CookingPrompt")
    if not rollPrompt then
        notyuri("PinBoard CookingPrompt (Roll) not found on " .. pinBoard.Name)
        return nil
    end
    local batterName = Modules.CafeOrderGuideConfig.BatterTool or "Batter"
    local fired = false
    CharacterLock.withLock(function()
        local tool = GetTool(batterName)
        if not tool then
            notyuri("Not holding " .. batterName .. ", cannot place on " .. pinBoard.Name)
            return
        end
        EquipTool(tool)
        task.wait(0.1)
        if not rollPrompt.Enabled then
            notyuri("PinBoard Roll prompt not enabled on " .. pinBoard.Name)
            return
        end
        FirePP(rollPrompt, true)
        task.wait(0.25)
        fired = true
    end)
    if not fired then
        return nil
    end
    return pinBoard
end
local function WaitForCroissantDoughTool(timeoutSec)
    return PollUntilTimeout(function()
        local tool = GetTool()
        if tool and tool:GetAttribute("IsRecipeFood") == true and tool:GetAttribute("FoodType") == "Croissant" and tool:GetAttribute("Doneness") == "Uncooked" then
            return tool
        end
        return nil
    end, timeoutSec, 30)
end
local function BakeCroissant(doughTool)
    local oven = FindFreeCroissantOven()
    if not oven then
        return nil
    end
    local bakePrompt = GetObject(oven, "Handle.CookingPrompt")
    if not bakePrompt then
        notyuri("Oven CookingPrompt (Bake) not found on " .. oven.Name)
        return nil
    end
    local placed = false
    CharacterLock.withLock(function()
        EquipTool(doughTool)
        task.wait(0.1)
        placed = PlaceToolWithRetry(doughTool.Name, oven, bakePrompt)
    end)
    if not placed then
        return nil
    end
    return oven, bakePrompt
end
local function IsCroissantWellDone(tool)
    if not tool or not tool:IsA("Tool") then
        return false
    end
    if tool:GetAttribute("IsRecipeFood") ~= true or tool:GetAttribute("FoodType") ~= "Croissant" then
        return false
    end
    local doneness = tool:GetAttribute("Doneness") or (Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.DefaultDoneness) or "WellDone"
    return doneness == "WellDone"
end
local function FindCroissantTool()
    return ForEachOwnedTool(function(tool)
        if tool:GetAttribute("IsRecipeFood") == true and tool:GetAttribute("FoodType") == "Croissant" then
            return tool
        end
        return nil
    end)
end
local function WaitForCookedCroissantTool(timeoutSec)
    return PollUntilTimeout(function()
        return ForEachOwnedTool(function(tool)
            if IsCroissantWellDone(tool) then
                return tool
            end
            return nil
        end)
    end, timeoutSec, 10)
end
local TRASH_BIN_PROMPT_PATH = "Main.Prompts.TrashBin.TrashBin.Trash.TrashPrompt"
local function TrashCroissantTool(tool)
    if not tool then
        return
    end
    local TrashPrompt = GetObject(workspace, TRASH_BIN_PROMPT_PATH)
    if not TrashPrompt then
        notyuri("Trash.TrashPrompt not found - cannot trash bad Croissant")
        return
    end
    CharacterLock.withLock(function()
        EquipTool(tool)
        task.wait(0.1)
        FirePP(TrashPrompt, true)
        task.wait(0.2)
    end)
end
local function WaitAndCollectFromOven(oven, bakePrompt)
    local result = WaitForCroissantOvenCooked(oven, 90)
    if not result then
        notyuri("Timed out waiting for cook-complete on " .. oven.Name)
        return false
    end
    if result == "Burnt" then
        notyuri("Croissant burnt in " .. oven.Name .. " - clearing it")
        CharacterLock.withLock(function()
            if not CanHoldMore(1) then
                notyuri("Backpack full (5/5), cannot pick up burnt Croissant from " .. oven.Name)
                return
            end
            FirePP(bakePrompt, true)
            task.wait(0.3)
        end)
        TrashCroissantTool(FindCroissantTool())
        return false
    end
    task.wait(0.2)
    local ok = true
    CharacterLock.withLock(function()
        if not CanHoldMore(1) then
            notyuri("Backpack full (5/5), cannot pick up cooked Croissant from oven")
            ok = false
            return
        end
        FirePP(bakePrompt, true)
        task.wait(0.3)
    end)
    if not ok then
        return false
    end
    local croissant = WaitForCookedCroissantTool(10)
    if not croissant then
        local bad = FindCroissantTool()
        notyuri("Croissant from " .. oven.Name .. " is not WellDone (" .. tostring(bad and bad:GetAttribute("Doneness") or "no tool") .. ") - trashing, order will retry")
        if bad then
            TrashCroissantTool(bad)
        end
        return false
    end
    CharacterLock.withLock(function()
        EquipTool(croissant)
        task.wait(0.1)
    end)
    return true
end
local function FindStartedAtAttribute(instance)
    for attrName, attrValue in pairs(instance:GetAttributes()) do
        if attrName:sub(-9) == "StartedAt" and typeof(attrValue) == "number" then
            return attrValue
        end
    end
    return nil
end
local function ClearStuckOrBurntItem(instance, isBurnt, burntWord, stuckTimeout, takePrompt, noPromptLabel, trashPrompt)
    local stuck = false
    if not isBurnt and instance:GetAttribute("Occupied") == true then
        local startedAt = FindStartedAtAttribute(instance)
        if startedAt and (workspace:GetServerTimeNow() - startedAt) > stuckTimeout then
            stuck = true
        end
    end
    if not (isBurnt or stuck) then
        return
    end
    local stateWord = isBurnt and burntWord or "stuck"
    if takePrompt then
        CharacterLock.withLock(function()
            if not CanHoldMore(1) then
                notyuri("Backpack full (5/5), cannot pick up " .. stateWord .. " item from " .. instance.Name)
                return
            end
            FirePP(takePrompt, true)
            task.wait(0.2)
            FirePP(trashPrompt, true)
            task.wait(0.2)
        end)
    else
        notyuri((isBurnt and (burntWord:sub(1,1):upper() .. burntWord:sub(2)) or "Stuck") .. " item on " .. instance.Name .. " but no " .. noPromptLabel .. " prompt found")
    end
end
local function ClearBurn()
    local TrashPrompt = GetObject(workspace, TRASH_BIN_PROMPT_PATH)
    if not TrashPrompt then
        notyuri("Trash.TrashPrompt not found - cannot clear burnt items")
        return
    end
    local CookTimeout = 60
    local GrillsFolder = GetObject(Scriptables, "Grills")
    if GrillsFolder then
        for _, grillPart in ipairs(GrillsFolder:GetChildren()) do
            local burnt = grillPart:GetAttribute("CookingStage") == "Burnt"
            local takePrompt = FindGrillPromptByAction(grillPart, "Take")
            ClearStuckOrBurntItem(grillPart, burnt, "burnt", CookTimeout, takePrompt, "Take", TrashPrompt)
        end
    end
    local stationNames = {}
    local milkshakeMixerName = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes.Milkshake and Modules.CafeOrderGuideConfig.Recipes.Milkshake.MixerName
    if milkshakeMixerName then
        table.insert(stationNames, milkshakeMixerName)
    end
    local coffeeMakerName = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes.Coffee and Modules.CafeOrderGuideConfig.Recipes.Coffee.CoffeeMakerName
    if coffeeMakerName then
        table.insert(stationNames, coffeeMakerName)
    end
    local blenderName = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes["Orange Juice"] and Modules.CafeOrderGuideConfig.Recipes["Orange Juice"].BlenderName
    if blenderName then
        table.insert(stationNames, blenderName)
    end
    for _, stationName in ipairs(stationNames) do
        local station = FindStationInstance(stationName, false)
        if station then
            local overmixed = station:GetAttribute("Overmixed") == true
            local cookingPrompt = GetObject(station, "Handle.CookingPrompt")
            ClearStuckOrBurntItem(station, overmixed, "overmixed", CookTimeout, cookingPrompt, "CookingPrompt", TrashPrompt)
        end
    end
    local croissantRecipeCfg = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes["Croissant"]
    local ovenStations = FindCroissantStations(croissantRecipeCfg and croissantRecipeCfg.OvenNames, "CroissantOvenSubject")
    local OvenStuckTimeout = 150
    for _, ovenPart in ipairs(ovenStations) do
        local burnt = ovenPart:GetAttribute("CookingStage") == "Burnt"
        local bakePrompt = GetObject(ovenPart, "Handle.CookingPrompt")
        ClearStuckOrBurntItem(ovenPart, burnt, "burnt", OvenStuckTimeout, bakePrompt, "Bake", TrashPrompt)
    end
end
local function PlaceBeansInCoffeeMaker(foodType)
    if not RequireOrderGuideConfig("Modules.CafeOrderGuideConfig not loaded, cannot resolve coffee maker/beans") then
        return nil
    end
    local recipeCfg = Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes[foodType]
    if not recipeCfg or not recipeCfg.CoffeeMakerName or not recipeCfg.CoffeeBeanTool then
        notyuri("No coffee recipe config for FoodType: " .. tostring(foodType))
        return nil
    end
    local coffeeMaker = FindStationInstance(recipeCfg.CoffeeMakerName, true)
    if not coffeeMaker then
        return nil
    end
    local cookingPrompt = GetObject(coffeeMaker, "Handle.CookingPrompt")
    if not cookingPrompt then
        notyuri("Coffee_Maker Handle.CookingPrompt not found on " .. coffeeMaker.Name)
        return nil
    end
    local placed = false
    CharacterLock.withLock(function()
        local beanTool = AcquireTool(
            recipeCfg.CoffeeBeanTool,
            "Backpack full (5/5), cannot pick up " .. recipeCfg.CoffeeBeanTool,
            "No pickup prompt found for: " .. recipeCfg.CoffeeBeanTool,
            "Did not receive expected tool: " .. recipeCfg.CoffeeBeanTool
        )
        if not beanTool then
            return
        end
        placed = PlaceToolWithRetry(recipeCfg.CoffeeBeanTool, coffeeMaker, cookingPrompt)
    end)
    if not placed then
        return nil
    end
    return coffeeMaker, cookingPrompt
end
local function PlaceScoopInMixer(foodType, flavor)
    if not RequireOrderGuideConfig("Modules.CafeOrderGuideConfig not loaded, cannot resolve mixer/scoop") then
        return nil
    end
    local recipeCfg = Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes[foodType]
    if not recipeCfg or not recipeCfg.MixerName then
        notyuri("No mixer recipe config for FoodType: " .. tostring(foodType))
        return nil
    end
    if not flavor then
        notyuri("No Flavor on order, cannot resolve ice cream scoop for FoodType: " .. tostring(foodType))
        return nil
    end
    local scoopToolName = flavor .. " Scoop"
    local mixer = FindStationInstance(recipeCfg.MixerName, true)
    if not mixer then
        return nil
    end
    local cookingPrompt = GetObject(mixer, "Handle.CookingPrompt")
    if not cookingPrompt then
        notyuri("" .. recipeCfg.MixerName .. " Handle.CookingPrompt not found on " .. mixer.Name)
        return nil
    end
    local placed = false
    CharacterLock.withLock(function()
        local scoopTool = AcquireTool(
            scoopToolName,
            "Backpack full (5/5), cannot pick up " .. scoopToolName,
            "No pickup prompt found for: " .. scoopToolName,
            "Did not receive expected tool: " .. scoopToolName
        )
        if not scoopTool then
            return
        end
        placed = PlaceToolWithRetry(scoopToolName, mixer, cookingPrompt)
    end)
    if not placed then
        return nil
    end
    return mixer, cookingPrompt
end
local function PlaceFruitInBlender(foodType)
    if not RequireOrderGuideConfig("Modules.CafeOrderGuideConfig not loaded, cannot resolve blender/fruit") then
        return nil
    end
    local recipeCfg = Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes[foodType]
    if not recipeCfg or not recipeCfg.BlenderName or not recipeCfg.FruitTool then
        notyuri("No blender recipe config for FoodType: " .. tostring(foodType))
        return nil
    end
    local blender = FindStationInstance(recipeCfg.BlenderName, true)
    if not blender then
        return nil
    end
    local cookingPrompt = GetObject(blender, "Handle.CookingPrompt")
    if not cookingPrompt then
        notyuri("" .. recipeCfg.BlenderName .. " Handle.CookingPrompt not found on " .. blender.Name)
        return nil
    end
    local placed = false
    CharacterLock.withLock(function()
        local fruitTool = AcquireTool(
            recipeCfg.FruitTool,
            "Backpack full (5/5), cannot pick up " .. recipeCfg.FruitTool,
            "No pickup prompt found for: " .. recipeCfg.FruitTool,
            "Did not receive expected tool: " .. recipeCfg.FruitTool
        )
        if not fruitTool then
            return
        end
        placed = PlaceToolWithRetry(recipeCfg.FruitTool, blender, cookingPrompt)
    end)
    if not placed then
        return nil
    end
    return blender, cookingPrompt
end
local function WaitForCoffeeReady(coffeeMaker, timeoutSec)
    return PollUntilTimeout(function()
        return coffeeMaker:GetAttribute("Ready") == true
    end, timeoutSec, 60)
end
local function WaitAndCollectFromCoffeeMaker(coffeeMaker, cookingPrompt)
    local ready = WaitForCoffeeReady(coffeeMaker, 90)
    if not ready then
        notyuri("Timed out waiting for coffee-ready on " .. coffeeMaker.Name)
        return false
    end
    task.wait(0.2)
    return CollectWithBackpackGuard(cookingPrompt, "Backpack full (5/5), cannot pick up coffee from " .. coffeeMaker.Name)
end
local function ApplyOrderToppings(orderState, foodType)
    CharacterLock.withLock(function()
        local applicators = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.IngredientApplicators
        if orderState.Syrup and applicators and applicators.Syrup then
            local terms = applicators.Syrup[orderState.Syrup]
            if terms then
                for _, term in ipairs(terms) do
                    local prompt = FindApplyPrompt(term, foodType)
                    if prompt then FirePP(prompt, true) task.wait(0.2) break end
                end
            else
                notyuri("No IngredientApplicators.Syrup entry for: " .. tostring(orderState.Syrup))
            end
        end
        if orderState.WhippedCream and applicators and applicators.WhippedCream then
            local terms = applicators.WhippedCream[orderState.WhippedCream]
            if terms then
                for _, term in ipairs(terms) do
                    local prompt = FindApplyPrompt(term, foodType)
                    if prompt then FirePP(prompt, true) task.wait(0.2) break end
                end
            else
                notyuri("No IngredientApplicators.WhippedCream entry for: " .. tostring(orderState.WhippedCream))
            end
        end
        if orderState.Toppings then
            for toppingName, active in pairs(orderState.Toppings) do
                if active then
                    local prompt = FindApplyPrompt(toppingName, foodType)
                    if prompt then FirePP(prompt, true) task.wait(0.2) end
                end
            end
        end
    end)
end
local function FindCustomerById(customerId)
    local CafeCustomersFolder = GetObject(workspace, "CafeCustomers")
    if not CafeCustomersFolder or not customerId then return nil end
    for _, model in ipairs(CafeCustomersFolder:GetChildren()) do
        if model:IsA("Model") then
            local id = model:GetAttribute("CafeCustomerId") or model:GetAttribute("CustomerId")
            if id == customerId then
                return model
            end
        end
    end
    return nil
end
local function ServeHeldFood(customerId)
    local customer = FindCustomerById(customerId)
    if not customer then
        notyuri("Could not find customer for CustomerId: " .. tostring(customerId))
        return false
    end
    local hrp = GetObject(customer, "HumanoidRootPart")
    local prompt = hrp and GetObject(hrp, "CafeRuntimePrompt")
    if not prompt then
        notyuri("CafeRuntimePrompt not found on customer: " .. customer.Name)
        return false
    end
    CharacterLock.withLock(function()
        FirePP(prompt, true)
        task.wait(0.2)
    end)
    return true
end
local function FirePrompt(root, predicateFn, waitTime)
    if not root then return end
    for _, descendant in ipairs(root:GetDescendants()) do
        if predicateFn(descendant) then
            FirePP(descendant, true)
            task.wait(waitTime)
        end
    end
end
local function HandleAnomaly()
    local CafeCustomersFolder = GetObject(workspace, "CafeCustomers")
    if not CafeCustomersFolder then return false end
    for _, model in ipairs(CafeCustomersFolder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("IsAnomaly") == true then
            local state = model:GetAttribute("CustomerState") or model:GetAttribute("CafeCustomerState")
            if state == "OrderPresented" then
                local lever = GetObject(Scriptables, "Lever")
                if lever then
                    local prompt = lever:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt and prompt.ActionText == "Close Shutter" then
                        FirePP(prompt, true)
                        task.wait(0.2)
                        return true
                    elseif prompt then
                        notyuri("Anomaly customer OrderPresented but Lever prompt ActionText=" .. tostring(prompt.ActionText))
                    else
                        notyuri("Anomaly customer OrderPresented but Lever has no ProximityPrompt")
                    end
                else
                    notyuri("Anomaly customer detected but Lever not found")
                end
            end
        end
    end
    return false
end
local function GetPanTool()
    for _, name in ipairs(Constants.PAN_TOOL_NAMES) do
        local tool = GetTool(name)
        if tool then return tool end
    end
    return nil
end
local function FindFlyHitPart(flyModel)
    local part = flyModel:FindFirstChild("uglybody.006")
    if part and part:IsA("BasePart") then
        return part
    end
    return flyModel:FindFirstChildWhichIsA("BasePart", true)
end
local function IsPanReady(panStatusLabel)
    if not panStatusLabel then return false end
    return string.find(panStatusLabel.Text, "ready", 1, true) ~= nil
end
local function HandleHitFly()
    local flyModel = GetObject(workspace, "FlyAnomalyServer")
    if not flyModel then
        return
    end
    local panTool = GetPanTool()
    if not panTool then
        notyuri("HandleHitFly: no pan tool held, attempting pickup")
        local PanPickupPrompt = GetObject(Scriptables, "PanPickup.PanPickupPrompt")
        if not PanPickupPrompt then
            notyuri("PanPickup.PanPickupPrompt not found - cannot pick up Pan")
            return
        end
        local PanStatusLabel = GetObject(Scriptables, "PanPickup.PANStatusBillboard.Background.StatusLabel")
        local panReady = IsPanReady(PanStatusLabel)
        notyuri("HandleHitFly: IsPanReady=" .. tostring(panReady) .. " PanStatusLabel.Text=" .. tostring(PanStatusLabel and PanStatusLabel.Text))
        if not panReady then
            return
        end
        CharacterLock.withLock(function()
            notyuri("HandleHitFly: firing PanPickupPrompt")
            FirePP(PanPickupPrompt, true)
            task.wait(0.3)
        end)
        panTool = GetPanTool()
        notyuri("HandleHitFly: after pickup attempt, panTool=" .. tostring(panTool and panTool.Name))
        if not panTool then
            notyuri("HandleHitFly: pickup failed, no pan tool in backpack/held")
            return
        end
    end
    local PanActivatedRemote = GetBridge("PanActivated")
    if not PanActivatedRemote then
        notyuri("PanActivated bridge not available - AutoOrder(fly) cannot fire")
        return
    end
    local hitPart = FindFlyHitPart(flyModel)
    if not hitPart then
        notyuri("No hittable part found on FlyAnomalyServer")
        return
    end
    CharacterLock.withLock(function()
        EquipTool(panTool)
        task.wait(0.1)
        PanActivatedRemote:Fire(hitPart)
        task.wait(0.3)
    end)
end
local function HandleGlorpShoo()
    local glorpModel = GetObject(workspace, "GlorpAnomaly")
    if not glorpModel then
        return
    end
    local hrp = GetObject(glorpModel, "HumanoidRootPart")
    if not hrp then
        notyuri("HandleGlorpShoo: GlorpAnomaly has no HumanoidRootPart")
        return
    end
    local ShooPrompt = GetObject(hrp, "GlorpShooPrompt")
    if not ShooPrompt then
        notyuri("HandleGlorpShoo: GlorpShooPrompt not found")
        return
    end
    if not ShooPrompt.Enabled then
        return
    end
    CharacterLock.withLock(function()
        FirePP(ShooPrompt, true)
        task.wait(0.3)
    end)
end
local function HandleMishyGive()
    local MishySpawnsFolder = GetObject(Scriptables, "MishySpawns")
    if not MishySpawnsFolder then
        return
    end
    for _, station in ipairs(MishySpawnsFolder:GetChildren()) do
        local mishyModel = station:FindFirstChild("MishyAnomaly")
        if mishyModel then
            local hrp = GetObject(mishyModel, "RootPart")
            local GivePrompt = hrp and GetObject(hrp, "MishyGivePrompt")
            if GivePrompt and GivePrompt.Enabled then
                local itemName = GivePrompt.ObjectText
                if typeof(itemName) ~= "string" or itemName == "" then
                    notyuri("HandleMishyGive: GivePrompt has no ObjectText")
                    return
                end
                local shouldStop = false
                CharacterLock.withLock(function()
                    local tool, failReason = AcquireTool(
                        itemName,
                        "HandleMishyGive: Backpack full (5/5), cannot pick up: " .. itemName,
                        "HandleMishyGive: No pickup prompt found for: " .. itemName,
                        "HandleMishyGive: Did not receive expected tool: " .. itemName
                    )
                    if tool then
                        EquipTool(tool)
                        task.wait(0.1)
                        FirePP(GivePrompt, true)
                        task.wait(0.3)
                    elseif failReason == "BackpackFull" then
                        shouldStop = true
                    end
                end)
                if shouldStop then return end
                return
            end
        end
    end
end
local function IsCoffeeReady(coffeeMakerSanity)
    if not coffeeMakerSanity then return false end
    return coffeeMakerSanity:GetAttribute("Ready") == true
end
local function ShouldDrinkCoffee()
    local maxSanity = Plr:GetAttribute("CafeMaxSanity") or (Modules.CafeConfig and Modules.CafeConfig.Sanity.MaximumValue)
    local sanity = Plr:GetAttribute("CafeSanity") or (Modules.CafeConfig and Modules.CafeConfig.Sanity.StartingValue)
    if not maxSanity or not sanity then
        notyuri("AutoCoffee: sanity values unavailable (no CafeSanity/CafeMaxSanity attribute and Modules.CafeConfig not loaded)")
        return false
    end
    local thresholdPercent = Options.CoffeeThreshold.Value
    return sanity < (maxSanity * (thresholdPercent / 100))
end
local function Func_AutoCoffee()
    while Toggles.AutoCoffee.Value do
        local ok, err = pcall(function()
            local RequestClassItemUseRemote = GetBridge("RequestClassItemUse")
            if not RequestClassItemUseRemote then
                notyuri("RequestClassItemUse bridge not available - AutoCoffee cannot fire")
                task.wait(1)
                return
            end
            local teaCupTool = GetTool(Constants.TT)
            if not teaCupTool then
                local CoffeeMakerSanity = GetObject(Scriptables, "Tea_Maker_Sanity")
                local CoffeeCookingPrompt = CoffeeMakerSanity and GetObject(CoffeeMakerSanity, "Handle.CookingPrompt")
                if not CoffeeCookingPrompt then
                    notyuri("Tea_Maker_Sanity.Handle.CookingPrompt not found - cannot pick up Coffee Cup")
                    task.wait(1)
                    return
                end
                if not IsCoffeeReady(CoffeeMakerSanity) then
                    task.wait(0.5)
                    return
                end
                if not CanHoldMore(1) then
                    notyuri("Backpack full (5/5), cannot pick up Coffee Cup")
                    task.wait(1)
                    return
                end
                CharacterLock.withLock(function()
                    FirePP(CoffeeCookingPrompt, true)
                    task.wait(0.3)
                end)
                teaCupTool = GetTool(Constants.TT)
                if not teaCupTool then
                    task.wait(0.5)
                    return
                end
            end
            if not ShouldDrinkCoffee() then
                task.wait(0.5)
                return
            end
            CharacterLock.withLock(function()
                EquipTool(teaCupTool)
                task.wait(0.1)
                RequestClassItemUseRemote:Fire("Tea Cup")
                task.wait(0.3)
            end)
        end)
        if not ok then
            notyuri("AutoCoffee error: " .. tostring(err))
        end
        task.wait(0.3)
    end
end
local function GetNearestAnomalyCustomer()
    local CafeCustomersFolder = GetObject(workspace, "CafeCustomers")
    if not CafeCustomersFolder then return nil end
    local char = Plr.Character
    local hrp = char and GetObject(char, "HumanoidRootPart")
    local nearest, nearestDist = nil, math.huge
    for _, model in ipairs(CafeCustomersFolder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("IsAnomaly") == true then
            local targetPart = GetObject(model, "HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if targetPart then
                local dist = hrp and (hrp.Position - targetPart.Position).Magnitude or 0
                if dist < nearestDist then
                    nearest, nearestDist = targetPart, dist
                end
            end
        end
    end
    return nearest
end
local function Func_AutoDevour()
    while Toggles.AutoDevour.Value do
        local ok, err = pcall(function()
            if Plr:GetAttribute("EquippedClass") ~= "Watcher" then
                notyuri("AutoDevour: EquippedClass is not Watcher - skipping")
                task.wait()
                return
            end
            local RequestClassAbilityRemote = GetBridge("RequestClassAbility")
            local RequestClassAbilityTargetRemote = GetBridge("RequestClassAbilityTarget")
            if not RequestClassAbilityRemote or not RequestClassAbilityTargetRemote then
                notyuri("RequestClassAbility/RequestClassAbilityTarget bridge not available - AutoDevour cannot fire")
                task.wait()
                return
            end
            if Plr:GetAttribute("ClassDevourFormActive") ~= true then
                local cooldownEndsAt = Plr:GetAttribute("ClassActiveAbilityCooldownEndsAt")
                if typeof(cooldownEndsAt) == "number" and cooldownEndsAt > workspace:GetServerTimeNow() then
                    task.wait()
                    return
                end
                local anomaly = GetNearestAnomalyCustomer()
                if not anomaly then
                    task.wait()
                    return
                end
                RequestClassAbilityRemote:Fire()
                task.wait()
                return
            end
            local anomaly = GetNearestAnomalyCustomer()
            if not anomaly then
                task.wait()
                return
            end
            TPTo(anomaly)
            RequestClassAbilityTargetRemote:Fire({ Target = anomaly })
            task.wait()
        end)
        if not ok then
            notyuri("AutoDevour error: " .. tostring(err))
        end
        task.wait(.1)
    end
end
local function FireAllCustomerPrompts()
    local CafeCustomersFolder = GetObject(workspace, "CafeCustomers")
    if not CafeCustomersFolder then return end
    for _, model in ipairs(CafeCustomersFolder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("IsAnomaly") ~= true then
            for _, descendant in ipairs(model:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") and descendant.Enabled and descendant.ActionText ~= "Serve" then
                    FirePP(descendant, true)
                    task.wait(0.2)
                end
            end
        end
    end
end
local CustomerESPFolder = Instance.new("Folder")
CustomerESPFolder.Parent = Services.CoreGui
local function getPartForAdornee(target)
    if target:IsA("BasePart") then
        return target
    elseif target:IsA("Model") then
        return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart", true)
    end
    return nil
end
local function makeLabel(text, sizeY, posY, bold, textColor)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, sizeY, 0)
    lbl.Position = UDim2.new(0, 0, posY, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = textColor or Color3.new(1, 1, 1)
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextScaled = true
    lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    return lbl
end
local function CustomerESPToggle(entry, enabled, fillColor, outlineColor, labelName, roleText, textColor)
    if enabled then
        if not entry then
            entry = table.remove(State.CustomerESPPool.Free)
        end
        if not entry then
            local h = Instance.new("Highlight")
            h.FillTransparency = 0.4
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            local bb = Instance.new("BillboardGui")
            bb.Size = UDim2.new(0, 100, 0, 30)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.ResetOnSpawn = false
            local nameLbl = makeLabel("", 0.5, 0, true, Color3.new(1, 1, 1))
            nameLbl.Parent = bb
            local roleLbl = makeLabel("", 0.5, 0.5, false, Color3.new(1, 1, 1))
            roleLbl.Parent = bb
            entry = { highlight = h, billboard = bb, nameLbl = nameLbl, roleLbl = roleLbl }
        end
        entry.highlight.FillColor = fillColor
        entry.highlight.OutlineColor = outlineColor
        entry.highlight.Parent = CustomerESPFolder
        entry.nameLbl.Text = labelName
        entry.nameLbl.TextColor3 = textColor or Color3.new(1, 1, 1)
        entry.roleLbl.Text = roleText
        entry.roleLbl.TextColor3 = textColor or Color3.new(1, 1, 1)
        entry.billboard.Parent = CustomerESPFolder
        State.CustomerESPPool.Active[entry] = true
        return entry
    else
        if not entry or not State.CustomerESPPool.Active[entry] then return end
        State.CustomerESPPool.Active[entry] = nil
        entry.highlight.Adornee = nil
        entry.highlight.Parent = nil
        entry.billboard.Adornee = nil
        entry.billboard.Parent = nil
        table.insert(State.CustomerESPPool.Free, entry)
        return nil
    end
end
local function SetCustomerHighlight(tbl, key, enabled, target, fillColor, outlineColor, labelName, roleText, textColor)
    if enabled then
        local part = getPartForAdornee(target)
        if not part then return end
        local entry = CustomerESPToggle(nil, true, fillColor, outlineColor, labelName, roleText, textColor)
        if not entry then return end
        entry.highlight.Adornee = target
        entry.billboard.Adornee = part
        tbl[key] = entry
    else
        if tbl[key] then
            CustomerESPToggle(tbl[key], false)
            tbl[key] = nil
        end
    end
end
local function RefreshCustomerESP()
    if not Toggles.CustomerESP.Value then
        for k in pairs(State.CustomerESPHighlights) do SetCustomerHighlight(State.CustomerESPHighlights, k, false) end
        return
    end
    local CafeCustomersFolder = GetObject(workspace, "CafeCustomers")
    if not CafeCustomersFolder then return end
    local normalColor = Options.CustomerColor.Value
    local anomalyColor = Options.AnomalyColor.Value
    local outlineColor = Options.CustomerOutline.Value
    local current = {}
    for _, model in ipairs(CafeCustomersFolder:GetChildren()) do
        if model:IsA("Model") then
            current[model] = true
        end
    end
    for key in pairs(State.CustomerESPHighlights) do
        if not current[key] or not key.Parent then
            SetCustomerHighlight(State.CustomerESPHighlights, key, false)
        end
    end
    for model in pairs(current) do
        local isAnomaly = model:GetAttribute("IsAnomaly") == true
        local customerType = model:GetAttribute("CustomerType") or (isAnomaly and "Anomaly" or "Normal")
        local color = isAnomaly and anomalyColor or normalColor
        if not State.CustomerESPHighlights[model] then
            SetCustomerHighlight(State.CustomerESPHighlights, model, true, model, color, outlineColor, model.Name, customerType, color)
        else
            local entry = State.CustomerESPHighlights[model]
            entry.highlight.FillColor = color
            entry.highlight.OutlineColor = outlineColor
            entry.nameLbl.Text = model.Name
            entry.nameLbl.TextColor3 = color
            entry.roleLbl.Text = customerType
            entry.roleLbl.TextColor3 = color
        end
    end
end
local function FuncCustomerESP()
    while true do
        RunService.Heartbeat:Wait()
        if Toggles.CustomerESP.Value then
            RefreshCustomerESP()
        end
        task.wait(0.3)
    end
end
local function IsRunFailedScreenShowing()
    local EndScreen = PGui:FindFirstChild("EndScreen")
    if not (EndScreen and EndScreen.Enabled) then
        return false
    end
    if not Modules.RunState then
        return false
    end
    return RS:GetAttribute("CafeRunState") == Modules.RunState.RunFailed
end
local function Func_AutoRetry()
    while Toggles.AutoRetry.Value do
        local ok, err = pcall(function()
            if not IsRunFailedScreenShowing() then
                task.wait(0.5)
                return
            end
            local CafeRoundAction = GetBridge("CafeRoundAction")
            if not CafeRoundAction then
                notyuri("CafeRoundAction bridge not available - AutoRetry cannot fire")
                task.wait(1)
                return
            end
            CafeRoundAction:Fire({
                Action = "PlayAgain"
            })
            task.wait(1)
        end)
        if not ok then
            notyuri("AutoRetry error: " .. tostring(err))
        end
        task.wait(0.3)
    end
end
local function HandleCookingMinigameStart(startData)
    local requestId = startData and startData.RequestId
    local minigame = startData and startData.Minigame
    if typeof(requestId) ~= "string" then
        return
    end
    if State.HandledMinigameRequestIds[requestId] then
        return
    end
    State.HandledMinigameRequestIds[requestId] = true
    task.delay(30, function()
        State.HandledMinigameRequestIds[requestId] = nil
    end)
    local payload = Constants.MinigameCompletePayloads[minigame]
    if not payload then
        return
    end
    if minigame == "Croissant" then
        local now = tick()
        if now - State.CroissantMinigameLastFired < 1 then
            return
        end
        State.CroissantMinigameLastFired = now
    end
    local CookingMinigameComplete = GetBridge("CookingMinigameComplete")
    if not CookingMinigameComplete then
        notyuri("CookingMinigameComplete bridge not available - cannot auto-complete " .. minigame .. " minigame")
        return
    end
    notyuri("Auto-completing " .. minigame .. " minigame, RequestId: " .. requestId)
    CookingMinigameComplete:Fire({
        RequestId = requestId,
        Multiplier = payload.Multiplier,
        ResultData = payload.ResultData,
    })
end
local function Func_AutoOrder()
    while Toggles.AutoOrder.Value do
        local ok, err = pcall(function()
            local CashierOrderSystem = GetObject(Scriptables, "CashierOrderSystem")
            FirePrompt(CashierOrderSystem, function(descendant)
                return descendant:IsA("ProximityPrompt") and descendant.Name == "CafeRuntimePrompt" and descendant.Enabled
            end, 0.2)
            if HandleAnomaly() then
                return 
            end
            ClearBurn()
            FireAllCustomerPrompts()
            FirePrompt(workspace, function(descendant)
                return descendant:IsA("ProximityPrompt") and descendant.Name == "CafeRuntimePrompt" and descendant.Parent and descendant.Parent.Name == "DirtyPlateNode" and descendant.Enabled
            end, nil)
            local CafeMesses = GetObject(workspace, "CafeMesses")
            FirePrompt(CafeMesses, function(descendant)
                return descendant:IsA("ProximityPrompt") and descendant.Enabled
            end, nil)
            HandleHitFly()
            HandleGlorpShoo()
            HandleMishyGive()
            local bellModel = GetObject(Scriptables, "Bell")
            local BellPrompt = bellModel and bellModel:FindFirstChildWhichIsA("ProximityPrompt", true)
            if BellPrompt and BellPrompt.Enabled then
                FirePP(BellPrompt, true)
                task.wait(0.2)
            end
            local OrderPaperPrompt = GetObject(Scriptables, "OrderPaper.CafeRuntimePrompt")
            if OrderPaperPrompt and OrderPaperPrompt.Enabled then
                FirePP(OrderPaperPrompt, true)
                task.wait(0.2)
            end
            local deliveryBox = GetTool("Delivery Box")
            if deliveryBox then
                local deliveryMarkerPrompt = nil
                local MarkersFolder = GetObject(Scriptables, "Markers")
                if MarkersFolder then
                    for _, marker in ipairs(MarkersFolder:GetChildren()) do
                        local prompt = GetObject(marker, "CafeRuntimePrompt")
                        if prompt and prompt.Enabled and prompt.ActionText == "Place Box" then
                            deliveryMarkerPrompt = prompt
                            break
                        end
                    end
                end
                if deliveryMarkerPrompt then
                    CharacterLock.withLock(function()
                        EquipTool(deliveryBox)
                        task.wait(0.1)
                        FirePP(deliveryMarkerPrompt, true)
                        task.wait(0.2)
                    end)
                end
            end
            local char = Plr.Character
            local hrp = char and GetObject(char, "HumanoidRootPart")
            local selfSavePrompt = hrp and GetObject(hrp, "CafeSelfSavePrompt")
            if selfSavePrompt and selfSavePrompt.Enabled then
                FirePP(selfSavePrompt, true)
                task.wait(0.2)
            end
            local scriptableFolder = GetObject(workspace, "Scriptable")
            local cryoRoomGasLeakRepairPrompt = GetObject(scriptableFolder, "CryoRoomGasLeakSource.CryoRoomGasLeakRepairPrompt")
            if cryoRoomGasLeakRepairPrompt and cryoRoomGasLeakRepairPrompt.Enabled then
                FirePP(cryoRoomGasLeakRepairPrompt, true)
                task.wait(0.2)
            end
            local powerBreakAnomalyPrompt = GetObject(workspace, "Power Break Anomaly.HumanoidRootPart.PowerBreakAnomalyPrompt")
            if powerBreakAnomalyPrompt and powerBreakAnomalyPrompt.Enabled then
                FirePP(powerBreakAnomalyPrompt, true)
                task.wait(0.2)
            end
            local powerBreakRepairPrompt = GetObject(Scriptables, "PowerBox.powerbox.PowerBreakRepairPrompt")
            if powerBreakRepairPrompt and powerBreakRepairPrompt.Enabled then
                FirePP(powerBreakRepairPrompt, true)
                task.wait(0.2)
            end
        end)
        if not ok then
            notyuri("AutoOrder error: " .. tostring(err))
        end
        task.wait(0.5)
    end
end
local function GetEmptyTeleporter()
    local zones = GetObject(workspace, "Main.Zones")
    if not zones then
        return nil
    end
    for _, child in ipairs(zones:GetChildren()) do
        if child.Name == "Teleporter" then
            local label = GetObject(child, "BillboardHolder.BillboardGui.Players")
            if label and label:IsA("TextLabel") then
                local current, max = label.Text:match("^(%d+)/(%d+)$")
                if current and tonumber(current) == 0 then
                    return child
                end
            end
        end
    end
    return nil
end
local function Func_AutoJoin()
    while Toggles.AutoJoin.Value do
        local ok, err = pcall(function()
            local teleporter = GetEmptyTeleporter()
            if not teleporter then
                return
            end
            local enterPart = teleporter:FindFirstChild("EnterPart")
            if not enterPart then
                return
            end
            FireTI(enterPart)
            local PartyCreate = GetBridge("PartyCreate")
            if not PartyCreate then
                return
            end
            if not PartyGameModes then
                return
            end
            task.wait(1)
            PartyCreate:Fire({
                maxPlayers = 1,
                friendOnly = false,
                gameModeId = "Normal"
            })
            task.wait(0.1)
            local PartySetSkipFTUE = GetBridge("PartySetSkipFTUE")
            if not PartySetSkipFTUE then
                return
            end
            PartySetSkipFTUE:Fire({ skipFTUE = true })
            task.wait(0.1)
            local PartyForceStart = GetBridge("PartyForceStart")
            if not PartyForceStart then
                return
            end
            PartyForceStart:Fire({ skipFTUE = true })
        end)
        if not ok then
            notyuri("AutoJoin error: " .. tostring(err))
        end
        task.wait()
    end
end
local function HandleDialogueEffect(effectData)
    if not effectData or effectData.EffectName ~= "PlayCustomerDialogue" then
        return
    end
    local CafeRoundAction = GetBridge("CafeRoundAction")
    if not CafeRoundAction then
        return
    end
    CafeRoundAction:Fire({
        Action = "DialogueSkip"
    })
end
local function SetAutoSkipDialogue(enabled)
    if enabled then
        if Connections.AutoSkipDialogue then
            return
        end
        local CafeEffectRemote = GetBridge("CafeEffectRemote")
        if not CafeEffectRemote then
            notyuri("CafeEffectRemote not available - AutoSkipDialogue cannot start")
            return
        end
        SafeConnect("AutoSkipDialogue", function()
            return CafeEffectRemote
        end, HandleDialogueEffect)
    else
        if Connections.AutoSkipDialogue then
            Connections.AutoSkipDialogue:Disconnect()
            Connections.AutoSkipDialogue = nil
        end
    end
end
local function FindMatchingHeldOrder(orderState)
    if not Modules.CafeOrderGuideResolver then return nil end
    local orderData = {
        FoodType = orderState.FoodType,
        Doneness = orderState.Doneness,
        Flavor = orderState.Flavor,
        Plate = orderState.Plate,
        Syrup = orderState.Syrup,
        WhippedCream = orderState.WhippedCream,
        Toppings = orderState.Toppings,
    }
    return ForEachOwnedTool(function(tool)
        local recipeState = Modules.CafeOrderGuideResolver.GetToolRecipeState(tool)
        if recipeState and Modules.CafeOrderGuideResolver.RecipeStateMatchesOrder(recipeState, orderData) then
            return tool
        end
        return nil
    end)
end
local function RecipeBaseMatchesOrder(recipeState, orderState)
    if not recipeState or recipeState.FoodType ~= orderState.FoodType then
        return false
    end
    local defaultDoneness = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.DefaultDoneness
    if orderState.Doneness and (recipeState.Doneness or defaultDoneness) ~= orderState.Doneness then
        return false
    end
    local defaultPlate = Modules.CafeOrderGuideConfig and Modules.CafeOrderGuideConfig.DefaultPlate
    if orderState.Plate and (recipeState.Plate or defaultPlate) ~= orderState.Plate then
        return false
    end
    if recipeState.Flavor ~= orderState.Flavor then
        return false
    end
    if recipeState.Syrup and orderState.Syrup and recipeState.Syrup ~= orderState.Syrup then
        return false
    end
    if recipeState.WhippedCream and orderState.WhippedCream and recipeState.WhippedCream ~= orderState.WhippedCream then
        return false
    end
    return true
end
local function GetMissingToppings(recipeState, orderState)
    local missingList = {}
    if not Modules.CafeOrderGuideConfig or not Modules.CafeOrderGuideConfig.ToppingAttributes then
        return missingList
    end
    local haveToppings = (recipeState and recipeState.Toppings) or {}
    local wantToppings = orderState.Toppings or {}
    for _, toppingName in ipairs(Modules.CafeOrderGuideConfig.ToppingAttributes) do
        local wants = wantToppings[toppingName] == true
        local has = haveToppings[toppingName] == true
        if wants and not has then
            table.insert(missingList, toppingName)
        end
    end
    return missingList
end
local function GetMissingSyrupIngredient(recipeState, orderState)
    if not orderState.Syrup then
        return nil
    end
    if recipeState and recipeState.Syrup == orderState.Syrup then
        return nil
    end
    return orderState.Syrup .. "Syrup"
end
local function GetMissingWhippedCreamIngredient(recipeState, orderState)
    if not orderState.WhippedCream then
        return nil
    end
    if recipeState and recipeState.WhippedCream == orderState.WhippedCream then
        return nil
    end
    return orderState.WhippedCream .. "WhippedCream"
end
local function FindPartialMatchHeldItem(orderState)
    if not Modules.CafeOrderGuideResolver then return nil end
    local function checkTool(tool)
        local recipeState = Modules.CafeOrderGuideResolver.GetToolRecipeState(tool)
        if not recipeState or not RecipeBaseMatchesOrder(recipeState, orderState) then
            return nil
        end
        local missingToppings = GetMissingToppings(recipeState, orderState)
        local missingSyrup = GetMissingSyrupIngredient(recipeState, orderState)
        local missingWhippedCream = GetMissingWhippedCreamIngredient(recipeState, orderState)
        if #missingToppings == 0 and not missingSyrup and not missingWhippedCream then
            return nil
        end
        return tool, { Toppings = missingToppings, Syrup = missingSyrup, WhippedCream = missingWhippedCream }
    end
    return ForEachOwnedTool(checkTool)
end
local function ApplyMissingToppings(orderState, foodType, missingItems)
    CharacterLock.withLock(function()
        if missingItems.Syrup then
            local prompt = FindApplyPrompt(missingItems.Syrup, foodType)
            if prompt then FirePP(prompt, true) task.wait(0.2) end
        end
        if missingItems.WhippedCream then
            local prompt = FindApplyPrompt(missingItems.WhippedCream, foodType)
            if prompt then FirePP(prompt, true) task.wait(0.2) end
        end
        for _, toppingName in ipairs(missingItems.Toppings) do
            local prompt = FindApplyPrompt(toppingName, foodType)
            if prompt then FirePP(prompt, true) task.wait(0.2) end
        end
    end)
end
local function ProcessOrder(orderState)
    local matchingTool = FindMatchingHeldOrder(orderState)
    if matchingTool then
        notyuri("Found matching dish already in inventory for OrderId: " .. tostring(orderState.OrderId) .. ", serving directly")
        local ok, err = pcall(function()
            CharacterLock.withLock(function()
                EquipTool(matchingTool)
                task.wait(0.1)
            end)
            ServeHeldFood(orderState.CustomerId)
        end)
        if not ok then
            notyuri("AutoCook direct-serve error: " .. tostring(err))
        end
        return
    end
    local partialTool, missingItems = FindPartialMatchHeldItem(orderState)
    if partialTool then
        notyuri("Found partial match in inventory for OrderId: " .. tostring(orderState.OrderId) .. ", adding " .. #missingItems.Toppings .. " missing topping(s) instead of cooking new")
        local ok, err = pcall(function()
            CharacterLock.withLock(function()
                EquipTool(partialTool)
                task.wait(0.1)
            end)
            ApplyMissingToppings(orderState, orderState.FoodType, missingItems)
            ServeHeldFood(orderState.CustomerId)
        end)
        if not ok then
            notyuri("AutoCook partial-match error: " .. tostring(err))
        end
        return
    end
    local foodDispatch = {
        ["Orange Juice"] = function()
            local blender, cookingPrompt = PlaceFruitInBlender(orderState.FoodType)
            if not blender then return end
            if not WaitAndCollectFromCoffeeMaker(blender, cookingPrompt) then return end
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Banana Juice"] = function()
            local blender, cookingPrompt = PlaceFruitInBlender(orderState.FoodType)
            if not blender then return end
            if not WaitAndCollectFromCoffeeMaker(blender, cookingPrompt) then return end
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Apple Juice"] = function()
            local blender, cookingPrompt = PlaceFruitInBlender(orderState.FoodType)
            if not blender then return end
            if not WaitAndCollectFromCoffeeMaker(blender, cookingPrompt) then return end
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Milkshake"] = function()
            local mixer, cookingPrompt = PlaceScoopInMixer(orderState.FoodType, orderState.Flavor)
            if not mixer then return end
            if not WaitAndCollectFromCoffeeMaker(mixer, cookingPrompt) then return end
            ApplyOrderToppings(orderState, orderState.FoodType)
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Coffee"] = function()
            local coffeeMaker, cookingPrompt = PlaceBeansInCoffeeMaker(orderState.FoodType)
            if not coffeeMaker then return end
            if not WaitAndCollectFromCoffeeMaker(coffeeMaker, cookingPrompt) then return end
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Decaf Coffee"] = function()
            local coffeeMaker, cookingPrompt = PlaceBeansInCoffeeMaker(orderState.FoodType)
            if not coffeeMaker then return end
            if not WaitAndCollectFromCoffeeMaker(coffeeMaker, cookingPrompt) then return end
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Creamer Coffee"] = function()
            local creamerRecipeCfg = Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes["Creamer Coffee"]
            local coffeeMaker, cookingPrompt = PlaceBeansInCoffeeMaker("Creamer Coffee")
            if not coffeeMaker then return end
            if not WaitAndCollectFromCoffeeMaker(coffeeMaker, cookingPrompt) then return end
            local creamerIngredient = creamerRecipeCfg and creamerRecipeCfg.ApplyIngredient
            if not creamerIngredient then
                notyuri("No ApplyIngredient in Recipes[\"Creamer Coffee\"], cannot apply creamer")
                return
            end
            if not ApplyIngredientToOrder(creamerIngredient, "Creamer Coffee") then return end
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Iced Creamer Coffee"] = function()
            local creamerRecipeCfg = Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes["Creamer Coffee"]
            local coffeeMaker, cookingPrompt = PlaceBeansInCoffeeMaker("Creamer Coffee")
            if not coffeeMaker then return end
            if not WaitAndCollectFromCoffeeMaker(coffeeMaker, cookingPrompt) then return end
            local creamerIngredient = creamerRecipeCfg and creamerRecipeCfg.ApplyIngredient
            if not creamerIngredient then
                notyuri("No ApplyIngredient in Recipes[\"Creamer Coffee\"], cannot apply creamer")
                return
            end
            if not ApplyIngredientToOrder(creamerIngredient, "Creamer Coffee") then return end
            local icedRecipeCfg = Modules.CafeOrderGuideConfig.Recipes and Modules.CafeOrderGuideConfig.Recipes["Iced Creamer Coffee"]
            local iceIngredient = icedRecipeCfg and icedRecipeCfg.ApplyIngredient
            if not iceIngredient then
                notyuri("No ApplyIngredient in Recipes[\"Iced Creamer Coffee\"], cannot apply ice")
                return
            end
            if not ApplyIngredientToOrder(iceIngredient, "Iced Creamer Coffee") then return end
            ServeHeldFood(orderState.CustomerId)
        end,
        ["Croissant"] = function()
            local existingDough = GetTool()
            if existingDough and existingDough:GetAttribute("IsRecipeFood") == true and existingDough:GetAttribute("FoodType") == "Croissant" and existingDough:GetAttribute("Doneness") == "Uncooked" then
                local oven, bakePrompt = BakeCroissant(existingDough)
                if not oven then return end
                if not WaitAndCollectFromOven(oven, bakePrompt) then return end
                ApplyOrderToppings(orderState, orderState.FoodType)
                ServeHeldFood(orderState.CustomerId)
                return
            end
            local bowl = FindFreeBatterBowl()
            if not bowl then return end
            WithBowlReservation(bowl, function()
                local batterTool = FillBowlAndGetBatter(bowl)
                if not batterTool then return end
                State.BowlsInUse[bowl] = nil
                local pinBoard = PlaceBatterOnPinBoard()
                if not pinBoard then return end
                local doughTool = WaitForCroissantDoughTool(30)
                if not doughTool then
                    notyuri("Timed out waiting for Croissant dough tool after pin board")
                    return
                end
                local oven, bakePrompt = BakeCroissant(doughTool)
                if not oven then return end
                if not WaitAndCollectFromOven(oven, bakePrompt) then return end
                ApplyOrderToppings(orderState, orderState.FoodType)
                ServeHeldFood(orderState.CustomerId)
            end)
        end,
    }
    local handler = foodDispatch[orderState.FoodType]
    if handler then
        local ok, err = pcall(handler)
        if not ok then
            notyuri("AutoCook order error: " .. tostring(err))
        end
        return
    end
    local bowl = FindFreeBatterBowl()
    if not bowl then
        return
    end
    local ok, err = WithBowlReservation(bowl, function()
        local batterTool = FillBowlAndGetBatter(bowl)
        if not batterTool then
            return
        end
        State.BowlsInUse[bowl] = nil
        local grillPart, takePrompt, flipPrompt = PlaceBatterOnGrill(orderState.FoodType)
        if not grillPart then
            return
        end
        if not WaitAndCollectFromGrill(grillPart, takePrompt, flipPrompt, orderState.FoodType) then
            return
        end
        ApplyOrderToppings(orderState, orderState.FoodType)
        ServeHeldFood(orderState.CustomerId)
    end)
    if not ok then
        notyuri("AutoCook order error: " .. tostring(err))
    end
end
local function Func_AutoCafe()
    while Toggles.AutoCook.Value do
        local ok, err = pcall(function()
            if not Modules.CafeOrderGuideConfig then
                notyuri("Modules.CafeOrderGuideConfig not loaded, stopping")
                Toggles.AutoCook.Value = false
                return
            end
            if State.InFlightCount >= Constants.MAX_CONCURRENT_ORDERS then
                task.wait(0.5)
                return
            end
            local pending = GetSupportedOrders(State.InFlightOrderIds)
            if #pending == 0 then
                task.wait(1)
                return
            end
            local slots = Constants.MAX_CONCURRENT_ORDERS - State.InFlightCount
            for i = 1, math.min(slots, #pending) do
                local orderState = pending[i]
                State.InFlightOrderIds[orderState.OrderId] = true
                State.InFlightCount = State.InFlightCount + 1
                task.spawn(function()
                    ProcessOrder(orderState)
                    State.InFlightOrderIds[orderState.OrderId] = nil
                    State.InFlightCount = State.InFlightCount - 1
                end)
            end
        end)
        if not ok then
            notyuri("AutoCook error: " .. tostring(err))
        end
        task.wait(0.5)
    end
end
local AutoUpgradeSelected
local function Func_AutoUpgrade()
    while Toggles.AutoUpgrade.Value do
        local ok, err = pcall(function()
            if not Modules.UpgradesConfig then
                Toggles.AutoUpgrade.Value = false
                return
            end
            local selectedIds = AutoUpgradeSelected()
            local sessionUpgrades = GetSessionUpgrades()
            local cash = RS:GetAttribute("CafeCash") or 0
            local bridge = GetBridge("RequestUpgradePurchase")
            if not bridge then
                Toggles.AutoUpgrade.Value = false
                return
            end
            for _, upgrade in ipairs(Modules.UpgradesConfig.GetUpgrades()) do
                if selectedIds[upgrade.Id] then
                    local level = Modules.UpgradesConfig.GetLevel(sessionUpgrades, upgrade.Id)
                    local price = Modules.UpgradesConfig.GetPrice(upgrade.Id, level)
                    local missingRequirement = Modules.UpgradesConfig.GetMissingRequirement(sessionUpgrades, upgrade.Id)
                    if not missingRequirement and price and cash >= price then
                        bridge:Fire(upgrade.Id)
                        cash = cash - price
                        task.wait(0.3)
                    end
                end
            end
        end)
        if not ok then
            notyuri("AutoUpgrade error: " .. tostring(err))
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
        if Toggles.JP.Value then
            Hum.JumpPower = Options.JPValue.Value
            Hum.UseJumpPower = true
        end
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
        if Toggles.NoFog.Value then Lighting.FogEnd = Constants.FOG_END_DISTANCE end
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
        setfpscap(Constants.FPS_CAP_FALLBACK)
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
local function MinigameConn(enabled)
    if enabled then
        State.CookingMinigameStartRefCount = State.CookingMinigameStartRefCount + 1
        if State.CookingMinigameStartRefCount == 1 then
            SafeConnect("CookingMinigameStart", function()
                local bridge = GetBridge("CookingMinigameStart")
                if not bridge then
                    error("CookingMinigameStart bridge not available")
                end
                return bridge
            end, HandleCookingMinigameStart)
        end
    else
        State.CookingMinigameStartRefCount = math.max(0, State.CookingMinigameStartRefCount - 1)
        if State.CookingMinigameStartRefCount == 0 then
            if Connections.CookingMinigameStart then
                Connections.CookingMinigameStart:Disconnect()
                Connections.CookingMinigameStart = nil
            end
        end
    end
end
TB_Tabs.Autofarm.T1:AddToggle("AutoCook", {
    Text = "Auto Cook",
    Default = false,
})
Toggles.AutoCook:OnChanged(function(state)
    Thread("AutoCook", SafeLoop("AutoCook", Func_AutoCafe), state)
    MinigameConn(state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoOrder", {
    Text = "Auto Order",
    Default = false,
})
Toggles.AutoOrder:OnChanged(function(state)
    Thread("AutoOrder", SafeLoop("AutoOrder", Func_AutoOrder), state)
    MinigameConn(state)
end)
do
    local upgradeValues = {}
    local upgradeLabelToId = {}
    if Modules.UpgradesConfig then
        for _, upgrade in ipairs(Modules.UpgradesConfig.GetUpgrades()) do
            table.insert(upgradeValues, upgrade.DisplayName)
            upgradeLabelToId[upgrade.DisplayName] = upgrade.Id
        end
    end
    AutoUpgradeSelected = AddMultiDropdown(TB_Tabs.Autofarm2.T1, "UpgradeSelected", {
        Text = "Upgrades List",
        Values = upgradeValues,
        label = upgradeLabelToId,
    })
end
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", {
    Text = "Auto Upgrade",
    Default = false,
})
Toggles.AutoUpgrade:OnChanged(function(state)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoRetry", {
    Text = "Auto Retry",
    Default = false,
})
Toggles.AutoRetry:OnChanged(function(state)
    Thread("AutoRetry", SafeLoop("AutoRetry", Func_AutoRetry), state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoCoffee", {
    Text = "Auto Coffee",
    Default = false,
})
Toggles.AutoCoffee:OnChanged(function(state)
    Thread("AutoCoffee", SafeLoop("AutoCoffee", Func_AutoCoffee), state)
end)
TB_Tabs.Autofarm.T1:AddToggle("AutoDevour", {
    Text = "Auto Devour",
    Default = false,
})
Toggles.AutoDevour:OnChanged(function(state)
    Thread("AutoDevour", SafeLoop("AutoDevour", Func_AutoDevour), state)
end)
TB_Tabs.Autofarm2.T1:AddSlider("CoffeeThreshold", {
    Text = "Coffee Threshold",
    Default = 95,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoSkipDialogue", {
    Text = "Auto Skip Dialogue",
    Default = false,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoJoin", {
    Text = "Auto Join",
    Default = false,
})
Toggles.AutoJoin:OnChanged(function(state)
    Thread("AutoJoin", SafeLoop("AutoJoin", Func_AutoJoin), state)
end)
Toggles.AutoSkipDialogue:OnChanged(function(state)
    SetAutoSkipDialogue(state)
end)
local ESPGroup = Tabs.ESP:AddLeftGroupbox("ESP")
ESPGroup:AddToggle("CustomerESP", { Text = "Customer", Default = false })
ESPGroup:AddLabel("Customer Color"):AddColorPicker("CustomerColor", {
    Title = "Customer Color",
    Default = Color3.fromRGB(80, 255, 120),
})
ESPGroup:AddLabel("Anomaly Color"):AddColorPicker("AnomalyColor", {
    Title = "Anomaly Color",
    Default = Color3.fromRGB(255, 60, 60),
})
ESPGroup:AddLabel("Outline Color"):AddColorPicker("CustomerOutline", {
    Title = "Outline Color",
    Default = Color3.fromRGB(0, 0, 0),
})
Toggles.CustomerESP:OnChanged(function()
    RefreshCustomerESP()
end)
task.spawn(SafeLoop("CustomerESP", FuncCustomerESP))
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
    getgenv().ayasemiyakissazumirsa = false
    State.Farm = false
    Cleanup(Connections)
    Cleanup(Flags)
    CustomerESPFolder:Destroy()
    Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/AnomalyCafe")
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
if not scriptLoadOk then
    Library:Notify("ERROR: " .. tostring(scriptLoadErr), 4)
    notyuri("ERROR: " .. tostring(scriptLoadErr))
end