if getgenv().ayasemiyatongekissazumirisa then
    warn("yuri")
    return
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
cloneref   = missing("function", cloneref, function(...) return ... end)
getgc      = missing("function", getgc or get_gc_objects)
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
local Players        = Services.Players
local Plr            = Players.LocalPlayer
local CoreGui        = Services.CoreGui
local RS             = Services.ReplicatedStorage
local RunService     = Services.RunService
local HttpService    = Services.HttpService
local UIS            = Services.UserInputService
local CollectionService = Services.CollectionService
local Marketplace    = Services.MarketplaceService
local Lighting       = Services.Lighting
local TeleportService = Services.TeleportService
local VirtualUser    = Services.VirtualUser
local v, Asset = pcall(function() return Marketplace:GetProductInfo(game.PlaceId) end)
local assetName = (v and Asset) and Asset.Name or "Creatures of Sonaria"
local Support = {
    Webhook     = (typeof(request) == "function" or typeof(http_request) == "function"),
    Clipboard   = (typeof(setclipboard) == "function"),
    FileIO      = (typeof(writefile) == "function" and typeof(isfile) == "function"),
    FPS         = (typeof(setfpscap) == "function"),
    Connections = (typeof(getconnections) == "function"),
}
local executorDisplayName = (identifyexecutor and identifyexecutor() or "Unknown")
local isLimitedExecutor   = executorDisplayName:lower():find("xeno") ~= nil
local repo        = "https://raw.githubusercontent.com/iLove-yuri/Linoria/main/"
local Library     = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
getgenv().ayasemiyatongekissazumirisa = true
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor          = true
Library.NotifySide                = "Left"
local function AddInfo(Window)
    local InfoTab   = Window:AddTab("Info")
    local InfoLeft  = InfoTab:AddLeftGroupbox("Information")
    local statusText = isLimitedExecutor
        and "<font color='#FFA500'>Semi-Working</font>"
        or  "<font color='#00FF00'>Working</font>"
    local extraNote = isLimitedExecutor
        and "<b>NOTE:</b> Some features may experience bugs!"
        or  "All features should work properly!"
    InfoLeft:AddLabel(
        "<b>Executor:</b> " .. executorDisplayName ..
        "\n<b>Status:</b> "  .. statusText ..
        "\n"                .. extraNote, true)
    local InfoRight = InfoTab:AddRightGroupbox("Links")
    InfoRight:AddButton({
        Text = "Join Discord Server",
        Func = function()
            local inviteCode = "b6kxdDtqd"
            local inviteLink = "https://discord.gg/" .. inviteCode
            local ok = false
            if request then
                ok = pcall(function()
                    request({
                        Url    = "http://127.0.0.1:6463/rpc?v=1",
                        Method = "POST",
                        Headers = {
                            ["Content-Type"] = "application/json",
                            ["Origin"]       = "https://discord.com",
                        },
                        Body = HttpService:JSONEncode({
                            cmd   = "INVITE_BROWSER",
                            args  = { code = inviteCode },
                            nonce = HttpService:GenerateGUID(false),
                        }),
                    })
                end)
            end
            if not ok and setclipboard then
                setclipboard(inviteLink)
                Library:Notify("Invite link copied to clipboard!", 4)
            end
        end,
    })
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
                Services.VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.2)
                Services.VirtualInputManager:SendKeyEvent(false, key, false, game); task.wait(0.1)
            end
            Services.GuiService.SelectedObject = nil
            success = true
        end
    end)
    return success
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
        if Config.Callback then Config.Callback(Toggle.Value) end
    end)
    return Toggle, Slider
end
local function GenUUID()
    return HttpService:GenerateGUID(false):lower()
end
local eh_success, err = pcall(function()
local Script_Start_Time = os.time()
local function GetSessionTime()
    local s = os.time() - Script_Start_Time
    return string.format("%dh %02dm", math.floor(s/3600), math.floor((s%3600)/60))
end
local Connections = {}
local Shared = {
    Farm       = false,
    LastSwitch = {},
    LastConsumeArg = nil,
    PlrSpecies = nil,
    CurHun     = nil,
    CurThirst  = nil,
    CurSta     = nil,
    CurDP      = nil,
    CurTar     = nil,
    IsFly      = false,
    IsLay      = false,
    TemBL      = {},
    TempRegionBL = {},  
    LastTP     = 0,
    TPCD       = 10,
    OgS        = nil,
    OgFS       = nil,
    Clip       = true,
    Noclipping = nil,
    ArriveDist = 60,
    NoclipOrigins = {},
    ConTask       = 2,
    IsConsuming = false,
    NavLock    = false,
    PathLine = {},
    CurrentTaskIsland = nil,
    PauseMission = false,
    FoodRange  = 90,
    WaterRange = 250,
    CollectRange = 100,
}
local Flags = {}
local function GetSafeModule(parent, name)
    local obj = parent:FindFirstChild(name)
    if obj and obj:IsA("ModuleScript") then
        local success, result = pcall(require, obj)
        if success then return result end
    end
    return nil
end
local Sonar               = GetSafeModule(RS, "Sonar")
local PlayerWrapper       = Sonar("PlayerWrapper")
local RemoteUtils         = Sonar("RemoteUtils")
local ShoomPilesService   = Sonar("ShoomPilesService")
local CreatureInfoService = Sonar("CreatureInfoService")
local Constants = Sonar("Constants")
local SaveSelectionClient = Sonar("SaveSelectionClient")
local DeathClient = Sonar("DeathClient")
local Remotes = {
    Food       = RemoteUtils.GetRemoteEvent("Food"),
    Drink         = RemoteUtils.GetRemoteEvent("DrinkRemote"),
    DrinkBuildable = RemoteUtils.GetRemoteEvent("DrinkBuildableWater"),
    GetToken   = RemoteUtils.GetRemoteFunction("GetSpawnedTokenRemote"),
    GetShoom   = RemoteUtils.GetRemoteFunction("ShoomPileCollected"),
    SetMission = RemoteUtils.GetRemoteEvent("SetMissionRemote"),
    Mud        = RemoteUtils.GetRemoteEvent("Mud"),
    ToggleFly  = RemoteUtils.GetRemoteEvent("ToggleFlyRemote"),
    DeathEvent = RemoteUtils.GetRemoteEvent("Death"),
    BreathToggle   = RemoteUtils.GetRemoteEvent("BreathToggle"),
    MobDmgBreath   = RemoteUtils.GetRemoteEvent("MobDamageRemoteBreath"),
    NPCDmgBreath   = RemoteUtils.GetRemoteEvent("NPCDamageRemoteBreath"),
    CharDmgBreath  = RemoteUtils.GetRemoteEvent("CharactersDamageRemoteBreath"),
    RestartSlot    = RemoteUtils.GetRemoteFunction("RestartSlotRemote"),
    Spawn          = RemoteUtils.GetRemoteFunction("SpawnRemote"),
}
local AllRegionNames = {
    "Algae Sandbar", "Basalt Cave", "Central Rockfaces", "Coral Reef",
    "Desert", "Flower Cove", "Forgotten Shores", "Grassy Shoal",
    "Jungle", "Mesa", "Mountains", "Pride Rocks", "Redwoods",
    "Rocky Drop", "Seaweed Depths", "Shadow Isle", "Swamp Hill",
    "Tundra", "Volcano Island",
}
local AllQuestTypes = {
    "AttackOrHealCreatureOrNPC", "ConcealScent", "DistanceTravelled",
    "EatFoodDrinkWater", "ShoomPilesCollected", "Sniff", "TimePlayed",
}
local TargetConfig = {
    { Id = "ESPTokens",  Group = "left",  Text = "Token ESP",   Tag = nil,
      Target  = function() return workspace:FindFirstChild("Interactions") and workspace.Interactions:FindFirstChild("SpawnedTokens") end,
      Color   = Color3.fromRGB(255, 215, 0),  Display = "Token"   },
    { Id = "ESPShooms",  Group = "right", Text = "Shoom ESP",   Tag = "ShoomPile",
      Color   = Color3.fromRGB(180, 80, 255), Display = "Shroom",
      filter  = function(pile)
          local region = pile:GetAttribute("Region")
          local id     = pile:GetAttribute("Id")
          if not (region and id) then return false end
          local check = ShoomPilesService.CanCollect(Plr, region, id)
          return not (type(check) == "table" and check[1] == "ShoomCollected")
      end },
    { Id = "ESPEggs",    Group = "left",  Text = "Egg ESP",     Tag = nil,
      Target  = function() return workspace:FindFirstChild("Interactions") and workspace.Interactions:FindFirstChild("AbandonedEggs") end,
      Color   = Color3.fromRGB(255, 120, 40),  Display = "Egg"    },
    { Id = "ESPShrines", Group = "right", Text = "Shrine ESP",
      GetItems = function()
          local root = workspace:FindFirstChild("Interactions") and workspace.Interactions:FindFirstChild("Warden Shrines")
          if not root then return {} end
          local meshParts = {}
          for _, shrineFolder in ipairs(root:GetChildren()) do
              local mesh = shrineFolder:FindFirstChildWhichIsA("MeshPart")
              if mesh then table.insert(meshParts, mesh) end
          end
          return meshParts
      end,
      GetRoot = function()
          return workspace:FindFirstChild("Interactions") and workspace.Interactions:FindFirstChild("Warden Shrines")
      end,
      Color   = Color3.fromRGB(0, 200, 255),  Display = "Shrine" },
    { Id = "ESPNPCs",    Group = "right", Text = "NPC ESP",     Tag = nil,
      Target  = function() return workspace:FindFirstChild("Interactions") and workspace.Interactions:FindFirstChild("NPCs") and workspace.Interactions.NPCs:FindFirstChild("Models") end,
      Color   = Color3.fromRGB(255, 100, 100),  Display = "NPC"    },
    { Id = "ESPCharacters", Group = "right", Text = "Player Esp", Tag = nil,
      Target  = function() return workspace:FindFirstChild("Characters") end,
      Color   = Color3.fromRGB(100, 255, 100),  Display = "Player"   },
}
local function Cleanup(tbl)
    for key, value in pairs(tbl) do
        if typeof(value) == "RBXScriptConnection" then
            value:Disconnect(); tbl[key] = nil
        elseif typeof(value) == "thread" then
            task.cancel(value); tbl[key] = nil
        elseif type(value) == "table" then
            Cleanup(value)
        end
    end
end
function Thread(featurePath, featureFunc, isEnabled, ...)
    local parts = featurePath:split(".")
    local tbl   = Flags
    for i = 1, #parts - 1 do
        local p = parts[i]
        if not tbl[p] then tbl[p] = {} end
        tbl = tbl[p]
    end
    local key    = parts[#parts]
    local active = tbl[key]
    if isEnabled then
        if not active or coroutine.status(active) == "dead" then
            tbl[key] = task.spawn(featureFunc, ...)
        end
    else
        if active and typeof(active) == "thread" then
            task.cancel(active); tbl[key] = nil
        end
    end
end
local function GetHRP()
    local c = Plr.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function GetCharClass()
    local ok, wrapper = pcall(function()
        return PlayerWrapper.getWrapperFromPlayer(Plr)
    end)
    if not ok or not wrapper then return nil end
    local ok2, cc = pcall(function()
        return wrapper:GetCurrentCharacter()
    end)
    return (ok2 and cc) or nil
end
local ExclusiveStates = {
    { method = "Fly",          key = "Flying",    disableArg = false },
    { method = "Lay",          key = "Laying",    disableArg = false },
    { method = "Sit",          key = "Sitting",   disableArg = false },
    { method = "Glide",        key = "Gliding",   disableArg = false },
    { method = "Ambush",       key = "Ambushing", disableArg = false },
    { method = "Sprint",       key = "Sprinting", disableArg = false },
}
local function Set(cc, method, stateKey, arg)
    local disable = stateKey:sub(1,1) == "!"
    local key     = disable and stateKey:sub(2) or stateKey
    local param   = not disable
    yuri("Set: method=", method, " stateKey=", stateKey, " arg=", tostring(arg), " cc=", tostring(cc))
    if param then
        for _, entry in ipairs(ExclusiveStates) do
            if entry.key ~= key then
                while cc[entry.key] do
                    yuri("Set: disabling exclusive state", entry.key, "for key", key)
                    if entry.disableArg ~= nil then
                        pcall(function() cc[entry.method](cc, entry.disableArg) end)
                    else
                        pcall(function() cc[entry.method](cc) end)
                    end
                    task.wait()
                    cc = GetCharClass()
                    if not cc then
                        yuri("Set: cc became nil while disabling exclusive state", entry.key)
                        return cc
                    end
                end
            end
        end
    end
    yuri("Set: entering wait loop for key=", key, " param=", tostring(param))
    local setIter = 0
    local SET_MAX_ITER = 120
    while cc[key] ~= param do
        setIter = setIter + 1
        if setIter > SET_MAX_ITER then
            yuri("Set: TIMEOUT after", setIter, "iters — key=", key, "stuck at", tostring(cc[key]), "expected", tostring(param), "— aborting")
            return nil
        end
        yuri("Set: state not yet", key, "=", tostring(cc[key]), "expected", tostring(param))
        if arg ~= nil then
            pcall(function() cc[method](cc, arg) end)
        else
            pcall(function() cc[method](cc, param) end)
        end
        task.wait()
        cc = GetCharClass()
        if not cc then
            yuri("Set: cc became nil during wait loop")
            break
        end
    end
    yuri("Set: finished, key=", key, "iters=", setIter, "cc[key]=", cc and tostring(cc[key]) or "nil")
    return cc
end
local function DisableAllStates(cc)
    yuri("DisableAllStates: called")
    for _, entry in ipairs(ExclusiveStates) do
        while cc[entry.key] do
            yuri("DisableAllStates: disabling", entry.key)
            if entry.disableArg ~= nil then
                pcall(function() cc[entry.method](cc, entry.disableArg) end)
            else
                pcall(function() cc[entry.method](cc) end)
            end
            task.wait()
            cc = GetCharClass()
            if not cc then
                yuri("DisableAllStates: cc became nil while disabling", entry.key)
                return nil
            end
        end
    end
    yuri("DisableAllStates: done")
    return cc
end
local function DoConsume(cc, method, arg)
    yuri("DoConsume: method=", method, "arg=", tostring(arg))
    do
        local activeList = {}
        for _, entry in ipairs(ExclusiveStates) do
            if cc[entry.key] then
                activeList[#activeList + 1] = entry.key
            end
        end
        if cc.Swimming then activeList[#activeList + 1] = "Swimming" end
        if cc.Eating   then activeList[#activeList + 1] = "Eating"   end
        if #activeList > 0 then
            yuri("DoConsume: active states = [", table.concat(activeList, ", "), "]")
        else
            yuri("DoConsume: active states = (none)")
        end
    end
    local started = false
    while not started do
        if typeof(arg) == "Instance" then
            local val = method == "StartEat" and arg:GetAttribute("Value") or nil
            if not arg.Parent or (val ~= nil and val <= 0) then
                yuri("DoConsume:", method, "arg unusable (no parent or Value=", tostring(val), ") — bailing out for rescan")
                return nil
            end
        end
        cc = DisableAllStates(cc)
        if not cc then
            yuri("DoConsume: cc lost in DisableAllStates")
            return nil
        end
        if (cc.Eating or cc.Drinking) and Shared.LastConsumeArg ~= arg then
            yuri("DoConsume: cancelling active", cc.Eating and "Eating" or "Drinking", "— target switched from", tostring(Shared.LastConsumeArg), "->", tostring(arg))
            pcall(function() cc:StopEatDrink() end)
            task.wait()
            cc = GetCharClass()
            if not cc then
                yuri("DoConsume: cc lost after StopEatDrink")
                return nil
            end
        end
        Shared.LastConsumeArg = arg
        pcall(function()
            local r = cc[method](cc, arg)
            if r == true then started = true end
        end)
        if not started then
            local hrp = GetHRP()
            local argPos = typeof(arg) == "Instance" and (
                (arg:IsA("BasePart") and arg.Position) or
                (arg.PrimaryPart and arg.PrimaryPart.Position) or
                (arg.Parent and arg.Parent:IsA("BasePart") and arg.Parent.Position)
            ) or nil
            local dist = hrp and argPos and (hrp.Position - argPos).Magnitude
            yuri("DoConsume:", method, "blocked (returned nil) — dist=", dist and math.floor(dist) or "?", "— retrying")
            if method == "StartEat" and typeof(arg) == "Instance" then
                local foodObj = Sonar("Food").GetFoodFromModel(arg)
                if foodObj and not foodObj:HasFood() then
                    yuri("DoConsume: food HasFood() false — bailing out for rescan")
                    return nil
                end
            end
            task.wait()
        end
    end
    cc = GetCharClass()
    if cc then
        pcall(function()
            local s0 = GetCharStats()
            local prevHun    = s0 and s0.hun
            local prevThirst = s0 and s0.thirst
            while cc.Eating do
                task.wait()
                local s = GetCharStats()
                local curHun    = s and s.hun
                local curThirst = s and s.thirst
                yuri("DoConsume: hun=", curHun and math.floor(curHun*100) or "?", "% thirst=", curThirst and math.floor(curThirst*100) or "?", "%")
                if curHun ~= prevHun or curThirst ~= prevThirst then
                    cc:StopEatDrink()
                    break
                end
            end
        end)
    end
    cc = GetCharClass()
    yuri("DoConsume: done, method=", method, "started=", tostring(started))
    return cc
end
local function GetCharStats()
    local cc = GetCharClass()
    if not cc then return nil end
    local slot = cc.Slot
    if not slot then return nil end
    local cd = cc.CharacterData
    if not cd then return nil end
    local species = cd.Species ~= "" and cd.Species or nil
    Shared.PlrSpecies = species
    local maxFood  = cd:GetWithModifiers("Appetite")
    local maxWater = cd:GetWithModifiers("ThirstAppetite")
    local foodSlot  = slot:FindFirstChild("Food")
    local waterSlot = slot:FindFirstChild("Water")
    local hun      = (maxFood  and maxFood  > 0 and foodSlot)  and foodSlot.Value  / maxFood  or nil
    local thirst   = (maxWater and maxWater > 0 and waterSlot) and waterSlot.Value / maxWater or nil
    local ok, dp = pcall(function() return CreatureInfoService.GetTotalDeathPoints(slot) end)
    if not ok then dp = nil end
    local diet = cd:GetCached("FoodType")
    return { hun = hun, thirst = thirst, dp = dp, diet = diet, species = species }
end
local cosPathFolder do
    local f = Instance.new("Folder", workspace)
    f.Name = GenUUID()
    cosPathFolder = f
end
local function DrawPath(waypoints, isDanger)
    if not cosPathFolder then return end
    cosPathFolder:ClearAllChildren()
    Shared.PathLine = {}
    if #waypoints < 2 then return end
    local prev = nil
    for i, wp in ipairs(waypoints) do
        local cur = wp.Position + Vector3.new(0, 0.4, 0)
        if prev then
            local dist = (prev - cur).Magnitude
            local line = Instance.new("Part")
            line.Name        = GenUUID()
            line.Size        = Vector3.new(0.22, 0.22, dist)
            line.CFrame      = CFrame.lookAt(prev, cur) * CFrame.new(0, 0, -dist / 2)
            line.Anchored    = true
            line.CanCollide  = false
            line.Material    = Enum.Material.Neon
            line.Color       = isDanger and Color3.fromRGB(255, 82, 82) or Color3.fromRGB(255, 208, 0)
            line.Transparency = isDanger and 0.2 or 0.1
            line.Parent      = cosPathFolder
            Shared.PathLine[i]  = line
        end
        prev = cur
    end
end
local function SurfacePierceTP(dest)
    local hrp = GetHRP()
    if not hrp then yuri("SurfacePierceTP: no hrp") return false end
    local rcParams = RaycastParams.new()
    rcParams.FilterType = Enum.RaycastFilterType.Exclude
    rcParams.FilterDescendantsInstances = { workspace.CurrentCamera, hrp.Parent }
    local pos = hrp.Position
    local safeDestY = dest.Y
    local belowAtDest = workspace:Raycast(
        Vector3.new(dest.X, dest.Y + 2, dest.Z),
        Vector3.new(0, -10, 0),
        rcParams
    )
    local aboveAtDest = workspace:Raycast(
        Vector3.new(dest.X, dest.Y - 2, dest.Z),
        Vector3.new(0, 10, 0),
        rcParams
    )
    if belowAtDest and aboveAtDest then
        safeDestY = dest.Y + 10
        yuri("SurfacePierceTP: dest underground — lifting to Y=", math.floor(safeDestY))
    end
    local safeDest = Vector3.new(dest.X, safeDestY, dest.Z)
    local upHit = workspace:Raycast(pos, Vector3.new(0, 300, 0), rcParams)
    local downHit = workspace:Raycast(
        Vector3.new(pos.X, pos.Y + 300, pos.Z),
        Vector3.new(0, -300, 0),
        rcParams
    )
    local pierceY
    if upHit then
        pierceY = upHit.Position.Y + 5
        yuri("SurfacePierceTP: surface above at Y=", math.floor(upHit.Position.Y), "— piercing to Y=", math.floor(pierceY))
    elseif downHit and math.abs(downHit.Position.Y - pos.Y) < 50 then
        pierceY = downHit.Position.Y - 5
        yuri("SurfacePierceTP: surface below at Y=", math.floor(downHit.Position.Y), "— piercing to Y=", math.floor(pierceY))
    else
        local nudge = (safeDest.Y > pos.Y) and 10 or -10
        pierceY = pos.Y + nudge
        yuri("SurfacePierceTP: no clear surface hit — nudging Y by", nudge)
    end
    local piercePos = Vector3.new(pos.X, pierceY, pos.Z)
    yuri("SurfacePierceTP: teleporting from", tostring(pos), "to", tostring(piercePos))
    hrp.CFrame = CFrame.new(piercePos)
    task.wait(0.1)
    return true
end
local function IsOutdoor(pos)
    local rcParams = RaycastParams.new()
    rcParams.FilterType = Enum.RaycastFilterType.Exclude
    rcParams.FilterDescendantsInstances = { workspace.CurrentCamera }
    local result = workspace:Raycast(pos, Vector3.new(0, 1000, 0), rcParams)
    return result == nil
end
local function GetRoofY(pos)
    local rcParams = RaycastParams.new()
    rcParams.FilterType = Enum.RaycastFilterType.Exclude
    rcParams.FilterDescendantsInstances = { workspace.CurrentCamera }
    local skyStart = Vector3.new(pos.X, pos.Y + 5000, pos.Z)
    local result = workspace:Raycast(skyStart, Vector3.new(0, -5000, 0), rcParams)
    if result then
        return result.Position.Y
    end
    return nil
end
local function IsUnderwater(pos)
    for _, obj in ipairs(CollectionService:GetTagged("DrinkableWater")) do
        local model = obj:IsA("Model") and obj or (obj.Parent and obj.Parent:IsA("Model") and obj.Parent)
        if not model then continue end
        local zone = model:GetAttribute("FakeWater") and model or model:FindFirstChild("WaterZone")
        if not zone or not zone:IsA("BasePart") then continue end
        local half = zone.Size / 2
        local rel  = zone.CFrame:PointToObjectSpace(pos)
        if math.abs(rel.X) <= half.X and math.abs(rel.Y) <= half.Y and math.abs(rel.Z) <= half.Z then
            return true
        end
    end
    return false
end
local function IsTagged(tag, filterFunc, origin, outdoorPrefer)
    if not origin then
        local hrp = GetHRP()
        if not hrp then return nil end
        origin = hrp.Position
    end
    if outdoorPrefer then
        local bestOut, bestOutD = nil, math.huge
        local bestIn,  bestInD  = nil, math.huge
        for _, obj in ipairs(CollectionService:GetTagged(tag)) do
            if (not filterFunc) or filterFunc(obj) then
                local pos = obj:IsA("BasePart") and obj.Position
                         or (obj.PrimaryPart and obj.PrimaryPart.Position)
                if pos then
                    local d = (pos - origin).Magnitude
                    if IsOutdoor(pos) then
                        if d < bestOutD then bestOutD = d; bestOut = obj end
                    else
                        if d < bestInD  then bestInD  = d; bestIn  = obj end
                    end
                end
            end
        end
        return bestOut or bestIn
    end
    local closest, best = nil, math.huge
    for _, obj in ipairs(CollectionService:GetTagged(tag)) do
        if (not filterFunc) or filterFunc(obj) then
            local pos = obj:IsA("BasePart") and obj.Position
                     or (obj.PrimaryPart and obj.PrimaryPart.Position)
            if pos then
                local d = (pos - origin).Magnitude
                if d < best then best = d; closest = obj end
            end
        end
    end
    return closest
end
local function PreferOutdoor(list, getPos)
    local hrp = GetHRP()
    if not hrp or #list == 0 then return nil end
    local origin = hrp.Position
    local bestOut, bestOutD = nil, math.huge
    local bestIn,  bestInD  = nil, math.huge
    for _, item in ipairs(list) do
        local pos = getPos(item)
        if pos then
            local d = (pos - origin).Magnitude
            if IsOutdoor(pos) then
                if d < bestOutD then bestOut, bestOutD = item, d end
            else
                if d < bestInD  then bestIn,  bestInD  = item, d end
            end
        end
    end
    return bestOut or bestIn
end
local function GetSick(preferSickly, fallback)
    local hrp = GetHRP()
    if not hrp then return nil end
    local sickly, anyCl = nil, nil
    local bestS, bestA = math.huge, math.huge
    for _, obj in ipairs(CollectionService:GetTagged("DrinkableWater")) do
        if obj:GetAttribute("FakeWater") or obj.Parent:GetAttribute("FakeWater") then continue end
        local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
        if p then
            local roofY = GetRoofY(p)
            if roofY and (roofY - p.Y) < Shared.WaterRange then continue end
            local d = (p - hrp.Position).Magnitude
            if obj.Parent:GetAttribute("Sickly") == true then
                if d < bestS then bestS = d; sickly = obj end
            else
                if d < bestA then bestA = d; anyCl = obj end
            end
        end
    end
    if preferSickly then
        if sickly then return sickly end
        if fallback then return anyCl end
        return nil
    end
    if bestS < bestA then return sickly else return anyCl end
end
local function GetLPData(attr, value)
    local char = workspace.Characters:FindFirstChild(Plr.Name)
    local data = char and char:FindFirstChild("Data")
    if not data then return nil end
    if attr ~= nil then
        if value ~= nil then data:SetAttribute(attr, value); return end
        return data:GetAttribute(attr)
    end
    return data
end
local function IsFlier()
    return GetLPData("ct") == "Flier"
end
local function GetNearest(list, getPosFn)
    local hrp = GetHRP()
    if not hrp or #list == 0 then return nil end
    local best, bestDist = nil, math.huge
    for _, item in ipairs(list) do
        local pos = getPosFn(item)
        if pos then
            local d = (pos - hrp.Position).Magnitude
            if d < bestDist then best, bestDist = item, d end
        end
    end
    return best
end
local function GetMobRoots()
    local roots = {}
    for _, tag in ipairs({ "MobSpawner", "BossSpawner" }) do
        for _, spawner in ipairs(CollectionService:GetTagged(tag)) do
            local folder = spawner:FindFirstChild("MobRoots")
            if folder then
                for _, root in ipairs(folder:GetChildren()) do
                    table.insert(roots, root)
                end
            end
        end
    end
    return roots
end
local function GetNPCRoots()
    local i = workspace:FindFirstChild("Interactions")
    local n = i and i:FindFirstChild("NPCs")
    local r = n and n:FindFirstChild("Roots")
    return r and r:GetChildren() or {}
end
local function GetPlayerRoots()
    local out = {}
    for _, model in ipairs(workspace.Characters:GetChildren()) do
        if model ~= Plr.Character then
            table.insert(out, model)
        end
    end
    return out
end
local function GetPlayerBreathPart()
    local hrp = GetHRP()
    if not hrp then return nil end
    local bip = workspace:FindFirstChild("BreathImpactParts")
    if not bip then return nil end
    local best, bestDist = nil, math.huge
    for _, playerFolder in ipairs(bip:GetChildren()) do
        if playerFolder.Name ~= Plr.Name then
            local part = playerFolder:FindFirstChildWhichIsA("BasePart")
            if part then
                local d = (part.Position - hrp.Position).Magnitude
                if d < bestDist then bestDist = d; best = playerFolder end
            end
        end
    end
    return best
end
local function HasObs(targetPos)
    local hrp = GetHRP()
    if not hrp then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local c = Plr.Character
    if c then params.FilterDescendantsInstances = { c } end
    local dir = targetPos - hrp.Position
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 0.1 then return true end
    dir = dir.Unit
    for _, h in ipairs({ 0.5, 1.5, 2.5 }) do
        if workspace:Raycast(hrp.Position + Vector3.new(0, h, 0), dir * 4, params) then
            return true
        end
    end
    return false
end
local function restoreStamina()
    local cc = GetCharClass()
    if not cc or not cc.StaminaTracker then
        yuri("restoreStamina: no cc or StaminaTracker")
        return
    end
    local cur = cc.StaminaTracker:GetStamina()
    local max = cc.StaminaTracker:GetMaxStamina()
    Shared.CurSta = cur
    yuri("restoreStamina: stamina=", math.floor(cur), "/", math.floor(max), string.format("(%.0f%%)", cur / max * 100))
    if cur / max >= 0.8 then return end
    if not cc.IsGrounded then
        if cc.Sprinting then cc:Sprint(false) end
        cc = Set(cc, "Fly", "Flying")
        if not cc then return end
    end
    if cc.Sprinting then cc:Sprint(false) end
    cc = Set(cc, "Lay", "Laying")
    if not cc then return end
    local t0 = tick()
    while tick() - t0 < 30 do
        task.wait(1)
        cc = GetCharClass()
        if not cc or not cc.StaminaTracker then break end
        cur = cc.StaminaTracker:GetStamina()
        max = cc.StaminaTracker:GetMaxStamina()
        Shared.CurSta = cur
        yuri("restoreStamina: stamina=", math.floor(cur), "/", math.floor(max), string.format("(%.0f%%)", cur / max * 100))
        if cur / max >= 0.8 then break end
    end
    cc = Set(cc, "Lay", "!Laying")
    if not cc then return end
    yuri("restoreStamina: done, stamina=", math.floor(cur), "/", math.floor(max))
end
local function SwimTo(targetPos)
    local cc  = GetCharClass()
    local hrp = GetHRP()
    if not cc or not hrp then return false end
    if not cc.Swimming then
        yuri("SwimTo: not swimming, skipping")
        return false
    end
    local bv = cc.BodyVelocity
    local bg = cc.BodyGyro
    if not bv or not bg then return false end
    local speed = cc.FlySpeed or 40
    local mf    = cc.MinimumForce or (hrp.AssemblyMass * workspace.Gravity * 1.1)
    yuri("SwimTo: swimming toward", tostring(targetPos), "from Y=", math.floor(hrp.Position.Y))
    local t0 = tick()
    while tick() - t0 < 10 do
        hrp = GetHRP()
        cc  = GetCharClass()
        if not cc or not hrp then break end
        if not cc.Swimming then
            yuri("SwimTo: exited water at Y=", math.floor(hrp.Position.Y))
            bv.Velocity = Vector3.zero
            bv.MaxForce = Vector3.zero
            return true
        end
        bv = cc.BodyVelocity
        bg = cc.BodyGyro
        if not bv or not bg then break end
        local dir = (targetPos - hrp.Position)
        if dir.Magnitude < 3 then
            yuri("SwimTo: arrived at Y=", math.floor(hrp.Position.Y))
            bv.Velocity = Vector3.zero
            bv.MaxForce = Vector3.zero
            return true
        end
        dir = dir.Unit
        bg.CFrame  = CFrame.new(hrp.Position, hrp.Position + dir)
        bv.Velocity  = dir * speed
        bv.MaxForce  = Vector3.new(mf * 3, mf * 3, mf * 3)
        RunService.Heartbeat:Wait()
    end
    cc = GetCharClass()
    if cc and cc.BodyVelocity then
        cc.BodyVelocity.Velocity = Vector3.zero
        cc.BodyVelocity.MaxForce = Vector3.zero
    end
    yuri("SwimTo: gave up after 10s, Y=", hrp and math.floor(hrp.Position.Y) or "?")
    return false
end
local function FlyTo(Target)
    local cc  = GetCharClass()
    local hrp = GetHRP()
    if not cc or not hrp then yuri("FlyTo: no cc or hrp") return false end
    local targetPos = typeof(Target) == "Vector3" and Target or Target.Position
    do
        local rcSan = RaycastParams.new()
        rcSan.FilterType = Enum.RaycastFilterType.Exclude
        rcSan.FilterDescendantsInstances = { workspace.CurrentCamera }
        local belowDest = workspace:Raycast(Vector3.new(targetPos.X, targetPos.Y + 2, targetPos.Z), Vector3.new(0, -10, 0), rcSan)
        local aboveDest = workspace:Raycast(Vector3.new(targetPos.X, targetPos.Y - 2, targetPos.Z), Vector3.new(0,  10, 0), rcSan)
        if belowDest and aboveDest then
            local lifted = Vector3.new(targetPos.X, targetPos.Y + 10, targetPos.Z)
            yuri("FlyTo: destination underground — lifting from Y=", math.floor(targetPos.Y), "to Y=", math.floor(lifted.Y))
            targetPos = lifted
        end
    end
    local FlightAlpha = 0.15
    if (hrp.Position - targetPos).Magnitude < Shared.ArriveDist then return true end
    if Shared.NavLock then
        yuri("FlyTo: waiting for NavLock to release...")
        local lockWaitT = tick()
        local lockDeadline = tick() + 10
        while Shared.NavLock and tick() < lockDeadline do task.wait() end
        if Shared.NavLock then
            yuri("FlyTo: NavLock timeout — forcing release after", math.floor((tick() - lockWaitT) * 10) / 10, "s")
            Shared.NavLock = false
        else
            yuri("FlyTo: NavLock released after", math.floor((tick() - lockWaitT) * 10) / 10, "s")
        end
    end
    Shared.NavLock = true
    local function _flyBody()
    yuri("FlyTo: _flyBody entered — target=", tostring(targetPos), "dist=", math.floor((GetHRP() and (GetHRP().Position - targetPos).Magnitude) or -1))
    restoreStamina()
    DisableAllStates(cc)
    cc  = GetCharClass()
    hrp = GetHRP()
    if not cc or not hrp then yuri("FlyTo: lost cc/hrp after stamina restore") return false end
    if (hrp.Position - targetPos).Magnitude < Shared.ArriveDist then
        yuri("FlyTo: already at target after stamina restore, skipping flight")
        return true
    end
    if cc.StaminaTracker then
        local cur = cc.StaminaTracker:GetStamina()
        local max = cc.StaminaTracker:GetMaxStamina()
        if cur / max < 0.2 then
            yuri("FlyTo: stamina too low to fly (", math.floor(cur/max*100), "%) — aborting")
            return false
        end
    end
    if cc.Swimming and not IsUnderwater(targetPos) then
        local swimFails = 0
        while cc.Swimming do
            yuri("FlyTo: swimming detected — surfacing before flying (attempt", swimFails + 1, ")")
            SwimTo(Vector3.new(hrp.Position.X, hrp.Position.Y + 200, hrp.Position.Z))
            cc = GetCharClass()
            hrp = GetHRP()
            if not cc or not hrp then yuri("FlyTo: lost cc/hrp during swim escape") return false end
            if not cc.Swimming then break end
            swimFails = swimFails + 1
            if swimFails >= 3 then
                yuri("FlyTo: SwimTo failed", swimFails, "times — attempting TP escape")
                local now = os.clock()
                if now - Shared.LastTP >= Shared.TPCD then
                    local roofY = GetRoofY(hrp.Position)
                    local escapeY = roofY and (roofY + 20) or (hrp.Position.Y + 200)
                    yuri("FlyTo: swim TP escape to Y=", math.floor(escapeY), "(roofY=", roofY and math.floor(roofY) or "nil", ")")
                    hrp.CFrame = CFrame.new(Vector3.new(hrp.Position.X, escapeY, hrp.Position.Z))
                    Shared.LastTP = os.clock()
                    task.wait(0.1)
                    cc = GetCharClass()
                    hrp = GetHRP()
                    if not cc or not hrp then return false end
                else
                    local remaining = math.ceil(Shared.TPCD - (now - Shared.LastTP))
                    yuri("FlyTo: swim TP on cooldown (", remaining, "s) — aborting")
                    return false
                end
                swimFails = 0
            end
        end
    end
    yuri("FlyTo: cc.Flying before Fly(true)=", tostring(cc.Flying), "CanFly=", tostring(cc.CanFly))
    cc = Set(cc, "Fly", "Flying")
    if not cc then return false end
    Shared.IsFly = cc.Flying or false
    yuri("FlyTo: cc.Flying confirmed=", tostring(cc.Flying), "target=", tostring(targetPos))
    local function flyPhysicsTo(dest, timeout, breakOnStuck)
        local t0 = tick()
        local stuckPos = nil
        local stuckT   = tick()
        local smoothDir = nil
        local exitReason = "timeout"
        while tick() - t0 < (timeout or 20) do
            hrp = GetHRP()
            if not hrp then exitReason = "no_hrp" break end
            cc = GetCharClass()
            if not cc or not cc.BodyVelocity or not cc.BodyGyro then exitReason = "no_cc_or_bv" break end
            if not cc.Flying then
                Shared.IsFly = false
                if cc.StaminaTracker then
                    local sta = cc.StaminaTracker:GetStamina()
                    local mxs = cc.StaminaTracker:GetMaxStamina()
                    if sta / mxs < 0.15 then
                        yuri("flyPhysicsTo: stamina drained (", math.floor(sta/mxs*100), "%) — breaking to restore")
                        local bv0 = cc.BodyVelocity
                        if bv0 then bv0.Velocity = Vector3.zero end
                        exitReason = "stamina_drained"
                        break
                    end
                end
                yuri("flyPhysicsTo: cc.Flying dropped — Swimming=", tostring(cc.Swimming), "IsGrounded=", tostring(cc.IsGrounded))
                if cc.Swimming and not IsUnderwater(dest) then
                    SwimTo(Vector3.new(dest.X, dest.Y + 200, dest.Z))
                    cc = GetCharClass()
                    if not cc then exitReason = "no_cc_after_swim" break end
                end
                if cc.Swimming and not IsUnderwater(dest) then
                    yuri("flyPhysicsTo: still swimming after surface escape, breaking")
                    exitReason = "still_swimming"
                    break
                end
                if cc.Laying then cc = Set(cc, "Lay", "!Laying") if not cc then exitReason = "no_cc_refly" break end end
                if cc.Sprinting then cc:Sprint(false) end
                cc = Set(cc, "Fly", "Flying")
                if not cc then exitReason = "no_cc_refly" break end
                Shared.IsFly = true
                yuri("flyPhysicsTo: fly re-enabled")
            end
            local bv  = cc.BodyVelocity
            local bg  = cc.BodyGyro
            local pos = hrp.Position
            local toTarget = dest - pos
            if toTarget.Magnitude < Shared.ArriveDist then exitReason = "arrived" break end
            if not stuckPos then stuckPos = pos end
            if tick() - stuckT >= 2 then
                if (pos - stuckPos).Magnitude < 2 then
                    if breakOnStuck then
                        yuri("flyPhysicsTo: stuck on descent — attempting surface pierce")
                        bv.Velocity = Vector3.zero
                        SurfacePierceTP(dest)
                        hrp = GetHRP()
                        if not hrp then exitReason = "no_hrp_after_pierce" break end
                        cc = GetCharClass()
                        if not cc then exitReason = "no_cc_after_pierce" break end
                        if (hrp.Position - pos).Magnitude < 2 then
                            yuri("flyPhysicsTo: pierce did not move us — breaking")
                            exitReason = "stuck_descent"
                            break
                        end
                        stuckPos = hrp.Position
                        stuckT   = tick()
                    else
                    yuri("flyPhysicsTo: stuck detected at", tostring(pos), "— attempting surface pierce")
                    bv.Velocity = Vector3.zero
                    SurfacePierceTP(dest)
                    hrp = GetHRP()
                    if not hrp then exitReason = "no_hrp_after_pierce" break end
                    cc = GetCharClass()
                    if not cc then exitReason = "no_cc_after_stuck" break end
                    pcall(function() cc:Fly(false) end)
                    task.wait(0.15)
                    cc = GetCharClass()
                    if not cc then exitReason = "no_cc_after_stuck" break end
                    local tr2 = tick()
                    cc = Set(cc, "Fly", "Flying")
                    yuri("flyPhysicsTo: stuck re-fly wait took", math.floor((tick()-tr2)*1000), "ms | cc.Flying=", tostring(cc and cc.Flying))
                    if not cc or not cc.Flying then
                        yuri("flyPhysicsTo: could not re-fly after pierce, breaking")
                        exitReason = "refly_failed_after_stuck"
                        break
                    end
                    Shared.IsFly = true
                    stuckPos = nil
                    stuckT   = tick()
                    end
                end
                stuckPos = pos
                stuckT   = tick()
            end
            local speed = cc.FlySpeed or 40
            local mf    = cc.MinimumForce or (hrp.AssemblyMass * workspace.Gravity * 1.1)
            local dir   = toTarget.Unit
            local probeLen = math.min(speed * 0.5, 30)
            local rcParams = RaycastParams.new()
            rcParams.FilterType = Enum.RaycastFilterType.Exclude
            rcParams.FilterDescendantsInstances = { workspace.CurrentCamera, hrp.Parent }
            local worldUp  = Vector3.new(0, 1, 0)
            local rayRight = dir:Cross(worldUp)
            if rayRight.Magnitude < 0.01 then rayRight = Vector3.new(1, 0, 0) end
            rayRight = rayRight.Unit
            local rayUp = rayRight:Cross(dir).Unit
            local PROBE_OFFSET = 4  
            local probeOrigins = {
                pos,
                pos + rayUp    * PROBE_OFFSET,
                pos - rayUp    * PROBE_OFFSET,
                pos + rayRight * PROBE_OFFSET,
                pos - rayRight * PROBE_OFFSET,
            }
            local firstHit = nil
            for _, origin in ipairs(probeOrigins) do
                local h = workspace:Raycast(origin, dir * probeLen, rcParams)
                if h and (not firstHit or h.Distance < firstHit.Distance) then
                    firstHit = h
                end
            end
            if firstHit then
                local obstNorm = firstHit.Normal
                local side     = dir:Cross(worldUp)
                if side.Magnitude < 0.01 then side = Vector3.new(1, 0, 0) end
                side = side.Unit
                if side:Dot(obstNorm) < 0 then side = -side end
                local deflectWeight = 1 - (firstHit.Distance / probeLen)
                local rawDeflect = (dir + side * deflectWeight * 1.5 + obstNorm * deflectWeight).Unit
                if smoothDir then
                    smoothDir = (smoothDir * 0.6 + rawDeflect * 0.4).Unit
                else
                    smoothDir = rawDeflect
                end
                dir = smoothDir
            else
                if smoothDir then
                    smoothDir = (smoothDir * 0.3 + dir * 0.7).Unit
                    dir = smoothDir
                end
            end
            local GROUND_CLEARANCE = 9  
            if dir.Y > -0.5 then
                local groundHit = workspace:Raycast(pos, Vector3.new(0, -GROUND_CLEARANCE, 0), rcParams)
                if groundHit then
                    local gapRatio = 1 - (groundHit.Distance / GROUND_CLEARANCE)
                    dir = (dir + Vector3.new(0, gapRatio * 1.2, 0)).Unit
                end
            end
            bg.CFrame   = bg.CFrame:Lerp(CFrame.new(pos, pos + dir), FlightAlpha * 2)
            bv.Velocity = dir * speed
            bv.MaxForce = Vector3.new(mf * 3, mf * 3, mf * 3)
            RunService.Heartbeat:Wait()
        end
        cc = GetCharClass()
        if cc and cc.BodyVelocity then cc.BodyVelocity.Velocity = Vector3.zero end
        hrp = GetHRP()
        yuri("flyPhysicsTo: exit reason=", exitReason, "| elapsed=", math.floor((tick()-t0)*10)/10, "s | remainDist=", hrp and math.floor((dest - hrp.Position).Magnitude) or "?", "| cc.Flying=", tostring(cc and cc.Flying))
        return exitReason
    end
    local totalDist  = (hrp.Position - targetPos).Magnitude
    local yDelta     = math.abs(targetPos.Y - hrp.Position.Y)
    local skipAscent = yDelta <= -50 and totalDist < 500
    local cruiseY
    if totalDist >= 500 then
        cruiseY = 1200
    else
        cruiseY = targetPos.Y + 100
    end
    local function flySegment(dest, timeout, breakOnStuck)
        local reason = flyPhysicsTo(dest, timeout, breakOnStuck)
        if reason == "stamina_drained" then
            yuri("FlyTo: stamina drained mid-segment — restoring stamina")
            restoreStamina()
            cc  = GetCharClass()
            hrp = GetHRP()
            if not cc or not hrp then
                yuri("FlyTo: lost cc/hrp after mid-flight restore")
                return reason
            end
            if not cc.Flying then
                if cc.Laying then cc = Set(cc, "Lay", "!Laying") if not cc then return "refly_failed" end end
                if cc.Sprinting then cc:Sprint(false) end
                cc = Set(cc, "Fly", "Flying")
                if not cc or not cc.Flying then
                    yuri("FlyTo: mid-flight Fly(true) failed after restore")
                    return "refly_failed"
                end
                Shared.IsFly = true
            end
        end
        return reason
    end
    yuri("FlyTo: totalDist=", math.floor(totalDist), "yDelta=", math.floor(yDelta), "skipAscent=", tostring(skipAscent), "cruiseY=", math.floor(cruiseY))
    cc = Set(cc, "Fly", "Flying")
    if skipAscent then
        yuri("FlyTo: yDelta <= 50, flying direct to target")
        hrp = GetHRP()
        local directDist = hrp and (hrp.Position - targetPos).Magnitude or 50
        local directTimeout = math.max(10, directDist / math.max((cc and cc.FlySpeed or 40), 1) * 1.5)
        yuri("FlyTo: direct timeout=", math.floor(directTimeout), "dist=", math.floor(directDist))
        flySegment(targetPos, directTimeout, true)
    else
        local cruiseFrom = Vector3.new(hrp.Position.X, cruiseY, hrp.Position.Z)
        local cruiseTo   = Vector3.new(targetPos.X,    cruiseY, targetPos.Z)
        local synthetic = {
            { Position = hrp.Position },
            { Position = cruiseFrom   },
            { Position = cruiseTo     },
            { Position = targetPos    },
        }
        DrawPath(synthetic, true)
        yuri("FlyTo: ascending to Y =", math.floor(cruiseY))
        hrp = GetHRP()
        local ascentDist = hrp and (hrp.Position - cruiseFrom).Magnitude or cruiseY
        local ascentTimeout = math.max(8, ascentDist / math.max((cc and cc.FlySpeed or 40), 1) * 0.5)
        yuri("FlyTo: ascent timeout=", math.floor(ascentTimeout), "dist=", math.floor(ascentDist))
        flySegment(cruiseFrom, ascentTimeout)
        hrp = GetHRP()
        if hrp then
            cruiseFrom = Vector3.new(hrp.Position.X, cruiseY, hrp.Position.Z)
            yuri("FlyTo: post-ascent cruiseFrom updated to", tostring(cruiseFrom))
        end
        yuri("FlyTo: flying to target XZ at cruise")
        flySegment(cruiseTo, 50)
        yuri("FlyTo: descending to target")
        hrp = GetHRP()
        local descentDist = hrp and (hrp.Position - targetPos).Magnitude or cruiseY
        local descentTimeout = math.max(10, descentDist / math.max((cc and cc.FlySpeed or 40), 1) * 0.5)
        yuri("FlyTo: descent timeout=", math.floor(descentTimeout), "dist=", math.floor(descentDist))
        flyPhysicsTo(targetPos, descentTimeout, true)
    end
    DrawPath({}, false)
    if cc then
        cc = Set(cc, "Fly", "!Flying")
        if cc then cc = Set(cc, "Lay", "Laying") end
        Shared.IsFly = cc and cc.Flying or false
    end
    hrp = GetHRP()
    local arrived = hrp and (hrp.Position - targetPos).Magnitude < Shared.ArriveDist
    yuri("FlyTo: arrived=", tostring(arrived), hrp and tostring(hrp.Position) or "no hrp")
    return arrived
    end 
    local ok, result = pcall(_flyBody)
    Shared.NavLock = false
    if not ok then
        yuri("FlyTo: _flyBody error —", tostring(result))
        return false
    end
    return result
end
local Window = Library:CreateWindow({
    Title                = "Yuri",
    Center               = true,
    AutoShow             = true,
    Resizable            = true,
    ShowCustomCursor     = false,
    UnlockMouseWhileOpen = false,
    NotifySide           = "Left",
    TabPadding           = 8,
    MenuFadeTime         = 0.2,
})
AddInfo(Window)
local Tabs = {
    Automation = Window:AddTab("Automation"),
    Farm    = Window:AddTab("Farm"),
    ESP     = Window:AddTab("ESP"),
    Player  = Window:AddTab("Player"),
    Config  = Window:AddTab("Config"),
}
local AutomationLeft  = Tabs.Automation:AddLeftGroupbox("Autos")
local FarmLeft       = Tabs.Farm:AddLeftGroupbox("Auto Farm")
local FarmRight      = Tabs.Farm:AddRightGroupbox("Farm Settings")
local MissionLeft    = Tabs.Farm:AddLeftGroupbox("Region Missions")
local MissionRight   = Tabs.Farm:AddRightGroupbox("Mission Settings")
local ESPGroupLeft   = Tabs.ESP:AddLeftGroupbox("ESP")
local ESPGroupRight  = Tabs.ESP:AddRightGroupbox("ESP")
local PlayerLeft     = Tabs.Player:AddLeftGroupbox("Movement")
local PlayerGeneral  = Tabs.Player:AddLeftGroupbox("General")
local PlayerServer   = Tabs.Player:AddLeftGroupbox("Server")
local PlayerGame     = Tabs.Player:AddRightGroupbox("Game")
local PlayerSafety   = Tabs.Player:AddRightGroupbox("Safety")
local MenuGroup      = Tabs.Config:AddLeftGroupbox("Menu")
local TargetGroupId = 1002185259
local BannedRanks = {255, 254, 175, 150}
AutomationLeft:AddToggle("AutoEat", { Text = "Auto Eat", Default = false })
AutomationLeft:AddSlider("EatInterval", {
    Text     = "Eat Interval (s)",
    Default  = 3, Min = 0.5, Max = 15, Rounding = 1, Compact = true,
})
AutomationLeft:AddToggle("AutoDrink", { Text = "Auto Drink", Default = false })
AutomationLeft:AddSlider("DrinkInterval", {
    Text     = "Drink Interval (s)",
    Default  = 3, Min = 0.5, Max = 15, Rounding = 1, Compact = true,
})
AutomationLeft:AddToggle("PreferSicklyWater", { Text = "Prefer Sickly Water", Default = false })
AutomationLeft:AddToggle("AutoSniff", { Text = "Auto Sniff", Default = false })
AutomationLeft:AddSlider("SniffInterval", {
    Text     = "Sniff Interval (s)",
    Default  = 3, Min = 0.5, Max = 15, Rounding = 1, Compact = true,
})
AutomationLeft:AddToggle("AutoMud", { Text = "Auto Mud", Default = false })
AutomationLeft:AddSlider("MudInterval", {
    Text     = "Mud Interval (s)",
    Default  = 5, Min = 1, Max = 30, Rounding = 1, Compact = true,
})
AutomationLeft:AddToggle("AutoRespawn", { Text = "Auto Respawn", Default = false })
local RespawnSlotNames = { "Auto" }
do
    local client = PlayerWrapper.GetClient()
    if client and client.SlotValues then
        for _, slotVal in pairs(client.SlotValues) do
            if slotVal and slotVal.Dino and #slotVal.Dino.Value > 0 then
                table.insert(RespawnSlotNames, slotVal.Name)
            end
        end
    end
end
AutomationLeft:AddDropdown("RespawnSlot", {
    Text    = "Respawn Slot",
    Values  = RespawnSlotNames,
    Default = "Auto",
    Searchable = true,
})
FarmLeft:AddToggle("AutoCollect", { Text = "Auto Collect", Default = false })
FarmLeft:AddDivider()
FarmLeft:AddToggle("AutoFarmTokens", { Text = "Auto Farm Tokens", Default = false })
FarmLeft:AddToggle("AutoFarmShooms", { Text = "Auto Farm Shooms", Default = false })
FarmRight:AddSlider("CollectRange", {
    Text     = "Collect Range (studs)",
    Default  = 100, Min = 5, Max = 100, Rounding = 0, Compact = true,
})
FarmRight:AddDivider()
FarmRight:AddSlider("FarmTokenDelay", {
    Text     = "Token Delay (s)",
    Default  = 0.3, Min = 0.01, Max = 2, Rounding = 2, Compact = true,
})
FarmRight:AddSlider("FarmShoomDelay", {
    Text     = "Shoom Delay (s)",
    Default  = 0.3, Min = 0.01, Max = 2, Rounding = 2, Compact = true,
})
MissionLeft:AddToggle("AutoRegionMission", { Text = "Auto Do Region Mission", Default = false })
local deathPtLabel = MissionLeft:AddLabel("<b>Death Points:</b> —", true)
MissionRight:AddDropdown("RegionBlacklist", {
    Text       = "Blacklisted Regions",
    Values     = AllRegionNames,
    Default    = {},
    Searchable = true,
    Multi      = true,
})
MissionRight:AddDropdown("QuestTypeBlacklist", {
    Text    = "Blacklisted Quest Types",
    Values  = AllQuestTypes,
    Default = {},
    Multi   = true,
})
for _, cfg in ipairs(TargetConfig) do
    local grp = cfg.Group == "right" and ESPGroupRight or ESPGroupLeft
    grp:AddToggle(cfg.Id, { Text = cfg.Text, Default = false })
    grp:AddLabel("Fill Color"):AddColorPicker(cfg.Id .. "Color", {
        Title   = cfg.Text .. " Fill",
        Default = cfg.Color,
    })
    grp:AddLabel("Outline Color"):AddColorPicker(cfg.Id .. "Outline", {
        Title   = cfg.Text .. " Outline",
        Default = Color3.fromRGB(0, 0, 0),
    })
end
AddSliderToggle({ Group = PlayerLeft, Id = "WS", Text = "WalkSpeed", Default = 32, Min = 16, Max = 400 })
AddSliderToggle({ Group = PlayerLeft, Id = "FS", Text = "FlySpeed",  Default = 40, Min = 10, Max = 400 })
PlayerGeneral:AddToggle("Disable3DRender", { Text = "Disable 3D Rendering" })
AddSliderToggle({ Group = PlayerGeneral, Id = "Zoom", Text = "Camera Zoom", Default = 128, Min = 128, Max = 10000 })
AddSliderToggle({ Group = PlayerGeneral, Id = "FOV", Text = "Field of View", Default = 70, Min = 30, Max = 120 })
local FPS_T, FPS_S = AddSliderToggle({ Group = PlayerGeneral, Id = "LimitFPS", Text = "Set Max FPS", Disabled = not Support.FPS, Default = 60, Min = 5, Max = 360 })
PlayerGeneral:AddToggle("FPSBoost", { Text = "FPS Boost" })
PlayerServer:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = true,
    Disabled = not Support.Connections,
})
PlayerServer:AddButton({ Text = "Serverhop", Func = function()
    local ok, raw = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    if not ok then return end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or not data or not data.data then return end
    local servers = data.data
    local currentJobId = game.JobId
    for _, server in ipairs(servers) do
        if server.id ~= currentJobId and server.playing and server.maxPlayers and server.playing < server.maxPlayers then
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr) end)
            return
        end
    end
end})
PlayerServer:AddButton({ Text = "Rejoin", Func = function() TeleportService:Teleport(game.PlaceId, Plr) end })
PlayerServer:AddToggle("AutoServerhop", { Text = "Auto Serverhop" })
PlayerServer:AddSlider("AutoHopMins", { Text = "Minutes", Default = 30, Min = 0, Max = 300, Compact = true, Rounding = 0 })
PlayerGame:AddToggle("Fullbright", { Text = "Fullbright" })
PlayerGame:AddToggle("NoFog", { Text = "No Fog" })
AddSliderToggle({ Group = PlayerGame, Id = "OverrideTime", Text = "Time Of Day", Default = 12, Min = 0, Max = 24, Rounding = 1 })
PlayerSafety:AddToggle("AutoKick", { Text = "Auto Kick", Default = true })
PlayerSafety:AddDropdown("SelectedKickType", {
    Text = "Select Type",
    Values = {"Mod", "Player Join", "Public Server"},
    Default = {"Mod"},
    Multi = true,
    Searchable = true,
})
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default  = Library.KeybindFrame.Visible,
    Text     = "Open Keybind Menu",
    Callback = function(v) Library.KeybindFrame.Visible = v end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text     = "Custom Cursor",
    Default  = false,
    Callback = function(v) Library.ShowCustomCursor = v end,
})
MenuGroup:AddDropdown("NotificationSide", {
    Values   = { "Left", "Right" },
    Default  = "Left",
    Text     = "Notification Side",
    Callback = function(v) Library:SetNotifySide(v) end,
})
MenuGroup:AddDropdown("DPIDropdown", {
    Values   = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default  = "100%",
    Text     = "DPI Scale",
    Callback = function(v)
        Library:SetDPIScale(tonumber(v:gsub("%%", "")))
    end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "U", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
    getgenv().ayasemiyatongekissazumirisa = false
    Shared.Farm = false
    Cleanup(ESPConnections)
    Cleanup(Connections)
    Cleanup(Flags)
    Library:Unload()
end)
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
Toggles.Disable3DRender:OnChanged(function(v)
    RunService:Set3dRenderingEnabled(not v)
end)
Toggles.FPSBoost:OnChanged(function(state)
    ApplyFPSBoost(state)
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
Connections.Player_Render = RunService.Stepped:Connect(function()
    if Toggles.FOV and Toggles.FOV.Value then
        workspace.CurrentCamera.FieldOfView = Options.FOVValue.Value
    end
    if Toggles.Zoom and Toggles.Zoom.Value then
        Plr.CameraMaxZoomDistance = Options.ZoomValue.Value
    end
end)
task.spawn(function()
    while task.wait() do
        if Toggles.Fullbright and Toggles.Fullbright.Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
        elseif Toggles.OverrideTime and Toggles.OverrideTime.Value then
            Lighting.ClockTime = Options.OverrideTimeValue.Value
        end
        if Toggles.NoFog and Toggles.NoFog.Value then
            Lighting.FogEnd = 9e9 end
        if Library.Unloaded then break end
    end
end)
local function DisableIdled()
    pcall(function()
        local cons = getconnections or get_signal_cons
        if cons then
            for _, v in pairs(cons(Plr.Idled)) do
                if v.Disable then v:Disable()
                elseif v.Disconnect then v:Disconnect() end
            end
        end
    end)
end
task.spawn(function()
    DisableIdled()
    while true do
        task.wait(60)
        if Toggles.AntiAFK and Toggles.AntiAFK.Value then
            pcall(function()
                Services.VirtualUser:CaptureController()
                Services.VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(0.2)
                Services.VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)
task.spawn(function()
    while true do
        local mins = Options.AutoHopMins and Options.AutoHopMins.Value or 30
        task.wait(math.max(mins, 1) * 60)
        if not Toggles.AutoServerhop or not Toggles.AutoServerhop.Value then continue end
        local ok, raw = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        end)
        if not ok then continue end
        local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok2 or not data or not data.data then continue end
        for _, server in ipairs(data.data) do
            if server.id ~= game.JobId and server.playing and server.maxPlayers and server.playing < server.maxPlayers then
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Plr) end)
                break
            end
        end
    end
end)
local function CheckPlayerForSafety(targetPlayer)
    if not Toggles.AutoKick or not Toggles.AutoKick.Value then return end
    if targetPlayer == Plr then return end
    local kickTypes = Options.SelectedKickType and Options.SelectedKickType.Value or {}
    if kickTypes["Player Join"] then
        task.wait(0.5)
        Plr:Kick("\n[CoS Script]\nReason: A player joined the server (" .. targetPlayer.Name .. ")")
        return
    end
    if kickTypes["Mod"] then
        local success, rank = pcall(function() return targetPlayer:GetRankInGroup(TargetGroupId) end)
        if success and table.find(BannedRanks, rank) then
            task.wait(0.5)
            Plr:Kick("\n[CoS Script]\nReason: Moderator Detected (" .. targetPlayer.Name .. ")")
        end
    end
end
local function CheckServerTypeSafety()
    if not Toggles.AutoKick or not Toggles.AutoKick.Value then return end
    local kickTypes = Options.SelectedKickType and Options.SelectedKickType.Value or {}
    if kickTypes["Public Server"] then
        local success, serverType = pcall(function()
            local remote = game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType", 2)
            if remote then return remote:InvokeServer() end
            return "Unknown"
        end)
        if success and serverType ~= "VIPServer" then
            task.wait(0.8)
            Plr:Kick("\n[CoS Script]\nReason: You are in a public server.")
        end
    end
end
local function InitAutoKick()
    CheckServerTypeSafety()
    for _, p in ipairs(Players:GetPlayers()) do
        CheckPlayerForSafety(p)
    end
    Players.PlayerAdded:Connect(CheckPlayerForSafety)
end
Options.SelectedKickType:OnChanged(function()
    CheckServerTypeSafety()
end)
InitAutoKick()
Toggles.AutoEat:OnChanged(function()
    Thread("Automation.Eat", function()
        while Toggles.AutoEat.Value do
            local stats = GetCharStats()
            local pct   = stats and stats.hun
            local diet  = stats and stats.diet
            if (pct == nil or pct < 1) and not Shared.IsConsuming then
                Shared.IsConsuming = true
                yuri("AutoEat: acquired lock, eating until full")
                while Toggles.AutoEat.Value do
                    local s2  = GetCharStats()
                    local p2  = s2 and s2.hun
                    local d2  = s2 and s2.diet
                    if p2 ~= nil and p2 >= 1 then
                        yuri("AutoEat: sated (hun=", math.floor(p2*100), "%), releasing lock")
                        break
                    end
                    local food = IsTagged("Food", function(obj)
                        if not d2 then return true end
                        local name = obj:GetAttribute("FoodDataName") or obj.Name
                        local fd = Sonar("Constants").FoodData[name]
                        if not fd then return false end
                        return d2 == "Omnivore" or fd.Diet == d2 or fd.Diet == "Omnivore"
                    end, nil, true)
                    if food then
                        local hrp = GetHRP()
                        local foodPos = food:IsA("BasePart") and food.Position or (food.PrimaryPart and food.PrimaryPart.Position)
                        if hrp and foodPos then
                            if (foodPos - hrp.Position).Magnitude > 100 then
                                FlyTo(foodPos)
                            end
                            if Shared.LastSwitch.action ~= "eat" then
                                yuri("AutoEat: switched from", Shared.LastSwitch.action or "none", "-> eat, waiting 1s")
                                task.wait(1)
                            end
                            Shared.LastSwitch.action = "eat"
                            local cc = GetCharClass()
                            if cc then
                                cc = DoConsume(cc, "StartEat", food)
                            end
                        end
                    end
                    task.wait(Options.EatInterval.Value)
                end
                if cc then pcall(function() cc:StopEatDrink() end) end
                Shared.IsConsuming = false
            end
            task.wait(Options.EatInterval.Value)
        end
    end, Toggles.AutoEat.Value)
end)
Toggles.AutoDrink:OnChanged(function()
    Thread("Automation.Drink", function()
        while Toggles.AutoDrink.Value do
            local stats = GetCharStats()
            local pct   = stats and stats.thirst
            if (pct == nil or pct < 1) and not Shared.IsConsuming then
                Shared.IsConsuming = true
                yuri("AutoDrink: acquired lock, drinking until full")
                while Toggles.AutoDrink.Value do
                    local s2 = GetCharStats()
                    local p2 = s2 and s2.thirst
                    if p2 ~= nil and p2 >= 1 then
                        yuri("AutoDrink: sated (thirst=", math.floor(p2*100), "%), releasing lock")
                        break
                    end
                    local water = GetSick(Toggles.PreferSicklyWater.Value, true)
                    if water then
                        local hrp = GetHRP()
                        local _wp = water:IsA("BasePart") and water or water.PrimaryPart
                        local waterPos = _wp and Vector3.new(_wp.Position.X, _wp.Position.Y + _wp.Size.Y / 2, _wp.Position.Z)
                        if hrp and waterPos then
                            if (waterPos - hrp.Position).Magnitude > 100 then
                                FlyTo(waterPos)
                            end
                            if Shared.LastSwitch.action ~= "drink" then
                                yuri("AutoDrink: switched from", Shared.LastSwitch.action or "none", "-> drink, waiting 1s")
                                task.wait(1)
                            end
                            Shared.LastSwitch.action = "drink"
                            yuri("AutoDrink: drinking from", water.Parent:GetAttribute("Sickly") == true and "SICKLY" or "clean", "water")
                            local cc = GetCharClass()
                            if cc then
                                cc = DoConsume(cc, "StartDrink", water)
                            end
                        end
                    end
                    task.wait(Options.DrinkInterval.Value)
                end
                if cc then pcall(function() cc:StopEatDrink() end) end
                Shared.IsConsuming = false
            end
            task.wait(Options.DrinkInterval.Value)
        end
    end, Toggles.AutoDrink.Value)
end)
Toggles.AutoSniff:OnChanged(function()
    Thread("Automation.Sniff", function()
        while Toggles.AutoSniff.Value do
            pcall(function() Remotes.SetMission:FireServer(1) end)
            task.wait(Options.SniffInterval.Value)
        end
    end, Toggles.AutoSniff.Value)
end)
Toggles.AutoMud:OnChanged(function()
    Thread("Automation.Mud", function()
        while Toggles.AutoMud.Value do
            local hrp = GetHRP()
            local mud
            if hrp then
                for _, obj in ipairs(CollectionService:GetTagged("Mud")) do
                    local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                    if p and (p - hrp.Position).Magnitude <= Shared.ArriveDist then
                        mud = obj
                        break
                    end
                end
            end
            if not mud then
                mud = IsTagged("Mud", nil, nil, true)
            end
            if mud and hrp then
                pcall(function() Remotes.Mud:FireServer(mud) end)
            end
            task.wait(Options.MudInterval.Value)
        end
    end, Toggles.AutoMud.Value)
end)
Toggles.AutoRespawn:OnChanged(function()
    Thread("Automation.AutoRespawn", function()
        local function resolveRespawnSlot(fallbackSlot)
            local chosen = Options.RespawnSlot.Value
            if not chosen or chosen == "Auto" then
                return fallbackSlot
            end
            local resolved = PlayerWrapper.GetClient():_getSlotValue(chosen)
            if not resolved then
                yuri("AutoRespawn: selected slot '" .. tostring(chosen) .. "' not found — falling back to current slot")
                return fallbackSlot
            end
            return resolved
        end
        local function doSpawn(slotName)
            yuri("AutoRespawn: respawning slot " .. tostring(slotName) .. " via SaveSelectionClient.Respawn")
            local ok = pcall(function()
                SaveSelectionClient.Respawn(slotName)
            end)
            if not ok then
                yuri("AutoRespawn: SaveSelectionClient.Respawn failed")
                return
            end
            yuri("AutoRespawn: SaveSelectionClient.Respawn call completed")
        end
        while Toggles.AutoRespawn.Value do
            if Constants.InDeathScreen then
                local currentSlot = PlayerWrapper.GetClient():GetCurrentSlot()
                local slot = resolveRespawnSlot(currentSlot)
                if not slot then
                    yuri("AutoRespawn: InDeathScreen but no current slot — skipping")
                else
                    yuri("AutoRespawn: closing death screen (claims death rewards) for slot " .. tostring(slot.Name))
                    local closeOk = pcall(function()
                        DeathClient.Close(true)
                    end)
                    if not closeOk then
                        yuri("AutoRespawn: DeathClient.Close failed")
                    end
                    if not CreatureInfoService.IsDead(slot) then
                        yuri("AutoRespawn: slot " .. tostring(slot.Name) .. " is not dead — spawning directly")
                        doSpawn(slot.Name)
                    else
                        local hasMutations = CreatureInfoService.HasCreatureGotMutations(slot)
                        yuri("AutoRespawn: restarting dead slot " .. tostring(slot.Name))
                        local restartOk, restartResult = pcall(function()
                            return Remotes.RestartSlot:InvokeServer(slot.Name, hasMutations)
                        end)
                        if not restartOk then
                            yuri("AutoRespawn: RestartSlot InvokeServer errored — skipping spawn this pass")
                        elseif not restartResult then
                            yuri("AutoRespawn: RestartSlot returned failure — skipping spawn this pass")
                        else
                            task.wait(0.5)
                            if CreatureInfoService.IsDead(slot) then
                                yuri("AutoRespawn: slot " .. tostring(slot.Name) .. " still dead after RestartSlot — skipping spawn this pass")
                            else
                                doSpawn(slot.Name)
                            end
                        end
                    end
                end
                local waited = 0
                while Constants.InDeathScreen and Toggles.AutoRespawn.Value and waited < 10 do
                    task.wait(0.5)
                    waited = waited + 0.5
                end
            elseif not PlayerWrapper.GetClient():GetCurrentCharacter() then
                local currentSlot = PlayerWrapper.GetClient():GetCurrentSlot()
                local slot = resolveRespawnSlot(currentSlot)
                if not slot then
                    yuri("AutoRespawn: not spawned in but no current slot — skipping")
                elseif CreatureInfoService.IsDead(slot) then
                    local hasMutations = CreatureInfoService.HasCreatureGotMutations(slot)
                    yuri("AutoRespawn: not spawned in and slot " .. tostring(slot.Name) .. " is dead — restarting")
                    local restartOk, restartResult = pcall(function()
                        return Remotes.RestartSlot:InvokeServer(slot.Name, hasMutations)
                    end)
                    if not restartOk then
                        yuri("AutoRespawn: RestartSlot InvokeServer errored — skipping spawn this pass")
                    elseif not restartResult then
                        yuri("AutoRespawn: RestartSlot returned failure — skipping spawn this pass")
                    else
                        task.wait(0.5)
                        if CreatureInfoService.IsDead(slot) then
                            yuri("AutoRespawn: slot " .. tostring(slot.Name) .. " still dead after RestartSlot — skipping spawn this pass")
                        else
                            doSpawn(slot.Name)
                        end
                    end
                else
                    doSpawn(slot.Name)
                end
                local waited = 0
                while Toggles.AutoRespawn.Value and not Constants.InDeathScreen
                    and not PlayerWrapper.GetClient():GetCurrentCharacter() and waited < 10 do
                    task.wait(0.5)
                    waited = waited + 0.5
                end
            end
            task.wait(0.5)
        end
    end, Toggles.AutoRespawn.Value)
end)
Toggles.AutoCollect:OnChanged(function()
    Thread("Farm.Collect", function()
        while Toggles.AutoCollect.Value do
            local hrp   = GetHRP()
            local range = Options.CollectRange.Value
            if hrp then
                local tokenFolder = workspace:FindFirstChild("Interactions")
                               and workspace.Interactions:FindFirstChild("SpawnedTokens")
                if tokenFolder then
                    for _, token in ipairs(tokenFolder:GetChildren()) do
                        local pos = token:IsA("BasePart") and token.Position
                                 or (token.PrimaryPart and token.PrimaryPart.Position)
                        if pos and (pos - hrp.Position).Magnitude <= range then
                            pcall(function() Remotes.GetToken:InvokeServer() end)
                            task.wait(0.1)
                        end
                    end
                end
                for _, pile in ipairs(CollectionService:GetTagged("ShoomPile")) do
                    local pos = pile:IsA("BasePart") and pile.Position
                             or (pile.PrimaryPart and pile.PrimaryPart.Position)
                    if pos and (pos - hrp.Position).Magnitude <= range then
                        local region = pile:GetAttribute("Region")
                        local id     = pile:GetAttribute("Id")
                        if region and id then
                            local ok = ShoomPilesService.CanCollect(Plr, region, id)
                            if ok == true then
                                pcall(function() Remotes.GetShoom:InvokeServer(region, id) end)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end, Toggles.AutoCollect.Value)
end)
local function AnyFarmActive()
    return Toggles.AutoFarmTokens.Value
        or Toggles.AutoFarmShooms.Value
end
Toggles.AutoFarmTokens:OnChanged(function()
    if not Toggles.AutoFarmTokens.Value and not AnyFarmActive() then end
    Thread("Farm.Tokens", function()
        while Toggles.AutoFarmTokens.Value do
            local folder = workspace:FindFirstChild("Interactions")
                       and workspace.Interactions:FindFirstChild("SpawnedTokens")
            if folder then
                local tokens = folder:GetChildren()
                local token = GetNearest(tokens, function(t)
                    return t:IsA("BasePart") and t.Position
                        or (t.PrimaryPart and t.PrimaryPart.Position)
                end)
                if token then
                    local pos = token:IsA("BasePart") and token.Position
                             or (token.PrimaryPart and token.PrimaryPart.Position)
                    if pos then
                        local hrp = GetHRP()
                        if hrp then
                            task.wait()
                            hrp.CFrame = CFrame.new(Vector3.new(pos.X, pos.Y + 15, pos.Z))
                        end
                        if not token.Parent then
                            yuri("AutoFarmTokens: token disappeared after nav, retargeting")
                        else
                            local t0 = tick()
                            while token.Parent and tick() - t0 < 5 do
                                local hrp2 = GetHRP()
                                if not hrp2 or (hrp2.Position - pos).Magnitude > Shared.CollectRange then break end
                                pcall(function() Remotes.GetToken:InvokeServer() end)
                                RunService.Heartbeat:Wait()
                            end
                            task.wait(Options.FarmTokenDelay.Value)
                        end
                    end
                end
            end
            task.wait()
        end
    end, Toggles.AutoFarmTokens.Value)
end)
Toggles.AutoFarmShooms:OnChanged(function()
    if not Toggles.AutoFarmShooms.Value and not AnyFarmActive() then end
    Thread("Farm.Shooms", function()
        while Toggles.AutoFarmShooms.Value do
            local tagged = CollectionService:GetTagged("ShoomPile")
            local eligible = {}
            for _, pile in ipairs(tagged) do
                local region = pile:GetAttribute("Region")
                local id     = pile:GetAttribute("Id")
                if region and id then
                    local preCheck = ShoomPilesService.CanCollect(Plr, region, id)
                    if not (type(preCheck) == "table" and preCheck[1] == "ShoomCollected") then
                        table.insert(eligible, pile)
                    end
                end
            end
            local pile = GetNearest(eligible, function(p)
                return p:IsA("BasePart") and p.Position
                    or (p.PrimaryPart and p.PrimaryPart.Position)
            end)
            if pile then
                local region = pile:GetAttribute("Region")
                local id     = pile:GetAttribute("Id")
                local pos    = pile:IsA("BasePart") and pile.Position
                            or (pile.PrimaryPart and pile.PrimaryPart.Position)
                if pos then
                    local hrp = GetHRP()
                    if hrp then
                        task.wait()
                        hrp.CFrame = CFrame.new(Vector3.new(pos.X, pos.Y + 15, pos.Z))
                    end
                    if not pile.Parent then
                        yuri("AutoFarmShooms: pile disappeared after nav, retargeting")
                    else
                        local t0 = tick()
                        while pile.Parent and tick() - t0 < 5 do
                            local hrp2 = GetHRP()
                            if not hrp2 or (hrp2.Position - pos).Magnitude > Shared.CollectRange then break end
                            local ok = ShoomPilesService.CanCollect(Plr, region, id)
                            if ok ~= true then break end
                            pcall(function() Remotes.GetShoom:InvokeServer(region, id) end)
                            RunService.Heartbeat:Wait()
                        end
                        task.wait(Options.FarmShoomDelay.Value)
                    end
                end
            end
            task.wait()
        end
    end, Toggles.AutoFarmShooms.Value)
end)
local function getRegionMissionsFolder()
    local ok, client = pcall(function()
        return Sonar("PlayerWrapper").GetClient()
    end)
    if not ok or not client then return nil end
    local missions = client.PlayerData:FindFirstChild("Missions")
    if not missions then return nil end
    return missions:FindFirstChild("RegionMissions")
end
local function GetIncomplete(regionFolder)
    local incomplete = {}
    for _, child in ipairs(regionFolder:GetChildren()) do
        if child:IsA("BoolValue") then
            local amount  = child:FindFirstChild("Amount")
            local target  = child:FindFirstChild("TargetAmount")
            local refresh = child:FindFirstChild("Refresh")
            yuri("RegionMission: task", child.Name, "| done:", child.Value,
                "| progress:", amount and amount.Value or "?", "/", target and target.Value or "?",
                "| refresh:", refresh and refresh.Value or "none")
            if not child.Value then
                if child.Name == "ShoomPilesCollected" then
                    yuri("RegionMission: skipping", child.Name, "— Shoom is an extra quest, ignored entirely")
                elseif refresh and refresh.Value ~= -1 then
                    yuri("RegionMission: skipping", child.Name, "— Refresh on cooldown, refreshes at:", refresh.Value)
                elseif Options.QuestTypeBlacklist.Value[child.Name] then
                    yuri("RegionMission: skipping", child.Name, "— blacklisted quest type")
                else
                    table.insert(incomplete, { taskType = child.Name, child = child })
                end
            end
        end
    end
    local TASK_PRIORITY = {
        ConcealScent              = 1,
        Sniff                     = 2,
        AttackOrHealCreatureOrNPC = 3,
        EatFoodDrinkWater         = 4,
    }
    table.sort(incomplete, function(a, b)
        local pa = TASK_PRIORITY[a.taskType] or 99
        local pb = TASK_PRIORITY[b.taskType] or 99
        return pa < pb
    end)
    yuri("RegionMission: GetIncomplete for", regionFolder.Name, "— found", #incomplete, "incomplete")
    if #incomplete > 1 then
        local otherCount = 0
        for _, t in ipairs(incomplete) do
            if t.taskType ~= "DistanceTravelled" and t.taskType ~= "TimePlayed" then
                otherCount = otherCount + 1
            end
        end
        if otherCount > 0 then
            for i = #incomplete, 1, -1 do
                if incomplete[i].taskType == "DistanceTravelled" then
                    table.remove(incomplete, i)
                    yuri("RegionMission: deferring DistanceTravelled — other tasks still pending (otherCount=" .. otherCount .. ")")
                end
            end
        else
            yuri("RegionMission: DistanceTravelled allowed — only TimePlayed or itself remains")
        end
    end
    return incomplete
end
local function IsInRegion(regionFolder)
    local rcParams = RaycastParams.new()
    rcParams.IncludeInstances = { workspace.Interactions.Regions }
    rcParams.CollisionGroup = "RegionParts"
    return function(p)
        local result = workspace:Raycast(p, Vector3.new(0, -600 - p.Y, 0), rcParams)
        return result ~= nil and result.Instance.Parent.Name == regionFolder.Name
    end
end
local function NavTo(taskType, regionFolder, highAlt)
    local hrp = GetHRP()
    local cc = GetCharClass()
    if not hrp then return false end
    local regionModel = workspace.Interactions.Regions:FindFirstChild(regionFolder.Name)
    local pivot = regionModel and regionModel:GetPivot().Position
    local inRegion = IsInRegion(regionFolder)
    local target = nil
    if taskType == "ConcealScent" then
        local bestOut, bestOutD = nil, math.huge
        local bestIn,  bestInD  = nil, math.huge
        for _, part in ipairs(CollectionService:GetTagged("Mud")) do
            if part:IsA("BasePart") and inRegion(part.Position) then
                local d = pivot and (part.Position - pivot).Magnitude
                       or (hrp and (part.Position - hrp.Position).Magnitude or math.huge)
                if IsOutdoor(part.Position) then
                    if d < bestOutD then bestOutD = d; bestOut = part end
                else
                    if d < bestInD  then bestInD  = d; bestIn  = part end
                end
            end
        end
        local best = bestOut or bestIn
        if best then
            if not bestOut then
                yuri("RegionMission: NavTo ConcealScent — no outdoor mud in region, falling back to indoor mud at dist:", bestInD)
            else
                yuri("RegionMission: NavTo ConcealScent — outdoor mud inside region at dist:", bestOutD)
            end
            target = best.Position
        end
    elseif taskType == "EatFoodDrinkWater" then
        local stats    = GetCharStats()
        local diet     = stats and stats.diet
        local foodPct  = stats and stats.hun
        local waterPct = stats and stats.thirst
        local needFood  = foodPct  == nil or foodPct  < 1
        local needWater = waterPct == nil or waterPct < 1
        yuri("RegionMission: NavTo EatFoodDrinkWater — needFood:", needFood, "(", foodPct and math.floor(foodPct*100) or "?", "%) needWater:", needWater, "(", waterPct and math.floor(waterPct*100) or "?", "%)")
        if needFood then
            local bestFood, bestFoodDist = nil, math.huge
            local function foodFilter(obj)
                if (obj:GetAttribute("Value") or 0) <= 0 then return false end
                if not diet then return true end
                local name = obj:GetAttribute("FoodDataName") or obj.Name
                local fd = Sonar("Constants").FoodData[name]
                if not fd then return false end
                return diet == "Omnivore" or fd.Diet == diet or fd.Diet == "Omnivore"
            end
            for _, obj in ipairs(CollectionService:GetTagged("Food")) do
                if foodFilter(obj) then
                    local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                    if p and inRegion(p) then
                        local d = pivot and (p - pivot).Magnitude or math.huge
                        if IsOutdoor(p) then
                            if d < bestFoodDist then bestFoodDist = d; bestFood = p end
                        end
                    end
                end
            end
            if not bestFood then
                local bestIndoorDist = math.huge
                for _, obj in ipairs(CollectionService:GetTagged("Food")) do
                    if foodFilter(obj) then
                        local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                        if p and inRegion(p) then
                            local d = pivot and (p - pivot).Magnitude or math.huge
                            if d < bestIndoorDist then bestIndoorDist = d; bestFood = p end
                        end
                    end
                end
                if bestFood then
                    yuri("RegionMission: NavTo — no outdoor food in region, falling back to indoor food")
                end
            end
            if bestFood then
                yuri("RegionMission: NavTo — food inside region at dist:", bestFoodDist)
                target = bestFood
            end
        end
        if not target and needWater then
            local BestWater, BestWaterDist = nil, math.huge
            for _, obj in ipairs(CollectionService:GetTagged("DrinkableWater")) do
                local part = obj:IsA("BasePart") and obj or obj.PrimaryPart
                local p = part and part.Position
                if p and inRegion(p) and IsOutdoor(p) and obj.Parent:GetAttribute("Sickly") == true then
                    local d = pivot and (p - pivot).Magnitude or math.huge
                    if d < BestWaterDist then
                        BestWaterDist = d
                        BestWater = Vector3.new(p.X, p.Y + part.Size.Y / 2, p.Z)
                    end
                end
            end
            if BestWater then
                yuri("RegionMission: NavTo — sickly water inside region at dist:", BestWaterDist)
                target = BestWater
            end
        end
        if not target then
            yuri("RegionMission: NavTo EatFoodDrinkWater — creature is full or no resource found, falling back to pivot")
        end
    end
    if not target then
        local stats = GetCharStats()
        local diet = stats and stats.diet
        local function foodFilter(obj)
            if (obj:GetAttribute("Value") or 0) <= 0 then return false end
            if not diet then return true end
            local name = obj:GetAttribute("FoodDataName") or obj.Name
            local fd = Sonar("Constants").FoodData[name]
            if not fd then return false end
            return diet == "Omnivore" or fd.Diet == diet or fd.Diet == "Omnivore"
        end
        local bestDist = math.huge
        for _, obj in ipairs(CollectionService:GetTagged("Food")) do
            if foodFilter(obj) then
                local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                if p and inRegion(p) then
                    local d = (p - hrp.Position).Magnitude
                    if d < bestDist then bestDist = d; target = p end
                end
            end
        end
        if target then
            yuri("RegionMission: NavTo — borrowed food target for TP (dist:", bestDist, ")")
        else
            bestDist = math.huge
            for _, part in ipairs(CollectionService:GetTagged("Mud")) do
                if part:IsA("BasePart") and inRegion(part.Position) then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < bestDist then bestDist = d; target = part.Position end
                end
            end
            if target then
                yuri("RegionMission: NavTo — borrowed mud target for TP (dist:", bestDist, ")")
            end
        end
    end
    if not target then
        if pivot then
            yuri("RegionMission: NavTo — no resource target found for", taskType, "— using pivot (no TP)")
            target = pivot
        else
            yuri("RegionMission: NavTo — no nav target found for", taskType, "in", regionFolder.Name)
            return false
        end
    end
    if (target - hrp.Position).Magnitude <= Shared.ArriveDist then return true end
    yuri("RegionMission: NavTo — moving to", taskType, "target in", regionFolder.Name)
    if Shared.PauseMission then
        yuri("RegionMission: NavTo — DistanceTravelled in progress, holding teleport...")
        repeat task.wait(1) until not Shared.PauseMission or not Toggles.AutoRegionMission.Value
        if not Toggles.AutoRegionMission.Value then return false end
        yuri("RegionMission: NavTo — DistanceTravelled done, resuming teleport")
    end
    Shared.CurTar = target
    task.wait()
    hrp.CFrame = CFrame.new(Vector3.new(target.X, target.Y + 15, target.Z))
    yuri("RegionMission: NavTo — teleported to", hrp.Position, "(highAlt=" .. tostring(highAlt) .. ")")
    return true
end
local function FindColocatedSpot(diet, regionFolder)
    local hrp = GetHRP()
    if not hrp then return nil end
    local origin = hrp.Position
    local inRegion = IsInRegion(regionFolder)
    local waterOut, waterIn = {}, {}
    for _, obj in ipairs(CollectionService:GetTagged("DrinkableWater")) do
        if obj:GetAttribute("FakeWater") or (obj.Parent and obj.Parent:GetAttribute("FakeWater")) then continue end
        local part = obj:IsA("BasePart") and obj or obj.PrimaryPart
        local p = part and Vector3.new(part.Position.X, part.Position.Y + part.Size.Y / 2, part.Position.Z)
        if p and inRegion(p) then
            if IsOutdoor(p) then table.insert(waterOut, p)
            else table.insert(waterIn, p) end
        end
    end
    local waterCandidates = #waterOut > 0 and waterOut or waterIn
    if #waterCandidates == 0 then
        yuri("FindColocatedSpot: no in-region water found")
        return nil
    end
    local function nearestWaterDist(pos)
        local best = math.huge
        for _, wp in ipairs(waterCandidates) do
            local d = (wp - pos).Magnitude
            if d < best then best = d end
        end
        return best
    end
    local function foodFilter(obj)
        if (obj:GetAttribute("Value") or 0) <= 0 then return false end
        if not diet then return true end
        local name = obj:GetAttribute("FoodDataName") or obj.Name
        local fd = Sonar("Constants").FoodData[name]
        if not fd then return false end
        return diet == "Omnivore" or fd.Diet == diet or fd.Diet == "Omnivore"
    end
    local bestOut, bestOutScore = nil, math.huge
    local bestIn,  bestInScore  = nil, math.huge
    for _, obj in ipairs(CollectionService:GetTagged("Food")) do
        if foodFilter(obj) then
            local fp = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
            if fp and inRegion(fp) then
                local toWater = nearestWaterDist(fp)
                if toWater <= Shared.WaterRange then
                    local score = (fp - origin).Magnitude
                    if IsOutdoor(fp) then
                        if score < bestOutScore then bestOutScore = score; bestOut = fp end
                    else
                        if score < bestInScore  then bestInScore  = score; bestIn  = fp end
                    end
                end
            end
        end
    end
    local spot = bestOut or bestIn
    if spot then
        yuri("FindColocatedSpot: spot dist=", math.floor((spot - origin).Magnitude), "| outdoor=", tostring(spot == bestOut))
    else
        yuri("FindColocatedSpot: no paired food+water spot in region")
    end
    return spot
end
local function DoMission(taskType, regionFolder)
    if taskType == "EatFoodDrinkWater" then
        local hrp = GetHRP()
        if not hrp then return false end
        local stats = GetCharStats()
        local diet     = stats and stats.diet
        local foodPct  = stats and stats.hun
        local waterPct = stats and stats.thirst
        Shared.CurHun    = foodPct
        Shared.CurThirst = waterPct
        local needFood  = foodPct  == nil or foodPct  < 1
        local needWater = waterPct == nil or waterPct < 1
        yuri("RegionMission: EatFoodDrinkWater — diet:", diet or "unknown", "| hun:", foodPct and math.floor(foodPct*100) or "?", "% | thirst:", waterPct and math.floor(waterPct*100) or "?", "%")
        if not needFood and not needWater then
            yuri("RegionMission: EatFoodDrinkWater — already full on both, skipping")
            return true
        end
        local function foodFilter(obj)
            local val = obj:GetAttribute("Value")
            if (val or 0) <= 0 then
                yuri("foodFilter: rejecting", obj.Name, "— Value=", tostring(val), "(nil or <=0)")
                return false
            end
            if not diet then return true end
            local name = obj:GetAttribute("FoodDataName") or obj.Name
            local fd = Sonar("Constants").FoodData[name]
            if not fd then
                yuri("foodFilter: rejecting", obj.Name, "— no FoodData entry for name=", name)
                return false
            end
            local pass = diet == "Omnivore" or fd.Diet == diet or fd.Diet == "Omnivore"
            if not pass then
                yuri("foodFilter: rejecting", obj.Name, "— diet mismatch: creature=", diet, "food=", fd.Diet)
            end
            return pass
        end
        local fireFood = needFood
        if needFood and needWater then
            local colocSpot = FindColocatedSpot(diet, regionFolder)
            if colocSpot then
                local distToSpot = (colocSpot - hrp.Position).Magnitude
                if distToSpot > 90 then
                    yuri("RegionMission: EatFoodDrinkWater — co-locating: moving to paired food+water spot (dist=", math.floor(distToSpot), ")")
                    local now = os.clock()
                    if now - Shared.LastTP >= Shared.TPCD then
                        hrp.CFrame = CFrame.new(Vector3.new(colocSpot.X, colocSpot.Y + 15, colocSpot.Z))
                        Shared.LastTP = os.clock()
                        local cc2 = GetCharClass()
                        if cc2 and cc2.Flying then Set(cc2, "Lay", "Laying") end
                        yuri("RegionMission: EatFoodDrinkWater — TP'd to co-located spot")
                    elseif Shared.NavLock then
                        yuri("RegionMission: EatFoodDrinkWater — co-locate nav skipped, NavLock held — falling through to per-resource")
                        colocSpot = nil
                    else
                        FlyTo(colocSpot)
                    end
                    hrp = GetHRP()
                    if not hrp then return false end
                else
                    yuri("RegionMission: EatFoodDrinkWater — already at co-located spot")
                end
            else
                yuri("RegionMission: EatFoodDrinkWater — no co-located spot found, will nav per-resource")
            end
        end
        if fireFood then
            local inRegionFood = IsInRegion(regionFolder)
            do
                local totalTagged, inRegionCount, passFilterCount = 0, 0, 0
                for _, obj in ipairs(CollectionService:GetTagged("Food")) do
                    totalTagged = totalTagged + 1
                    local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                    if p and inRegionFood(p) then
                        inRegionCount = inRegionCount + 1
                        if foodFilter(obj) then
                            passFilterCount = passFilterCount + 1
                        end
                    end
                end
                yuri("EatFoodDrinkWater food scan: totalTagged=", totalTagged, "inRegion=", inRegionCount, "passFilter=", passFilterCount)
            end
            local nearbyFood
            for _, obj in ipairs(CollectionService:GetTagged("Food")) do
                if foodFilter(obj) then
                    local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                    if p and inRegionFood(p) and (p - hrp.Position).Magnitude <= Shared.FoodRange then
                        nearbyFood = obj
                        break
                    end
                end
            end
            local food = nearbyFood
            if food then
                yuri("RegionMission: EatFoodDrinkWater — using nearby food (within FoodRange), skipping scan")
            else
                food = IsTagged("Food", function(obj)
                    if not foodFilter(obj) then return false end
                    local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                    return p and inRegionFood(p)
                end, nil, true)
            end
            if not food then
                yuri("RegionMission: EatFoodDrinkWater — no in-region food found")
                return false
            end
            local foodPos = food:IsA("BasePart") and food.Position or (food.PrimaryPart and food.PrimaryPart.Position)
            local foodDist = foodPos and (foodPos - hrp.Position).Magnitude
            if foodDist and foodDist > Shared.FoodRange then
                yuri("RegionMission: EatFoodDrinkWater — food out of range (", math.floor(foodDist), "), navigating")
                local now = os.clock()
                if now - Shared.LastTP >= Shared.TPCD then
                    hrp.CFrame = CFrame.new(Vector3.new(foodPos.X, foodPos.Y + 15, foodPos.Z))
                    Shared.LastTP = os.clock()
                    local cc2 = GetCharClass()
                    if cc2 and cc2.Flying then Set(cc2, "Lay", "Laying") end
                    yuri("RegionMission: EatFoodDrinkWater — TP'd to food")
                elseif Shared.NavLock then
                    yuri("RegionMission: EatFoodDrinkWater — food nav skipped, NavLock held — returning false")
                    return false
                else
                    FlyTo(foodPos)
                end
                hrp = GetHRP()
                if not hrp then return false end
                food = IsTagged("Food", function(obj)
                    if not foodFilter(obj) then return false end
                    local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                    return p and inRegionFood(p)
                end, nil, true)
                if not food then
                    yuri("RegionMission: EatFoodDrinkWater — food gone after navigation")
                    return false
                end
                local foodPosAfterNav = food:IsA("BasePart") and food.Position or (food.PrimaryPart and food.PrimaryPart.Position)
                local foodDistAfterNav = foodPosAfterNav and (foodPosAfterNav - hrp.Position).Magnitude
                yuri("RegionMission: EatFoodDrinkWater — post-nav food dist=", foodDistAfterNav and math.floor(foodDistAfterNav) or "?", "FoodRange=", Shared.FoodRange)
                if foodDistAfterNav and foodDistAfterNav > Shared.FoodRange then
                    yuri("RegionMission: EatFoodDrinkWater — still out of range after nav, bailing")
                    return false
                end
            end
            if Shared.LastSwitch.action ~= "eat" then
                yuri("RegionMission: EatFoodDrinkWater — switched from", Shared.LastSwitch.action or "none", "-> eat, waiting 1s")
            end
            Shared.LastSwitch.action = "eat"
            local cc = GetCharClass()
            if cc then
                cc = DoConsume(cc, "StartEat", food)
                if not cc then
                    yuri("RegionMission: EatFoodDrinkWater — cc lost during DoConsume for eating")
                    return false
                end
            end
            yuri("RegionMission: ate food (hun:", foodPct and math.floor(foodPct*100) or "?", "%)")
            return true
        else
            local inRegion = IsInRegion(regionFolder)
            local waterObj, waterObjOut, waterObjIn
            local bestOutD, bestInD = math.huge, math.huge
            for _, obj in ipairs(CollectionService:GetTagged("DrinkableWater")) do
                if obj:GetAttribute("FakeWater") or (obj.Parent and obj.Parent:GetAttribute("FakeWater")) then continue end
                local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
                if p and inRegion(p) then
                    local d = (p - hrp.Position).Magnitude
                    if IsOutdoor(p) then
                        if d < bestOutD then bestOutD = d; waterObjOut = obj end
                    else
                        if d < bestInD  then bestInD  = d; waterObjIn  = obj end
                    end
                end
            end
            waterObj = waterObjOut or waterObjIn
            if not waterObj then
                yuri("RegionMission: EatFoodDrinkWater — no in-region water found")
                return false
            end
            local _wp = waterObj:IsA("BasePart") and waterObj or waterObj.PrimaryPart
            local waterPos = _wp and Vector3.new(_wp.Position.X, _wp.Position.Y + _wp.Size.Y / 2, _wp.Position.Z)
            local waterDist = waterPos and (waterPos - hrp.Position).Magnitude
            yuri("RegionMission: EatFoodDrinkWater — drinking water at dist=", waterDist and math.floor(waterDist) or "?")
            if Shared.LastSwitch.action ~= "drink" then
                yuri("RegionMission: EatFoodDrinkWater — switched from", Shared.LastSwitch.action or "none", "-> drink, waiting 1s")
            end
            Shared.LastSwitch.action = "drink"
            local cc = GetCharClass()
            if cc then
                cc = DoConsume(cc, "StartDrink", waterObj)
                if not cc then
                    yuri("RegionMission: EatFoodDrinkWater — cc lost during DoConsume for drinking")
                    return false
                end
            end
            yuri("RegionMission: drank water (thirst:", waterPct and math.floor(waterPct*100) or "?", "%)")
            return true
        end
    elseif taskType == "AttackOrHealCreatureOrNPC" then
        local DamageClient = Sonar("CreatureDamageClient")
        local cc = GetCharClass()
        if not cc then
            yuri("RegionMission: AttackOrHealCreatureOrNPC — no cc, skipping")
            return false
        end
        local hrp = GetHRP()
        if not hrp then return false end
        Shared.CurrentTaskIsland = regionFolder.Name
        local function pickClosest(candidates, getPart)
            local best, bestDist = nil, math.huge
            for _, candidate in ipairs(candidates) do
                local part = getPart(candidate)
                if part and part.Parent then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < bestDist then bestDist = d; best = part end
                end
            end
            return best, bestDist
        end
        local targetPart, targetDist = pickClosest(GetMobRoots(), function(root)
            return root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart")
        end)
        if not targetPart then
            targetPart, targetDist = pickClosest(GetNPCRoots(), function(root)
                return root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart")
            end)
        end
        if not targetPart then
            yuri("RegionMission: no targets found for AttackOrHealCreatureOrNPC — will fly to other islands to load NPCs")
            Shared.CurrentTaskIsland = regionFolder.Name
            local taskIslandModel = workspace.Interactions.Regions:FindFirstChild(regionFolder.Name)
            local taskIslandPivot = taskIslandModel and taskIslandModel:GetPivot().Position
            local otherIslands = {}
            for _, regionModel in ipairs(workspace.Interactions.Regions:GetChildren()) do
                if regionModel.Name ~= regionFolder.Name then
                    local p = regionModel:GetPivot().Position
                    local d = hrp and (p - hrp.Position).Magnitude or math.huge
                    table.insert(otherIslands, { name = regionModel.Name, pos = p, dist = d })
                end
            end
            table.sort(otherIslands, function(a, b) return a.dist < b.dist end)
            local foundTargets = false
            Shared.PauseMission = true
            for _, island in ipairs(otherIslands) do
                if not Toggles.AutoRegionMission.Value then break end
                yuri("RegionMission: NPC load — teleporting to", island.name, "dist=", math.floor(island.dist))
                task.wait()
                hrp.CFrame = CFrame.new(Vector3.new(island.pos.X, island.pos.Y + 15, island.pos.Z))
                task.wait(3)
                local checkMobs = GetMobRoots()
                local checkNPCs = GetNPCRoots()
                local found = false
                for _, root in ipairs(checkMobs) do
                    local part = root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart")
                    if part and part.Parent then found = true break end
                end
                if not found then
                    for _, root in ipairs(checkNPCs) do
                        local part = root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart")
                        if part and part.Parent then found = true break end
                    end
                end
                if found then
                    yuri("RegionMission: NPC load — targets appeared after visiting", island.name, "— returning to", Shared.CurrentTaskIsland)
                    foundTargets = true
                    break
                end
                yuri("RegionMission: NPC load — still no targets after visiting", island.name)
            end
            if taskIslandPivot then
                yuri("RegionMission: NPC load — returning to task island", Shared.CurrentTaskIsland)
                hrp = GetHRP()
                if hrp then
                    task.wait()
                    hrp.CFrame = CFrame.new(Vector3.new(taskIslandPivot.X, taskIslandPivot.Y + 15, taskIslandPivot.Z))
                end
            end
            Shared.PauseMission = false
            if not foundTargets then
                yuri("RegionMission: NPC load fly — no targets loaded after visiting all islands, giving up this tick")
                return false
            end
            hrp = GetHRP()
            if not hrp then return false end
            targetPart, targetDist = pickClosest(GetMobRoots(), function(root)
                return root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart")
            end)
            if not targetPart then
                targetPart, targetDist = pickClosest(GetNPCRoots(), function(root)
                    return root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart")
                end)
            end
            if not targetPart then
                yuri("RegionMission: NPC load fly — still no target after returning, giving up")
                return false
            end
        end
        yuri("RegionMission: AttackOrHeal — target=", targetPart:GetFullName(), "dist=", math.floor(targetDist))
        local entity = DamageClient.GetEntityFromHit(targetPart, targetPart)
        if not entity then
            yuri("RegionMission: AttackOrHeal — GetEntityFromHit returned nil")
            return false
        end
        local hit, hitSound = DamageClient.RegisterHits({ entity }, "Breath")
        yuri("RegionMission: fired", "— hit=", tostring(hit), "hitSound=", tostring(hitSound), "dist=", math.floor(targetDist))
        return hit and true or false
    elseif taskType == "Sniff" then
        pcall(function() Remotes.SetMission:FireServer(1) end)
        yuri("RegionMission: fired Sniff")
        return true
    elseif taskType == "ConcealScent" then
        local hrp = GetHRP()
        if not hrp then return false end
        local mud
        for _, obj in ipairs(CollectionService:GetTagged("Mud")) do
            local p = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)
            if p and (p - hrp.Position).Magnitude <= Shared.ArriveDist then
                mud = obj
                break
            end
        end
        if not mud then
            mud = IsTagged("Mud", nil, nil, true)
        end
        if not mud then
            yuri("RegionMission: no mud found for ConcealScent")
            return false
        end
        local dist = (mud.Position - hrp.Position).Magnitude
        if dist > Shared.ArriveDist then
            yuri("RegionMission: ConcealScent — mud out of range (", math.floor(dist), "), navigating")
            NavTo(taskType, regionFolder, false)
            mud = IsTagged("Mud", nil, nil, true)
            if not mud then
                yuri("RegionMission: ConcealScent — mud gone after navigation")
                return false
            end
        end
        pcall(function() Remotes.Mud:FireServer(mud) end)
        yuri("RegionMission: fired Mud for ConcealScent")
        return true
    elseif taskType == "DistanceTravelled" then
        local hrp = GetHRP()
        if not hrp then return false end
        local taskChild = regionFolder:FindFirstChild("DistanceTravelled")
        local amountVal = taskChild and taskChild:FindFirstChild("Amount")
        local targetVal = taskChild and taskChild:FindFirstChild("TargetAmount")
        local remaining = (targetVal and amountVal)
            and math.max(0, targetVal.Value - amountVal.Value)
            or 500
        yuri("RegionMission: DistanceTravelled — remaining=", remaining, "| amount=", amountVal and amountVal.Value or "?", "/", targetVal and targetVal.Value or "?")
        local origin = hrp.Position
        local away = Vector3.new(origin.X + 500, origin.Y + 500, origin.Z)
        local function waitForAmountChange(timeout)
            local before = amountVal and amountVal.Value
            local t = os.clock()
            while os.clock() - t < timeout do
                if taskChild and taskChild.Value then return end
                if amountVal and amountVal.Value >= (before + 100) then return end
                task.wait(0.2)
            end
        end
        local roundTrips = math.ceil(remaining / 1000)
        for i = 1, roundTrips do
            if taskChild and taskChild.Value then
                yuri("RegionMission: DistanceTravelled — task completed mid-loop, stopping")
                break
            end
            hrp = GetHRP()
            if not hrp then break end
            yuri("RegionMission: DistanceTravelled — trip", i, "/", roundTrips, "— teleporting away")
            hrp.CFrame = CFrame.new(away)
            waitForAmountChange(5)
            if taskChild and taskChild.Value then
                yuri("RegionMission: DistanceTravelled — task completed, stopping")
                break
            end
            hrp = GetHRP()
            if not hrp then break end
            yuri("RegionMission: DistanceTravelled — trip", i, "/", roundTrips, "— teleporting back")
            hrp.CFrame = CFrame.new(origin)
            waitForAmountChange(10)
        end
        hrp = GetHRP()
        yuri("RegionMission: DistanceTravelled — done, pos=", hrp and hrp.Position or "?")
        return true
    else
        yuri("RegionMission: unknown task type:", taskType)
        return false
    end
end
local function updateDeathPtLabel(slot)
    local ok, pts = pcall(function() return CreatureInfoService.GetTotalDeathPoints(slot) end)
    pts = ok and pts or nil
    Shared.CurDP = pts
    if pts then
        deathPtLabel:SetText(string.format("<b>Death Points:</b> %s", tostring(pts)))
    else
        deathPtLabel:SetText("<b>Death Points:</b> <font color='#888888'>not available</font>")
    end
end
task.spawn(function()
    local hookedSlot = nil
    local deathStatConns = {}
    while true do
        local cc   = GetCharClass()
        local slot = cc and cc.Slot
        if slot ~= hookedSlot then
            for _, c in ipairs(deathStatConns) do c:Disconnect() end
            deathStatConns = {}
            hookedSlot = slot
            if slot then
                local ds = slot:FindFirstChild("DeathStats")
                if ds then
                    local function hookChild(child)
                        deathStatConns[#deathStatConns + 1] = child.Changed:Connect(function()
                            updateDeathPtLabel(slot)
                        end)
                    end
                    for _, child in ipairs(ds:GetChildren()) do hookChild(child) end
                    deathStatConns[#deathStatConns + 1] = ds.ChildAdded:Connect(hookChild)
                end
                updateDeathPtLabel(slot)
            else
                Shared.CurDP = nil
                deathPtLabel:SetText("<b>Death Points:</b> <font color='#888888'>not available</font>")
            end
        end
        task.wait(1)
    end
end)
Toggles.AutoRegionMission:OnChanged(function()
    Thread("Farm.RegionMission", function()
        while Toggles.AutoRegionMission.Value do
            task.wait(1)
            local rmf = getRegionMissionsFolder()
            if not rmf then
                yuri("RegionMission: PlayerData not ready, retrying...")
                task.wait(3)
                continue
            end
            if Shared.PauseMission then
                yuri("RegionMission: paused — waiting for mobs to load...")
                repeat task.wait(1) until not Shared.PauseMission or not Toggles.AutoRegionMission.Value
                if not Toggles.AutoRegionMission.Value then break end
                yuri("RegionMission: resumed — mobs found")
            end
            local hrp = GetHRP()
            local currentRegion = Sonar("MinimapTracker").GetCurrentRegion()
            yuri("RegionMission: loop tick — currentRegion:", currentRegion, "| hrp:", hrp and hrp.Position or "nil")
            local regionFolder = nil
            local currentRf = rmf:FindFirstChild(currentRegion)
            if currentRf and currentRf:IsA("IntValue") and currentRf.Value == -1
               and workspace.Interactions.Regions:FindFirstChild(currentRegion) then
                if Options.RegionBlacklist.Value[currentRegion] then
                    yuri("RegionMission: current region", currentRegion, "is blacklisted — skipping")
                elseif Shared.TempRegionBL[currentRegion] and os.clock() < Shared.TempRegionBL[currentRegion] then
                    local remaining = math.ceil(Shared.TempRegionBL[currentRegion] - os.clock())
                    yuri("RegionMission: current region", currentRegion, "is temp-blacklisted for", remaining, "s — skipping")
                else
                    local tasks = GetIncomplete(currentRf)
                    yuri("RegionMission: current region", currentRegion, "— incomplete:", #tasks)
                    if #tasks > 0 then
                        regionFolder = currentRf
                        yuri("RegionMission: staying in current region:", currentRegion)
                    end
                end
            else
                yuri("RegionMission: current region", currentRegion, "has no active mission folder or workspace model — scanning others")
            end
            if not regionFolder then
                local bestDist = math.huge
                local scanned = 0
                for _, rf in ipairs(rmf:GetChildren()) do
                    scanned = scanned + 1
                    if rf:IsA("IntValue") and rf.Value == -1 then
                        local regionModel = workspace.Interactions.Regions:FindFirstChild(rf.Name)
                        if not regionModel then
                            yuri("RegionMission: skipping", rf.Name, "— no workspace region model")
                        elseif Options.RegionBlacklist.Value[rf.Name] then
                            yuri("RegionMission: skipping", rf.Name, "— blacklisted region")
                        elseif Shared.TempRegionBL[rf.Name] and os.clock() < Shared.TempRegionBL[rf.Name] then
                            local remaining = math.ceil(Shared.TempRegionBL[rf.Name] - os.clock())
                            yuri("RegionMission: skipping", rf.Name, "— temp-blacklisted for", remaining, "s")
                        else
                            local tasks = GetIncomplete(rf)
                            local dist = hrp and (regionModel:GetPivot().Position - hrp.Position).Magnitude or 0
                            yuri("RegionMission: region", rf.Name, "— incomplete:", #tasks, "| dist:", dist)
                            if #tasks > 0 and dist < bestDist then
                                bestDist = dist
                                regionFolder = rf
                            end
                        end
                    end
                end
                yuri("RegionMission: scanned", scanned, "children — selected region:", regionFolder and regionFolder.Name or "none")
            end
            if not regionFolder then
                yuri("RegionMission: all tasks done in all active regions — waiting")
                repeat task.wait(5) until not Toggles.AutoRegionMission.Value or getRegionMissionsFolder()
                if not Toggles.AutoRegionMission.Value then break end
                continue
            end
            yuri("RegionMission: selected:", regionFolder.Name, "| currentRegion:", currentRegion, "| match:", currentRegion == regionFolder.Name)
            if regionFolder.Name ~= currentRegion then
                yuri("RegionMission: need to move — current:", currentRegion, "target:", regionFolder.Name)
                local dominant = GetIncomplete(regionFolder)
                dominant = dominant[1] and dominant[1].taskType or nil
                yuri("RegionMission: dominant task for", regionFolder.Name, ":", dominant)
                local moved = NavTo(dominant or "EatFoodDrinkWater", regionFolder, false)
                if moved then
                    yuri("RegionMission: NavTo done — waiting 3s for region update")
                    task.wait(3)
                else
                    yuri("RegionMission: NavTo blocked — waiting 5s")
                    task.wait(5)
                end
                yuri("RegionMission: region after nav:", Sonar("MinimapTracker").GetCurrentRegion())
                continue 
            end
            local incomplete = GetIncomplete(regionFolder)
            local spawnCount = math.min(#incomplete, Shared.ConTask)
            Shared.TemBL = {}
            yuri("RegionMission: IN region", regionFolder.Name, "— spawning", spawnCount, "of", #incomplete, "task threads (Shared.ConTask=" .. Shared.ConTask .. ")")
            local assignedTasks = {}
            local function spawnSlot(slotIndex, task_info)
                local taskChild = task_info.child
                local taskType  = task_info.taskType
                assignedTasks[taskChild] = true
                yuri("RegionMission: spawning thread for task:", taskType, "| current progress:", taskChild:FindFirstChild("Amount") and taskChild.Amount.Value or "?", "/", taskChild:FindFirstChild("TargetAmount") and taskChild.TargetAmount.Value or "?")
                Thread("Farm.RegionTask_" .. slotIndex, function()
                    local FailsCount = 0
                    while Toggles.AutoRegionMission.Value and not taskChild.Value
                        and Sonar("MinimapTracker").GetCurrentRegion() == regionFolder.Name do
                        yuri("RegionMission: firing task:", taskType)
                        local ok, result = pcall(DoMission, taskType, regionFolder)
                        if not ok then
                            yuri("RegionMission: DoMission ERROR for", taskType, ":", tostring(result))
                            task.wait(1)
                        else
                            local fired = result
                            yuri("RegionMission: task", taskType, "fired:", fired)
                            local skipWait = false
                            if fired then
                                FailsCount = 0
                            else
                                FailsCount = FailsCount + 1
                                if FailsCount >= 3 then
                                    yuri("RegionMission: task", taskType, "failed", FailsCount, "times — forcing NavTo retry")
                                    FailsCount = 0
                                    if taskType ~= "Sniff" and os.clock() - Shared.LastTP >= Shared.TPCD then
                                        yuri("RegionMission: 3 fails, TP off cooldown — forcing NavTo retry")
                                        NavTo(taskType, regionFolder, false)
                                        local ok2, fired2 = pcall(DoMission, taskType, regionFolder)
                                        if not ok2 then
                                            yuri("RegionMission: DoMission ERROR on retry for", taskType, ":", tostring(fired2))
                                        else
                                            yuri("RegionMission: forced TP retry fired:", fired2)
                                        end
                                        skipWait = true
                                    end
                                end
                            end
                            if not skipWait then task.wait(1) end
                        end
                    end
                    yuri("RegionMission: task done:", taskType)
                end, true)
            end
            for i = 1, spawnCount do
                spawnSlot(i, incomplete[i])
            end
            yuri("RegionMission: waiting for all tasks to complete...")
            local regionDeadline = os.clock() + 240
            repeat
                task.wait(1)
                if not Toggles.AutoRegionMission.Value then break end
                if Sonar("MinimapTracker").GetCurrentRegion() ~= regionFolder.Name then break end
                if os.clock() >= regionDeadline then break end
                local liveIncomplete = GetIncomplete(regionFolder)
                if #liveIncomplete == 0 then break end
                for slotIndex = 1, spawnCount do
                    local t = Flags["Farm"] and Flags["Farm"]["RegionTask_" .. slotIndex]
                    if not t or coroutine.status(t) == "dead" then
                        local found = nil
                        for _, task_info in ipairs(liveIncomplete) do
                            if not assignedTasks[task_info.child] and not Shared.TemBL[task_info.taskType] then
                                found = task_info
                                break
                            end
                        end
                        if found then
                            yuri("RegionMission: slot", slotIndex, "is free — refilling with", found.taskType)
                            spawnSlot(slotIndex, found)
                        end
                    end
                end
                local allDead = true
                for slotIndex = 1, spawnCount do
                    local t = Flags["Farm"] and Flags["Farm"]["RegionTask_" .. slotIndex]
                    if t and coroutine.status(t) ~= "dead" then
                        allDead = false
                        break
                    end
                end
                if allDead then
                    local anyUnassigned = false
                    local remaining = GetIncomplete(regionFolder)
                    for _, task_info in ipairs(remaining) do
                        if not assignedTasks[task_info.child] and not Shared.TemBL[task_info.taskType] then
                            anyUnassigned = true
                            break
                        end
                    end
                    if not anyUnassigned then break end
                end
            until false
            for i = 1, spawnCount do
                Thread("Farm.RegionTask_" .. i, nil, false)
            end
            if Shared.NavLock then
                yuri("RegionMission: forcing NavLock release after thread cancel")
                Shared.NavLock = false
            end
            if Shared.PauseMission then
                yuri("RegionMission: forcing PauseMission release after thread cancel")
                Shared.PauseMission = false
            end
            if os.clock() >= regionDeadline and #GetIncomplete(regionFolder) > 0 then
                Shared.TempRegionBL[regionFolder.Name] = os.clock() + 240
                yuri("RegionMission: region", regionFolder.Name, "not cleared in 240s — temp-blacklisted for 240s")
            end
            if next(Shared.TemBL) then
                local skippedList = {}
                for t in pairs(Shared.TemBL) do skippedList[#skippedList+1] = t end
                yuri("RegionMission: skipped tasks (will retry):", table.concat(skippedList, ", "))
            end
            yuri("RegionMission: all tasks in", regionFolder.Name, "done or toggle off")
        end
    end, Toggles.AutoRegionMission.Value)
end)
local ESPFolder = Instance.new("Folder")
ESPFolder.Parent = CoreGui
local ESPConnections = {}
local AllHighlights = {}
for _, cfg in ipairs(TargetConfig) do AllHighlights[cfg.Id] = {} end
local function getPartForAdornee(target)
    if target:IsA("BasePart") then
        return target
    elseif target:IsA("Model") then
        return target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function makeLabel(text, sizeY, posY, bold, textColor)
    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, 0, sizeY, 0)
    lbl.Position               = UDim2.new(0, 0, posY, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = text
    lbl.TextColor3             = textColor or Color3.new(1, 1, 1)
    lbl.TextStrokeColor3       = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextScaled             = true
    lbl.Font                   = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    lbl.TextXAlignment         = Enum.TextXAlignment.Center
    return lbl
end
local function makeBillboard(target, name, textColor)
    local part = getPartForAdornee(target)
    if not part then return nil end
    local bb = Instance.new("BillboardGui")
    bb.Name         = GenUUID()
    bb.Adornee      = part
    bb.Size         = UDim2.new(0, 70, 0, 20)
    bb.StudsOffset  = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop  = true
    bb.ResetOnSpawn = false
    bb.Parent       = ESPFolder
    local nameLbl = makeLabel(name, 0.55, 0, true, textColor)
    nameLbl.Name   = GenUUID()
    nameLbl.Parent = bb
    local distLbl = makeLabel("", 0.45, 0.55, false, textColor)
    local distLblName = GenUUID()
    distLbl.Name   = distLblName
    distLbl.Parent = bb
    bb:SetAttribute("DistLabel", distLblName)
    return bb
end
local function makeHighlight(target, fillColor, outlineColor, labelName, textColor)
    local h = Instance.new("Highlight")
    h.Adornee             = target
    h.FillColor           = fillColor
    h.OutlineColor        = outlineColor
    h.FillTransparency    = 0.4
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent              = ESPFolder
    local bb = makeBillboard(target, labelName or (target.Name ~= "" and target.Name or "?"), textColor)
    return { highlight = h, billboard = bb }
end
local function removeHighlight(tbl, key)
    if tbl[key] then
        if tbl[key].highlight then tbl[key].highlight:Destroy() end
        if tbl[key].billboard then tbl[key].billboard:Destroy() end
        tbl[key] = nil
    end
end
local function refreshESP(cfg)
    local tbl = AllHighlights[cfg.Id]
    for k in pairs(tbl) do removeHighlight(tbl, k) end
    if not Toggles[cfg.Id].Value then return end
    local fillColor    = Options[cfg.Id .. "Color"].Value
    local outlineColor = Options[cfg.Id .. "Outline"].Value
    local items
    if cfg.Tag then
        items = CollectionService:GetTagged(cfg.Tag)
    elseif cfg.GetItems then
        items = cfg.GetItems()
    elseif cfg.Target then
        local folder = cfg.Target()
        items = folder and folder:GetChildren() or {}
    else
        items = {}
    end
    for _, item in ipairs(items) do
        if not cfg.filter or cfg.filter(item) then
            tbl[item] = makeHighlight(item, fillColor, outlineColor, cfg.Display, fillColor)
        end
    end
end
local ESPSubConns = {}
local function watchESP(cfg)
    local addKey    = cfg.Id .. "Added"
    local remKey    = cfg.Id .. "Removed"
    local subKey    = cfg.Id .. "Sub"
    if ESPConnections[addKey] then ESPConnections[addKey]:Disconnect(); ESPConnections[addKey] = nil end
    if ESPConnections[remKey] then ESPConnections[remKey]:Disconnect(); ESPConnections[remKey] = nil end
    if ESPSubConns[subKey] then
        for _, conn in pairs(ESPSubConns[subKey]) do conn:Disconnect() end
        ESPSubConns[subKey] = nil
    end
    if not Toggles[cfg.Id].Value then return end
    local tbl          = AllHighlights[cfg.Id]
    local fillColor    = function() return Options[cfg.Id .. "Color"].Value end
    local outlineColor = function() return Options[cfg.Id .. "Outline"].Value end
    local function onAdded(item)
        if not Toggles[cfg.Id].Value then return end
        if cfg.filter and not cfg.filter(item) then return end
        tbl[item] = makeHighlight(item, fillColor(), outlineColor(), cfg.Display, fillColor())
    end
    local function onRemoved(item)
        removeHighlight(tbl, item)
    end
    if cfg.Tag then
        ESPConnections[addKey] = CollectionService:GetInstanceAddedSignal(cfg.Tag):Connect(onAdded)
        ESPConnections[remKey] = CollectionService:GetInstanceRemovedSignal(cfg.Tag):Connect(onRemoved)
    elseif cfg.GetItems then
        local root = cfg.GetRoot and cfg.GetRoot()
        if not root then return end
        local subConns = {}
        ESPSubConns[subKey] = subConns
        local function watchSubFolder(shrineFolder)
            if subConns[shrineFolder] then return end
            subConns[shrineFolder] = shrineFolder.ChildAdded:Connect(function(child)
                if child:IsA("MeshPart") then onAdded(child) end
            end)
        end
        local function onSubFolderRemoved(shrineFolder)
            if subConns[shrineFolder] then
                subConns[shrineFolder]:Disconnect()
                subConns[shrineFolder] = nil
            end
            for item in pairs(tbl) do
                if item.Parent == shrineFolder then onRemoved(item) end
            end
        end
        for _, child in ipairs(root:GetChildren()) do
            watchSubFolder(child)
        end
        ESPConnections[addKey] = root.ChildAdded:Connect(function(child)
            watchSubFolder(child)
        end)
        ESPConnections[remKey] = root.ChildRemoved:Connect(function(child)
            onSubFolderRemoved(child)
        end)
    elseif cfg.Target then
        local folder = cfg.Target()
        if not folder then return end
        ESPConnections[addKey] = folder.ChildAdded:Connect(onAdded)
        ESPConnections[remKey] = folder.ChildRemoved:Connect(onRemoved)
    end
end
for _, cfg in ipairs(TargetConfig) do
    Toggles[cfg.Id]:OnChanged(function()
        refreshESP(cfg)
        watchESP(cfg)
    end)
    Options[cfg.Id .. "Color"]:OnChanged(function()
        local tbl = AllHighlights[cfg.Id]
        local v   = Options[cfg.Id .. "Color"].Value
        for _, e in pairs(tbl) do
            if e.highlight then e.highlight.FillColor = v end
            if e.billboard then
                for _, lbl in ipairs(e.billboard:GetChildren()) do
                    if lbl:IsA("TextLabel") then lbl.TextColor3 = v end
                end
            end
        end
    end)
    Options[cfg.Id .. "Outline"]:OnChanged(function()
        local tbl = AllHighlights[cfg.Id]
        local v   = Options[cfg.Id .. "Outline"].Value
        for _, e in pairs(tbl) do if e.highlight then e.highlight.OutlineColor = v end end
    end)
end
Connections.espDistUpdate = RunService.Heartbeat:Connect(function()
    local hrp = GetHRP()
    if not hrp then return end
    local origin = hrp.Position
    for _, tbl in pairs(AllHighlights) do
        for _, entry in pairs(tbl) do
            if entry.billboard and entry.billboard.Adornee then
                local dist = math.floor((entry.billboard.Adornee.Position - origin).Magnitude)
                local lbl  = entry.billboard and entry.billboard:FindFirstChild(entry.billboard:GetAttribute("DistLabel"))
                if lbl then lbl.Text = dist .. " studs" end
            end
        end
    end
end)
Connections.shoomESPRefresh = RunService.Heartbeat:Connect(function()
    if not Toggles.ESPShooms.Value then return end
    local tbl = AllHighlights["ESPShooms"]
    for pile in pairs(tbl) do
        if not pile or not pile.Parent then
            removeHighlight(tbl, pile)
        else
            local region = pile:GetAttribute("Region")
            local id     = pile:GetAttribute("Id")
            if region and id then
                local check = ShoomPilesService.CanCollect(Plr, region, id)
                if type(check) == "table" and check[1] == "ShoomCollected" then
                    removeHighlight(tbl, pile)
                end
            end
        end
    end
end)
Connections.playerMovement = RunService.Heartbeat:Connect(function()
    if not GetLPData() then return end
    if not Shared.OgS  then Shared.OgS  = GetLPData("s")  end
    if not Shared.OgFS then Shared.OgFS = GetLPData("fs") end
    if Toggles.WS.Value then
        GetLPData("s", Options.WSValue.Value)
    else
        GetLPData("s", Shared.OgS)
    end
    if Toggles.FS.Value then
        GetLPData("fs", Options.FSValue.Value)
    else
        GetLPData("fs", Shared.OgFS)
    end
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/CoS")
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
    Library:Notify("LOAD ERROR: " .. tostring(err), 6)
    yuri("CoS Script load error:", err)
end
