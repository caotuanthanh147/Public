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
local _gcScriptFn    = getscriptclosure or get_script_function
local dbgUpval   = debug and (debug.getupvalues or debug.getupvals) or getupvalues or getupvals
local GameClient = Plr:WaitForChild("PlayerScripts"):WaitForChild("GameClient")
local SourceCache = nil
local function GetPlayerData()
    if not dbgUpval or not getgc then return nil end
    if SourceCache then
        if type(SourceCache.getData) == "function" then
            local ok, data = pcall(SourceCache.getData)
            if ok and type(data) == "table" and data.Characters then return data end
        elseif type(SourceCache.Characters) == "table" then
            return SourceCache
        end
        SourceCache = nil
    end
    local ok, gc = pcall(getgc, false)
    if not ok or type(gc) ~= "table" then return nil end
    for _, fn in ipairs(gc) do
        if type(fn) ~= "function" then continue end
        local okE, env = pcall(getfenv, fn)
        if not okE or type(env) ~= "table" then continue end
        if rawget(env, "script") ~= GameClient then continue end
        local okU, upvals = pcall(dbgUpval, fn)
        if not okU or type(upvals) ~= "table" then continue end
        for _, uv in pairs(upvals) do
            if type(uv) == "table" and type(uv.getData) == "function" then
                local ok3, data = pcall(uv.getData)
                if ok3 and type(data) == "table" and data.Characters then
                    SourceCache = uv
                    return data
                end
            end
        end
        for _, uv in pairs(upvals) do
            if type(uv) == "table" and type(uv.Characters) == "table" then
                SourceCache = uv
                return uv
            end
        end
    end
    return nil
end
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
        notyuri("Your executor does not support firesignal or getconnections.")
    end
end
local Remotes = {
}
local Modules = {
}
local Flags = {}
local Connections = {
    Player_General = nil,
    Knockback = {},
    Reconnect = nil,
}
local Shared = {
}
local FuseRemote = RS:WaitForChild("RemoteEvent")
local function Fire(action, ...)
    FuseRemote:FireServer(action, ...)
end
local _Mods          = RS:WaitForChild("Modules")
local BestiaryModule    = GetSafeModule(_Mods, "Bestiary")
local RedeemCodesModule = GetSafeModule(_Mods, "RedeemCodes")
local RecipesModule     = GetSafeModule(_Mods:WaitForChild("NPC"), "Recipes")
local TierNamesModule   = GetSafeModule(_Mods:WaitForChild("NPC"), "TierNames")
local function GetRarityName(tier)
    return (TierNamesModule and TierNamesModule[tier]) or "Common"
end
local ClassesModule        = GetSafeModule(_Mods:WaitForChild("NPC"), "Classes")
local FusionLogicScript     = _Mods:WaitForChild("FusionLogic")
local FusionLogicModule     = GetSafeModule(_Mods, "FusionLogic")
local SpecialFusionsModule  = GetSafeModule(FusionLogicScript, "SpecialFusions")
local RestrictionsModule    = GetSafeModule(FusionLogicScript, "Restrictions")
local FuseDropdown = {}
local FuseMap = {} 
local _fusePlotConn = nil
local _fuseAttrConns = {} 
local function BuildFuseList()
    local vals, map = {}, {}
    local data = GetPlayerData()
    if not data then return vals, map end
    if not data.Characters then
        notyuri("[Fuse/dbg] data exists but no .Characters")
        return vals, map
    end
    local total, inPouch = 0, 0
    for _, char in ipairs(data.Characters) do
        total += 1
        if char.Pouch then
            inPouch += 1
            if char.Id and char.UAID then
                local label = tostring(char.Id) .. " | " .. tostring(char.UAID)
                if not map[label] then
                    table.insert(vals, label)
                    map[label] = char.UAID
                end
            else
                notyuri("[Fuse/dbg] pouch char missing Id/UAID:", tostring(char.Id), tostring(char.UAID))
            end
        end
    end
    notyuri("[Fuse/dbg] Characters:", total, "inPouch:", inPouch, "labeled:", #vals)
    table.sort(vals)
    return vals, map
end
local function RefreshFuseDropdown()
    local vals, map = BuildFuseList()
    FuseDropdown = vals
    FuseMap = map
    if Options.FuseCharSelect then
        Options.FuseCharSelect:SetValues(vals)
    end
    notyuri("[Fuse] Refreshed dropdown:", #vals, "units")
end
local function WatchPlotForFuse()
    task.spawn(function()
        while true do
            task.wait(5)
            RefreshFuseDropdown()
        end
    end)
    notyuri("[Fuse] Watching player data for unit changes")
end
local FuseTargetList      = {}   
local FuseTargetLabelToId = {}   
local FuseTargetLabelIsSpecial = {}
local FuseTargetSpecialEntry = {} 
local function BuildFuseTargetIndex()
    table.clear(FuseTargetList)
    table.clear(FuseTargetLabelToId)
    table.clear(FuseTargetLabelIsSpecial)
    table.clear(FuseTargetSpecialEntry)
    if not ClassesModule then
        notyuri("[FuseTarget] Classes module unavailable")
        return
    end
    for id, cls in pairs(ClassesModule) do
        if type(cls) == "table" then
            local label = tostring(id) .. " (" .. GetRarityName(cls.Tier or 0) .. ")"
            table.insert(FuseTargetList, label)
            FuseTargetLabelToId[label] = id
            FuseTargetLabelIsSpecial[label] = false
        end
    end
    if SpecialFusionsModule then
        for _, entry in ipairs(SpecialFusionsModule) do
            for _, res in ipairs(entry.Result) do
                local label = tostring(res.id) .. " (Special Fusion)"
                if not FuseTargetLabelToId[label] then
                    FuseTargetSpecialEntry[res.id] = { entry = entry, chance = res.chance or 0 }
                    table.insert(FuseTargetList, label)
                    FuseTargetLabelToId[label] = res.id
                    FuseTargetLabelIsSpecial[label] = true
                end
            end
        end
    end
    table.sort(FuseTargetList)
    notyuri("[FuseTarget] Indexed", #FuseTargetList, "targets,", #(SpecialFusionsModule or {}), "special recipes")
end
local function GetOwnedPouchUnits()
    local flat, byClass = {}, {}
    local data = GetPlayerData()
    if not data or not data.Characters then return flat, byClass, data end
    for _, char in ipairs(data.Characters) do
        if char.Pouch and char.Id and char.UAID then
            table.insert(flat, { Id = char.Id, UAID = char.UAID, Grade = char.Grade or 1, XP = char.XP or 0, Favorited = char.Favorited == true })
            byClass[char.Id] = byClass[char.Id] or {}
            table.insert(byClass[char.Id], { UAID = char.UAID, used = false })
        end
    end
    return flat, byClass, data
end
local function GetEffectiveBaseId(classId)
    local cls = ClassesModule and ClassesModule[classId]
    if not cls then return classId end
    if cls.BaseClassId then return cls.BaseClassId end
    if cls.EX == true and #classId > 3 and string.sub(classId, -3) == " EX" then
        return string.sub(classId, 1, #classId - 3)
    end
    return classId
end
local function ClassMatchesRequirement(classId, req)
    local cls = ClassesModule and ClassesModule[classId]
    if not cls then return false end
    if req.id and GetEffectiveBaseId(classId) ~= req.id then return false end
    if req.element and cls.Element ~= req.element then return false end
    local tier = cls.Tier or 0
    if req.minTier and tier < req.minTier then return false end
    if req.maxTier and req.maxTier < tier then return false end
    if req.maxTierExclusive and req.maxTierExclusive <= tier then return false end
    return true
end
local function DescribeRequirement(req)
    if req.id then return tostring(req.id) end
    local parts = {}
    if req.element then table.insert(parts, tostring(req.element)) end
    if req.maxTier then table.insert(parts, "Tier<=" .. req.maxTier) end
    if req.maxTierExclusive then table.insert(parts, "Tier<" .. req.maxTierExclusive) end
    if req.minTier then table.insert(parts, "Tier>=" .. req.minTier) end
    return #parts > 0 and table.concat(parts, " ") or "Any unit"
end
local function ResolveSpecialIngredients(entry, byClass)
    local plan, missing = {}, {}
    for _, req in ipairs(entry.Ingredients) do
        local need = req.count or 1
        local got = 0
        for classId, units in pairs(byClass) do
            if got >= need then break end
            if ClassMatchesRequirement(classId, req) then
                for _, u in ipairs(units) do
                    if got >= need then break end
                    if not u.used then
                        u.used = true
                        got = got + 1
                        table.insert(plan, { Id = classId, UAID = u.UAID })
                    end
                end
            end
        end
        if got < need then
            table.insert(missing, DescribeRequirement(req) .. " x" .. need .. " (have " .. got .. ")")
        end
    end
    return plan, missing
end
local function GetChanceForTarget(preview, targetId)
    if not preview or not preview.CandidateStates then return 0, false end
    for _, c in ipairs(preview.CandidateStates) do
        if c.Id == targetId then return c.Chance or 0, true end
    end
    return 0, false
end
local function FindBestRegularCombo(targetId, flatUnits, minSuccessPct)
    if not FusionLogicModule then return { possible = false } end
    if #flatUnits < 2 then return { possible = false } end
    local function unitTier(u)
        local cls = ClassesModule and ClassesModule[u.Id]
        return cls and (cls.Tier or 0) or 0
    end
    local classUnits = {}
    for _, u in ipairs(flatUnits) do
        classUnits[u.Id] = classUnits[u.Id] or {}
        table.insert(classUnits[u.Id], u)
    end
    local uniqueReps = {}
    for _, units in pairs(classUnits) do
        table.insert(uniqueReps, units[1])
    end
    local candidatePairs = {}
    local checkedKeys = {}
    local function tryPair(a, b)
        local ok, preview = pcall(FusionLogicModule.BuildPreview, {
            { Id = a.Id, Grade = a.Grade or 1 },
            { Id = b.Id, Grade = b.Grade or 1 },
        })
        if not ok or not preview then return false end
        local _, appears = GetChanceForTarget(preview, targetId)
        return appears
    end
    local function addPair(a, b)
        local key = a.Id == b.Id and (a.Id .. "\0\0")
            or (a.Id < b.Id and (a.Id .. "\0" .. b.Id) or (b.Id .. "\0" .. a.Id))
        if checkedKeys[key] then return end
        checkedKeys[key] = true
        if tryPair(a, b) then
            table.insert(candidatePairs, { a = a, b = b })
        end
    end
    for i = 1, #uniqueReps do
        for j = i + 1, #uniqueReps do
            addPair(uniqueReps[i], uniqueReps[j])
        end
    end
    for _, units in pairs(classUnits) do
        if #units >= 2 then
            local key = units[1].Id .. "\0\0"
            if not checkedKeys[key] then
                if tryPair(units[1], units[2]) then
                    checkedKeys[key] = true
                    table.insert(candidatePairs, { a = units[1], b = units[2] })
                elseif #units >= 3 then
                    local ok3, preview3 = pcall(FusionLogicModule.BuildPreview, {
                        { Id = units[1].Id, Grade = units[1].Grade or 1 },
                        { Id = units[2].Id, Grade = units[2].Grade or 1 },
                        { Id = units[3].Id, Grade = units[3].Grade or 1 },
                    })
                    if ok3 and preview3 then
                        local _, appears3 = GetChanceForTarget(preview3, targetId)
                        if appears3 then
                            checkedKeys[key] = true
                            table.insert(candidatePairs, { a = units[1], b = units[2] })
                        end
                    end
                end
            end
        end
    end
    if #candidatePairs == 0 then return { possible = false } end
    table.sort(candidatePairs, function(x, y)
        local mx = math.max(unitTier(x.a), unitTier(x.b))
        local my = math.max(unitTier(y.a), unitTier(y.b))
        return mx < my
    end)
    local best, bestAchievable = nil, nil
    local targetEverAppeared = false
    for _, qp in ipairs(candidatePairs) do
        local anchorTier = math.max(unitTier(qp.a), unitTier(qp.b))
        local usedUAIDs = { [qp.a.UAID] = true, [qp.b.UAID] = true }
        local fodderPool = {}
        for _, u in ipairs(flatUnits) do
            if not usedUAIDs[u.UAID] then
                table.insert(fodderPool, u)
            end
        end
        table.sort(fodderPool, function(x, y)
            local tx, ty = unitTier(x), unitTier(y)
            local sameIdX = (x.Id == qp.a.Id or x.Id == qp.b.Id)
            local sameIdY = (y.Id == qp.a.Id or y.Id == qp.b.Id)
            if sameIdX ~= sameIdY then return sameIdX end
            if tx ~= ty then return tx < ty end
            return (x.UAID or "") < (y.UAID or "")
        end)
        local maxFodder = math.min(#fodderPool, 10)
        for fc = 0, maxFodder do
            local ingredientSet = { { Id = qp.a.Id, Grade = qp.a.Grade or 1 }, { Id = qp.b.Id, Grade = qp.b.Grade or 1 } }
            for k = 1, fc do
                table.insert(ingredientSet, { Id = fodderPool[k].Id, Grade = fodderPool[k].Grade or 1 })
            end
            local ok, preview = pcall(FusionLogicModule.BuildPreview, ingredientSet)
            if ok and preview then
                local chance, appears = GetChanceForTarget(preview, targetId)
                if appears then
                    targetEverAppeared = true
                    if not bestAchievable or chance > bestAchievable.chance then
                        bestAchievable = { chance = chance, totalUnits = 2 + fc }
                    end
                    if chance >= minSuccessPct then
                        local newMaxTier = math.max(unitTier(qp.a), unitTier(qp.b))
                        local curMaxTier = best and math.max(unitTier(best.a), unitTier(best.b)) or math.huge
                        if not best
                            or newMaxTier < curMaxTier
                            or (newMaxTier == curMaxTier and chance > best.chance)
                            or (newMaxTier == curMaxTier and chance == best.chance and (2 + fc) < best.totalUnits)
                        then
                            best = {
                                a = qp.a, b = qp.b,
                                fodder = table.move(fodderPool, 1, fc, 1, {}),
                                chance = chance,
                                totalUnits = 2 + fc,
                            }
                        end
                        break
                    end
                end
            end
        end
    end
    return {
        possible = targetEverAppeared,
        ready = best ~= nil,
        combo = best,
        bestAchievable = bestAchievable,
    }
end
local ClimbCache = { fp = "", result = nil }
local function FindClimb(flatUnits)
    if not FusionLogicModule or #flatUnits < 2 then return nil end
    local fp = tostring(#flatUnits)
    if ClimbCache.fp == fp then return ClimbCache.result end
    local function unitTier(u)
        local cls = ClassesModule and ClassesModule[u.Id]
        return cls and (cls.Tier or 0) or 0
    end
    local classUnits = {}
    for _, u in ipairs(flatUnits) do
        classUnits[u.Id] = classUnits[u.Id] or {}
        table.insert(classUnits[u.Id], u)
    end
    local uniqueReps = {}
    for _, units in pairs(classUnits) do table.insert(uniqueReps, units[1]) end
    local best = nil
    local function tryIngredients(ingredients)
        local maxInputTier, previewIngr, uaids = 0, {}, {}
        for _, u in ipairs(ingredients) do
            maxInputTier = math.max(maxInputTier, unitTier(u))
            table.insert(previewIngr, { Id = u.Id, Grade = u.Grade or 1 })
            table.insert(uaids, u.UAID)
        end
        local ok, preview = pcall(FusionLogicModule.BuildPreview, previewIngr)
        if not ok or not preview or not preview.CandidateStates then return end
        local bestChance, bestOutTier = 0, 0
        for _, c in ipairs(preview.CandidateStates) do
            local cls = ClassesModule and ClassesModule[c.Id]
            local outTier = cls and (cls.Tier or 0) or 0
            if outTier > maxInputTier and (c.Chance or 0) > bestChance then
                bestChance = c.Chance or 0
                bestOutTier = outTier
            end
        end
        if bestChance > 0 and (not best or bestChance > best.chance) then
            best = { uaids = uaids, chance = bestChance, outputTier = bestOutTier }
        end
    end
    for i = 1, #uniqueReps do
        for j = i + 1, #uniqueReps do tryIngredients({ uniqueReps[i], uniqueReps[j] }) end
    end
    for _, units in pairs(classUnits) do
        if #units >= 2 then tryIngredients({ units[1], units[2] }) end
        if #units >= 3 then tryIngredients({ units[1], units[2], units[3] }) end
        if #units >= 4 then tryIngredients({ units[1], units[2], units[3], units[4] }) end
    end
    ClimbCache = { fp = fp, result = best }
    return best
end
local LastFuseCheck = nil 
local FuseTargetLabel = nil
local function RefreshFuseTargetLabel()
    if not FuseTargetLabel or not Options.FuseTargetSelect then return end
    local sel = Options.FuseTargetSelect.Value
    local targetId = sel and FuseTargetLabelToId[sel]
    if not targetId then
        LastFuseCheck = nil
        FuseTargetLabel:SetText("Select a character first.")
        return
    end
    local flatUnits, byClass, data = GetOwnedPouchUnits()
    local minSuccess = Options.MinFuseSuccess and Options.MinFuseSuccess.Value or 50
    local text
    if FuseTargetLabelIsSpecial[sel] then
        local info = FuseTargetSpecialEntry[targetId]
        local lockMsg = RestrictionsModule and RestrictionsModule.GetLockedMessage(targetId, data)
        local plan, missing = ResolveSpecialIngredients(info.entry, byClass)
        LastFuseCheck = { targetId = targetId, special = true, info = info, lockMsg = lockMsg, plan = plan, missing = missing }
        local reqDescs = {}
        for _, req in ipairs(info.entry.Ingredients) do
            table.insert(reqDescs, DescribeRequirement(req) .. " x" .. (req.count or 1))
        end
        local lines = {
            "[Special Fusion] Chance: " .. tostring(info.chance) .. "%",
            "Needs: " .. table.concat(reqDescs, ", "),
        }
        if lockMsg then
            table.insert(lines, "LOCKED: " .. lockMsg)
        elseif #missing > 0 then
            table.insert(lines, "Missing: " .. table.concat(missing, ", "))
        elseif info.chance < minSuccess then
            table.insert(lines, "Ready(Low Success)")
        else
            table.insert(lines, "Ready")
        end
        text = table.concat(lines, "\n")
    else
        local result = FindBestRegularCombo(targetId, flatUnits, minSuccess)
        LastFuseCheck = { targetId = targetId, special = false, result = result }
        if #flatUnits < 2 then
            text = "Need at least 2 characters to attempt."
        elseif not result.possible then
            text = "Fusion method undefined."
        elseif result.ready then
            local c = result.combo
            text = string.format(
                "Best combo: %s + %s + %d fodder -> %d%% chance (%d%% minimum)",
                c.a.Id, c.b.Id, #c.fodder, c.chance, minSuccess
            )
        else
            local best = result.bestAchievable
            text = string.format(
                "Not enough material for your %d%% minimum (best reachable now: %d%%).",
                minSuccess, best and best.chance or 0
            )
        end
    end
    FuseTargetLabel:SetText(text)
end
local function Func_AutoFuse()
    while Toggles.AutoFuse.Value do
        local allUnits = GetOwnedPouchUnits()
        local filter = Options.AutoFuseRarity and Options.AutoFuseRarity.Value or {}
        local filtered = allUnits
        if next(filter) then
            filtered = {}
            for _, u in ipairs(allUnits) do
                local cls = ClassesModule and ClassesModule[u.Id]
                if filter[GetRarityName(cls and cls.Tier or 0)] then
                    table.insert(filtered, u)
                end
            end
        end
        do
            local noFav = {}
            for _, u in ipairs(filtered) do
                if not u.Favorited then
                    table.insert(noFav, u)
                end
            end
            filtered = noFav
        end
        local best = FindClimb(filtered)
        if not best then
            Library:Notify("No upgrade found, stopping.", 4)
            Toggles.AutoFuse:SetValue(false)
            break
        end
        local minSuccess = Options.MinFuseSuccess and Options.MinFuseSuccess.Value or 50
        if best.chance < minSuccess then
            -- FindClimb only tries pairs/triplets; greedily add more fodder to try to reach minSuccess
            local usedUAIDs = {}
            for _, id in ipairs(best.uaids) do usedUAIDs[id] = true end
            local currentIngr = {}
            for _, u in ipairs(filtered) do
                if usedUAIDs[u.UAID] then
                    table.insert(currentIngr, { Id = u.Id, Grade = u.Grade or 1 })
                end
            end
            notyuri("[AutoFuse] Base combo", #currentIngr, "units at", best.chance .. "%, trying to reach", minSuccess .. "% by adding fodder")
            for _, u in ipairs(filtered) do
                if best.chance >= minSuccess then break end
                if not usedUAIDs[u.UAID] then
                    local newIngr = {}
                    for _, i in ipairs(currentIngr) do table.insert(newIngr, i) end
                    table.insert(newIngr, { Id = u.Id, Grade = u.Grade or 1 })
                    local newUAIDs = {}
                    for _, id in ipairs(best.uaids) do table.insert(newUAIDs, id) end
                    table.insert(newUAIDs, u.UAID)
                    local ok, preview = pcall(FusionLogicModule.BuildPreview, newIngr)
                    if ok and preview and preview.CandidateStates then
                        local maxInputTier = 0
                        for _, ingr in ipairs(newIngr) do
                            local cls = ClassesModule and ClassesModule[ingr.Id]
                            maxInputTier = math.max(maxInputTier, cls and (cls.Tier or 0) or 0)
                        end
                        for _, c in ipairs(preview.CandidateStates) do
                            local cls = ClassesModule and ClassesModule[c.Id]
                            local outTier = cls and (cls.Tier or 0) or 0
                            if outTier > maxInputTier and (c.Chance or 0) > best.chance then
                                best = { uaids = newUAIDs, chance = c.Chance or 0, outputTier = outTier }
                                currentIngr = newIngr
                                usedUAIDs[u.UAID] = true
                                notyuri("[AutoFuse] Fodder boost: added", u.Id, "->", best.chance .. "%", "(", #newUAIDs, "units)")
                                break
                            end
                        end
                    end
                end
            end
        end
        if best.chance < minSuccess then
            Library:Notify(string.format("Best %d%% below %d%%, stopping.", best.chance, minSuccess), 4)
            notyuri("[AutoFuse] Could not reach", minSuccess .. "%, best was", best.chance .. "%")
            Toggles.AutoFuse:SetValue(false)
            break
        end
        notyuri("[AutoFuse] Fusing ->", GetRarityName(best.outputTier), "(" .. best.chance .. "%)")
        FuseRemote:FireServer("Fusion", best.uaids, 10000)
        Library:Notify(string.format("Auto Fuse → %s (%d%%)", GetRarityName(best.outputTier), best.chance), 3)
        task.wait(.5)
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
            if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect")
            or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect")
            or v:IsA("Atmosphere") then
                v.Enabled = false
            end
        end
        pcall(function()
            local Environments = game:GetService("ReplicatedStorage"):FindFirstChild("Environments")
            if not Environments then return end
            for _, env in ipairs(Environments:GetChildren()) do
                for _, v in ipairs(env:GetChildren()) do
                    if v:IsA("PostProcessEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect")
                    or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect")
                    or v:IsA("Atmosphere") then
                        v.Enabled = false
                    end
                end
            end
        end)
        pcall(function()
            local Players = game:GetService("Players")
            for _, character in ipairs(workspace:GetChildren()) do
                if not character:IsA("Model") then continue end
                local player = Players:GetPlayerFromCharacter(character)
                if player and player ~= Plr then
                    local anim = character:FindFirstChild("Animate")
                    if anim and anim:IsA("LocalScript") then anim.Disabled = true end
                    local sound = character:FindFirstChild("WalkingSound")
                    if sound and sound:IsA("LocalScript") then sound.Disabled = true end
                end
            end
        end)
        pcall(function()
            local plots = workspace:FindFirstChild("Active_Plots")
            if not plots then return end
            for _, plot in ipairs(plots:GetChildren()) do
                if plot:GetAttribute("owner") ~= Plr.UserId then
                    plot:Destroy()
                end
            end
        end)
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
        T2 = TB.Main.Left.Autofarm:AddTab("Misc"),
        T3 = TB.Main.Left.Autofarm:AddTab("Fusion"),
    },
    Label = {
        T1 = TB.Main.Right.Autofarm:AddTab("Panel"),
    },
}
WatchPlotForFuse()
FuseDropdown, FuseMap = BuildFuseList()
TB_Tabs.Autofarm.T3:AddDropdown("FuseCharSelect", {
    Text = "Fuse Character",
    Values = FuseDropdown,
    Default = {},
    Multi = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T3:AddButton({
    Text = "Fuse",
    Func = function()
        local uaids = {}
        for label, active in pairs(Options.FuseCharSelect.Value) do
            if active then
                local uaid = FuseMap[label]
                if uaid then
                    table.insert(uaids, uaid)
                end
            end
        end
        if #uaids < 2 then
            Library:Notify("Select at least 2 characters to fuse.", 2)
            return
        end
        FuseRemote:FireServer("Fusion", uaids, 10000)
        Library:Notify("Fusion fired with " .. #uaids .. " characters.", 3)
    end,
})
TB_Tabs.Autofarm.T3:AddDivider()
BuildFuseTargetIndex()
TB_Tabs.Autofarm.T3:AddDropdown("FuseTargetSelect", {
    Text = "Fuse Target Character",
    Values = FuseTargetList,
    Default = nil,
    AllowNull = true,
    Searchable = true,
})
TB_Tabs.Autofarm.T3:AddSlider("MinFuseSuccess", {
    Text = "Min Success %",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 0,
})
FuseTargetLabel = TB_Tabs.Label.T1:AddLabel("Select a character first.", true)
Options.FuseTargetSelect:OnChanged(function()
    RefreshFuseTargetLabel()
end)
Options.MinFuseSuccess:OnChanged(function()
    RefreshFuseTargetLabel()
end)
local AutoFuseRarityValues = {}
if TierNamesModule then
    local i = 0
    while TierNamesModule[i] do
        table.insert(AutoFuseRarityValues, TierNamesModule[i])
        i += 1
    end
end
TB_Tabs.Autofarm.T3:AddButton({
    Text = "Fuse(Target)",
    Func = function()
        local sel = Options.FuseTargetSelect.Value
        local targetId = sel and FuseTargetLabelToId[sel]
        if not targetId then Library:Notify("Select a target character first.", 2) return end
        local flatUnits, byClass, data = GetOwnedPouchUnits()
        local minSuccess = Options.MinFuseSuccess.Value
        if FuseTargetLabelIsSpecial[sel] then
            local info = FuseTargetSpecialEntry[targetId]
            local lockMsg = RestrictionsModule and RestrictionsModule.GetLockedMessage(targetId, data)
            if lockMsg then Library:Notify(lockMsg, 3) return end
            if info.chance < minSuccess then
                return
            end
            local plan, missing = ResolveSpecialIngredients(info.entry, byClass)
            if #missing > 0 then
                Library:Notify("Missing: " .. table.concat(missing, ", "), 4)
                return
            end
            local uaids = {}
            for _, p in ipairs(plan) do table.insert(uaids, p.UAID) end
            notyuri("[FuseTarget] Firing special recipe for", targetId, "chance:", info.chance)
            FuseRemote:FireServer("Fusion", uaids, 10000)
            Library:Notify("Fusion fired for " .. targetId .. " (" .. info.chance .. "% chance).", 3)
        else
            local result = FindBestRegularCombo(targetId, flatUnits, minSuccess)
            if not result or not result.possible then
                Library:Notify(targetId .. " can't appear from your current units.", 3)
                return
            end
            if not result.ready then
                Library:Notify("Not enough material for " .. minSuccess .. "% odds (best: " .. (result.bestAchievable and result.bestAchievable.chance or 0) .. "%).", 4)
                return
            end
            local c = result.combo
            local uaids = { c.a.UAID, c.b.UAID }
            for _, f in ipairs(c.fodder) do table.insert(uaids, f.UAID) end
            notyuri("[FuseTarget] Firing regular combo for", targetId, "chance:", c.chance)
            FuseRemote:FireServer("Fusion", uaids, 10000)
            Library:Notify("Fusion fired (" .. c.chance .. "% chance for " .. targetId .. ").", 3)
        end
    end,
})
TB_Tabs.Autofarm.T3:AddDropdown("AutoFuseRarity", {
    Text    = "Rarity Filter",
    Values  = AutoFuseRarityValues,
    Default = {},
    Multi   = true,
})
TB_Tabs.Autofarm.T3:AddToggle("AutoFuse", {
    Text    = "Auto Fuse",
    Default = false,
})
task.spawn(function()
    while true do
        task.wait(5)
        RefreshFuseTargetLabel()
    end
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
Toggles.Disable3DRender:OnChanged(function(v) RunService:SeT2dRenderingEnabled(not v) end)
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
TB_Tabs.Autofarm.T2:AddToggle("AutoTask", {
    Text    = "Auto Task",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoInfPass", {
    Text    = "Auto Claim Inf Pass",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoBestiary", {
    Text    = "Auto Claim Bestiary",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddButton({
    Text = "Redeem All Codes",
    Func = function()
        if not RedeemCodesModule then
            Library:Notify("RedeemCodes module not found.", 3)
            return
        end
        local data     = GetPlayerData()
        local redeemed = data and RedeemCodesModule.EnsureData(data) or {}
        local all      = RedeemCodesModule.GetAll()
        local count    = 0
        for _, code in pairs(all) do
            if not redeemed[code.Id] then
                notyuri("[Codes] Redeeming:", code.Id)
                pcall(Fire, "RedeemCode", code.Id)
                task.wait(0.4)
                count += 1
            end
        end
        Library:Notify("Redeemed " .. count .. " code(s).", 3)
    end,
})
local CraftUnitMap, CraftWeaponMap = {}, {}
local CraftUnitList, CraftWeaponList = {}, {}
local CraftWorldSet = {}
if RecipesModule then
    for _, recipe in pairs(RecipesModule) do
        if recipe.Biome == "Tutorial" then continue end
        local rarity = GetRarityName(recipe.Tier)
        local label = recipe.Biome .. " | " .. recipe.Id .. " [" .. rarity .. "]"
        CraftWorldSet[recipe.Biome] = true
        if recipe.Type == "Character" then
            CraftUnitMap[label]  = recipe
            table.insert(CraftUnitList, label)
        elseif recipe.Type == "Weapon" then
            CraftWeaponMap[label] = recipe
            table.insert(CraftWeaponList, label)
        end
    end
    table.sort(CraftUnitList)
    table.sort(CraftWeaponList)
end
TB_Tabs.Autofarm.T1:AddDropdown("CraftUnitSelect", {
    Text       = "Select Unit",
    Values     = CraftUnitList,
    Default    = CraftUnitList[1],
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddButton({
    Text = "Craft Unit",
    Func = function()
        local label  = Options.CraftUnitSelect.Value
        local recipe = CraftUnitMap[label]
        if not recipe then Library:Notify("Select a unit first.", 2) return end
        notyuri("[Craft] Unit:", recipe.Id, "| Biome:", recipe.Biome)
        pcall(Fire, "Craft", recipe.Biome, recipe.Id)
        Library:Notify("Crafted " .. recipe.Id, 2)
    end,
})
TB_Tabs.Autofarm.T1:AddDivider()
TB_Tabs.Autofarm.T1:AddDropdown("CraftWeaponSelect", {
    Text       = "Select Weapon",
    Values     = CraftWeaponList,
    Default    = CraftWeaponList[1],
    Searchable = true,
})
TB_Tabs.Autofarm.T1:AddButton({
    Text = "Craft Weapon",
    Func = function()
        local label  = Options.CraftWeaponSelect.Value
        local recipe = CraftWeaponMap[label]
        if not recipe then Library:Notify("Select a weapon first.", 2) return end
        notyuri("[Craft] Weapon:", recipe.Id, "| Biome:", recipe.Biome)
        pcall(Fire, "Craft", recipe.Biome, recipe.Id)
        Library:Notify("Crafted " .. recipe.Id, 2)
    end,
})
TB_Tabs.Autofarm.T1:AddDropdown("SelectedBoon", {
    Text    = "Island Boon",
    Values  = {
        "EncounterBoon", "BoostBoon", "WeatherBoon",
        "QuickWind", "MaterialWind", "GemWind",
        "DescendChaos", "FightChaoticBeing", "ReceiveGift",
    },
    Default = {},
    Multi   = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoIslandEvent", {
    Text    = "Auto Island Event",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoPlantSeed", {
    Text    = "Auto Plant Seed",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoHarvestSeed", {
    Text    = "Auto Harvest Seed",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoRankUp", {
    Text    = "Auto Rank Up",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoGeode", {
    Text    = "Auto Geode",
    Default = false,
})
TB_Tabs.Autofarm.T2:AddToggle("AutoPortalReward", {
    Text    = "Auto Portal Reward",
    Default = false,
})
local function DoAutoTask()
    local data = GetPlayerData()
    if not data or type(data.AreaTasks) ~= "table" then return end
    for areaId, board in pairs(data.AreaTasks) do
        if type(board) ~= "table" then continue end
        if board.ActiveTaskId then
            notyuri("[AutoTask] ClaimTaskReward:", areaId, board.ActiveTaskId)
            pcall(Fire, "ClaimTaskReward", areaId, board.ActiveTaskId)
            task.wait(0.4)
        else
            notyuri("[AutoTask] BeginTask:", areaId)
            pcall(Fire, "BeginTask", areaId)
            task.wait(0.4)
        end
    end
end
local function Func_AutoTask()
    while Toggles.AutoTask.Value do
        pcall(DoAutoTask)
        task.wait(1)
    end
end
local function DoAutoInfPass()
    local data = GetPlayerData()
    if not data then return end
    local meta = data.MetaData
    local pack = meta and meta.Monetization and meta.Monetization.InfinitePack
    local nextClaim = pack and (pack.NextClaimAt or 0) or 0
    if nextClaim <= os.time() then
        pcall(Fire, "ClaimInfinitePack")
    end
end
local function Func_AutoInfPass()
    while Toggles.AutoInfPass.Value do
        pcall(DoAutoInfPass)
        task.wait(1)
    end
end
local function DoAutoBestiary()
    local data = GetPlayerData()
    if not data or not BestiaryModule then return end
    local ok, sections = pcall(function()
        return BestiaryModule.GetSections(data)
    end)
    if not ok or not sections then return end
    for _, kind in ipairs(BestiaryModule.SECTION_KINDS) do
        for _, section in ipairs(sections[kind] or {}) do
            local claimable = false
            for _, ms in ipairs(section.Milestones or {}) do
                if ms.Claimable then claimable = true; break end
            end
            if not claimable then
                for _, entry in ipairs(section.Entries or {}) do
                    if entry.CanClaim then claimable = true; break end
                end
            end
            if claimable then
                notyuri("[AutoBestiary] ClaimAllBestiarySection:", kind, section.Id)
                pcall(Fire, "ClaimAllBestiarySection", kind, section.Id)
                task.wait(0.3)
            end
        end
    end
end
local function Func_AutoBestiary()
    while Toggles.AutoBestiary.Value do
        pcall(DoAutoBestiary)
        task.wait(1)
    end
end
local function DoAutoIslandEvent()
    local Active_Plots = workspace:FindFirstChild("Active_Plots")
    if not Active_Plots then return end
    for _, plot in ipairs(Active_Plots:GetChildren()) do
        local base = plot:FindFirstChild("Base")
        if not base then continue end
        local runtime = base:FindFirstChild("PortalIslandEventRuntime")
        if not runtime then continue end
        for _, obj in ipairs(runtime:GetChildren()) do
            local hostUserId = obj:GetAttribute("HostUserId")
            local refreshId  = obj:GetAttribute("EventRefreshId")
            local kind       = obj:GetAttribute("EventKind")
            local claimed    = obj:GetAttribute("Claimed")
            if typeof(hostUserId) == "number" and kind == "Visitor" and not claimed then
                for choiceId, active in pairs(Options.SelectedBoon.Value) do
                    if active then
                        notyuri("[IslandEvent] Firing:", hostUserId, refreshId, choiceId)
                        pcall(Fire, "UseIslandEvent", hostUserId, "Visitor", refreshId, choiceId)
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end
local function Func_AutoIslandEvent()
    while Toggles.AutoIslandEvent.Value do
        pcall(DoAutoIslandEvent)
        task.wait(1)
    end
end
local PortalSelect = require(RS.Modules.PortalSelect)
local function GetBase()
    for _, plot in ipairs(workspace.Active_Plots:GetChildren()) do
        if plot:GetAttribute("owner") == Plr.UserId then
            return plot:FindFirstChild("Base")
        end
    end
end
local function DoAutoGeode()
    local base = GetBase()
    if not base then return end
    local crackPrompts, geodePrompts = {}, {}
    for _, prompt in ipairs(base:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            if prompt.Name == "CaveCrackStation" then
                table.insert(crackPrompts, prompt)
            elseif prompt.Name == "CaveGeodeNode" then
                table.insert(geodePrompts, prompt)
            end
        end
    end
    for _, prompt in ipairs(geodePrompts) do
        local stone = prompt.Parent
        local cooldownUntil = stone and stone:GetAttribute("CooldownUntil")
        if cooldownUntil and cooldownUntil > os.time() then
            notyuri("[AutoGeode] Skipping (cooldown):", stone, "until", cooldownUntil)
        else
            notyuri("[AutoGeode] CollectCaveNode (Geode):", stone)
            pcall(FirePP, prompt, true)
            task.wait()
        end
    end
    if crackPrompts[1] then
        local data = GetPlayerData()
        local rawGeodeCount = (type(data) == "table" and type(data.Materials) == "table")
            and (tonumber(data.Materials["Raw Geode"]) or 0) or 0
        for i = 1, rawGeodeCount do
            notyuri("[AutoGeode] CrackGeode (" .. i .. "/" .. rawGeodeCount .. "):", crackPrompts[1].Parent)
            pcall(FirePP, crackPrompts[1], true)
            task.wait()
        end
    end
end
local function Func_AutoGeode()
    while Toggles.AutoGeode.Value do
        pcall(DoAutoGeode)
        task.wait(2)
    end
end
local function DoAutoPortalReward()
    local data = GetPlayerData()
    if not data then return end
    for _, portal in ipairs(PortalSelect) do
        if portal.SkipRewards then continue end
        local rewards = PortalSelect.GetPortalRewards(data, portal.Id)
        for _, reward in ipairs(rewards) do
            if reward.Claimable and not reward.Claimed then
                notyuri("[AutoPortalReward] ClaimPortalReward:", portal.Id, reward.Id)
                pcall(Fire, "ClaimPortalReward", reward.Id)
                task.wait(0.5)
            end
        end
    end
end
local function Func_AutoPortalReward()
    while Toggles.AutoPortalReward.Value do
        pcall(DoAutoPortalReward)
        task.wait(5)
    end
end
local function DoAutoPlant()
    local data = GetPlayerData()
    local items = type(data) == "table" and data.Items
    if type(items) ~= "table" or (tonumber(items["Mystic Seed"]) or 0) <= 0 then return end
    local base = GetBase()
    if not base then return end
    local map = base:FindFirstChild("Map")
    if not map then return end
    local hrp = Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { map }
    params.IgnoreWater = true
    local result = workspace:Raycast(hrp.Position, Vector3.new(0, -50, 0), params)
    if not result then return end
    local groundPart = result.Instance
    local plantPosition = result.Position
    if (hrp.Position - plantPosition).Magnitude <= 20 then
        pcall(Fire, "MysticSeedPlaceRequest", { groundPart = groundPart, plantPosition = plantPosition })
    end
end
local function DoAutoHarvest()
    local base = GetBase()
    if not base then return end
    local runtime = base:FindFirstChild("MysticSeedRuntime")
    if not runtime then return end
    for _, plant in ipairs(runtime:GetChildren()) do
        local plantId = plant:GetAttribute("MysticSeedPlantId")
        if type(plantId) ~= "string" or plantId == "" then continue end
        local prompt = plant:FindFirstChild("MysticSeedHarvestPrompt")
        if not prompt then continue end
        notyuri("[AutoHarvestSeed] Harvesting plantId:", plantId)
        pcall(Fire, "MysticSeedHarvestRequest", { plantId = plantId })
        task.wait(0.3)
    end
end
local function Func_AutoPlant()
    while Toggles.AutoPlantSeed.Value do
        pcall(DoAutoPlant)
        task.wait(1)
    end
end
local function Func_AutoHarvest()
    while Toggles.AutoHarvestSeed.Value do
        pcall(DoAutoHarvest)
        task.wait(1)
    end
end
local function Func_AutoRankUp()
    while Toggles.AutoRankUp.Value do
        pcall(Fire, "RankUp")
        task.wait(1)
    end
end
Toggles.AutoTask:OnChanged(function(state)
    Thread("AutoTask", Func_AutoTask, state)
end)
Toggles.AutoFuse:OnChanged(function(state)
    Thread("AutoFuse", Func_AutoFuse, state)
end)
Toggles.AutoInfPass:OnChanged(function(state)
    Thread("AutoInfPass", Func_AutoInfPass, state)
end)
Toggles.AutoBestiary:OnChanged(function(state)
    Thread("AutoBestiary", Func_AutoBestiary, state)
end)
Toggles.AutoIslandEvent:OnChanged(function(state)
    Thread("AutoIslandEvent", Func_AutoIslandEvent, state)
end)
Toggles.AutoPlantSeed:OnChanged(function(state)
    Thread("AutoPlantSeed", Func_AutoPlant, state)
end)
Toggles.AutoHarvestSeed:OnChanged(function(state)
    Thread("AutoHarvestSeed", Func_AutoHarvest, state)
end)
Toggles.AutoRankUp:OnChanged(function(state)
    Thread("AutoRankUp", Func_AutoRankUp, state)
end)
Toggles.AutoGeode:OnChanged(function(state)
    Thread("AutoGeode", Func_AutoGeode, state)
end)
Toggles.AutoPortalReward:OnChanged(function(state)
    Thread("AutoPortalReward", Func_AutoPortalReward, state)
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
    if _fusePlotConn then _fusePlotConn:Disconnect(); _fusePlotConn = nil end
    for _, c in ipairs(_fuseAttrConns) do c:Disconnect() end
    table.clear(_fuseAttrConns)
    Cleanup(Connections)
    Cleanup(Flags)
	Library:Unload()
end)
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder("Yuri")
SaveManager:SetFolder("Yuri/PortalKeeper")
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