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
local Teams = Services.Teams
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
-- ============================================================
-- Remotes: this game routes all remote calls through a single
-- local lookup table (friendly-name keys -> live Remote instances)
-- because the actual Instance names under ReplicatedStorage.Remotes
-- are obfuscated garbage. Verified from the deobfuscated
-- PlayerScriptsLoader source: `local v_u_65 = { ["Attack"] = v64.Attack,
-- ..., ["Build"] = v64.Build, ["Buy"] = v64.Buy, ... }`, later aliased
-- as `v_u_691 = v_u_65` and used everywhere as v_u_691.Build,
-- v_u_691.Buy, v_u_691.Delete, etc. We grab that same live table via
-- getgc so we don't have to depend on the obfuscated instance names.
-- ============================================================
local function FindRemotesTable()
    local found = nil
    pcall(function()
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "table" then
                local buy = rawget(obj, "Buy")
                local build = rawget(obj, "Build")
                if typeof(buy) == "Instance" and buy:IsA("RemoteFunction")
                    and typeof(build) == "Instance" and build:IsA("RemoteFunction") then
                    found = obj
                    break
                end
            end
        end
    end)
    return found
end
local Remotes = FindRemotesTable()
local function GetRemote()
    if Remotes and Remotes.Build and Remotes.Buy then return true end
    Remotes = FindRemotesTable()
    return Remotes ~= nil
end
if not Remotes then
    notyuri("[Remotes] Not found on first attempt, will retry when Build tab is used.")
end
local function GetMyPlot()
    if not Plr.Team then return nil end
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return nil end
    return Plots:FindFirstChild(Plr.Team.Name)
end
local function GetAllPlots()
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return {} end
    local myPlot = GetMyPlot()
    local out = {}
    for _, plot in ipairs(Plots:GetChildren()) do
        if plot:IsA("Folder") then
            local players = {}
            pcall(function()
                local team = Teams:FindFirstChild(plot.Name)
                if team then
                    for _, p in ipairs(team:GetPlayers()) do
                        table.insert(players, p.Name)
                    end
                end
            end)
            table.insert(out, {
                plot = plot,
                teamName = plot.Name,
                players = players,
                isMine = (plot == myPlot),
            })
        end
    end
    return out
end
local function GetPlacedBlocksFromPlot(plot, folderName, ownerFilter)
    if not plot then return {} end
    local placedFolder = plot:FindFirstChild("Placed Blocks")
    if not placedFolder then return {} end
    local out = {}
    for _, obj in pairs(placedFolder:GetDescendants()) do
        if obj:GetAttribute("Owner") ~= nil then
            if folderName == nil or (obj.Parent and obj.Parent.Name == folderName) then
                if ownerFilter == nil or obj:GetAttribute("Owner") == ownerFilter then
                    table.insert(out, obj)
                end
            end
        end
    end
    return out
end
local function Vec3ToTable(v)
    return { v.X, v.Y, v.Z }
end
local function TableToVec3(t)
    return Vector3.new(t[1], t[2], t[3])
end
local function CFrameToTable(cf)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    return { x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 }
end
local function TableToCFrame(t)
    if type(t) ~= "table" or #t < 12 then return CFrame.new() end
    return CFrame.new(t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
end
local Folder = "Yuri/ToyDefense/Builds"
local function GetPlotCFrameOf(plot)
    if not plot then return nil end
    local map = plot:FindFirstChild("Map")
    if not map or not map.PrimaryPart then return nil end
    return map.PrimaryPart.CFrame
end
local function Cerial(plot, ownerFilter)
    local blocks = GetPlacedBlocksFromPlot(plot, nil, ownerFilter)
    if #blocks == 0 then return nil end
    local plotCF = GetPlotCFrameOf(plot)
    if not plotCF then return nil end
    local relative = plotCF:Inverse()
    local data = { version = 1, count = 0, blocks = {} }
    for _, block in ipairs(blocks) do
        local pp = block.PrimaryPart or block:FindFirstChildWhichIsA("BasePart")
        if pp then
            local relCF = relative * pp.CFrame
            table.insert(data.blocks, {
                Name = block.Name,
                CF = CFrameToTable(relCF),
                Shape = block:GetAttribute("Type") or "Block",
                Skin = block:GetAttribute("Skin") or "Default",
            })
        end
    end
    data.count = #data.blocks
    return data
end
local function ToFile(plot, ownerFilter)
    local data = Cerial(plot, ownerFilter)
    if not data then return nil end
    local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
    if not ok then return nil end
    return json
end
local function LoadJson(json)
    if not json or json == "" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(json) end)
    if not ok or type(data) ~= "table" or type(data.blocks) ~= "table" then return nil end
    return data
end
local function ListSource()
    local files = {}
    if not Support.FileIO or not isfolder then return files end
    pcall(function()
        if not isfolder(Folder) then return end
        for _, name in ipairs(listfiles(Folder)) do
            if name:sub(-5) == ".json" then
                local short = name:match("([^/\\]+)%.json$")
                if short then table.insert(files, short) end
            end
        end
    end)
    table.sort(files)
    return files
end
local function GetTempCount(blockName)
    local alphaName = blockName:gsub("%s+", "")
    return Plr:GetAttribute("Temporary" .. alphaName) or 0
end
local function DoBuild(entry, plotCF)
    if not GetRemote() then return false end
    local shapeArg = (entry.Shape and entry.Shape ~= "Block") and entry.Shape or false
    local skinArg = (entry.Skin and entry.Skin ~= "Default") and entry.Skin or false
    local relCF = TableToCFrame(entry.CF)
    local worldCF = plotCF and (plotCF * relCF) or relCF
    local position = worldCF.Position
    local rx, ry, rz = worldCF:ToOrientation()
    local orientation = Vector3.new(math.deg(rx), math.deg(ry), math.deg(rz))
    local ok, result = pcall(function()
        return Remotes.Build:InvokeServer({ entry.Name }, { position }, { orientation }, { shapeArg }, { skinArg })
    end)
    return ok and result ~= nil and result[1] ~= nil, worldCF
end
local function PositionKey(v)
    return string.format("%.1f,%.1f,%.1f", v.X, v.Y, v.Z)
end
local function GetMyPos()
    local myPlot = GetMyPlot()
    local plotCF = GetPlotCFrameOf(myPlot)
    local existing = {}
    if not plotCF then return existing end
    local relative = plotCF:Inverse()
    for _, block in ipairs(GetPlacedBlocksFromPlot(myPlot, nil, Plr.UserId)) do
        local pp = block.PrimaryPart or block:FindFirstChildWhichIsA("BasePart")
        if pp then
            local relCF = relative * pp.CFrame
            existing[PositionKey(relCF.Position)] = true
        end
    end
    return existing
end
local _buildSourcesLookup = {}
local RefreshSource
local function SaveBuild(saveName, plot, ownerFilter)
    if not saveName or saveName == "" then
        Library:Notify("Enter a file name first.", 3)
        return
    end
    if not Support.FileIO then
        Library:Notify("File IO not supported.", 4)
        return
    end
    local json = ToFile(plot, ownerFilter)
    if not json then
        Library:Notify("No placed blocks to save.", 4)
        return
    end
    local path = Folder .. "/" .. saveName .. ".json"
    pcall(function()
        if makefolder then pcall(makefolder, Folder) end
        writefile(path, json)
    end)
    Library:Notify("Saved: " .. saveName, 5)
    notyuri("[CopyBuild] saved to", path)
    if RefreshSource then RefreshSource() end
end
local function LoadFile(saveName)
    if not saveName or saveName == "" then return nil end
    if not Support.FileIO then return nil end
    local path = Folder .. "/" .. saveName .. ".json"
    if not isfile(path) then return nil end
    local ok, json = pcall(readfile, path)
    if not ok or not json then return nil end
    return LoadJson(json)
end
RefreshSource = function()
    if not Options.SelectedFile then return end
    local plots = GetAllPlots()
    local files = ListSource()
    local values = {}
    _buildSourcesLookup = {}
    for _, p in ipairs(plots) do
        local label
        if #p.players > 0 then
            label = p.teamName .. " (" .. table.concat(p.players, ", ") .. ")"
        else
            label = p.teamName .. " (Empty)"
        end
        if p.isMine then
            label = "[My Plot] " .. label
        else
            label = "[Plot] " .. label
        end
        table.insert(values, label)
        _buildSourcesLookup[label] = { type = "plot", plot = p.plot, isMine = p.isMine }
    end
    for _, fname in ipairs(files) do
        local label = "[File] " .. fname
        table.insert(values, label)
        _buildSourcesLookup[label] = { type = "file", name = fname }
    end
    Options.SelectedFile:SetValues(values)
end
local function LoadSource()
    local sel = Options.SelectedFile and Options.SelectedFile.Value
    if not sel or sel == "" then
        Library:Notify("Select a plot or file first.", 3)
        return nil
    end
    local entry = _buildSourcesLookup[sel]
    if not entry then
        Library:Notify("Unknown source: " .. tostring(sel), 4)
        return nil
    end
    if entry.type == "plot" then
        local ownerFilter = entry.isMine and Plr.UserId or nil
        local data = Cerial(entry.plot, ownerFilter)
        if not data then
            Library:Notify("No placed blocks.", 4)
            return nil
        end
        return data
    elseif entry.type == "file" then
        local data = LoadFile(entry.name)
        if not data then
            Library:Notify("Failed to load: " .. tostring(entry.name), 4)
        end
        return data
    end
    return nil
end
local function GetBlock(data)
    local reqs = {}
    for _, entry in ipairs(data.blocks) do
        if entry.Name then
            reqs[entry.Name] = (reqs[entry.Name] or 0) + 1
        end
    end
    return reqs
end
local function MissingBlock(reqs)
    local missing = {}
    local parts = {}
    for blockName, need in pairs(reqs) do
        local have = GetTempCount(blockName)
        if have < need then
            local short = need - have
            missing[blockName] = short
            table.insert(parts, blockName .. " (x" .. short .. ")")
        end
    end
    table.sort(parts)
    local display
    if #parts == 0 then
        display = "Enough"
    else
        display = "Missing: " .. table.concat(parts, ", ")
    end
    return missing, display
end
local MatLabel = nil
local function RefreshMat()
    if not MatLabel then return end
    if not GetRemote() then
        MatLabel:SetText("Remotes not found yet.")
        return
    end
    local data = LoadSource()
    if not data then
        MatLabel:SetText("No build selected.")
        return
    end
    local _, display = MissingBlock(GetBlock(data))
    MatLabel:SetText(display)
end
local function DoLoad()
    if not GetRemote() then
        Library:Notify("Could not find remote.", 5)
        return
    end
    local data = LoadSource()
    if not data then return end
    local myPlot = GetMyPlot()
    if not myPlot then
        Library:Notify("No Plot.", 4)
        return
    end
    local plotCF = GetPlotCFrameOf(myPlot)
    if not plotCF then
        Library:Notify("Could not find plot origin.", 4)
        return
    end
    local existing = GetMyPos()
    local placed, skipped, alreadyThere, failed = 0, 0, 0, 0
    notyuri("[LoadBuild] starting, blocks:", #data.blocks)
    for idx, entry in ipairs(data.blocks) do
        if not Toggles.LoadBuild.Value then
            notyuri("[LoadBuild] toggle off, stopping at block", idx)
            break
        end
        local relCF = TableToCFrame(entry.CF)
        local key = PositionKey(relCF.Position)
        if existing[key] then
            alreadyThere = alreadyThere + 1
        else
            local have = GetTempCount(entry.Name)
            if have <= 0 then
                notyuri("[LoadBuild] skipping", entry.Name, "block", idx, "- no Temporary stock")
                skipped = skipped + 1
            else
                local ok, worldCF = DoBuild(entry, plotCF)
                if ok then
                    placed = placed + 1
                    existing[key] = true
                    notyuri("[LoadBuild] placed", entry.Name, "at", tostring(worldCF.Position))
                else
                    failed = failed + 1
                    notyuri("[LoadBuild] failed to place", entry.Name, "at", tostring(worldCF.Position))
                end
                task.wait(0.05)
            end
        end
    end
    notyuri("[LoadBuild] done. placed:", placed, "already there:", alreadyThere, "skipped:", skipped, "failed:", failed)
    Toggles.LoadBuild:SetValue(false)
    Library:Notify(("Loaded: %d placed, %d skipped, %d failed."):format(placed, skipped, failed), 3)
    RefreshMat()
end
local Modules = {
}
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
    Build = Window:AddTab("Build"),
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
TB_Tabs.Autofarm2.T1:AddInput("WaveSelected", {
    Text = "Wave Number",
    Default = "1",
    Placeholder = "1/Endless",
    Callback = function() end,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoWave", {
    Text = "Auto Wave",
    Default = false,
    Callback = function(state)
        if state then
            local t = task.spawn(function()
                while Toggles.AutoWave.Value do
                    if not GetRemote() then
                        task.wait(1)
                    else
                        local rawInput = Options.WaveSelected and Options.WaveSelected.Value
                        local waveArg
                        if type(rawInput) == "string" and rawInput:lower() == "endless" then
                            waveArg = "Endless"
                        else
                            waveArg = tonumber(rawInput)
                        end
                        if not waveArg then
                            notyuri("[AutoWave] invalid wave number:", tostring(rawInput))
                        else
                            local myPlot = GetMyPlot()
                            local currentWave = myPlot and myPlot:GetAttribute("CurrentWave")
                            if myPlot and currentWave == 0 then
                                notyuri("[AutoWave] starting wave", waveArg)
                                Remotes["Start Wave"]:FireServer(waveArg)
                            end
                        end
                        task.wait(1)
                    end
                end
            end)
            Flags.AutoWave = t
        else
            if Flags.AutoWave and typeof(Flags.AutoWave) == "thread" then
                task.cancel(Flags.AutoWave)
                Flags.AutoWave = nil
            end
        end
    end,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoPickup", {
    Text = "Auto Pickup",
    Default = false,
    Callback = function(state)
        if state then
            local t = task.spawn(function()
                while Toggles.AutoPickup.Value do
                    if not GetRemote() then
                        task.wait(1)
                    else
                        local droppedFolder = Plr:FindFirstChild("Dropped Items")
                        if droppedFolder then
                            for _, item in ipairs(droppedFolder:GetChildren()) do
                                local ok, err = pcall(function()
                                    Remotes.Collect:InvokeServer(item)
                                end)
                                if not ok then
                                    notyuri("[AutoPickup] failed to collect", item.Name, "-", tostring(err))
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end
            end)
            Flags.AutoPickup = t
        else
            if Flags.AutoPickup and typeof(Flags.AutoPickup) == "thread" then
                task.cancel(Flags.AutoPickup)
                Flags.AutoPickup = nil
            end
        end
    end,
})
local A1 = Tabs.Build:AddLeftGroupbox("Build")
local A2 = Tabs.Build:AddRightGroupbox("Material")
A1:AddDropdown("SelectedFile", {
    Text = "Select File",
    Values = {},
    Default = "",
    Multi = false,
    Searchable = true,
    Callback = function()
        RefreshMat()
    end,
})
MatLabel = A2:AddLabel("No build selected.", true)
A1:AddToggle("LoadBuild", {
    Text = "Load Build",
    Default = false,
    Callback = function(state)
        if state then
            local t = task.spawn(function()
                while Toggles.LoadBuild.Value do
                    DoLoad()
                    task.wait(5)
                end
            end)
            Flags.LoadBuild = t
        else
            if Flags.LoadBuild and typeof(Flags.LoadBuild) == "thread" then
                task.cancel(Flags.LoadBuild)
                Flags.LoadBuild = nil
            end
        end
    end,
})
A1:AddInput("FileName", {
    Text = "File Name",
    Default = "",
    Placeholder = "yuriyuri",
    Callback = function() end,
})
A1:AddButton({
    Text = "Save Build",
    Func = function()
        local myPlot = GetMyPlot()
        SaveBuild(Options.FileName and Options.FileName.Value or "", myPlot, Plr.UserId)
    end,
})
A1:AddButton({
    Text = "Save Selected",
    Func = function()
        local saveName = Options.FileName and Options.FileName.Value or ""
        if not saveName or saveName == "" then
            Library:Notify("Enter a file name first.", 3)
            return
        end
        if not Support.FileIO then
            Library:Notify("File IO not supported by executor.", 4)
            return
        end
        local data = LoadSource()
        if not data then return end
        local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
        if not ok or not json then
            Library:Notify("Failed to encode build data.", 4)
            return
        end
        local path = Folder .. "/" .. saveName .. ".json"
        pcall(function()
            if makefolder then pcall(makefolder, Folder) end
            writefile(path, json)
        end)
        Library:Notify(("Saved: %s (%d blocks)"):format(saveName, #data.blocks), 5)
        notyuri("[CopyBuild] selected saved to", path)
        RefreshSource()
    end,
})
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
SaveManager:SetFolder("Yuri/ToyDefense")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:SetLoadingOrder(true, {"Dropdown", "Slider", "ColorPicker", "KeyPicker", "Input", "Toggle"})
task.defer(function()
    SaveManager:LoadAutoloadConfig()
end)
if UIS.TouchEnabled and not UIS.KeyboardEnabled then
    Library:SetDPIScale(75)
elseif UIS.KeyboardEnabled then
    Library:SetDPIScale(100)
end
task.spawn(function()
    task.wait(2)
    GetRemote()
    RefreshSource()
end)
Library:Notify("Script loaded.", 2)
Library:Notify("Yuri!", 5)
end)
if not eh_success then
    Library:Notify("ERROR: " .. tostring(err), 4)
    notyuri("ERROR: " .. tostring(err))
end