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
local PacketModule = GetSafeModule(RS, "Packet")
local Remotes = {
    Packet = PacketModule,
    CubeFusionPacket = nil,   
    PickUpPacket      = nil,
    DropPacket        = nil,
    BuyUpgradePacket  = nil,
    ClaimBadgePacket  = nil,
    SettingsPacket    = nil,
    UseLifeCubePacket = nil,
    CrystalRevivePacket = nil,
}
local Modules = {
    Packet = PacketModule,
    HitRaycast = GetSafeModule(RS:WaitForChild("Modules"), "HitRaycast"),
}
local function InitPackets()
    if not PacketModule then return end
    pcall(function()
        Remotes.CubeFusionPacket = PacketModule("CubeFusion", PacketModule.Instance, PacketModule.Instance, PacketModule.Vector3F32)
        Remotes.PickUpPacket      = PacketModule("PickUp", PacketModule.Instance)
        Remotes.DropPacket        = PacketModule("Drop", PacketModule.CFrameF24U8, PacketModule.Any)
        Remotes.BuyUpgradePacket  = PacketModule("BuyUpgrade", PacketModule.String)
        Remotes.ClaimBadgePacket  = PacketModule("ClaimBadge", PacketModule.String)
        Remotes.SettingsPacket    = PacketModule("Settings", PacketModule.String, PacketModule.Any)
        Remotes.UseLifeCubePacket = PacketModule("UseLifeCube", PacketModule.Instance)
        Remotes.CrystalRevivePacket = PacketModule("CrystalRevive")
    end)
end
InitPackets()
local function GetPacket(scriptPath, upvaluePredicate)
    if not (getgc and getfenv) then return nil end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    if not dbgGetUpvals then return nil end
    local islclosureFn = islclosure or is_l_closure or function() return true end
    local targetScript
    pcall(function()
        local cur = game
        for part in string.gmatch(scriptPath, "[^.]+") do
            cur = cur:FindFirstChild(part)
            if not cur then break end
        end
        targetScript = cur
    end)
    if not targetScript then return nil end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) == "function" and islclosureFn(fn) then
            local okE, env = pcall(getfenv, fn)
            if okE and type(env) == "table" and rawget(env, "script") == targetScript then
                local okU, uvs = pcall(dbgGetUpvals, fn)
                if okU and type(uvs) == "table" then
                    local found = upvaluePredicate(uvs)
                    if found then return found end
                end
            end
        end
    end
    return nil
end
if not Remotes.CubeFusionPacket then
    local harvested = GetPacket(
        "Players.LocalPlayer.PlayerScripts.Client.Systems.Combine",
        function(uvs)
            for _, v in pairs(uvs) do
                if type(v) == "table" and v.Name == "CubeFusion" and v.Fire then return v end
            end
        end
    )
    if harvested then
        Remotes.CubeFusionPacket = harvested
        notyuri("[Packet] CubeFusion harvested via getfenv(Combine script)")
    end
end
local CombineModule = nil
local function GetCombineModule()
    if CombineModule then return CombineModule end
    CombineModule = GetPacket(
        "Players.LocalPlayer.PlayerScripts.Client.Systems.Combine",
        function(uvs)
            for _, v in pairs(uvs) do
                if type(v) == "table"
                    and type(rawget(v, "CubeTouch")) == "function"
                    and type(rawget(v, "HandleCube")) == "function" then
                    return v
                end
            end
        end
    )
    if CombineModule then
        notyuri("[Combine] module table harvested (CubeTouch available)")
    end
    return CombineModule
end
GetCombineModule()
local GameFireDrop = nil
local function GetGameFireDrop()
    if GameFireDrop then return GameFireDrop end
    if not (getgc and getfenv) then return nil end
    local dbgGetUpvals = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
    if not dbgGetUpvals then return nil end
    local islclosureFn = islclosure or is_l_closure or function() return true end
    local targetScript
    pcall(function()
        local cur = game
        for part in string.gmatch("Players.LocalPlayer.PlayerScripts.Client.Systems.Drop", "[^.]+") do
            cur = cur:FindFirstChild(part)
            if not cur then break end
        end
        targetScript = cur
    end)
    if not targetScript then return nil end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" or not islclosureFn(fn) then continue end
        local okE, env = pcall(getfenv, fn)
        if not okE or type(env) ~= "table" or rawget(env, "script") ~= targetScript then continue end
        local okU, uvs = pcall(dbgGetUpvals, fn)
        if not okU or type(uvs) ~= "table" then continue end
        for _, uv in pairs(uvs) do
            if type(uv) == "table" and uv.Name == "Drop" and type(uv.Fire) == "function" then
                GameFireDrop = fn
                notyuri("[Drop] FireDrop harvested via getfenv(Drop script)")
                return GameFireDrop
            end
        end
    end
    return nil
end
GetGameFireDrop()
local function GetBackpackC()
    local out = {}
    local cubes = workspace:FindFirstChild("Cubes")
    if cubes then
        for _, t in ipairs(cubes:GetChildren()) do
            if t:IsA("Tool") then table.insert(out, t) end
        end
    end
    return out
end
local function GetCubeModel(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    return tool:FindFirstChildOfClass("Model")
end
local function GetCName(tool)
    local m = GetCubeModel(tool)
    return m and m.Name or tool.Name
end
local function CountCubeInBackpack(name)
    local n = 0
    for _, t in ipairs(GetBackpackC()) do
        if GetCName(t) == name then n = n + 1 end
    end
    return n
end
local function FindCBP(name)
    for _, t in ipairs(GetBackpackC()) do
        if GetCName(t) == name then return t end
    end
    return nil
end
local function FindTwoCubeToolsInWorld(name)
    local first = nil
    local cubes = workspace:FindFirstChild("Cubes")
    if not cubes then return nil, nil end
    for _, t in ipairs(cubes:GetChildren()) do
        if t:IsA("Tool") and GetCName(t) == name then
            if not first then
                first = t
            else
                return first, t
            end
        end
    end
    return nil, nil
end
local function GetGems()
    local ls = Plr:FindFirstChild("leaderstats")
    local v = ls and ls:FindFirstChild("Gems")
    return v and v.Value or 0
end
local function GetCombinations()
    local ls = Plr:FindFirstChild("leaderstats")
    local v = ls and ls:FindFirstChild("Combinations")
    return v and v.Value or 0
end
local WikiRecipes = {
    ["Advanced Backpack Cube"] = {
        {"Military Backpack Cube", "Reinforced Black Cryoide Cube"}
    },
    ["Air Cube"] = {
        {"Steam Cube", "White Cube"}
    },
    ["Armor Cube"] = {
        {"Copper Cube", "Gold Cube"}
    },
    ["Assist Cube"] = {
        {"Life Cube", "Wealth Cube"}
    },
    ["Backpack Cube"] = {
        {"Container Cube", "Wealth Cube"}
    },
    ["Battery"] = {
        {"Copper Wealth Cube", "Lithium Cube"}
    },
    ["Black Cryoide Cube"] = {
        {"Black Iron Dust", "Cryoide Cube"}
    },
    ["Black Iron Cage"] = {
        {"Black Iron Cube", "Magenta Cube"}
    },
    ["Black Iron Cube"] = {
        {"Black Iron", "Lithium Cube"}
    },
    ["Bluesteel Cube"] = {
        {"Bluesteel Ingot", "Reinforced Goldplate Cube"}
    },
    ["Bomb Cube"] = {
        {"Explosive Cube", "Lava Cube"}
    },
    ["Concrete Cube"] = {
        {"Mud Cube", "Wet Sand Cube"}
    },
    ["Container Cube"] = {
        {"Pack Cube", "Plate Cube"}
    },
    ["Contaminated Cube"] = {
        {"Poison Cube", "Rusted Iron Cube"}
    },
    ["Cooled Lava Cube"] = {
        {"Glacier Cube", "Lava Cube"}
    },
    ["Copper Cube"] = {
        {"Copper Ingot", "White Cube"}
    },
    ["Copper Handle"] = {
        {"Reinforced Hammer Handle", "Wealth Copper Cube"}
    },
    ["Copper Spiked Cube"] = {
        {"Spiked Cube", "Copper Cube"}
    },
    ["Copper Wealth Cube"] = {
        {"Copper Cube", "Wealth Cube"}
    },
    ["Cryoide Cube"] = {
        {"Cryoide Ingot", "Whie Cube"}
    },
    ["Cryoide Ingot"] = {
        {"Cryoide Dust", "Gold Ingot"}
    },
    ["Cube Pedestral"] = {
        {"Steel Plate Cube", "Reinforced Forge Cube"}
    },
    ["Cyan Cube"] = {
        {"Blue Cube", "Green Cube"}
    },
    ["Enriched Regen Cube"] = {
        {"Regen Cube", "Enrichment Cube"}
    },
    ["Enriched White Cube"] = {
        {"Enrichment Cube", "White Cube"}
    },
    ["Enricher"] = {
        {"Cooled Lava Cube", "Goldplate Cube"}
    },
    ["Enrichment Cube"] = {
        {"Enricher", "Wealth Cube"}
    },
    ["Explosive Cube"] = {
        {"Gunpowder Cube", "Throwable Cube"}
    },
    ["Forge Cube"] = {
        {"Iron Cube", "Gold Cube"}
    },
    ["Frigid Cube"] = {
        {"Glacier Cube", "Cryoide Dust"}
    },
    ["Fusion Power Cube"] = {
        {"Blaze Power Cube", "Glacier Generator Cube"}
    },
    ["Glacier Cube"] = {
        {"Ice Cube", "Water Cube"}
    },
    ["Glassbound Reinforced Goldplate Cube"] = {
        {"Glass Cube", "Reinforced Goldplate Cube"}
    },
    ["Glassbound Wealth Copper Cube"] = {
        {"Wealth Copper Cube", "Glass Cube"}
    },
    ["Gold Cube"] = {
        {"Gold", "White Cube"}
    },
    ["Goldplate Cube"] = {
        {"Plate Cube", "Wealth Cube"}
    },
    ["Healer Cube"] = {
        {"Green Cube", "Plate Cube"}
    },
    ["Heartbeat Cube"] = {
        {"Black Iron Cube", "Life Cube"}
    },
    ["Hell Cube"] = {
        {"Reinforced Pyrolithium Cube", "Hellfire Cube"}
    },
    ["Hellfire Cube"] = {
        {"Dragon Fire Cube", "Black Magic Cube"}
    },
    ["Hindrance Cube"] = {
        {"Poverty Cube", "Assist Cube"}
    },
    ["Impact Bomb Cube"] = {
        {"Bomb Cube", "Impact Cube"}
    },
    ["Impact Cube"] = {
        {"Explosive Cube", "Enrichment Cube"}
    },
    ["Iron Cube"] = {
        {"Iron", "White Cube"}
    },
    ["Lamp Charger"] = {
        {"Cube Pedestral", "Battery"}
    },
    ["Lamp Cube"] = {
        {"Glass Cube", "Lava Cube"}
    },
    ["Lava Cube"] = {
        {"Molten Sphere", "Rock Cube"}
    },
    ["Life Cube"] = {
        {"Healer Cube", "Enrichment Cube"}
    },
    ["Lithium Cube"] = {
        {"Lithium", "White Cube"}
    },
    ["Loyalty Cube"] = {
        {"Glassbound Reinforced Goldplate Cube", "Heartbeat Cube"}
    },
    ["Magenta Cube"] = {
        {"Blue Cube", "Red Cube"}
    },
    ["Magma Cube"] = {
        {"Black Iron Cube", "Lava Cube"}
    },
    ["Military Backpack Cube"] = {
        {"Backpack Cube", "Fabric Cube"}
    },
    ["Move Cube"] = {
        {"Air Cube", "Forge Cube"}
    },
    ["Moving Tool"] = {
        {"Move Cube", "BTools"}
    },
    ["Mud Cube"] = {
        {"Dirt Cube", "Water Cube"}
    },
    ["Overdrive Cube"] = {
        {"Glassbound Wealth Copper Cube", "Glass Cube"}
    },
    ["Pack Cube"] = {
        {"Dirt Cube", "Wood Cube"}
    },
    ["Plate Cube"] = {
        {"Iron Cube", "Forge Cube"}
    },
    ["Poison Cube"] = {
        {"Regen Cube", "Poverty Cube"}
    },
    ["Poverty Cube"] = {
        {"Suspect Book", "Enrichment Cube"}
    },
    ["Power Controller Cube"] = {
        {"Fusion Power Cube", "Health Controller Cube"}
    },
    ["Pyroforge Cube"] = {
        {"Forge Cube", "Pyrolite Cube"}
    },
    ["Pyrolite Cube"] = {
        {"Pyrolite Ingot", "White Cube"}
    },
    ["Pyrolite Heart"] = {
        {"Enricher", "Pyrolite Plate Cube"}
    },
    ["Pyrolite Heart Cube"] = {
        {"Pyrolite Heart", "Pyrolite Plate Cube"}
    },
    ["Pyrolite Plate Cube"] = {
        {"Pyroforge Cube", "Pyrolite Cube"}
    },
    ["Recall Cube"] = {
        {"Magnet Cube", "Enrichment Cube"}
    },
    ["Regen Cube"] = {
        {"Healer Cube", "Wealth Cube"}
    },
    ["Reinforced Black Cryoide Cube"] = {
        {"Black Cryoide Cube", "Reinforced Goldplate Cube"}
    },
    ["Reinforced Forge Cube"] = {
        {"Steel Cube", "Forge Cube"}
    },
    ["Reinforced Goldplate Cube"] = {
        {"Reinforced Plate Cube", "Reinforced Wealth Cube"}
    },
    ["Reinforced Hammer Handle"] = {
        {"Compressor", "Reinforced Hammer"}
    },
    ["Reinforced Lithium Cube"] = {
        {"Steel Cube", "Lithium Cube"}
    },
    ["Reinforced Plate Cube"] = {
        {"Reinforced Forge Cube", "Iron Cube"}
    },
    ["Reinforced Pyrolithium Cube"] = {
        {"Reinforced Lithium Cube", "Pyrolite Cube"}
    },
    ["Reinforced Storage Cube"] = {
        {"Storage Soul", "Reinforced Goldplate Cube"}
    },
    ["Reinforced Wealth Cube"] = {
        {"Reinforced Forge Cube", "Gold Cube"}
    },
    ["Repacking Cube"] = {
        {"Air Cube", "Wealth Cube"}
    },
    ["Repacking Tool"] = {
        {"Repacking Cube", "BTools"}
    },
    ["Riddance Cube"] = {
        {"Life Cube", "Reinforced Lithium Cube"}
    },
    ["Rusted Iron Cube"] = {
        {"Rusted Iron Ingot", "White Cube"}
    },
    ["Rusted Spiked Cube"] = {
        {"Spiked Cube", "Rusted Iron Cube"}
    },
    ["Sacrificial Cube"] = {
        {"Pyrolite Heart Cube", "Heartbeat Cube"}
    },
    ["Sand Cube"] = {
        {"Rock Cube", "Steam Cube"}
    },
    ["Spiked Cube"] = {
        {"Spike", "Plate Cube"}
    },
    ["Steel Cube"] = {
        {"Steel Ingot", "White Cube"}
    },
    ["Steel Handle"] = {
        {"Reinforced Hammer Handle", "Steel Cube"}
    },
    ["Steel Plate Cube"] = {
        {"Steel Cube", "Reinforced Forge Cube"}
    },
    ["Storage Cube"] = {
        {"Storage Soul", "Wood Cube"}
    },
    ["Storage Soul"] = {
        {"Storage Cube", "Compressor"}
    },
    ["Subzero Handle"] = {
        {"Reinforced Hammer Handle", "Reinforced Cryoide Crystal"}
    },
    ["Throwable Cube"] = {
        {"Iron Ingot", "Red Cube"}
    },
    ["Void Cube"] = {
        {"Void Fragment", "Black Magic Cube"}
    },
    ["Wealth Cube"] = {
        {"Gold Cube", "Forge Cube"}
    },
    ["Wet Sand Cube"] = {
        {"Sand Cube", "Water Cube"}
    },
    ["White Cube"] = {
        {"Red Cube", "Cyan Cube"},
        {"Green Cube", "Magenta Cube"},
        {"Blue Cube", "Yellow Cube"}
    },
    ["World Generation Cube"] = {
        {"Health Controller Cube", "Life Cube"}
    },
    ["Yellow Cube"] = {
        {"Red Cube", "Green Cube"}
    },
    ["conen Cube"] = {
        {"Ash Cube", "Burned Wood Cube"}
    },
}
local function GetAllRecipes()
    local recipes = {}
    for outputName, combos in pairs(WikiRecipes) do
        recipes[outputName] = combos[1]
    end
    return recipes
end
local function GetRecipe(outputName)
    local combos = WikiRecipes[outputName]
    if combos then return combos[1] end
    return nil
end
local function GetDiscoveredC()
    local seen = {}
    local names = {}
    local function add(name)
        if not seen[name] then seen[name] = true; table.insert(names, name) end
    end
    for outputName, combos in pairs(WikiRecipes) do
        add(outputName)
        for _, combo in ipairs(combos) do
            for _, ingredient in ipairs(combo) do
                add(ingredient)
            end
        end
    end
    table.sort(names)
    return names
end
local function GetCombinable()
    local names = {}
    for outputName in pairs(WikiRecipes) do
        table.insert(names, outputName)
    end
    table.sort(names)
    return names
end
local function GetWorldC()
    local names = {}
    local cubes = workspace:FindFirstChild("Cubes")
    if cubes then
        for _, t in ipairs(cubes:GetChildren()) do
            if t:IsA("Tool") then table.insert(names, GetCName(t)) end
        end
    end
    table.sort(names)
    return names
end
local function GetUpgrades()
    local out = {}
    local au = RS:FindFirstChild("AvailableUpgrades")
    if au then
        for _, upg in ipairs(au:GetChildren()) do
            local price = upg:GetAttribute("Price")
            local display = upg:GetAttribute("DisplayName") or upg.Name
            if price and not upg.Value then   
                table.insert(out, { name = upg.Name, price = price, display = display })
            end
        end
    end
    return out
end
local function CombineCubes(toolA, toolB)
    if not Remotes.CubeFusionPacket then return false end
    local modelA = GetCubeModel(toolA)
    local modelB = GetCubeModel(toolB)
    if not modelA or not modelB then return false end
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local pos = hrp and hrp.Position or Vector3.new()
    pcall(function() Remotes.CubeFusionPacket:Fire(modelA, modelB, pos) end)
    return true
end
local function Smelt(A, B)
    local function resolveModel(v)
        if v:IsA("Model") or v:IsA("BasePart") then return v end
        return GetCModel(v)
    end
    local modelA = resolveModel(A)
    local modelB = resolveModel(B)
    if not modelA or not modelB then return false end
    local rootA = modelA:IsA("Model") and modelA:FindFirstChild("Root") or modelA
    if not rootA then return false end
    if not Remotes.CubeFusionPacket then return false end
    local char = Plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local pos = hrp and hrp.Position or rootA.Position
    pcall(function() Remotes.CubeFusionPacket:Fire(modelA, modelB, pos) end)
    notyuri("[Combine] fired:", modelA.Name, "+", modelB.Name)
    return true
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
local function Func_AutoCombine()
    while Toggles.AutoCombine.Value do
        local rawValue = Options.CombinationList and Options.CombinationList.Value
        local selected = {}
        if rawValue then
            if rawValue["All"] then
                selected = GetCombinable()
            else
                for name, active in pairs(rawValue) do
                    if active then table.insert(selected, name) end
                end
            end
        end
        if #selected > 0 and Remotes.CubeFusionPacket then
            for _, outputName in ipairs(selected) do
                if not Toggles.AutoCombine.Value then break end
                local recipe = GetRecipe(outputName)
                if recipe and #recipe >= 2 then
                    local in1, in2 = recipe[1], recipe[2]
                    local toolA, toolB
                    if in1 == in2 then
                        toolA, toolB = FindTwoCubeToolsInWorld(in1)
                    else
                        toolA = FindCBP(in1)
                        toolB = FindCBP(in2)
                    end
                    if toolA and toolB and toolA ~= toolB then
                        CombineCubes(toolA, toolB)
                        notyuri("[AutoCombine] combined", in1, "+", in2, "->", outputName)
                        task.wait()
                    end
                end
            end
        end
        task.wait(.1)
    end
end
local function Func_AutoPickup()
    while Toggles.AutoPickup.Value do
        if Remotes.PickUpPacket then
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local cubes = workspace:FindFirstChild("Cubes")
            local range = (Options.ReachRange and Options.ReachRange.Value) or 30
            local rawValue = Options.PickupList and Options.PickupList.Value
            local selectedFilter = {}
            local anySelected = false
            if rawValue then
                for name, active in pairs(rawValue) do
                    if active then
                        if name == "Any" then anySelected = true end
                        selectedFilter[name] = true
                    end
                end
            end
            local hasFilter = not anySelected and next(selectedFilter) ~= nil
            if hrp and cubes then
                local candidates = {}
                for _, tool in ipairs(cubes:GetChildren()) do
                    if tool:IsA("Tool") then
                        local cubeName = GetCName(tool)
                        if not hasFilter or selectedFilter[cubeName] then
                            local model = GetCubeModel(tool)
                            local root = model and model:FindFirstChild("Root")
                            if root and root:IsA("BasePart") then
                                local dist = (hrp.Position - root.Position).Magnitude
                                if dist <= range then
                                    table.insert(candidates, {tool = tool, dist = dist})
                                end
                            end
                        end
                    end
                end
                table.sort(candidates, function(a, b) return a.dist < b.dist end)
                for _, entry in ipairs(candidates) do
                    if not Toggles.AutoPickup.Value then break end
                    pcall(function() Remotes.PickUpPacket:Fire(entry.tool) end)
                    task.wait()
                end
            end
        end
        task.wait(0.1)
    end
end
local function Func_AutoUpgrades()
    while Toggles.AutoUpgrades.Value do
        if Remotes.BuyUpgradePacket then
            local rawValue = Options.UpgradeList and Options.UpgradeList.Value
            local selectedFilter = {}
            local anySelected = rawValue == nil or next(rawValue) == nil
            if rawValue then
                for name, active in pairs(rawValue) do
                    if active then selectedFilter[name] = true end
                end
            end
            for _, upg in ipairs(GetUpgrades()) do
                if not Toggles.AutoUpgrades.Value then break end
                if anySelected or selectedFilter[upg.name] then
                    if GetGems() >= upg.price then
                        pcall(function() Remotes.BuyUpgradePacket:Fire(upg.name) end)
                        notyuri("[AutoUpgrades] bought", upg.name, "for", upg.price, "gems")
                        task.wait()
                    end
                end
            end
        end
        task.wait(.175)
    end
end
local function EnableInstantCombination()
    if Remotes.SettingsPacket then
        pcall(function() Remotes.SettingsPacket:Fire("InstantCombination", true) end)
        Library:Notify("InstantCombination enabled.", 4)
        notyuri("[Settings] InstantCombination = true")
    end
end
local function EnableFastPickup()
    if Remotes.SettingsPacket then
        pcall(function() Remotes.SettingsPacket:Fire("FastPickup", true) end)
        pcall(function() Remotes.SettingsPacket:Fire("FastDrop", true) end)
        pcall(function() Remotes.SettingsPacket:Fire("CursorPickUp", true) end)
        Library:Notify("FastPickup/FastDrop/CursorPickUp enabled.", 4)
        notyuri("[Settings] FastPickup + FastDrop + CursorPickUp = true")
    end
end
local function DropC(cframe)
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    local fireDrop = GetGameFireDrop()
    if fireDrop then
        local dropCF = cframe or hrp.CFrame * CFrame.new(0, 0, -4)
        pcall(fireDrop, dropCF, tool)
        notyuri("[Drop] dropped via game FireDrop")
        return
    end
    if not Remotes.DropPacket then Library:Notify("Drop packet not ready.", 3) return end
    local cf = cframe or hrp.CFrame * CFrame.new(0, 0, -4)
    pcall(function() Remotes.DropPacket:Fire(cf, tool) end)
    notyuri("[Drop] dropped equipped cube via DropPacket fallback")
end
local function CrystalRevive()
    if not Remotes.CrystalRevivePacket then Library:Notify("CrystalRevive packet not ready.", 3) return end
    pcall(function() Remotes.CrystalRevivePacket:Fire() end)
    Library:Notify("Crystal revive fired.", 3)
    notyuri("[CrystalRevive] fired")
end
local function GetC()
    local seen = {}
    local names = {}
    for _, name in ipairs(GetDiscoveredC()) do
        if not seen[name] then seen[name] = true; table.insert(names, name) end
    end
    for _, name in ipairs(GetWorldC()) do
        if not seen[name] then seen[name] = true; table.insert(names, name) end
    end
    table.sort(names)
    return names
end
local function RefreshUpgradeDD()
    if not Options.UpgradeList then return end
    local names = {}
    for _, upg in ipairs(GetUpgrades()) do
        table.insert(names, upg.name)
    end
    table.sort(names)
    Options.UpgradeList:SetValues(names)
    notyuri("[AutoUpgrades] loaded", #names, "upgrades into dropdown")
end
local function RefreshCDD()
    local names = GetC()
    table.insert(names, 1, "Any")
    if Options.PickupList then Options.PickupList:SetValues(names) end
    if Options.SmeltList then Options.SmeltList:SetValues(names) end
    if Options.ExpandList then Options.ExpandList:SetValues(names) end
    if Options.MoveList then Options.MoveList:SetValues(names) end
    notyuri("[MoveCube] loaded", #names, "cubes into dropdowns")
end
local function RefreshRCPDD()
RefreshUpgradeDD()
    RefreshCDD()
    if not Options.CombinationList then return end
    local names = GetCombinable()
    table.insert(names, 1, "All")
    Options.CombinationList:SetValues(names)
    notyuri("[Recipes] loaded", #names, "entries into dropdown")
end
local function GetFurnaceModel()
    local function findInContainer(container)
        if not container then return nil end
        for _, child in ipairs(container:GetChildren()) do
            if child.Name == "Furnace" then
                local inner = child:FindFirstChild("Furnace")
                if inner then
                    local innermost = inner:FindFirstChild("Furnace")
                    if innermost and innermost:FindFirstChild("Root") then
                        return innermost
                    end
                end
            end
        end
        return nil
    end
    return findInContainer(workspace:FindFirstChild("HardStructures"))
        or findInContainer(workspace:FindFirstChild("Structures"))
end
local function Func_AutoSmelt()
    while Toggles.AutoSmelt.Value do
        local furnaceModel = GetFurnaceModel()
        if not furnaceModel then
            notyuri("[AutoSmelt] no furnace found in workspace")
            task.wait(3)
            continue
        end
        local rawValue = Options.SmeltList and Options.SmeltList.Value
        local selectedFilter = {}
        local anySelected = false
        if rawValue then
            for name, active in pairs(rawValue) do
                if active then
                    if name == "Any" then anySelected = true end
                    selectedFilter[name] = true
                end
            end
        end
        local hasFilter = not anySelected and next(selectedFilter) ~= nil
        local cubes = workspace:FindFirstChild("Cubes")
        if cubes then
            local candidates = {}
            for _, tool in ipairs(cubes:GetChildren()) do
                if not Toggles.AutoSmelt.Value then break end
                if tool:IsA("Tool") then
                    local cubeName = GetCName(tool)
                    if not hasFilter or selectedFilter[cubeName] then
                        local model = GetCubeModel(tool)
                        local root = model and model:FindFirstChild("Root")
                        if root then
                            table.insert(candidates, {model = model, root = root, name = cubeName})
                        end
                    end
                end
            end
            for _, entry in ipairs(candidates) do
                if not Toggles.AutoSmelt.Value then break end
                Smelt(entry.model, furnaceModel)
                notyuri("[AutoSmelt] smelted", entry.name)
                task.wait()
            end
        end
        task.wait()
    end
end
local function GetSortedBridges()
    local bridges = workspace:FindFirstChild("Bridges")
    if not bridges then return {} end
    local list = {}
    for _, bridge in ipairs(bridges:GetChildren()) do
        table.insert(list, bridge)
    end
    table.sort(list, function(a, b)
        local sizeA = (a:IsA("BasePart") and a.Size.Magnitude) or 0
        local sizeB = (b:IsA("BasePart") and b.Size.Magnitude) or 0
        return sizeA > sizeB
    end)
    return list
end
local function Func_AutoExpand()
    while Toggles.AutoExpand.Value do
        if not Remotes.PickUpPacket then
            task.wait(2)
            continue
        end
        local cubes = workspace:FindFirstChild("Cubes")
        if not cubes then
            task.wait(2)
            continue
        end
        local biggestBridge = nil
        local bridgeRoot = nil
        local biggestSize = -1
        local bridges = workspace:FindFirstChild("Bridges")
        if bridges then
            for _, bridge in ipairs(bridges:GetChildren()) do
                local upgradeModel = bridge:FindFirstChild("BridgeUpgrade")
                local r = upgradeModel and upgradeModel:FindFirstChild("Root")
                if r then
                    local size = bridge:IsA("BasePart") and bridge.Size.Magnitude or 0
                    if size > biggestSize then
                        biggestSize = size
                        biggestBridge = bridge
                        bridgeRoot = r
                    end
                end
            end
        end
        if not biggestBridge or not bridgeRoot then
            task.wait(2)
            continue
        end
        local dropCF = bridgeRoot.CFrame
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            task.wait(2)
            continue
        end
        local rawValue = Options.ExpandList and Options.ExpandList.Value
        local selectedFilter = {}
        local anySelected = false
        if rawValue then
            for name, active in pairs(rawValue) do
                if active then
                    if name == "Any" then anySelected = true end
                    selectedFilter[name] = true
                end
            end
        end
        local hasFilter = not anySelected and next(selectedFilter) ~= nil
        local function GetHeldCount()
            local n = 0
            for _, t in ipairs(Plr.Backpack:GetChildren()) do
                if t:IsA("Tool") then n = n + 1 end
            end
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") then n = n + 1 end
            end
            return n
        end
        local maxCapacity = Plr:GetAttribute("BackpackSize") or 3
        for _, tool in ipairs(cubes:GetChildren()) do
            if not Toggles.AutoExpand.Value then break end
            if GetHeldCount() >= maxCapacity then break end
            if tool:IsA("Tool") then
                local cubeName = GetCName(tool)
                if not hasFilter or selectedFilter[cubeName] then
                    local model = GetCubeModel(tool)
                    local root = model and model:FindFirstChild("Root")
                    if root then
                        hrp.CFrame = CFrame.new(root.Position) * CFrame.new(0, 3, 0)
                    end
                    task.wait(.175)
                    pcall(function() Remotes.PickUpPacket:Fire(tool) end)
                    task.wait(.175)
                    local pickedUp = Plr.Backpack:FindFirstChild(tool.Name)
                    if pickedUp then
                        pickedUp.Parent = char
                        notyuri("[AutoExpand] picked up", cubeName, "(", GetHeldCount(), "/", maxCapacity, ")")
                    else
                        notyuri("[AutoExpand] pickup failed (server rejected?):", cubeName)
                    end
                end
            end
        end
        while Toggles.AutoExpand.Value and GetHeldCount() > 0 do
            local freshBridge, freshRoot = nil, nil
            local freshSize = -1
            local bridges = workspace:FindFirstChild("Bridges")
            if bridges then
                for _, bridge in ipairs(bridges:GetChildren()) do
                    local upgradeModel = bridge:FindFirstChild("BridgeUpgrade")
                    local r = upgradeModel and upgradeModel:FindFirstChild("Root")
                    if r then
                        local size = bridge:IsA("BasePart") and bridge.Size.Magnitude or 0
                        if size > freshSize then
                            freshSize = size
                            freshBridge = bridge
                            freshRoot = r
                        end
                    end
                end
            end
            if not freshBridge or not freshRoot then
                task.wait(.5)
                continue
            end
            local equipped = char:FindFirstChildOfClass("Tool")
            if not equipped then
                local next_tool = Plr.Backpack:FindFirstChildOfClass("Tool")
                if next_tool then
                    next_tool.Parent = char
                    task.wait(.175)
                end
            end
            local dropCF = freshRoot.CFrame
            notyuri("[AutoExpand] bridge root pos before drop:", dropCF.Position)
            hrp.CFrame = dropCF + Vector3.new(0, 4, 0)
            task.wait(.175)
            DropC(dropCF)
            notyuri("[AutoExpand] dropped at", freshBridge.Name, "(", GetHeldCount(), "remaining)")
            task.wait(.5)
            notyuri("[AutoExpand] bridge root pos after drop:", freshRoot.CFrame.Position)
        end
        task.wait()
    end
end
local function Func_MoveCubeToOre()
    if not Remotes.PickUpPacket then
        Library:Notify("PickUp/Drop packets not ready.", 3)
        return
    end
    local rawValue = Options.MoveList and Options.MoveList.Value
    local selected = {}
    if rawValue then
        for name, active in pairs(rawValue) do
            if active then table.insert(selected, name) end
        end
    end
    if #selected == 0 then
        Library:Notify("No cubes selected to move.", 3)
        return
    end
    local sortedBridges = GetSortedBridges()
    local targetTouchPart = nil
    for _, bridge in ipairs(sortedBridges) do
        local upgradeModel = bridge:FindFirstChild("BridgeUpgrade")
        if upgradeModel then
            local tp = upgradeModel:FindFirstChild("TouchPart")
            if tp then
                targetTouchPart = tp
                notyuri("[MoveCubeToOre] targeting bridge:", bridge.Name, "(size:", math.floor(bridge.Size.Magnitude * 10) / 10, ")")
                break
            end
        end
    end
    if not targetTouchPart then
        Library:Notify("No bridge TouchPart found.", 3)
        return
    end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Library:Notify("Character not found.", 3)
        return
    end
    local cubes = workspace:FindFirstChild("Cubes")
    if not cubes then return end
    local anySelected = false
    for _, name in ipairs(selected) do
        if name == "Any" then anySelected = true break end
    end
    local toolsToMove = {}
    if anySelected then
        for _, t in ipairs(cubes:GetChildren()) do
            if t:IsA("Tool") then
                local m = GetCubeModel(t)
                local r = m and m:FindFirstChild("Root")
                if r then
                    table.insert(toolsToMove, {tool = t, name = GetCName(t), dist = (hrp.Position - r.Position).Magnitude})
                end
            end
        end
        table.sort(toolsToMove, function(a, b) return a.dist < b.dist end)
    else
        for _, name in ipairs(selected) do
            local bestTool = nil
            local bestDist = math.huge
            for _, t in ipairs(cubes:GetChildren()) do
                if t:IsA("Tool") and GetCName(t) == name then
                    local m = GetCubeModel(t)
                    local r = m and m:FindFirstChild("Root")
                    if r then
                        local dist = (hrp.Position - r.Position).Magnitude
                        if dist < bestDist then bestDist = dist; bestTool = t end
                    end
                end
            end
            if bestTool then
                table.insert(toolsToMove, {tool = bestTool, name = name, dist = bestDist})
            else
                notyuri("[MoveCubeToOre] cube not found in world:", name)
            end
        end
    end
    local dropCF = targetTouchPart.CFrame
    for _, entry in ipairs(toolsToMove) do
        local name = entry.name
        local tool = entry.tool
        if tool then
            local model = GetCubeModel(tool)
            local root = model and model:FindFirstChild("Root")
            local originCF = hrp.CFrame
            if root then
                hrp.CFrame = CFrame.new(root.Position) * CFrame.new(0, 3, 0)
            end
            task.wait(.175)
            pcall(function() Remotes.PickUpPacket:Fire(tool) end)
            hrp.CFrame = originCF
            local pickedUp = Plr.Backpack:FindFirstChild(tool.Name)
            if pickedUp then
                pickedUp.Parent = char
                task.wait(1)
                DropC(dropCF)
                notyuri("[MoveCubeToOre] moved", name, "to bridge TouchPart")
            else
                notyuri("[MoveCubeToOre] pickup failed (server rejected?):", name)
            end
        end
    end
end
local function Func_MoveCubeToMe()
    if not Remotes.PickUpPacket then
        Library:Notify("PickUp/Drop packets not ready.", 3)
        return
    end
    local rawValue = Options.MoveList and Options.MoveList.Value
    local selected = {}
    if rawValue then
        for name, active in pairs(rawValue) do
            if active then table.insert(selected, name) end
        end
    end
    if #selected == 0 then
        Library:Notify("No cubes selected to move.", 3)
        return
    end
    local char = GetCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Library:Notify("Character not found.", 3)
        return
    end
    local cubes = workspace:FindFirstChild("Cubes")
    if not cubes then return end
    local anySelected = false
    for _, name in ipairs(selected) do
        if name == "Any" then anySelected = true break end
    end
    local toolsToMove = {}
    if anySelected then
        for _, t in ipairs(cubes:GetChildren()) do
            if t:IsA("Tool") then
                local m = GetCubeModel(t)
                local r = m and m:FindFirstChild("Root")
                if r then
                    table.insert(toolsToMove, {tool = t, name = GetCName(t), dist = (hrp.Position - r.Position).Magnitude})
                end
            end
        end
        table.sort(toolsToMove, function(a, b) return a.dist > b.dist end)
    else
        for _, name in ipairs(selected) do
            local bestTool = nil
            local bestDist = -math.huge
            for _, t in ipairs(cubes:GetChildren()) do
                if t:IsA("Tool") and GetCName(t) == name then
                    local m = GetCubeModel(t)
                    local r = m and m:FindFirstChild("Root")
                    if r then
                        local dist = (hrp.Position - r.Position).Magnitude
                        if dist > bestDist then bestDist = dist; bestTool = t end
                    end
                end
            end
            if bestTool then
                table.insert(toolsToMove, {tool = bestTool, name = name, dist = bestDist})
            else
                notyuri("[MoveCubeToMe] cube not found in world:", name)
            end
        end
    end
    for _, entry in ipairs(toolsToMove) do
        local name = entry.name
        local tool = entry.tool
        if tool then
            local model = GetCubeModel(tool)
            local root = model and model:FindFirstChild("Root")
            local originCF = hrp.CFrame
            if root then
                hrp.CFrame = CFrame.new(root.Position) * CFrame.new(0, 3, 0)
            end
            task.wait(.175)
            pcall(function() Remotes.PickUpPacket:Fire(tool) end)
            hrp.CFrame = originCF
            local pickedUp = Plr.Backpack:FindFirstChild(tool.Name)
            if pickedUp then
                pickedUp.Parent = char
                task.wait(1)
                local dropCF = originCF
                DropC(dropCF)
                notyuri("[MoveCubeToMe] moved", name, "to player position")
            else
                notyuri("[MoveCubeToMe] pickup failed (server rejected?):", name)
            end
        end
    end
end
local function GetResearchedCubes()
    local researched = {}
    local serverSettings = RS:FindFirstChild("ServerSettings")
    if not serverSettings then return researched end
    local attr = serverSettings:GetAttribute("Researched")
    if not attr or attr == "" then return researched end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(attr) end)
    if ok and type(decoded) == "table" then
        for _, name in ipairs(decoded) do
            researched[name] = true
        end
    end
    return researched
end
local function Func_AutoResearch()
    while Toggles.AutoResearch.Value do
        if not Remotes.CubeFusionPacket then
            task.wait(2)
            continue
        end
        local researcherModel = workspace:FindFirstChild("HardStructures") and workspace.HardStructures:FindFirstChild("Researcher")
        if not researcherModel then
            notyuri("[AutoResearch] workspace.HardStructures.Researcher not found")
            task.wait(3)
            continue
        end
        local researcherRoot = researcherModel:FindFirstChild("ActivatorPart")
        if not researcherRoot then
            notyuri("[AutoResearch] Researcher ActivatorPart not found")
            task.wait(3)
            continue
        end
        local researched = GetResearchedCubes()
        local cubes = workspace:FindFirstChild("Cubes")
        if not cubes then
            task.wait(1)
            continue
        end
        local candidates = {}
        for _, tool in ipairs(cubes:GetChildren()) do
            if not Toggles.AutoResearch.Value then break end
            if tool:IsA("Tool") then
                local cubeName = GetCName(tool)
                if not researched[cubeName] then
                    local model = GetCubeModel(tool)
                    local root = model and model:FindFirstChild("Root")
                    if model and root then
                        table.insert(candidates, {model = model, root = root, name = cubeName})
                    end
                end
            end
        end
        if #candidates == 0 then
            notyuri("[AutoResearch] no unresearched cubes in world")
            task.wait(5)
            continue
        end
        for _, entry in ipairs(candidates) do
            if not Toggles.AutoResearch.Value then break end
            pcall(function()
                Remotes.CubeFusionPacket:Fire(entry.model, researcherModel, researcherRoot.Position)
            end)
            notyuri("[AutoResearch] researched", entry.name)
            task.wait(0.175)
            researched = GetResearchedCubes()
        end
        task.wait(1)
    end
end
local function Func_AutoAbility()
    while Toggles.AutoAbility.Value do
        local char = GetCharacter()
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hitCFrame = hrp and hrp.CFrame or CFrame.new()
            local sources = {char, Plr.Backpack}
            local offhand = char:FindFirstChild("Offhand")
            if offhand then
                for _, tool in ipairs(offhand:GetChildren()) do
                    table.insert(sources, tool)
                end
            end
            for _, source in ipairs(sources) do
                for _, tool in ipairs(source:GetChildren()) do
                    if not tool:IsA("Tool") then continue end
                    local functionality = tool:FindFirstChild("Functionality")
                    if not functionality then continue end
                    local remote = functionality:FindFirstChild("RemoteEvent")
                    if not remote then continue end
                    pcall(function() remote:FireServer(hitCFrame) end)
                    notyuri("[AutoAbility] fired", tool.Name)
                end
            end
        end
        task.wait(0.1)
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
TB_Tabs.Autofarm2.T1:AddDropdown("CombinationList", {
    Text = "Combination List",
    Values = {},
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("PickupList", {
    Text = "Pickup List",
    Values = {},
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("SmeltList", {
    Text = "Smelt List",
    Values = {},
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("ExpandList", {
    Text = "Expand List",
    Values = {},
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("MoveList", {
    Text = "Move List",
    Values = {},
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm2.T1:AddDropdown("UpgradeList", {
    Text = "Upgrade List",
    Values = {},
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCombine", { Text = "Auto Combine", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", { Text = "Auto Pickup Cubes", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSmelt", { Text = "Auto Smelt", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoExpand", { Text = "Auto Expand", Default = false })
TB_Tabs.Autofarm2.T1:AddSlider("ReachRange", {
    Text = "Reach Range",
    Default = 30,
    Min = 5,
    Max = 200,
    Rounding = 0,
    Compact = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrades", { Text = "Auto Upgrades", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAbility", { Text = "Auto Abilities", Default = false })
TB_Tabs.Autofarm.T1:AddButton({ Text = "Move Selected Cubes to Me", Func = function()
    Func_MoveCubeToMe()
end })
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
Toggles.AutoCombine:OnChanged(function(v)
    Thread("AutoCombine", SafeLoop("AutoCombine", Func_AutoCombine), v)
end)
Toggles.AutoPickup:OnChanged(function(v)
    Thread("AutoPickup", SafeLoop("AutoPickup", Func_AutoPickup), v)
end)
Toggles.AutoSmelt:OnChanged(function(v)
    Thread("AutoSmelt", SafeLoop("AutoSmelt", Func_AutoSmelt), v)
end)
Toggles.AutoExpand:OnChanged(function(v)
    Thread("AutoExpand", SafeLoop("AutoExpand", Func_AutoExpand), v)
end)
Toggles.AutoUpgrades:OnChanged(function(v)
    Thread("AutoUpgrades", SafeLoop("AutoUpgrades", Func_AutoUpgrades), v)
end)
Toggles.AutoAbility:OnChanged(function(v)
    Thread("AutoAbility", SafeLoop("AutoAbility", Func_AutoAbility), v)
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
SaveManager:SetFolder("Yuri/Cubination")
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
RefreshRCPDD()
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
    notyuri("ERROR: " .. tostring(err))
end
