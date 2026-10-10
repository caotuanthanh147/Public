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
}
local _Module_BigNum = (function()
local t = {
	POW_ZERO = { 0, 0 },
	precision = 5,
	display_precision = 2,
	ZERO = { 0, 0 },
	NAN = { -2, 0 }
}
local v1 = 10 ^ t.precision
local v2 = 10 ^ t.display_precision
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function ShouldUseScientific() 
	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then
		return false
	end
	local Data = ReplicatedStorage:FindFirstChild("Data")
	local v1 = Data and (Data:FindFirstChild((tostring(LocalPlayer.UserId))) or Data:FindFirstChild(LocalPlayer.Name))
	local v2 = v1 and v1:FindFirstChild("Settings") or v1
	local v3 = v2 and v2:FindFirstChild("ScientificNotation") or v2
	return v3 ~= nil and v3.Value == true or false
end
function t.fromNumber(p1) 
	if type(p1) ~= "number" then
		return table.clone(t.NAN)
	end
	if p1 == 0 then
		return table.clone(t.ZERO)
	end
	if p1 == p1 then
		local v1 = math.sign(p1)
		local t2 = {}
		local v2 = math.abs(p1)
		t2[1] = v1
		t2[2] = math.log10(v2)
		return t2
	end
	return table.clone(t.NAN)
end
function t.toNumber(p1) 
	if p1[1] == -2 then
		return (0 / 0)
	end
	local v12 = p1[1] * 10 ^ p1[2]
	if v12 < 4503599627370496 then
		return math.round(v12 * v1) / v1
	end
	return v12
end
function t.fromString(p1) 
	local v1 = string.find(p1, "e")
	if v1 then
		local v3 = tonumber((string.sub(p1, 1, v1 - 1)))
		local v5 = tonumber((string.sub(p1, v1 + 1, -1)))
		if v3 ~= v3 or v3 == nil then
			return table.clone(t.NAN)
		end
		if v5 ~= v5 or v5 == nil then
			return table.clone(t.NAN)
		end
		if v3 == 0 then
			return table.clone(t.ZERO)
		end
		local t2 = {}
		local v6 = math.sign(v3)
		local v7 = math.abs(v3)
		t2[1] = v6
		t2[2] = math.log10(v7) + v5
		return t2
	end
	if string.find(p1, ";") then
		local v8 = string.find(p1, ";")
		local v10 = tonumber((string.sub(p1, 1, v8 - 1)))
		local v12 = tonumber((string.sub(p1, v8 + 1, -1)))
		if v10 ~= v10 or v10 == nil then
			return table.clone(t.NAN)
		end
		if v12 ~= v12 or v12 == nil then
			return table.clone(t.NAN)
		end
		if v10 == 0 then
			return t.fromNumber(v12)
		end
		if math.abs(v10) == 1 then
			return { math.sign(v10), v12 }
		end
		return { math.sign(v10), (1 / 0) }
	end
	if string.lower(p1) == "inf" then
		return { 1, (1 / 0) }
	end
	local v13 = tonumber(p1)
	if v13 ~= v13 or v13 == nil then
		return table.clone(t.NAN)
	end
	if v13 == 0 then
		return table.clone(t.ZERO)
	end
	local t2 = {}
	local v14 = math.sign(v13)
	local v15 = math.abs(v13)
	t2[1] = v14
	t2[2] = math.log10(v15)
	return t2
end
function t.toString(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == 0 then
		return "0e0"
	end
	if p1[1] == -2 then
		return "NaN"
	end
	if p1[2] == (1 / 0) then
		return (p1[1] == -1 and "-" or "") .. "inf"
	end
	local v4 = math.floor(p1[2])
	return (p1[1] == -1 and "-" or "") .. 10 ^ (p1[2] - v4) .. "e" .. v4
end
function t.add(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == -2 or p2[1] == -2 then
		return table.clone(t.NAN)
	end
	if p1[1] == 0 then
		return table.clone(p2)
	end
	if p2[1] == 0 then
		return table.clone(p1)
	end
	local v3 = p1[2] - p2[2]
	if v3 > 16 then
		return table.clone(p1)
	end
	if v3 < -16 then
		return table.clone(p2)
	end
	if v3 == 0 and p1[1] ~= p2[1] then
		return table.clone(t.ZERO)
	end
	if p1[1] == p2[1] then
		return { p1[1], math.log10(10 ^ v3 + 1) + p2[2] }
	end
	if v3 >= 0 then
		return { p1[1], p1[2] + math.log10(1 - 10 ^ (-v3)) }
	end
	return { -p1[1], p2[2] + math.log10(1 - 10 ^ v3) }
end
function t.sub(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == -2 or p2[1] == -2 then
		return table.clone(t.NAN)
	end
	if p1[1] == 0 then
		return table.clone(p2)
	end
	if p2[1] == 0 then
		return table.clone(p1)
	end
	local v3 = p1[2] - p2[2]
	if v3 > 16 then
		return table.clone(p1)
	end
	if v3 < -16 then
		return table.clone(p2)
	end
	if v3 == 0 and p1[1] == p2[1] then
		return table.clone(t.ZERO)
	end
	if p1[1] ~= p2[1] then
		return { p1[1], math.log10(10 ^ v3 + 1) + p2[2] }
	end
	if v3 >= 0 then
		return { p1[1], p1[2] + math.log10(1 - 10 ^ (-v3)) }
	end
	return { -p1[1], p2[2] + math.log10(1 - 10 ^ v3) }
end
function t.mul(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == -2 or p2[1] == -2 then
		return table.clone(t.NAN)
	end
	return { p1[1] * p2[1], p1[2] + p2[2] }
end
function t.div(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == -2 or p2[1] == -2 then
		return table.clone(t.NAN)
	end
	if p2[1] == 0 then
		return table.clone(t.NAN)
	end
	return { p1[1] * p2[1], p1[2] - p2[2] }
end
function t.intdiv(p1, p2) 
	return t.floor(t.div(p1, p2))
end
function t.pow(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == -2 or p2[1] == -2 then
		return table.clone(t.NAN)
	end
	if p1[1] == 0 then
		if p2[1] == 0 then
			return table.clone(t.POW_ZERO)
		end
		return table.clone(t.ZERO)
	end
	if p1[1] ~= -1 then
		return { 1, p1[2] * 10 ^ p2[2] * p2[1] }
	end
	local t2 = {}
	t2[1] = (t.toNumber(p2) % 2 == 1) and -1 or 1
	t2[2] = p1[2] * 10 ^ p2[2] * p2[1]
	return t2
end
function t.powf(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] ~= 1 then
		return table.clone(t.NAN)
	end
	if p2 == 0 then
		return { 0, 0 }
	end
	if p2 == 1 then
		return { 1, 0 }
	end
	return { 1, p1[2] * p2 }
end
function t.pow10(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	return { 1, p1[1] * 10 ^ p1[2] }
end
function t.sqrt(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] < 0 then
		return table.clone(t.NAN)
	end
	if p1[1] == 0 then
		return table.clone(t.ZERO)
	end
	return { 1, 0.5 * p1[2] }
end
function t.root(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p2[1] == -2 then
		return table.clone(t.NAN)
	end
	if p2[2] == 0 or p1[1] < 0 then
		return table.clone(t.NAN)
	end
	if p1[1] == 0 then
		return table.clone(t.ZERO)
	end
	return { 1, 1 / t.toNumber(p2) * p1[2] }
end
function t.cmp(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == p2[1] then
		if not (math.abs(p1[2] - p2[2]) <= 1e-7) then
			if p1[2] > p2[2] then
				return p1[1]
			end
			if p1[2] < p2[2] then
				return -1 * p1[1]
			end
		end
		if p1[1] == -2 then
			return -1
		end
		return 0
	end
	if p1[1] > p2[1] then
		return 1
	end
	return -1
end
function t.eq(p1, p2) 
	return t.cmp(p1, p2) == 0
end
function t.lt(p1, p2) 
	return t.cmp(p1, p2) == -1
end
function t.gt(p1, p2) 
	return t.cmp(p1, p2) == 1
end
function t.lte(p1, p2) 
	return t.cmp(p1, p2) ~= 1
end
function t.gte(p1, p2) 
	return t.cmp(p1, p2) ~= -1
end
function t.isBigNum(p1) 
	return type(p1) == "table" and (type(p1[1]) == "number" and type(p1[2]) == "number" or false) or false
end
function t.isNaN(p1) 
	return math.abs(p1[1]) > 1
end
function t.sign(p1) 
	return p1[1]
end
function t.isNegative(p1) 
	return p1[1] == -1
end
function t.isPositive(p1) 
	return p1[1] == 1
end
function t.isZero(p1) 
	return p1[1] == 0
end
function t.isFloat(p1) 
	return p1[2] <= 308.2304489213783 and math.abs(p1[1]) <= 1 or false
end
function t.neg(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	return { -p1[1], p1[2] }
end
function t.abs(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	return { 1, p1[2] }
end
function t.toBN(p1) 
	if type(p1) == "string" then
		return t.fromString(p1)
	end
	if type(p1) == "number" then
		return t.fromNumber(p1)
	end
	if type(p1) == "table" then
		return { p1[1], p1[2] }
	end
	warn(debug.traceback((("Invalid input type \'%*\'"):format((type(p1))))))
	return table.clone(t.ZERO)
end
function t.recip(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	return { p1[1], p1[2] * -1 }
end
function t.log10(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == 1 then
		local t2 = {}
		local v3 = math.sign(p1[2])
		local v5 = math.abs(p1[2])
		t2[1] = v3
		t2[2] = math.log10(v5)
		return t2
	end
	return table.clone(t.NAN)
end
function t.log2(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == 1 then
		local t2 = {}
		local v3 = math.sign(p1[2])
		local v5 = math.abs(p1[2]) / 0.3010299956639812
		t2[1] = v3
		t2[2] = math.log10(v5)
		return t2
	end
	return table.clone(t.NAN)
end
function t.ln(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == 1 then
		local t2 = {}
		local v3 = math.sign(p1[2])
		local v5 = math.abs(p1[2]) / 0.4342944819032518
		t2[1] = v3
		t2[2] = math.log10(v5)
		return t2
	end
	return table.clone(t.NAN)
end
function t.log(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	local v2 = p2 and t.toNumber(t.toBN(p2)) or 2.718281828459045
	if p1[1] ~= 1 then
		return table.clone(t.NAN)
	end
	if v2 then
		local t2 = {}
		local v4 = math.sign(p1[2])
		local v6 = math.abs(p1[2]) / math.log10(v2)
		t2[1] = v4
		t2[2] = math.log10(v6)
		return t2
	end
	local t2 = {}
	local v8 = math.sign(p1[2])
	local v10 = math.abs(p1[2]) / 0.4342944819032518
	t2[1] = v8
	t2[2] = math.log10(v10)
	return t2
end
function t.exp(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	return { 1, 0.4342944819032518 * 10 ^ p1[2] * p1[1] }
end
local t2 = {
	0.9999999999998099,
	676.5203681218851,
	-1259.1392167224028,
	771.3234287776531,
	-176.6150291621406,
	12.507343278686905,
	-0.13857109526572012,
	9.984369578019572e-6,
	1.5056327351493116e-7
}
local function v3(p1) 
	if p1 > 0.5 then
		local v1 = p1 - 1
		local v2 = v1 + 7.5
		return (t2[1] + t2[2] / (v1 + 1) + t2[3] / (v1 + 2) + t2[4] / (v1 + 3) + t2[5] / (v1 + 4) + t2[6] / (v1 + 5) + t2[7] / (v1 + 6) + t2[8] / (v1 + 7)) * v2 ^ (v1 + 0.5 - 36) * math.exp(-v2) * v2 ^ 36 * 2.5066282746310007
	end
	return math.pi / (math.sin(p1 * math.pi) * v3(1 - p1))
end
local t3 = { 1, 0.798179868358115 }
local t4 = { 1, 0.4342944819032518 }
local t5 = { 1, -1.079181246064997 }
local t6 = { 1, -2.556302501983312 }
function t.fact(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	local v2 = t.toNumber(p1)
	if p1[1] == -1 then
		return table.clone(t.NAN)
	end
	if v2 < 170.61 then
		return t.fromNumber((v3(v2 + 1)))
	end
	local v4 = t.div(t5, p1)
	local v5 = t.div(t6, t.powf(p1, 3))
	local v7 = t.sqrt((t.mul(t3, p1)))
	return t.mul(t.exp((t.sub(v4, v5))), (t.mul(t.pow(t.div(p1, t4), p1), v7)))
end
function t.random(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == -2 or p2[1] == -2 then
		return table.clone(t.NAN)
	end
	return t.add(t.mul(t.sub(p2, p1), t.fromNumber(math.random())), p1)
end
function t.exprand(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if p1[1] == -2 or p2[1] == -2 then
		return table.clone(t.NAN)
	end
	return { p1[1], p1[2] + p2[2] * math.random() }
end
function t.min(...) 
	local t2 = { ... }
	local v1 = t2[1]
	for v2, v3 in t2 do
		if t.cmp(v3, v1) == -1 then
			v1 = v3
		end
	end
	return t.toBN(v1)
end
function t.max(...) 
	local t2 = { ... }
	local v1 = t2[1]
	for v2, v3 in t2 do
		if t.cmp(v3, v1) == 1 then
			v1 = v3
		end
	end
	return t.toBN(v1)
end
function t.floor(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	if p1[2] >= 16 then
		return table.clone(p1)
	end
	if p1[1] == 0 or p1[2] < 0 then
		return table.clone(t.ZERO)
	end
	if p1[1] == -1 then
		local t2 = {}
		local v3 = math.ceil(10 ^ p1[2])
		t2[1] = -1
		t2[2] = math.log10(v3)
		return t2
	end
	local t2 = {}
	local v5 = math.floor(10 ^ p1[2])
	t2[1] = 1
	t2[2] = math.log10(v5)
	return t2
end
function t.ceil(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	if p1[2] >= 16 then
		return table.clone(p1)
	end
	if p1[1] == 0 or p1[2] < 0 then
		return table.clone(t.ZERO)
	end
	if p1[1] == -1 then
		local t2 = {}
		local v3 = math.floor(10 ^ p1[2])
		t2[1] = -1
		t2[2] = math.log10(v3)
		return t2
	end
	local t2 = {}
	local v5 = math.ceil(10 ^ p1[2])
	t2[1] = 1
	t2[2] = math.log10(v5)
	return t2
end
function t.round(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return table.clone(t.NAN)
	end
	if p1[2] >= 16 then
		return table.clone(p1)
	end
	if p1[1] == 0 or p1[2] < 0 then
		return table.clone(t.ZERO)
	end
	local t2 = {}
	local v4 = math.round(10 ^ p1[2])
	t2[1] = p1[1]
	t2[2] = math.log10(v4)
	return t2
end
function t.mod(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if type(p2) ~= "table" then
		p2 = t.toBN(p2)
	end
	if t.isFloat(p1) and t.isFloat(p2) then
		return t.fromNumber(t.toNumber(p1) % t.toNumber(p2))
	end
	return t.sub(p1, t.mul(p2, t.intdiv(p1, p2)))
end
function t.lbencode(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	local v2 = t.add({ 1, p1[2] }, { 1, 0 })
	if v2[2] ~= v2[2] then
		return 0
	end
	local v3 = v2[2]
	if v3 > 1.7976931348623157e308 then
		v3 = 1.7976931348623157e308
	end
	if v2[1] == 0 or v3 <= 0 then
		return 0
	end
	return math.floor((math.log10(v3 + 1) + 1) * 291262135922330) * p1[1]
end
function t.lbencodePrecise(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	local v2 = t.add({ 1, p1[2] }, { 1, 0 })
	if v2[2] ~= v2[2] then
		return 0
	end
	local v3 = v2[2]
	if v3 > 1.7976931348623157e308 then
		v3 = 1.7976931348623157e308
	end
	if v2[1] == 0 or v3 <= 0 then
		return 0
	end
	return math.floor((math.log10(v3 + 1) + 1) * 4503599627370496 * p1[1])
end
function t.lbdecode(p1) 
	if p1 == 0 then
		return table.clone(t.ZERO)
	end
	local v1 = math.sign(p1)
	return { v1, t.sub({ 1, 10 ^ (math.abs(p1) / 291262135922330 - 1) - 1 }, { 1, 0 })[2] }
end
function t.lbdecodePrecise(p1) 
	if p1 == 0 then
		return table.clone(t.ZERO)
	end
	local v1 = math.sign(p1)
	return { v1, t.sub({ 1, 10 ^ (math.abs(p1) / 4503599627370496 - 1) - 1 }, { 1, 0 })[2] }
end
function t.toScientific(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return "NaN"
	end
	if p1[1] == 0 then
		return "0e0"
	end
	local v22 = p1[1] == -1 and "-" or ""
	local v4 = math.floor(p1[2])
	return v22 .. math.round(10 ^ (p1[2] - v4) * v2) / v2 .. "e" .. v4
end
function t.toEngineer(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == -2 then
		return "NaN"
	end
	if p1[1] == 0 then
		return "0e0"
	end
	local v22 = p1[1] == -1 and "-" or ""
	local v4 = math.floor(p1[2])
	local v5 = v4 - v4 % 3
	return v22 .. math.round(10 ^ (p1[2] - v5) * v2) / v2 .. "e" .. v5
end
local t7 = { "k", "M", "B" }
local t8 = {
	"",
	"U",
	"D",
	"T",
	"Qd",
	"Qn",
	"Sx",
	"Sp",
	"Oc",
	"No"
}
local t9 = {
	"",
	"De",
	"Vt",
	"Tg",
	"qg",
	"Qg",
	"sg",
	"Sg",
	"Og",
	"Ng"
}
local t10 = {
	"",
	"Ce",
	"Du",
	"Tr",
	"Qa",
	"Qi",
	"Se",
	"Si",
	"Ot",
	"Ni"
}
local t11 = {
	"Mi",
	"Mc",
	"Na",
	"Pi",
	"Fm",
	"At",
	"Zp",
	"Yc",
	"Xo",
	"Ve",
	"Me",
	"Due",
	"Tre",
	"Te",
	"Pt",
	"He",
	"Hp",
	"Oct",
	"En",
	"Ic",
	"Mei",
	"Dui",
	"Tri",
	"Teti",
	"Pti",
	"Hei",
	"Hp",
	"Oci",
	"Eni",
	"Tra",
	"TeC",
	"MTc",
	"DTc",
	"TrTc",
	"TeTc",
	"PeTc",
	"HTc",
	"HpT",
	"OcT",
	"EnT",
	"TetC",
	"MTetc",
	"DTetc",
	"TrTetc",
	"TeTetc",
	"PeTetc",
	"HTetc",
	"HpTetc",
	"OcTetc",
	"EnTetc",
	"PcT",
	"MPcT",
	"DPcT",
	"TPCt",
	"TePCt",
	"PePCt",
	"HePCt",
	"HpPct",
	"OcPct",
	"EnPct",
	"HCt",
	"MHcT",
	"DHcT",
	"THCt",
	"TeHCt",
	"PeHCt",
	"HeHCt",
	"HpHct",
	"OcHct",
	"EnHct",
	"HpCt",
	"MHpcT",
	"DHpcT",
	"THpCt",
	"TeHpCt",
	"PeHpCt",
	"HeHpCt",
	"HpHpct",
	"OcHpct",
	"EnHpct",
	"OCt",
	"MOcT",
	"DOcT",
	"TOCt",
	"TeOCt",
	"PeOCt",
	"HeOCt",
	"HpOct",
	"OcOct",
	"EnOct",
	"Ent",
	"MEnT",
	"DEnT",
	"TEnt",
	"TeEnt",
	"PeEnt",
	"HeEnt",
	"HpEnt",
	"OcEnt",
	"EnEnt",
	"Hect",
	"MeHect"
}
local function lowTier(p1) 
	return t8[p1 % 10 + 1] .. t9[math.floor(p1 / 10) % 10 + 1] .. t10[math.floor(p1 / 100) % 10 + 1]
end
local function highTier(p1) 
	local v1 = ""
	for v2, v3 in t11 do
		local v4 = 10 ^ (v2 * 3 - 3)
		if p1 < v4 then
			break
		end
		local v5 = math.floor(p1 / v4) % 1000
		if v5 > 0 then
			if v5 == 1 then
				v5 = 0
			end
			v1 = (t8[v5 % 10 + 1] .. t9[math.floor(v5 / 10) % 10 + 1] .. t10[math.floor(v5 / 100) % 10 + 1]) .. v3 .. v1
		end
	end
	return v1
end
function t.toSuffix(p1) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	if p1[1] == 0 then
		return "0"
	end
	if p1[1] == -2 then
		return "NaN"
	end
	if p1[2] == (1 / 0) then
		return "inf"
	end
	if p1[2] >= 45 or p1[2] >= 3 and ShouldUseScientific() then
		return t.toScientific(p1)
	end
	if p1[2] < 0 then
		local v3 = math.round(10 ^ p1[2] * v2) / v2
		if v3 == 0 then
			return "0"
		end
		return (p1[1] == -1 and "-" or "") .. v3
	end
	p1[2] = math.round(p1[2] * 100000000000) / 100000000000
	local v6 = math.floor((p1[2] - 3) / 3)
	local v8 = math.floor(p1[2])
	local v10 = math.round(10 ^ (p1[2] - (v8 - v8 % 3)) * v2) / v2
	if v10 == 0 then
		return "0"
	end
	local v11 = p1[1] == -1 and "-" or ""
	if not (v6 < 1000) then
		local v12 = v6 % 1000
		return v11 .. v10 .. highTier(math.floor(v6 / 1000)) .. t8[v12 % 10 + 1] .. t9[math.floor(v12 / 10) % 10 + 1] .. t10[math.floor(v12 / 100) % 10 + 1]
	end
	if v6 < 3 then
		return v11 .. v10 .. (t7[v6 + 1] or "")
	end
	return v11 .. v10 .. t8[v6 % 10 + 1] .. t9[math.floor(v6 / 10) % 10 + 1] .. t10[math.floor(v6 / 100) % 10 + 1]
end
function t.roundMantissa(p1, p2) 
	if type(p1) ~= "table" then
		p1 = t.toBN(p1)
	end
	local v3 = math.round(10 ^ (p1[2] % 1 + p2)) / 10 ^ p2
	local t2 = {}
	t2[1] = p1[1]
	t2[2] = math.floor(p1[2]) + math.log10(v3)
	return t2
end
function t.map(p1, p2, p3, p4, p5) 
	local v1 = t.sub(p1, p2)
	local v2 = t.sub(p5, p4)
	local v3 = t.sub(p3, p2)
	return t.add(t.div(t.mul(v1, v2), v3), p4)
end
return t
end)()
local _Module_Ascend = (function()
    local t = {
        Currency = "Taps",
        Tiers = {
            { Price = 10000 },
            { Price = 250000 },
            { Price = 2000000 },
            { Price = 50000000 },
            { Price = 150000000 },
            { Price = 5000000000 },
            { Price = 50000000000 },
            { Price = 1000000000000 },
            { Price = 25000000000000 },
            { Price = 1000000000000000 },
            { Price = 2.5e16 },
            { Price = 5e18 },
            { Price = 5e19 },
            { Price = 2.5e22 },
            { Price = 2.5e26 },
            { Price = 1e28 },
            { Price = 5e29 },
        }
    }
    return t
end)()
local _Module_Runes = (function()
return {
	Basic = {
		Price = 150,
		Currency = "Charge",
		Rewards = {
			{
				Title = "Common",
				Chance = 0.6,
				Color = Color3.fromRGB(224, 224, 224),
				Rewards = {
					{
						Title = "Taps",
						Max = 2.5,
						Boost = function(p1) 
							return p1 * 0.025 + 1
						end
					}
				}
			},
			{
				Title = "Uncommon",
				Chance = 0.24949,
				Color = Color3.fromRGB(78, 255, 73),
				Rewards = {
					{
						Title = "Charge",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					}
				}
			},
			{
				Title = "Rare",
				Chance = 0.1,
				Color = Color3.fromRGB(58, 152, 255),
				Rewards = {
					{
						Title = "XP",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					}
				}
			},
			{
				Title = "Epic",
				Chance = 0.04,
				Color = Color3.fromRGB(237, 74, 255),
				Rewards = {
					{
						Title = "Taps",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Charge",
						Max = 2.5,
						Boost = function(p1) 
							return p1 * 0.005 + 1
						end
					}
				}
			},
			{
				Title = "Legendary",
				Chance = 0.0095,
				Color = Color3.fromRGB(255, 194, 53),
				Rewards = {
					{
						Title = "Taps",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Boss Damage",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.005 + 1
						end
					}
				}
			},
			{
				Title = "Mythical",
				Chance = 0.0005,
				Color = Color3.fromRGB(255, 99, 163),
				Rewards = {
					{
						Title = "Rune Luck",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Bones",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.005 + 1
						end
					}
				}
			},
			{
				Title = "Divine",
				Chance = 0.00001,
				Secret = true,
				Color = Color3.fromRGB(163, 176, 255),
				Rewards = {
					{
						Title = "Charge",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Rune Bulk",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.015 + 1
						end
					}
				}
			}
		}
	},
	Color = {
		Price = 5,
		Currency = "Copper",
		RequiredAscension = 0,
		UnlockStat = "Layer",
		UnlockAmount = 1,
		Rewards = {
			{
				Title = "Red",
				Chance = 0.55,
				Color = Color3.fromRGB(255, 75, 75),
				Rewards = {
					{
						Title = "Mining Damage",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.002 + 1
						end
					},
					{
						Title = "Apple",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.005 + 1
						end
					}
				}
			},
			{
				Title = "Green",
				Chance = 0.25,
				Color = Color3.fromRGB(78, 255, 73),
				Rewards = {
					{
						Title = "More Ores",
						Max = 2.5,
						Boost = function(p1) 
							return p1 * 0.005 + 1
						end
					},
					{
						Title = "Orange",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.004 + 1
						end
					}
				}
			},
			{
				Title = "Blue",
				Chance = 0.12,
				Color = Color3.fromRGB(58, 152, 255),
				Rewards = {
					{
						Title = "Mining Speed",
						Max = 1.5,
						Boost = function(p1) 
							return p1 * 0.003 + 1
						end
					},
					{
						Title = "Banana",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.005 + 1
						end
					}
				}
			},
			{
				Title = "Purple",
				Chance = 0.06,
				Color = Color3.fromRGB(237, 74, 255),
				Rewards = {
					{
						Title = "Coins",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.003 + 1
						end
					},
					{
						Title = "Grape",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.005 + 1
						end
					}
				}
			},
			{
				Title = "Yellow",
				Chance = 0.018,
				Color = Color3.fromRGB(255, 224, 75),
				Rewards = {
					{
						Title = "More Ores",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.012 + 1
						end
					},
					{
						Title = "Mining Damage",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.012 + 1
						end
					}
				}
			},
			{
				Title = "Pink",
				Chance = 0.0019,
				Color = Color3.fromRGB(255, 99, 163),
				Rewards = {
					{
						Title = "XP",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					},
					{
						Title = "Coins",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					}
				}
			},
			{
				Title = "Cyan",
				Chance = 0.00009,
				Secret = true,
				Color = Color3.fromRGB(95, 224, 255),
				Rewards = {
					{
						Title = "Fruits",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					}
				}
			},
			{
				Title = "White",
				Chance = 9e-6,
				Secret = true,
				Color = Color3.fromRGB(255, 255, 255),
				Rewards = {
					{
						Title = "More Ores",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Rune Luck",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					}
				}
			},
			{
				Title = "Black",
				Chance = 1e-6,
				Secret = true,
				Color = Color3.fromRGB(45, 45, 55),
				Rewards = {
					{
						Title = "XP",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Rune Bulk",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.05 + 1
						end
					}
				}
			}
		}
	},
	Circuit = {
		Price = 75000,
		Currency = "Cash",
		UnlockStat = "Tier",
		UnlockAmount = 5,
		Rewards = {
			{
				Title = "Wire",
				Chance = 0.55,
				Color = Color3.fromRGB(85, 255, 120),
				Rewards = {
					{
						Title = "Cash",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.004 + 1
						end
					}
				}
			},
			{
				Title = "Battery",
				Chance = 0.25,
				Color = Color3.fromRGB(255, 92, 92),
				Rewards = {
					{
						Title = "Power",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.004 + 1
						end
					}
				}
			},
			{
				Title = "Sensor",
				Chance = 0.12,
				Color = Color3.fromRGB(184, 107, 255),
				Rewards = {
					{
						Title = "Rarity Luck",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.004 + 1
						end
					},
					{
						Title = "Bones",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.0002 + 1
						end
					}
				}
			},
			{
				Title = "Chip",
				Chance = 0.06,
				Color = Color3.fromRGB(59, 167, 255),
				Rewards = {
					{
						Title = "Cash",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					},
					{
						Title = "Power",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					}
				}
			},
			{
				Title = "Processor",
				Chance = 0.018,
				Color = Color3.fromRGB(255, 216, 74),
				Rewards = {
					{
						Title = "More Ores",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Rarity Luck",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					}
				}
			},
			{
				Title = "Core",
				Chance = 0.0019,
				Color = Color3.fromRGB(255, 99, 163),
				Rewards = {
					{
						Title = "Power",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Rarity Luck",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					}
				}
			},
			{
				Title = "Reactor",
				Chance = 0.00009,
				Secret = true,
				Color = Color3.fromRGB(255, 135, 58),
				Rewards = {
					{
						Title = "Cash",
						Max = 10,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					}
				}
			},
			{
				Title = "Mainframe",
				Chance = 9e-6,
				Secret = true,
				Color = Color3.fromRGB(95, 224, 255),
				Rewards = {
					{
						Title = "Power",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Rarity Luck",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					}
				}
			},
			{
				Title = "Singularity",
				Chance = 1e-6,
				Secret = true,
				Color = Color3.fromRGB(55, 56, 76),
				Rewards = {
					{
						Title = "Cash",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Power",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Rarity Luck",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					}
				}
			}
		}
	},
	Reef = {
		Price = 1000,
		Currency = "Pearls",
		RequiredAscension = 0,
		UnlockStat = "Highest Fire",
		UnlockAmount = 15000000,
		Rewards = {
			{
				Title = "Shell",
				Chance = 0.63,
				Color = Color3.fromRGB(255, 224, 178),
				Rewards = {
					{
						Title = "Fire",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.001 + 1
						end
					}
				}
			},
			{
				Title = "Kelp",
				Chance = 0.23,
				Color = Color3.fromRGB(78, 180, 73),
				Rewards = {
					{
						Title = "Pearls",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.001 + 1
						end
					}
				}
			},
			{
				Title = "Starfish",
				Chance = 0.09,
				Color = Color3.fromRGB(255, 150, 60),
				Rewards = {
					{
						Title = "Fishing Luck",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.002 + 1
						end
					}
				}
			},
			{
				Title = "Anemone",
				Chance = 0.035,
				Color = Color3.fromRGB(255, 120, 180),
				Rewards = {
					{
						Title = "Fire",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.004 + 1
						end
					},
					{
						Title = "Pearls",
						Max = 2.5,
						Boost = function(p1) 
							return p1 * 0.003 + 1
						end
					}
				}
			},
			{
				Title = "Jellyfish",
				Chance = 0.009,
				Color = Color3.fromRGB(190, 150, 255),
				Rewards = {
					{
						Title = "Pearls",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					},
					{
						Title = "Coral",
						Max = 1.5,
						Boost = function(p1) 
							return p1 * 0.003 + 1
						end
					}
				}
			},
			{
				Title = "Seahorse",
				Chance = 0.0013,
				Color = Color3.fromRGB(255, 210, 90),
				Rewards = {
					{
						Title = "Fishing Luck",
						Max = 3,
						Boost = function(p1) 
							return p1 * 0.006 + 1
						end
					},
					{
						Title = "Coral",
						Max = 1.75,
						Boost = function(p1) 
							return p1 * 0.004 + 1
						end
					}
				}
			},
			{
				Title = "Nautilus",
				Chance = 0.00006,
				Secret = true,
				Color = Color3.fromRGB(95, 224, 255),
				Rewards = {
					{
						Title = "Fire",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Pearls",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.008 + 1
						end
					}
				}
			},
			{
				Title = "Leviathan",
				Chance = 5e-6,
				Secret = true,
				Color = Color3.fromRGB(60, 90, 200),
				Rewards = {
					{
						Title = "Fire",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Pearls",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Coral",
						Max = 2,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					}
				}
			},
			{
				Title = "Kraken",
				Chance = 5e-7,
				Secret = true,
				Color = Color3.fromRGB(40, 45, 70),
				Rewards = {
					{
						Title = "Fire",
						Max = 7,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Pearls",
						Max = 7,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Coral",
						Max = 2.5,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Fishing Luck",
						Max = 4,
						Boost = function(p1) 
							return p1 * 0.02 + 1
						end
					},
					{
						Title = "Rune Luck",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.01 + 1
						end
					},
					{
						Title = "Rune Bulk",
						Max = 5,
						Boost = function(p1) 
							return p1 * 0.05 + 1
						end
					}
				}
			}
		}
	}
}
end)()
local _Module_Ores = (function()
return {
	StoneSmall = {
		DisplayName = "Small Stone",
		Ore = "Stone",
		Tier = 1,
		HP = 10,
		Reward = 1,
		RequiredPickaxe = 1,
		Currency = "Stone"
	},
	StoneBig = {
		DisplayName = "Big Stone",
		Ore = "Stone",
		Tier = 2,
		HP = 25,
		Reward = 2,
		RequiredPickaxe = 2,
		Currency = "Stone"
	},
	StoneGiant = {
		DisplayName = "Giant Stone",
		Ore = "Stone",
		Tier = 3,
		HP = 100,
		Reward = 6,
		RequiredPickaxe = 3,
		Currency = "Stone"
	},
	CoalSmall = {
		DisplayName = "Small Coal",
		Ore = "Coal",
		Tier = 1,
		HP = 150,
		Reward = 0.2,
		RequiredPickaxe = 4,
		Currency = "Coal"
	},
	CoalBig = {
		DisplayName = "Big Coal",
		Ore = "Coal",
		Tier = 2,
		HP = 600,
		Reward = 0.5,
		RequiredPickaxe = 5,
		Currency = "Coal"
	},
	CoalGiant = {
		DisplayName = "Giant Coal",
		Ore = "Coal",
		Tier = 3,
		HP = 3000,
		Reward = 2,
		RequiredPickaxe = 6,
		Currency = "Coal"
	},
	CopperSmall = {
		DisplayName = "Small Copper",
		Ore = "Copper",
		Tier = 1,
		HP = 1200,
		Reward = 0.13333333333333333,
		RequiredPickaxe = 7,
		Currency = "Copper"
	},
	CopperBig = {
		DisplayName = "Big Copper",
		Ore = "Copper",
		Tier = 2,
		HP = 3000,
		Reward = 0.26666666666666666,
		RequiredPickaxe = 8,
		Currency = "Copper"
	},
	CopperGiant = {
		DisplayName = "Giant Copper",
		Ore = "Copper",
		Tier = 3,
		HP = 8000,
		Reward = 0.5,
		RequiredPickaxe = 9,
		Currency = "Copper"
	},
	GoldSmall = {
		DisplayName = "Small Gold",
		Ore = "Gold",
		Tier = 1,
		HP = 7200,
		Reward = 0.06666666666666667,
		RequiredPickaxe = 10,
		Currency = "Gold"
	},
	GoldBig = {
		DisplayName = "Big Gold",
		Ore = "Gold",
		Tier = 2,
		HP = 27000,
		Reward = 0.2,
		RequiredPickaxe = 11,
		Currency = "Gold"
	},
	GoldGiant = {
		DisplayName = "Giant Gold",
		Ore = "Gold",
		Tier = 3,
		HP = 96000,
		Reward = 0.5,
		RequiredPickaxe = 12,
		Currency = "Gold"
	},
	DiamondSmall = {
		DisplayName = "Small Diamond",
		Ore = "Diamond",
		Tier = 1,
		HP = 57600,
		Reward = 0.022222222222222223,
		RequiredPickaxe = 13,
		Currency = "Diamonds"
	},
	DiamondBig = {
		DisplayName = "Big Diamond",
		Ore = "Diamond",
		Tier = 2,
		HP = 216000,
		Reward = 0.08888888888888889,
		RequiredPickaxe = 14,
		Currency = "Diamonds"
	},
	DiamondGiant = {
		DisplayName = "Giant Diamond",
		Ore = "Diamond",
		Tier = 3,
		HP = 768000,
		Reward = 0.16666666666666666,
		RequiredPickaxe = 15,
		Currency = "Diamonds"
	}
}
end)()
local _Module_OreSellValues = (function()
return {
	Stone = {
		Value = 1,
		Order = 1
	},
	Coal = {
		Value = 60,
		Order = 2
	},
	Copper = {
		Value = 300,
		Order = 3
	},
	Gold = {
		Value = 1750,
		Order = 4
	},
	Diamonds = {
		Value = 10000,
		Order = 5
	}
}
end)()
local _Module_Sacrifice = (function(BigNum)
    local t = {
        Currency = "SacrificePoints",
        RequirementCurrency = "Bones",
        MinBones = 10000,
        BonesPerPoint = 500,
    }
    function t.GetReward(p1)
        return math.floor(BigNum.toNumber(BigNum.toBN(p1)) / t.BonesPerPoint + 1e-6)
    end
    function t.CanSacrifice(p1)
        return BigNum.gte(p1, t.MinBones)
    end
    return t
end)(_Module_BigNum)
local _Module_Pickaxes = (function()
return {
	{
		Name = "Wooden Pickaxe",
		Damage = 5,
		Cooldown = 1,
		Boosts = {}
	},
	{
		Name = "Stone Pickaxe",
		Damage = 10,
		Cooldown = 1.03,
		Price = 20,
		Boosts = {}
	},
	{
		Name = "Golden Pickaxe",
		Damage = 20,
		Cooldown = 1.05,
		CoinsBoost = 1.25,
		Price = 75,
		Boosts = {}
	},
	{
		Name = "Diamond Pickaxe",
		Damage = 35,
		Cooldown = 1.08,
		CoinsBoost = 1.5,
		Price = 1000,
		Boosts = {}
	},
	{
		Name = "Petal Pickaxe",
		Damage = 50,
		Cooldown = 1.1,
		CoinBoost = 1.1,
		Price = 3000,
		Boosts = {}
	},
	{
		Name = "Moonclaw Digger",
		Damage = 75,
		Cooldown = 1.13,
		CoinBoost = 1.2,
		Price = 10000,
		Boosts = {}
	},
	{
		Name = "Sunstone Pickaxe",
		Damage = 105,
		Cooldown = 1.15,
		CoinBoost = 1.3,
		Price = 30000,
		Boosts = {}
	},
	{
		Name = "Icewing Pick",
		Damage = 140,
		Cooldown = 1.18,
		CoinBoost = 1.4,
		Price = 60000,
		Boosts = {}
	},
	{
		Name = "Toxic Fang",
		Damage = 180,
		Cooldown = 1.2,
		CoinBoost = 1.5,
		Price = 125000,
		Boosts = {}
	},
	{
		Name = "Frostbite Pickaxe",
		Damage = 230,
		Cooldown = 1.23,
		CoinBoost = 1.6,
		Price = 250000,
		Boosts = {}
	},
	{
		Name = "Solar Spire",
		Damage = 290,
		Cooldown = 1.25,
		CoinBoost = 1.7,
		Price = 500000,
		Boosts = {}
	},
	{
		Name = "Amethyst Wing",
		Damage = 360,
		Cooldown = 1.28,
		CoinBoost = 1.8,
		Price = 1500000,
		Boosts = {}
	},
	{
		Name = "Glacier Core",
		Damage = 440,
		Cooldown = 1.3,
		CoinBoost = 1.9,
		OreBoost = 1.2,
		Price = 7500000,
		Boosts = {}
	},
	{
		Name = "Voidpiercer",
		Damage = 535,
		Cooldown = 1.33,
		CoinBoost = 2,
		OreBoost = 1.35,
		Price = 100000000,
		Boosts = {}
	},
	{
		Name = "Frostfang Shard",
		Damage = 650,
		Cooldown = 1.35,
		CoinBoost = 2.1,
		OreBoost = 1.55,
		Price = 750000000,
		Boosts = {}
	}
}
end)()
local _Module_Swords = (function()
    return {
        Currency = "Bones",
        Tiers = {
            { Name = "WoodSword",         Price = 0 },
            { Name = "ChippedStoneSword", Price = 500 },
            { Name = "IronSword",         Price = 1500 },
            { Name = "EmeraldSword",      Price = 5000 },
            { Name = "GoldCutlass",       Price = 15000 },
            { Name = "CrystalBlade",      Price = 50000 },
            { Name = "EtheralSword",      Price = 250000 },
            { Name = "DiamondGreatSword", Price = 1250000 },
            { Name = "ThunderBlade",      Price = 6500000 },
            { Name = "DazzlingBlade",     Price = 35000000 },
        }
    }
end)()
local _Module_FishingRods = (function()
return {
	{
		Name = "Fishing Rod",
		Model = "FishingRod",
		LuckBoost = 1,
		Cooldown = 2
	},
	{
		Name = "Ancient Rod",
		Model = "AncientRod",
		LuckBoost = 1.25,
		Cooldown = 1.9,
		Price = 1000
	},
	{
		Name = "Golden Rod",
		Model = "GoldenRod",
		LuckBoost = 1.55,
		Cooldown = 1.8,
		Price = 5000,
		PearlBoost = 1.1
	},
	{
		Name = "Bone Rod",
		Model = "BoneRod",
		LuckBoost = 1.9,
		Cooldown = 1.7,
		Price = 15000,
		PearlBoost = 1.2
	},
	{
		Name = "Ice Rod",
		Model = "IceRod",
		LuckBoost = 2.3,
		Cooldown = 1.6,
		Price = 50000,
		PearlBoost = 1.3
	},
	{
		Name = "Clover Rod",
		Model = "CloverRod",
		LuckBoost = 2.8,
		Cooldown = 1.5,
		Price = 200000,
		PearlBoost = 1.4
	},
	{
		Name = "Bamboo Rod",
		Model = "BambooRod",
		LuckBoost = 3.4,
		Cooldown = 1.4,
		Price = 500000,
		PearlBoost = 1.5
	},
	{
		Name = "Magma Rod",
		Model = "MagmaRod",
		LuckBoost = 4.1,
		Cooldown = 1.3,
		Price = 1500000,
		PearlBoost = 1.6
	},
	{
		Name = "Crystalic Rod",
		Model = "CrystalicRod",
		LuckBoost = 5,
		Cooldown = 1.2,
		Price = 5000000,
		PearlBoost = 1.7
	},
	{
		Name = "Celestial Rod",
		Model = "CelestialRod",
		LuckBoost = 6.5,
		Cooldown = 1.1,
		Price = 20000000,
		PearlBoost = 1.8
	},
	{
		Name = "Trident Rod",
		Model = "TridentRod",
		LuckBoost = 8,
		Cooldown = 1,
		Price = 100000000,
		PearlBoost = 1.9
	},
	{
		Name = "Chrono Rod",
		Model = "ChronoRod",
		LuckBoost = 9.5,
		Cooldown = 0.9,
		Price = 1000000000,
		PearlBoost = 2
	},
	{
		Name = "Eclipse Rod",
		Model = "EclipseRod",
		LuckBoost = 11,
		Cooldown = 0.8,
		Price = 15000000000,
		PearlBoost = 2.1
	}
}
end)()
local _Module_Generators = (function(BigNum)
    local t = { Currency = "Power" }
    local function MkPrice(base, exp)
        return function(p1)
            return BigNum.floor(BigNum.add(BigNum.mul(base, BigNum.pow(exp, p1)), 1e-6))
        end
    end
    t.Generators = {
        { Name = "Generator 1", BuyCurrency = "Cash", Price = MkPrice(250,     1.45) },
        { Name = "Generator 2", BuyCurrency = "Cash", Price = MkPrice(1500,    1.58) },
        { Name = "Generator 3", BuyCurrency = "Cash", Price = MkPrice(10000,   1.72) },
        { Name = "Generator 4", BuyCurrency = "Cash", Price = MkPrice(75000,   1.86) },
        { Name = "Generator 5", BuyCurrency = "Cash", Price = MkPrice(1000000, 2)    },
    }
    return t
end)(_Module_BigNum)
local _Module_Layers = (function()
    local t = {
        Currency = "Coins",
        MaxLayer = 15,
    }
    function t.GetPrice(p1)
        if p1 == 0 then return 100000 end
        if p1 == 1 then return 750000 end
        if p1 == 2 then return 10000000 end
        if p1 == 3 then return 750000000 end
        if p1 == 4 then return 15000000000 end
        return math.floor(25 ^ (p1 - 5) * 200000000000)
    end
    return t
end)()
local _Module_Tiers = (function()
    local t = {
        { Currency = "Coins",    Price = 100000000 },
        { Currency = "Grape",    Price = 1000 },
        { Currency = "Diamonds", Price = 10000 },
        { Currency = "Taps",     Price = 7.5e17 },
        { Currency = "Power",    Price = 750000 },
        { Currency = "Bones",    Price = 10000000000 },
        { Currency = "Coins",    Price = 100000000000000 },
        { Currency = "Orange",   Price = 1000000 },
        { Currency = "Taps",     Price = 1e23 },
        { Currency = "Cash",     Price = 25000000000 },
        { Currency = "Fire",     Price = 1000000 },
        { Currency = "Pearls",   Price = 4000000 },
        { Currency = "Pearls",   Price = 50000000000 },
        { Currency = "Taps",     Price = 1e30 },
    }
    function t.GetTier(p1)
        return t[p1]
    end
    return t
end)()
local _Module_Overclock = (function(BigNum)
    local t = {
        RequirementCurrency = "Power",
    }
    function t.GetRequirement(p1)
        return BigNum.toString(BigNum.floor(BigNum.mul(100000, BigNum.pow(10, p1))))
    end
    return t
end)(_Module_BigNum)
local _Module_Fire = (function()
    local t = {
        RequirementCurrency = "Charge",
        MinCharge = 1000000,
        ChargePerFire = 1000000,
    }
    function t.GetChargePerFire(plr)
        local cPF = t.ChargePerFire
        if plr and _G.__TI_Framework then
            local ok, v = pcall(_G.__TI_Framework.Stat.Get, plr, "TreeCheaperFire")
            if ok and v and v.Value >= 1 then cPF = cPF / 2 end
        end
        return cPF
    end
    function t.GetReward(p1, p2)
        return math.floor(p1 / t.GetChargePerFire(p2))
    end
    return t
end)()
local _Module_Coral = (function(BigNum)
    local t = {
        RequirementCurrency = "Pearls",
        MinPearls = 1000000,
        PearlsPerPoint = 25000,
    }
    function t.GetReward(p1)
        return math.floor(BigNum.toNumber(BigNum.toBN(p1)) / t.PearlsPerPoint + 1e-6)
    end
    function t.CanConvert(p1)
        return BigNum.gte(p1, t.MinPearls)
    end
    return t
end)(_Module_BigNum)
local Modules = {
    Framework     = require(RS.Framework),
    BigNum        = _Module_BigNum,
    Ascend        = _Module_Ascend,
    UpgradeTree   = require(RS.Modules.Shared.UpgradeTree),
    Runes         = _Module_Runes,
    Ores          = _Module_Ores or {},
    OreSellValues = _Module_OreSellValues or {},
    Sacrifice     = _Module_Sacrifice,
    Pickaxes      = _Module_Pickaxes or {},
    Swords        = _Module_Swords or {},
    FishingRods   = _Module_FishingRods or {},
    Generators    = _Module_Generators or {},
    Layers        = _Module_Layers,
    Tiers         = _Module_Tiers,
    Overclock     = _Module_Overclock,
    Fire          = _Module_Fire,
    Coral         = _Module_Coral,
    Multipliers   = require(RS.Modules.Shared.Multipliers),
}
_G.__TI_Framework = Modules.Framework
local UpgradeMods = RS.Modules.Shared.Upgrades
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
    local lastChar = nil
    local noclipParts = {}
    while Toggles.Noclip.Value do
        RunService.Stepped:Wait()
        local char = GetCharacter()
        if char ~= lastChar then
            lastChar = char
            noclipParts = {}
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(noclipParts, part)
                    end
                end
            end
        end
        for _, part in ipairs(noclipParts) do
            if part.CanCollide then
                part.CanCollide = false
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
local function ToNum(v)
    if type(v) == "number" then return v end
    if v == nil then return 0 end
    local n = tonumber(tostring(v))
    if n then return n end
    local BigNum = Modules.BigNum
    if BigNum and BigNum.toNumber then
        local ok, res = pcall(BigNum.toNumber, v)
        if ok and type(res) == "number" then return res end
    end
    return 0
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
local function Func_AutoClick()
    local fw = Modules.Framework
    while true do
        fw.Network.Fire("Tap")
        task.wait()
    end
end
local _CachedUpgradeMods = nil
local function GetCachedUpgradeMods()
    if _CachedUpgradeMods then return _CachedUpgradeMods end
    _CachedUpgradeMods = {}
    for _, modScript in UpgradeMods:GetChildren() do
        if modScript:IsA("ModuleScript") and modScript.Name ~= "RobuxTree" then
            local ok, mod = pcall(require, modScript)
            if ok and mod and mod.Upgrades then
                table.insert(_CachedUpgradeMods, { name = modScript.Name, mod = mod })
            end
        end
    end
    return _CachedUpgradeMods
end
local function Func_AutoUpgrade()
    local fw = Modules.Framework
    while true do
        local cached = GetCachedUpgradeMods()
        for _, entry in cached do
            if not Toggles.AutoUpgrade.Value then break end
            local modName, mod = entry.name, entry.mod
            for upgName, upgData in mod.Upgrades do
                if not Toggles.AutoUpgrade.Value then break end
                local currencyName = mod.Currency or upgData.Currency
                local currencyStat = fw.Stat.Get(currencyName)
                if currencyStat then
                    local levelStat = fw.Stat.Get(Plr, modName .. upgName)
                    if levelStat then
                        local level = levelStat.Value
                        local ok3, maxVal = pcall(upgData.Max)
                        if ok3 and level < maxVal then
                            local ok4, price = pcall(upgData.Price, level)
                            if ok4 and fw.Currency.CanAfford(currencyStat, price) then
                                fw.Network.Fire("BuyUpgrade", modName, upgName, "Max")
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoUpgradeTree()
    local fw   = Modules.Framework
    local tree = Modules.UpgradeTree
    while true do
        local levelStat = fw.Stat.Get("Level")
        if levelStat then
            for upgName, upgData in pairs(tree) do
                if not Toggles.AutoUpgrade.Value then break end
                local requiredLevel = (upgData.UnlockLevel ~= nil) and upgData.UnlockLevel or 9
                if requiredLevel <= levelStat.Value then
                    local okU, unlocked = pcall(upgData.Unlocked, Plr)
                    if okU and unlocked then
                        local levelStatInst = fw.Stat.Get(Plr, upgName)
                        if levelStatInst then
                            local okCap, cap = pcall(upgData.Cap, Plr)
                            if okCap and levelStatInst.Value < cap then
                                local okPrice, price = pcall(upgData.Price, Plr)
                                if okPrice then
                                    local currencyStat = fw.Stat.Get(upgData.Currency)
                                    if currencyStat and fw.Currency.CanAfford(currencyStat, price) then
                                        fw.Network.Fire("BuyUpgrade", upgData.ModuleName or "Tree", upgName, "Single")
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoAscend()
    local fw = Modules.Framework
    local ascendMod = Modules.Ascend
    while true do
        local ok, ascStat = pcall(function() return fw.Stat.Get("Ascension") end)
        if ok and ascStat then
            local nextTier = ascendMod.Tiers[ascStat.Value + 1]
            if nextTier then
                local currency = nextTier.Currency or ascendMod.Currency
                local ok2, currStat = pcall(function() return fw.Stat.Get(currency) end)
                if ok2 and currStat and fw.Currency.CanAfford(currStat, nextTier.Price) then
                    fw.Network.Fire("Ascend")
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoBuyRune()
    local fw = Modules.Framework
    local runes = Modules.Runes
    while true do
        local okAsc, ascStat = pcall(fw.Stat.Get, "Ascension")
        if okAsc and ascStat then
            for runeName, runeData in runes do
                if not Toggles.AutoBuyRune.Value then break end
                if type(runeData) == "table" then
                    local unlocked = ascStat.Value >= (tonumber(runeData.RequiredAscension) or 4)
                    if unlocked and runeData.UnlockStat then
                        local okU, unlockStat = pcall(fw.Stat.Get, tostring(runeData.UnlockStat))
                        unlocked = okU and unlockStat and (tonumber(runeData.UnlockAmount) or 1) <= unlockStat.Value
                    end
                    if unlocked then
                        local okC, currencyStat = pcall(fw.Stat.Get, runeData.Currency)
                        if okC and currencyStat and fw.Currency.CanAfford(currencyStat, runeData.Price) then
                            fw.Network.Fire("BuyRune", runeName)
                            task.wait(0.01)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end
local function Func_AutoCollectFruit()
    local ClientFruits = workspace:WaitForChild("ClientFruits")
    while Toggles.AutoCollectFruit.Value do
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local best, bestPart, bestDist = nil, nil, math.huge
            for _, fruitModel in ClientFruits:GetChildren() do
                if fruitModel:IsA("Model") then
                    local MainPart = fruitModel:FindFirstChild("MainPart")
                    if MainPart and MainPart:IsA("BasePart") then
                        local dist = (hrp.Position - MainPart.Position).Magnitude
                        if dist < bestDist then
                            best, bestPart, bestDist = fruitModel, MainPart, dist
                        end
                    end
                end
            end
            if best and bestPart then
                repeat
                    if not Toggles.AutoCollectFruit.Value then break end
                    if bestPart and bestPart.Parent and best.Parent then
                        hrp.CFrame = CFrame.new(bestPart.Position)
                    end
                    task.wait()
                until (not bestPart.Parent) or (not best.Parent) or (not Toggles.AutoCollectFruit.Value)
            end
        end
        task.wait()
    end
end
local function Func_AutoTree()
    local ClientTrees = workspace:WaitForChild("ClientTrees", 10)
    if not ClientTrees then
        warn("[AutoTree] ClientTrees folder not found")
        return
    end
    while Toggles.AutoTree.Value do
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local best, bestDist = nil, math.huge
            for _, treeModel in ClientTrees:GetChildren() do
                if treeModel:IsA("Model") then
                    local pos = treeModel:GetPivot().Position
                    local dist = Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(pos.X, pos.Z)
                    local mag = dist.Magnitude
                    if mag < bestDist then
                        best, bestDist = treeModel, mag
                    end
                end
            end
            if best then
                local treePos = best:GetPivot().Position
                pcall(function() hrp.CFrame = CFrame.new(treePos + Vector3.new(0, 3, 3)) end)
                repeat task.wait() until (not Toggles.AutoTree.Value) or (not best.Parent)
            else
                task.wait(0.5)
            end
        end
        task.wait()
    end
end
local function Func_AutoMine()
    local fw = Modules.Framework
    local OresMod = Modules.Ores or {}
    local OresFolder = workspace:WaitForChild("Ores")
    local function OreKeyOf(oreModel)
        return oreModel:GetAttribute("OreKey") or oreModel.Name
    end
    local function GetPickaxeTier()
        local ok, stat = pcall(fw.Stat.Get, Plr, "PickaxeTier")
        return ok and stat and ToNum(stat.Value) or 0
    end
    local function IsOnCooldown(oreModel)
        local main = oreModel:FindFirstChild("Main")
        local billboard = main and main:FindFirstChild("OreBillboard")
        local bar = billboard and billboard:FindFirstChild("Bar")
        local amount = bar and bar:FindFirstChild("Amount")
        if amount and amount:IsA("TextLabel") then
            local text = amount.Text
            if text and text:match("s%s*$") then
                return true
            end
        end
        return false
    end
    while Toggles.AutoMine.Value do
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local minHP = ToNum((Options.AutoMineMinHP and Options.AutoMineMinHP.Value) or 0)
            local pickaxeTier = GetPickaxeTier()
            local best, bestDist = nil, math.huge
            for _, oreModel in OresFolder:GetChildren() do
                if oreModel:IsA("Model") and oreModel.Parent == OresFolder then
                    local oreKey = OreKeyOf(oreModel)
                    local oreData = OresMod[oreKey]
                    if oreData and pickaxeTier >= (oreData.RequiredPickaxe or 0) and not IsOnCooldown(oreModel) then
                        local maxHP = oreModel:GetAttribute("MaxHP")
                        if type(maxHP) ~= "number" then maxHP = oreData.HP end
                        if type(maxHP) == "number" and maxHP >= minHP then
                            local pos = oreModel:GetPivot().Position
                            local dist = (hrp.Position - pos).Magnitude
                            if dist < bestDist then
                                best, bestDist = oreModel, dist
                            end
                        end
                    end
                end
            end
            if best then
                pcall(function() hrp.CFrame = best:GetPivot() * CFrame.new(0, 2, 0) end)
                local startTime = tick()
                repeat
                    task.wait()
                until (not Toggles.AutoMine.Value) or (not best.Parent) or IsOnCooldown(best) or (tick() - startTime >= 3)
            else
                task.wait(0.1)
            end
        end
        task.wait()
    end
end
local function Func_AutoSell()
    local fw = Modules.Framework
    local OreSellValues = Modules.OreSellValues or {}
    local RingsFolder = workspace:WaitForChild("Rings")
    local function GetSellPosition()
        for _, name in ipairs({ "Sell", "Sell2" }) do
            local ring = RingsFolder:FindFirstChild(name)
            if ring then
                local hb = ring:FindFirstChild("Hitbox", true)
                if hb and hb:IsA("BasePart") then
                    return hb.Position, name
                end
                return ring:GetPivot().Position, name
            end
        end
        local bestPos, bestDist = nil, math.huge
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        for _, ring in RingsFolder:GetChildren() do
            local hb = ring:FindFirstChild("Hitbox", true)
            local pos = (hb and hb:IsA("BasePart")) and hb.Position or ring:GetPivot().Position
            local dist = hrp and (hrp.Position - pos).Magnitude or 0
            if dist < bestDist then
                bestPos, bestDist = pos, dist
            end
        end
        return bestPos, nil
    end
    local function GetTotalOres()
        local total = 0
        for statName in pairs(OreSellValues) do
            local ok, stat = pcall(fw.Stat.Get, statName)
            if ok and stat and type(stat.Value) == "number" then
                total = total + stat.Value
            end
        end
        return total
    end
    local function SellAllOres()
        local ok = pcall(function() fw.Network.Fire("SellOres", "All", "Sell") end)
        if not ok then
            pcall(function()
                local args = { "All", "Sell" }
                RS:WaitForChild("Remotes"):WaitForChild("SellOres"):InvokeServer(unpack(args))
            end)
        end
    end
    while Toggles.AutoSell.Value do
        local total = GetTotalOres()
        local threshold = ToNum((Options.AutoSellThreshold and Options.AutoSellThreshold.Value)) or 500
        if total >= threshold then
            local char = GetCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local sellPos, station = GetSellPosition()
            if hrp and sellPos then
                pcall(function() hrp.CFrame = CFrame.new(sellPos) * CFrame.new(0, 3, 0) end)
                task.wait(0.35)
                SellAllOres()
                notyuri(("[AutoSell] Sold all ores at %s (had %s ores)"):format(tostring(station or "Sell"), tostring(total)))
                task.wait(0.5)
            else
                SellAllOres()
                task.wait(1)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoSacrifice()
    local fw = Modules.Framework
    local Sacrifice = Modules.Sacrifice
    local function GetBones()
        local req = Sacrifice and Sacrifice.RequirementCurrency or "Bones"
        local ok, stat = pcall(fw.Stat.Get, req)
        return ok and stat and stat.Value or 0
    end
    local function CanSacrificeNow(bones)
        if not Sacrifice then return false end
        local ok, res = pcall(Sacrifice.CanSacrifice, bones)
        if ok then return res == true end
        if type(bones) == "number" then
            return bones >= (Sacrifice.MinBones or 10000)
        end
        return false
    end
    local function GetMinPointsGain()
        local raw = Options.AutoSacrificeMinPoints and Options.AutoSacrificeMinPoints.Value
        return ToNum(raw) or 0
    end
    while Toggles.AutoSacrifice.Value do
        local bones = GetBones()
        if CanSacrificeNow(bones) then
            local minPoints = GetMinPointsGain()
            local reward = 0
            if Sacrifice then
                local ok, res = pcall(Sacrifice.GetReward, bones)
                if ok and type(res) == "number" then reward = res end
            end
            if reward >= minPoints then
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local features = workspace:FindFirstChild("Features")
                local sacFeature = features and features:FindFirstChild("Sacrifice")
                if hrp and sacFeature then
                    pcall(function() hrp.CFrame = sacFeature:GetPivot() * CFrame.new(0, 3, 4) end)
                    task.wait(0.35)
                end
                notyuri(("[AutoSacrifice] Sacrificing %s Bones for %s Sacrifice Points"):format(tostring(bones), tostring(reward)))
                pcall(function() fw.Network.Fire("Sacrifice") end)
                task.wait(1)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoCoral()
    local fw = Modules.Framework
    local Coral = Modules.Coral
    local function GetPearls()
        local req = Coral and Coral.RequirementCurrency or "Pearls"
        local ok, stat = pcall(fw.Stat.Get, req)
        return ok and stat and stat.Value or 0
    end
    local function CanConvertNow(pearls)
        if not Coral then return false end
        local ok, res = pcall(Coral.CanConvert, pearls)
        if ok then return res == true end
        if type(pearls) == "number" then
            return pearls >= (Coral.MinPearls or 1000000)
        end
        return false
    end
    local function GetMinPointsGain()
        local raw = Options.AutoCoralMinPoints and Options.AutoCoralMinPoints.Value
        return ToNum(raw) or 0
    end
    while Toggles.AutoCoral.Value do
        local pearls = GetPearls()
        if CanConvertNow(pearls) then
            local minPoints = GetMinPointsGain()
            local reward = 0
            if Coral then
                local ok, res = pcall(Coral.GetReward, pearls)
                if ok and type(res) == "number" then reward = res end
            end
            if reward >= minPoints then
                local char = GetCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local features = workspace:FindFirstChild("Features")
                local coralFeature = features and features:FindFirstChild("Coral")
                if hrp and coralFeature then
                    pcall(function() hrp.CFrame = coralFeature:GetPivot() * CFrame.new(0, 3, 4) end)
                    task.wait(0.35)
                end
                notyuri(("[AutoCoral] Converting %s Pearls for %s Coral"):format(tostring(pearls), tostring(reward)))
                pcall(function() fw.Network.Fire("Coral") end)
                task.wait(1)
            end
        end
        task.wait(1)
    end
end
local function GetStatValue(name)
    local stat = Modules.Framework.Stat.Get(name)
    if stat then return stat.Value end
    return nil
end
local function CanAffordPrice(currencyName, price)
    if price == nil then return false end
    local stat = Modules.Framework.Stat.Get(currencyName)
    if not stat then return false end
    local ok, res = pcall(Modules.Framework.Currency.CanAfford, stat, price)
    return ok and res == true
end
local function Func_AutoBuyPickaxe()
    local fw = Modules.Framework
    local Pickaxes = Modules.Pickaxes or {}
    while true do
        local tier = ToNum(GetStatValue("PickaxeTier"))
        local nextPick = Pickaxes[tier + 1]
        if nextPick and nextPick.Price and CanAffordPrice("Coins", nextPick.Price) then
            pcall(function() fw.Network.Fire("BuyPickaxe") end)
            task.wait(0.3)
        end
        task.wait(0.5)
    end
end
local function Func_AutoBuySword()
    local fw = Modules.Framework
    local Swords = Modules.Swords or {}
    local tiers = Swords.Tiers or {}
    local currency = Swords.Currency or "Bones"
    while true do
        local tier = ToNum(GetStatValue("SwordTier"))
        local nextSword = tiers[tier + 1]
        if nextSword and nextSword.Price and CanAffordPrice(currency, nextSword.Price) then
            pcall(function() fw.Network.Fire("BuySword") end)
            task.wait(0.3)
        end
        task.wait(0.5)
    end
end
local function Func_AutoBuyRod()
    local fw = Modules.Framework
    local Rods = Modules.FishingRods or {}
    while true do
        local tier = ToNum(GetStatValue("FishingRodTier"))
        local nextRod = Rods[tier + 1]
        if nextRod and nextRod.Price and CanAffordPrice("Pearls", nextRod.Price) then
            pcall(function() fw.Network.Fire("BuyRod") end)
            task.wait(0.3)
        end
        task.wait(0.5)
    end
end
local function Func_AutoBuyGenerator()
    local fw = Modules.Framework
    local Generators = Modules.Generators or {}
    local gens = Generators.Generators or {}
    while true do
        for i, gen in ipairs(gens) do
            local statName = ("Generator%d"):format(i)
            local ok, stat = pcall(fw.Stat.Get, statName)
            if ok and stat and gen.Price and gen.BuyCurrency then
                local level = ToNum(stat.Value)
                local canSee = (i == 1)
                if not canSee then
                    local okP, prev = pcall(fw.Stat.Get, ("Generator%d"):format(i - 1))
                    canSee = okP and prev and (ToNum(prev.Value) > 0)
                end
                if canSee then
                    local price = gen.Price(level)
                    if CanAffordPrice(gen.BuyCurrency, price) then
                        pcall(function() fw.Network.Fire("BuyGenerator", i, "Single") end)
                        task.wait(0.15)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoBuyLayer()
    local fw = Modules.Framework
    local Layers = Modules.Layers
    while true do
        if Layers and Layers.GetPrice then
            local layer = ToNum(GetStatValue("Layer"))
            if layer < (Layers.MaxLayer or 15) then
                local price = Layers.GetPrice(layer)
                if CanAffordPrice(Layers.Currency or "Coins", price) then
                    pcall(function() fw.Network.Fire("Layer") end)
                    task.wait(0.3)
                end
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoBuyTier()
    local fw = Modules.Framework
    local Tiers = Modules.Tiers
    while true do
        if Tiers and Tiers.GetTier then
            local tier = ToNum(GetStatValue("Tier"))
            local nextTier = Tiers.GetTier(tier + 1)
            if nextTier and nextTier.Currency and nextTier.Price and CanAffordPrice(nextTier.Currency, nextTier.Price) then
                pcall(function() fw.Network.Fire("Tier") end)
                task.wait(0.3)
            end
        end
        task.wait(0.5)
    end
end
local function Func_AutoOverclock()
    local fw = Modules.Framework
    local Overclock = Modules.Overclock
    while true do
        if Overclock and Overclock.GetRequirement then
            local cores = ToNum(GetStatValue("Cores"))
            local req = Overclock.GetRequirement(cores)
            if CanAffordPrice(Overclock.RequirementCurrency or "Power", req) then
                pcall(function() fw.Network.Fire("Overclock") end)
                task.wait(0.5)
            end
        end
        task.wait(1)
    end
end
local function Func_AutoFire()
    local fw = Modules.Framework
    local Fire = Modules.Fire
    local function GetMinGain()
        local raw = Options.AutoFireMinGain and Options.AutoFireMinGain.Value
        return ToNum(raw) or 0
    end
    while Toggles.AutoFire.Value do
        if Fire and Fire.MinCharge then
            if CanAffordPrice(Fire.RequirementCurrency or "Charge", Fire.MinCharge) then
                local minGain = GetMinGain()
                local gain = 0
                if Fire.GetReward then
                    local charge = GetStatValue(Fire.RequirementCurrency or "Charge")
                    local ok, res = pcall(Fire.GetReward, ToNum(charge) or 0, Plr)
                    if ok and type(res) == "number" then gain = res end
                end
                if gain >= minGain then
                    notyuri(("[AutoFire] Converting Charge for %s Fire"):format(tostring(gain)))
                    pcall(function() fw.Network.Fire("Fire") end)
                    task.wait(0.5)
                end
            end
        end
        task.wait(1)
    end
end
local function Func_AutoRollClass()
    local fw = Modules.Framework
    while Toggles.AutoRollClass.Value do
        local rolling = GetStatValue("IsRolling")
        if not rolling then
            local res = nil
            pcall(function() res = fw.Network.Fire("RollClass") end)
            if res and res.Success == false and res.Error == "NotEnoughCurrency" then
                task.wait(3)
            else
                task.wait(0.4)
            end
        else
            task.wait(0.3)
        end
    end
end
local function Func_AutoRollRarity()
    local fw = Modules.Framework
    local Multipliers = Modules.Multipliers
    local function GetRarityButtonPos()
        local features = workspace:FindFirstChild("Features")
        if not features then return nil end
        local rar = features:FindFirstChild("Rarities")
        if not rar then return nil end
        local btn = rar:FindFirstChild("Button", true)
        if not btn or not btn:IsA("BasePart") then return nil end
        return btn.CFrame * CFrame.new(0, -math.clamp(btn.Size.Y * 0.45, 0.45, 1.5) + 1, 0)
    end
    while Toggles.AutoRollRarity.Value do
        local char = GetCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local btnCF = GetRarityButtonPos()
        if hrp and btnCF then
            pcall(function() hrp.CFrame = btnCF end)
            task.wait(0.2)
            pcall(function() fw.Network.Fire("RollRarity") end)
            local cd = 2
            if Multipliers and Multipliers.GetRarityRollCooldown then
                local ok, c = pcall(Multipliers.GetRarityRollCooldown, Plr)
                if ok and type(c) == "number" then cd = math.max(0.5, c) end
            end
            task.wait(cd)
        else
            task.wait(1)
        end
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
TB_Tabs.Autofarm.T1:AddToggle("AutoClick", { Text = "Auto Click", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoUpgrade", { Text = "Auto Upgrade", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoAscend", { Text = "Auto Ascend", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoBuyRune", { Text = "Auto Buy Rune", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoCollectFruit", { Text = "Auto Collect Fruit", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoTree", { Text = "Auto Tree", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoMine", { Text = "Auto Mine", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoSell", { Text = "Auto Sell", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("AutoMineMinHP", {
    Text = "Min Ore HP",
    Default = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
    end
})
TB_Tabs.Autofarm2.T1:AddInput("AutoSellThreshold", {
    Text = "Sell Threshold (ores)",
    Default = "500",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoSacrifice", { Text = "Auto Sacrifice", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("AutoSacrificeMinPoints", {
    Text = "Min Sacrifice Gain",
    Default = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
    end
})
TB_Tabs.Autofarm.T1:AddToggle("AutoCoral", { Text = "Auto Coral", Default = false })
TB_Tabs.Autofarm2.T1:AddInput("AutoCoralMinPoints", {
    Text = "Min Coral Gain",
    Default = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
    end
})
TB_Tabs.Autofarm2.T1:AddInput("AutoFireMinGain", {
    Text = "Min Fire Gain",
    Default = "0",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
    end
})
local AutoBuyList = { "Pickaxe", "Sword", "Rod", "Generator", "Layer", "Tier", "Overclock" }
local AutoBuyToggleKey = {
    Pickaxe = "AutoBuyPickaxe",
    Sword = "AutoBuySword",
    Rod = "AutoBuyRod",
    Generator = "AutoBuyGenerator",
    Layer = "AutoBuyLayer",
    Tier = "AutoBuyTier",
    Overclock = "AutoOverclock",
}
local AutoBuyFunc = {
    Pickaxe = Func_AutoBuyPickaxe,
    Sword = Func_AutoBuySword,
    Rod = Func_AutoBuyRod,
    Generator = Func_AutoBuyGenerator,
    Layer = Func_AutoBuyLayer,
    Tier = Func_AutoBuyTier,
    Overclock = Func_AutoOverclock,
}
TB_Tabs.Autofarm2.T1:AddDropdown("BuyTarget", {
    Text = "Buy List",
    Values = AutoBuyList,
    Default = {},
    Multi = true,
})
TB_Tabs.Autofarm.T1:AddToggle("AutoBuy", { Text = "Auto Buy", Default = false })
local function ApplyAutoBuySelection()
    local selected = Options.BuyTarget.Value or {}
    local masterOn = Toggles.AutoBuy.Value
    for _, name in ipairs(AutoBuyList) do
        local key = AutoBuyToggleKey[name]
        local shouldRun = masterOn and selected[name] == true
        Thread(key, SafeLoop(key, AutoBuyFunc[name]), shouldRun)
    end
end
Options.BuyTarget:OnChanged(ApplyAutoBuySelection)
Toggles.AutoBuy:OnChanged(ApplyAutoBuySelection)
TB_Tabs.Autofarm.T1:AddToggle("AutoFire", { Text = "Auto Charge", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollClass", { Text = "Auto Roll Class", Default = false })
TB_Tabs.Autofarm.T1:AddToggle("AutoRollRarity", { Text = "Auto Roll Rarity", Default = false })
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
Toggles.AutoClick:OnChanged(function(v)
    Thread("AutoClick", SafeLoop("AutoClick", Func_AutoClick), v)
end)
Toggles.AutoUpgrade:OnChanged(function(v)
    Thread("AutoUpgrade", SafeLoop("AutoUpgrade", Func_AutoUpgrade), v)
    Thread("AutoUpgradeTree", SafeLoop("AutoUpgradeTree", Func_AutoUpgradeTree), v)
end)
Toggles.AutoAscend:OnChanged(function(v)
    Thread("AutoAscend", SafeLoop("AutoAscend", Func_AutoAscend), v)
end)
Toggles.AutoBuyRune:OnChanged(function(v)
    Thread("AutoBuyRune", SafeLoop("AutoBuyRune", Func_AutoBuyRune), v)
end)
Toggles.AutoCollectFruit:OnChanged(function(v)
    Thread("AutoCollectFruit", SafeLoop("AutoCollectFruit", Func_AutoCollectFruit), v)
end)
Toggles.AutoTree:OnChanged(function(v)
    Thread("AutoTree", SafeLoop("AutoTree", Func_AutoTree), v)
end)
Toggles.AutoMine:OnChanged(function(v)
    Thread("AutoMine", SafeLoop("AutoMine", Func_AutoMine), v)
end)
Toggles.AutoSell:OnChanged(function(v)
    Thread("AutoSell", SafeLoop("AutoSell", Func_AutoSell), v)
end)
Toggles.AutoSacrifice:OnChanged(function(v)
    Thread("AutoSacrifice", SafeLoop("AutoSacrifice", Func_AutoSacrifice), v)
end)
Toggles.AutoCoral:OnChanged(function(v)
    Thread("AutoCoral", SafeLoop("AutoCoral", Func_AutoCoral), v)
end)
Toggles.AutoFire:OnChanged(function(v)
    Thread("AutoFire", SafeLoop("AutoFire", Func_AutoFire), v)
end)
Toggles.AutoRollClass:OnChanged(function(v)
    Thread("AutoRollClass", SafeLoop("AutoRollClass", Func_AutoRollClass), v)
end)
Toggles.AutoRollRarity:OnChanged(function(v)
    Thread("AutoRollRarity", SafeLoop("AutoRollRarity", Func_AutoRollRarity), v)
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
local function ApplyLighting()
    if Toggles.Fullbright.Value then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    elseif Toggles.OverrideTime.Value then
        Lighting.ClockTime = Options.OverrideTimeValue.Value
    end
    if Toggles.NoFog.Value then Lighting.FogEnd = 9e9 end
end
Toggles.Fullbright:OnChanged(ApplyLighting)
Toggles.OverrideTime:OnChanged(ApplyLighting)
Options.OverrideTimeValue:OnChanged(ApplyLighting)
Toggles.NoFog:OnChanged(ApplyLighting)
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
SaveManager:SetFolder("Yuri/TapIncremental")
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