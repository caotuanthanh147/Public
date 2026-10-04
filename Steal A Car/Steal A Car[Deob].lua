--- Players.LocalPlayer.PlayerScripts.WindController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

game:GetService("RunService")
local var1 = require(script.WindLines)
local var2 = require(script.WindShake)
local var3 = Vector3.new(1, 0, 0.3)
local num1 = 20
var1:Init({ Direction = var3, Speed = num1, Lifetime = 1.5, SpawnRate = 11 })
local num2 = 0.5
var2:SetDefaultSettings({ WindSpeed = num1, WindDirection = var3, WindPower = num2 })
var2:Init()
local var4 = Instance.new("ScreenGui")
local var5 = Instance.new("TextLabel")
var5.Text = string.format("Leaf Count: %d Active, %d Inactive, 77760 Total", 0, 0)
var5.BackgroundTransparency = 0.3
var5.BackgroundColor3 = Color3.new()
var5.TextStrokeTransparency = 0.8
var5.Size = UDim2.new(0.6, 0, 0, 27)
var5.Position = UDim2.new(0.2, 0, 1, -35)
var5.Font = Enum.Font.RobotoMono
var5.TextSize = 25
var5.TextColor3 = Color3.new(1, 1, 1)
var5.Parent = var4
local var6 = Instance.new("TextBox")
var6.Text = string.format("Wind Speed: %.1f", num1)
var6.PlaceholderText = "Input Speed"
var6.BackgroundTransparency = 0.8
var6.TextStrokeTransparency = 0.8
var6.Size = UDim2.new(0.2, 0, 0, 20)
var6.Position = UDim2.new(0, 5, 0.45, 0)
var6.Font = Enum.Font.RobotoMono
var6.TextXAlignment = Enum.TextXAlignment.Left
var6.TextSize = 18
var6.TextColor3 = Color3.new(1, 1, 1)
var6.FocusLost:Connect(function()
	local str1 = "[%d%.]+"
	local var4 = tonumber(var6.Text:match(str1))
	if var4 then
		num1 = math.clamp(var4, 0, 50)
		var1.Speed = num1
		var2:UpdateAllObjectSettings({ Speed = num1 })
		var2:SetDefaultSettings({ Speed = num1 })
	end

	var6.Text = string.format("Wind Speed: %.1f", num1)
end)

var6.Parent = var4
local var7 = Instance.new("TextBox")
var7.Text = string.format("Wind Power: %.1f", num2)
var7.PlaceholderText = "Input Power"
var7.BackgroundTransparency = 0.8
var7.TextStrokeTransparency = 0.8
var7.Size = UDim2.new(0.2, 0, 0, 20)
var7.Position = UDim2.new(0, 5, 0.45, 25)
var7.Font = Enum.Font.RobotoMono
var7.TextXAlignment = Enum.TextXAlignment.Left
var7.TextSize = 18
var7.TextColor3 = Color3.new(1, 1, 1)
var7.FocusLost:Connect(function()
	local str1 = "[%d%.]+"
	local var3 = tonumber(var7.Text:match(str1))
	if var3 then
		num2 = math.clamp(var3, 0, 3)
		var2:UpdateAllObjectSettings({ Power = num2 })
		var2:SetDefaultSettings({ Power = num2 })
	end

	var7.Text = string.format("Wind Power: %.1f", num2)
end)

var7.Parent = var4
local var8 = Instance.new("TextBox")
var8.Text = string.format("Wind Direction: %.1f,%.1f,%.1f", var3.X, var3.Y, var3.Z)
var8.PlaceholderText = "Input Direction"
var8.BackgroundTransparency = 0.8
var8.TextStrokeTransparency = 0.8
var8.Size = UDim2.new(0.2, 0, 0, 20)
var8.Position = UDim2.new(0, 5, 0.45, 50)
var8.Font = Enum.Font.RobotoMono
var8.TextXAlignment = Enum.TextXAlignment.Left
var8.TextSize = 18
var8.TextColor3 = Color3.new(1, 1, 1)
var8.FocusLost:Connect(function()
	local var4 = table.create(3)
	for k1 in string.gmatch(var8.Text, "%-?[%d%.]+") do
		var4[#var4 + 1] = tonumber(k1)
	end

	local var5 = var4[1]
	local var6 = var4[2]
	local var7 = var4[3]
	local var10 = Vector3.new(var5 or var3.X, var6 or var3.Y, var7 or var3.Z).Unit
	if var10 then
		var3 = var10
		var1.Direction = var10
		var2:UpdateAllObjectSettings({ Direction = var10 })
		var2:SetDefaultSettings({ Direction = var10 })
	end

	var8.Text = string.format("Wind Direction: %.1f, %.1f, %.1f", var3.X, var3.Y, var3.Z)
end)

var8.Parent = var4
spawn(function()
	while wait(0.1) do
		local var1 = var2.Active
		local var3 = var2.Handled
		var5.Text = string.format("Leaf Count: %d Active, %d Inactive, %d Not Streamed In (77760 Total)", var1, var3 - var1, 77760 - var3)
	end
end)

--- Players.LocalPlayer.PlayerScripts.WindController.WindLines [ModuleScript]
-- y u r i

local var1 = game:GetService("RunService")
local var2 = workspace:FindFirstChildOfClass("Terrain")
local tbl1 = { UpdateQueue = table.create(10) }
tbl1.Init = function(_, arg2)
	tbl1.Lifetime = arg2.Lifetime or 3
	tbl1.Direction = arg2.Direction or Vector3.new(1, 0, 0)
	tbl1.Speed = arg2.Speed or 6
	if tbl1.UpdateConnection then
		tbl1.UpdateConnection:Disconnect()
		tbl1.UpdateConnection = nil
	end

	for k1, v1 in ipairs(tbl1.UpdateQueue) do
		v1.Attachment0:Destroy()
		v1.Attachment1:Destroy()
		v1.Trail:Destroy()
	end

	table.clear(tbl1.UpdateQueue)
	tbl1.LastSpawned = os.clock()
	local var2 = 1 / (arg2.SpawnRate or 25)
	tbl1.UpdateConnection = var1.Heartbeat:Connect(function()
		local var1 = os.clock()
		if var2 < var1 - tbl1.LastSpawned then
			tbl1:Create()
			tbl1.LastSpawned = var1
		end

		debug.profilebegin("Wind Lines")
		for k1, v1 in ipairs(tbl1.UpdateQueue) do
			local var4 = var1 - v1.StartClock
			if v1.Lifetime <= var4 then
				v1.Attachment0:Destroy()
				v1.Attachment1:Destroy()
				v1.Trail:Destroy()
				local var5 = #tbl1.UpdateQueue
				tbl1.UpdateQueue[k1] = tbl1.UpdateQueue[var5]
				tbl1.UpdateQueue[var5] = nil
			else
				v1.Trail.MaxLength = 20 - 20 * (var4 / v1.Lifetime)
				local var6 = v1.Position
				local var7 = (var1 + v1.Seed) * (v1.Speed * 0.2)
				v1.Attachment0.WorldPosition = (CFrame.new(var6, var6 + v1.Direction) * CFrame.new(0, 0, v1.Speed * -var4)).Position + Vector3.new(math.sin(var7) * 0.5, math.sin(var7) * 0.8, math.sin(var7) * 0.5)
				v1.Attachment1.WorldPosition = v1.Attachment0.WorldPosition + Vector3.new(0, 0.1, 0)
			end
		end

		debug.profileend()
	end)
end

tbl1.Cleanup = function(_)
	if tbl1.UpdateConnection then
		tbl1.UpdateConnection:Disconnect()
		tbl1.UpdateConnection = nil
	end

	for k1, v1 in ipairs(tbl1.UpdateQueue) do
		v1.Attachment0:Destroy()
		v1.Attachment1:Destroy()
		v1.Trail:Destroy()
	end

	table.clear(tbl1.UpdateQueue)
end

local tbl2 = {}
tbl1.Create = function(_, arg2)
	debug.profilebegin("Add Wind Line")
	local var1 = arg2
	arg2 = var1 or tbl2
	var1 = arg2.Lifetime
	local var4 = arg2.Position
	var1 = var1 or tbl1.Lifetime
	if not var4 then
		var4 = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad((math.random(-30, 70))), math.rad((math.random(-80, 80))), 0) * CFrame.new(0, 0, math.random(200, 600) * -0.1).Position
	end

	local var5 = arg2.Direction
	local var6 = arg2.Speed
	var6 = var6 or tbl1.Speed
	var5 = var5 or tbl1.Direction
	if var6 <= 0 then
		return
	end

	local var7 = Instance.new("Attachment")
	local var8 = Instance.new("Attachment")
	local var9 = Instance.new("Trail")
	var9.Attachment0 = var7
	var9.Attachment1 = var8
	local num1 = 1
	local num2 = 0.3
	var9.WidthScale = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3),
		NumberSequenceKeypoint.new(0.2, 1),
		NumberSequenceKeypoint.new(0.8, 1),
		NumberSequenceKeypoint.new(num1, num2),
	})

	var9.Transparency = NumberSequence.new(0.7)
	var9.FaceCamera = true
	var9.Parent = var7
	var7.WorldPosition = var4
	var8.WorldPosition = var4 + Vector3.new(0, 0.1, 0)
	local tbl3 = {
		Attachment0 = var7,
		Attachment1 = var8,
		Trail = var9,
		Lifetime = var1 + math.random(-10, 10) * 0.1,
	}

	tbl3.Position = var4
	tbl3.Direction = var5
	tbl3.Speed = var6 + math.random(-10, 10) * 0.1
	tbl3.StartClock = os.clock()
	tbl3.Seed = math.random(1, 1000) * 0.1
	tbl1.UpdateQueue[#tbl1.UpdateQueue + 1] = tbl3
	var7.Parent = var2
	var8.Parent = var2
	debug.profileend()
end

return tbl1

--- Players.LocalPlayer.PlayerScripts.WindController.WindShake [ModuleScript]
-- y u r i

local var1 = require(script.Settings)
local var2 = game:GetService("CollectionService")
local var3 = game:GetService("RunService")
local var4 = require(script.Octree)
local var5 = var1.new(script, { WindDirection = Vector3.new(0.5, 0, 0.5), WindSpeed = 20, WindPower = 0.5 })
local var6 = Instance.new("BindableEvent")
local var7 = Instance.new("BindableEvent")
local var8 = Instance.new("BindableEvent")
local var9 = Instance.new("BindableEvent")
local var10 = Instance.new("BindableEvent")
local tbl1 = { ObjectMetadata = {}, Octree = var4.new(), Handled = 0, Active = 0 }
tbl1.LastUpdate = os.clock()
tbl1.ObjectShakeAdded = var6.Event
tbl1.ObjectShakeRemoved = var7.Event
tbl1.ObjectShakeUpdated = var8.Event
tbl1.Paused = var9.Event
tbl1.Resumed = var10.Event
tbl1.Connect = function(arg1, arg2, arg3)
	local var1 = arg1[arg2]
	assert(typeof(var1) == "function", "Unknown function: " .. arg2)
	local function fn2(...)
		local var2 = arg1
		return var1(var2, ...)
	end

	return arg3:Connect(fn2)
end

tbl1.AddObjectShake = function(arg1, arg2, arg3)
	if typeof(arg2) ~= "Instance" then
		return
	end

	if not arg2:IsA("BasePart") then
		return
	end

	local var2 = arg1.ObjectMetadata
	if var2[arg2] then
		return
	end

	local var3 = arg1.Handled + 1
	arg1.Handled = var3
	var3 = { Node = arg1.Octree:CreateNode(arg2.Position, arg2) }
	var3.Settings = var1.new(arg2, var5)
	var3.Seed = math.random(1000) * 0.1
	var3.Origin = arg2.CFrame
	var2[arg2] = var3
	arg1:UpdateObjectSettings(arg2, arg3)
	var6:Fire(arg2)
end

tbl1.RemoveObjectShake = function(arg1, arg2)
	if typeof(arg2) ~= "Instance" then
		return
	end

	local var1 = arg1.ObjectMetadata
	local var3 = var1[arg2]
	if var3 then
		local var4 = arg1.Handled - 1
		arg1.Handled = var4
		var1[arg2] = nil
		var3.Settings:Destroy()
		var3.Node:Destroy()
		if arg2:IsA("BasePart") then
			arg2.CFrame = var3.Origin
		end
	end

	var7:Fire(arg2)
end

tbl1.Update = function(arg1)
	local var1 = os.clock()
	local var3 = var1 - arg1.LastUpdate
	if var3 < 0.022222222222222223 then
		return
	end

	arg1.LastUpdate = var1
	debug.profilebegin("WindShake")
	local var4 = workspace.CurrentCamera
	local var5 = var4
	debug.profilebegin("Octree Search")
	var5 = var5 and var4.CFrame
	debug.profileend()
	local var6 = arg1.Octree:RadiusSearch(var5.Position + var5.LookVector * 115, 120)
	local var7 = #var6
	arg1.Active = var7
	if var7 < 1 then
		return
	end

	debug.profilebegin("Calc")
	local var8 = math.min(1, var3 * 8)
	local var9 = table.create(var7)
	local var10 = arg1.ObjectMetadata
	for k1, v1 in ipairs(var6) do
		local var11 = var10[v1]
		local var12 = var11.Origin
		local var18 = var11.CFrame or var12
		if 0.033333333333333333 < var1 - (var11.LastCompute or 0) then
			local var19 = var11.Settings
			local var20 = var1 * (var19.WindSpeed * 0.08)
			local var21 = var11.Seed
			local var22 = var19.WindPower * 0.1
			local var23 = v1.PivotOffset
			var11.Target = (var12 * var23 * CFrame.Angles(math.noise(var20, 0, var21) * var22, math.noise(var20, 0, -var21) * var22, math.noise(var20, 0, var21 + var21) * var22) + var19.WindDirection * ((0.5 + math.noise(var20, var21, var21)) * var22)) * var23:Inverse()
			var11.LastCompute = var1
		end

		var18 = var18:Lerp(var11.Target, var8)
		var11.CFrame = var18
		var9[k1] = var18
	end

	debug.profileend()
	workspace:BulkMoveTo(var6, var9, Enum.BulkMoveMode.FireCFrameChanged)
	debug.profileend()
end

tbl1.Pause = function(arg1)
	if arg1.UpdateConnection then
		arg1.UpdateConnection:Disconnect()
		arg1.UpdateConnection = nil
	end

	arg1.Active = 0
	arg1.Running = false
	var9:Fire()
end

tbl1.Resume = function(arg1)
	if arg1.Running then
		return
	end

	arg1.Running = true
	local var1 = arg1:Connect("Update", var3.Heartbeat)
	arg1.UpdateConnection = var1
	var10:Fire()
end

tbl1.Init = function(arg1)
	if arg1.Initialized then
		return
	end

	arg1.Initialized = true
	local var1 = script:GetAttribute("WindSpeed")
	local var3 = script:GetAttribute("WindDirection")
	if typeof((script:GetAttribute("WindPower"))) ~= "number" then
		script:SetAttribute("WindPower", var5.WindPower)
	end

	if typeof(var1) ~= "number" then
		script:SetAttribute("WindSpeed", var5.WindSpeed)
	end

	if typeof(var3) ~= "Vector3" then
		script:SetAttribute("WindDirection", var5.WindDirection)
	end

	arg1:Cleanup()
	local var4 = arg1:Connect("AddObjectShake", (var2:GetInstanceAddedSignal("WindShake")))
	arg1.AddedConnection = var4
	local var6 = arg1:Connect("RemoveObjectShake", (var2:GetInstanceRemovedSignal("WindShake")))
	arg1.RemovedConnection = var6
	local str1 = "WindShake"
	for k1, v1 in pairs(var2:GetTagged(str1)) do
		arg1:AddObjectShake(v1)
	end

	arg1:Resume()
end

tbl1.Cleanup = function(arg1)
	if not arg1.Initialized then
		return
	end

	arg1:Pause()
	if arg1.AddedConnection then
		arg1.AddedConnection:Disconnect()
		arg1.AddedConnection = nil
	end

	if arg1.RemovedConnection then
		arg1.RemovedConnection:Disconnect()
		arg1.RemovedConnection = nil
	end

	table.clear(arg1.ObjectMetadata)
	arg1.Octree:ClearNodes()
	arg1.Handled = 0
	arg1.Active = 0
	arg1.Initialized = false
end

tbl1.UpdateObjectSettings = function(arg1, arg2, arg3)
	if typeof(arg2) ~= "Instance" then
		return
	end

	if typeof(arg3) ~= "table" then
		return
	end

	if not arg1.ObjectMetadata[arg2] and arg2 ~= script then
		return
	end

	for k1, v1 in pairs(arg3) do
		arg2:SetAttribute(k1, v1)
	end

	var8:Fire(arg2)
end

tbl1.UpdateAllObjectSettings = function(arg1, arg2)
	if typeof(arg2) ~= "table" then
		return
	end

	for k1, v1 in pairs(arg1.ObjectMetadata) do
		for k2, v2 in pairs(arg2) do
			k1:SetAttribute(k2, v2)
		end

		var8:Fire(k1)
	end
end

tbl1.SetDefaultSettings = function(arg1, arg2)
	arg1:UpdateObjectSettings(script, arg2)
end

return tbl1

--- Players.LocalPlayer.PlayerScripts.WindController.WindShake.Settings [ModuleScript]
-- y u r i

return { new = function(arg1, arg2)
	local var1 = arg1:GetAttribute("WindPower")
	local var2 = table.create(3)
	local var3 = arg1:GetAttribute("WindSpeed")
	local var4 = arg1:GetAttribute("WindDirection")
	local var5 = typeof(var1) == "number" and var1 or arg2.WindPower
	var2.WindPower = var5
	var5 = typeof(var3) == "number" and var3 or arg2.WindSpeed
	var2.WindSpeed = var5
	var5 = typeof(var4) == "Vector3" and var4 or arg2.WindDirection
	var2.WindDirection = var5
	var5 = arg1:GetAttributeChangedSignal("WindPower"):Connect(function()
		var1 = arg1:GetAttribute("WindPower")
		local var3 = typeof(var1) == "number" and var1 or arg2.WindPower
		var2.WindPower = var3
	end)

	local var6 = arg1:GetAttributeChangedSignal("WindSpeed"):Connect(function()
		var3 = arg1:GetAttribute("WindSpeed")
		local var1 = typeof(var3) == "number" and var3 or arg2.WindSpeed
		var2.WindSpeed = var1
	end)

	local var7 = arg1:GetAttributeChangedSignal("WindDirection"):Connect(function()
		var4 = arg1:GetAttribute("WindDirection")
		local var1 = typeof(var4) == "Vector3" and var4 or arg2.WindDirection
		var2.WindDirection = var1
	end)

	var2.Destroy = function(_)
		var5:Disconnect()
		var6:Disconnect()
		var7:Disconnect()
		table.clear(var2)
	end

	return var2
end }

--- Players.LocalPlayer.PlayerScripts.WindController.WindShake.Octree [ModuleScript]
-- y u r i

local var1 = require(script.OctreeNode)
local var2 = require(script.OctreeRegionUtils)
local tbl1 = { ClassName = "Octree" }
tbl1.__index = tbl1
tbl1.new = function()
	local tbl2 = { MaxDepth = 4, MaxRegionSize = table.create(3, 512) }
	tbl2.RegionHashMap = {}
	return (setmetatable(tbl2, tbl1))
end

tbl1.ClearNodes = function(arg1)
	arg1.MaxDepth = 4
	arg1.MaxRegionSize = table.create(3, 512)
	table.clear(arg1.RegionHashMap)
end

tbl1.GetAllNodes = function(arg1)
	local tbl1 = {}
	local num1 = 0
	for k1, v1 in next, arg1.RegionHashMap do
		for k2, v2 in ipairs(v1) do
			for k3 in next, v2.Nodes do
				num1 = num1 + 1
				tbl1[num1] = k3
			end
		end
	end

	return tbl1
end

local var3 = var1.new
tbl1.CreateNode = function(arg1, arg2, arg3)
	if typeof(arg2) ~= "Vector3" then
		error("Bad position value")
	end

	if not arg3 then
		error("Bad object value.")
	end

	local var1 = var3(arg1, arg3)
	var1:SetPosition(arg2)
	return var1
end

local var4 = var2.GetNeighborsWithinRadius
tbl1.RadiusSearch = function(arg1, arg2, arg3)
	if typeof(arg2) ~= "Vector3" then
		error("Bad position value")
	end

	if type(arg3) ~= "number" then
		error("Bad radius value")
	end

	local var1 = arg3 + 0.8660254037844386 * arg1.MaxRegionSize[1]
	local var2 = arg2.X
	local var3 = arg2.Y
	local var5 = arg2.Z
	local tbl1 = {}
	local tbl2 = {}
	local num1 = 0
	local num2 = 0
	for k1, v1 in next, arg1.RegionHashMap do
		for k2, v2 in ipairs(v1) do
			local var6 = v2.Position
			local var7 = var2 - var6[1]
			local var8 = var3 - var6[2]
			local var9 = var5 - var6[3]
			local var10 = var1 * var1 + 1e-09
			if var7 * var7 + var8 * var8 + var9 * var9 > var10 then
				continue
			end

			local var11, var12 = var4(v2, arg3, var2, var3, var5, tbl1, tbl2, arg1.MaxDepth, num1, num2)
			local var13 = var11
			local var14 = var12
		end
	end

	return tbl1, tbl2
end

local function NearestNeighborSort(arg1, arg2)
	return arg1.Distance2 < arg2.Distance2
end

tbl1.KNearestNeighborsSearch = function(arg1, arg2, arg3, arg4)
	if typeof(arg2) ~= "Vector3" then
		error("Bad position value")
	end

	if type(arg4) ~= "number" then
		error("Bad radius value")
	end

	local var1 = arg4 + 0.8660254037844386 * arg1.MaxRegionSize[1]
	local var2 = arg2.X
	local var3 = arg2.Y
	local var5 = arg2.Z
	local tbl1 = {}
	local tbl2 = {}
	local num1 = 0
	local num2 = 0
	for k1, v1 in next, arg1.RegionHashMap do
		for k2, v2 in ipairs(v1) do
			local var6 = v2.Position
			local var7 = var2 - var6[1]
			local var8 = var3 - var6[2]
			local var9 = var5 - var6[3]
			local var10 = var1 * var1 + 1e-09
			if var7 * var7 + var8 * var8 + var9 * var9 > var10 then
				continue
			end

			local var11, var12 = var4(v2, arg4, var2, var3, var5, tbl1, tbl2, arg1.MaxDepth, num1, num2)
			local var13 = var11
			num2 = var12
		end
	end

	local var14 = table.create(num2)
	for k3, v3 in ipairs(tbl2) do
		var14[k3] = { Distance2 = v3, Index = k3 }
	end

	table.sort(var14, NearestNeighborSort)
	local var15 = math.min(num2, arg3)
	local var16 = table.create(var15)
	local var17 = table.create(var15)
	for i1 = 1, var15 do
		local var18 = var14[i1]
		var17[i1] = var18.Distance2
		var16[i1] = tbl1[var18.Index]
	end

	return var16, var17
end

local function GetOrCreateRegion(arg1, arg2, arg3, arg4)
	local var1 = arg1.MaxRegionSize
	local var2 = var1[1]
	local var3 = var1[2]
	local var4 = var1[3]
	local var5 = math.floor(arg2 / var2 + 0.5)
	local var6 = math.floor(arg3 / var3 + 0.5)
	local var7 = math.floor(arg4 / var4 + 0.5)
	local var8 = arg1.RegionHashMap
	local var9 = var5 * 73856093 + var6 * 19351301 + var7 * 83492791
	local var11 = var8[var9]
	if not var11 then
		var11 = {}
		var8[var9] = var11
	end

	local var12 = var2 * var5
	local var13 = var3 * var6
	local var14 = var4 * var7
	for k1, v1 in ipairs(var11) do
		local var15 = v1.Position
		if var15[1] ~= var12 then
			continue
		end

		if var15[2] ~= var13 then
			continue
		end

		if var15[3] ~= var14 then
			continue
		end

		return v1
	end

	local var16 = var2 / 2
	local var17 = var3 / 2
	local var18 = var4 / 2
	local tbl1 = {
		Depth = 1,
		LowerBounds = { var12 - var16, var13 - var17, var14 - var18 },
		NodeCount = 0,
		Nodes = {},
		Parent = nil,
		ParentIndex = nil,
		Position = { var12, var13, var14 },
		Size = { var2, var3, var4 },
		SubRegions = {},
		UpperBounds = { var12 + var16, var13 + var17, var14 + var18 },
	}

	table.insert(var11, tbl1)
	return tbl1
end

local tbl2 = {
	{ 0.25, 0.25, -0.25 },
	{ -0.25, 0.25, -0.25 },
	{ 0.25, 0.25, 0.25 },
	{ -0.25, 0.25, 0.25 },
	{ 0.25, -0.25, -0.25 },
	{ -0.25, -0.25, -0.25 },
	{ 0.25, -0.25, 0.25 },
	{ -0.25, -0.25, 0.25 },
}

tbl1.GetOrCreateLowestSubRegion = function(arg1, arg2, arg3, arg4)
	local var1 = GetOrCreateRegion(arg1, arg2, arg3, arg4)
	local var2 = var1
	for i1 = var1.Depth, arg1.MaxDepth do
		local var3 = var2.Position
		local var4 = if var3[1] < arg2 then 1 else 2
		if arg3 <= var3[2] then
			var4 = var4 + 4
		end

		if var3[3] <= arg4 then
			var4 = var4 + 2
		end

		local var5 = var2.SubRegions
		local var21 = var5[var4]
		if not var21 then
			local var22 = var2.Size
			local var23 = tbl2[var4]
			local var24 = var22[1]
			local var25 = var22[2]
			local var26 = var22[3]
			local var27 = var24 / 2
			local var28 = var25 / 2
			local var29 = var26 / 2
			local var30 = var3[1] + var23[1] * var24
			local var31 = var27 / 2
			local var32 = var3[2] + var23[2] * var25
			local var33 = var28 / 2
			local var34 = var3[3] + var23[3] * var26
			local var35 = var29 / 2
			var21 = {
				Depth = var2 and var2.Depth + 1 or 1,
				LowerBounds = { var30 - var31, var32 - var33, var34 - var35 },
				NodeCount = 0,
				Nodes = {},
				Parent = var2,
				ParentIndex = var4,
				Position = { var30, var32, var34 },
				Size = { var27, var28, var29 },
				SubRegions = {},
				UpperBounds = { var30 + var31, var32 + var33, var34 + var35 },
			}

			var5[var4] = var21
		end

		var2 = var21
	end

	return var2
end

return tbl1

--- Players.LocalPlayer.PlayerScripts.WindController.WindShake.Octree.OctreeNode [ModuleScript]
-- y u r i

local tbl1 = { ClassName = "OctreeNode" }
tbl1.__index = tbl1
tbl1.new = function(arg1, arg2)
	local var1 = arg1
	var1 = var1 or error("No octree")
	local tbl2 = {
		Octree = var1,
		CurrentLowestRegion = nil,
		Position = nil,
		PositionX = nil,
		PositionY = nil,
		PositionZ = nil,
	}

	var1 = arg2
	var1 = var1 or error("No object")
	tbl2.Object = var1
	return (setmetatable(tbl2, tbl1))
end

tbl1.KNearestNeighborsSearch = function(arg1, arg2, arg3)
	local var1 = arg1.Position
	local var2 = arg2
	local var3 = arg3
	return arg1.Octree:KNearestNeighborsSearch(var1, var2, var3)
end

tbl1.GetObject = function(arg1)
	warn("OctreeNode:GetObject is deprecated.")
	return arg1.Object
end

tbl1.RadiusSearch = function(arg1, arg2)
	local var1 = arg1.Position
	local var2 = arg2
	return arg1.Octree:RadiusSearch(var1, var2)
end

tbl1.GetPosition = function(arg1)
	warn("OctreeNode:GetPosition is deprecated.")
	return arg1.Position
end

tbl1.GetRawPosition = function(arg1)
	return arg1.PositionX, arg1.PositionY, arg1.PositionZ
end

tbl1.SetPosition = function(arg1, arg2)
	if arg1.Position == arg2 then
		return
	end

	local var1 = arg2.X
	arg1.PositionX = var1
	local var2 = arg2.Y
	arg1.PositionY = var2
	local var3 = arg2.Z
	arg1.PositionZ = var3
	arg1.Position = arg2
	local var7 = arg1.CurrentLowestRegion
	local var8 = var7.LowerBounds
	local var9 = var7.UpperBounds
	if arg1.CurrentLowestRegion and (var8[1] <= var1 and (var1 <= var9[1] and (var8[2] <= var2 and (var2 <= var9[2] and (var8[3] <= var3 and var3 <= var9[3]))))) then
		return
	end

	var7 = arg1.Octree:GetOrCreateLowestSubRegion(var1, var2, var3)
	if arg1.CurrentLowestRegion then
		var8 = arg1.CurrentLowestRegion
		if var8.Depth ~= var7.Depth then
			error("fromLowest.Depth ~= toLowest.Depth")
		end

		if var8 == var7 then
			error("fromLowest == toLowest")
		end

		var9 = var8
		local var10 = var7
		while true do
			if var9 ~= var10 then
				local var12 = var9.Nodes
				if not var12[arg1] then
					error("CurrentFrom.Nodes doesn't have a node here.")
				end

				local var14 = var9.NodeCount
				if var14 <= 0 then
					error("NodeCount is <= 0.")
				end

				var12[arg1] = nil
				var14 = var14 - 1
				var9.NodeCount = var14
				local var16 = var9.ParentIndex
				if var14 <= 0 then
					if var16 then
						local var18 = var9.Parent
						if not var18 then
							error("CurrentFrom.Parent doesn't exist.")
						end

						local var19 = var18.SubRegions
						if var19[var16] ~= var9 then
							error("Failed equality check.")
						end

						var19[var16] = nil
					end
				end

				local var20 = var10.Nodes
				if var20[arg1] then
					error("CurrentTo.Nodes already has a node here.")
				end

				var20[arg1] = arg1
				local var21 = var10.NodeCount + 1
				var10.NodeCount = var21
				var9 = var9.Parent
				var10 = var10.Parent
				continue
			end
		end
	else
		var8 = var7
		var9 = var8.Nodes
		while not var8 and (not var9[arg1]) do
		end
	end

	arg1.CurrentLowestRegion = var7
end

tbl1.Destroy = function(arg1)
	local var4 = arg1.CurrentLowestRegion
	if var4 then
		local var5 = var4
		local var6 = var5.Nodes
		while not var5 and (not var6[arg1]) do
		end
	end
end

return tbl1

--- Players.LocalPlayer.PlayerScripts.WindController.WindShake.Octree.OctreeRegionUtils [ModuleScript]
-- y u r i

local function GetNeighborsWithinRadius(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
	if not arg8 then
		error("Missing MaxDepth.")
	end

	local var1 = arg2 + 0.8660254037844386 * (arg1.Size[1] / 2)
	for k1, v1 in next, arg1.SubRegions do
		local var2 = v1.Position
		local var3 = arg3 - var2[1]
		local var4 = arg4 - var2[2]
		local var5 = arg5 - var2[3]
		local var6 = var1 * var1 + 1e-06
		if var3 * var3 + var4 * var4 + var5 * var5 > var6 then
			continue
		end

		local var7
		if v1.Depth == arg8 then
			for k2 in next, v1.Nodes do
				local var8 = k2.PositionX - arg3
				local var9 = k2.PositionY - arg4
				local var10 = k2.PositionZ - arg5
				local var11 = var8 * var8 + var9 * var9 + var10 * var10
				local var12 = arg2 * arg2
				if var11 > var12 then
					continue
				end

				arg9 = arg9 + 1
				arg6[arg9] = k2.Object
				arg10 = arg10 + 1
				arg7[arg10] = var11
			end
		else
			local var13 = arg3
			local var14, var15 = GetNeighborsWithinRadius(v1, arg2, var13, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
			arg9 = var14
			arg10 = var15
		end
	end

	return arg9, arg10
end

return { GetNeighborsWithinRadius = GetNeighborsWithinRadius }

--- Players.LocalPlayer.PlayerScripts.HudController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = var1:WaitForChild("Remotes")
local var3 = game:GetService("Players").LocalPlayer
local var4 = var3:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("BottomLeft")
local var5 = nil
local var6 = require(var1.Modules.NumberFormatter)
local var7 = var4:WaitForChild("Speed"):WaitForChild("SpeedNumber")
local var8 = var4:WaitForChild("Cash"):WaitForChild("CashNumber")
local function drawSpeed(arg1)
	local var1 = arg1
	var1 = var1 or (var3:GetAttribute("SpeedPower") or var5)
	var5 = var1
	if var5 == nil then
		return
	end

	local str1 = "PurchasedTreadmillMultiplier"
	local var4 = tonumber(var3:GetAttribute(str1)) or 1
	var1 = var6.Format(var5)
	if var3:GetAttribute("TrainingTier") and 1 < var4 then
		var1 = var1 .. " x" .. tostring(var4)
	end

	var7.Text = var1
end

var3:GetAttributeChangedSignal("SpeedPower"):Connect(function()
	local var2 = var3:GetAttribute("SpeedPower")
	if var2 ~= nil then
		drawSpeed(var2)
	end
end)

var3:GetAttributeChangedSignal("TrainingTier"):Connect(function()
	drawSpeed()
end)

var3:GetAttributeChangedSignal("PurchasedTreadmillMultiplier"):Connect(function()
	drawSpeed()
end)

local num1 = 0
local var9 = nil
var2.Events:WaitForChild("CurrencyUpdated").OnClientEvent:Connect(function(arg1)
	if type(arg1) == "table" then
		local var1 = num1 + 1
		num1 = var1
		var9 = arg1
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if var9 then
		local var1 = var9
		var9 = nil
		if var1.Cash ~= nil then
			local var2 = var1.CashFormatted
			var8.Text = "$" .. (var2 or var6.Format(var1.Cash))
		end

		local var4 = var1.Speed
		var4 = var4 or var3:GetAttribute("SpeedPower")
		if var4 ~= nil then
			drawSpeed(var4)
		end
	end
end)

local var10 = var2.Functions:WaitForChild("GetPlayerData")
task.spawn(function()
	local num2 = 1
	while true do
		if not var3.Parent then
			break
		end

		local success, result = pcall(function()
			return var10:InvokeServer()
		end)

		if success then
			if type(result) == "table" then
				if num1 == num1 then
					local var1 = var3:GetAttribute("SpeedPower")
					local tbl1 = { Cash = result.Cash, Speed = var1 or result.Speed }
					if tbl1.Cash ~= nil then
						local var2 = tbl1.CashFormatted
						var8.Text = "$" .. (var2 or var6.Format(tbl1.Cash))
					end

					var1 = tbl1.Speed
					var1 = var1 or var3:GetAttribute("SpeedPower")
					if var1 ~= nil then
						drawSpeed(var1)
					end
				end

				return
			end
		end

		task.wait(num2)
		local var4 = math.min(5, num2 + 1)
	end
end)

--- Players.LocalPlayer.PlayerScripts.PlotSignController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = require(var1.Configs.PlotConfig)
local tbl1 = {}
local var3 = game:GetService("Players").LocalPlayer
local var4 = game:GetService("TweenService")
local var5 = workspace:WaitForChild("Plots")
local var6 = game:GetService("RunService")
local var7 = var1.Remotes.Events:WaitForChild("PlotUpgradeResult")
local tbl2 = {
	NotOwner = "This is not your plot",
	NotEnoughCash = "Not enough cash",
	TooFar = "Move closer",
	DataNotLoaded = "Data is still loading",
	Unavailable = "Try again shortly",
	Upgraded = "Upgraded!",
}

local function bind(arg1)
	if not var2.IsPlayablePlot(arg1) or tbl1[arg1] then
		return
	end

	local var1 = arg1:FindFirstChild("Sign")
	local var5 = var1
	var5 = var5 and (var1:FindFirstChild("Sign") or var1:FindFirstChild("sign"))
	local var6 = var5
	local var7 = var5
	var7 = var7 and var5:FindFirstChildOfClass("SurfaceGui")
	local var8 = var7
	var8 = var8 and var7:FindFirstChild("Frame")
	local var9 = var8
	var9 = var9 and var8:FindFirstChild("ButtonFrame")
	var6 = var6 and var5:FindFirstChildOfClass("ClickDetector")
	if not var9 or (not var6) then
		return
	end

	local var10 = var9.Position
	local tbl2 = {
		connections = {},
		button = var9,
		frame = var8,
		part = var5,
		detector = var6,
		base = var10,
		hovered = false,
		tween = nil,
		feedbackId = 0,
	}

	tbl1[arg1] = tbl2
	local function lift(arg1)
		local var5 = arg1
		local var6 = tbl2
		if var5 then
			var5 = false
			if arg1:GetAttribute("Owner") == var3.UserId then
				var5 = false
				if (arg1:GetAttribute("Level") or 0) < var2.MaxLevel then
					var5 = var9.Visible
				end
			end
		end

		var6.hovered = var5
		if tbl2.tween then
			tbl2.tween:Cancel()
		end

		var6 = tbl2
		var5 = var4
		local var7 = var9
		local var8 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local var11 = if tbl2.hovered then var10 - UDim2.fromScale(0, var2.HoverLift) else var10
		var6.tween = var5:Create(var7, var8, { Position = var11 })
		tbl2.tween:Play()
	end

	tbl2.lift = lift
	local function fn3(arg1)
		if arg1 == var3 then
			lift(true)
		end
	end

	table.insert(tbl2.connections, var6.MouseHoverEnter:Connect(fn3))
	fn3 = function(arg1)
		if arg1 == var3 then
			lift(false)
		end
	end

	table.insert(tbl2.connections, var6.MouseHoverLeave:Connect(fn3))
	fn3 = "Level"
	for k1, v1 in ipairs({ "Owner", fn3 }) do
		local function fn5()
			lift(false)
		end

		table.insert(tbl2.connections, arg1:GetAttributeChangedSignal(v1):Connect(fn5))
	end
end

local function unbind(arg1)
	local var2 = tbl1[arg1]
	if not var2 then
		return
	end

	for k1, v1 in ipairs(var2.connections) do
		v1:Disconnect()
	end

	if var2.tween then
		var2.tween:Cancel()
	end

	tbl1[arg1] = nil
end

for k1, v1 in ipairs(var5:GetChildren()) do
	bind(v1)
end

var5.ChildAdded:Connect(bind)
var5.ChildRemoved:Connect(unbind)
var5.DescendantAdded:Connect(function(arg1)
	local var1 = arg1
	while var1.Parent and var1.Parent ~= var5 do
		var1 = var1.Parent
	end

	if var1.Parent == var5 then
		bind(var1)
	end
end)

var5.DescendantRemoving:Connect(function(arg1)
	for k1, v1 in pairs(tbl1) do
		if arg1 == v1.button or arg1 == v1.detector then
			unbind(k1)
		end
	end
end)

local num1 = 0
var6.Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	if num1 < 0.15 then
		return
	end

	num1 = 0
	var1 = var3.Character
	var1 = var1 and var3.Character:FindFirstChild("HumanoidRootPart")
	for k1, v1 in pairs(tbl1) do
		if not v1.hovered then
			continue
		end

		if not var1 or v1.detector.MaxActivationDistance < (var1.Position - v1.part.Position).Magnitude then
			v1.lift(false)
		end
	end
end)

var7.OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	local var1 = var5:FindFirstChild(arg1.PlotName or "")
	local var2 = var1
	var2 = var2 and tbl1[var1]
	local var4 = tbl2[arg1.Reason]
	if not var2 or (not var4) then
		return
	end

	local var7 = var2.frame:FindFirstChild("Upgrade")
	if not var7 then
		return
	end

	local var8 = var2.feedbackId + 1
	var2.feedbackId = var8
	var7.Text = var4
	var2.lift(false)
	var8 = var2.feedbackId
	task.delay(1.8, function()
		if tbl1[var1] == var2 and var2.feedbackId == var8 then
			var7.Text = "Upgrade:"
		end
	end)
end)

--- Players.LocalPlayer.PlayerScripts.DrivingController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local str1 = "LifecycleWait"
local var1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild(str1))
local var2 = game:GetService("ReplicatedStorage")
local var3 = game:GetService("Players")
str1 = game:GetService("UserInputService")
local bool1 = true
str1.WindowFocused:Connect(function()
	bool1 = true
end)

str1.WindowFocusReleased:Connect(function()
	bool1 = false
end)

str1.InputBegan:Connect(function(arg1, arg2)
	if not arg2 and (arg1.UserInputType == Enum.UserInputType.Keyboard or (arg1.UserInputType == Enum.UserInputType.Touch or arg1.UserInputType.Name:find("Gamepad"))) then
		bool1 = true
	end
end)

local var4 = nil
local var5 = nil
local tbl1 = {}
local var6 = require(var2.Modules.CarDrivingVisuals)
local var7 = var2.Remotes.Events:WaitForChild("DriveInput")
local var8 = var3.LocalPlayer
local var9 = nil
local function stopCamera(arg1)
	if var4 then
		var4:SetDriving(false)
	end

	local var2 = var5
	if not var2 and (not arg1) then
		return
	end

	var5 = nil
	local var3 = tbl1
	for k1, v1 in var3, nil do
		v1:Disconnect()
	end

	table.clear(var3)
	if var2 then
		var6.Destroy(var2.Visuals)
		if var2.jumpHumanoid and var2.jumpHumanoid.Parent then
			var2.jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, var2.jumpEnabled)
		end

		var7:FireServer(0, 0)
		var8.CameraMode = var2.mode
		var8.CameraMinZoomDistance = var2.minZoom
		var8.CameraMaxZoomDistance = var2.maxZoom
	end

	var3 = var8.Character
	local var9 = var3
	local var10 = var3
	var9 = var9 and var3:FindFirstChildOfClass("Humanoid")
	var10 = var10 and var3:FindFirstChild("HumanoidRootPart")
	local var11 = workspace.CurrentCamera
	if var8:GetAttribute("RaceFinishCamera") then
		return
	end

	if var11 then
		if var9 then
			local var12 = if var10 then var10.Position + Vector3.new(0, 1.5, 0) else var11.Focus.Position
			var11.CameraType = Enum.CameraType.Custom
			var11.CameraSubject = var9
			local var13 = var12 - var11.Focus.Position
			if var2 and var10 then
				local var14 = var11.CFrame + var13
				var11.CFrame = var14
				var11.Focus = CFrame.new(var12)
			end
		end
	end
end

local var10 = require(var2.Configs.DrivingConfig)
local function validSeat(arg1)
	local var1 = var8.Character
	local var2 = var1
	local var3 = arg1
	local var5 = arg1
	var2 = var2 and var1:FindFirstChildOfClass("Humanoid")
	var3 = var3 and arg1.Parent
	if var5 then
		var5 = false
		if arg1 ~= var9 then
			var5 = false
			if arg1:GetAttribute("SimpleCarSeat") == true then
				var5 = var3
				if var5 then
					var5 = var3:IsDescendantOf(workspace)
					if var5 then
						var5 = var2
						if var5 then
							var5 = false
							if 0 < var2.Health then
								var5 = false
								if var2.SeatPart == arg1 then
									var5 = not var1:GetAttribute("Ragdolled")
									if var5 then
										var5 = false
										if var1:GetAttribute("Driving") == true then
											var5 = false
											if var8:GetAttribute("DrivingCar") ~= nil then
												var5 = var3:GetAttribute("DriverUserId") == var8.UserId
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return var5
end

local num1 = 0
local var11 = require(var2.Modules.CarHandling)
var4 = require(var2.Modules.MobileDrivingControls).new(var8, function()
	local var1 = var8.Character
	local var3 = var5
	var1 = var1 and var8.Character:FindFirstChildOfClass("Humanoid")
	if not var3 or (not var1 or var1.Health <= 0) then
		return
	end

	if var3.car:GetAttribute("RaceVehicle") then
		var1.Jump = false
		return
	end

	var9 = var3.seat
	stopCamera(true)
	var1.Sit = false
	var1.Jump = true
end)

local function updateDrivingCamera(arg1, _)
	if var8:GetAttribute("RaceFinishCamera") then
		return
	end

	local var2 = workspace.CurrentCamera
	if not var2 then
		return
	end

	local var4 = arg1.chassis
	local bool2 = true
	if arg1.camera == var2 then
		bool2 = true
		if var2.CameraType == Enum.CameraType.Custom then
			bool2 = var2.CameraSubject ~= var4
		end
	end

	if bool2 then
		arg1.camera = var2
		arg1.cameraSeedFrames = 2
		local var5 = math.clamp(Vector3.new(0, 10, 26).Magnitude, var10.CameraMinZoom, var10.CameraMaxZoom)
		var8.CameraMaxZoomDistance = math.max(var8.CameraMaxZoomDistance, var5)
		var8.CameraMinZoomDistance = var5
		var8.CameraMaxZoomDistance = var5
		var2.CameraSubject = var4
		var2.CameraType = Enum.CameraType.Custom
	end

	if 0 < (arg1.cameraSeedFrames or 0) then
		local var6 = Vector3.new(var4.CFrame.LookVector.X, 0, var4.CFrame.LookVector.Z)
		local var7 = var4.Position + Vector3.new(0, 1, 0)
		var2.Focus = CFrame.new(var7)
		var2.CFrame = CFrame.lookAt(var7 + (-(if 0.001 < var6.Magnitude then var6.Unit else Vector3.new(0, 0, -1)) * 26 + Vector3.new(0, 10, 0)), var7)
		local var9 = arg1.cameraSeedFrames - 1
		arg1.cameraSeedFrames = var9
		return
	end

	if arg1.cameraSeedFrames == 0 then
		var8.CameraMinZoomDistance = var10.CameraMinZoom
		var8.CameraMaxZoomDistance = var10.CameraMaxZoom
		arg1.cameraSeedFrames = nil
	end
end

local function setSeat(arg1)
	if not validSeat(arg1) then
		stopCamera()
		return
	end

	if var5 and var5.seat == arg1 then
		return
	end

	stopCamera()
	if os.clock() < num1 then
		return
	end

	num1 = os.clock() + 0.2
	local var1 = arg1.Parent
	local var3 = var1:FindFirstChild("Chassis")
	if not var3 or (not workspace.CurrentCamera) then
		return
	end

	local success, result = pcall(var11.Create, var1)
	if not success then
		return
	end

	local tbl2 = {
		seat = arg1,
		car = var1,
		chassis = var3,
		handling = result,
		Visuals = var6.Create(var1),
	}

	tbl2.mode = var8.CameraMode
	tbl2.minZoom = var8.CameraMinZoomDistance
	tbl2.maxZoom = var8.CameraMaxZoomDistance
	tbl2.elapsed = var10.SendInterval
	var5 = tbl2
	if var1:GetAttribute("RaceVehicle") then
		tbl2 = var8.Character
		tbl2 = tbl2 and var8.Character:FindFirstChildOfClass("Humanoid")
		if tbl2 then
			var5.jumpHumanoid = tbl2
			var5.jumpEnabled = tbl2:GetStateEnabled(Enum.HumanoidStateType.Jumping)
			tbl2.Jump = false
			tbl2:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		end
	end

	var4:SetDriving(true)
	var8.CameraMode = Enum.CameraMode.Classic
	var8.CameraMaxZoomDistance = var10.CameraMaxZoom
	var8.CameraMinZoomDistance = var10.CameraMinZoom
	updateDrivingCamera(var5, 0)
	local function fn2()
		if not validSeat(arg1) then
			stopCamera()
		end
	end

	table.insert(tbl1, var1:GetAttributeChangedSignal("DriverUserId"):Connect(fn2))
	fn2 = function()
		if not var1:IsDescendantOf(workspace) then
			stopCamera()
		end
	end

	table.insert(tbl1, var1.AncestryChanged:Connect(fn2))
end

local tbl2 = {}
local function syncSeat()
	if not var8:GetAttribute("RaceFinishing") then
		if var8:GetAttribute("RaceFinishCamera") then
			if var4 then
				var4:SetDriving(false)
			end

			return
		end
	end

	local var1 = var8.Character
	local var2 = var1
	var2 = var2 and var1:FindFirstChildOfClass("Humanoid")
	if not var2 then
		stopCamera()
		return
	end

	if not var2.SeatPart or var8:GetAttribute("DrivingCar") == nil then
		var9 = nil
	end

	if var1:GetAttribute("Ragdolled") then
		stopCamera(true)
		return
	end

	setSeat(var2.SeatPart)
end

var8:GetAttributeChangedSignal("DrivingCar"):Connect(syncSeat)
var2.Remotes.Events:WaitForChild("CoreFeedback").OnClientEvent:Connect(function(arg1)
	if type(arg1) == "table" then
		if arg1.Kind ~= "ChaseEnd" then
			if arg1.Kind ~= "Success" then
				return
			end
		end

		local var1 = var8.Character
		var1 = var1 and var8.Character:FindFirstChildOfClass("Humanoid")
		local var2
		if var5 then
			var2 = var5.seat
		else
			var2 = var1
			var2 = var2 and var1.SeatPart
		end

		var9 = var2
		stopCamera(true)
	end
end)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if workspace.CurrentCamera and (var5 and validSeat(var5.seat)) then
		updateDrivingCamera(var5, 0)
		return
	end

	stopCamera(true)
end)

local function bindCharacter(arg1)
	stopCamera(true)
	local var2 = tbl2
	for k1, v1 in var2, nil do
		v1:Disconnect()
	end

	table.clear(var2)
	var9 = nil
	var2 = var1.Child(arg1, "Humanoid", function()
		local bool1 = false
		if var8.Parent ~= nil then
			bool1 = var8.Character == arg1
		end

		return bool1
	end)

	if not var2 then
		return
	end

	if var8.Character ~= arg1 then
		return
	end

	local var3 = syncSeat
	table.insert(tbl2, var2:GetPropertyChangedSignal("SeatPart"):Connect(var3))
	var3 = syncSeat
	table.insert(tbl2, arg1:GetAttributeChangedSignal("Driving"):Connect(var3))
	var3 = syncSeat
	table.insert(tbl2, arg1:GetAttributeChangedSignal("Ragdolled"):Connect(var3))
	var3 = function()
		stopCamera(true)
	end

	table.insert(tbl2, var2.Died:Connect(var3))
	syncSeat()
end

var8.CharacterAdded:Connect(bindCharacter)
var8.CharacterRemoving:Connect(function()
	stopCamera(true)
	local var1 = tbl2
	for k1, v1 in var1, nil do
		v1:Disconnect()
	end

	table.clear(var1)
end)

local var12 = game:GetService("RunService")
local var13 = game:GetService("GuiService")
local var14 = require(var2.Modules.RaceSteerAssist)
local var15 = require(var2.Configs.RaceConfig)
if var8.Character then
	task.spawn(bindCharacter, var8.Character)
end

var12:BindToRenderStep("StealACarDrivingCamera", Enum.RenderPriority.Camera.Value + 1, function(arg1)
	syncSeat()
	if var5 then
		updateDrivingCamera(var5, arg1)
		var6.Render(var5.Visuals, arg1)
	end
end)

script.Destroying:Connect(function()
	var12:UnbindFromRenderStep("StealACarDrivingCamera")
	stopCamera(true)
	var4:Destroy()
	local var1 = tbl2
	for k1, v1 in var1, nil do
		v1:Disconnect()
	end

	table.clear(var1)
end)

var12.PreSimulation:Connect(function(arg1)
	local var3 = var5
	if not var3 then
		return
	end

	if not validSeat(var3.seat) then
		stopCamera()
		return
	end

	if var3.car:GetAttribute("CaptureResolving") then
		return
	end

	local var9 = Vector3.new(0, 0, 0)
	if not str1:GetFocusedTextBox() then
		if not var13.MenuIsOpen then
			if bool1 then
				local var12 = var8.Character
				var12 = var12 and var8.Character:FindFirstChildOfClass("Humanoid")
				local var16 = workspace.CurrentCamera
				if str1.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
					local var17 = str1:IsKeyDown(Enum.KeyCode.W)
					local var18 = str1:IsKeyDown(Enum.KeyCode.S)
					local var19 = str1:IsKeyDown(Enum.KeyCode.A)
					local var20 = str1:IsKeyDown(Enum.KeyCode.D)
					var17 = var17 or str1:IsKeyDown(Enum.KeyCode.Up)
					var18 = var18 or str1:IsKeyDown(Enum.KeyCode.Down)
					var19 = var19 or str1:IsKeyDown(Enum.KeyCode.Left)
					local var21 = if var20 or str1:IsKeyDown(Enum.KeyCode.Right) then 1 else 0
					local var22 = var21 - (if var19 then 1 else 0)
					var21 = 0
					local var23 = if var18 then 1 else 0
					var9 = Vector3.new(var22, var21, var23 - (if var17 then 1 else 0))
				elseif var12 then
					if var16 then
						local var24 = Vector3.new(var16.CFrame.LookVector.X, 0, var16.CFrame.LookVector.Z)
						var24 = if var24.Magnitude < 0.001 then var3.chassis.CFrame.LookVector else var24.Unit
						var9 = Vector3.new(var12.MoveDirection:Dot((Vector3.new(-var24.Z, 0, var24.X))), 0, -var12.MoveDirection:Dot(var24))
					end
				end
			end
		end
	end

	local var29 = math.clamp(-var9.Z, -1, 1)
	local var30 = math.clamp(var9.X, -1, 1)
	if var4:IsTouchDriving() then
		local var31, var32 = var4:GetAxes()
		var29 = var31
		var30 = var32
	end

	local var34 = workspace.CurrentCamera
	if var34 then
		local var35 = Vector3.new(var34.CFrame.LookVector.X, 0, var34.CFrame.LookVector.Z)
		var35 = var35 or Vector3.new(0, 0, 0)
	end

	local var36 = Vector3.new(0, 0, 0)
	var36 = if 0.001 < var36.Magnitude then var36.Unit else Vector3.new(var3.chassis.CFrame.LookVector.X, 0, var3.chassis.CFrame.LookVector.Z).Unit
	local var37 = var36 * var29 + var36:Cross(Vector3.new(0, 1, 0)) * var30
	if 1 < var37.Magnitude then
		var37 = var37.Unit
	end

	local var38 = Vector3.new(var3.chassis.CFrame.LookVector.X, 0, var3.chassis.CFrame.LookVector.Z)
	var38 = if 0.001 < var38.Magnitude then var38.Unit else var36
	local var39 = Vector3.new(0, 1, 0)
	var30 = var37:Dot(var38:Cross(var39))
	var29 = var37:Dot(var38)
	local var40 = var30
	if var3.car:GetAttribute("RaceVehicle") then
		if var3.car:GetAttribute("RaceLocked") or var3.chassis.Anchored then
			var3.handling.steer = 0
			if var3.raceAssist then
				var3.raceAssist.Correction = 0
			end

			local var41 = var3.elapsed + arg1
			var3.elapsed = var41
			if var10.SendInterval <= var3.elapsed then
				var3.elapsed = 0
				var7:FireServer(var29, 0, var4:IsTouchDriving())
			end

			return
		end

		local var42 = var2.RaceState:GetAttribute("MapId")
		local var43 = nil
		for k1, v1 in var2.RaceMaps:GetChildren() do
			if v1:GetAttribute("RaceMapId") ~= var42 then
				continue
			end

			var43 = v1
			break
		end

		local var44 = var43
		var44 = var44 and var43:FindFirstChild("RaceCheckpoints")
		if var44 and (not var3.raceAssist or var3.raceAssist.Folder ~= var44) then
			var39 = var44:GetChildren()
			table.sort(var39, function(arg1, arg2)
				return (tonumber(arg1.Name) or 0) < (tonumber(arg2.Name) or 0)
			end)

			var3.raceAssist = { Folder = var44, Gates = var39, NextGate = 1, Correction = 0 }
		end

		if var3.raceAssist then
			var3.raceAssist.NextGate = var3.car:GetAttribute("RaceNextGate") or 1
			if var2.RaceState:GetAttribute("SteerAssistEnabled") ~= false and var8:GetAttribute("SteeringAssistEnabled") == true then
				var40 = var14.Step(var3.raceAssist, var3.chassis.CFrame, var3.chassis.AssemblyLinearVelocity, var29, var30, var4:IsTouchDriving(), arg1, var15.SteerAssist, var10.TurnRate or 360)
			else
				var3.raceAssist.Correction = 0
			end
		end
	end

	var6.Input(var3.Visuals, var29, var40)
	var11.Step(var3.handling, var29, var40, (math.min(arg1, 0.1)))
	local var45 = var3.elapsed + arg1
	var3.elapsed = var45
	if var10.SendInterval <= var3.elapsed then
		var3.elapsed = 0
		var7:FireServer(var29, var30, var4:IsTouchDriving())
	end
end)

local tbl3 = {}
local function bindSounds(arg1)
	if tbl3[arg1] then
		return
	end

	local tbl1 = { muted = {}, connections = {} }
	tbl3[arg1] = tbl1
	local function mute(arg1)
		if not arg1:IsA("Sound") or tbl1.muted[arg1] then
			return
		end

		local tbl2 = { volume = arg1.Volume }
		tbl1.muted[arg1] = tbl2
		tbl2.connection = arg1:GetPropertyChangedSignal("Volume"):Connect(function()
			if arg1.Volume ~= 0 then
				tbl2.volume = arg1.Volume
				arg1.Volume = 0
			end
		end)

		arg1.Volume = 0
	end

	local function restore()
		for k1, v1 in pairs(tbl1.muted) do
			v1.connection:Disconnect()
			if not k1.Parent then
				continue
			end

			k1.Volume = v1.volume
		end

		table.clear(tbl1.muted)
	end

	local function refresh()
		if arg1:GetAttribute("Driving") then
			for k1, v1 in ipairs(arg1:GetDescendants()) do
				mute(v1)
			end

			return
		end

		restore()
	end

	local var1 = refresh
	table.insert(tbl1.connections, arg1:GetAttributeChangedSignal("Driving"):Connect(var1))
	var1 = function(arg1)
		if arg1:GetAttribute("Driving") then
			mute(arg1)
		end
	end

	table.insert(tbl1.connections, arg1.DescendantAdded:Connect(var1))
	var1 = function()
		if not arg1.Parent then
			restore()
			for k1, v1 in ipairs(tbl1.connections) do
				v1:Disconnect()
			end

			tbl3[arg1] = nil
		end
	end

	table.insert(tbl1.connections, arg1.AncestryChanged:Connect(var1))
	refresh()
end

var3.PlayerAdded:Connect(function(arg1)
	arg1.CharacterAdded:Connect(bindSounds)
	if arg1.Character then
		bindSounds(arg1.Character)
	end
end)

for k1, v1 in ipairs(var3:GetPlayers()) do
	v1.CharacterAdded:Connect(bindSounds)
	if not v1.Character then
		continue
	end

	bindSounds(v1.Character)
end

--- Players.LocalPlayer.PlayerScripts.CarBillboardController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("CollectionService")
local var2 = game:GetService("RunService")
local var3 = require(game.ReplicatedStorage.Configs.CarConfig)
local var4 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local tbl1 = {}
var1:GetInstanceAddedSignal("CarRarityGradient"):Connect(function(arg1)
	if arg1:IsA("UIGradient") then
		tbl1[arg1] = { gradient = arg1 }
	end
end)

var1:GetInstanceRemovedSignal("CarRarityGradient"):Connect(function(arg1)
	tbl1[arg1] = nil
end)

local tbl2 = {}
local tbl3 = {
	ShopStarterPack = { period = 4.8, angle = 22, drift = 0.28 },
	Robux = { period = 1.8, angle = 28, drift = 0.34 },
	LobbyFuse = { period = 3.2, angle = 12, drift = 0.22 },
	LobbyInvite = { period = 4.2, angle = 12, drift = 0.22 },
	Fuse = { period = 1.5, angle = 80, drift = 0.4 },
	FuseBat = { period = 0.75, angle = 180, drift = 0.6 },
	Infernal = { period = 1.15, angle = -100, drift = 0.42 },
	Celestial = { period = 0.85, angle = 65, drift = 0.46 },
	Uncommon = { period = 2, angle = 18, drift = 0.32 },
	Rare = { period = 1.75, angle = 55, drift = 0.35 },
	Epic = { period = 1.6, angle = -40, drift = 0.36 },
	Legendary = { period = 1.9, angle = 28, drift = 0.42 },
	Cosmic = { period = 2.2, angle = 100, drift = 0.3 },
	Ethereal = { period = 1.8, angle = -85, drift = 0.34 },
	Chromatic = { period = 1.5, angle = 180, drift = 0.28 },
	Secret = { period = 1.25, angle = -70, drift = 0.42 },
	Apex = { period = 1.1, angle = 120, drift = 0.38 },
}

local tbl4 = { period = 2.1, angle = 35, drift = 0.3 }
local function visible(arg1)
	if not arg1:IsDescendantOf(workspace) and (not arg1:IsDescendantOf(var4)) then
		return false
	end

	local var1 = arg1.Parent
	local var8 = var1
	local var9 = nil
	local var10 = nil
	local var11 = nil
	local var12 = nil
	if var8 then
		if var8:IsA("GuiObject") then
			var9 = var8.AbsolutePosition.X
			var10 = var8.AbsolutePosition.Y
			var11 = var9 + var8.AbsoluteSize.X
			var12 = var10 + var8.AbsoluteSize.Y
		end
	end

	while not var1 and var1:IsA("GuiObject") and (not var1.Visible) do
	end

	local var13 = var4
	return arg1:IsDescendantOf(var13)
end

local function styleLabel(arg1)
	if not arg1:IsA("TextLabel") or arg1.Name:lower() ~= "rarity" then
		return
	end

	local function update()
		local var2 = arg1:GetAttribute("GradientStyleOverride")
		var2 = var2 or arg1.Text
		local var5 = var3.Rarities[var2]
		if not var5 then
			return
		end

		local var6 = arg1:FindFirstChildOfClass("UIGradient")
		var6 = var6 or Instance.new("UIGradient")
		var6.Color = var5.Gradient
		var6:SetAttribute("GradientStyle", var2)
		var6.Parent = arg1
		arg1.TextColor3 = Color3.new(1, 1, 1)
		if var5.Animated then
			var1:AddTag(var6, "CarRarityGradient")
			if not var6:IsA("UIGradient") then
				return
			end

			tbl1[var6] = { gradient = var6 }
			return
		end

		var1:RemoveTag(var6, "CarRarityGradient")
		tbl1[var6] = nil
		var6.Offset = Vector2.zero
		var6.Rotation = 0
	end

	update()
	local var2 = arg1:GetPropertyChangedSignal("Text"):Connect(update)
	arg1.Destroying:Once(function()
		var2:Disconnect()
	end)
end

for k1, v1 in var1:GetTagged("CarRarityGradient") do
	if not v1:IsA("UIGradient") then
		continue
	end

	tbl1[v1] = { gradient = v1 }
end

var4.DescendantAdded:Connect(styleLabel)
for k2, v2 in var4:GetDescendants() do
	styleLabel(v2)
end

local num1 = 0
local num2 = 0
local num3 = 0
local num4 = 0.016666666666666666
var2.Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	var1 = num2 + arg1
	num2 = var1
	var1 = num3 + arg1
	num3 = var1
	local num5 = 0.1
	local var2 = num4
	var1 = num4 + (math.min(arg1, num5) - var2) * 0.05
	num4 = var1
	if 0.25 <= num2 then
		num2 = 0
		table.clear(tbl2)
		var1 = if 0.028571428571428571 < num4 then 20 else 48
		for k1, v1 in pairs(tbl1) do
			if not k1.Parent then
				continue
			end

			if not k1.Enabled then
				continue
			end

			if not visible(k1) then
				continue
			end

			if k1:GetAttribute("GradientStyle") == "Common" then
				continue
			end

			table.insert(tbl2, v1)
			if var1 <= (#tbl2) then
				break
			end
		end
	end

	if num3 < (if 0.028571428571428571 < num4 then 0.033333333333333333 else 0.016666666666666666) then
		return
	end

	num3 = 0
	for k2, v2 in tbl2, nil do
		local var3 = v2.gradient
		if not tbl1[var3] then
			continue
		end

		if not var3.Parent then
			continue
		end

		local var4 = var3:GetAttribute("GradientStyle")
		local var5 = tbl3[var4]
		var5 = var5 or tbl4
		local var6 = num1 * 2 * 3.1415926535897931 / var5.period + (var3:GetAttribute("GradientPhase") or 0)
		var3.Offset = Vector2.new(math.sin(var6) * var5.drift, math.cos(var6) * var5.drift * 0.25)
		local var7 = if var4 == "Chromatic" then num1 * 110 % 360 else math.sin(var6 * 0.5) * var5.angle
		var3.Rotation = var7
	end
end)

--- Players.LocalPlayer.PlayerScripts.CoreGameController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("TweenService")
local bool1 = false
local var3 = nil
local var4 = nil
local var5 = nil
local var6 = nil
local var7 = require(var1.Modules.UIEffects)
local bool2 = false
local var8 = nil
local num1 = 0
local var9 = nil
local var10 = nil
local var11 = nil
local var12 = require(var1.Configs.ZoneConfig)
local var13 = game:GetService("Players").LocalPlayer
local function setChase(arg1, arg2)
	if arg1 == bool1 and (not arg2) then
		return
	end

	bool1 = arg1
	if var3 then
		var3.Visible = arg1
	end

	if var4 then
		var4:Cancel()
		var4 = nil
	end

	if var5 then
		var5()
		var5 = nil
	end

	if var6 then
		var6.Scale = 1
		if arg1 then
			var5 = var7.FreezeText(var6.Parent)
			var4 = var2:Create(var6, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Scale = 1.18 })
			var4:Play()
		end
	end

	local var1 = workspace.CurrentCamera
	if bool2 then
		return
	end

	if not arg1 and var8 then
		return
	end

	local var13 = num1 + 1
	num1 = var13
	var8 = nil
	if var9 then
		var9:Cancel()
	end

	if var1 then
		if arg1 then
			var13 = var10
			var10 = var13 or (var11 or var1.FieldOfView)
			var11 = var10
			var13 = var2:Create(var1, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = math.min(100, var10 + var12.ChaseFovIncrease) })
			var13:Play()
			var9 = var13
			return
		end

		if var10 then
			var13 = var2:Create(var1, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = var10 })
			var13:Play()
			var9 = var13
			var10 = nil
		end
	end
end

local var14 = nil
local var15 = require(var1.Modules.ConfettiEffect)
local var16 = nil
local var17 = nil
local var18 = nil
local var19 = nil
local num2 = 0
local tbl1 = {}
var13:GetAttributeChangedSignal("BeingChased"):Connect(function()
	setChase(var13:GetAttribute("BeingChased") == true)
end)

local var20 = var1:WaitForChild("RaceState")
local bool3 = false
local var21 = nil
local var22 = require(var1.Configs.RaceConfig)
local function updateRaceCamera(arg1)
	local var1 = var13.Character
	local var3 = var1
	local var5 = not arg1
	var3 = var3 and var1:FindFirstChildOfClass("Humanoid")
	if var5 then
		var5 = false
		if var20:GetAttribute("Phase") == "Racing" then
			var5 = false
			if var13:GetAttribute("RaceParticipant") == true then
				var5 = false
				if var13:GetAttribute("DrivingCar") ~= nil then
					var5 = false
					if var3 ~= nil then
						var5 = 0 < var3.Health
					end
				end
			end
		end
	end

	local var7 = var5
	local var14 = workspace.CurrentCamera
	if var7 then
		var7 = var13:GetAttribute("RaceBoosted") == true
	end

	if var5 == bool2 and (var7 == bool3 and (not var5 or var14 == var21)) then
		return
	end

	local var15 = bool2
	bool2 = var5
	bool3 = var7
	local var16 = num1 + 1
	num1 = var16
	if var9 then
		var9:Cancel()
		var9 = nil
	end

	if var8 and var11 then
		var8.FieldOfView = var11
	end

	var8 = nil
	if var21 and (var21 ~= var14 and var11) then
		var21.FieldOfView = var11
	end

	var21 = if var5 then var14 else nil
	if not var14 then
		return
	end

	if var5 then
		var16 = var10
		var16 = var16 or (var11 or var14.FieldOfView)
		var11 = var16
		var10 = nil
		var16 = if var7 then var22.Boost.CameraFovIncrease else 0
		local var17 = var2:Create(var14, TweenInfo.new(if var15 then var22.Boost.CameraTweenSeconds else var22.CameraFovInSeconds or 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = math.min(100, var11 + (var22.CameraFovIncrease or 14) + var16) })
		var17:Play()
		var9 = var17
		return
	end

	if var15 then
		var16 = var11
		var16 = var16 or var14.FieldOfView
		if bool1 then
			var10 = var16
			var16 = math.min(100, var16 + var12.ChaseFovIncrease)
		end

		local var18 = var2:Create(var14, TweenInfo.new(var22.CameraFovOutSeconds or 0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = var16 })
		var18:Play()
		var9 = var18
	end
end

var20:GetAttributeChangedSignal("Phase"):Connect(function()
	updateRaceCamera(false)
end)

var13:GetAttributeChangedSignal("RaceParticipant"):Connect(function()
	updateRaceCamera(false)
end)

var13:GetAttributeChangedSignal("RaceBoosted"):Connect(function()
	updateRaceCamera(false)
end)

var13:GetAttributeChangedSignal("DrivingCar"):Connect(function()
	updateRaceCamera(false)
end)

local var23 = require(var1.Modules.FinishCelebration)
var13.CharacterRemoving:Connect(function()
	local var1 = num1 + 1
	num1 = var1
	if var9 then
		var9:Cancel()
		var9 = nil
	end

	if var8 and var11 then
		var8.FieldOfView = var11
	end

	var8 = nil
	updateRaceCamera(true)
	if var14 then
		var15.Stop(var14)
	end

	var23.Stop()
end)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local var1 = num1 + 1
	num1 = var1
	if var9 then
		var9:Cancel()
		var9 = nil
	end

	if var8 and var11 then
		var8.FieldOfView = var11
	end

	var8 = nil
	updateRaceCamera(false)
end)

local num3 = 0
local function bindUI()
	local var2 = var13:FindFirstChildOfClass("PlayerGui")
	if not var2 then
		return
	end

	local var4 = var2:FindFirstChild("Chase")
	local var5 = var4
	var5 = var5 and var4:FindFirstChild("root")
	if var5 and var5 ~= var3 then
		var3 = var5
		local var8 = var5:FindFirstChild("RunText")
		if var8 then
			local var9 = var8:FindFirstChild("ChasePulse")
			var9 = var9 or Instance.new("UIScale")
			var6 = var9
			var6.Name = "ChasePulse"
			var6.Parent = var8
		end

		setChase(var13:GetAttribute("BeingChased") == true, true)
	end

	local var10 = var2:FindFirstChild("Notifications")
	local var11 = var10
	var11 = var11 and var10:FindFirstChild("Confetti")
	if var11 then
		if var11 ~= var14 then
			if var14 then
				var15.Stop(var14)
			end

			var14 = var11
			var14.Visible = false
			var14.Active = false
			var15.Prepare(var14, "Finish")
		end
	end

	local var12 = var10
	var12 = var12 and (var10:FindFirstChild("Zonetext") or var10:FindFirstChild("ZoneText"))
	if var12 and var12 ~= var16 then
		var16 = var12
		var17 = var12:FindFirstChild("Text")
		var18 = var12.Position
		var19 = {}
		local var20 = table.unpack(var12:GetDescendants())
		for k1, v1 in ipairs({ var12, var20 }) do
			local tbl1 = {}
			if v1:IsA("GuiObject") then
				tbl1.BackgroundTransparency = v1.BackgroundTransparency
			end

			if v1:IsA("TextLabel") then
				tbl1.TextTransparency = v1.TextTransparency
				tbl1.TextStrokeTransparency = v1.TextStrokeTransparency
			end

			if v1:IsA("ImageLabel") then
				tbl1.ImageTransparency = v1.ImageTransparency
			end

			if v1:IsA("UIStroke") then
				tbl1.Transparency = v1.Transparency
			end

			var19[v1] = tbl1
		end

		var12.Visible = false
	end
end

var13.CharacterAdded:Connect(function()
	num3 = 0
	task.defer(bindUI)
end)

local var24 = var13:WaitForChild("PlayerGui")
var24.DescendantAdded:Connect(function(arg1)
	if arg1.Name == "root" or (arg1.Name == "RunText" or (arg1.Name == "Zonetext" or (arg1.Name == "ZoneText" or arg1.Name == "Confetti"))) then
		task.defer(bindUI)
	end
end)

bindUI()
updateRaceCamera(false)
local var25 = script:WaitForChild("Success")
local function finishCameraEffect()
	if bool2 then
		return
	end

	local var3 = workspace.CurrentCamera
	if not var3 then
		return
	end

	local var4 = num1 + 1
	num1 = var4
	var4 = num1
	if var9 then
		var9:Cancel()
	end

	local var5 = var11
	var5 = var5 or (var10 or var3.FieldOfView)
	var11 = var5
	var8 = var3
	local var6 = TweenInfo.new(0.48, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	var9 = var2:Create(var3, var6, { FieldOfView = math.max(45, var5 - (var12.FinishFovDip or 6)) })
	var9:Play()
	task.delay(0.58, function()
		if var4 ~= num1 or (bool1 or var3 ~= workspace.CurrentCamera) then
			return
		end

		local var1 = TweenInfo.new(1.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		var9 = var2:Create(var3, var1, { FieldOfView = var5 })
		var9:Play()
		task.delay(1.15, function()
			if var4 == num1 then
				var8 = nil
				var9 = nil
			end
		end)
	end)
end

var25.Event:Connect(function(arg1)
	bindUI()
	finishCameraEffect()
	var15.Play(var14, "Finish")
	var23.Play(var24, arg1)
end)

local var26 = nil
local var27 = require(var1.Modules.OtherSounds)
game:GetService("ProximityPromptService").PromptTriggered:Connect(function(arg1, arg2)
	if arg2 and arg2 ~= var13 then
		return
	end

	var26 = arg1
	var27.Play("PromptSound")
end)

local var28 = require(var1.Modules.NumberFormatter)
var1.Remotes.Events:WaitForChild("CoreFeedback").OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	if arg1.Kind == "ChaseStart" then
		setChase(true)
		return
	end

	if arg1.Kind == "ChaseEnd" then
		if bool1 == false then
			return
		end

		bool1 = false
		if var3 then
			var3.Visible = false
		end

		if var4 then
			var4:Cancel()
			var4 = nil
		end

		if var5 then
			var5()
			var5 = nil
		end

		if var6 then
			var6.Scale = 1
		end

		local var1 = workspace.CurrentCamera
		if bool2 then
			return
		end

		if var8 then
			return
		end

		local var7 = num1 + 1
		num1 = var7
		var8 = nil
		if var9 then
			var9:Cancel()
		end

		if not (var1 and var10) then
			return
		end

		if not var10 then
			return
		end

		var7 = var2:Create(var1, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = var10 })
		var7:Play()
		var9 = var7
		var10 = nil
		return
	end

	if arg1.Kind == "Success" then
	if bool1 ~= false then
			bool1 = false
			if var3 then
				var3.Visible = false
			end

			if var4 then
				var4:Cancel()
				var4 = nil
			end

			if var5 then
				var5()
				var5 = nil
			end

			if var6 then
				var6.Scale = 1
			end

			local var11 = workspace.CurrentCamera
			if bool2 then
			else
	if not var8 then
					local var12 = num1 + 1
					num1 = var12
					var8 = nil
					if var9 then
						var9:Cancel()
					end

					if var11 and var10 then
						var12 = var2:Create(var11, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { FieldOfView = var10 })
						var12:Play()
						var9 = var12
						var10 = nil
					end
				end
			end
		end

		var25:Fire(arg1.CarId)
		return
	end

	if arg1.Success == false then
		if var26 then
			if var26.Parent then
				local var13 = ({
					MovementCheck = "Position syncing, try again",
					HoldMiniCar = "Hold a MiniCar",
					NotOwner = "Your plot only",
					TooFar = "Move closer",
					LockedSlot = "Upgrade your plot",
					Unavailable = "Try again",
					AlreadyDriving = "Exit your car first",
				})[arg1.Reason]

				if arg1.Reason == "SpeedRequired" then
					var13 = if type(arg1.RequiredSpeed) == "number" then "Requires " .. var28.Format(arg1.RequiredSpeed) .. " speed" else "Unavailable"
				end

				if var13 then
					local var15 = var26
					local var16 = var15.ActionText
					var15.ActionText = var13
					task.delay(1.5, function()
						if var15.Parent and var15.ActionText == var13 then
							var15.ActionText = var16
						end
					end)

				end
			end
		end
	end
end)

local num4 = 0
local var29 = require(var1.Modules.ZoneRegions)
local function showZone(arg1)
	if not var16 or (not var17) then
		return
	end

	local var1 = num2 + 1
	num2 = var1
	var1 = num2
	for k1, v1 in ipairs(tbl1) do
		v1:Cancel()
	end

	table.clear(tbl1)
	local var3 = var12.Get(arg1)
	var17.Text = var3.Name
	var17.TextColor3 = Color3.new(1, 1, 1)
	local var4 = var17:FindFirstChildWhichIsA("UIGradient")
	local var5 = ColorSequence.new(var3.Colors[1], var3.Colors[#var3.Colors])
	var4 = var4 or Instance.new("UIGradient")
	var4.Color = var5
	var4.Parent = var17
	local var7 = var16:FindFirstChildWhichIsA("UIGradient")
	if var7 then
		var7.Color = var5
	end

	local var8 = var16
	for k2, v2 in pairs(var19) do
		if not k2.Parent then
			continue
		end

		for k3 in pairs(v2) do
			k2[k3] = 1
		end
	end

	var8.Position = UDim2.new(var18.X.Scale, var18.X.Offset, -0.2, var18.Y.Offset)
	var8.Visible = true
	local tbl2 = { Position = var18 }
	local var9 = var2:Create(var8, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl2)
	var9:Play()
	table.insert(tbl1, var9)
	for k4, v3 in pairs(var19) do
		if not k4.Parent then
			continue
		end

		local var10 = var2:Create(k4, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v3)
		var10:Play()
		table.insert(tbl1, var10)
	end

	task.delay(2.3, function()
		if var1 ~= num2 or var8 ~= var16 then
			return
		end

		for k1, v1 in pairs(var19) do
			if not k1.Parent then
				continue
			end

			local tbl2 = {}
			for k2 in pairs(v1) do
				tbl2[k2] = 1
			end

			local var3 = var2:Create(k1, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), tbl2)
			var3:Play()
			table.insert(tbl1, var3)
		end

		local var4 = var2:Create(var8, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = var18 - UDim2.fromScale(0, 0.04) })
		var4:Play()
		table.insert(tbl1, var4)
		task.delay(0.4, function()
			if var1 == num2 and var8.Parent then
				var8.Visible = false
			end
		end)
	end)
end

game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var1 = num4 + arg1
	num4 = var1
	if num4 < var12.ZonePollInterval then
		return
	end

	num4 = 0
	var1 = var13.Character
	var1 = var1 and var13.Character:FindFirstChild("HumanoidRootPart")
	if not var1 then
		return
	end

	local var3 = var29.Get(var1.Position)
	if var3 ~= nil then
		if var3 ~= num3 then
			if num3 < var3 and 0 < var3 then
				showZone(var3)
			end

			num3 = var3
		end
	end
end)

--- Players.LocalPlayer.PlayerScripts.AutoDriveWheelController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local tbl1 = {}
local var1 = game:GetService("CollectionService")
local function add(arg1)
	if tbl1[arg1] then
		return
	end

	local tbl2 = { wheels = {}, steer = 0, dirty = true, connections = {} }
	tbl1[arg1] = tbl2
	local function changed(arg1)
		if arg1:IsA("Motor6D") then
			tbl2.dirty = true
		end
	end

	local var1 = changed
	table.insert(tbl2.connections, arg1.DescendantAdded:Connect(var1))
	var1 = changed
	table.insert(tbl2.connections, arg1.DescendantRemoving:Connect(var1))
	var1 = function()
		tbl2.dirty = true
	end

	table.insert(tbl2.connections, arg1:GetPropertyChangedSignal("PrimaryPart"):Connect(var1))
	var1 = function()
		local var1 = arg1
		local var3 = tbl1[var1]
		if not var3 then
			return
		end

		for k1, v1 in var3.connections, nil do
			v1:Disconnect()
		end

		tbl1[var1] = nil
	end

	table.insert(tbl2.connections, arg1.Destroying:Connect(var1))
end

var1:GetInstanceAddedSignal("AutoDrivenCar"):Connect(add)
var1:GetInstanceRemovedSignal("AutoDrivenCar"):Connect(function(arg1)
	local var2 = tbl1[arg1]
	if not var2 then
		return
	end

	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	tbl1[arg1] = nil
end)

local var2 = game:GetService("RunService")
local var3 = require(game.ReplicatedStorage.Modules.WheelSpin)
for k1, v1 in var1:GetTagged("AutoDrivenCar") do
	add(v1)
end

var2.PreSimulation:Connect(function(arg1)
	local var1 = workspace.CurrentCamera
	for k1, v1 in tbl1, nil do
		local var2
		local var4
		if v1.dirty then
			v1.root = k1.PrimaryPart
			v1.wheels = {}
			v1.dirty = false
			if v1.root then
				for k2, v2 in v1.root:GetChildren() do
					var4 = v2:IsA("Motor6D")
					if not var4 then
						continue
					end

					var4 = v2.Name:sub(1, 10)
					if var4 ~= "AutoWheel_" then
						continue
					end

					local tbl2 = { joint = v2, phase = 0, radius = v2:GetAttribute("Radius") or 1 }
					tbl2.front = v2:GetAttribute("Front")
					tbl2.tracked = v2:GetAttribute("TrackedWheel")
					table.insert(v1.wheels, tbl2)
				end
			end
		end

		local var5 = v1.root
		if not var5 or (not var1) then
			continue
		end

		if 0 >= (#v1.wheels) then
			continue
		end

		if (var1.CFrame.Position - var5.Position).Magnitude >= 220 then
			continue
		end

		local var6
		if var5.Anchored then
			if v1.parked then
				continue
			end

			v1.steer = 0
			v1.parked = true
			for k3, v3 in v1.wheels, nil do
				v3.joint.Transform = CFrame.Angles(-v3.phase, 0, 0)
			end
		else
			v1.parked = false
			local var7 = var5.CFrame.LookVector
			local var8 = math.exp(-12 * arg1)
			local var9 = var5.AssemblyLinearVelocity:Dot(var7)
			local var10 = v1.steer + ((k1:GetAttribute("AutoSteering") or 0) - v1.steer) * (1 - var8)
			v1.steer = var10
			for k4, v4 in v1.wheels, nil do
				local var12 = v4.joint
				local var13 = var9
				if v4.tracked then
					var13 = var13 + var5.AssemblyAngularVelocity:Cross((var5.CFrame:VectorToWorldSpace(var12.C0.Position))):Dot(var7)
				end

				local var14 = (v4.phase + math.clamp(var3.AngularSpeed(var13, v4.radius) * math.min(arg1, 0.1), -0.45, 0.45)) % 6.2831853071795862
				v4.phase = var14
				local var15 = CFrame.Angles
				local num1 = 0
				var15 = var15(num1, if v4.front then v1.steer else 0, 0)
				var12.Transform = var15 * CFrame.Angles(-v4.phase, 0, 0)
			end
		end
	end
end)

--- Players.LocalPlayer.PlayerScripts.UIFeedbackController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = require(game.ReplicatedStorage.Modules.UIEffects)
local var2 = setmetatable({}, { __mode = "k" })
local var3 = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local function bind(arg1)
	if arg1:IsA("GuiButton") then
		var1.BindButton(arg1)
	end

	if var2[arg1] then
		return
	end

	local var4 = nil
	if arg1:IsA("ScreenGui") then
		var4 = "Enabled"
	else
		if arg1:IsA("GuiObject") and (arg1.Parent and arg1.Parent:IsA("ScreenGui")) then
			var4 = "Visible"
		end
	end

	if not var4 then
		return
	end

	var2[arg1] = true
	local var5 = arg1[var4]
	local var6 = arg1:GetPropertyChangedSignal(var4):Connect(function()
		local var3 = arg1[var4]
		if var3 == var5 then
			return
		end

		var5 = var3
		if arg1:GetAttribute("WindowEffectsManaged") then
			return
		end

		if not var3 then
			var1.Reset(arg1)
		end

		local var6 = var1.Play
		var6(if var3 then "Open" else "Close", arg1)
	end)

	arg1.Destroying:Once(function()
		var6:Disconnect()
		var2[arg1] = nil
	end)
end

for k1, v1 in var3:GetDescendants() do
	bind(v1)
end

var3.DescendantAdded:Connect(bind)

--- Players.LocalPlayer.PlayerScripts.ShopController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("Players").LocalPlayer
local var3 = var2:WaitForChild("PlayerGui"):WaitForChild("Main")
local var4 = var3:WaitForChild("Trails")
var4.List.Template:Destroy()
local var5 = game:GetService("RunService")
local var6 = require(var1.Modules.ShopRegions)
local var7 = require(var1.Configs.CarConfig)
local var8 = require(var1.Configs.TrailConfig)
local var9 = require(var1.Modules.UIEffects)
local var10 = require(var1.Modules.OtherSounds)
local var11 = require(var1.Modules.CarAssets)
local var12 = require(var1.Modules.NumberFormatter)
local var13 = require(var1.Modules.BigNumber)
local var14 = var3:WaitForChild("Sell")
local var15 = var4.List.Template:Clone()
var15.Parent = nil
var14.List.Template:Destroy()
local var16 = var14.List.Template:Clone()
var16.Parent = nil
local var17 = nil
local bool1 = false
var4.Visible = false
var14.Visible = false
var4.Exit.Button.Activated:Connect(function()
	var9.SetWindow(var4, false)
end)

var14.Exit.Button.Activated:Connect(function()
	var9.SetWindow(var14, false)
end)

local var18 = var4.Size
local var19 = var14.Size
local tbl1 = {}
local tbl2 = { Owned = {}, Equipped = "" }
local var20 = var1.Remotes.Events
local function updateTrailRows()
	for k1, v1 in pairs(tbl1) do
		local var2 = tbl2.Owned[k1] == true
		local var3 = var8.Get(k1)
		local var4 = v1.Cash.Price
		local var5
		if var2 then
			if tbl2.Equipped == k1 then
				var5 = "Unequip"
			else
				var5 = "Equip"
			end
		else
			local var6 = var3.Price
			var5 = "$" .. var12.Format(var13.fromNumber(var6))
		end

		var4.Text = var5
		var5 = not var2
		var4 = v1.Robux
		if var5 then
			var5 = 0 < (v1:GetAttribute("DevProductId") or 0)
		end

		var4.Visible = var5
	end
end

var20.TrailUpdated.OnClientEvent:Connect(function(arg1)
	if type(arg1) == "table" then
		local var1 = arg1.Owned
		tbl2.Owned = var1 or {}
		tbl2.Equipped = arg1.Equipped or ""
		updateTrailRows()
	end
end)

local bool2 = false
local var21 = var1.Remotes.Functions
local function buildTrails(arg1)
	tbl2.Owned = {}
	tbl2.Equipped = arg1.Equipped or ""
	local var1 = arg1.Trails
	local var2 = table.clone(var1 or {})
	table.sort(var2, function(arg1, arg2)
		local var3 = var8.GetPrice(arg1.Id)
		local var4 = var8.GetPrice(arg2.Id)
		if var3 ~= var4 then
			return var3 < var4
		end

		if (arg1.Order or 0) ~= (arg2.Order or 0) then
			return (arg1.Order or 0) < (arg2.Order or 0)
		end

		return arg1.Id < arg2.Id
	end)

	for k1, v1 in ipairs(var2) do
		local var3 = v1.Id
		tbl2.Owned[var3] = v1.Owned == true
		if not tbl1[var3] then
			local var5 = var15:Clone()
			var5.Name = var3
			var5.Visible = true
			var5.LayoutOrder = k1
			local var9 = var5:FindFirstChildOfClass("UIGradient")
			if not var9 then
				var9 = Instance.new("UIGradient")
				var9.Rotation = 90
				var9.Parent = var5
			end

			var9.Color = var8.GetCardGradient(var3)
			var9.Enabled = true
			var5.BackgroundColor3 = Color3.new(1, 1, 1)
			local var10 = var5:FindFirstChild("Name")
			var10.Text = v1.Name or var3
			var5.Rarity.Text = v1.Rarity or "Common"
			var5.Rarity.TextColor3 = var7.GetRarityInfo(var5.Rarity.Text).Color
			var5.Speed.Speed.RichText = true
			var5:SetAttribute("MovementMultiplier", v1.MovementMultiplier or 1)
			var5.Speed.Speed.Text = "<font color=\"#00FF00\">x" .. tostring(v1.SpeedMultiplier) .. "</font> <font color=\"#FFFFFF\">Training</font>"
			var5.TrailPicture.Image = v1.Image or ""
			var5.TrailPicture.Visible = var5.TrailPicture.Image ~= ""
			var5:SetAttribute("DevProductId", v1.DevProductId or 0)
			var5.Robux.Price.Text = tostring(v1.RobuxPrice or "\226\128\148")
			var5.Cash.Button.Activated:Connect(function()
				if tbl2.Owned[var3] then
					local var1 = var20.EquipTrail
					var1:FireServer(if tbl2.Equipped == var3 then "" else var3)
					return
				end

				var20.BuyTrail:FireServer(var3)
			end)

			var5.Robux.Button.Activated:Connect(function()
				if 0 < (var5:GetAttribute("DevProductId") or 0) and (not tbl2.Owned[var3]) then
					var20.BuyTrailRobux:FireServer(var3)
				end
			end)

			var5.Size = var15.Size
			var5.Parent = var4.List
			tbl1[var3] = var5
		end
	end

	updateTrailRows()
	var1 = workspace.CurrentCamera
	if not var1 then
		return
	end

	local var12 = var1.ViewportSize.X < 1000
	local var13 = var4
	local var16 = if var12 then UDim2.fromScale(0.92, 0.78) else var18
	var13.Size = var16
	var13 = var14
	var16 = if var12 then UDim2.fromScale(0.92, 0.78) else var19
	var13.Size = var16
end

var17 = function()
	if bool2 or bool1 then
		return
	end

	bool2 = true
	for i1 = 1, 3 do
		local success, result = pcall(function()
			return var21.GetTrailData:InvokeServer()
		end)

		if success and (result and type(result.Trails) == "table") then
			buildTrails(result)
			bool1 = true
			break
		end

		task.wait(i1)
	end

	bool2 = false
end

task.spawn(var17)
local tbl3 = {}
local tbl4 = {}
local tbl5 = {}
local function preview(arg1, arg2)
	if arg1:FindFirstChild("CarPreview") then
		return
	end

	local var2 = var11.GetHeldTemplate(arg2)
	if not var2 then
		return
	end

	local var3 = var2:Clone()
	local var4 = Instance.new("Model")
	var4.Name = "PreviewCar"
	for k1, v1 in var3:GetChildren() do
		v1.Parent = var4
	end

	var3:Destroy()
	for k2, v2 in var4:GetDescendants() do
		if v2:IsA("LuaSourceContainer") or (v2:IsA("Constraint") or (v2:IsA("JointInstance") or (v2:IsA("WeldConstraint") or v2:IsA("Sound")))) then
			v2:Destroy()
		else
			if not v2:IsA("BasePart") then
				continue
			end

			v2.Anchored = true
			v2.CanCollide = false
		end
	end

	local var5 = Instance.new("ViewportFrame")
	var5.Name = "CarPreview"
	var5.BackgroundTransparency = 1
	var5.Position = UDim2.fromScale(0.04, 0.04)
	var5.Size = UDim2.fromScale(0.92, 0.7)
	var5.ZIndex = arg1.ImageLabel.ZIndex
	var5.Ambient = Color3.fromRGB(200, 200, 200)
	var5.LightColor = Color3.new(1, 1, 1)
	var4.Parent = var5
	local var6, var7 = var4:GetBoundingBox()
	local var8 = Instance.new("Camera")
	var8.FieldOfView = 35
	var8.CFrame = CFrame.lookAt(var6.Position + Vector3.new(0.8, 0.5, -1).Unit * (math.max(var7.X, var7.Y, var7.Z) * 1.9), var6.Position)
	var8.Parent = var5
	var5.CurrentCamera = var8
	var5.Parent = arg1
end

local bool3 = false
local function updateTotal()
	local num1 = 0
	for k1 in pairs(tbl3) do
		if tbl4[k1] then
			num1 = num1 + tbl4[k1].Price
		else
			tbl3[k1] = nil
		end
	end

	local var1 = num1
	local str1 = "$"
	local var2 = var12.Format(var13.fromNumber(var1))
	var14.SellBar.Price.Text = str1 .. var2
	for k2, v1 in pairs(tbl5) do
		local var3 = v1:FindFirstChildOfClass("UIStroke")
		var1 = if tbl3[k2] then Color3.fromRGB(45, 145, 255) else Color3.new(0, 0, 0)
		var3.Color = var1
	end
end

local function updatePreviews()
	local var1 = var14.List.AbsolutePosition
	local var2 = var14.List.AbsoluteSize
	for k1, v1 in pairs(tbl5) do
		local var4 = var14.Visible
		if var4 then
			var4 = false
			if var1.Y <= v1.AbsolutePosition.Y + v1.AbsoluteSize.Y then
				var4 = v1.AbsolutePosition.Y <= var1.Y + var2.Y
			end
		end

		local var6 = tbl4[k1]
		if var6 then
			var6 = false
			if tbl4[k1].Image ~= "" then
				var6 = v1.ImageLabel.IsLoaded
			end
		end

		v1.ImageLabel.Visible = var6 == true
		if var4 and (tbl4[k1] and (not var6)) then
			preview(v1, tbl4[k1].Id)
		else
			local var7 = v1:FindFirstChild("CarPreview")
			if not var7 then
				continue
			end

			var7:Destroy()
		end
	end
end

local num1 = 0
local function renderItems(arg1)
	tbl4 = {}
	local var1 = arg1
	for k1, v1 in ipairs(var1 or {}) do
		tbl4[v1.Uid] = v1
	end

	for k2, v2 in pairs(tbl5) do
		if tbl4[k2] then
			continue
		end

		v2:Destroy()
		tbl5[k2] = nil
		tbl3[k2] = nil
	end

	var1 = arg1
	for k3, v3 in ipairs(var1 or {}) do
		local var2 = v3.Uid
		local var4 = tbl5[var2]
		if not var4 then
			var4 = var16:Clone()
			var4.Name = var2
			var4.Visible = true
			var4:SetAttribute("CarId", v3.Id)
			var4.Button.Activated:Connect(function()
				if not bool3 then
					tbl3[var2] = not tbl3[var2] or nil
					updateTotal()
				end
			end)

			var4.ImageLabel:GetPropertyChangedSignal("IsLoaded"):Connect(updatePreviews)
			var4.Parent = var14.List
			tbl5[var2] = var4
		end

		var4.LayoutOrder = k3
		local var5 = v3.Price
		var4.Price.Text = "$" .. var12.Format(var13.fromNumber(var5))
		var4.ImageLabel.Image = v3.Image or ""
		var4.ImageLabel.Visible = v3.Image ~= ""
	end

	updateTotal()
	task.defer(updatePreviews)
end

local bool4 = false
local function refreshInventory()
	local var1 = num1 + 1
	num1 = var1
	local success, result = pcall(function()
		return var21.GetSellInventory:InvokeServer()
	end)

	if success and num1 == num1 then
		renderItems(result)
	end
end

var14:GetPropertyChangedSignal("Visible"):Connect(function()
	if var14.Visible then
		task.spawn(refreshInventory)
		return
	end

	updatePreviews()
end)

var14.List:GetPropertyChangedSignal("CanvasPosition"):Connect(updatePreviews)
var14.SellBar.SellFrame.Button.Activated:Connect(function()
	if bool3 then
		return
	end

	local tbl1 = {}
	for k1 in pairs(tbl3) do
		table.insert(tbl1, k1)
	end

	if #tbl1 == 0 then
		return
	end

	bool3 = true
	local var1 = num1 + 1
	num1 = var1
	var14.SellBar.SellFrame.Text.Text = "Selling..."
	local success, result = pcall(function()
		local var1 = tbl1
		return var21.SellCars:InvokeServer(var1)
	end)

	if success then
		if result then
			if result.Success then
				table.clear(tbl3)
			end

			renderItems(result.Items)
			local var2 = var14.SellBar.SellFrame.Text
			local var3
			if result.Success then
				var3 = "Sold!"
			else
				var3 = if result.Reason == "InventoryChanged" then "Try again" else "Unavailable"
			end

			var2.Text = var3
		else
			var14.SellBar.SellFrame.Text.Text = "Try again"
		end
	else
		var14.SellBar.SellFrame.Text.Text = "Try again"
	end

	bool3 = false
	task.delay(1, function()
		if not bool3 then
			var14.SellBar.SellFrame.Text.Text = "Sell"
		end
	end)
end)

local tbl6 = {}
local function queueRefresh()
	if bool4 then
		return
	end

	bool4 = true
	task.delay(0.1, function()
		bool4 = false
		if var14.Visible and (not bool3) then
			local var1 = num1 + 1
			num1 = var1
			local success, result = pcall(function()
				return var21.GetSellInventory:InvokeServer()
			end)

			if success and num1 == num1 then
				renderItems(result)
			end
		end
	end)
end

local function bindBackpack(arg1)
	if not arg1:IsA("Backpack") then
		return
	end

	for k1, v1 in tbl6, nil do
		v1:Disconnect()
	end

	table.clear(tbl6)
	local var1 = queueRefresh
	table.insert(tbl6, arg1.ChildAdded:Connect(var1))
	var1 = queueRefresh
	table.insert(tbl6, arg1.ChildRemoved:Connect(var1))
	if bool4 then
		return
	end

	bool4 = true
	task.delay(0.1, function()
		bool4 = false
		if var14.Visible and (not bool3) then
			local var1 = num1 + 1
			num1 = var1
			local success, result = pcall(function()
				return var21.GetSellInventory:InvokeServer()
			end)

			if success and num1 == num1 then
				renderItems(result)
			end
		end
	end)
end

var2.ChildAdded:Connect(bindBackpack)
local str1 = "Backpack"
bindBackpack(var2:WaitForChild(str1))
local tbl7 = {}
local tbl8 = { Trails = false, Sell = false }
local function bindCharacter(arg1)
	for k1, v1 in tbl7, nil do
		v1:Disconnect()
	end

	table.clear(tbl7)
	local var1 = queueRefresh
	table.insert(tbl7, arg1.ChildAdded:Connect(var1))
	var1 = queueRefresh
	table.insert(tbl7, arg1.ChildRemoved:Connect(var1))
	tbl8.Trails = false
	tbl8.Sell = false
	var9.SetWindow(var4, false)
	var9.SetWindow(var14, false)
end

var2.CharacterAdded:Connect(bindCharacter)
local function fitPanels()
	local var2 = workspace.CurrentCamera
	if not var2 then
		return
	end

	local var5 = var2.ViewportSize.X < 1000
	local var6 = var4
	local var7 = if var5 then UDim2.fromScale(0.92, 0.78) else var18
	var6.Size = var7
	var6 = var14
	var7 = if var5 then UDim2.fromScale(0.92, 0.78) else var19
	var6.Size = var7
end

if var2.Character then
	bindCharacter(var2.Character)
end

var20.CoreFeedback.OnClientEvent:Connect(function(arg1)
	if arg1.Kind ~= "TrailPurchase" or arg1.Success then
		return
	end

	if arg1.Action ~= "Equip" then
		var10.Play("Error")
	end

	local var3 = tbl1[arg1.TrailId]
	if var3 then
		local var4 = var3.Cash.Price
		local var5 = var4.Text
		var4.Text = if arg1.Reason == "NotEnoughCash" then "Need cash" else "Unavailable"
		task.delay(1, function()
			if var4.Parent and var4.Text ~= var5 then
				updateTrailRows()
			end
		end)

	end
end)

local var22 = nil
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if var22 then
		var22:Disconnect()
	end

	local var2 = workspace.CurrentCamera
	if var2 then
		var22 = var2:GetPropertyChangedSignal("ViewportSize"):Connect(fitPanels)
	end

	local var5 = workspace.CurrentCamera
	if not var5 then
		return
	end

	local var7 = var5.ViewportSize.X < 1000
	local var8 = var4
	local var9 = if var7 then UDim2.fromScale(0.92, 0.78) else var18
	var8.Size = var9
	var8 = var14
	var9 = if var7 then UDim2.fromScale(0.92, 0.78) else var19
	var8.Size = var9
end)

if var22 then
	var22:Disconnect()
end

local var24 = workspace.CurrentCamera
if var24 then
	var24:GetPropertyChangedSignal("ViewportSize"):Connect(fitPanels)
end

local var26 = workspace.CurrentCamera
if not var26 then
else
	local var28 = var26.ViewportSize.X < 1000
	local var29 = if var28 then UDim2.fromScale(0.92, 0.78) else var18
	var4.Size = var29
	var29 = if var28 then UDim2.fromScale(0.92, 0.78) else var19
	var14.Size = var29
end

var24 = 0
var5.Heartbeat:Connect(function(arg1)
	local var1 = var24 + arg1
	var24 = var1
	if var24 < 0.1 then
		return
	end

	var24 = 0
	local str1 = "Sell"
	for k1, v1 in { "Trails", str1 }, nil do
		local var3 = var6.PlayerInside(var2, v1, 0) == true
		if var3 == tbl8[v1] then
			continue
		end

		tbl8[v1] = var3
		if var3 then
			local var7 = if v1 == "Trails" then "Sell" else "Trails"
			local var8 = var7 == "Trails"
			var9.SetWindow(if var7 == "Trails" then var4 else var14, false)
		end

		local var10 = if v1 == "Trails" then var4 else var14
		if v1 == "Trails" and var3 then
			var4.List.CanvasPosition = Vector2.zero
			if var17 and (not bool1) then
				task.spawn(var17)
			end
		end

		var9.SetWindow(var10, var3)
	end
end)

--- Players.LocalPlayer.PlayerScripts.SatchelAppearanceController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BackpackGui")
local var2 = game.ReplicatedStorage.Remotes.Events:WaitForChild("EquipMiniCar")
var1:GetAttributeChangedSignal("EquipRequestRevision"):Connect(function()
	local var3 = var1:GetAttribute("RequestedMiniCarUid")
	if type(var3) == "string" then
		var2:FireServer(var3)
	end
end)

local var3 = setmetatable({}, { __mode = "k" })
local var4 = require(game.ReplicatedStorage.Modules.MiniCarSlots)
local var5 = require(game.ReplicatedStorage.Modules.UIEffects)
local function bind(arg1)
	if not arg1:IsA("ObjectValue") or (arg1.Name ~= "SatchelTool" or var3[arg1]) then
		return
	end

	local var2 = arg1.Parent
	if not var2 or (not var2:IsA("GuiButton")) then
		return
	end

	var3[arg1] = true
	local function update()
		if var2.Parent then
			var4.SetTool(var2, arg1.Value, var2.Icon, var2.ToolName)
		end
	end

	arg1:GetPropertyChangedSignal("Value"):Connect(update)
	var2:GetAttributeChangedSignal("VisualRevision"):Connect(update)
	var2:GetAttributeChangedSignal("ResetHoverRevision"):Connect(function()
		var5.Reset(var2)
	end)

	if var2.Parent then
		var4.SetTool(var2, arg1.Value, var2.Icon, var2.ToolName)
	end
end

for k1, v1 in var1:GetDescendants() do
	bind(v1)
end

var1.DescendantAdded:Connect(bind)
var1:GetAttributeChangedSignal("InventoryOpen"):Connect(function()
	local var3 = var1:GetAttribute("InventoryOpen")
	local var4 = var5.Play
	var4(if var3 then "Open" else "Close", var1)
	if not var3 then
		var4 = var1:FindFirstChild("Backpack")
		var4 = var4 or var1:FindFirstChildWhichIsA("Frame")
		if var4 then
			var5.Reset(var4)
		end
	end
end)

--- Players.LocalPlayer.PlayerScripts.HighlightService [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local tbl1 = {}
local var1 = require(game.ReplicatedStorage.Modules.PromptPolicy)
local var2 = game:GetService("Players").LocalPlayer
local var3 = script:WaitForChild("Highlight")
local tbl2 = {}
local var4 = game:GetService("ProximityPromptService")
var4.PromptHidden:Connect(function(arg1)
	local var2 = tbl2[arg1]
	if not var2 then
		return
	end

	tbl2[arg1] = nil
	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	local var3 = var2.target
	local var4 = var3
	var4 = var4 and tbl1[var3]
	if var4 then
		local var5 = var4.count - 1
		var4.count = var5
		if var4.count == 0 then
			var4.highlight:Destroy()
			tbl1[var3] = nil
		end
	end

	var2.target = nil
end)

local function update(arg1, arg2)
	local var4 = var1.CanShow(arg1, var2)
	var4 = var4 and var1.GetHighlightTarget(arg1)
	var4 = var4 and (var4:IsDescendantOf(workspace) or nil)
	if arg2.target == var4 then
		return
	end

	local var5 = arg2.target
	local var6 = var5
	var6 = var6 and tbl1[var5]
	if var6 then
		local var7 = var6.count - 1
		var6.count = var7
		if var6.count == 0 then
			var6.highlight:Destroy()
			tbl1[var5] = nil
		end
	end

	arg2.target = nil
	if not var4 then
		return
	end

	var5 = tbl1[var4]
	if not var5 then
		var6 = var3:Clone()
		var6.Name = "PromptHighlight"
		var6.Adornee = var4
		var6.Enabled = true
		var6.Parent = script
		var5 = { highlight = var6, count = 0 }
		tbl1[var4] = var5
	end

	var6 = var5.count + 1
	var5.count = var6
	arg2.target = var4
end

var4.PromptShown:Connect(function(arg1)
	local var4 = tbl2[arg1]
	if not not var4 then
		tbl2[arg1] = nil
		for k1, v1 in var4.connections, nil do
			v1:Disconnect()
		end

		local var5 = var4.target
		local var6 = var5
		var6 = var6 and tbl1[var5]
		if var6 then
			local var7 = var6.count - 1
			var6.count = var7
			if var6.count == 0 then
				var6.highlight:Destroy()
				tbl1[var5] = nil
			end
		end

		var4.target = nil
	end

	if not var1.CanShow(arg1, var2) then
		return
	end

	var4 = { connections = {} }
	tbl2[arg1] = var4
	local var9 = arg1:FindFirstChild("HighlightTarget")
	if var9 and var9:IsA("ObjectValue") then
		local function fn4()
			update(arg1, var4)
		end

		table.insert(var4.connections, var9.Changed:Connect(fn4))
	end

	fn4 = function()
		if not var1.CanShow(arg1, var2) then
			local var4 = arg1
			local var6 = tbl2[var4]
			if not var6 then
				return
			end

			tbl2[var4] = nil
			for k1, v1 in var6.connections, nil do
				v1:Disconnect()
			end

			local var7 = var6.target
			local var8 = var7
			var8 = var8 and tbl1[var7]
			if var8 then
				local var9 = var8.count - 1
				var8.count = var9
				if var8.count == 0 then
					var8.highlight:Destroy()
					tbl1[var7] = nil
				end
			end

			var6.target = nil
		end
	end

	table.insert(var4.connections, arg1:GetPropertyChangedSignal("Enabled"):Connect(fn4))
	fn4 = function()
		local var1 = arg1
		local var3 = tbl2[var1]
		if not var3 then
			return
		end

		tbl2[var1] = nil
		for k1, v1 in var3.connections, nil do
			v1:Disconnect()
		end

		local var4 = var3.target
		local var5 = var4
		var5 = var5 and tbl1[var4]
		if var5 then
			local var6 = var5.count - 1
			var5.count = var6
			if var5.count == 0 then
				var5.highlight:Destroy()
				tbl1[var4] = nil
			end
		end

		var3.target = nil
	end

	table.insert(var4.connections, arg1.Destroying:Connect(fn4))
	local var11 = var1.GetPlot(arg1)
	if var11 then
		local function fn8()
			if not var1.CanShow(arg1, var2) then
				local var4 = arg1
				local var6 = tbl2[var4]
				if not var6 then
					return
				end

				tbl2[var4] = nil
				for k1, v1 in var6.connections, nil do
					v1:Disconnect()
				end

				local var7 = var6.target
				local var8 = var7
				var8 = var8 and tbl1[var7]
				if var8 then
					local var9 = var8.count - 1
					var8.count = var9
					if var8.count == 0 then
						var8.highlight:Destroy()
						tbl1[var7] = nil
					end
				end

				var6.target = nil
			end
		end

		table.insert(var4.connections, var11:GetAttributeChangedSignal("Owner"):Connect(fn8))
	end

	update(arg1, var4)
end)

--- Players.LocalPlayer.PlayerScripts.ProximityPromptScript [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = game:GetService("UserInputService")
local var3 = game:GetService("ProximityPromptService")
local var4 = game:GetService("TweenService")
local var5 = game:GetService("TextService")
local var6 = require(game.ReplicatedStorage.Modules.PromptPolicy)
local var7 = var1:WaitForChild("PlayerGui")
local tbl1 = {
	[Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/xboxX.png",
	[Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/xboxY.png",
	[Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/xboxA.png",
	[Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/xboxB.png",
	[Enum.KeyCode.DPadLeft] = "rbxasset://textures/ui/Controls/dpadLeft.png",
	[Enum.KeyCode.DPadRight] = "rbxasset://textures/ui/Controls/dpadRight.png",
	[Enum.KeyCode.DPadUp] = "rbxasset://textures/ui/Controls/dpadUp.png",
	[Enum.KeyCode.DPadDown] = "rbxasset://textures/ui/Controls/dpadDown.png",
	[Enum.KeyCode.ButtonSelect] = "rbxasset://textures/ui/Controls/xboxmenu.png",
	[Enum.KeyCode.ButtonL1] = "rbxasset://textures/ui/Controls/xboxLS.png",
	[Enum.KeyCode.ButtonR1] = "rbxasset://textures/ui/Controls/xboxRS.png",
}

local tbl2 = {
	[Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
	[Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
	[Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
	[Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png",
}

local tbl3 = {
	["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
	[","] = "rbxasset://textures/ui/Controls/comma.png",
	["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
	["."] = "rbxasset://textures/ui/Controls/period.png",
	[" "] = "rbxasset://textures/ui/Controls/spacebar.png",
}

local tbl4 = {
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.RightControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.RightAlt] = "Alt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12",
}

local tbl5 = {}
var3.PromptHidden:Connect(function(arg1)
	local var2 = tbl5[arg1]
	if not var2 then
		return
	end

	tbl5[arg1] = nil
	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	if var2.cleanup then
		var2.cleanup()
	end
end)

local function createPrompt(arg1, arg2, arg3, arg4)
	TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local var7 = arg1:GetAttribute("Theme")
	local tbl5 = {}
	local tbl6 = {}
	local tbl7 = {}
	local tbl8 = {}
	local var8 = TweenInfo.new(arg1.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local var9 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local var10 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local var11 = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local var12 = nil
	if var7 then
		local var14 = script:FindFirstChild(var7)
		if var14 then
			var12 = var14:Clone()
		end
	end

	if var12 == nil then
		var12 = script.Default:Clone()
	end

	var12.Enabled = true
	local var15 = var12.PromptFrame
	local var16 = var15.BackgroundTransparency
	var15.BackgroundTransparency = 1
	local var17 = var15.ImageTransparency
	var15.ImageTransparency = 1
	local var18 = var15
	local var19 = var9
	local tbl9 = { Size = UDim2.fromScale(0.5, 1), BackgroundTransparency = 1, ImageTransparency = 1 }
	table.insert(tbl5, var4:Create(var18, var19, tbl9))
	tbl9 = { Size = UDim2.fromScale(1, 1) }
	tbl9.BackgroundTransparency = var16
	tbl9.ImageTransparency = var17
	var18 = var15
	var19 = var9
	table.insert(tbl6, var4:Create(var18, var19, tbl9))
	var18 = var15
	var19 = var9
	tbl9 = { Size = UDim2.fromScale(0.5, 1), BackgroundTransparency = 1, ImageTransparency = 1 }
	table.insert(tbl7, var4:Create(var18, var19, tbl9))
	tbl9 = { Size = UDim2.fromScale(1, 1) }
	tbl9.BackgroundTransparency = var16
	tbl9.ImageTransparency = var17
	var18 = var15
	var19 = var9
	table.insert(tbl8, var4:Create(var18, var19, tbl9))
	local function setupUIStrokeTweens(arg1)
		local var1 = arg1.Transparency
		arg1.Transparency = 1
		local var2 = arg1
		local var3 = var9
		local tbl1 = { Transparency = 1 }
		table.insert(tbl5, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { Transparency = var1 }
		table.insert(tbl6, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { Transparency = 1 }
		table.insert(tbl7, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { Transparency = var1 }
		table.insert(tbl8, var4:Create(var2, var3, tbl1))
	end

	local function setupGUIObjectTweens(arg1)
		local var1 = arg1.BackgroundTransparency
		arg1.BackgroundTransparency = 1
		local var2 = arg1
		local var3 = var9
		local tbl1 = { BackgroundTransparency = 1 }
		table.insert(tbl5, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { BackgroundTransparency = var1 }
		table.insert(tbl6, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { BackgroundTransparency = 1 }
		table.insert(tbl7, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { BackgroundTransparency = var1 }
		table.insert(tbl8, var4:Create(var2, var3, tbl1))
	end

	local function setupTextLabelTweens(arg1)
		local var1 = arg1.TextTransparency
		arg1.TextTransparency = 1
		local var2 = arg1.TextStrokeTransparency
		arg1.TextStrokeTransparency = 1
		local var3 = arg1
		local var5 = var9
		local tbl1 = { TextTransparency = 1, TextStrokeTransparency = 1 }
		table.insert(tbl5, var4:Create(var3, var5, tbl1))
		var3 = arg1
		var5 = var9
		tbl1 = { TextTransparency = var1, TextStrokeTransparency = var2 }
		table.insert(tbl6, var4:Create(var3, var5, tbl1))
		var3 = arg1
		var5 = var9
		tbl1 = { TextTransparency = 1, TextStrokeTransparency = 1 }
		table.insert(tbl7, var4:Create(var3, var5, tbl1))
		var3 = arg1
		var5 = var9
		tbl1 = { TextTransparency = var1, TextStrokeTransparency = var2 }
		table.insert(tbl8, var4:Create(var3, var5, tbl1))
	end

	local function setupImageLabelTweens(arg1)
		local var1 = arg1.ImageTransparency
		arg1.ImageTransparency = 1
		local var2 = arg1
		local var3 = var9
		local tbl1 = { ImageTransparency = 1 }
		table.insert(tbl5, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { ImageTransparency = var1 }
		table.insert(tbl6, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { ImageTransparency = 1 }
		table.insert(tbl7, var4:Create(var2, var3, tbl1))
		var2 = arg1
		var3 = var9
		tbl1 = { ImageTransparency = var1 }
		table.insert(tbl8, var4:Create(var2, var3, tbl1))
	end

	var18 = function(arg1)
		if arg1:IsA("UIStroke") then
			setupUIStrokeTweens(arg1)
		else
			if arg1:IsA("UIGradient") then
			else
				if arg1:IsA("GuiObject") then
					setupGUIObjectTweens(arg1)
					if arg1:IsA("TextLabel") then
						setupTextLabelTweens(arg1)
					else
						if arg1:IsA("ImageLabel") then
							setupImageLabelTweens(arg1)
						end
					end
				end
			end
		end

		for k1, v1 in pairs(arg1:GetChildren()) do
			var18(v1)
		end
	end

	local var20 = var15.InputFrame
	local var21 = var15.ActionText
	local var22 = var15.ObjectText
	var19 = { [var20] = false, [var21] = true, [var22] = true }
	for k1, v1 in pairs(var15:GetChildren()) do
		if var19[v1] == nil then
			var18(v1)
		else
			if var19[v1] ~= true then
				continue
			end

			for k2, v2 in pairs(v1:GetChildren()) do
				var18(v2)
			end
		end
	end

	tbl9 = var20.Frame
	local var23 = tbl9.UIScale
	local var24 = var23
	local var25 = var9
	local tbl10 = { Scale = if arg2 == Enum.ProximityPromptInputType.Touch then 1.6 else 1.33 }
	table.insert(tbl5, var4:Create(var24, var25, tbl10))
	var24 = var23
	var25 = var9
	tbl10 = { Scale = 1 }
	table.insert(tbl6, var4:Create(var24, var25, tbl10))
	setupTextLabelTweens(var21)
	setupTextLabelTweens(var22)
	local var26 = tbl9.ButtonFrame;
	(function()
		local var1 = var26
		local var2 = var10
		local tbl1 = { BackgroundTransparency = 1, ImageTransparency = 1 }
		table.insert(tbl7, var4:Create(var1, var2, tbl1))
		var1 = var26
		var2 = var10
		tbl1 = {
			BackgroundTransparency = var26.BackgroundTransparency,
			ImageTransparency = var26.ImageTransparency,
		}

		table.insert(tbl8, var4:Create(var1, var2, tbl1))
		for k1, v1 in pairs(var26:getChildren()) do
			if not v1:IsA("UIStroke") then
				continue
			end

			local var3 = v1
			local var5 = var10
			local tbl2 = { Transparency = 1 }
			table.insert(tbl7, var4:Create(var3, var5, tbl2))
			var3 = v1
			var5 = var10
			tbl2 = { Transparency = v1.Transparency }
			table.insert(tbl8, var4:Create(var3, var5, tbl2))
		end
	end)()

	local var27 = tbl9.ButtonText
	local var28 = tbl9.ButtonImage
	var24 = tbl9.ButtonTextImage
	var25 = function()
		var27.BackgroundTransparency = 1
		var27.TextStrokeTransparency = 1
		var27.TextTransparency = 1
		local var1 = var27
		local var2 = var10
		local tbl1 = { TextTransparency = 1, TextStrokeTransparency = 1, BackgroundTransparency = 1 }
		table.insert(tbl7, var4:Create(var1, var2, tbl1))
		var1 = var27
		var2 = var10
		tbl1 = {
			TextTransparency = var27.TextTransparency,
			TextStrokeTransparency = var27.TextStrokeTransparency,
			BackgroundTransparency = var27.BackgroundTransparency,
		}

		table.insert(tbl8, var4:Create(var1, var2, tbl1))
		for k1, v1 in pairs(var27:getChildren()) do
			if not v1:IsA("UIStroke") then
				continue
			end

			local var3 = v1
			local var5 = var10
			local tbl2 = { Transparency = 1 }
			table.insert(tbl7, var4:Create(var3, var5, tbl2))
			var3 = v1
			var5 = var10
			tbl2 = { Transparency = v1.Transparency }
			table.insert(tbl8, var4:Create(var3, var5, tbl2))
		end
	end

	tbl10 = function()
		var28.BackgroundTransparency = 1
		var28.ImageTransparency = 1
		local var1 = var28
		local var2 = var10
		local tbl1 = { ImageTransparency = 1, BackgroundTransparency = 1 }
		table.insert(tbl7, var4:Create(var1, var2, tbl1))
		var1 = var28
		var2 = var10
		tbl1 = {
			ImageTransparency = var28.ImageTransparency,
			BackgroundTransparency = var28.BackgroundTransparency,
		}

		table.insert(tbl8, var4:Create(var1, var2, tbl1))
	end

	local function setupIconTweens()
		var24.BackgroundTransparency = 1
		var24.ImageTransparency = 1
		local var1 = var24
		local var2 = var10
		local tbl1 = { ImageTransparency = 1, BackgroundTransparency = 1 }
		table.insert(tbl7, var4:Create(var1, var2, tbl1))
		var1 = var24
		var2 = var10
		tbl1 = {
			ImageTransparency = var24.ImageTransparency,
			BackgroundTransparency = var24.BackgroundTransparency,
		}

		table.insert(tbl8, var4:Create(var1, var2, tbl1))
	end

	if arg2 == Enum.ProximityPromptInputType.Gamepad then
		if tbl1[arg1.GamepadKeyCode] then
			setupIconTweens()
			var24.Image = tbl1[arg1.GamepadKeyCode]
			var27.Visible = false
			var28.Visible = false
			var24.Visible = true
		end
	else
		if arg2 == Enum.ProximityPromptInputType.Touch then
			tbl10()
			var28.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
			var27.Visible = false
			var24.Visible = false
			var28.Visible = true
		else
			tbl10()
			var28.Visible = true
			local var31 = tbl2[arg1.KeyboardKeyCode]
			local var32 = var2:GetStringForKeyCode(arg1.KeyboardKeyCode)
			if var31 == nil then
				var31 = tbl3[var32]
			end

			if var31 == nil then
				local var35 = tbl4[arg1.KeyboardKeyCode]
				if var35 then
					var32 = var35
				end
			end

			if var31 then
				setupIconTweens()
				var24.Image = var31
				var27.Visible = false
				var24.Visible = true
			elseif var32 ~= nil then
				if var32 ~= "" then
					if 2 < string.len(var32) then
						local var36 = math.round(var27.TextSize * 6 / 7)
						var27.TextSize = var36
					end

					var25()
					var27.Text = var32
					var24.Visible = false
					var27.Visible = true
				else
					error("ProximityPrompt '" .. arg1.Name .. "' has an unsupported keycode for rendering UI: " .. tostring(arg1.KeyboardKeyCode))
				end
			else
				error("ProximityPrompt '" .. arg1.Name .. "' has an unsupported keycode for rendering UI: " .. tostring(arg1.KeyboardKeyCode))
			end
		end
	end

	if arg2 == Enum.ProximityPromptInputType.Touch or arg1.ClickablePrompt then
		local var38 = var12.TextButton
		local bool2 = false
		var38.InputBegan:Connect(function(arg1)
			if (arg1.UserInputType == Enum.UserInputType.Touch or arg1.UserInputType == Enum.UserInputType.MouseButton1) and arg1.UserInputState ~= Enum.UserInputState.Change then
				arg1:InputHoldBegin()
				bool2 = true
			end
		end)

		var38.InputEnded:Connect(function(arg1)
			if (arg1.UserInputType == Enum.UserInputType.Touch or arg1.UserInputType == Enum.UserInputType.MouseButton1) and bool2 then
				bool2 = false
				arg1:InputHoldEnd()
			end
		end)

		var12.Active = true
	end

	if 0 < arg1.HoldDuration then
		local var42 = tbl9.ProgressBar
		local var43 = var42.LeftGradient.ProgressBarImage.UIGradient
		local var44 = var42.RightGradient.ProgressBarImage.UIGradient
		var42.Progress.Changed:Connect(function(arg1)
			local var1 = math.clamp(arg1 * 360, 0, 360)
			var43.Rotation = math.clamp(var1, 180, 360)
			var44.Rotation = math.clamp(var1, 0, 180)
		end)

		local var45 = var42.Progress
		local var46 = var8
		local tbl11 = { Value = 1 }
		table.insert(tbl5, var4:Create(var45, var46, tbl11))
		var45 = var42.Progress
		var46 = var11
		tbl11 = { Value = 0 }
		table.insert(tbl6, var4:Create(var45, var46, tbl11))
	end

	local var49 = nil
	local var50 = nil
	local var51 = nil
	local var52 = nil
	if 0 < arg1.HoldDuration then
		var49 = arg1.PromptButtonHoldBegan:Connect(function()
			for k1, v1 in ipairs(tbl5) do
				v1:Play()
			end
		end)

		var50 = arg1.PromptButtonHoldEnded:Connect(function()
			for k1, v1 in ipairs(tbl6) do
				v1:Play()
			end
		end)

	end

	local tbl12 = {
		ActionText = true,
		ObjectText = true,
		UIOffset = true,
		AutoLocalize = true,
		RootLocalizationTable = true,
	}

	local function updateUIFromPrompt()
		if not arg4() then
			return
		end

		local var1 = Instance.new("GetTextBoundsParams")
		var1.Text = arg1.ActionText
		var1.Font = var21.FontFace
		var1.Size = var21.TextSize
		var1.Width = 1000
		local var2 = var5:GetTextBoundsAsync(var1)
		local var3 = Instance.new("GetTextBoundsParams")
		var3.Text = arg1.ObjectText
		var3.Font = var22.FontFace
		var3.Size = var22.TextSize
		var3.Width = 1000
		var1:Destroy()
		var3:Destroy()
		local var4 = var5:GetTextBoundsAsync(var3)
		if not arg4() then
			return
		end

		local var6 = math.max(var2.X, var4.X)
		local num2 = 72
		if arg1.ActionText ~= nil then
			if arg1.ActionText == "" then
				if arg1.ObjectText ~= nil and arg1.ObjectText ~= "" then
					num2 = var6 + 72 + 24
				end
			end
		end

		local num4 = 0
		if arg1.ObjectText ~= nil and arg1.ObjectText ~= "" then
			num4 = 9
		end

		var21.Position = UDim2.new(0.5, 72 - num2 / 2, 0, num4)
		var22.Position = UDim2.new(0.5, 72 - num2 / 2, 0, -10)
		var21.Text = arg1.ActionText
		var22.Text = arg1.ObjectText
		var21.AutoLocalize = arg1.AutoLocalize
		var21.RootLocalizationTable = arg1.RootLocalizationTable
		var22.AutoLocalize = arg1.AutoLocalize
		var22.RootLocalizationTable = arg1.RootLocalizationTable
		var12.Size = UDim2.fromOffset(num2, 72)
		var12.SizeOffset = Vector2.new(arg1.UIOffset.X / var12.Size.Width.Offset, arg1.UIOffset.Y / var12.Size.Height.Offset)
	end

	updateUIFromPrompt()
	var51 = arg1.Triggered:Connect(function()
		for k1, v1 in ipairs(tbl7) do
			v1:Play()
		end
	end)

	var52 = arg1.TriggerEnded:Connect(function()
		for k1, v1 in ipairs(tbl8) do
			v1:Play()
		end
	end)

	local var53 = arg1.Changed:Connect(function(arg1)
		if tbl12[arg1] then
			updateUIFromPrompt()
		end
	end)

	var12.Adornee = arg1.Parent
	if arg4() then
		var12.Parent = arg3
	end

	for k3, v3 in ipairs(tbl8) do
		v3:Play()
	end

	local bool3 = false
	return function()
		if bool3 then
			return
		end

		bool3 = true
		var12.Active = false
		if var49 then
			var49:Disconnect()
		end

		if var50 then
			var50:Disconnect()
		end

		var51:Disconnect()
		var52:Disconnect()
		var53:Disconnect()
		for k1, v1 in ipairs(tbl7) do
			v1:Play()
		end

		task.delay(0.2, function()
			var12:Destroy()
		end)
	end
end

var3.PromptShown:Connect(function(arg1, arg2)
	local var3 = tbl5[arg1]
	if not not var3 then
		tbl5[arg1] = nil
		for k1, v1 in var3.connections, nil do
			v1:Disconnect()
		end

		if var3.cleanup then
			var3.cleanup()
		end
	end

	if arg1.Style ~= Enum.ProximityPromptStyle.Custom or (not var6.CanShow(arg1, var1)) then
		return
	end

	var3 = { connections = {} }
	tbl5[arg1] = var3
	local function fn2()
		local var1 = arg1
		local var3 = tbl5[var1]
		if not var3 then
			return
		end

		tbl5[var1] = nil
		for k1, v1 in var3.connections, nil do
			v1:Disconnect()
		end

		if var3.cleanup then
			var3.cleanup()
		end
	end

	table.insert(var3.connections, arg1.Destroying:Connect(fn2))
	fn2 = function()
		local bool2 = false
		if tbl5[arg1] == var3 then
			bool2 = var6.CanShow(arg1, var1)
		end

		if not bool2 then
			bool2 = arg1
			local var4 = tbl5[bool2]
			if not var4 then
				return
			end

			tbl5[bool2] = nil
			for k1, v1 in var4.connections, nil do
				v1:Disconnect()
			end

			if var4.cleanup then
				var4.cleanup()
			end
		end
	end

	table.insert(var3.connections, arg1:GetPropertyChangedSignal("Enabled"):Connect(fn2))
	local var5 = var6.GetPlot(arg1)
	local function isCurrent()
		local bool2 = false
		if tbl5[arg1] == var3 then
			bool2 = var6.CanShow(arg1, var1)
		end

		return bool2
	end

	if var5 then
		local function fn7()
			local bool2 = false
			if tbl5[arg1] == var3 then
				bool2 = var6.CanShow(arg1, var1)
			end

			if not bool2 then
				bool2 = arg1
				local var4 = tbl5[bool2]
				if not var4 then
					return
				end

				tbl5[bool2] = nil
				for k1, v1 in var4.connections, nil do
					v1:Disconnect()
				end

				if var4.cleanup then
					var4.cleanup()
				end
			end
		end

		table.insert(var3.connections, var5:GetAttributeChangedSignal("Owner"):Connect(fn7))
	end

	fn2 = var7:FindFirstChild("ProximityPrompts")
	local var8 = createPrompt
	local var9 = arg1
	local var10 = arg2
	if fn2 == nil then
		fn2 = Instance.new("ScreenGui")
		fn2.Name = "ProximityPrompts"
		fn2.ResetOnSpawn = false
		fn2.Parent = var7
	end

	var8 = var8(var9, var10, fn2, isCurrent)
	var9 = false
	if tbl5[arg1] == var3 then
		var9 = var6.CanShow(arg1, var1)
	end

	if var9 then
		var3.cleanup = var8
		return
	end

	var8()
	var9 = tbl5[arg1]
	if not var9 then
		return
	end

	tbl5[arg1] = nil
	for k2, v2 in var9.connections, nil do
		v2:Disconnect()
	end

	if var9.cleanup then
		var9.cleanup()
	end
end)

--- Players.LocalPlayer.PlayerScripts.PromptHide [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = require(game.ReplicatedStorage.Modules.PromptPolicy)
local var2 = game:GetService("Players").LocalPlayer
local var3 = require(game.ReplicatedStorage.Configs.PlotConfig)
local tbl1 = {}
local function refresh(arg1, arg2)
	if arg2.writing or (not arg1.Parent) then
		return
	end

	local var5 = arg1:GetAttribute("PromptAvailable")
	local var6 = var1.GetPlot(arg1)
	if var5 == nil then
		var5 = arg2.serverEnabled
	end

	local var8 = var5
	if var8 then
		var8 = not var6
		if not var8 then
			var8 = false
			if var6:GetAttribute("Owner") == var2.UserId then
				var8 = var6:GetAttribute("Taken") == true
			end
		end
	end

	local var9 = arg1:GetAttribute("OwnerUserId")
	var9 = var9 or arg1:GetAttribute("TutorialOwnerUserId")
	if var9 then
		if var9 ~= var2.UserId then
			var8 = false
		end
	end

	if arg1:GetAttribute("TutorialDuplicateHidden") then
		var8 = false
	end

	if var8 then
		if arg1.Name == "ParkingPrompt" then
			local var14 = var2.Character
			var14 = var14 and var2.Character:FindFirstChild("HumanoidRootPart")
			local var16 = arg1.Parent
			local bool4 = false
			if var14 ~= nil then
				bool4 = var16:IsA("Attachment")
				if bool4 then
					bool4 = math.abs(var14.Position.Y - var16.WorldPosition.Y) <= var3.ParkingVerticalTolerance
				end
			end

			var8 = bool4
		end
	end

	arg2.writing = true
	arg2.lastApplied = var8
	arg1.Enabled = var8
	arg2.writing = false
end

local tbl2 = {}
local function refreshPlot(arg1)
	for k1, v1 in tbl1, nil do
		if var1.GetPlot(k1) ~= arg1 then
			continue
		end

		refresh(k1, v1)
	end
end

local var4 = workspace:WaitForChild("Plots")
local function bindPlot(arg1)
	if tbl2[arg1] then
		return
	end

	local function fn2()
		refreshPlot(arg1)
	end

	local tbl1 = {
		arg1:GetAttributeChangedSignal("Owner"):Connect(function()
			refreshPlot(arg1)
		end),
		arg1:GetAttributeChangedSignal("Taken"):Connect(fn2),
	}

	tbl2[arg1] = tbl1
end

var4.ChildAdded:Connect(bindPlot)
var4.ChildRemoved:Connect(function(arg1)
	local var1 = tbl2[arg1]
	for k1, v1 in var1 or {}, nil do
		v1:Disconnect()
	end

	tbl2[arg1] = nil
end)

local function bind(arg1)
	if not arg1:IsA("ProximityPrompt") or tbl1[arg1] then
		return
	end

	arg1.Style = Enum.ProximityPromptStyle.Custom
	local tbl2 = { serverEnabled = arg1.Enabled, connections = {} }
	tbl1[arg1] = tbl2
	local function fn2()
		if tbl2.writing or arg1.Enabled == tbl2.lastApplied then
			return
		end

		tbl2.serverEnabled = arg1.Enabled
		refresh(arg1, tbl2)
	end

	table.insert(tbl2.connections, arg1:GetPropertyChangedSignal("Enabled"):Connect(fn2))
	fn2 = function()
		refresh(arg1, tbl2)
	end

	table.insert(tbl2.connections, arg1:GetAttributeChangedSignal("PromptAvailable"):Connect(fn2))
	fn2 = function()
		refresh(arg1, tbl2)
	end

	table.insert(tbl2.connections, arg1:GetAttributeChangedSignal("TutorialDuplicateHidden"):Connect(fn2))
	fn2 = function()
		if not arg1:IsDescendantOf(workspace) then
			local var2 = arg1
			local var4 = tbl1[var2]
			if not var4 then
				return
			end

			tbl1[var2] = nil
			for k1, v1 in var4.connections, nil do
				v1:Disconnect()
			end

			return
		end

		refresh(arg1, tbl2)
	end

	table.insert(tbl2.connections, arg1.AncestryChanged:Connect(fn2))
	refresh(arg1, tbl2)
end

workspace.DescendantAdded:Connect(bind)
for k1, v1 in var4:GetChildren() do
	bindPlot(v1)
end

for k2, v2 in workspace:GetDescendants() do
	bind(v2)
end

local num1 = 0
game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	if num1 < 0.15 then
		return
	end

	num1 = 0
	for k1, v1 in tbl1, nil do
		if k1.Name ~= "ParkingPrompt" then
			continue
		end

		refresh(k1, v1)
	end
end)

--- Players.LocalPlayer.PlayerScripts.TreadmillController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local str1 = "LifecycleWait"
local var1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild(str1))
local var2 = game:GetService("ReplicatedStorage")
local var3 = game:GetService("Players").LocalPlayer
local num1 = 0
local var4 = var2:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("ExitTreadmill")
str1 = game:GetService("UserInputService")
str1.JumpRequest:Connect(function()
	if not var3:GetAttribute("TrainingTier") or os.clock() - num1 < 0.2 then
		return
	end

	num1 = os.clock()
	var4:FireServer()
end)

local var5 = nil
local function bind(arg1)
	if var5 then
		var5:Disconnect()
	end

	local var6 = var1.Child(arg1, "Humanoid", function()
		local bool1 = false
		if var3.Parent ~= nil then
			bool1 = var3.Character == arg1
		end

		return bool1
	end)

	if not var6 then
		return
	end

	var5 = var6:GetPropertyChangedSignal("Jump"):Connect(function()
		if var6.Jump then
			if var3:GetAttribute("TrainingTier") then
				if os.clock() - num1 < 0.2 then
					return
				end

				num1 = os.clock()
				var4:FireServer()
			end
		end
	end)
end

var3.CharacterAdded:Connect(bind)
local var6 = game:GetService("RunService")
local var7 = require(var2.Configs.TreadmillConfig)
if var3.Character then
	task.spawn(bind, var3.Character)
end

var4.OnClientEvent:Connect(function(arg1)
	local var1 = var3.Character
	var1 = var1 and var3.Character:FindFirstChildOfClass("Humanoid")
	if arg1 and (var1 and 0 < var1.Health) then
		var1:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local tbl1 = {}
workspace.DescendantAdded:Connect(function(arg1)
	if arg1:IsA("Model") and arg1:GetAttribute("PlotTreadmill") then
		task.defer(function()
			if not arg1:IsA("Model") or (not arg1:IsDescendantOf(workspace) or (not arg1:GetAttribute("PlotTreadmill"))) then
				return
			end

			local tbl2 = {}
			for k1, v1 in arg1:GetDescendants() do
				if v1:IsA("Beam") or (v1:IsA("ParticleEmitter") or (v1:IsA("Light") or (v1:IsA("Fire") or v1:IsA("Smoke")))) then
					table.insert(tbl2, { object = v1, enabled = v1.Enabled })
				end
			end

			tbl1[arg1] = { items = tbl2, visible = true }
		end)

	end
end)

workspace.DescendantRemoving:Connect(function(arg1)
	if tbl1[arg1] then
		tbl1[arg1] = nil
	end
end)

for k1, v1 in workspace:WaitForChild("Plots"):GetDescendants() do
	if not v1:IsA("Model") then
		continue
	end

	if not v1:GetAttribute("PlotTreadmill") then
		continue
	end

	task.defer(function()
		if not v1:IsA("Model") or (not v1:IsDescendantOf(workspace) or (not v1:GetAttribute("PlotTreadmill"))) then
			return
		end

		local tbl2 = {}
		for k1, v2 in v1:GetDescendants() do
			if v2:IsA("Beam") or (v2:IsA("ParticleEmitter") or (v2:IsA("Light") or (v2:IsA("Fire") or v2:IsA("Smoke")))) then
				table.insert(tbl2, { object = v2, enabled = v2.Enabled })
			end
		end

		tbl1[v1] = { items = tbl2, visible = true }
	end)

end

local num2 = 0
var6.Heartbeat:Connect(function(arg1)
	local var1 = num2 + arg1
	num2 = var1
	if num2 < 0.5 then
		return
	end

	num2 = 0
	var1 = workspace.CurrentCamera
	if not var1 then
		return
	end

	for k1, v1 in tbl1, nil do
		local var2 = k1:FindFirstChild("RunPosition")
		if not var2 then
			continue
		end

		local var3 = (var1.CFrame.Position - var2.Position).Magnitude < var7.EffectDistance
		if var3 == v1.visible then
			continue
		end

		v1.visible = var3
		for k2, v2 in v1.items, nil do
			if not v2.object.Parent then
				continue
			end

			local var4 = var3
			v2.object.Enabled = var4 and v2.enabled
		end
	end
end)

local num3 = -math.huge
local var8 = var2.Remotes.Events:WaitForChild("TreadmillActivity")
str1.InputBegan:Connect(function()
	if not var3:GetAttribute("TrainingTier") then
		return
	end

	local var1 = os.clock()
	if var1 - num3 < 5 then
		return
	end

	num3 = var1
	var8:FireServer()
end)

str1.InputChanged:Connect(function(arg1)
	if arg1.UserInputType == Enum.UserInputType.MouseMovement then
		if 0 >= arg1.Delta.Magnitude then
			return
		end

		if not var3:GetAttribute("TrainingTier") then
			return
		end

		local var1 = os.clock()
		if var1 - num3 < 5 then
			return
		end

		num3 = var1
		var8:FireServer()
		return
	end

	if arg1.UserInputType ~= Enum.UserInputType.Touch then
		if arg1.UserInputType == Enum.UserInputType.MouseWheel then
			if not var3:GetAttribute("TrainingTier") then
				return
			end

			local var2 = os.clock()
			if var2 - num3 < 5 then
				return
			end

			num3 = var2
			var8:FireServer()
			return
		end
	end

	if arg1.KeyCode ~= Enum.KeyCode.Thumbstick1 then
		if arg1.KeyCode ~= Enum.KeyCode.Thumbstick2 then
			return
		end
	end

	if 0.2 < arg1.Position.Magnitude then
		if not var3:GetAttribute("TrainingTier") then
			return
		end

		local var4 = os.clock()
		if var4 - num3 < 5 then
			return
		end

		num3 = var4
		var8:FireServer()
	end
end)

--- Players.LocalPlayer.PlayerScripts.TreadmillRevealController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = setmetatable({}, { __mode = "k" })
local var2 = game:GetService("RunService")
local var3 = game:GetService("TweenService")
local function bind(arg1)
	if not arg1:IsA("Model") or (not arg1:GetAttribute("PlotTreadmill") or var1[arg1]) then
		return
	end

	var1[arg1] = true
	task.defer(function()
		if not arg1.Parent then
			return
		end

		local var4 = arg1:GetAttribute("RevealTime")
		if not var4 then
			return
		end

		local var6 = workspace:GetServerTimeNow() - var4
		if 0.6 < var6 then
			return
		end

		local var7 = math.max(0.05, 0.6 - math.max(0, var6))
		local var8 = arg1:GetScale()
		local tbl1 = {}
		for k1, v1 in arg1:GetDescendants() do
			if not v1:IsA("BasePart") then
				continue
			end

			local var9 = v1:GetAttribute("TreadmillTransparency")
			if not var9 then
				continue
			end

			tbl1[v1] = var9
		end

		local var10 = nil
		local num1 = 0
		var2.RenderStepped:Connect(function(arg1)
			if not arg1.Parent then
				var10:Disconnect()
				return
			end

			local var1 = num1 + arg1
			num1 = var1
			var1 = math.min(1, num1 / var7)
			local var2 = var8
			local var4 = 0.82 + 0.18 * var3:GetValue(var1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			arg1:ScaleTo(var2 * var4)
			for k1, v1 in tbl1, nil do
				if not k1.Parent then
					continue
				end

				k1.Transparency = v1 + (1 - v1) * 0.5 * (1 - var1)
			end

			if 1 <= var1 then
				arg1:ScaleTo(var8)
				var10:Disconnect()
			end
		end)
	end)
end

workspace.DescendantAdded:Connect(bind)
for k1, v1 in workspace.Plots:GetDescendants() do
	bind(v1)
end

--- Players.LocalPlayer.PlayerScripts.ChaseSleepEffects [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local tbl1 = {}
local var1 = game:GetService("CollectionService")
local function bind(arg1)
	if not arg1:IsA("ParticleEmitter") or tbl1[arg1] then
		return
	end

	tbl1[arg1] = arg1:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not arg1.Enabled then
			arg1:Clear()
		end
	end)

	if not arg1.Enabled then
		arg1:Clear()
	end
end

var1:GetInstanceAddedSignal("ChaseSleepEffect"):Connect(bind)
var1:GetInstanceRemovedSignal("ChaseSleepEffect"):Connect(function(arg1)
	local var2 = tbl1[arg1]
	if var2 then
		var2:Disconnect()
		tbl1[arg1] = nil
	end
end)

for k1, v1 in var1:GetTagged("ChaseSleepEffect") do
	bind(v1)
end

--- Players.LocalPlayer.PlayerScripts.OffsetListController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = require(game.ReplicatedStorage.Modules.OffsetListLayout)
local var2 = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local function bind(arg1)
	if arg1:IsA("GuiObject") and arg1:GetAttribute("OffsetListKind") then
		var1.Bind(arg1)
	end
end

for k1, v1 in var2:GetDescendants() do
	if not v1:IsA("GuiObject") then
		continue
	end

	if not v1:GetAttribute("OffsetListKind") then
		continue
	end

	var1.Bind(v1)
end

var2.DescendantAdded:Connect(bind)

--- Players.LocalPlayer.PlayerScripts.OfflineIncomeController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("Players").LocalPlayer
local var3 = nil
local var4 = require(var1.Modules.BigNumber)
local var5 = require(var1.Modules.NumberFormatter)
local var6 = var2:WaitForChild("PlayerGui")
local var7 = nil
local bool1 = false
var2:GetAttributeChangedSignal("OfflineCashPerSecond"):Connect(function()
	if not var3 then
		return
	end

	local str1 = "OfflineCashPerSecond"
	local var1 = var4.mul(math.max(0, tonumber(var2:GetAttribute(str1)) or 0), 43200)
	var3.RichText = true
	var3.Text = "You earn <font color=\"#00FF00\">$" .. var5.Format(var1) .. "</font>/12h Offline!"
end)

local function update()
	local var1 = var6:FindFirstChild("Notifications")
	var1 = var1 or var6:FindFirstChild("Notification")
	local var8 = var1
	var8 = var8 and (var1:FindFirstChild("CashText") or var1:FindFirstChild("cashtext"))
	if var8 ~= var3 then
		local var9 = if var8 and var8:IsA("TextLabel") then var8 else nil
		var3 = var9
	if not not var3 then
			local str1 = "OfflineCashPerSecond"
			local var10 = var4.mul(math.max(0, tonumber(var2:GetAttribute(str1)) or 0), 43200)
			var3.RichText = true
			var3.Text = "You earn <font color=\"#00FF00\">$" .. var5.Format(var10) .. "</font>/12h Offline!"
		end
	end

	local var11 = workspace:FindFirstChild("Plots")
	local var14 = var11
	local var15 = var2:GetAttribute("PlotName")
	if var14 then
		var14 = var15
		if var14 then
			var14 = var11:FindFirstChild((tostring(var15)))
		end
	end

	if var14 ~= var7 then
		bool1 = false
		var7 = var14
	end

	local var16 = var2.Character
	local var17 = var16
	local var18 = var16
	local var19 = var14
	var19 = var19 and var14:FindFirstChild("Build")
	local var20 = var19
	var17 = var17 and var16:FindFirstChild("HumanoidRootPart")
	var18 = var18 and var16:FindFirstChildOfClass("Humanoid")
	var20 = var20 and var19:FindFirstChild("Bottom")
	local bool2 = false
	if var14 then
		if var14:GetAttribute("Owner") == var2.UserId then
			if var17 then
				if var18 then
					if 0 < var18.Health then
						if var20 then
							if var20:IsA("BasePart") then
								local var21 = var20.CFrame:PointToObjectSpace(var17.Position)
								local var22 = var20.Size / 2
								local var23 = if bool1 then 2 else 0
								local bool4 = false
								if math.abs(var21.X) <= var22.X + var23 then
									bool4 = false
									if math.abs(var21.Z) <= var22.Z + var23 then
										bool4 = false
										if -4 <= var21.Y then
											bool4 = var21.Y <= var22.Y + 24
										end
									end
								end

								bool2 = bool4
							end
						end
					end
				end
			end
		end
	end

	bool1 = bool2
	if var3 then
		var3.Visible = bool1
	end
end

var2:GetAttributeChangedSignal("PlotName"):Connect(update)
local num1 = 0
game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	if num1 < 0.2 then
		return
	end

	num1 = 0
	update()
end)

update()

--- Players.LocalPlayer.PlayerScripts.ChaseWakeEffects [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("ChaseWakeEffect")
local var2 = game:GetService("Debris")
local tbl1 = {}
local function playWake(arg1)
	local var4 = arg1.PrimaryPart
	if not var4 or (not var1 or (not arg1:IsDescendantOf(workspace))) then
		return
	end

	local var5, var6 = arg1:GetBoundingBox()
	local var7 = var5:PointToWorldSpace((Vector3.new(0, var6.Y / 2 + 1.5, 0)))
	local var8 = var1:Clone()
	var8.Name = "ChaseWakeBurst"
	var8.CFrame = var4.CFrame:ToObjectSpace(CFrame.new(var7) * var1.CFrame.Rotation)
	local num1 = 0
	for k1, v1 in var8:GetDescendants() do
		if not v1:IsA("ParticleEmitter") then
			continue
		end

		v1.Enabled = false
		num1 = math.max(num1, v1.Lifetime.Max)
	end

	var8.Parent = var4
	for k2, v2 in var8:GetDescendants() do
		if not v2:IsA("ParticleEmitter") then
			continue
		end

		local str1 = "EmitCount"
		v2:Emit((math.clamp(math.floor(tonumber(v2:GetAttribute(str1)) or 1), 1, 50)))
	end

	var2:AddItem(var8, num1 + 1)
end

local var3 = workspace:WaitForChild("Zones")
local function bind(arg1)
	if not arg1:IsA("Model") or (not arg1.Parent or (arg1.Parent.Name ~= "ChaseCar" or tbl1[arg1])) then
		return
	end

	local var1 = arg1:GetAttribute("ChaseState")
	tbl1[arg1] = arg1:GetAttributeChangedSignal("ChaseState"):Connect(function()
		local var3 = arg1:GetAttribute("ChaseState")
		if var1 == "Parked" and (var3 == "Jumping" or var3 == "Chasing") then
			playWake(arg1)
		end

		var1 = var3
	end)

	arg1.Destroying:Once(function()
		local var2 = tbl1[arg1]
		if var2 then
			var2:Disconnect()
			tbl1[arg1] = nil
		end
	end)
end

var3.DescendantAdded:Connect(bind)
for k1, v1 in var3:GetDescendants() do
	bind(v1)
end

--- Players.LocalPlayer.PlayerScripts.GlobalLeaderboardController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("Players")
local num1 = 225
local num2 = 160
local num3 = 109
local tbl1 = {}
local tbl2 = {}
local tbl3 = {}
local num4 = 0
local tbl4 = {}
local var3 = var1:WaitForChild("GlobalLeaderboardState")
local var4 = game:GetService("HttpService")
local tbl5 = {
	Color3.fromRGB(255, 215, 96),
	Color3.fromRGB(212, 227, 244),
	Color3.fromRGB(num1, num2, num3),
}

local var5 = require(var1.Configs.GlobalLeaderboardConfig)
local var6 = workspace:WaitForChild("LEADERBOARD")
local function unbind(arg1)
	local var2 = tbl4[arg1]
	if not var2 then
		return
	end

	tbl4[arg1] = nil
	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	var2.template:Destroy()
	var2.gui:Destroy()
end

local var7 = var2.LocalPlayer:WaitForChild("PlayerGui")
num1 = function(arg1)
	if not arg1:IsA("SurfaceGui") or tbl4[arg1] then
		return
	end

	local var1 = arg1:GetAttribute("GlobalLeaderboard")
	local var2 = var1
	var2 = var2 and var3:FindFirstChild(var1)
	if not var2 or (not arg1.Parent or (not arg1.Parent:IsA("BasePart"))) then
		return
	end

	local var8 = arg1:Clone()
	var8.Name = "GlobalLeaderboard_" .. var1
	var8.Adornee = arg1.Parent
	var8.Enabled = true
	var8.ResetOnSpawn = false
	arg1.Enabled = false
	local var9 = var8.root.List.Template
	var9.Parent = nil
	local tbl1 = { gui = var8, source = arg1, template = var9, rows = {}, connections = {}, state = var2 }
	tbl4[arg1] = tbl1
	local function update()
		local var3 = var2:GetAttribute("Entries")
		if var3 then
			local success, result = pcall(var4.JSONDecode, var4, var3)
			if not (success and type(result) == "table") then
				return
			end

			if type(result) ~= "table" then
				return
			end

			for k1, v1 in ipairs(result) do
				local var7 = tbl1.rows[k1]
				if not var7 then
					var7 = var9:Clone()
					var7.Name = string.format("%03d", k1)
					var7.Visible = true
					var7.LayoutOrder = k1
					var7.Parent = var8.root.List
					tbl1.rows[k1] = var7
				end

				if var7:GetAttribute("UserId") ~= v1.UserId then
					var7:SetAttribute("UserId", v1.UserId)
					var7.PlayerName.Text = "Player " .. tostring(v1.UserId)
					var7.Avatar.Image = ""
				end

				var7.Rank.Text = "#" .. k1
				var7.Amount.Text = v1.Value
				local var10 = tbl5[k1]
				var10 = var10 or Color3.fromRGB(206, 219, 237)
				var7.Rank.TextColor3 = var10
			end

			for i1 = #tbl1.rows, #result + 1, -1 do
				tbl1.rows[i1]:Destroy()
				tbl1.rows[i1] = nil
			end

			var8.root.List.CanvasSize = UDim2.fromOffset(0, #result * (var5.RowHeight + var5.RowGap))
			local var11 = var8.root.Empty
			var11.Text = if #result == 0 then "No ranked players yet" else ""
			var8.root.Empty.Visible = #result == 0
			return
		end

		var8.root.Empty.Text = "Loading global rankings\226\128\166"
		var8.root.Empty.Visible = true
	end

	local var10 = update
	table.insert(tbl1.connections, var2:GetAttributeChangedSignal("Entries"):Connect(var10))
	var10 = function()
		if not arg1:IsDescendantOf(var6) then
			unbind(arg1)
		end
	end

	table.insert(tbl1.connections, arg1.AncestryChanged:Connect(var10))
	var8.Parent = var7
	update()
end

var6.DescendantAdded:Connect(num1)
local var8 = game:GetService("RunService")
local function serviceNames()
	while num4 < 2 and 0 < (#tbl3) do
		local var1 = table.remove(tbl3, 1)
		local var3 = num4 + 1
		num4 = var3
		task.spawn(function()
			local success, result = pcall(function()
				local var3 = var1
				return var2:GetNameFromUserIdAsync(var3)
			end)

			local var3 = tbl1
			local var4 = var1
			local var5 = os.clock()
			var3[var4] = {
				name = if success then result else "Player " .. var1,
				untilTime = var5 + (if success then 3600 else 60),
			}

			tbl2[var1] = nil
			var3 = num4 - 1
			num4 = var3
		end)

	end
end

for k1, v1 in var6:GetDescendants() do
	num1(v1)
end

num2 = 0
var8.Heartbeat:Connect(function(arg1)
	local var1 = num2 + arg1
	num2 = var1
	if num2 < 0.5 then
		return
	end

	num2 = 0
	var1 = workspace.CurrentCamera
	for k1, v1 in pairs(tbl4) do
		local var4 = var1
		local var6 = v1.gui.Adornee
		if var4 then
			var4 = var6
			if var4 then
				var4 = var6:IsDescendantOf(workspace)
				if var4 then
					var4 = (var1.CFrame.Position - var6.Position).Magnitude <= var5.RenderDistance
				end
			end
		end

		v1.gui.Enabled = var4 == true
		if not var4 then
			continue
		end

		local var7 = v1.gui.root.List
		local var8 = var5.RowHeight + var5.RowGap
		local var9 = var7.CanvasPosition.Y + var7.AbsoluteWindowSize.Y
		local var10 = var9 / var8
		local var11 = math.max(1, (math.floor(var7.CanvasPosition.Y / var8)))
		local var12 = math.min(#v1.rows, math.ceil(var10) + 1)
		for k2, v2 in ipairs(v1.rows) do
			if var11 <= k2 then
				if k2 <= var12 then
					local var17 = v2:GetAttribute("UserId")
					local var19 = tbl1[var17]
					local var20 = v2.PlayerName
					local var21
					if var19 and os.clock() < var19.untilTime then
						var21 = var19.name
					else
						if not tbl2[var17] then
							tbl2[var17] = true
							table.insert(tbl3, var17)
						end

						var21 = var19 and var19.name or "Player " .. var17
					end

					var20.Text = var21
					var20 = "rbxthumb://type=AvatarHeadShot&id=" .. var17 .. "&w=150&h=150"
					if v2.Avatar.Image == var20 then
						continue
					end

					v2.Avatar.Image = var20
				else
					if v2.Avatar.Image == "" then
						continue
					end

					v2.Avatar.Image = ""
				end
			else
				if v2.Avatar.Image == "" then
					continue
				end

				v2.Avatar.Image = ""
			end
		end

		local var23 = v1.state:GetAttribute("Status")
		local var24 = v1.state:GetAttribute("UpdatedAt")
		local var25 = v1.gui.root.Status
		local var26
		if var23 and var23 ~= "" then
			var26 = var23
		elseif var24 then
			var26 = "GLOBAL \226\128\162 Refresh in " .. math.max(0, (math.ceil(var5.RefreshSeconds - (workspace:GetServerTimeNow() - var24)))) .. "s"
		else
			var26 = "Loading global rankings\226\128\166"
		end

		var25.Text = var26
	end

	serviceNames()
end)

--- Players.LocalPlayer.PlayerScripts.MainMenuController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = var1:WaitForChild("PlayerGui")
local var3 = game:GetService("ReplicatedStorage")
local var4 = var2:WaitForChild("Main")
local str1 = "Index"
local var5 = game:GetService("MarketplaceService")
local var6 = game:GetService("TweenService")
local var7 = var2:WaitForChild("HUD"):WaitForChild("Left")
local var8 = require(var3.Modules.UIEffects)
local var9 = require(var3.Modules.ConfettiEffect)
local var10 = require(var3.Configs.ShopConfig)
local var11 = require(var3.Modules.NumberFormatter)
local var12 = var3.Remotes.Events
local var13 = var4:WaitForChild("Shop")
local var14 = var4:WaitForChild("Index")
for k1, v1 in { "Shop", str1 }, nil do
	local var15 = var4[v1]
	var15.Visible = false
	var15:SetAttribute("WindowEffectsManaged", true)
	var7[v1].Button.Activated:Connect(function()
		var8.SetWindow(var15, not var8.IsWindowOpen(var15))
	end)

	var15.Exit.Button.Activated:Connect(function()
		var8.SetWindow(var15, false)
	end)

end

local tbl1 = { [var13] = var13.Size, [var14] = var14.Size }
local var16 = nil
local function fit()
	local var2 = workspace.CurrentCamera
	if not var2 then
		return
	end

	for k1, v1 in pairs(tbl1) do
		local var3 = if var2.ViewportSize.X < 1000 then UDim2.fromScale(0.92, 0.78) else v1
		k1.Size = var3
	end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if var16 then
		var16:Disconnect()
	end

	if workspace.CurrentCamera then
		var16 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
	end

	fit()
end)

if var16 then
	var16:Disconnect()
end

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end

fit()
local var17 = nil
local var18 = nil
local var19 = var7:WaitForChild("Mode")
local var21 = var1:GetAttribute("SlowMode") == true
local bool1 = false
local function renderMode(arg1)
	local var3 = var1:GetAttribute("SlowMode") == true
	local var4 = UDim2.fromScale
	var4 = var4(if var3 then 0.75 else 0.222, 0.488)
	local var5 = if var3 then Color3.fromRGB(65, 220, 75) else Color3.new(0, 0, 0)
	if var17 then
		var17:Cancel()
		var18:Cancel()
	end

	if arg1 then
		local var7 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		var17 = var6:Create(var19.Knob, var7, { Position = var4 })
		var7 = TweenInfo.new(0.18)
		var18 = var6:Create(var19, var7, { BackgroundColor3 = var5 })
		var17:Play()
		var18:Play()
		return
	end

	var19.Knob.Position = var4
	var19.BackgroundColor3 = var5
end

local var22 = UDim2.fromScale
var22 = var22(if var21 then 0.75 else 0.222, 0.488)
local var23 = if var21 then Color3.fromRGB(65, 220, 75) else Color3.new(0, 0, 0)
if var17 then
	var17:Cancel()
	var18:Cancel()
end

var19.Knob.Position = var22
var19.BackgroundColor3 = var23
var1:GetAttributeChangedSignal("SlowMode"):Connect(function()
	renderMode(true)
end)

var19.Button.Activated:Connect(function()
	if bool1 then
		return
	end

	bool1 = true
	var12.SetSlowMode:FireServer(var1:GetAttribute("SlowMode") ~= true)
	task.delay(0.2, function()
		bool1 = false
	end)
end)

var21 = false
var5.PromptProductPurchaseFinished:Connect(function(arg1)
	if arg1 == var1.UserId then
		var21 = false
	end
end)

var5.PromptGamePassPurchaseFinished:Connect(function(arg1)
	if arg1 == var1 then
		var21 = false
	end
end)

var22 = function(arg1, arg2)
	if arg1 <= 0 or var21 then
		return
	end

	var21 = true
	if not pcall(function()
		if arg2 then
			var5:PromptGamePassPurchase(var1, arg1)
			return
		end

		var5:PromptProductPurchase(var1, arg1)
	end) then

		var21 = false
	end

	task.delay(30, function()
		var21 = false
	end)
end

local str2 = "Speed"
var23 = function(arg1, arg2, arg3, arg4)
	local var2 = arg1.Text.RobuxPrice
	local var3 = nil
	local var4 = var2:FindFirstChild("GreenRobux")
	local var6 = arg1.Button
	local function refresh()
		local var7 = arg3
		if var7 then
			var7 = var1:GetAttribute("OwnsDouble" .. arg4) == true
		end

		local var8 = var2
		local var9
		if var7 then
			var9 = "Owned"
		else
			if arg2 <= 0 then
				var9 = "Unavailable"
			else
				var9 = if var3 then tostring(var3) else "\226\128\166"
			end
		end

		var8.Text = var9
		if var4 then
			var9 = not var7
			var8 = var4
			if var9 then
				var9 = var3 ~= nil
			end

			var8.Visible = var9
		end

		var8 = var6
		var9 = false
		if 0 < arg2 then
			var9 = not var7
		end

		var8.Active = var9
		var6.Selectable = var6.Active
	end

	refresh()
	if arg3 then
		var1:GetAttributeChangedSignal("OwnsDouble" .. arg4):Connect(refresh)
	end

	var6.Activated:Connect(function()
		if arg3 and var1:GetAttribute("OwnsDouble" .. arg4) == true then
			return
		end

		var22(arg2, arg3)
	end)

	if 0 < arg2 then
		task.spawn(function()
			for i1 = 1, 3 do
				local var1 = pcall
				local var4 = var5.GetProductInfo
				local var6 = var5
				local var7 = arg2
				local var8, var9 = var1(var4, var6, var7, if arg3 then Enum.InfoType.GamePass else Enum.InfoType.Product)
				if var8 and (type(var9) == "table" and var9.PriceInRobux) then
					var3 = var9.PriceInRobux
					refresh()
					return
				end

				task.wait(i1 * 2)
			end

			var2.Text = "View price"
		end)

	end
end

for k2, v2 in { "Cash", str2 }, nil do
	local var24 = var13.List
	local var25 = var24[if v2 == "Cash" then "4_CashFrame" else "8_SpeedFrame"].List
	local str3 = "Small"
	local str4 = "Medium"
	for k3, v3 in { str3, str4, "Large", "Massive" }, nil do
		local var26 = var25[v3]
		var26.LayoutOrder = k3
		local var27 = var10[v2][v3]
		local var28 = var26[v2 .. "Quantity"]
		var28.Text = (if v2 == "Cash" then "$" else "+") .. var11.Format(var27.Amount)
		var23(var26.ButtonFrame, var27.ProductId, false, v2)
	end

	var23(var13.List["6_Gamepasses"][v2].ButtonFrame, var10.Gamepasses[v2].PassId, true, v2)
end

local tbl2 = {}
var12.PurchaseCelebration.OnClientEvent:Connect(function(arg1, arg2)
	local var1 = tostring(arg1) .. ":" .. tostring(arg2)
	if tbl2[var1] then
		return
	end

	tbl2[var1] = true
	local var3 = var2:FindFirstChild("Notifications")
	var3 = var3 or var2:FindFirstChild("Notification")
	local var4 = var3
	var9.Play(var4 and var3:FindFirstChild("Confetti"))
end)

var1.CharacterAdded:Connect(function()
	var8.SetWindow(var13, false)
	var8.SetWindow(var14, false)
end)

local var29 = var2.HUD:WaitForChild("BottomLeft"):WaitForChild("SpeedButton"):WaitForChild("Button")
var8.BindButton(var29)
local num1 = 0
local var30 = nil
var13:GetPropertyChangedSignal("Visible"):Connect(function()
	if not var13.Visible then
		local var1 = num1 + 1
		num1 = var1
		if var30 then
			var30:Cancel()
			var30 = nil
		end
	end
end)

var29.Activated:Connect(function()
	local var1 = num1 + 1
	num1 = var1
	if var30 then
		var30:Cancel()
		var30 = nil
	end

	var8.SetWindow(var13, true)
	var1 = num1
	task.delay(0.24, function()
		if var1 ~= num1 or (not var8.IsWindowOpen(var13)) then
			return
		end

		local var2 = var13.List
		local var3 = var2:FindFirstChild("5_Title")
		var3 = var3 or var2:FindFirstChild("6_SpeedFrame")
		if not var3 then
			return
		end

		local num2 = 1
		local var4 = var2
		while var4 and var4:IsA("GuiObject") do
			for k1, v1 in var4:GetChildren() do
				if not v1:IsA("UIScale") then
					continue
				end

				num2 = num2 * v1.Scale
			end

			var4 = var4.Parent
		end

		num2 = math.max(0.01, num2)
		local var5 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		var30 = var6:Create(var2, var5, { CanvasPosition = Vector2.new(0, (math.clamp(var2.CanvasPosition.Y + (var3.AbsolutePosition.Y - var2.AbsolutePosition.Y) / num2 - 10, 0, (math.max(0, (var2.AbsoluteCanvasSize.Y - var2.AbsoluteWindowSize.Y) / num2))))) })
		var30:Play()
	end)
end)

local function formatRobux(arg1)
	local str1 = "^,"
	local str2 = ""
	return tostring((math.max(0, (math.floor(tonumber(arg1) or 0))))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub(str1, str2)
end

local var32 = var10.Boosts
local function bindStarterPack(arg1, arg2)
	if not arg1 or type(arg2) ~= "table" then
		return
	end

	local var2 = arg1:FindFirstChild("Text")
	local var3 = var2
	local var6 = arg1:FindFirstChild("Button")
	var3 = var3 and var2:FindFirstChild("RobuxPrice")
	if not var6 or (not var3) then
		return
	end

	local var7 = nil
	local var8 = tonumber(arg2.ProductId) or 0
	local var10 = var1:GetAttribute("StarterPackClaimed") == true
	local function refresh()
		local var4 = var1:GetAttribute("StarterPackClaimed") == true
		local var5 = var3
		local var9
		if var4 then
			var9 = "Claimed!"
		else
			local var10 = var7
			var9 = "\238\128\130" .. formatRobux(var10 or (arg2.DisplayPrice or 5000))
		end

		var5.Text = var9
		var5 = var6
		var9 = false
		if 0 < var8 then
			var9 = not var4
		end

		var5.Active = var9
		var6.Selectable = var6.Active
	end

	local var11
	if var10 then
		var11 = "Claimed!"
	else
		local var12 = var7
		var11 = "\238\128\130" .. formatRobux(var12 or (arg2.DisplayPrice or 5000))
	end

	var3.Text = var11
	var11 = false
	if 0 < var8 then
		var11 = not var10
	end

	var6.Active = var11
	var6.Selectable = var6.Active
	var1:GetAttributeChangedSignal("StarterPackClaimed"):Connect(refresh)
	var6.Activated:Connect(function()
		if 0 < var8 and var1:GetAttribute("StarterPackClaimed") ~= true then
			var22(var8, false)
		end
	end)

	if 0 < var8 then
		task.spawn(function()
			for i1 = 1, 3 do
				local success, result = pcall(var5.GetProductInfo, var5, var8, Enum.InfoType.Product)
				if success and (type(result) == "table" and result.PriceInRobux) then
					var7 = result.PriceInRobux
					local var4 = var1:GetAttribute("StarterPackClaimed") == true
					local var9 = var3
					local var10
					if var4 then
						var10 = "Claimed!"
					else
						local var11 = var7
						var10 = "\238\128\130" .. formatRobux(var11 or (arg2.DisplayPrice or 5000))
					end

					var9.Text = var10
					var9 = var6
					var10 = false
					if 0 < var8 then
						var10 = not var4
					end

					var9.Active = var10
					var6.Selectable = var6.Active
					return
				end

				task.wait(i1 * 2)
			end

			if var1:GetAttribute("StarterPackClaimed") ~= true then
				local var12 = var7
				var3.Text = "\238\128\130" .. formatRobux(var12 or (arg2.DisplayPrice or 5000))
			end
		end)

	end
end

local function bindGlobalBoost(arg1, arg2)
	if not arg1 or type(arg2) ~= "table" then
		return
	end

	local var1 = arg1:FindFirstChild("Text")
	local var2 = var1
	local var4 = arg1:FindFirstChild("Button")
	var2 = var2 and var1:FindFirstChild("RobuxPrice")
	if not var4 or (not var2) then
		return
	end

	local var6 = nil
	local var7 = tonumber(arg2.ProductId) or 0
	local var8 = var6
	var2.Text = "\238\128\130" .. formatRobux(var8 or (arg2.DisplayPrice or 10000))
	var4.Active = 0 < var7
	var4.Selectable = var4.Active
	var4.Activated:Connect(function()
		if 0 < var7 then
			var22(var7, false)
		end
	end)

	if 0 < var7 then
		task.spawn(function()
			for i1 = 1, 3 do
				local success, result = pcall(var5.GetProductInfo, var5, var7, Enum.InfoType.Product)
				if success and (type(result) == "table" and result.PriceInRobux) then
					var6 = result.PriceInRobux
					local var1 = var6
					var2.Text = "\238\128\130" .. formatRobux(var1 or (arg2.DisplayPrice or 10000))
					var4.Active = 0 < var7
					var4.Selectable = var4.Active
					return
				end

				task.wait(i1 * 2)
			end
		end)

	end
end

if var32 then
	local var33 = var13.List:FindFirstChild("2_StarterPack")
	bindStarterPack(var33 and var13.List["2_StarterPack"]:FindFirstChild("ButtonFrame"), var10.StarterPack)
	local var34 = var13.List:FindFirstChild("x_Boosts")
	var33 = var34
	var34 = var33 and var34:FindFirstChild("List")
	local str5 = "Cash"
	for k4, v4 in ipairs({ "Treadmill", str5 }) do
		local var35 = var32.Personal
		var35 = var35 and var32.Personal[v4]
		if not var35 or (not var34) then
			continue
		end

		local var36 = var35.Offers
		for k5, v5 in pairs(var36 or {}) do
			local var37 = var34:FindFirstChild(k5)
			if not var37 then
				continue
			end

			if not var37:FindFirstChild("ButtonFrame") then
				continue
			end

			var23(var37.ButtonFrame, tonumber(v5.ProductId) or 0, false, nil)
		end
	end

	var33 = var13.List:FindFirstChild("z_Globalboost")
	local var38 = var33
	bindGlobalBoost(var38 and var33:FindFirstChild("ButtonFrame"), var32.Global)
end

local var39 = var2:WaitForChild("HUD")
local var40 = var39:FindFirstChild("CashBoost")
local var41 = var39:FindFirstChild("TreadmillBoost")
local var42 = var39:FindFirstChild("GlobalBoost")
local str6 = "CashBoostMultiplier"
local function refreshBoostHud()
	local str1 = "CashBoostSeconds"
	local var3 = math.max(0, tonumber(var1:GetAttribute(str1)) or 0)
	if var40 then
		var40.Visible = 0 < var3
		if 0 < var3 then
			local var4 = tonumber((var1:GetAttribute("CashBoostMultiplier"))) or 1
			local var5 = var40
			local str2 = "Cash Boost x"
			local var6 = math.max(0, (math.floor(tonumber(var3) or 0)))
			var5.Text = str2 .. (if var4 == math.floor(var4) then tostring((math.floor(var4))) else string.format("%.1f", var4)) .. " " .. string.format("%d:%02d", math.floor(var6 / 60), var6 % 60)
		end
	end

	local str3 = "TreadmillBoostSeconds"
	local var8 = math.max(0, tonumber(var1:GetAttribute(str3)) or 0)
	if var41 then
		var41.Visible = 0 < var8
		if 0 < var8 then
			str1 = tonumber((var1:GetAttribute("TreadmillBoostMultiplier"))) or 1
			local var9 = var41
			local str4 = "Treadmill Boost x"
			local var10 = math.max(0, (math.floor(tonumber(var8) or 0)))
			var9.Text = str4 .. (if str1 == math.floor(str1) then tostring((math.floor(str1))) else string.format("%.1f", str1)) .. " " .. string.format("%d:%02d", math.floor(var10 / 60), var10 % 60)
		end
	end

	local str5 = "GlobalBoostSeconds"
	local var12 = math.max(0, tonumber(var1:GetAttribute(str5)) or 0)
	if var42 then
		var42.Visible = 0 < var12
		if 0 < var12 then
			str3 = tonumber((var1:GetAttribute("GlobalTreadmillMultiplier"))) or 1
			local var13 = var42
			local str6 = "Global Boost x"
			local var14 = tonumber((var1:GetAttribute("GlobalCashMultiplier"))) or 1
			str1 = if str3 == math.floor(str3) then tostring((math.floor(str3))) else string.format("%.1f", str3)
			str3 = " Training x"
			local var15 = math.max(0, (math.floor(tonumber(var12) or 0)))
			var13.Text = str6 .. str1 .. str3 .. (if var14 == math.floor(var14) then tostring((math.floor(var14))) else string.format("%.1f", var14)) .. " Cash " .. string.format("%d:%02d", math.floor(var15 / 60), var15 % 60)
		end
	end
end

for k6, v6 in ipairs({
	"CashBoostSeconds",
	str6,
	"TreadmillBoostSeconds",
	"TreadmillBoostMultiplier",
	"GlobalBoostSeconds",
	"GlobalCashMultiplier",
	"GlobalTreadmillMultiplier",
}) do

	var1:GetAttributeChangedSignal(v6):Connect(refreshBoostHud)
end

refreshBoostHud()
local var46 = var2:WaitForChild("Notifications"):FindFirstChild("GlobalBoost")
if var46 then
	local var47 = var46:FindFirstChild("Text")
	local var48 = var47
	var48 = var48 and var47:FindFirstChildOfClass("UIGradient")
	local num3 = 0
	game:GetService("RunService").RenderStepped:Connect(function(arg1)
		if not var46.Visible or (not var48) then
			return
		end

		local var1 = (num3 + arg1 * 0.22) % 1
		num3 = var1
		local var2 = num3
		local num1 = 1
		local num2 = 1
		local var3 = ColorSequenceKeypoint.new(0, Color3.fromHSV(var2, num1, num2))
		num1 = (num3 + 0.25) % 1
		num2 = 1
		local num4 = 1
		local var4 = ColorSequenceKeypoint.new(0.25, Color3.fromHSV(num1, num2, num4))
		num2 = (num3 + 0.5) % 1
		num4 = 1
		local num5 = 1
		local var5 = ColorSequenceKeypoint.new(0.5, Color3.fromHSV(num2, num4, num5))
		num4 = (num3 + 0.75) % 1
		num5 = 1
		local num6 = 1
		var2 = ColorSequenceKeypoint.new(0.75, Color3.fromHSV(num4, num5, num6))
		num5 = num3
		num6 = 1
		local num7 = 1
		num2 = 1
		var48.Color = ColorSequence.new({
			var3,
			var4,
			var5,
			var2,
			ColorSequenceKeypoint.new(num2, Color3.fromHSV(num5, num6, num7)),
		})
	end)

	local num4 = 0
	local var49 = UDim2.new(0.5, 0, -0.25, 0)
	local var50 = UDim2.new(0.5, 0, 0.301, 0)
	local function showGlobalBoost(arg1)
		local var1 = num4 + 1
		num4 = var1
		local var4 = var46:FindFirstChild("PlayerIcon")
		local var5 = tonumber(arg1.UserId) or 0
		var1 = num4
		local var7 = tostring(arg1.Name or "Someone")
		if var4 and 0 < var5 then
			var4.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(var5) .. "&w=420&h=420"
		end

		if var47 then
			var47.Text = var7 .. " Just Globally Boosted!"
		end

		var46.Visible = true
		var46.Position = var49
		local var8 = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		var6:Create(var46, var8, { Position = var50 }):Play()
		task.delay(3.5, function()
			if var1 ~= num4 or (not var46.Parent) then
				return
			end

			local var2 = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
			local var3 = var6:Create(var46, var2, { Position = var49 })
			var3:Play()
			var3.Completed:Once(function()
				if var1 == num4 and var46.Parent then
					var46.Visible = false
				end
			end)
		end)
	end

	var12.CoreFeedback.OnClientEvent:Connect(function(arg1)
		if type(arg1) == "table" and arg1.Kind == "GlobalBoost" then
			showGlobalBoost(arg1)
		end
	end)

end

--- Players.LocalPlayer.PlayerScripts.MusicController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local str1 = "LifecycleWait"
local var1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild(str1))
str1 = game:GetService("ReplicatedStorage")
local var2 = require(str1.Modules.MusicPlayer).new((game:GetService("SoundService")))
local var3 = game:GetService("Players").LocalPlayer
local function applyMusicPreference()
	local var1 = var2
	local bool1 = true
	if var3:GetAttribute("SettingsReady") == true then
		bool1 = var3:GetAttribute("MusicEnabled") == false
	end

	var1:SetMuted(bool1)
	var1 = var2
	bool1 = true
	if var3:GetAttribute("SettingsReady") == true then
		bool1 = var3:GetAttribute("RaceMusicEnabled") == false
	end

	var1:SetRaceMuted(bool1)
end

applyMusicPreference()
var3:GetAttributeChangedSignal("SettingsReady"):Connect(applyMusicPreference)
var3:GetAttributeChangedSignal("MusicEnabled"):Connect(applyMusicPreference)
var3:GetAttributeChangedSignal("RaceMusicEnabled"):Connect(applyMusicPreference)
local var4 = nil
local var5 = nil
local function updateMode()
	local var1 = var4
	var1 = var1 and var4:FindFirstChildOfClass("Humanoid")
	local var5 = var3:GetAttribute("DrivingCar")
	local var6 = var2
	local bool2 = false
	if var4 ~= nil then
		bool2 = false
		if var1 ~= nil then
			bool2 = false
			if 0 < var1.Health then
				bool2 = var3:GetAttribute("RaceParticipant") == true
			end
		end
	end

	var6:SetRacing(bool2)
	var6 = var2
	bool2 = false
	if var4 ~= nil then
		bool2 = false
		if var1 ~= nil then
			bool2 = false
			if 0 < var1.Health then
				bool2 = false
				if var3:GetAttribute("BeingChased") == true then
					bool2 = false
					if type(var5) == "string" then
						bool2 = var5 ~= ""
					end
				end
			end
		end
	end

	var6:SetChasing(bool2)
end

var3:GetAttributeChangedSignal("BeingChased"):Connect(updateMode)
var3:GetAttributeChangedSignal("DrivingCar"):Connect(updateMode)
var3:GetAttributeChangedSignal("RaceParticipant"):Connect(updateMode)
local function bindCharacter(arg1)
	if var5 then
		var5:Disconnect()
		var5 = nil
	end

	var4 = arg1
	updateMode()
	if not var4 then
		return
	end

	local var7 = var1.Child(arg1, "Humanoid", function()
		local bool2 = false
		if var3.Parent ~= nil then
			bool2 = false
			if var3.Character == arg1 then
				bool2 = var4 == arg1
			end
		end

		return bool2
	end)

	if var7 and var4 == arg1 then
		var5 = var7.Died:Connect(function()
			var2:SetChasing(false)
			var2:SetRacing(false)
		end)

		updateMode()
	end
end

var3.CharacterAdded:Connect(bindCharacter)
var3.CharacterRemoving:Connect(function()
	bindCharacter(nil)
end)

str1.Remotes.Events.CoreFeedback.OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	if arg1.Kind == "ChaseEnd" or arg1.Kind == "Success" then
		var2:SetChasing(false)
		return
	end

	if arg1.Kind == "ChaseStart" then
		updateMode()
	end
end)

local var6 = game:GetService("RunService")
if var3.Character then
	task.spawn(bindCharacter, var3.Character)
end

var2:Update()
local num1 = 0
local var7 = var6.Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	if num1 < 1 then
		return
	end

	num1 = 0
	var2:Update()
end)

script.Destroying:Once(function()
	var7:Disconnect()
	if var5 then
		var5:Disconnect()
	end

	var2:Destroy()
end)

--- Players.LocalPlayer.PlayerScripts.TutorialVehicleVisibility [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local tbl1 = {}
local function hidePart(arg1, arg2)
	if arg2.saved[arg1] ~= nil then
		return
	end

	if arg1:IsA("BasePart") then
		arg2.saved[arg1] = arg1.LocalTransparencyModifier
		arg1.LocalTransparencyModifier = 1
		return
	end

	if arg1:IsA("Decal") or arg1:IsA("Texture") then
		arg2.saved[arg1] = arg1.Transparency
		arg1.Transparency = 1
		return
	end

	if arg1:IsA("ParticleEmitter") or (arg1:IsA("Trail") or (arg1:IsA("Beam") or (arg1:IsA("BillboardGui") or arg1:IsA("SurfaceGui")))) then
		arg2.saved[arg1] = arg1.Enabled
		arg1.Enabled = false
		if arg1:IsA("ParticleEmitter") then
			arg1:Clear()
		end
	end
end

local var1 = workspace:WaitForChild("LiveStolenCars")
var1.ChildRemoved:Connect(function(arg1)
	local var2 = tbl1[arg1]
	if var2 then
		var2.connection:Disconnect()
		tbl1[arg1] = nil
	end
end)

local var2 = game:GetService("Players").LocalPlayer
local function setHidden(arg1, arg2)
	local var2 = tbl1[arg1]
	if not var2 then
		var2 = { hidden = false, saved = {} }
		tbl1[arg1] = var2
		var2.connection = arg1.DescendantAdded:Connect(function(arg1)
			if var2.hidden then
				hidePart(arg1, var2)
			end
		end)

	end

	if var2.hidden == arg2 then
		return
	end

	var2.hidden = arg2
	if arg2 then
		for k1, v1 in arg1:GetDescendants() do
			hidePart(v1, var2)
		end
	else
		for k2, v2 in pairs(var2.saved) do
			if not k2.Parent then
				continue
			end

			if k2:IsA("BasePart") then
				k2.LocalTransparencyModifier = v2
			elseif k2:IsA("Decal") or k2:IsA("Texture") then
				k2.Transparency = v2
			else
				k2.Enabled = v2
			end
		end

		table.clear(var2.saved)
	end
end

while true do
	local var3 = nil
	for k1, v1 in var1:GetChildren() do
		if not v1:IsA("Model") then
			continue
		end

		if v1:GetAttribute("TutorialOwnerUserId") ~= var2.UserId then
			continue
		end

		if v1:GetAttribute("TheftState") ~= "Available" then
			continue
		end

		var3 = v1:GetAttribute("SpawnId")
		break
	end

	for k2, v2 in var1:GetChildren() do
		if not v2:IsA("Model") then
			continue
		end

		if not v2:GetAttribute("ZoneSpawn") then
			continue
		end

		local var5 = v2:GetAttribute("TutorialOwnerUserId")
		local bool1 = false
		if var5 ~= nil then
			bool1 = var5 ~= var2.UserId
		end

		if not var5 and (var3 and (v2:GetAttribute("OriginZone") == 1 and (v2:GetAttribute("SpawnId") == var3 and v2:GetAttribute("TheftState") == "Available"))) then
			bool1 = true
		end

		setHidden(v2, bool1)
		local var6 = v2:FindFirstChild("StealPrompt", true)
		if not var6 then
			continue
		end

		var6:SetAttribute("TutorialDuplicateHidden", bool1)
	end

	task.wait(0.2)
end

--- Players.LocalPlayer.PlayerScripts.ChaseTargetHighlight [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local tbl1 = {}
local var1 = game:GetService("Players").LocalPlayer
local function refresh(arg1)
	local var3 = tbl1[arg1]
	if not var3 then
		return
	end

	local var5 = arg1:GetAttribute("ChaseState")
	local bool2 = false
	if var1.Character ~= nil then
		bool2 = false
		if var1:GetAttribute("BeingChased") == true then
			bool2 = arg1:IsDescendantOf(workspace)
			if bool2 then
				bool2 = false
				if arg1:GetAttribute("TargetUserId") == var1.UserId then
					bool2 = true
					if var5 ~= "Chasing" then
						bool2 = var5 == "Jumping"
					end
				end
			end
		end
	end

	if bool2 then
		if not not var3.highlight then
			return
		end

		local var6 = Instance.new("Highlight")
		var6.Name = "ChaseTargetHighlight"
		var6.Adornee = arg1
		var6.FillColor = Color3.fromRGB(255, 0, 0)
		var6.FillTransparency = 0.6
		var6.OutlineColor = Color3.fromRGB(255, 0, 0)
		var6.OutlineTransparency = 0
		var6.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		var6.Parent = script
		var3.highlight = var6
		return
	end

	if var3.highlight then
		var3.highlight:Destroy()
		var3.highlight = nil
	end
end

local var2 = game:GetService("CollectionService")
local function add(arg1)
	if not arg1:IsA("Model") or tbl1[arg1] then
		return
	end

	local tbl2 = { connections = {} }
	tbl1[arg1] = tbl2
	local str1 = "ChaseState"
	for k1, v1 in { "TargetUserId", str1 }, nil do
		local function fn2()
			refresh(arg1)
		end

		table.insert(tbl2.connections, arg1:GetAttributeChangedSignal(v1):Connect(fn2))
	end

	local function fn4()
		local var1 = arg1
		local var3 = tbl1[var1]
		if not var3 then
			return
		end

		tbl1[var1] = nil
		for k1, v1 in var3.connections, nil do
			v1:Disconnect()
		end

		if var3.highlight then
			var3.highlight:Destroy()
		end
	end

	table.insert(tbl2.connections, arg1.Destroying:Connect(fn4))
	refresh(arg1)
end

var2:GetInstanceAddedSignal("AutoDrivenCar"):Connect(add)
var2:GetInstanceRemovedSignal("AutoDrivenCar"):Connect(function(arg1)
	local var2 = tbl1[arg1]
	if not var2 then
		return
	end

	tbl1[arg1] = nil
	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	if var2.highlight then
		var2.highlight:Destroy()
	end
end)

for k1, v1 in var2:GetTagged("AutoDrivenCar") do
	add(v1)
end

local function refreshAll()
	for k1 in tbl1, nil do
		refresh(k1)
	end
end

var1:GetAttributeChangedSignal("BeingChased"):Connect(refreshAll)
var1.CharacterAdded:Connect(refreshAll)
var1.CharacterRemoving:Connect(function()
	for k1, v1 in tbl1, nil do
		if not v1.highlight then
			continue
		end

		v1.highlight:Destroy()
		v1.highlight = nil
	end
end)

--- Players.LocalPlayer.PlayerScripts.AntiCheatNotifications [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

game:GetService("Players")
local var1 = game:GetService("StarterGui")
game:GetService("ReplicatedStorage"):WaitForChild("Remotes").Events:WaitForChild("AntiCheatNotice").OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	local var2 = if arg1.Banned then "Three confirmed movement warnings. A 24-hour ban applies." else ("Movement warning %d/%d. Disable movement exploits. Three warnings result in a 24-hour ban."):format(arg1.Count, arg1.Limit)
	if arg1.Studio then
		var2 = "Studio test only: " .. var2
	end

	for i1 = 1, 5 do
		if pcall(var1.SetCore, var1, "SendNotification", { Title = "Movement warning", Text = var2, Duration = 12 }) then
			break
		end

		task.wait(1)
	end
end)

--- Players.LocalPlayer.PlayerScripts.TreadmillGainPopups [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = game:GetService("ReplicatedStorage")
local var3 = game:GetService("TweenService")
local var4 = var1:WaitForChild("PlayerGui")
local var5 = var2:WaitForChild("Assets"):WaitForChild("Billboards"):WaitForChild("SpeedBillboard"):WaitForChild("BillboardGui")
local var6 = require(var2.Modules.NumberFormatter)
local var7 = var2:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("TreadmillGain")
local tbl1 = {}
local num1 = 0
local var8 = Random.new()
local function trainingRoot()
	local var2 = var1.Character
	local var3 = var2
	var3 = var3 and var2:FindFirstChildOfClass("Humanoid")
	if not var2 or (not var3 or (var3.Health <= 0 or (not var1:GetAttribute("TrainingTier") or (not var2:GetAttribute("TrainingTreadmill"))))) then
		return nil
	end

	local str1 = "HumanoidRootPart"
	return var2:FindFirstChild(str1)
end

local function reset(arg1)
	local var1 = arg1.version + 1
	arg1.version = var1
	for k1, v1 in arg1.tweens, nil do
		v1:Cancel()
	end

	table.clear(arg1.tweens)
	arg1.gui.Enabled = false
	arg1.gui.Adornee = nil
	for k2, v2 in arg1.fades, nil do
		v2.object[v2.property] = v2.value
	end

	arg1.scale.Scale = 1
end

for i1 = 1, 6 do
	local var9 = var5:Clone()
	var9.Name = "TreadmillGainPopup" .. i1
	var9.Enabled = false
	var9.Adornee = nil
	var9.AlwaysOnTop = true
	var9.MaxDistance = 100
	var9.ResetOnSpawn = false
	var9.StudsOffset = Vector3.new(0, 0, 0)
	var9.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	var9.Parent = var4
	local var10 = var9:WaitForChild("root")
	local var11 = Instance.new("UIScale")
	var11.Name = "GainPopScale"
	var11.Parent = var10
	local tbl2 = { gui = var9, label = var10:WaitForChild("Text"), version = 0 }
	tbl2.scale = var11
	tbl2.fades = {}
	tbl2.tweens = {}
	for k1, v1 in var9:GetDescendants() do
		if v1:IsA("GuiObject") then
			table.insert(tbl2.fades, { object = v1, property = "BackgroundTransparency", value = v1.BackgroundTransparency })
		end

		if v1:IsA("TextLabel") or v1:IsA("TextButton") then
			table.insert(tbl2.fades, { object = v1, property = "TextTransparency", value = v1.TextTransparency })
			table.insert(tbl2.fades, { object = v1, property = "TextStrokeTransparency", value = v1.TextStrokeTransparency })
		else
			if v1:IsA("ImageLabel") or v1:IsA("ImageButton") then
				table.insert(tbl2.fades, { object = v1, property = "ImageTransparency", value = v1.ImageTransparency })
			else
				if not v1:IsA("UIStroke") then
					continue
				end

				table.insert(tbl2.fades, { object = v1, property = "Transparency", value = v1.Transparency })
			end
		end
	end

	table.insert(tbl1, tbl2)
end

local function show(arg1)
	local var2 = trainingRoot()
	if not var2 or arg1 <= 0 then
		return
	end

	local var4 = num1 + 1
	num1 = var4
	var4 = tbl1[(num1 - 1) % #tbl1 + 1]
	reset(var4)
	var4.label.Text = "+" .. var6.Format(arg1)
	var4.gui.Adornee = var2
	local var5 = var4.version
	local var9 = workspace.CurrentCamera
	local var10 = if num1 % 2 == 0 then 1 else -1
	local var11 = if var9 then var9.CFrame.RightVector else Vector3.new(1, 0, 0)
	local var12 = var11 * (var10 * var8:NextNumber(0.35, 0.8)) + Vector3.new(0, 0.15, 0)
	var4.gui.StudsOffsetWorldSpace = var12
	var4.gui.Enabled = true
	var4.scale.Scale = 0.55
	local var13 = var3:Create(var4.scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	table.insert(var4.tweens, var13)
	var13:Play()
	local var14 = TweenInfo.new(2.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	var13 = var3:Create(var4.gui, var14, { StudsOffsetWorldSpace = var12 + var11 * (var10 * var8:NextNumber(0.7, 1.4)) + Vector3.new(0, 4.4, 0) })
	table.insert(var4.tweens, var13)
	var13:Play()
	task.delay(1.25, function()
		if var4.version ~= var5 then
			return
		end

		for k1, v1 in var4.fades, nil do
			if v1.value >= 1 then
				continue
			end

			local var1 = TweenInfo.new(0.85)
			local var2 = var3:Create(v1.object, var1, { [v1.property] = 1 })
			table.insert(var4.tweens, var2)
			var2:Play()
		end
	end)

	task.delay(2.15, function()
		if var4.version == var5 then
			reset(var4)
		end
	end)
end

var7.OnClientEvent:Connect(function(arg1)
	if typeof(arg1) ~= "number" or (arg1 ~= arg1 or (arg1 == math.huge or (arg1 <= 0 or (not trainingRoot())))) then
		return
	end

	show(arg1)
end)

var1:GetAttributeChangedSignal("TrainingTier"):Connect(function()
	if not var1:GetAttribute("TrainingTier") then
		for k1, v1 in tbl1, nil do
			reset(v1)
		end
	end
end)

var1.CharacterRemoving:Connect(function()
	for k1, v1 in tbl1, nil do
		reset(v1)
	end
end)

script.Destroying:Connect(function()
	for k1, v1 in tbl1, nil do
		reset(v1)
	end

	for k2, v2 in tbl1, nil do
		v2.gui:Destroy()
	end
end)

--- Players.LocalPlayer.PlayerScripts.ChaseRagdollController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local str1 = "LifecycleWait"
local var1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild(str1))
local var2 = game:GetService("Players").LocalPlayer
local function bind(arg1)
	local var4 = var1.Child(arg1, "Humanoid", function()
		local bool1 = false
		if var2.Parent ~= nil then
			bool1 = var2.Character == arg1
		end

		return bool1
	end)

	if not var4 then
		return
	end

	local var5 = nil
	local function update()
		local var2 = arg1:GetAttribute("Ragdolled") == true
		if var2 and (not var5) then
			local var3 = arg1:FindFirstChild("Animate")
			local tbl1 = { gettingUp = var4:GetStateEnabled(Enum.HumanoidStateType.GettingUp) }
			tbl1.animate = var3
			local var6 = var3
			tbl1.enabled = var6 and var3.Enabled
			var5 = tbl1
			if var3 then
				var3.Enabled = false
			end

			tbl1 = var4:FindFirstChildOfClass("Animator")
			if tbl1 then
				for k1, v1 in tbl1:GetPlayingAnimationTracks() do
					v1:Stop(0.08)
				end
			end

			var4:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
			var4.PlatformStand = true
			var4:ChangeState(Enum.HumanoidStateType.Physics)
			return
		end

		if not var2 and var5 then
			var4:SetStateEnabled(Enum.HumanoidStateType.GettingUp, var5.gettingUp)
			if var5.animate and var5.animate.Parent then
				var5.animate.Enabled = var5.enabled
			end

			var5 = nil
			var4.PlatformStand = false
			if 0 < var4.Health then
				var4:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
	end

	local var6 = arg1:GetAttributeChangedSignal("Ragdolled"):Connect(update)
	arg1.Destroying:Once(function()
		var6:Disconnect()
	end)

	update()
end

var2.CharacterAdded:Connect(bind)
if var2.Character then
	task.spawn(bind, var2.Character)
end

--- Players.LocalPlayer.PlayerScripts.CarIncomePopups [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = game:GetService("ReplicatedStorage")
local var3 = game:GetService("TweenService")
local var4 = var1:WaitForChild("PlayerGui")
local var5 = var2:WaitForChild("Assets"):WaitForChild("Billboards"):WaitForChild("CashBillboard"):WaitForChild("BillboardGui")
local var6 = require(var2.Modules.NumberFormatter)
local var7 = var2:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("CarIncomePopups")
local tbl1 = {}
local num1 = 0
local var8 = Random.new()
local function reset(arg1)
	local var1 = arg1.version + 1
	arg1.version = var1
	for k1, v1 in arg1.tweens, nil do
		v1:Cancel()
	end

	table.clear(arg1.tweens)
	arg1.gui.Enabled = false
	arg1.gui.Adornee = nil
	for k2, v2 in arg1.fades, nil do
		v2.object[v2.property] = v2.value
	end

	arg1.scale.Scale = 1
end

for i1 = 1, 32 do
	local var9 = var5:Clone()
	var9.Name = "CarIncomePopup" .. i1
	var9.Enabled = false
	var9.Adornee = nil
	var9.AlwaysOnTop = true
	var9.MaxDistance = 180
	var9.ResetOnSpawn = false
	var9.StudsOffset = Vector3.new(0, 0, 0)
	var9.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	var9.Parent = var4
	local var10 = var9:WaitForChild("root")
	local var11 = Instance.new("UIScale")
	var11.Name = "GainPopScale"
	var11.Parent = var10
	local tbl2 = { gui = var9, label = var10:WaitForChild("Text"), version = 0 }
	tbl2.scale = var11
	tbl2.fades = {}
	tbl2.tweens = {}
	for k1, v1 in var9:GetDescendants() do
		if v1:IsA("GuiObject") then
			table.insert(tbl2.fades, { object = v1, property = "BackgroundTransparency", value = v1.BackgroundTransparency })
		end

		if v1:IsA("TextLabel") or v1:IsA("TextButton") then
			table.insert(tbl2.fades, { object = v1, property = "TextTransparency", value = v1.TextTransparency })
			table.insert(tbl2.fades, { object = v1, property = "TextStrokeTransparency", value = v1.TextStrokeTransparency })
		else
			if v1:IsA("ImageLabel") or v1:IsA("ImageButton") then
				table.insert(tbl2.fades, { object = v1, property = "ImageTransparency", value = v1.ImageTransparency })
			else
				if not v1:IsA("UIStroke") then
					continue
				end

				table.insert(tbl2.fades, { object = v1, property = "Transparency", value = v1.Transparency })
			end
		end
	end

	table.insert(tbl1, tbl2)
end

local function show(arg1, arg2)
	if typeof(arg1) ~= "Instance" or (not arg1:IsA("Model") or (not arg1:IsDescendantOf(workspace))) then
		return
	end

	local var2 = arg1.Parent
	var2 = var2 and arg1.Parent.Parent
	if not var2 or var2:GetAttribute("Owner") ~= var1.UserId then
		return
	end

	local var7 = arg1.PrimaryPart
	local var9 = workspace.CurrentCamera
	if not var7 or (not var9 or 180 < (var9.CFrame.Position - var7.Position).Magnitude) then
		return
	end

	local var10, var11 = var9:WorldToViewportPoint(var7.Position)
	if not var11 then
		return
	end

	local var12 = num1 + 1
	num1 = var12
	var12 = tbl1[(num1 - 1) % #tbl1 + 1]
	reset(var12)
	var12.label.Text = "+$" .. var6.Format(arg2)
	var12.gui.Adornee = var7
	local var13 = var12.version
	local var15 = workspace.CurrentCamera
	local var16 = if num1 % 2 == 0 then 1 else -1
	local var17 = if var15 then var15.CFrame.RightVector else Vector3.new(1, 0, 0)
	local var18 = var17 * (var16 * var8:NextNumber(0.35, 0.8)) + Vector3.new(0, (arg1:GetAttribute("CarHeight") or 4) * 0.5 + 1, 0)
	var12.gui.StudsOffsetWorldSpace = var18
	var12.gui.Enabled = true
	var12.scale.Scale = 0.55
	local var19 = var3:Create(var12.scale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	table.insert(var12.tweens, var19)
	var19:Play()
	local var20 = TweenInfo.new(1.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	var19 = var3:Create(var12.gui, var20, { StudsOffsetWorldSpace = var18 + var17 * (var16 * var8:NextNumber(0.7, 1.4)) + Vector3.new(0, 3, 0) })
	table.insert(var12.tweens, var19)
	var19:Play()
	task.delay(0.85, function()
		if var12.version ~= var13 then
			return
		end

		for k1, v1 in var12.fades, nil do
			if v1.value >= 1 then
				continue
			end

			local var1 = TweenInfo.new(0.6)
			local var2 = var3:Create(v1.object, var1, { [v1.property] = 1 })
			table.insert(var12.tweens, var2)
			var2:Play()
		end
	end)

	task.delay(1.5, function()
		if var12.version == var13 then
			reset(var12)
		end
	end)
end

var7.OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	for k1, v1 in ipairs(arg1) do
		if 16 < k1 then
			break
		end

		show(v1.Car, v1.Amount)
	end
end)

var1.CharacterRemoving:Connect(function()
	for k1, v1 in tbl1, nil do
		reset(v1)
	end
end)

script.Destroying:Connect(function()
	for k1, v1 in tbl1, nil do
		reset(v1)
	end

	for k2, v2 in tbl1, nil do
		v2.gui:Destroy()
	end
end)

--- Players.LocalPlayer.PlayerScripts.OfflineLootController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = game:GetService("ReplicatedStorage")
local var3 = var1:WaitForChild("PlayerGui"):WaitForChild("Other"):WaitForChild("OfflineLoot")
local var4 = game:GetService("MarketplaceService")
local var5 = require(var2.Modules.UIEffects)
local var6 = require(var2.Modules.OtherSounds)
local var7 = require(var2.Modules.CashHudPulse)
local var8 = require(var2.Configs.ShopConfig)
local var9 = require(var2.Configs.TrailConfig)
local var10 = var2.Remotes.Functions:WaitForChild("OfflineLootRequest")
var3.Visible = false
var3:SetAttribute("WindowEffectsManaged", true)
local var11 = var3.ButtonsFolder.CollectFrame.Button
local var12 = var3.ButtonsFolder.DoubleCollect.Button
local var13 = var3.Exit.Button
local var14 = var12
local var15 = var2.Remotes.Events
local bool1 = false
local tbl1 = {}
for k1, v1 in { var11, var14, var13 }, nil do
	var5.BindButton(v1)
end

local var16 = var3.Size
local var17 = nil
local function fit()
	local var2 = workspace.CurrentCamera
	if var2 then
		local var4 = var3
		local var5 = if var2.ViewportSize.X < 1000 then UDim2.fromScale(0.92, 0.65) else var16
		var4.Size = var5
	end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if var17 then
		var17:Disconnect()
	end

	if workspace.CurrentCamera then
		var17 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
	end

	local var2 = workspace.CurrentCamera
	if var2 then
		local var4 = var3
		local var5 = if var2.ViewportSize.X < 1000 then UDim2.fromScale(0.92, 0.65) else var16
		var4.Size = var5
	end
end)

if var17 then
	var17:Disconnect()
end

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end

local var19 = workspace.CurrentCamera
if var19 then
	local var20 = if var19.ViewportSize.X < 1000 then UDim2.fromScale(0.92, 0.65) else var16
	var3.Size = var20
end

var19 = function(arg1)
	if type(arg1) ~= "table" or (not arg1.Ready) then
		return
	end

	tbl1 = arg1
	var3.Coins.Text.Text = "$" .. (arg1.Formatted or "0")
	var3.ButtonsFolder.DoubleCollect.Visible = 0 < (arg1.DoubleProductId or 0)
	local bool2 = false
	if 0 < (arg1.DoubleProductId or 0) then
		bool2 = not arg1.PurchasePending
	end

	var12.Active = bool2
	var12.Selectable = bool2
	local var1 = var3.ButtonsFolder.DoubleCollect.Text
	local var2
	if arg1.PurchasePending then
		var2 = "Processing\226\128\166"
	elseif bool2 then
		var2 = "x2 Collect"
	else
		var2 = "Unavailable"
	end

	var1.Text = var2
	var5.SetWindow(var3, arg1.Id ~= nil)
end

local function request(arg1)
	if bool1 then
		return
	end

	bool1 = true
	local success, result = pcall(function()
		local var1 = arg1
		return var10:InvokeServer(var1)
	end)

	bool1 = false
	if success and type(result) == "table" then
		var19(result.State)
		if not (not result.Success and result.Reason ~= "NoReward") then
			return
		end

		if result.Reason == "NoReward" then
			return
		end

		var6.Play("Error")
		return
	end

	var6.Play("Error")
end

var11.Activated:Connect(function()
	request("Claim")
end)

var13.Activated:Connect(function()
	request("Claim")
end)

var12.Activated:Connect(function()
	if 0 < (tbl1.DoubleProductId or 0) and (not tbl1.PurchasePending) then
		request("Double")
	end
end)

var15:WaitForChild("OfflineLootChanged").OnClientEvent:Connect(function(arg1, arg2)
	var19(arg1)
	if arg2 == "Claimed" then
		var7.Play()
		var6.Play("CashRegister")
	end
end)

task.spawn(function()
	while true do
		local success, result = pcall(function()
			local str1 = "Get"
			return var10:InvokeServer(str1)
		end)

		if success then
			var19(result)
		end

		local var1 = success
		if var1 and (result and result.Ready) then
			break
		end

		task.wait(1)
	end
end)

local tbl2 = {}
local function refresh()
	local success, result = pcall(function()
		local str1 = "Get"
		return var10:InvokeServer(str1)
	end)

	if success then
		var19(result)
	end

	local var1 = success
	return var1 and (result and result.Ready)
end

var15.PurchaseCelebration.OnClientEvent:Connect(function(arg1, arg2, arg3)
	if arg1 ~= "Product" or tbl2[arg2] then
		return
	end

	tbl2[arg2] = true
	if arg3 == var8.OfflineLoot.ProductId and 0 < arg3 then
		var7.Play()
		var6.Play("CashRegister")
		task.spawn(refresh)
		return
	end

	if arg3 and var9.GetByDevProductId(arg3) then
		var6.Play("CashRegister")
	end
end)

var15.CoreFeedback.OnClientEvent:Connect(function(arg1)
	if arg1.Kind == "TrailPurchase" and (arg1.Success and arg1.Reason == "Purchased") then
		var6.Play("CashRegister")
	end
end)

var4.PromptProductPurchaseFinished:Connect(function(arg1, arg2)
	if arg1 == var1.UserId and arg2 == var8.OfflineLoot.ProductId then
		task.delay(0.5, refresh)
	end
end)

--- Players.LocalPlayer.PlayerScripts.CaughtSpeedController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = var1:WaitForChild("PlayerGui"):WaitForChild("Notifications"):WaitForChild("BuySpeed")
local var3 = game:GetService("ReplicatedStorage")
var2:SetAttribute("WindowEffectsManaged", true)
local var4 = game:GetService("TweenService")
local var5 = var2:WaitForChild("Button")
local var6 = var2:WaitForChild("SpeedNumber")
local var7 = require(var3.Modules.UIEffects)
local var8 = require(var3.Modules.NumberFormatter)
local var9 = require(var3.Modules.OtherSounds)
local var10 = UDim2.fromScale(0.492, 0.13)
local var11 = UDim2.fromScale(0.492, -0.2)
var2.Position = var11
var2.Visible = false
var7.BindButton(var5)
local num1 = 0
local var12 = nil
local bool1 = false
local var13 = nil
local function hide()
	local var1 = num1 + 1
	num1 = var1
	var12 = nil
	bool1 = false
	if var13 then
		var13:Cancel()
	end

	local var3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	var13 = var4:Create(var2, var3, { Position = var11 })
	var13:Play()
	var1 = num1
	task.delay(0.3, function()
		if var1 == num1 then
			var2.Visible = false
			var7.Reset(var2)
		end
	end)
end

local function show(arg1)
	if (tonumber(arg1.ProductId) or 0) <= 0 then
		return
	end

	if type(arg1.Amount) ~= "number" or (arg1.Amount <= 0 or type(arg1.ZoneId) ~= "number") then
		return
	end

	local var1 = num1 + 1
	num1 = var1
	var1 = num1
	if var13 then
		var13:Cancel()
	end

	var12 = arg1
	bool1 = false
	var6.Text = "+" .. var8.Format(arg1.Amount)
	var5.Active = 0 < (arg1.ProductId or 0)
	var5.Selectable = var5.Active
	if not var2.Visible then
		var2.Position = var11
	end

	var2.Visible = true
	local var3 = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	var13 = var4:Create(var2, var3, { Position = var10 })
	var13:Play()
	task.delay(5.35, function()
		if var1 == num1 then
			hide()
		end
	end)
end

var3.Remotes.Events.CoreFeedback.OnClientEvent:Connect(function(arg1)
	if type(arg1) == "table" and arg1.Kind == "CaughtSpeedOffer" then
		show(arg1)
	end
end)

var5.Activated:Connect(function()
	if bool1 or (not var12 or (var12.ProductId or 0) <= 0) then
		return
	end

	bool1 = true
	local var1 = var12
	local success, result = pcall(function()
		local var2 = var1.ZoneId
		return var3.Remotes.Functions.CaughtSpeedPurchase:InvokeServer(var2)
	end)

	if var12 ~= var1 then
		return
	end

	bool1 = false
	if success and (result and result.Success) then
		hide()
		return
	end

	var9.Play("Error")
end)

var1.CharacterRemoving:Connect(hide)

--- Players.LocalPlayer.PlayerScripts.FreeGiftController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("Players").LocalPlayer
local var3 = var2:WaitForChild("PlayerGui"):WaitForChild("Other"):WaitForChild("FreeGift")
local var4 = game:GetService("GroupService")
local var5 = game:GetService("RunService")
local var6 = require(var1.Configs.FreeGiftConfig)
local var7 = require(var1.Modules.ShopRegions)
local var8 = require(var1.Modules.UIEffects)
local var9 = var1.Remotes.Functions:WaitForChild("FreeGiftRequest")
var3.Visible = false
var3:SetAttribute("WindowEffectsManaged", true)
local var10 = var3.CollectFrame.Button
var8.BindButton(var10)
var8.BindButton(var3.Exit.Button)
local var11 = var3.CollectFrame.Text
local bool1 = false
local bool2 = false
local num1 = 0
local function request(arg1)
	local success, result = pcall(function()
		local var1 = arg1
		return var9:InvokeServer(var1)
	end)

	if success then
		if type(result) == "table" then
			if result.Claimed then
				bool1 = true
			end

			return result
		end
	end

	return { Success = false, Reason = "VerificationUnavailable" }
end

local function refresh()
	if request("Get").Success and (not bool2) then
		local var1 = num1 + 1
		num1 = var1
		var1 = var11
		var1.Text = if bool1 then "Claimed!" else "Claim!"
		local var2 = not bool1
		var10.Active = var2 and (not bool2)
		var2 = not bool1
		var10.Selectable = var2 and (not bool2)
	end
end

var3.Exit.Button.Activated:Connect(function()
	var8.SetWindow(var3, false)
end)

local function claim()
	local var1 = request("Get")
	if bool1 then
		return
	end

	if not var1.Success then
		return "Try again!"
	end

	var11.Text = "Checking..."
	local success, result = pcall(function()
		local var1 = var2.UserId
		local var3 = var6.GroupId
		return var4:GetRolesInGroupAsync(var1, var3)
	end)

	local var5 = success
	if var5 then
		var5 = false
		if type(result) == "table" then
			var5 = result.IsMember == true
		end
	end

	if not var5 then
		var11.Text = "Join Group!"
		local success, result = pcall(function()
			local var1 = var6.GroupId
			return var4:PromptJoinAsync(var1)
		end)

		if not success then
			return "Try again!"
		end

		if result == Enum.GroupMembershipStatus.JoinRequestPending then
			return "Join pending!"
		end

		if result ~= Enum.GroupMembershipStatus.Joined and result ~= Enum.GroupMembershipStatus.AlreadyMember then
			return "Join Group!"
		end
	end

	var11.Text = "Verifying..."
	for i1 = 1, 6 do
		local var7 = request("Claim")
		if bool1 then
			return
		end

		if var7.Reason == "MoveCloser" then
			return "Move closer!"
		end

		if var7.Reason ~= "NotInGroup" and (var7.Reason ~= "Busy" and var7.Reason ~= "VerificationUnavailable") then
			return "Try again!"
		end

		if i1 >= 6 then
			continue
		end

		task.wait((math.min(i1 * 1.5, 5)))
	end

	return "Try again!"
end

var10.Activated:Connect(function()
	if bool2 or bool1 then
		return
	end

	bool2 = true
	local var1 = num1 + 1
	num1 = var1
	var10.Active = false
	var10.Selectable = false
	local success, result = pcall(claim)
	bool2 = false
	local var2 = var11
	var2.Text = if bool1 then "Claimed!" else "Claim!"
	local var3 = not bool1
	var10.Active = var3 and (not bool2)
	var3 = not bool1
	var10.Selectable = var3 and (not bool2)
	if not success then
		var2 = num1 + 1
		num1 = var2
		var11.Text = "Try again!"
		var2 = num1
		task.delay(var6.DeclineTextSeconds, function()
			if var2 == num1 then
				if not bool2 then
					local var1 = var11
					var1.Text = if bool1 then "Claimed!" else "Claim!"
					local var3 = not bool1
					var10.Active = var3 and (not bool2)
					var3 = not bool1
					var10.Selectable = var3 and (not bool2)
				end
			end
		end)

		return
	end

	if result then
		var2 = num1 + 1
		num1 = var2
		var11.Text = result
		var2 = num1
		task.delay(var6.DeclineTextSeconds, function()
			if var2 == num1 then
				if not bool2 then
					local var1 = var11
					var1.Text = if bool1 then "Claimed!" else "Claim!"
					local var3 = not bool1
					var10.Active = var3 and (not bool2)
					var3 = not bool1
					var10.Selectable = var3 and (not bool2)
				end
			end
		end)

	end
end)

local bool3 = false
var2.CharacterAdded:Connect(function()
	bool3 = false
	var8.SetWindow(var3, false)
end)

local num2 = 0
var5.Heartbeat:Connect(function(arg1)
	local var1 = num2 + arg1
	num2 = var1
	if num2 < 0.1 then
		return
	end

	num2 = 0
	var1 = var7.PlayerInside(var2, "FreeGift", 0) == true
	if var1 ~= bool3 then
		bool3 = var1
		var8.SetWindow(var3, var1)
		if var1 then
			task.spawn(refresh)
		end
	end
end)

var11.Text = if bool1 then "Claimed!" else "Claim!"
local var12 = not bool1
var10.Active = var12 and (not bool2)
var12 = not bool1
var10.Selectable = var12 and (not bool2)
task.spawn(function()
	for i1 = 1, 10 do
		if request("Get").Success then
			if not bool2 then
				local var1 = var11
				var1.Text = if bool1 then "Claimed!" else "Claim!"
				local var2 = not bool1
				var10.Active = var2 and (not bool2)
				var2 = not bool1
				var10.Selectable = var2 and (not bool2)
			end

			return
		end

		task.wait(2)
	end
end)

--- Players.LocalPlayer.PlayerScripts.RareCarController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Notifications"):WaitForChild("RareCar")
local var3 = var2:FindFirstChildOfClass("UIGradient")
local var4 = game:GetService("TweenService")
local var5 = game:GetService("RunService")
local var6 = require(var1.Configs.RareCarConfig)
local var7 = require(var1.Configs.CarConfig)
var3 = var3 or Instance.new("UIGradient", var2)
var3.Rotation = 0
var3.Offset = Vector2.zero
var2.TextColor3 = Color3.new(1, 1, 1)
local var8 = UDim2.fromScale(0.5, 0.159)
local var9 = UDim2.fromScale(0.5, -0.3)
var2.Position = var9
var2.Visible = false
local num1 = 0
local var10 = nil
local var11 = nil
var1.Remotes.Events:WaitForChild("RareCarSpawned").OnClientEvent:Connect(function(arg1, arg2)
	if type(arg1) ~= "string" or type(arg2) ~= "string" then
		return
	end

	local var1 = num1 + 1
	num1 = var1
	var1 = num1
	if var10 then
		var10:Cancel()
	end

	local var5 = var7.Get(arg1)
	if var5.Rarity ~= "Celestial" then
		local var12 = var5.Rarity == "Infernal" and var5.Rarity or nil
	end

	local var13 = var5.Rarity
	var11 = var13 or nil
	if var11 then
		var3.Color = var7.Rarities[var11].Gradient
	end

	var2.Text = "A " .. (var5.DisplayName or arg1) .. " has spawned in " .. arg2 .. "!"
	var2.Position = var9
	var2.Visible = true
	local var14 = TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	var10 = var4:Create(var2, var14, { Position = var8 })
	var10:Play()
	task.delay(var6.DisplaySeconds, function()
		if var1 ~= num1 then
			return
		end

		local var3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		var10 = var4:Create(var2, var3, { Position = var9 })
		var10:Play()
		var10.Completed:Once(function(arg1)
			if var1 == num1 and arg1 == Enum.PlaybackState.Completed then
				var2.Visible = false
			end
		end)
	end)
end)

local num2 = 0
var5.Heartbeat:Connect(function(arg1)
	if not var2.Visible then
		return
	end

	local var1 = num2 + arg1
	num2 = var1
	if num2 < 0.033333333333333333 then
		return
	end

	num2 = 0
	if var11 then
		local var4 = workspace:GetServerTimeNow() * 3.1415926535897931 * 2
		var1 = var4 / (if var11 == "Infernal" then 1.15 else 0.85)
		var3.Offset = Vector2.new(math.sin(var1) * 0.46, 0)
		var3.Rotation = math.sin(var1 * 0.5) * 25
		return
	end

	var3.Offset = Vector2.zero
	var3.Rotation = 0
	var1 = workspace:GetServerTimeNow() * 0.35
	local tbl1 = {}
	for i1 = 0, 8 do
		local var5 = (i1 / 8 - var1) % 1
		local num1 = 1
		local num3 = 1
		tbl1[i1 + 1] = ColorSequenceKeypoint.new(i1 / 8, Color3.fromHSV(var5, num1, num3))
	end

	var3.Color = ColorSequence.new(tbl1)
end)

--- Players.LocalPlayer.PlayerScripts.CombatController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players")
local var2 = game:GetService("ReplicatedStorage")
local var3 = var2.Remotes.Events
local var4 = var1.LocalPlayer
local var5 = setmetatable({}, { __mode = "k" })
local function stopSwing(arg1)
	local var2 = var5[arg1]
	if not var2 then
		return
	end

	var5[arg1] = nil
	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	var2.track:Stop(0.08)
	var2.track:Destroy()
	var2.animation:Destroy()
end

local var6 = require(var2.Configs.CombatConfig)
local tbl1 = { Bat = 0, BearTrap = 0 }
local var7 = var3:WaitForChild("CombatRequest")
local function animateSwing(arg1)
	if var5[arg1] then
		return
	end

	local var1 = arg1.Parent
	local var2 = var1
	var2 = var2 and var1:FindFirstChildOfClass("Humanoid")
	local var3 = var2
	var3 = var3 and var2:FindFirstChildOfClass("Animator")
	if not var3 or (var2.Health <= 0 or (var1:GetAttribute("IsTrapped") or (var1:GetAttribute("Ragdolled") or var1:GetAttribute("Driving")))) then
		return
	end

	local var7 = if var2.RigType == Enum.HumanoidRigType.R15 then arg1:GetAttribute("SwingAnimationR15") else arg1:GetAttribute("SwingAnimationR6")
	if not var7 then
		return
	end

	for k1, v1 in var3:GetPlayingAnimationTracks() do
		if not v1.Animation then
			continue
		end

		if v1.Animation.AnimationId ~= var7 then
			continue
		end

		if not v1.IsPlaying then
			continue
		end

		return
	end

	local var8 = Instance.new("Animation")
	var8.AnimationId = var7
	local success, result = pcall(function()
		local var1 = var8
		return var3:LoadAnimation(var1)
	end)

	if not success then
		var8:Destroy()
		return
	end

	local tbl1 = { track = result, animation = var8, connections = {} }
	var5[arg1] = tbl1
	result.Priority = Enum.AnimationPriority.Action
	result.Looped = false
	local function fn2()
		stopSwing(arg1)
	end

	table.insert(tbl1.connections, arg1.Unequipped:Connect(fn2))
	fn2 = function()
		stopSwing(arg1)
	end

	table.insert(tbl1.connections, var2.Died:Connect(fn2))
	fn2 = "Ragdolled"
	for k2, v2 in { "IsTrapped", fn2, "Driving" }, nil do
		local function fn4()
			if var1:GetAttribute(v2) then
				stopSwing(arg1)
			end
		end

		table.insert(tbl1.connections, var1:GetAttributeChangedSignal(v2):Connect(fn4))
	end

	local function fn6()
		stopSwing(arg1)
	end

	table.insert(tbl1.connections, result.Ended:Connect(fn6))
	result:Play(0.06, 1, 1)
	task.delay(var6.BatCooldown, function()
		if var5[arg1] == tbl1 then
			stopSwing(arg1)
		end
	end)
end

local var8 = game:GetService("UserInputService")
local function place(arg1)
	local var1 = var4.Character
	local var2 = var1
	var2 = var2 and var1:FindFirstChildOfClass("Tool")
	local var5 = var2
	if var5 then
		var5 = false
		if var2:GetAttribute("CombatKind") == "BearTrap" then
			var5 = var2
		end
	end

	if not var5 or os.clock() < tbl1.BearTrap then
		return
	end

	tbl1.BearTrap = os.clock() + 0.35
	var5 = var4.Character
	if var5:GetAttribute("IsTrapped") or (var5:GetAttribute("Ragdolled") or var5:GetAttribute("Driving")) then
		return
	end

	var1 = workspace.CurrentCamera
	if not var1 then
		return
	end

	var2 = var1:ViewportPointToRay(arg1.X, arg1.Y)
	local var6 = RaycastParams.new()
	var6.FilterType = Enum.RaycastFilterType.Exclude
	var6.FilterDescendantsInstances = { var5 }
	var6.RespectCanCollide = true
	local var9 = workspace:Raycast(var2.Origin, var2.Direction * 1000, var6)
	if not var9 then
		return
	end

	var7:FireServer("Place", var9.Position)
end

local var9 = setmetatable({}, { __mode = "k" })
local function activate(arg1)
	local var1 = var4.Character
	local var2 = var1
	var2 = var2 and var1:FindFirstChildOfClass("Tool")
	local var9 = var2
	local var10 = arg1:GetAttribute("CombatKind")
	if var9 then
		var9 = false
		if var2:GetAttribute("CombatKind") == var10 then
			var9 = var2
		end
	end

	if not var9 then
		return
	end

	if var10 == "Bat" then
		if os.clock() < tbl1.Bat then
			return
		end

		tbl1.Bat = os.clock() + var6.BatCooldown
		animateSwing(arg1)
		var7:FireServer("Swing")
		return
	end

	if var8:GetLastInputType() ~= Enum.UserInputType.Touch then
		var9 = workspace.CurrentCamera
		if not var9 then
			return
		end

		place(if var8:GetLastInputType().Name:find("Gamepad") then var9.ViewportSize / 2 else var8:GetMouseLocation())
	end
end

var8.TouchTapInWorld:Connect(function(arg1, arg2)
	if not arg2 then
		place(arg1)
	end
end)

local function bind(arg1)
	if not arg1:IsA("Tool") or (not arg1:GetAttribute("CombatKind") or var9[arg1]) then
		return
	end

	var9[arg1] = true
	arg1.Activated:Connect(function()
		activate(arg1)
	end)

	arg1.Destroying:Once(function()
		stopSwing(arg1)
	end)
end

var4.CharacterAdded:Connect(function(arg1)
	arg1.ChildAdded:Connect(bind)
	for k1, v1 in arg1:GetChildren() do
		bind(v1)
	end
end)

local var11 = game:GetService("RunService")
if var4.Character then
	local var12 = var4.Character
	var12.ChildAdded:Connect(bind)
	for k1, v1 in var12:GetChildren() do
		bind(v1)
	end
end

local function bindBackpack(arg1)
	if not arg1:IsA("Backpack") then
		return
	end

	arg1.ChildAdded:Connect(bind)
	for k1, v1 in arg1:GetChildren() do
		bind(v1)
	end
end

var4.ChildAdded:Connect(bindBackpack)
local str1 = "Backpack"
bindBackpack(var4:WaitForChild(str1))
task.spawn(function()
	local var1 = var4.PlayerGui:WaitForChild("BackpackGui")
	var1:GetAttributeChangedSignal("CombatEquipRequestRevision"):Connect(function()
		local var3 = var1:GetAttribute("RequestedCombatTool")
		if var3 == "" or (var3 == "Bat" or var3 == "BearTrap") then
			var7:FireServer("Equip", var3)
		end
	end)

	if var1:GetAttribute("CombatEquipRequestRevision") then
		local str2 = "RequestedCombatTool"
		var7:FireServer("Equip", var1:GetAttribute(str2))
	end
end)

var3:WaitForChild("CombatSwing").OnClientEvent:Connect(function(arg1)
	if arg1 == var4 then
		return
	end

	local var1 = arg1
	var1 = var1 and arg1.Character
	local var2 = var1
	local var3 = var1
	var2 = var2 and var1:FindFirstChildOfClass("Tool")
	var3 = var3 and var1:FindFirstChild("HumanoidRootPart")
	if not var2 or (var2:GetAttribute("CombatKind") ~= "Bat" or (not var3)) then
		return
	end

	if 140 < (var3.Position - workspace.CurrentCamera.CFrame.Position).Magnitude then
		return
	end

	animateSwing(var2)
end)

local num1 = 0
var11.Heartbeat:Connect(function(arg1)
	local var2 = num1 + arg1
	num1 = var2
	if num1 < 0.1 then
		return
	end

	num1 = 0
	var2 = workspace:GetServerTimeNow()
	for k1, v1 in var1:GetPlayers() do
		local var3 = v1.Character
		local var4 = var3
		local var5 = var3
		var5 = var5 and var3:FindFirstChild("HumanoidRootPart")
		local var6 = var5
		var4 = var4 and var3:GetAttribute("TrappedUntil")
		var6 = var6 and var5:FindFirstChild("TrappedCountdown")
		if not var4 or (not var6) then
			continue
		end

		local var7 = var6:FindFirstChild("Text", true)
		if not var7 then
			continue
		end

		if not var7:IsA("TextLabel") then
			continue
		end

		local var8 = math.max(0, (math.ceil(var4 - var2))) .. "s"
		if var7.Text == var8 then
			continue
		end

		var7.Text = var8
	end
end)

--- Players.LocalPlayer.PlayerScripts.FriendBoostController [LocalScript]
-- y u r i

local var1 = game:GetService("Players").LocalPlayer
local var2 = var1:WaitForChild("PlayerGui")
local function render()
	local var3 = var2:FindFirstChild("HUD")
	local var4 = var3
	var4 = var4 and var3:FindFirstChild("BottomLeft")
	local var5 = var4
	var5 = var5 and var4:FindFirstChild("Friendboost")
	if not var5 or (not var5:IsA("TextLabel")) then
		return
	end

	local str1 = "FriendBoostPercent"
	local var6 = math.clamp(math.floor(tonumber(var1:GetAttribute(str1)) or 0), 0, 30)
	var5.Text = ("Friend Boost: +%d%%"):format(var6)
	var5.Visible = 0 < var6
end

var1:GetAttributeChangedSignal("FriendBoostPercent"):Connect(render)
var2.DescendantAdded:Connect(function(arg1)
	if arg1.Name == "Friendboost" then
		render()
	end
end)

render()

--- Players.LocalPlayer.PlayerScripts.TreadmillUpgradeController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local str1 = "UIEffects"
local var2 = game:GetService("Players").LocalPlayer
local var3 = require(var1:WaitForChild("Modules"):WaitForChild(str1))
str1 = var2:WaitForChild("PlayerGui"):WaitForChild("Notifications"):WaitForChild("UpgradeTreadmill")
local var4 = str1.Position
str1:SetAttribute("WindowEffectsManaged", true)
local var5 = game:GetService("TweenService")
local var6 = require(var1.Configs.TreadmillConfig)
local var7 = var1.Remotes.Functions:WaitForChild("UpgradeTreadmillPurchase")
local var8 = str1:WaitForChild("Button")
local var9 = str1:WaitForChild("TreadmillIcon")
local var10 = UDim2.new(1.3, 0, var4.Y.Scale, var4.Y.Offset)
str1.Visible = false
str1.Position = var10
var3.BindButton(var8)
local var11 = nil
local bool1 = false
local var12 = nil
local num1 = 0
local var13 = nil
local function picture(arg1)
	if var11 then
		var11:Destroy()
		var11 = nil
	end

	local var2 = var6.Tiers[arg1]
	if type(var2.Icon) == "string" and var2.Icon ~= "" then
		var9.Image = var2.Icon
		return
	end

	var9.Image = ""
	local var3 = nil
	for k1, v1 in var1.Assets.Treadmills:GetChildren() do
		local var4 = v1:GetAttribute("Tier")
		if var4 ~= arg1 then
			continue
		end

		var3 = v1
		break
	end

	if not var3 then
		return
	end

	local var5 = var3:Clone()
	for k2, v2 in var5:GetDescendants() do
		if v2:IsA("LuaSourceContainer") or (v2:IsA("LayerCollector") or (v2:IsA("ParticleEmitter") or (v2:IsA("Trail") or (v2:IsA("Beam") or v2:IsA("Sound"))))) then
			v2:Destroy()
		else
			if not v2:IsA("BasePart") then
				continue
			end

			if 1 <= v2.Transparency then
				v2:Destroy()
			else
				v2.Anchored = true
				v2.CanCollide = false
				v2.CanTouch = false
				v2.CanQuery = false
			end
		end
	end

	var5:PivotTo(CFrame.new())
	local var7 = Instance.new("ViewportFrame")
	var7.Name = "NextTreadmillPreview"
	var7.BackgroundTransparency = 1
	var7.Size = UDim2.fromScale(1, 1)
	var7.ZIndex = var9.ZIndex
	var7.Ambient = Color3.fromRGB(210, 210, 220)
	var7.LightColor = Color3.new(1, 1, 1)
	var7.LightDirection = Vector3.new(-1, -1, -1)
	var5.Parent = var7
	local var8, var10 = var5:GetBoundingBox()
	local var12 = Vector3.new(0.8, 0.7, -1).Unit
	local var13 = math.max(0.2, var9.AbsoluteSize.X / math.max(1, var9.AbsoluteSize.Y)) * 0.28674538575880792
	local var14 = CFrame.lookAt(var8.Position, var8.Position - var12)
	local num1 = 0
	for k3, v3 in var5:GetDescendants() do
		if not v3:IsA("BasePart") then
			continue
		end

		for i1 = -1, 1, 2 do
			for i2 = -1, 1, 2 do
				for i3 = -1, 1, 2 do
					local var15 = v3.Size * Vector3.new(i1, i2, i3) * 0.5
					local var16 = var14:PointToObjectSpace(v3.CFrame:PointToWorldSpace(var15))
					num1 = math.max(num1, var16.Z + math.abs(var16.X) / var13, var16.Z + math.abs(var16.Y) / 0.28674538575880792)
				end
			end
		end
	end

	local var17 = Instance.new("Camera")
	var17.FieldOfView = 32
	var17.CFrame = CFrame.lookAt(var8.Position + var12 * num1 * 1.08, var8.Position)
	var17.Parent = var7
	var7.CurrentCamera = var17
	var7.Parent = var9
	var11 = var7
end

local function refresh()
	if not var2:GetAttribute("TrainingAdminEvent") then
		local str3 = "TrainingTier"
		local var1 = tonumber(var2:GetAttribute(str3))
		var1 = var1 or nil
	end

	local var7 = nil
	local var9 = var7
	var9 = var9 and var7 + 1
	if var7 then
		var9 = var7 >= 1 and var6.Tiers[var9] or nil
	end

	var9 = nil
	local var14 = var8
	local bool3 = false
	if var9 ~= nil then
		bool3 = false
		if 0 < (var6.Tiers[var9].ProductId or 0) then
			bool3 = not bool1
			bool3 = bool3 and (not var2:GetAttribute("TreadmillPurchasePending"))
		end
	end

	var14.Active = bool3
	var8.Selectable = var8.Active
	if var9 == var12 then
		return
	end

	var12 = var9
	var14 = num1 + 1
	num1 = var14
	var14 = num1
	if var13 then
		var13:Cancel()
	end

	if var9 then
		str1.Visible = true
		picture(var9)
		str1:SetAttribute("OfferedTier", var9)
		local var15 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		var13 = var5:Create(str1, var15, { Position = var4 })
	else
		str1:SetAttribute("OfferedTier", nil)
		local var16 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		var13 = var5:Create(str1, var16, { Position = var10 })
		task.delay(0.25, function()
			if num1 == var14 then
				str1.Visible = false
				var3.Reset(str1)
				if var11 then
					var11:Destroy()
					var11 = nil
				end
			end
		end)

	end

	var13:Play()
end

var8.Activated:Connect(function()
	if bool1 or (not var12 or (var6.Tiers[var12].ProductId or 0) <= 0) then
		return
	end

	bool1 = true
	refresh()
	local success, result = pcall(function()
		local var1 = var12
		return var7:InvokeServer(var1)
	end)

	bool1 = false
	refresh()
	if not success or (not result or (not result.Success)) then
		require(var1.Modules.OtherSounds).Play("Error")
	end
end)

var2:GetAttributeChangedSignal("TrainingTier"):Connect(refresh)
var2:GetAttributeChangedSignal("TrainingAdminEvent"):Connect(refresh)
var2:GetAttributeChangedSignal("TreadmillPurchasePending"):Connect(refresh)
var9:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if var12 then
		picture(var12)
	end
end)

script.Destroying:Connect(function()
	if var11 then
		var11:Destroy()
		var11 = nil
	end
end)

refresh()

--- Players.LocalPlayer.PlayerScripts.TreadmillMultiplierController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local str1 = "TreadmillMultiplierConfig"
local var2 = game:GetService("Players").LocalPlayer
local var3 = require(var1:WaitForChild("Configs"):WaitForChild(str1))
str1 = var2:WaitForChild("PlayerGui"):WaitForChild("Notifications"):WaitForChild("SpeedMultiplier")
local var4 = str1:WaitForChild("Button")
local function palette(...)
	local tbl1 = { ... }
	local tbl2 = {}
	for k1, v1 in tbl1, nil do
		local var1 = v1[1]
		local var2 = v1[2]
		local var3 = v1[3]
		tbl2[k1] = ColorSequenceKeypoint.new((k1 - 1) / (#tbl1 - 1), Color3.fromRGB(var1, var2, var3))
	end

	local var4 = tbl2
	return ColorSequence.new(var4)
end

local var5 = game:GetService("MarketplaceService")
local var6 = game:GetService("TweenService")
local var7 = require(var1.Modules.UIEffects)
local var8 = var1.Remotes.Functions:WaitForChild("BuyTreadmillMultiplier")
local var9 = var4:WaitForChild("UIGradient")
local tbl1 = { palette({ 0, 213, 255 }, { 0, 255, 140 }) }
tbl1[2] = palette({ 70, 245, 25 }, { 225, 255, 60 }, { 0, 195, 65 })
tbl1[4] = palette({ 255, 155, 0 }, { 255, 235, 30 }, { 255, 65, 0 })
tbl1[8] = palette({ 255, 0, 110 }, { 255, 65, 220 }, { 145, 0, 255 })
tbl1[16] = palette({ 45, 0, 255 }, { 0, 240, 255 }, { 185, 0, 255 })
tbl1[32] = palette({ 255, 0, 65 }, { 255, 150, 0 }, { 245, 255, 0 }, { 0, 255, 95 }, { 0, 205, 255 }, { 95, 0, 255 }, { 255, 0, 220 })
tbl1[64] = palette({ 255, 0, 190 }, { 135, 0, 255 }, { 0, 255, 255 }, { 140, 255, 0 }, { 255, 225, 0 }, { 255, 0, 65 })
local var10 = nil
local tbl2 = {}
local tbl3 = {}
local tbl4 = {}
local bool1 = false
local var11 = nil
str1:SetAttribute("WindowEffectsManaged", true)
local var12 = str1:WaitForChild("SpeedText")
local var13 = str1:WaitForChild("RobuxText")
local var14 = UDim2.fromScale(0.5, 0.108)
local var15 = UDim2.fromScale(0.5, -0.2)
str1.Position = var15
str1.Visible = false
var13.Visible = false
var7.BindButton(var4)
local var16 = nil
local var17 = nil
local bool2 = false
local function loadPrice(arg1)
	if arg1 <= 0 or (tbl2[arg1] or (tbl3[arg1] or os.clock() < (tbl4[arg1] or 0))) then
		return
	end

	tbl3[arg1] = true
	task.spawn(function()
		local success, result = pcall(var5.GetProductInfoAsync, var5, arg1, Enum.InfoType.Product)
		tbl3[arg1] = nil
		if not str1.Parent then
			return
		end

		if success and (type(result) == "table" and (type(result.PriceInRobux) == "number" and result.IsForSale)) then
			tbl2[arg1] = result.PriceInRobux
		else
			tbl4[arg1] = os.clock() + 15
			task.delay(15, function()
				if str1.Parent and bool1 then
					var11()
				end
			end)

		end

		var11()
	end)
end

local num1 = 0
local var18 = nil
var11 = function()
	local str2 = "PurchasedTreadmillMultiplier"
	local var1 = tonumber(var2:GetAttribute(str2)) or 1
	local var8 = tbl1[var1] and var1 or 1
	if var10 ~= var8 then
		var10 = var8
		var9.Color = tbl1[var8]
	end

	local var11 = if var2:GetAttribute("TrainingTier") ~= nil and var1 < 2 ^ var3.MaxLevel then var1 * 2 else nil
	var16 = var11
	var11 = var16
	var11 = var11 and var3.Upgrades[var16]
	local var19 = var11 ~= nil
	if var11 then
		if var11.ProductId <= 0 then
			str2 = var11.RobuxPrice
		else
			str2 = tbl2[var11.ProductId]
		end
	else
		str2 = nil
	end

	var17 = str2
	if var16 then
		var12.Text = "x" .. var16 .. " Speed"
	end

	var13.Visible = var17 ~= nil
	if var17 then
		var13.Text = "Only " .. tostring(var17) .. "\238\128\130!"
	end

	local var21 = var19
	str2 = var4
	if var21 then
		var21 = false
		if 0 < var11.ProductId then
			var21 = false
			if var17 ~= nil then
				var21 = not bool2
				var21 = var21 and (not var2:GetAttribute("MultiplierPurchasePending"))
			end
		end
	end

	str2.Active = var21
	var4.Selectable = var4.Active
	if var19 then
		loadPrice(var11.ProductId)
	end

	if var19 == bool1 then
		return
	end

	bool1 = var19
	str2 = num1 + 1
	num1 = str2
	str2 = num1
	if var18 then
		var18:Cancel()
	end

	if var19 then
		str1.Visible = true
		local var22 = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		var18 = var6:Create(str1, var22, { Position = var14 })
	else
		local var23 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		var18 = var6:Create(str1, var23, { Position = var15 })
		task.delay(0.25, function()
			if num1 == str2 then
				str1.Visible = false
				var7.Reset(str1)
			end
		end)

	end

	var18:Play()
end

var4.Activated:Connect(function()
	if bool2 or (not var16 or (var3.Upgrades[var16].ProductId <= 0 or (not var17 or var2:GetAttribute("MultiplierPurchasePending")))) then
		return
	end

	bool2 = true
	var11()
	local var4 = var16
	local success, result = pcall(function()
		local var1 = var4
		return var8:InvokeServer(var1)
	end)

	bool2 = false
	var11()
	if not success or (not result or (not result.Success)) then
		require(var1.Modules.OtherSounds).Play("Error")
	end
end)

local str2 = "PurchasedTreadmillMultiplier"
for k1, v1 in { "TrainingTier", str2, "MultiplierPurchasePending" }, nil do
	var2:GetAttributeChangedSignal(v1):Connect(var11)
end

var11()

--- Players.LocalPlayer.PlayerScripts.RaceController [LocalScript]
-- y u r i

local var1 = game:GetService("Players").LocalPlayer
local var2 = game:GetService("ReplicatedStorage")
local tbl1 = {}
local tbl2 = {}
local var3 = Color3.fromRGB(255, 210, 35)
local var4 = Color3.fromRGB(220, 235, 255)
local var5 = Color3.fromRGB(255, 145, 55)
local var6 = game:GetService("SoundService")
local bool1 = false
local num1 = 0
local num2 = 0
local var7 = nil
local var8 = nil
local var9 = require(var2.Modules.UIEffects)
local var10 = game:GetService("TweenService")
local var11 = nil
local var12 = require(var2.Modules.OtherSounds)
local var13 = require(var2.Configs.RaceConfig)
local var14 = var2:WaitForChild("RaceState")
local tbl3 = {}
local var15 = var1:WaitForChild("PlayerGui")
local var16 = require(var2.Modules.ConfettiEffect)
local var17 = require(var2.Modules.CashHudPulse)
local var18 = nil
local var19 = nil
local var20 = require(var2.Modules.RaceFinishPresentation)
local var21 = nil
local var22 = var2.Remotes.Functions:WaitForChild("RaceRewardRequest")
local function renderReward(arg1)
	if type(arg1) ~= "table" or (not arg1.Ready) then
		return
	end

	var18 = arg1.Offer
	if not var19 then
		return
	end

	if var20.IsActive() or var1:GetAttribute("RaceFinishing") then
		return
	end

	if var18 then
		var19.Rewards.Text.Text = tostring(var18.Minutes) .. "m Time Skip!"
		local var2 = var19.Rewards.Icon
		var2.Image = if var18.Kind == "Cash" then var13.CashRewardIcon else var13.SpeedRewardIcon
	end

	var9.SetWindow(var19, var18 ~= nil)
end

local var23 = setmetatable({}, { __mode = "k" })
local var24 = nil
local var25 = nil
local var26 = nil
local var27 = var2.Remotes.Events:WaitForChild("RaceRequest")
local function hideInvite()
	if bool1 then
		return
	end

	bool1 = true
	num1 = 0
	local var1 = num2 + 1
	num2 = var1
	var1 = num2
	if var7 then
		var7:Cancel()
	end

	if not var8 or (not var8.Parent) then
		bool1 = false
		return
	end

	local var2 = var8
	var9.Reset(var2)
	local var3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	var7 = var10:Create(var2, var3, { Position = UDim2.fromScale(0.5, -0.35) })
	var7:Play()
	task.delay(0.3, function()
		if var1 == num2 and var2.Parent then
			var2.Visible = false
			bool1 = false
		end
	end)
end

local function claim()
	if var21 or (not var18) then
		return
	end

	var21 = true
	local var1 = var18.Id
	local success, result = pcall(function()
		local str1 = "Claim"
		local var2 = var1
		return var22:InvokeServer(str1, var2)
	end)

	var21 = false
	if not success or (not result.Success) then
		var12.Play("Error")
		if success then
			renderReward(result.State)
		end
	end
end

local var28 = nil
local function findUI()
	local var1 = var15:FindFirstChild("Notifications")
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("JoinRace")
	if var2 ~= var8 then
		var8 = var2
		bool1 = false
		if var8 then
			var8.Visible = false
		end
	end

	var24 = var15:FindFirstChild("Race")
	local var3 = var24
	var3 = var3 and var24:FindFirstChild("Finish")
	if var3 ~= var25 then
		var25 = var3
		if var25 then
			var25.Visible = false
			var25:SetAttribute("WindowEffectsManaged", true)
		end
	end

	local var4 = var24
	var4 = var4 and var24:FindFirstChild("RaceRewards")
	local var5 = var4
	var5 = var5 and var4:FindFirstChild("Rewards")
	var4 = var5 and (var5:FindFirstChild("Text") and var5:FindFirstChild("Icon")) or nil
	if var4 ~= var19 then
		var19 = var4
		if var19 then
			var19.Visible = false
			var19:SetAttribute("WindowEffectsManaged", true)
		end

		if var18 then
			renderReward({ Ready = true, Offer = var18 })
		end
	end

	if var8 then
		local var6 = var8:FindFirstChild("Yes")
		var6 = var6 and var8.Yes:FindFirstChild("Button")
		local function fn2()
			if var26 or var14:GetAttribute("Phase") ~= "Joining" then
				return
			end

			var26 = true
			var27:FireServer("Join")
			task.delay(3, function()
				var26 = false
			end)
		end

		if var6 then
	if not var23[var6] then
				var23[var6] = true
				var9.BindButton(var6)
				var6.Activated:Connect(fn2)
			end
		end

		var6 = var8:FindFirstChild("No")
		var6 = var6 and var8.No:FindFirstChild("Button")
		fn2 = hideInvite
		if var6 then
	if not var23[var6] then
				var23[var6] = true
				var9.BindButton(var6)
				var6.Activated:Connect(fn2)
			end
		end
	end

	if var19 then
		local var10 = var19:FindFirstChild("ButtonsFolder")
		fn2 = var10
		fn2 = fn2 and var10:FindFirstChild("CollectFrame")
		local var11 = fn2
		var11 = var11 and fn2:FindFirstChild("Button")
		local var12 = claim
		if var11 then
	if not var23[var11] then
				var23[var11] = true
				var9.BindButton(var11)
				var11.Activated:Connect(var12)
			end
		end

		var11 = var19:FindFirstChild("Exit")
		var12 = var11
		var12 = var12 and var11:FindFirstChild("Button")
		if var12 then
			local var13 = claim
			if var23[var12] then
				return
			end

			var23[var12] = true
			var9.BindButton(var12)
			var12.Activated:Connect(var13)
		end
	end
end

local var29 = nil
local function showInvite(arg1)
	if not var8 or var11 == arg1 then
		return
	end

	var11 = arg1
	local var1 = num2 + 1
	num2 = var1
	bool1 = false
	if var7 then
		var7:Cancel()
	end

	var8.Position = UDim2.fromScale(0.5, -0.35)
	var8.Visible = true
	var12.Play("Notification")
	num1 = math.min(workspace:GetServerTimeNow() + var13.InviteSeconds, var14:GetAttribute("Deadline") or math.huge)
	local var2 = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	var7 = var10:Create(var8, var2, { Position = UDim2.fromScale(0.5, 0.311) })
	var7:Play()
end

local var30 = nil
local var31 = nil
local var32 = nil
local var33 = nil
local var34 = nil
local function pulse(arg1)
	local var1 = arg1:FindFirstChild("RacePulseScale")
	var1 = var1 or Instance.new("UIScale")
	var1.Name = "RacePulseScale"
	var1.Parent = arg1
	if var28 then
		var28:Cancel()
	end

	var1.Scale = 1.18
	var28 = var10:Create(var1, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 })
	var28:Play()
end

local var35 = nil
local var36 = nil
local function announcePodium(arg1)
	if type(arg1) ~= "table" or (type(arg1.Name) ~= "string" or (type(arg1.RoundId) ~= "string" or (type(arg1.Place) ~= "number" or (arg1.Place % 1 ~= 0 or (arg1.Place < 1 or 3 < arg1.Place))))) then
		return
	end

	local var1 = arg1.RoundId .. ":" .. tostring(arg1.Place)
	if tbl1[var1] then
		return
	end

	tbl1[var1] = true
	table.insert(tbl2, var1)
	if 30 < (#tbl2) then
		local var2 = table.remove(tbl2, 1)
		tbl1[var2] = nil
	end

	local var3 = "<font color=\"" .. ({ "#FFD23F", "#C0C9DA", "#CD7F32" })[arg1.Place] .. "\">" .. arg1.Name:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;") .. " came " .. ({ "1st", "2nd", "3rd" })[arg1.Place] .. "!</font>"
	task.spawn(function()
		local var1 = game:GetService("TextChatService"):WaitForChild("TextChannels", 15)
		local var2 = var1
		var2 = var2 and (var1:FindFirstChild("RBXGeneral") or var1:WaitForChild("RBXGeneral", 10))
		if var2 then
			var2:DisplaySystemMessage(var3, "RacePodium")
		end
	end)
end

local function updateUI()
	local var11
	findUI()
	local var2 = workspace:GetServerTimeNow()
	local var7 = var14:GetAttribute("Phase")
	local var9 = var14:GetAttribute("RoundId")
	local var10 = math.max(0, (math.ceil((var14:GetAttribute("Deadline") or var2) - var2)))
	if var1:GetAttribute("RaceParticipant") ~= true then
		local bool3 = false
		if var1:GetAttribute("RaceJoining") == true then
			bool3 = not var20.IsActive()
			bool3 = bool3 and (not var1:GetAttribute("RaceFinishing"))
		end
	end

	if var7 == "Joining" and (var9 and (var29 ~= var9 and (not var11))) then
		showInvite(var9)
	end

	if var8 and (var8.Visible and (num1 <= var2 or (var7 ~= "Joining" or var11))) then
		hideInvite()
	end

	local var12 = var15:FindFirstChild("HUD")
	local var16 = var12
	var16 = var16 and var12:FindFirstChild("BottomRight")
	local var17 = var16
	var17 = var17 and var16:FindFirstChild("Time")
	if var17 then
		local bool6 = false
		if var7 ~= nil then
			bool6 = false
			if var7 ~= "Disabled" then
				bool6 = var7 ~= "Unavailable"
			end
		end

		var17.Visible = bool6
		bool6 = if var7 == "Intermission" then string.format("Race in %dm %ds", math.floor(var10 / 60), var10 % 60) else "Race is NOW!"
		var17.Text = bool6
	end

	if var7 ~= var30 then
		if var7 == "Racing" and var11 then
			var31 = var2 + 1
			local var18 = var6:FindFirstChild("Race")
			local var19 = var18
			var19 = var19 and var18:FindFirstChild("Go")
			if var19 then
				var19.PlaybackSpeed = 1
				var19.TimePosition = 0
				var6:PlayLocalSound(var19)
			end
		end

		var30 = var7
	end

	if not var24 then
		return
	end

	local var22 = var24:FindFirstChild("LapNumber")
	local var23 = var24:FindFirstChild("Position")
	local var25 = var24:FindFirstChild("TimeLeft")
	if var22 then
		local var26 = var11
		var26 = var26 or var20.IsActive()
		var22.Visible = var26
		var26 = var1:GetAttribute("RaceMaxLaps")
		var26 = var26 or (var14:GetAttribute("MaxLaps") or (var13.Laps or 1))
		var22.Text = string.format("Lap %d/%d", math.clamp(var1:GetAttribute("RaceLap") or 1, 1, var26), var26)
	end

	local var27 = var24:FindFirstChild("Countdown")
	if var23 then
		var23.Visible = var11
		local var28
		if var32 == var9 then
			var28 = var33
		else
			var28 = if var1:GetAttribute("RaceRoundId") == var9 then var1:GetAttribute("RacePlace") else nil
		end

		local var36
		if type(var28) == "number" then
			if 1 <= var28 then
				local var39 = var28 % 100
				local var40
				if 11 <= var39 and var39 <= 13 then
					var40 = "th"
				else
					if var28 % 10 == 1 then
						var40 = "st"
					else
						if var28 % 10 == 2 then
							var40 = "nd"
						else
							var40 = if var28 % 10 == 3 then "rd" else "th"
						end
					end
				end

				var36 = tostring(var28) .. var40
			else
				var36 = "\226\128\148"
			end
		else
			var36 = "\226\128\148"
		end

		var23.Text = var36
		if var28 == 1 then
			var36 = var3
		elseif var28 == 2 then
			var36 = var4
		elseif var28 == 3 then
			var36 = var5
		else
			var36 = Color3.new(1, 1, 1)
		end

		var23.TextColor3 = var36
	end

	if var25 then
		var25.Visible = var11
		var36 = math.max(0, (math.ceil(var10)))
		var25.Text = string.format("%02d:%02d", math.floor(var36 / 60), var36 % 60)
	end

	if var27 then
		var28 = nil
		var36 = nil
		if var11 then
			if var7 == "Joining" then
				var28 = tostring(var10) .. "s left"
				var36 = Color3.fromRGB(80, 220, 255)
			elseif var7 == "Staging" then
				var28 = "Race countdown"
				var36 = var3
			elseif var7 == "Countdown" then
				var28 = tostring((math.max(1, var10))) .. "!"
				var36 = Color3.fromRGB(255, 80, 55)
			else
				if var7 == "Racing" and var2 < (var31 or 0) then
					var28 = "GO!"
					var36 = Color3.fromRGB(75, 255, 95)
				end
			end
		end

		var27.Visible = var28 ~= nil
		if var28 then
			var27.Text = var28
			var27.TextColor3 = var36
			if var34 ~= var28 then
				pulse(var27)
				if var7 == "Countdown" then
					var40 = var6:FindFirstChild("Race")
					local var41 = var40
					var41 = var41 and var40:FindFirstChild("Count")
					local var42 = (3 - math.clamp(var10, 1, 3)) * 0.12 + 1
					if var41 then
						var41.PlaybackSpeed = var42 or 1
						var41.TimePosition = 0
						var6:PlayLocalSound(var41)
					end
				end
			end
		end

		var34 = var28
	end
end

var2.Remotes.Events:WaitForChild("RaceUpdate").OnClientEvent:Connect(function(arg1, arg2)
	if arg1 == "Position" then
		if type(arg2) == "table" and (type(arg2.RoundId) == "string" and (type(arg2.Sequence) == "number" and (type(arg2.Place) == "number" and (1 <= arg2.Place and (arg2.Place % 1 == 0 and (var32 ~= arg2.RoundId or (var35 or -1) < arg2.Sequence)))))) then
			var32 = arg2.RoundId
			var35 = arg2.Sequence
			var33 = arg2.Place
		end
	elseif arg1 == "LapCompleted" then
		local var2 = tostring(arg2.RoundId) .. ":" .. tostring(arg2.Lap)
		if var2 ~= var36 then
			var36 = var2
			local var3 = var24
			var20.Lap(var3 and var24:FindFirstChild("LapNumber"))
		end
	elseif arg1 == "Finish" then
		findUI()
		if var19 then
			var9.SetWindow(var19, false)
		end

		var20.Play(arg2, var25)
	elseif arg1 == "Podium" then
		announcePodium(arg2)
	elseif arg1 == "Joined" then
		var29 = arg2.RoundId
		var26 = false
		hideInvite()
		local var5 = var15:FindFirstChild("Main")
		if var5 then
			local str1 = "Index"
			for k1, v1 in { "Shop", str1, "Trails", "Sell" }, nil do
				local var6 = var5:FindFirstChild(v1)
				if not var6 then
					continue
				end

				if not var9.IsWindowOpen(var6) then
					continue
				end

				var9.SetWindow(var6, false)
			end
		end
	elseif arg1 == "JoinResponse" then
		var26 = false
		if arg2.Success then
			var29 = var14:GetAttribute("RoundId")
			hideInvite()
		else
			var12.Play("Error")
		end
	elseif arg1 == "Result" then
		var26 = false
		var20.Stop()
		task.defer(function()
			if var18 then
				renderReward({ Ready = true, Offer = var18 })
			end
		end)

	end

	updateUI()
end)

local function celebrate(arg1)
	if not arg1 or tbl3[arg1.Id] then
		return
	end

	tbl3[arg1.Id] = true
	local var1 = var15:FindFirstChild("Notifications")
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("Confetti")
	if var2 then
		var16.Play(var2)
	end

	if arg1.Kind == "Cash" then
		var17.Play()
		var12.Play("CashRegister")
	end
end

var2.Remotes.Events:WaitForChild("RaceRewardChanged").OnClientEvent:Connect(function(arg1, arg2, arg3)
	if arg2 == "Claimed" then
		var18 = nil
		if var19 then
			var9.SetWindow(var19, false)
		end

		celebrate(arg3)
		task.delay(0.2, function()
			renderReward(arg1)
		end)

		return
	end

	renderReward(arg1)
end)

local num3 = 0
game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var1 = num3 + arg1
	num3 = var1
	if num3 < 0.1 then
		return
	end

	num3 = 0
	updateUI()
end)

task.spawn(function()
	var27:FireServer("Sync")
	while true do
		if not var1.Parent then
			break
		end

		local success, result = pcall(function()
			local str1 = "Get"
			return var22:InvokeServer(str1)
		end)

		if success and (type(result) == "table" and result.Ready) then
			renderReward(result)
			return
		end

		task.wait(1)
	end
end)

updateUI()
var1.CharacterRemoving:Connect(function()
	var20.Stop()
end)

script.Destroying:Connect(function()
	var20.Stop()
end)

local tbl4 = {}
local function clearPad(arg1)
	local var2 = tbl4[arg1]
	if not var2 then
		return
	end

	tbl4[arg1] = nil
	local var3 = var2.revision + 1
	var2.revision = var3
	if var2.sound then
		var2.sound:Destroy()
		var2.sound = nil
	end

	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	for k2, v2 in var2.tweens, nil do
		v2:Cancel()
	end

	for k3, v3 in var2.parts, nil do
		if not k3.Parent then
			continue
		end

		k3.CFrame = v3.cf
		k3.Color = v3.color
		k3.Material = v3.material
	end

	for k4, v4 in var2.beams, nil do
		if not k4.Parent then
			continue
		end

		k4.Color = v4
	end
end

local function bindPad(arg1)
	if not arg1:IsA("BasePart") or (arg1:GetAttribute("RaceBoostPad") ~= true or tbl4[arg1]) then
		return
	end

	local tbl1 = { connections = {}, parts = {}, beams = {}, tweens = {}, revision = 0 }
	tbl4[arg1] = tbl1
	local function pulsePad()
		local var2 = workspace.CurrentCamera
		if not var2 or 220 < (var2.CFrame.Position - arg1.Position).Magnitude then
			return
		end

		local var4 = arg1:FindFirstChild("Surface")
		if not var4 then
			return
		end

		local var5 = var6:FindFirstChild("Other")
		local var7 = var5
		var7 = var7 and var5:FindFirstChild("Boost")
		if var7 then
			if var7:IsA("Sound") then
				if 0.18 <= os.clock() - (tbl1.lastSoundAt or -math.huge) then
					if not tbl1.sound then
						tbl1.sound = var7:Clone()
						tbl1.sound.Name = "RaceBoostSound"
						tbl1.sound.Parent = arg1
					end

					tbl1.sound.SoundId = var7.SoundId
					tbl1.sound.Volume = var7.Volume
					tbl1.sound.PlaybackSpeed = var7.PlaybackSpeed
					tbl1.sound.TimePosition = 0
					tbl1.sound:Play()
					tbl1.lastSoundAt = os.clock()
				end
			end
		end

		local var8 = tbl1
		local var9 = var8.revision + 1
		var8.revision = var9
		var8 = tbl1.revision
		for k1, v1 in tbl1.tweens, nil do
			v1:Cancel()
		end

		table.clear(tbl1.tweens)
		local var11 = table.unpack(var4:GetDescendants())
		for k2, v2 in { var4, var11 }, nil do
			if v2:IsA("BasePart") and (not tbl1.parts[v2]) then
				tbl1.parts[v2] = { cf = v2.CFrame, color = v2.Color, material = v2.Material }
			else
				if not v2:IsA("Beam") then
					continue
				end

				if tbl1.beams[v2] then
					continue
				end

				tbl1.beams[v2] = v2.Color
			end
		end

		for k3, v3 in tbl1.parts, nil do
			if not k3.Parent then
				continue
			end

			k3.Material = Enum.Material.Neon
			local var12 = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local var13 = var10:Create(k3, var12, { CFrame = v3.cf + Vector3.new(0, 0.55, 0), Color = Color3.fromRGB(150, 255, 55) })
			table.insert(tbl1.tweens, var13)
			var13:Play()
		end

		for k4 in tbl1.beams, nil do
			if not k4.Parent then
				continue
			end

			local num1 = 245
			local num2 = 255
			local num3 = 180
			k4.Color = ColorSequence.new(Color3.fromRGB(num1, num2, num3))
		end

		task.delay(0.2, function()
			if tbl4[arg1] ~= tbl1 or var8 ~= tbl1.revision then
				return
			end

			for k1, v1 in tbl1.parts, nil do
				if not k1.Parent then
					continue
				end

				local var1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				local var2 = var10:Create(k1, var1, { CFrame = v1.cf, Color = v1.color })
				table.insert(tbl1.tweens, var2)
				var2:Play()
			end

			task.delay(0.52, function()
				if tbl4[arg1] ~= tbl1 or var8 ~= tbl1.revision then
					return
				end

				for k1, v1 in tbl1.parts, nil do
					if not k1.Parent then
						continue
					end

					k1.CFrame = v1.cf
					k1.Material = v1.material
				end

				for k2, v2 in tbl1.beams, nil do
					if not k2.Parent then
						continue
					end

					k2.Color = v2
				end

				table.clear(tbl1.tweens)
			end)
		end)
	end

	table.insert(tbl1.connections, arg1:GetAttributeChangedSignal("ActivationSerial"):Connect(pulsePad))
	pulsePad = function()
		if not arg1:IsDescendantOf(workspace) then
			clearPad(arg1)
		end
	end

	table.insert(tbl1.connections, arg1.AncestryChanged:Connect(pulsePad))
end

local var37 = workspace.DescendantAdded:Connect(function(arg1)
	if arg1:IsA("BasePart") and arg1:GetAttribute("RaceBoostPad") == true then
		bindPad(arg1)
	end
end)

for k1, v1 in workspace:GetDescendants() do
	if not v1:IsA("BasePart") then
		continue
	end

	if v1:GetAttribute("RaceBoostPad") ~= true then
		continue
	end

	bindPad(v1)
end

script.Destroying:Connect(function()
	var37:Disconnect()
	local tbl1 = {}
	for k1 in tbl4, nil do
		table.insert(tbl1, k1)
	end

	for k2, v1 in tbl1, nil do
		clearPad(v1)
	end
end)

--- Players.LocalPlayer.PlayerScripts.EventBoardController [LocalScript]
-- y u r i

local var1 = game:GetService("ProximityPromptService")
local var2 = setmetatable({}, { __mode = "k" })
local var3 = game:GetService("CollectionService")
local var4 = game:GetService("SocialService")
local bool1 = false
var1.PromptShown:Connect(function(arg1)
	if var2[arg1] or (not var3:HasTag(arg1, "ExperienceEventPrompt")) then
		return
	end

	local var1 = arg1:GetAttribute("ExperienceEventId")
	if type(var1) ~= "string" then
		return
	end

	var2[arg1] = true
	local success, result = pcall(function()
		local var2 = var1
		return var4:GetEventRsvpStatusAsync(var2)
	end)

	if success then
		if not bool1 then
			if not arg1.Parent then
				return
			end

			arg1:SetAttribute("LocalRsvpStatus", result.Name)
			arg1.ActionText = if result == Enum.RsvpStatus.Going then "Manage Reminder" else "Get Notified"
		end
	end
end)

local var5 = game:GetService("Players").LocalPlayer
local num1 = 0
var1.PromptTriggered:Connect(function(arg1, arg2)
	if arg2 ~= var5 or (not var3:HasTag(arg1, "ExperienceEventPrompt")) then
		return
	end

	if bool1 or (os.clock() < num1 or (not arg1:IsDescendantOf(workspace))) then
		return
	end

	local var1 = arg1:GetAttribute("ExperienceEventId")
	if type(var1) ~= "string" or (not var1:match("^%d+$")) then
		return
	end

	bool1 = true
	num1 = os.clock() + 2
	local success, result = pcall(function()
		local var2 = var1
		return var4:PromptRsvpToEventAsync(var2)
	end)

	bool1 = false
	num1 = os.clock() + 1
	if not arg1.Parent then
		return
	end

	if success then
		if not arg1.Parent then
			return
		end

		arg1:SetAttribute("LocalRsvpStatus", result.Name)
		arg1.ActionText = if result == Enum.RsvpStatus.Going then "Manage Reminder" else "Get Notified"
		return
	end

	warn("[EventBoard] Unable to open Roblox event prompt:", result)
end)

--- Players.LocalPlayer.PlayerScripts.SettingsController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = game:GetService("ReplicatedStorage")
local str1 = "UIEffects"
local var3 = require(var2:WaitForChild("Modules"):WaitForChild(str1))
local var4 = var1:WaitForChild("PlayerGui")
local tbl1 = {
	Music = "MusicEnabled",
	RaceMusic = "RaceMusicEnabled",
	SteeringAssist = "SteeringAssistEnabled",
}

local var5 = Color3.fromRGB(45, 205, 75)
local var6 = Color3.fromRGB(230, 55, 55)
local tbl2 = {}
str1 = setmetatable({}, { __mode = "k" })
local var7 = setmetatable({}, { __mode = "k" })
local bool1 = true
local function render()
	local var2 = var4:FindFirstChild("Other")
	local var3 = var2
	var3 = var3 and var2:FindFirstChild("Settings")
	var2 = var3
	var2 = var2 and var3:FindFirstChild("Buttons")
	if not var2 then
		return
	end

	local var7 = var1:GetAttribute("SettingsReady") == true
	for k1, v1 in tbl1, nil do
		local var8 = var2:FindFirstChild(k1)
		local var9 = var8
		var9 = var9 and var8:FindFirstChild("ButtonFrame")
		if not var9 then
			continue
		end

		local var12 = var9:FindFirstChild("Text")
		local var13 = var1:GetAttribute(v1) ~= false
		local var14 = var9:FindFirstChild("Button")
		if var12 then
			var12.Text = if var13 then "On" else "Off"
		end

		var9.BackgroundColor3 = if var13 then var5 else var6
		if not var14 then
			continue
		end

		local var15 = var7
		var14.Active = var15 and (not tbl2[k1])
		var14.Selectable = var14.Active
	end
end

local var8 = var2:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SetPlayerSetting")
local var9 = require(var2.Modules.OtherSounds)
local str2 = "MusicEnabled"
local function refreshBindings()
	local var2 = var4:FindFirstChild("Other")
	local var5 = var2
	var5 = var5 and var2:FindFirstChild("Settings")
	if not var5 then
		return
	end

	if not var7[var5] then
		var7[var5] = true
		var5.Visible = false
		var5:SetAttribute("WindowEffectsManaged", true)
	end

	var2 = var4:FindFirstChild("Feedback")
	local var6 = var2
	var6 = var6 and var2:FindFirstChild("settingsbutton")
	local var10 = var6
	var10 = var10 and var6:FindFirstChild("Button")
	local function fn2()
		local var1 = var4:FindFirstChild("Other")
		local var2 = var1
		var2 = var2 and var1:FindFirstChild("Settings")
		if var2 then
			var3.SetWindow(var2, not var3.IsWindowOpen(var2))
		end
	end

	if var10 then
		if var10:IsA("GuiButton") then
	if not str1[var10] then
				str1[var10] = true
				var3.BindButton(var10)
				var10.Activated:Connect(fn2)
			end
		end
	end

	var10 = var5:FindFirstChild("Exit")
	fn2 = var10
	fn2 = fn2 and var10:FindFirstChild("Button")
	local function fn4()
		var3.SetWindow(var5, false)
	end

	local var11
	if fn2 then
		var11 = "GuiButton"
		if fn2:IsA(var11) then
	if not str1[fn2] then
				str1[fn2] = true
				var3.BindButton(fn2)
				var11 = fn4
				fn2.Activated:Connect(var11)
			end
		end
	end

	fn2 = var5:FindFirstChild("Buttons")
	for k1, v1 in tbl1, nil do
		local var12 = fn2
		var12 = var12 and fn2:FindFirstChild(k1)
		local var13 = var12
		var13 = var13 and var12:FindFirstChild("ButtonFrame")
		local var14 = var13
		var14 = var14 and var13:FindFirstChild("Button")
		if not var14 then
			continue
		end

		if not var14:IsA("GuiButton") then
			continue
		end

		local function fn6()
			if not bool1 or (tbl2[k1] or var1:GetAttribute("SettingsReady") ~= true) then
				return
			end

			tbl2[k1] = true
			render()
			local var2 = var1:GetAttribute(v1) == false
			local success, result = pcall(function()
				local var1 = k1
				local var3 = var2
				return var8:InvokeServer(var1, var3)
			end)

			tbl2[k1] = nil
			if not bool1 then
				return
			end

			if not success or (type(result) ~= "table" or (not result.Success)) then
				var9.Play("Error")
			end

			render()
		end

	if not str1[var14] then
			str1[var14] = true
			var3.BindButton(var14)
			var14.Activated:Connect(fn6)
		end
	end

	render()
end

for k1, v1 in { "SettingsReady", str2, "RaceMusicEnabled", "SteeringAssistEnabled" }, nil do
	var1:GetAttributeChangedSignal(v1):Connect(render)
end

local bool2 = false
local var10 = var4.DescendantAdded:Connect(function(arg1)
	if arg1.Name ~= "Settings" then
		if not (arg1.Name == "settingsbutton" or (arg1.Name == "Button" or (arg1.Name == "ButtonFrame" or arg1.Name == "Text"))) then
			return
		end

		if not (arg1.Name == "Button" or (arg1.Name == "ButtonFrame" or arg1.Name == "Text")) then
			return
		end

		if not (arg1.Name == "ButtonFrame" or arg1.Name == "Text") then
			return
		end

		if arg1.Name ~= "Text" then
			return
		end
	end

	if bool2 then
		return
	end

	bool2 = true
	task.defer(function()
		bool2 = false
		if bool1 then
			refreshBindings()
		end
	end)
end)

script.Destroying:Connect(function()
	bool1 = false
	var10:Disconnect()
end)

refreshBindings()

--- Players.LocalPlayer.PlayerScripts.StadiumCrowdAnimation [LocalScript]
-- y u r i

local tbl1 = {}
local var1 = game:GetService("CollectionService")
local var2 = game:GetService("RunService")
local function add(arg1)
	if arg1:IsA("BasePart") and (arg1:IsDescendantOf(workspace) and arg1:GetAttribute("CrowdBase")) then
		local tbl2 = { base = arg1:GetAttribute("CrowdBase") }
		tbl2.phase = arg1:GetAttribute("CrowdPhase") or 0
		tbl2.speed = arg1:GetAttribute("CrowdSpeed") or 3
		tbl2.height = arg1:GetAttribute("CrowdHeight") or 2
		tbl1[arg1] = tbl2
	end
end

for k1, v1 in var1:GetTagged("RaceStadiumBean") do
	add(v1)
end

var1:GetInstanceAddedSignal("RaceStadiumBean"):Connect(add)
workspace.DescendantAdded:Connect(function(arg1)
	if arg1:HasTag("RaceStadiumBean") then
		add(arg1)
	end
end)

var1:GetInstanceRemovedSignal("RaceStadiumBean"):Connect(function(arg1)
	tbl1[arg1] = nil
end)

local num1 = 0
var2.Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	if num1 < 0.033333333333333333 then
		return
	end

	num1 = 0
	var1 = workspace.CurrentCamera
	if not var1 then
		return
	end

	local var2 = workspace:GetServerTimeNow()
	local tbl2 = {}
	local tbl3 = {}
	for k1, v1 in tbl1, nil do
		if not k1:IsDescendantOf(workspace) then
			tbl1[k1] = nil
		else
			if (var1.CFrame.Position - v1.base.Position).Magnitude >= 1250 then
				continue
			end

			local var3 = var2 * v1.speed + v1.phase
			table.insert(tbl2, k1)
			table.insert(tbl3, v1.base * CFrame.new(0, math.max(0, (math.sin(var3))) * v1.height, 0) * CFrame.Angles(0, 0, math.sin(var3 * 0.7) * 0.07))
		end
	end

	if 0 < (#tbl2) then
		workspace:BulkMoveTo(tbl2, tbl3, Enum.BulkMoveMode.FireCFrameChanged)
	end
end)

--- Players.LocalPlayer.PlayerScripts.FuseController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("Players").LocalPlayer
local var2 = var1:WaitForChild("PlayerGui"):WaitForChild("Main")
local var3 = var2:WaitForChild("Fuse")
local var4 = game:GetService("ReplicatedStorage")
local var5 = var3.List
local var7 = var5:FindFirstChild("Template")
local var8 = game:GetService("RunService")
local var9 = game:GetService("TweenService")
local var10 = game:GetService("MarketplaceService")
local var11 = game:GetService("ProximityPromptService")
local var12 = game:GetService("CollectionService")
local var13 = require(var4.Configs.FuseConfig)
local var14 = require(var4.Configs.CarConfig)
local var15 = require(var4.Modules.CarAssets)
local var16 = require(var4.Modules.UIEffects)
local var17 = require(var4.Modules.OffsetListLayout)
local var18 = var4.Remotes.Functions:WaitForChild("FuseRequest")
local var19 = var4.Remotes.Events:WaitForChild("FuseUpdated")
if var7 then
	var7.Parent = nil
else
	var7 = var4.Assets:WaitForChild("FuseRowTemplate")
end

for k1, v1 in var5:GetChildren() do
	if not v1:IsA("GuiObject") then
		continue
	end

	v1:Destroy()
end

var3:SetAttribute("WindowEffectsManaged", true)
var3.Visible = false
var5:SetAttribute("OffsetListKind", "Fuse")
var5.ScrollingDirection = Enum.ScrollingDirection.Y
var5.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
var17.Bind(var5)
local num1 = 0
local function close()
	var16.SetWindow(var3, false)
end

var3.Exit.Button.Activated:Connect(close)
var16.BindButton(var3.Exit.Button)
local tbl1 = {}
local var20 = nil
local var21 = nil
local bool1 = false
local function errorRow(arg1, arg2)
	local var2 = tbl1[arg1]
	if not var2 then
		return
	end

	local var3 = (var2:GetAttribute("ErrorToken") or 0) + 1
	var2:SetAttribute("ErrorToken", var3)
	var2:SetAttribute("ErrorUntil", os.clock() + 3)
	var2.Number.Text = arg2 or "Try again"
	var2.Number.TextColor3 = Color3.fromRGB(255, 50, 50)
	var2.Fusebutton.Button.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
	local var4 = TweenInfo.new(0.5)
	var9:Create(var2.Fusebutton.Button, var4, { BackgroundColor3 = Color3.fromRGB(0, 255, 17) }):Play()
	task.delay(3, function()
		if var2.Parent and var2:GetAttribute("ErrorToken") == var3 then
			var2:SetAttribute("ErrorUntil", nil)
			var2.Number.TextColor3 = Color3.new(1, 1, 1)
			var20()
		end
	end)
end

local tbl2 = {}
local function apply(arg1)
	if type(arg1) ~= "table" or type(arg1.Tiers) ~= "table" then
		return
	end

	var21 = arg1
	local var1 = arg1.ServerTime
	num1 = (var1 or os.time()) - os.time()
	var20()
end

local function send(arg1, arg2, arg3)
	if bool1 then
		return
	end

	bool1 = true
	local success, result = pcall(function()
		local var1 = arg1
		local var2 = arg2
		local var3 = arg3
		return var18:InvokeServer(var1, var2, var3)
	end)

	bool1 = false
	if success then
		if type(result) == "table" then
			if result.State then
				local var1 = result.State
				if type(var1) == "table" then
	if type(var1.Tiers) == "table" then
						var21 = var1
						local var2 = var1.ServerTime
						num1 = (var2 or os.time()) - os.time()
						var20()
					end
				end
			end

			if not (not result.Success and arg2) then
				return
			end

			if not arg2 then
				return
			end

			errorRow(arg2, result.Reason)
			return
		end
	end

	if arg2 then
		errorRow(arg2, "Connection issue; try again")
	end
end

local function setIcon(arg1, arg2)
	arg1.Image = ""
	arg1.BackgroundTransparency = 1
	arg1.Parent.BackgroundTransparency = 1
	arg1.ScaleType = Enum.ScaleType.Fit
	arg1:SetAttribute("CarId", arg2)
	arg1.AutoButtonColor = false
	local var1 = Instance.new("TextLabel")
	var1.Name = "CarName"
	var1.BackgroundTransparency = 1
	var1.AnchorPoint = Vector2.new(0.5, 1)
	var1.Position = UDim2.fromScale(0.5, 1)
	var1.Size = UDim2.fromScale(0.98, 0.23)
	var1.Font = Enum.Font.GothamBold
	var1.TextScaled = true
	local var2 = var14.Get(arg2).DisplayName
	var2 = var2 or (var14.Get(arg2).Name or arg2)
	var1.Text = var2
	var1.TextColor3 = Color3.new(1, 1, 1)
	var1.ZIndex = arg1.ZIndex + 2
	var1.Parent = arg1
	var2 = Instance.new("UIStroke")
	var2.Thickness = 1.4
	var2.Parent = var1
	local var3 = var14.Get(arg2)
	local var4 = var3.GradientStyle
	var4 = var4 or var3.Rarity
	local var5 = var14.GetRarityInfo(var4)
	if var5.Animated then
		local var6 = Instance.new("UIGradient")
		var6.Color = var5.Gradient
		var6:SetAttribute("GradientStyle", var4)
		var6.Parent = var1
		var12:AddTag(var6, "CarRarityGradient")
	end
end

for k2, v2 in ipairs(var13.Tiers) do
	local var22 = var7:Clone()
	var22.Name = "Tier" .. k2
	var22.LayoutOrder = k2
	var22.Visible = true
	var22:SetAttribute("ListHeightRatio", 0.4)
	var22.Title.Text = "Tier " .. k2 .. " Fuse \226\128\148 " .. v2.Name
	var22.Fusebutton.BackgroundColor3 = Color3.fromRGB(0, 255, 17)
	local num2 = 1
	local var23 = math.max(num2, k2 - 1)
	var22.Locked.Text.Text = "Complete Tier " .. var23
	for k3, v3 in ipairs(v2.Ingredients) do
		local var24 = var22[tostring(k3)].Car
		setIcon(var24, v3)
		var24.Activated:Connect(function()
			send("Toggle", k2, k3)
		end)

	end

	setIcon(var22.Result.Car, v2.CarId)
	var22.Result.Car.Active = false
	var22.Fusebutton.Button.Activated:Connect(function()
		local var1 = var21
		var1 = var1 and var21.Tiers[k2]
		local var2 = send
		var2(if var1 and (0 < var1.EndsAt and var1.EndsAt <= os.time() + num1) then "Claim" else "Fuse", k2)
	end)

	var16.BindButton(var22.Fusebutton.Button)
	var22.RobuxFrame.Button.Activated:Connect(function()
		send("Skip", k2)
	end)

	local var25 = var22.RobuxFrame.Text
	var25.Text = if 0 < v2.SkipProductId then "Skip Time? \238\128\130\226\128\166" else "Skip unavailable"
	if 0 < v2.SkipProductId then
		task.spawn(function()
			for i1 = 1, 3 do
				local success, result = pcall(var10.GetProductInfo, var10, v2.SkipProductId, Enum.InfoType.Product)
				if success and (result and result.PriceInRobux) then
					var22.RobuxFrame.Text.Text = "Skip Time? \238\128\130" .. result.PriceInRobux
					return
				end

				task.wait(i1)
			end

			var22.RobuxFrame.Text.Text = "Skip \226\128\148 view price"
		end)

	end

	var22.Parent = var5
	tbl1[k2] = var22
end

local function preview(arg1)
	local str1 = "CarId"
	local var1 = var15.GetHeldTemplate(arg1:GetAttribute(str1))
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("Car")
	if not var2 then
		return
	end

	local var3 = var2:Clone()
	for k1, v1 in var3:GetDescendants() do
		if v1:IsA("Constraint") or (v1:IsA("JointInstance") or (v1:IsA("WeldConstraint") or v1:IsA("LuaSourceContainer"))) then
			v1:Destroy()
		else
			if not v1:IsA("BasePart") then
				continue
			end

			if 1 <= v1.Transparency then
				v1:Destroy()
			else
				v1.Anchored = true
				v1.CanCollide = false
			end
		end
	end

	local var4, var5 = var3:GetBoundingBox()
	local var6 = Instance.new("ViewportFrame")
	var6.Name = "FuseCarPreview"
	var6.BackgroundTransparency = 1
	var6.Size = UDim2.fromScale(1, 0.8)
	var6.ZIndex = arg1.ZIndex + 1
	var6.Ambient = Color3.fromRGB(205, 205, 220)
	var6.LightColor = Color3.new(1, 1, 1)
	var6.LightDirection = Vector3.new(-1, -1, -1)
	local var7 = Instance.new("Camera")
	var7.FieldOfView = 32
	local var8 = Vector3.new(0.8, 0.55, -1).Unit
	local var9 = CFrame.lookAt(var4.Position, var4.Position - var8)
	local var10 = math.max(0.5, arg1.AbsoluteSize.X / math.max(1, arg1.AbsoluteSize.Y * 0.8)) * 0.28674538575880792
	local num1 = 0
	for k2, v2 in var3:GetDescendants() do
		if not v2:IsA("BasePart") then
			continue
		end

		for i1 = -1, 1, 2 do
			for i2 = -1, 1, 2 do
				for i3 = -1, 1, 2 do
					local var11 = v2.Size * Vector3.new(i1, i2, i3) * 0.5
					local var12 = var9:PointToObjectSpace(v2.CFrame:PointToWorldSpace(var11))
					num1 = math.max(num1, var12.Z + math.abs(var12.X) / var10, var12.Z + math.abs(var12.Y) / 0.28674538575880792)
				end
			end
		end
	end

	var7.CFrame = CFrame.lookAt(var4.Position + var8 * num1 * 1.05, var4.Position)
	var3.Parent = var6
	var7.Parent = var6
	var6.CurrentCamera = var7
	var6.ImageColor3 = arg1.ImageColor3
	var6.Parent = arg1
	tbl2[arg1] = var6
end

var19.OnClientEvent:Connect(apply)
var11.PromptTriggered:Connect(function(arg1, arg2)
	if arg1.Name ~= "FusePrompt" or arg2 and arg2 ~= var1 then
		return
	end

	local str1 = "Sell"
	for k1, v1 in { "Trails", str1, "Shop", "Index" }, nil do
		local var4 = var2:FindFirstChild(v1)
		if not var4 then
			continue
		end

		var16.SetWindow(var4, false)
	end

	var16.SetWindow(var3, true)
end)

local function previewsVisible()
	for k1, v1 in ipairs(tbl1) do
		local var2 = var3.Visible
		if var2 then
			var2 = false
			if var5.AbsolutePosition.Y < v1.AbsolutePosition.Y + v1.AbsoluteSize.Y then
				var2 = v1.AbsolutePosition.Y < var5.AbsolutePosition.Y + var5.AbsoluteWindowSize.Y
			end
		end

		local str1 = "2"
		for k2, v2 in { "1", str1, "3", "Result" }, nil do
			local var6 = v1[v2].Car
			if var2 and (not tbl2[var6]) then
				preview(var6)
			else
				if var2 then
					continue
				end

				if not tbl2[var6] then
					continue
				end

				tbl2[var6]:Destroy()
				tbl2[var6] = nil
			end
		end
	end
end

local var26 = nil
var3:GetPropertyChangedSignal("Visible"):Connect(function()
	previewsVisible()
	if var3.Visible then
		task.spawn(send, "Get")
	end

	local var4 = var1.PlayerGui:FindFirstChild("BackpackGui")
	if var4 then
		if var3.Visible then
			var26 = var4.Enabled
			var4.Enabled = false
			return
		end

		if var26 ~= nil then
			var4.Enabled = var26
			var26 = nil
		end
	end
end)

var5:GetPropertyChangedSignal("CanvasPosition"):Connect(previewsVisible)
local var27 = var3.Size
local var28 = nil
local function fit()
	local var2 = workspace.CurrentCamera
	if var2 then
		local var4 = var3
		local var5 = if var2.ViewportSize.X < 1000 then UDim2.fromScale(0.94, 0.82) else var27
		var4.Size = var5
	end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if var28 then
		var28:Disconnect()
	end

	if workspace.CurrentCamera then
		var28 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
	end

	local var2 = workspace.CurrentCamera
	if var2 then
		local var4 = var3
		local var5 = if var2.ViewportSize.X < 1000 then UDim2.fromScale(0.94, 0.82) else var27
		var4.Size = var5
	end
end)

var20 = function()
	for k1, v1 in ipairs(tbl1) do
		local var1 = var21
		var1 = var1 and var21.Tiers[k1]
		local bool2 = false
		if var21 ~= nil then
			bool2 = true
			bool2 = k1 == 1 or var21.Tiers[k1 - 1].Claimed
		end

		local bool3 = false
		if var1 ~= nil then
			bool3 = 0 < var1.EndsAt
		end

		local var3 = bool3
		if var3 then
			var3 = false
			if os.time() + num1 < var1.EndsAt then
				var3 = not var1.Claimed
			end
		end

		local var4 = bool3
		v1.Locked.Visible = not bool2
		var4 = var4 and (not var3 and (not var1.Claimed))
		local var5 = v1.Locked.Text
		local var6 = if not var21 then "Loading..." else "Complete Tier " .. math.max(1, k1 - 1)
		var5.Text = var6
		var5 = 0
		for i1 = 1, 3 do
			local var7 = var1
			var7 = var7 and (var1.Slots[i1] or (bool3 or var1.Claimed))
			var5 = var7 and var5 + 1
			local var8 = v1[tostring(i1)].Car
			local var9 = if var7 then Color3.new(1, 1, 1) else Color3.fromRGB(65, 65, 65)
			var8.ImageColor3 = var9
			local var11 = var8:FindFirstChild("FuseCarPreview")
			if var11 then
				var11.ImageColor3 = var9
			end

			var9 = bool2
			var8 = v1[tostring(i1)].Car
			var8.Active = var9 and (not bool3 and (not var1.Claimed))
		end

		local var12 = Color3.new(1, 1, 1)
		var6 = v1.Result.Car
		var6.ImageColor3 = var12
		local var15 = var6:FindFirstChild("FuseCarPreview")
		if var15 then
			var15.ImageColor3 = var12
		end

		var6 = v1.Fusebutton.Text
		if var1 and var1.Claimed then
			var12 = "Claimed"
		elseif var3 then
			var12 = "Fusing"
		elseif var4 then
			var12 = "Claim"
		else
			var12 = "Fuse"
		end

		var6.Text = var12
		var12 = bool2
		v1.Fusebutton.Button.Active = var12 and (var1 and (not var1.Claimed and (not var3)))
		v1.RobuxFrame.Visible = var3 == true
		var12 = var3
		var6 = v1.RobuxFrame.Button
		if var12 then
			var12 = 0 < var13.Tiers[k1].SkipProductId
		end

		var6.Active = var12
		if v1:GetAttribute("ErrorUntil") then
			continue
		end

		var6 = v1.Number
		if var3 then
			var15 = math.max(0, (math.ceil(var1.EndsAt - (os.time() + num1))))
			local var17 = math.floor(var15 / 3600)
			local var18 = math.floor(var15 % 3600 / 60)
			local var19 = var15 % 60
			local str1 = "Time Left: "
			var12 = str1 .. (if 0 < var17 then var17 .. "hr " else "") .. var18 .. "m " .. var19 .. "s"
		else
			if var1 and var1.Claimed then
				var12 = "Completed!"
			elseif var4 then
				var12 = "Ready to claim!"
			else
				var12 = var5 .. "/3"
			end
		end

		var6.Text = var12
	end
end

if var28 then
	var28:Disconnect()
end

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end

local var30 = workspace.CurrentCamera
if var30 then
	local var31 = if var30.ViewportSize.X < 1000 then UDim2.fromScale(0.94, 0.82) else var27
	var3.Size = var31
end

var1.CharacterAdded:Connect(close)
var30 = 0
var8.Heartbeat:Connect(function(arg1)
	local var2 = var30 + arg1
	var30 = var2
	if var30 < 0.25 then
		return
	end

	var30 = 0
	var20()
	previewsVisible()
	if var3.Visible then
		var2 = workspace:FindFirstChild("LOBBY")
		var2 = var2 and workspace.LOBBY:FindFirstChild("FUSE MACHINE")
		local var4 = var2
		local var5 = var1.Character
		var4 = var4 and var2:FindFirstChild("FuseInteraction", true)
		var5 = var5 and var1.Character:FindFirstChild("HumanoidRootPart")
		if var4 and (var5 and 32 < (var4.Position - var5.Position).Magnitude) then
			var16.SetWindow(var3, false)
		end
	end
end)

var20()
task.spawn(function()
	for i1 = 1, 5 do
		send("Get")
		if var21 then
			return
		end

		task.wait(i1)
	end
end)

--- Players.LocalPlayer.PlayerScripts.DontLeaveController [LocalScript]
-- y u r i

local var1 = game:GetService("GuiService")
local var2 = var1.MenuIsOpen
local var3 = nil
var1.MenuOpened:Connect(function()
	var2 = true
	if var3 then
		task.spawn(var3)
	end
end)

local var4 = game:GetService("Players").LocalPlayer
local var5 = var4:WaitForChild("PlayerGui"):WaitForChild("DontLeave")
local var6 = var5:WaitForChild("root")
local var7 = var6:WaitForChild("main")
local var8 = game:GetService("ReplicatedStorage")
local var9 = game:GetService("TweenService")
local var10 = game:GetService("UserInputService")
local var11 = var7:WaitForChild("Button")
local var12 = var7:WaitForChild("Dismiss")
local var13 = var7:WaitForChild("ResponsiveScale")
local var14 = require(var8.Configs.DontLeaveGiftConfig)
local var15 = require(var8.Modules.OtherSounds)
local var16 = var8:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("DontLeaveGiftRequest")
var6.Visible = false
var6.BackgroundTransparency = 1
var5.ResetOnSpawn = false
local function fit()
	local var1 = var6.AbsoluteSize
	local var2 = math.max(0.1, (math.min(1.2, (var1.X - 32) / 420, (var1.Y - 56) / 450)))
	var13.Scale = var2
	var11.Size = UDim2.new(0.65, 0, 0, (math.max(60, 44 / var2)))
	var12.Size = UDim2.fromOffset(math.max(36, 40 / var2), (math.max(36, 40 / var2)))
end

var6:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
fit()
local var17 = nil
local var18 = nil
local bool1 = false
local bool2 = false
local bool3 = false
local function request(arg1)
	local bool1 = false
	local var1 = nil
	local bool2 = false
	task.spawn(function()
		local success, result = pcall(function()
			local var1 = arg1
			return var16:InvokeServer(var1)
		end)

		bool1 = success
		var1 = result
		bool2 = true
	end)

	local var2 = os.clock() + 8
	while not bool2 and os.clock() < var2 do
		task.wait(0.05)
	end

	if not bool2 then
		return { Success = false, Reason = "Unavailable" }
	end

	if bool1 and type(var1) == "table" then
		return var1
	end

	return { Success = false, Reason = "Unavailable" }
end

local function show()
	if bool1 or bool2 then
		return
	end

	bool1 = true
	var18 = var1.SelectedObject
	var6.Visible = true
	var6.BackgroundTransparency = 1
	var11.Text = "Claim"
	var11.Active = true
	var11.Selectable = true
	local var2 = TweenInfo.new(var14.PulseSeconds, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	var17 = var9:Create(var6, var2, { BackgroundTransparency = var14.PulseTransparency })
	var17:Play()
	var15.Play(var14.DingSound)
	if var6.Visible and (not var1.MenuIsOpen and var10:GetLastInputType().Name:find("Gamepad")) then
		var1.SelectedObject = var11
	end
end

local function focus()
	if var6.Visible and (not var1.MenuIsOpen and var10:GetLastInputType().Name:find("Gamepad")) then
		var1.SelectedObject = var11
	end
end

var1.MenuClosed:Connect(function()
	task.defer(focus)
end)

var3 = function()
	if not var2 or (bool1 or (bool2 or (bool3 or var4:GetAttribute("DataLoaded") ~= true))) then
		return
	end

	bool3 = true
	for i1 = 1, 3 do
		local var1 = request("Open")
		if var1.Success then
			if var1.Available then
				show()
				break
			end

			bool2 = true
			break
		end

		if var1.Reason == "Expired" then
			bool2 = true
			break
		end

		if i1 >= 3 then
			continue
		end

		task.wait(i1)
	end

	bool3 = false
end

var4:GetAttributeChangedSignal("DataLoaded"):Connect(function()
	if var4:GetAttribute("DataLoaded") == true then
		task.spawn(var3)
	end
end)

local bool4 = false
local function hide()
	if var17 then
		var17:Cancel()
		var17 = nil
	end

	var6.Visible = false
	var6.BackgroundTransparency = 1
	if var1.SelectedObject then
		if var1.SelectedObject:IsDescendantOf(var7) then
			local var2 = var1
			local var3 = if var18 and (var18.Parent and var18:IsDescendantOf(var4.PlayerGui)) then var18 else nil
			var2.SelectedObject = var3
		end
	end
end

var11.Activated:Connect(function()
	if bool4 or (bool2 or (not var6.Visible or var1.MenuIsOpen)) then
		return
	end

	bool4 = true
	var11.Text = "Claiming..."
	var11.Active = false
	local var2 = request("Claim")
	bool4 = false
	if var2.Success and var2.Claimed then
		bool2 = true
		var11.Text = "Claimed!"
		hide()
		return
	end

	if var2.Reason == "NotOffered" or var2.Reason == "Expired" then
		bool2 = true
		hide()
		return
	end

	var11.Text = "Try again"
	var11.Active = true
	var15.Play("Error")
end)

var12.Activated:Connect(function()
	if bool4 or var1.MenuIsOpen then
		return
	end

	bool2 = true
	hide()
end)

task.spawn(var3)

--- Players.LocalPlayer.PlayerScripts.RevueltoInviteController [LocalScript]
-- y u r i

local var1 = game:GetService("Players")
local var2 = game:GetService("SocialService")
local var3 = game:GetService("ProximityPromptService")
local var4 = game:GetService("RunService")
local var5 = game:GetService("StarterGui")
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var6 = var1.LocalPlayer
local bool1 = false
local num1 = -math.huge
var3.PromptTriggered:Connect(function(arg1, arg2)
	if arg2 and arg2 ~= var6 then
		return
	end

	local var1 = workspace:FindFirstChild("PodiumRevuelto")
	local var3 = var1
	var3 = var3 and var1:FindFirstChild("Revuelto")
	if not var3 or (arg1.Name ~= "RevueltoInvitePrompt" or (not arg1:IsDescendantOf(var3))) then
		return
	end

	if bool1 or os.clock() - num1 < 5 then
		return
	end

	bool1 = true
	num1 = os.clock()
	task.delay(15, function()
		bool1 = false
	end)

	local success, result = pcall(function()
		local var1 = var6
		return var2:CanSendGameInviteAsync(var1)
	end)

	if not success or (not result) then
		bool1 = false
		local str1 = "Invites aren't available right now. Please try again in the published game."
		task.spawn(function()
			for i1 = 1, 3 do
				if pcall(function()
					var5:SetCore("SendNotification", { Title = "Invite Reward", Text = str1, Duration = 6 })
				end) then

					return
				end

				task.wait(1)
			end
		end)

		return
	end

	local var4 = Instance.new("ExperienceInviteOptions")
	var4.PromptMessage = "Earn a Legendary Revuelto when an invited friend joins! One per player."
	var4:Destroy()
	local var7 = pcall(function()
		var2:PromptGameInvite(var6, var4)
	end)

	bool1 = false
	if not var7 then
		local str3 = "Couldn't open invites. Please try again."
		task.spawn(function()
			for i1 = 1, 3 do
				if pcall(function()
					var5:SetCore("SendNotification", { Title = "Invite Reward", Text = str3, Duration = 6 })
				end) then

					return
				end

				task.wait(1)
			end
		end)

	end
end)

game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("CoreFeedback").OnClientEvent:Connect(function(arg1)
	if type(arg1) == "table" and arg1.Kind == "RevueltoInvite" then
		local var2 = arg1.Message
		task.spawn(function()
			for i1 = 1, 3 do
				if pcall(function()
					var5:SetCore("SendNotification", { Title = "Invite Reward", Text = var2, Duration = 6 })
				end) then

					return
				end

				task.wait(1)
			end
		end)

	end
end)

local var7 = nil
local var8 = nil
local var9 = workspace:FindFirstChild("PodiumRevuelto")
local var10 = var9
var10 = var10 and var9:FindFirstChild("Revuelto")
local var11 = var10
var7 = var10
var8 = var11 and var10:GetAttribute("PodiumBasePivot")
var9 = 0
local num2 = 0
var4.RenderStepped:Connect(function(arg1)
	local var1 = var9 + arg1
	var9 = var1
	if 1 <= var9 then
		var9 = 0
		var1 = workspace:FindFirstChild("PodiumRevuelto")
		local var2 = var1
		var2 = var2 and var1:FindFirstChild("Revuelto")
		var7 = var2
		local var3 = var2
		var3 = var3 and var2:GetAttribute("PodiumBasePivot")
		var8 = var3
	end

	if not var7 or (not var7.Parent or typeof(var8) ~= "CFrame") then
		return
	end

	var1 = (num2 + arg1) % 24
	num2 = var1
	var7:PivotTo(CFrame.new(var8.Position) * CFrame.Angles(0, math.rad(num2 * 15), 0) * var8.Rotation)
end)

--- Players.LocalPlayer.PlayerScripts.OceanRaceController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local tbl1 = {}
local var1 = nil
local var2 = nil
local var3 = nil
local function add(arg1)
	local var2 = arg1:GetAttribute("OceanMotion")
	local var3 = arg1:GetAttribute("MotionBase")
	if not var2 or (typeof(var3) ~= "CFrame" or not arg1:IsA("Model") and (not arg1:IsA("BasePart"))) then
		return
	end

	local tbl2 = { Kind = var2, Base = var3, Phase = arg1:GetAttribute("Phase") or 0 }
	tbl2.Bob = arg1:GetAttribute("BobHeight") or 2
	tbl2.Axis = arg1:GetAttribute("MotionAxis")
	tbl2.Forward = arg1:GetAttribute("MotionForward")
	tbl2.Amplitude = arg1:GetAttribute("SwimAmplitude") or 82
	tbl2.Rate = arg1:GetAttribute("SwimRate") or 0.22
	tbl1[arg1] = tbl2
end

local num1 = 0
local num2 = 0
local function bind(arg1)
	if var1 then
		var1:Disconnect()
		var1 = nil
	end

	if var2 then
		var2:Disconnect()
		var2 = nil
	end

	table.clear(tbl1)
	var3 = arg1
	if not var3 then
		return
	end

	for k1, v1 in var3:GetDescendants() do
		add(v1)
	end

	var1 = var3.DescendantAdded:Connect(add)
	var2 = var3.DescendantRemoving:Connect(function(arg1)
		tbl1[arg1] = nil
	end)
end

local var4 = game:GetService("Players").LocalPlayer
game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	var1 = num2 + arg1
	num2 = var1
	if 0.3 < num2 then
		num2 = 0
		var1 = workspace:FindFirstChild("ActiveRaceTrack")
		if var1 then
			if var1:GetAttribute("OceanTheme") ~= true then
				var1 = nil
			end
		end

		if var1 ~= var3 then
			bind(var1)
		end
	end

	if num1 < 0.033333333333333333 then
		return
	end

	num1 = 0
	var1 = workspace.CurrentCamera
	if not var3 or (not var1) then
		return
	end

	local var2 = var3:FindFirstChild("StartPositions")
	local var5 = var2
	local var6 = var4.Character
	local var7 = var6
	var5 = var5 and var2:FindFirstChild("1")
	local var9 = var5
	var7 = var7 and var6:FindFirstChild("HumanoidRootPart")
	if var9 then
		var9 = (var1.CFrame.Position - var5.Position).Magnitude < 1600
	end

	if var7 then
		if var5 then
		end
	end

	if not var9 then
		return
	end

	local var10 = workspace:GetServerTimeNow()
	for k1, v1 in pairs(tbl1) do
		if not k1:IsDescendantOf(var3) then
			tbl1[k1] = nil
		else
			local var12 = nil
			if v1.Kind == "Jellyfish" then
				local var13 = var10 * 0.65 + v1.Phase
				var12 = (v1.Base + Vector3.new(math.sin(var13 * 0.67) * 1.5, math.sin(var13) * v1.Bob, 0)) * CFrame.Angles(math.sin(var13 * 0.8) * 0.035, math.sin(var13 * 0.4) * 0.12, math.cos(var13) * 0.04)
			else
				if v1.Kind == "FishSchool" and (v1.Axis and v1.Forward) then
					local var14 = var10 * v1.Rate + v1.Phase
					local var15 = v1.Base.Position + v1.Axis * (math.sin(var14) * v1.Amplitude) + v1.Forward * (math.cos(var14) * 13) + Vector3.new(0, math.sin(var14 * 2) * 2, 0)
					var12 = CFrame.lookAt(var15, var15 + (v1.Axis * (math.cos(var14) * v1.Amplitude) - v1.Forward * (math.sin(var14) * 13) + Vector3.new(0, math.cos(var14 * 2) * 4, 0)))
				else
					if v1.Kind == "Bubble" and k1:IsA("BasePart") then
						local var16 = (var10 * 0.065 + v1.Phase) % 1
						var12 = v1.Base + Vector3.new(math.sin(var10 + v1.Phase) * 1.5, var16 * 80, math.cos(var10 * 0.7 + v1.Phase) * 1.5)
						k1.Transparency = math.max(0, (var16 - 0.8) / 0.2, 1 - var16 / 0.1) * 0.5 + 0.5
					end
				end
			end

			if not var12 then
				continue
			end

			k1:PivotTo(var12)
		end
	end
end)

script.Destroying:Connect(function()
	bind(nil)
end)

--- Players.LocalPlayer.PlayerScripts.RaceBurnoutController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local str1 = "RaceBurnoutEffects"
local var2 = require(var1:WaitForChild("Modules"):WaitForChild(str1))
str1 = 0
local var3 = var1:WaitForChild("RaceState")
local tbl1 = {}
game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var1 = str1 + arg1
	str1 = var1
	if str1 < 0.033333333333333333 then
		return
	end

	var1 = str1
	str1 = 0
	local var6 = workspace:FindFirstChild("LiveRaceCars")
	local var7 = workspace.CurrentCamera
	local tbl2 = {}
	local var8
	local var9
	if var6 and (var7 and var3:GetAttribute("Phase") == "Countdown") then
		for k1, v1 in var6:GetChildren() do
			local var10 = v1:FindFirstChild("Chassis")
			if not var10 then
				continue
			end

			if not var10.Anchored then
				continue
			end

			if v1:GetAttribute("RaceVehicle") ~= true then
				continue
			end

			if v1:GetAttribute("RaceLocked") ~= true then
				continue
			end

			if v1:GetAttribute("RaceRoundId") ~= var3:GetAttribute("RoundId") then
				continue
			end

			if v1:GetAttribute("RaceBurnout") ~= true then
				continue
			end

			if (var7.CFrame.Position - var10.Position).Magnitude >= 250 then
				continue
			end

			tbl2[v1] = true
			if tbl1[v1] then
				continue
			end

			tbl1[v1] = var2.Start(v1)
		end
	end

	for k2, v2 in pairs(tbl1) do
		if not tbl2[k2] or v2.Folder.Parent ~= var7 then
			var2.Stop(v2)
			tbl1[k2] = nil
		else
			var2.Step(v2, var1)
		end
	end
end)

script.Destroying:Connect(function()
	for k1, v1 in pairs(tbl1) do
		var2.Stop(v1)
	end

	table.clear(tbl1)
end)

--- Players.LocalPlayer.PlayerScripts.SnowRaceController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = Instance.new("ColorCorrectionEffect")
var1.Name = "FrostpeakSnowTint"
var1.TintColor = Color3.fromRGB(224, 241, 255)
var1.Saturation = -0.03
var1.Brightness = 0.015
var1.Enabled = false
local var2 = Instance.new("Part")
var2.Name = "LocalFrostpeakSnow"
var2.Size = Vector3.new(110, 0.1, 110)
var2.Transparency = 1
var2.Anchored = true
var2.CanCollide = false
var2.CanTouch = false
var2.CanQuery = false
var2.CastShadow = false
local var3 = Instance.new("ParticleEmitter")
var3.Name = "GentleSnowfall"
var3.Texture = "rbxasset://textures/particles/sparkles_main.dds"
var3.Rate = 100
var3.Lifetime = NumberRange.new(1.8, 2.8)
var3.Speed = NumberRange.new(14, 20)
var3.EmissionDirection = Enum.NormalId.Bottom
var3.Size = NumberSequence.new(0.28)
local num1 = 1
local num2 = 1
var3.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.1, 0.25),
	NumberSequenceKeypoint.new(0.8, 0.25),
	NumberSequenceKeypoint.new(num1, num2),
})

local num3 = 227
local num4 = 247
local num5 = 255
var3.Color = ColorSequence.new(Color3.fromRGB(num3, num4, num5))
var3.LightEmission = 0.35
var3.Rotation = NumberRange.new(0, 360)
var3.RotSpeed = NumberRange.new(-40, 40)
var3.Acceleration = Vector3.new(1, -3, 1)
var3.SpreadAngle = Vector2.new(10, 10)
var3.Enabled = false
var3.Parent = var2
local num6 = 0
local var4 = game.Players.LocalPlayer
game.RunService.Heartbeat:Connect(function(arg1)
	local var5 = num6 + arg1
	num6 = var5
	if num6 < 0.05 then
		return
	end

	num6 = 0
	var5 = workspace.CurrentCamera
	var1.Parent = var5
	var2.Parent = var5
	local var6 = workspace:FindFirstChild("ActiveRaceTrack")
	local var8 = var6
	if var8 then
		var8 = false
		if var6:GetAttribute("SnowTheme") == true then
			var8 = var6:FindFirstChild("StartPositions")
		end
	end

	local var9 = var8
	local var10 = var4.Character
	local var12 = var5
	var9 = var9 and var8:FindFirstChild("1")
	var10 = var10 and var4.Character:FindFirstChild("HumanoidRootPart")
	if var12 then
		var12 = var9
		if var12 then
			var12 = var10
			if var12 then
				var12 = false
				if (var10.Position - var9.Position).Magnitude < 1700 then
					var12 = (var5.CFrame.Position - var9.Position).Magnitude < 1700
				end
			end
		end
	end

	var1.Enabled = var12 == true
	var3.Enabled = var12 == true
	if var12 then
		var2.CFrame = CFrame.new(var5.CFrame.Position + Vector3.new(var5.CFrame.LookVector.X, 0, var5.CFrame.LookVector.Z) * 35 + Vector3.new(0, 30, 0))
		return
	end

	var3:Clear()
end)

script.Destroying:Connect(function()
	var2:Destroy()
	var1:Destroy()
end)

--- Players.LocalPlayer.PlayerScripts.MinotaurChaseAnimation [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local str1 = "MinotaurAnimator"
local tbl1 = {}
local tbl2 = {}
local var1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild(str1))
local var2 = game:GetService("CollectionService")
var2:GetInstanceAddedSignal("MinotaurChaser"):Connect(function(arg1)
	if not arg1:IsA("Model") or arg1:GetAttribute("AnimationRig") ~= "Minotaur" then
		return
	end

	tbl2[arg1] = true
end)

var2:GetInstanceRemovedSignal("MinotaurChaser"):Connect(function(arg1)
	local var2 = tbl1[arg1]
	if var2 then
		var2:Reset()
	end

	tbl1[arg1] = nil
	tbl2[arg1] = nil
end)

local var3 = game:GetService("RunService")
for k1, v1 in var2:GetTagged("MinotaurChaser") do
	if not v1:IsA("Model") then
		continue
	end

if v1:GetAttribute("AnimationRig") == "Minotaur" then
		tbl2[v1] = true
	end
end

local num1 = 0
var3.PreSimulation:Connect(function(arg1)
	local var2
	if num1 <= os.clock() then
		num1 = os.clock() + 1
		for k1 in tbl2, nil do
			if not k1:IsDescendantOf(workspace) then
				var2 = tbl1[k1]
				if var2 then
					var2:Reset()
				end

				tbl1[k1] = nil
				tbl2[k1] = nil
			else
				var2 = var1.new(k1)
				if not var2 then
					continue
				end

				tbl1[k1] = var2
				tbl2[k1] = nil
			end
		end
	end

	local var3 = workspace.CurrentCamera
	for k2, v1 in tbl1, nil do
		local var6 = k2.PrimaryPart
		if k2:IsDescendantOf(workspace) then
			if not var6 then
				local var9 = tbl1[k2]
				if var9 then
					var9:Reset()
				end

				tbl1[k2] = nil
				tbl2[k2] = nil
			elseif var3 then
				if (var6.Position - var3.CFrame.Position).Magnitude >= 650 then
					continue
				end
			end
		end
	end
end)

--- Players.LocalPlayer.PlayerScripts.PlotLadderController [LocalScript]
-- y u r i

local var1 = require(game:GetService("ReplicatedStorage").Configs.PlotConfig)
local var2 = game:GetService("Players").LocalPlayer
local var3 = nil
local function nearLadder(arg1, arg2)
	local var3 = workspace:FindFirstChild("Plots")
	if not var3 then
		return false
	end

	for k1, v1 in var3:GetChildren() do
		if not var1.IsPlayablePlot(v1) then
			continue
		end

		if var1.SecondFloorLevel > (v1:GetAttribute("Level") or 0) then
			continue
		end

		local var4 = v1:FindFirstChild("Build")
		local var5 = var4
		local var6 = v1:FindFirstChild("Ladder")
		local var7 = v1:FindFirstChild("SecondFloor")
		var5 = var5 and var4:FindFirstChild("Bottom")
		if not var6 or (not var7) or (not var5) then
			continue
		end

		if var6:GetAttribute("ManagedPlotFloor") ~= true then
			continue
		end

		local str1 = "FloorOffset"
		if arg2 or arg1.Y < var5.Position.Y + var5.Size.Y / 2 + (var7:GetAttribute(str1) or 0) + 1 then
			for k2, v2 in var6:GetChildren() do
				if not v2:IsA("TrussPart") then
					continue
				end

				if not v2.CanCollide then
					continue
				end

				local var8 = v2.CFrame:PointToObjectSpace(arg1)
				if math.abs(var8.X) > v2.Size.X / 2 + 5 then
					continue
				end

				if math.abs(var8.Z) > v2.Size.Z / 2 + 3 then
					continue
				end

				if math.abs(var8.Y) > v2.Size.Y / 2 + 4 then
					continue
				end

				return true
			end
		end
	end

	return false
end

game:GetService("RunService").PreSimulation:Connect(function(arg1)
	local var1 = var2.Character
	local var4 = var1
	local var5 = var1
	var4 = var4 and var1:FindFirstChildOfClass("Humanoid")
	var5 = var5 and var1:FindFirstChild("HumanoidRootPart")
	if not var4 or (not var5 or var4.Health <= 0) then
		var3 = nil
		return
	end

	local str1 = "EffectiveSpeed"
	local var6 = tonumber(var2:GetAttribute(str1))
	var6 = var6 or var4.WalkSpeed
	str1 = not var4.SeatPart
	local var7 = var4:GetState() == Enum.HumanoidStateType.Climbing
	if str1 and (not var2:GetAttribute("RaceParticipant") and (nearLadder(var5.Position, var7) or nearLadder(var5.Position + var4.MoveDirection * var6 * math.min(arg1, 0.1), var7))) then
		var3 = var4
		var4.WalkSpeed = math.min(var6, 28)
		local var8 = var5.AssemblyLinearVelocity
		local var9 = math.min(var6, 28) * 0.7
		if not (var7 and var9 < var8.Y) then
			return
		end

		var8 = var5.AssemblyLinearVelocity
		var9 = math.min(var6, 28) * 0.7
		if var9 >= var8.Y then
			return
		end

		var5.AssemblyLinearVelocity = Vector3.new(var8.X, var9, var8.Z)
		return
	end

	if var3 then
		if var3 == var4 then
			var4.WalkSpeed = var6
		end

		var3 = nil
	end
end)

--- Players.LocalPlayer.PlayerScripts.Ferrari458Controller [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = require(var1.Configs.Ferrari458Config)
local var3 = game:GetService("RunService")
local var4 = game:GetService("MarketplaceService")
local var5 = game:GetService("StarterGui")
local var6 = game:GetService("Players").LocalPlayer
local var7 = nil
local var8 = nil
local var9 = nil
local var10 = nil
local var11 = nil
local tbl1 = {}
local tbl2 = {}
local tbl3 = {}
local var12 = if 0 < var2.ProductId then "BUY WITH ROBUX" else "COMING SOON"
local function refresh()
	var7 = workspace:FindFirstChild(var2.PodiumName)
	local var1 = var7
	var1 = var1 and var7:FindFirstChild(var2.CarId)
	var8 = var1
	var1 = var8
	var1 = var1 and var8:GetAttribute("PodiumBasePivot")
	var9 = var1
	table.clear(tbl1)
	table.clear(tbl2)
	table.clear(tbl3)
	if var8 then
		for k1, v1 in var8:GetDescendants() do
			local var3 = v1:IsA("BasePart")
			var3 = var3 and v1:GetAttribute("PodiumLocalCFrame")
			if typeof(var3) ~= "CFrame" then
				continue
			end

			table.insert(tbl1, v1)
			table.insert(tbl2, var3)
		end
	end

	var1 = var7
	var1 = var1 and var7:FindFirstChild(var2.PromptName, true)
	var10 = var1
	var1 = var7
	var1 = var1 and var7:FindFirstChild("PurchaseStatus", true)
	var11 = var1
	var1 = var6:GetAttribute(var2.OwnedAttribute) == true
	local var4 = var6:GetAttribute(var2.PendingAttribute) == true
	if var11 then
		local var5 = var11
		local var13
		if var1 then
			var13 = "OWNED"
		elseif var4 then
			var13 = "PURCHASE PENDING..."
		else
			var13 = var12
		end

		var5.Text = var13
	end

	if var10 then
		local var14 = not var1
		var10:SetAttribute("PromptAvailable", var14 and (not var4))
		var13 = not var1
		var10.Enabled = var13 and (not var4)
		local var15 = var10
		var15.ActionText = if 0 < var2.ProductId then var12 else "Coming Soon"
	end
end

var6:GetAttributeChangedSignal(var2.OwnedAttribute):Connect(refresh)
var6:GetAttributeChangedSignal(var2.PendingAttribute):Connect(refresh)
refresh()
if 0 < var2.ProductId then
	task.spawn(function()
		for i1 = 1, 4 do
			local success, result = pcall(function()
				local var1 = var2.ProductId
				local var3 = Enum.InfoType.Product
				return var4:GetProductInfo(var1, var3)
			end)

			if success and (type(result) == "table" and tonumber(result.PriceInRobux)) then
				var12 = utf8.char(57346) .. " " .. tostring(result.PriceInRobux) .. " \226\128\162 BUY ONCE"
				refresh()
				return
			end

			task.wait(i1 * 3)
		end
	end)

end

var1.Remotes.Events.CoreFeedback.OnClientEvent:Connect(function(arg1)
	if type(arg1) == "table" and arg1.Kind == "Ferrari458" then
		pcall(function()
			var5:SetCore("SendNotification", { Title = "Ferrari 458", Text = arg1.Message, Duration = 6 })
		end)

	end
end)

local num1 = 0
local num2 = 0
var3.RenderStepped:Connect(function(arg1)
	local var1 = (num1 + arg1) % (360 / var2.RotationDegreesPerSecond)
	num1 = var1
	var1 = num2 + arg1
	num2 = var1
	if 1 <= num2 then
		num2 = 0
		refresh()
	end

	if var8 and (var8.Parent and typeof(var9) == "CFrame") then
		local var3 = math.rad(num1 * var2.RotationDegreesPerSecond)
		local num3 = 0
		var1 = CFrame.new(var9.Position) * CFrame.Angles(0, var3, num3) * var9.Rotation
		local bool1 = true
		for k1, v1 in tbl1, nil do
			if not v1:IsDescendantOf(var8) then
				bool1 = false
				break
			end

			tbl3[k1] = var1 * tbl2[k1]
		end

		if bool1 and 0 < (#tbl1) then
			workspace:BulkMoveTo(tbl1, tbl3, Enum.BulkMoveMode.FireCFrameChanged)
		end
	end
end)

--- Players.LocalPlayer.PlayerScripts.TreadmillClickController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = var1.Remotes.Functions
local var3 = game:GetService("Players").LocalPlayer
local var4 = var3:WaitForChild("PlayerGui"):WaitForChild("Treadmill"):WaitForChild("root")
local var5 = game:GetService("TweenService")
local var6 = game:GetService("RunService")
local var7 = game:GetService("UserInputService")
local var8 = game:GetService("GuiService")
local var9 = game:GetService("SoundService")
local var10 = require(var1.Configs.TreadmillClickConfig)
local var11 = var2:WaitForChild("ClaimTreadmillBonus")
local var12 = var2:WaitForChild("BuyTreadmillClickBoost")
local var13 = var4:WaitForChild("Template")
local var14 = Random.new()
var13.Visible = false
local tbl1 = {}
local function CreateTarget(arg1)
	local var1 = var13:Clone()
	var1.Name = if arg1 then "PaidBonusTarget" else "BonusTarget"
	var1.Visible = false
	var1.AnchorPoint = Vector2.new(0.5, 0.5)
	var1:SetAttribute("WindowEffectsManaged", true)
	local var2 = var1:WaitForChild("Button")
	var2:SetAttribute("UIEffectsIgnore", true)
	var2.Interactable = false
	local var3 = var1:FindFirstChildOfClass("UIScale")
	var3 = var3 or Instance.new("UIScale", var1)
	local tbl1 = {
		Paid = arg1,
		Frame = var1,
		Button = var2,
		Label = var1:WaitForChild("Text"),
		U = 0.5,
		V = 0.5,
	}

	tbl1.Scale = var3
	tbl1.BaseScale = math.max(0.1, var3.Scale)
	tbl1.Prefix = if arg1 then "TreadmillPaidOffer" else "TreadmillBonusOffer"
	tbl1.Remote = arg1 and var12 or var11
	if arg1 then
		tbl1.Label.Text = "20x"
		local var6 = var1:FindFirstChildOfClass("UIGradient")
		if var6 then
			local num4 = 255
			local num5 = 135
			local num6 = 30
			var6.Color = ColorSequence.new(Color3.fromRGB(255, 225, 60), Color3.fromRGB(num4, num5, num6))
		end
	end

	var1.Parent = var4
	return tbl1
end

local tbl2 = { Free = CreateTarget(false) }
tbl2.Paid = CreateTarget(true)
local function RefreshTarget(arg1, arg2)
	local var1 = var3:GetAttribute(arg1.Prefix .. "Id")
	local var2 = var3:GetAttribute(arg1.Prefix .. "Until")
	if not arg2 or (type(var1) ~= "string" or (type(var2) ~= "number" or (var2 <= workspace:GetServerTimeNow() or (var1 == arg1.ClickedToken or arg1.Paid and (var10.Paid.ProductId <= 0 or var3:GetAttribute("TreadmillClickPurchasePending")))))) then
		arg1.Token = nil
		local var4 = arg1.Frame.Visible
		if arg1.Pulse then
			arg1.Pulse:Cancel()
			arg1.Pulse = nil
		end

		arg1.Scale.Scale = arg1.BaseScale
		if var8.SelectedObject == arg1.Button then
			var8.SelectedObject = nil
		end

		arg1.Frame.Visible = false
		arg1.Button.Interactable = false
		arg1.Button.Selectable = false
		return var4
	end

	if not arg1.Paid then
		arg1.Label.Text = tostring(var3:GetAttribute("TreadmillBonusOfferMultiplier") or 2) .. "x"
	end

	local var9 = var1 ~= arg1.Token
	if var9 then
		local var11 = arg1.Frame.Visible
		if arg1.Pulse then
			arg1.Pulse:Cancel()
			arg1.Pulse = nil
		end

		arg1.Scale.Scale = arg1.BaseScale
		if var8.SelectedObject == arg1.Button then
			var8.SelectedObject = nil
		end

		arg1.Frame.Visible = false
		arg1.Button.Interactable = false
		arg1.Button.Selectable = false
		arg1.Token = var1
		var11 = var14:NextNumber()
		arg1.U = var11
		local var12 = var14:NextNumber()
		arg1.V = var12
		arg1.Frame.Visible = true
		local var13 = TweenInfo.new(var10.PulseSeconds, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
		arg1.Pulse = var5:Create(arg1.Scale, var13, { Scale = arg1.BaseScale * var10.PulseScale })
		arg1.Pulse:Play()
		if var7:GetLastInputType().Name:find("Gamepad") and var8.SelectedObject == nil then
			var8.SelectedObject = arg1.Button
		end
	end

	arg1.Button.Interactable = not arg1.Busy
	arg1.Button.Selectable = not arg1.Busy
	return var9
end

local function Place(arg1)
	local var1 = var4.AbsoluteSize
	if var1.X <= 0 or var1.Y <= 0 then
		return
	end

	local var2 = tbl2.Free.Frame.Visible
	var2 = var2 and tbl2.Paid.Frame.Visible
	local var3 = math.max(64, var1.X * var13.Size.X.Scale + var13.Size.X.Offset)
	local var5 = var1.X
	local var6 = var5 * (if var2 then 0.28 else 0.65)
	local var7 = math.min(var3, var6 / arg1.BaseScale)
	var3 = math.min(math.max(64, var1.Y * var13.Size.Y.Scale + var13.Size.Y.Offset), var1.Y * 0.58 / arg1.BaseScale)
	arg1.Frame.Size = UDim2.fromOffset(var7, var3)
	local var8 = math.min(0.49, (var7 * arg1.BaseScale * var10.PulseScale * 0.7 + 6) / var1.X)
	var6 = math.min(0.49, (var3 * arg1.BaseScale * var10.PulseScale * 0.78 + 6) / var1.Y)
	arg1.Frame.Position = UDim2.fromScale(var8 + (1 - var8 * 2) * (var2 and (arg1.Paid and 0.85 + arg1.U * 0.15) or (arg1.U * 0.15 or arg1.U)), var6 + (1 - var6 * 2) * arg1.V)
end

local var15 = nil
local var16 = nil
local function Refresh()
	local var1 = var3.Character
	local var2 = var1
	local bool2 = false
	var2 = var2 and var1:FindFirstChildOfClass("Humanoid")
	if var3:GetAttribute("TrainingTier") ~= nil then
		bool2 = false
		if var1 ~= nil then
			bool2 = false
			if var1:GetAttribute("TrainingTreadmill") == true then
				bool2 = var2
				if bool2 then
					bool2 = 0 < var2.Health
				end
			end
		end
	end

	local var5 = bool2 == true
	var4.Visible = var5
	if RefreshTarget(tbl2.Free, var5) or RefreshTarget(tbl2.Paid, var5) then
		Place(tbl2.Free)
		Place(tbl2.Paid)
	end
end

for k1, v1 in tbl2, nil do
	table.insert(tbl1, (v1.Button.Activated:Connect(function()
		if not v1.Busy then
			if v1.Token then
				local var7 = var3.Character
				local var10 = var7
				local bool4 = false
				var10 = var10 and var7:FindFirstChildOfClass("Humanoid")
				if var3:GetAttribute("TrainingTier") ~= nil then
					bool4 = false
					if var7 ~= nil then
						bool4 = false
						if var7:GetAttribute("TrainingTreadmill") == true then
							bool4 = var10
							if bool4 then
								bool4 = 0 < var10.Health
							end
						end
					end
				end

				if not bool4 then
					return
				end
			end
		end

		local var11 = v1.Token
		v1.ClickedToken = var11
		v1.Busy = true
		local var12 = v1
		local var13 = var3.Character
		local var14 = var12.Frame.Visible
		if var12.Pulse then
			var12.Pulse:Cancel()
			var12.Pulse = nil
		end

		var12.Scale.Scale = var12.BaseScale
		if var8.SelectedObject == var12.Button then
			var8.SelectedObject = nil
		end

		var12.Frame.Visible = false
		var12.Button.Interactable = false
		var12.Button.Selectable = false
		local success, result = pcall(function()
			local var1 = var11
			return v1.Remote:InvokeServer(var1)
		end)

		v1.Busy = false
		if success then
			if type(result) == "table" then
				if result.Success then
					if not v1.Paid then
						local var27 = var9:FindFirstChild("Other")
						local var28 = var27
						var28 = var28 and var27:FindFirstChild("TreadmillClick")
						if var28 then
							if var28:IsA("Sound") then
								if var3.Character == var13 then
									local var35 = var3.Character
									local var36 = var35
									local bool12 = false
									var36 = var36 and var35:FindFirstChildOfClass("Humanoid")
									if var3:GetAttribute("TrainingTier") ~= nil then
										bool12 = false
										if var35 ~= nil then
											bool12 = false
											if var35:GetAttribute("TrainingTreadmill") == true then
												bool12 = var36
												if bool12 then
													bool12 = 0 < var36.Health
												end
											end
										end
									end

									if bool12 then
										var28.TimePosition = 0
										var9:PlayLocalSound(var28)
									end
								end
							end
						end
					end
				else
					v1.ClickedToken = nil
				end
			else
				v1.ClickedToken = nil
			end
		else
			v1.ClickedToken = nil
		end

		local var37 = var3.Character
		local var38 = var37
		local bool14 = false
		var38 = var38 and var37:FindFirstChildOfClass("Humanoid")
		if var3:GetAttribute("TrainingTier") ~= nil then
			bool14 = false
			if var37 ~= nil then
				bool14 = false
				if var37:GetAttribute("TrainingTreadmill") == true then
					bool14 = var38
					if bool14 then
						bool14 = 0 < var38.Health
					end
				end
			end
		end

		local var39 = bool14 == true
		var4.Visible = var39
		if RefreshTarget(tbl2.Free, var39) or RefreshTarget(tbl2.Paid, var39) then
			Place(tbl2.Free)
			Place(tbl2.Paid)
		end
	end)))

end

local str1 = "TreadmillBonusOfferId"
for k2, v2 in {
	"TrainingTier",
	str1,
	"TreadmillBonusOfferUntil",
	"TreadmillBonusOfferMultiplier",
	"TreadmillPaidOfferId",
	"TreadmillPaidOfferUntil",
	"TreadmillClickPurchasePending",
}, nil do

	table.insert(tbl1, (var3:GetAttributeChangedSignal(v2):Connect(Refresh)))
end

table.insert(tbl1, (var4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	Place(tbl2.Free)
	Place(tbl2.Paid)
end)))

local function BindCharacter(arg1)
	if var15 then
		var15:Disconnect()
		var15 = nil
	end

	if var16 then
		var16:Disconnect()
		var16 = nil
	end

	var15 = arg1:GetAttributeChangedSignal("TrainingTreadmill"):Connect(Refresh)
	task.spawn(function()
		local var2 = arg1:WaitForChild("Humanoid", 10)
		if var2 and var3.Character == arg1 then
			var16 = var2.Died:Connect(Refresh)
			local var5 = var3.Character
			local var6 = var5
			local bool2 = false
			var6 = var6 and var5:FindFirstChildOfClass("Humanoid")
			if var3:GetAttribute("TrainingTier") ~= nil then
				bool2 = false
				if var5 ~= nil then
					bool2 = false
					if var5:GetAttribute("TrainingTreadmill") == true then
						bool2 = var6
						if bool2 then
							bool2 = 0 < var6.Health
						end
					end
				end
			end

			local var7 = bool2 == true
			var4.Visible = var7
			if RefreshTarget(tbl2.Free, var7) or RefreshTarget(tbl2.Paid, var7) then
				Place(tbl2.Free)
				Place(tbl2.Paid)
			end
		end
	end)
end

table.insert(tbl1, (var3.CharacterAdded:Connect(BindCharacter)))
table.insert(tbl1, (var3.CharacterRemoving:Connect(function()
	var4.Visible = false
	for k1, v1 in tbl2, nil do
		local var1 = v1.Frame.Visible
		if v1.Pulse then
			v1.Pulse:Cancel()
			v1.Pulse = nil
		end

		v1.Scale.Scale = v1.BaseScale
		if var8.SelectedObject == v1.Button then
			var8.SelectedObject = nil
		end

		v1.Frame.Visible = false
		v1.Button.Interactable = false
		v1.Button.Selectable = false
		v1.Token = nil
		v1.ClickedToken = nil
	end
end)))

if var3.Character then
	BindCharacter(var3.Character)
end

local num1 = 0
table.insert(tbl1, (var6.Heartbeat:Connect(function(arg1)
	local var1 = num1 + arg1
	num1 = var1
	if num1 < 0.1 then
		return
	end

	num1 = 0
	local var2 = var3.Character
	local var5 = var2
	local bool2 = false
	var5 = var5 and var2:FindFirstChildOfClass("Humanoid")
	if var3:GetAttribute("TrainingTier") ~= nil then
		bool2 = false
		if var2 ~= nil then
			bool2 = false
			if var2:GetAttribute("TrainingTreadmill") == true then
				bool2 = var5
				if bool2 then
					bool2 = 0 < var5.Health
				end
			end
		end
	end

	var1 = bool2 == true
	var4.Visible = var1
	if RefreshTarget(tbl2.Free, var1) or RefreshTarget(tbl2.Paid, var1) then
		Place(tbl2.Free)
		Place(tbl2.Paid)
	end
end)))

script.Destroying:Once(function()
	for k1, v1 in tbl2, nil do
		local var1 = v1.Frame.Visible
		if v1.Pulse then
			v1.Pulse:Cancel()
			v1.Pulse = nil
		end

		v1.Scale.Scale = v1.BaseScale
		if var8.SelectedObject == v1.Button then
			var8.SelectedObject = nil
		end

		v1.Frame.Visible = false
		v1.Button.Interactable = false
		v1.Button.Selectable = false
		v1.Frame:Destroy()
	end

	for k2, v2 in tbl1, nil do
		v2:Disconnect()
	end

	if var15 then
		var15:Disconnect()
	end

	if var16 then
		var16:Disconnect()
	end
end)

local var17 = var3.Character
local var18 = var17
local bool2 = false
var18 = var18 and var17:FindFirstChildOfClass("Humanoid")
if var3:GetAttribute("TrainingTier") ~= nil then
	bool2 = false
	if var17 ~= nil then
		bool2 = false
		if var17:GetAttribute("TrainingTreadmill") == true then
			bool2 = var18
			if bool2 then
				bool2 = 0 < var18.Health
			end
		end
	end
end

local var19 = bool2 == true
var4.Visible = var19
if RefreshTarget(tbl2.Free, var19) or RefreshTarget(tbl2.Paid, var19) then
	Place(tbl2.Free)
	Place(tbl2.Paid)
end

--- Players.LocalPlayer.PlayerScripts.RaceLightingController [LocalScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
local str1 = "Lighting"
local tbl1 = {}
local var2 = require(var1.Modules.RaceLighting).new(game:GetService(str1))
local var3 = game:GetService("Players").LocalPlayer
local var4 = var1:WaitForChild("RaceState")
local var5 = nil
local str2 = "RaceFinishing"
local var6 = game:GetService("RunService")
local function refresh()
	local var6 = var3.Character
	local var7 = var6
	local var8 = var6
	var7 = var7 and var6:FindFirstChildOfClass("Humanoid")
	var8 = var8 and var6:FindFirstChild("HumanoidRootPart")
	local var9 = workspace.CurrentCamera
	local var10 = workspace:FindFirstChild("ActiveRaceTrack")
	local var11 = var4:GetAttribute("MapId")
	local var12 = var4:GetAttribute("Phase")
	local bool1 = true
	if var3:GetAttribute("RaceParticipant") ~= true then
		bool1 = var3:GetAttribute("RaceFinishing") == true
	end

	local var13 = var4:GetAttribute("RoundId")
	local bool3 = true
	if var12 ~= "Joining" then
		bool3 = true
		if var12 ~= "Staging" then
			bool3 = true
			if var12 ~= "Countdown" then
				bool3 = true
				if var12 ~= "Racing" then
					bool3 = var12 == "Results"
				end
			end
		end
	end

	local var15 = bool1
	if var15 then
		var15 = bool3
		if var15 then
			var15 = false
			if var13 ~= nil then
				var15 = false
				if var3:GetAttribute("RaceRoundId") == var13 then
					var15 = false
					if var6 ~= var5 then
						var15 = var7
						if var15 then
							var15 = false
							if 0 < var7.Health then
								var15 = var8
								if var15 then
									var15 = var9
									if var15 then
										var15 = var10
										if var15 then
											var15 = var10:GetAttribute("RaceMapId") == var11
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if var15 then
		local var16 = nil
		for k1, v1 in var1.RaceMaps:GetChildren() do
			if v1:GetAttribute("RaceMapId") ~= var11 then
				continue
			end

			var16 = v1
			break
		end

		local var17 = var16
		var17 = var17 and var16:FindFirstChild("StartPositions")
		local var18 = var17
		var18 = var18 and var17:FindFirstChild("1")
		local var20 = var18
		if var20 then
			var20 = false
			if (var8.Position - var18.Position).Magnitude < 1800 then
				var20 = (var9.CFrame.Position - var18.Position).Magnitude < 1800
			end
		end

		var15 = var20
	end

	if var15 then
		var2:Apply(var11)
		return
	end

	var2:Restore()
end

for k1, v1 in { "RaceParticipant", str2, "RaceRoundId" }, nil do
	local var7 = refresh
	table.insert(tbl1, var3:GetAttributeChangedSignal(v1):Connect(var7))
end

local str3 = "RoundId"
for k2, v2 in { "MapId", str3, "Phase" }, nil do
	local var8 = refresh
	table.insert(tbl1, var4:GetAttributeChangedSignal(v2):Connect(var8))
end

local function fn3(arg1)
	var5 = arg1
	var2:Restore()
end

table.insert(tbl1, var3.CharacterRemoving:Connect(fn3))
fn3 = function()
	var5 = nil
	refresh()
end

table.insert(tbl1, var3.CharacterAdded:Connect(fn3))
fn3 = function(arg1)
	if arg1.Name == "ActiveRaceTrack" then
		var2:Restore()
	end
end

table.insert(tbl1, workspace.ChildRemoved:Connect(fn3))
local var9 = refresh
table.insert(tbl1, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(var9))
local num1 = 0
local function fn5(arg1)
	local var1 = num1 + arg1
	num1 = var1
	if 0.05 <= num1 then
		num1 = 0
		refresh()
	end
end

table.insert(tbl1, var6.Heartbeat:Connect(fn5))
script.Destroying:Connect(function()
	for k1, v1 in tbl1, nil do
		v1:Disconnect()
	end

	var2:Destroy()
end)

refresh()

--- Players.LocalPlayer.PlayerScripts.AdminPanelController [LocalScript]
-- y u r i

local var1 = game:GetService("Players").LocalPlayer
local var2 = game:GetService("ReplicatedStorage")
local str1 = "AdminCrateConfig"
local str2 = "NumberFormatter"
local var3 = require(var2:WaitForChild("Configs"):WaitForChild(str1))
local str3 = "CarConfig"
local var4 = require(var2:WaitForChild("Modules"):WaitForChild(str2))
local str4 = "IndexCarPreviews"
str1 = require(var2:WaitForChild("Modules"):WaitForChild(str4))
local var5 = var1:WaitForChild("PlayerGui")
str2 = var5:FindFirstChild("Main")
local var6 = require(var2:WaitForChild("Configs"):WaitForChild(str3))
local var7 = game:GetService("UserInputService")
local var8 = game:GetService("TextChatService")
local var9 = game:GetService("TweenService")
local var10 = game:GetService("HttpService")
local var11 = var2:WaitForChild("Remotes"):WaitForChild("Events")
str2 = (str2 or game:GetService("StarterGui"):WaitForChild("Main")):WaitForChild("Index")
str3 = { Background = Color3.fromRGB(10, 12, 18) }
str3.Surface = Color3.fromRGB(34, 41, 59)
str3.Soft = Color3.fromRGB(45, 55, 77)
str3.Hover = Color3.fromRGB(59, 71, 97)
str3.Border = Color3.fromRGB(64, 77, 103)
str3.Text = Color3.fromRGB(245, 248, 255)
str3.Muted = Color3.fromRGB(171, 184, 208)
str3.Accent = Color3.fromRGB(129, 169, 255)
str3.Tint = Color3.fromRGB(60, 112, 229)
str3.Close = Color3.fromRGB(207, 74, 87)
str3.CloseHover = Color3.fromRGB(231, 91, 104)
str3.Error = Color3.fromRGB(255, 151, 157)
local function Create(arg1, arg2, arg3)
	local var1 = Instance.new(arg1)
	for k1, v1 in arg2, nil do
		var1[k1] = v1
	end

	if var1:IsA("GuiObject") then
		local var2 = arg2.ZIndex
		var2 = var2 or (arg3 and (arg3:IsA("GuiObject") and arg3.ZIndex + 1) or 100)
		var1.ZIndex = var2
		if arg2.LayoutOrder == nil and arg3 then
			var1.LayoutOrder = #arg3:GetChildren() + 1
		end
	end

	var1.Parent = arg3
	return var1
end

local function Studs(arg1, arg2)
	local var1 = str2.Studs:Clone()
	var1.AnchorPoint = Vector2.new(0.5, 0.5)
	var1.Position = UDim2.fromScale(0.5, 0.5)
	var1.Size = UDim2.fromScale(1, 1)
	var1.ImageTransparency = arg2 or 0.9
	var1.ScaleType = Enum.ScaleType.Tile
	var1.TileSize = UDim2.fromOffset(64, 64)
	var1.ZIndex = arg1.ZIndex
	var1.Active = false
	var1.Parent = arg1
	if not var1:FindFirstChildOfClass("UICorner") then
		Create("UICorner", { CornerRadius = UDim.new(0, 10) }, var1)
	end
end

local function Label(arg1, arg2, arg3, arg4, arg5, arg6)
	local tbl1 = {
		Name = arg2,
		Size = UDim2.new(1, 0, 0, arg4 or 22),
		BackgroundTransparency = 1,
		TextWrapped = true,
	}

	tbl1.Font = Enum.Font.Gotham
	tbl1.Text = arg3
	tbl1.TextSize = arg5 or 14
	local var1 = arg6
	tbl1.TextColor3 = var1 or str3.Text
	tbl1.TextXAlignment = Enum.TextXAlignment.Left
	tbl1.TextYAlignment = Enum.TextYAlignment.Center
	return (Create("TextLabel", tbl1, arg1))
end

local function Button(arg1, arg2, arg3, arg4)
	if arg2 == "Close" then
		local var1 = str2.Exit:Clone()
		var1.Name = "CloseSlot"
		var1:SetAttribute("WindowEffectsManaged", true)
		var1.ZIndex = arg1.ZIndex + 4
		var1.Size = UDim2.fromOffset(42, 42)
		local var2 = var1.Button
		var2.Name = "Close"
		var2:SetAttribute("UIEffectsIgnore", true)
		var2.AnchorPoint = Vector2.new(0.5, 0.5)
		var2.Position = UDim2.fromScale(0.5, 0.5)
		var2.Size = UDim2.fromScale(1, 1)
		var2.ZIndex = var1.ZIndex + 1
		var2.AutoButtonColor = false
		var1.Text.ZIndex = var2.ZIndex + 1
		var1.Text.Size = UDim2.new(1, -8, 1, -8)
		local var3 = nil
		local var4 = Create("UIScale", { Scale = 1 }, var1)
		local function Paint(arg1)
			if var3 then
				var3:Cancel()
			end

			local var1 = TweenInfo.new(0.1)
			var3 = var9:Create(var4, var1, { Scale = arg1 })
			var3:Play()
		end

		var2.MouseEnter:Connect(function()
			Paint(1.06)
		end)

		var2.MouseLeave:Connect(function()
			Paint(1)
		end)

		var2.SelectionGained:Connect(function()
			Paint(1.06)
		end)

		var2.SelectionLost:Connect(function()
			Paint(1)
		end)

		var2.Destroying:Once(function()
			if var3 then
				var3:Cancel()
			end
		end)

		var1.Parent = arg1
		return var2, var1
	end

	local var5 = Create("Frame", { Name = arg2 .. "Slot", Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1 }, arg1)
	local var6 = Instance.new("TextButton")
	var6.Name = arg2
	var6:SetAttribute("UIEffectsIgnore", true)
	var6.AnchorPoint = Vector2.new(0.5, 0.5)
	var6.Position = UDim2.fromScale(0.5, 0.5)
	var6.Size = UDim2.fromScale(1, 1)
	var6.ZIndex = var5.ZIndex + 1
	var6.BackgroundColor3 = arg2 == "Close" and str3.Close or str3.Soft
	var6.BorderSizePixel = 0
	var6.AutoButtonColor = false
	var6.Interactable = not arg4
	var6.Selectable = not arg4
	var6.Font = Enum.Font.GothamBold
	var6.Text = arg3
	var6.TextSize = 14
	var6.TextScaled = true
	var6.TextWrapped = false
	Create("UITextSizeConstraint", { MinTextSize = 10, MaxTextSize = 14 }, var6)
	Paint = { PaddingLeft = UDim.new(0, 6) }
	Paint.PaddingRight = UDim.new(0, 6)
	Create("UIPadding", Paint, var6)
	var6.TextColor3 = arg4 and str3.Muted or str3.Text
	Create("UICorner", { CornerRadius = UDim.new(0, 8) }, var6)
	Studs(var6, 0.97)
	local num1 = 180
	local num2 = 199
	local num3 = 230
	Create("UIGradient", {
		Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(num1, num2, num3)),
		Rotation = 90,
	}, var6)

	local var7 = Create("UIStroke", { Color = str3.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, var6)
	var6.Parent = var5
	Paint = nil
	local bool1 = false
	local function fn3()
		if Paint then
			Paint:Cancel()
		end

		local var1 = var6:GetAttribute("Selected") == true
		var6.TextColor3 = var6.Interactable or str3.Muted or str3.Text
		var7.Color = var1 and str3.Accent or str3.Border
		local bool3 = true
		if arg2 ~= "DropCrate" then
			bool3 = true
			if arg2 ~= "SendAnnouncement" then
				bool3 = true
				if arg2 ~= "StartPoll" then
					bool3 = arg2 == "StartEvent"
				end
			end
		end

		local var3 = var6.Interactable or str3.Soft or (bool3 and (bool1 and Color3.fromRGB(61, 217, 115)) or (Color3.fromRGB(35, 178, 90) or (var1 and str3.Tint or (bool1 and str3.Hover or str3.Soft))))
		if arg2 == "Close" then
			var3 = bool1 and str3.CloseHover or str3.Close
		end

		local var4 = TweenInfo.new(0.1)
		Paint = var9:Create(var6, var4, { BackgroundColor3 = var3 })
		Paint:Play()
	end

	var6.MouseEnter:Connect(function()
		bool1 = true
		fn3()
	end)

	var6.MouseLeave:Connect(function()
		bool1 = false
		fn3()
	end)

	var6.SelectionGained:Connect(function()
		bool1 = true
		fn3()
	end)

	var6.SelectionLost:Connect(function()
		bool1 = false
		fn3()
	end)

	var6:GetAttributeChangedSignal("Selected"):Connect(fn3)
	var6:GetPropertyChangedSignal("Interactable"):Connect(function()
		var6.Selectable = var6.Interactable
		fn3()
	end)

	var6.Destroying:Once(function()
		if Paint then
			Paint:Cancel()
		end
	end)

	fn3()
	return var6, var5
end

local function Stack(arg1, arg2, arg3)
	local tbl1 = { Name = arg2, Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 }
	tbl1.AutomaticSize = Enum.AutomaticSize.Y
	local var1 = Create("Frame", tbl1, arg1)
	local tbl2 = { Padding = UDim.new(0, arg3 or 8) }
	tbl2.SortOrder = Enum.SortOrder.LayoutOrder
	Create("UIListLayout", tbl2, var1)
	return var1
end

local var12 = nil
str4 = nil
local function ScopeSelector(arg1)
	local var1 = Create("Frame", { Name = "Audience", Size = UDim2.new(1, 0, 0, 94), BackgroundTransparency = 1 }, arg1)
	local var2 = Label(var1, "Label", "1. Choose audience", 20, 13)
	var2.Font = Enum.Font.GothamBold
	local var3, var4 = Button(var1, "Server", "This server")
	local var5, var6 = Button(var1, "Global", "All servers")
	var4.Size = UDim2.new(0.5, -4, 0, 36)
	var4.Position = UDim2.fromOffset(0, 26)
	var6.Size = UDim2.new(0.5, -4, 0, 36)
	var6.Position = UDim2.new(0.5, 4, 0, 26)
	local var7 = Label(var1, "ScopeHint", "", 26, 11, str3.Muted)
	var7.Position = UDim2.fromOffset(0, 66)
	var3.Activated:Connect(function()
		arg1:SetAttribute("Scope", "Server")
		var3:SetAttribute("Selected", true)
		var5:SetAttribute("Selected", false)
		var7.Text = "Only players in your current server."
		var7.TextColor3 = str3.Muted
	end)

	var5.Activated:Connect(function()
		arg1:SetAttribute("Scope", "Global")
		var3:SetAttribute("Selected", false)
		var5:SetAttribute("Selected", true)
		var7.Text = "ALL SERVERS \226\128\162 This action reaches players across the game."
		local var1 = Color3.fromRGB(255, 207, 128)
		var7.TextColor3 = var1 or str3.Muted
	end)

	arg1:SetAttribute("Scope", "Server")
	var3:SetAttribute("Selected", true)
	var5:SetAttribute("Selected", false)
	var7.Text = "Only players in your current server."
	var7.TextColor3 = str3.Muted
end

local function Field(arg1, arg2, arg3, arg4)
	local tbl1 = {
		Name = arg2,
		Size = UDim2.new(1, 0, 0, arg4 or 44),
		BorderSizePixel = 0,
		Text = "",
		TextSize = 14,
		ClearTextOnFocus = false,
	}

	tbl1.BackgroundColor3 = str3.Surface
	tbl1.Font = Enum.Font.Gotham
	tbl1.TextColor3 = str3.Text
	tbl1.PlaceholderText = arg3
	tbl1.PlaceholderColor3 = str3.Muted
	tbl1.TextXAlignment = Enum.TextXAlignment.Left
	tbl1.TextWrapped = arg4 ~= nil
	tbl1.MultiLine = arg4 ~= nil
	tbl1.TextYAlignment = arg4 and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
	local var1 = Create("TextBox", tbl1, arg1)
	Create("UICorner", { CornerRadius = UDim.new(0, 8) }, var1)
	local tbl2 = { PaddingLeft = UDim.new(0, 12) }
	tbl2.PaddingRight = UDim.new(0, 12)
	tbl2.PaddingTop = UDim.new(0, 10)
	tbl2.PaddingBottom = UDim.new(0, 10)
	Create("UIPadding", tbl2, var1)
	local var2 = Create("UIStroke", { Color = str3.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, var1)
	var1.Focused:Connect(function()
		var2.Color = str3.Accent
	end)

	var1.FocusLost:Connect(function()
		var2.Color = str3.Border
	end)

	return var1
end

local function CharacterHint(arg1, arg2, arg3)
	local var1 = Label(arg1, arg2.Name .. "Count", "", 20, 11, str3.Muted)
	arg2:GetPropertyChangedSignal("Text"):Connect(function()
		local var2 = utf8.len(arg2.Text)
		local var3 = var2
		local var4 = tostring(var3 or (#arg2.Text))
		var1.Text = var4 .. " / " .. arg3 .. " characters"
		var1.TextColor3 = arg3 < var2 and str3.Error or str3.Muted
	end)

	local var2 = utf8.len(arg2.Text)
	local var3 = var2
	local var4 = tostring(var3 or (#arg2.Text))
	var1.Text = var4 .. " / " .. arg3 .. " characters"
	var1.TextColor3 = var2 and arg3 < var2 and str3.Error or str3.Muted
	return var1
end

local function Preview(arg1)
	local var1 = Stack(arg1, "Preview", 8)
	var1.Visible = false
	var1.BackgroundColor3 = str3.Surface
	var1.BackgroundTransparency = 0
	Create("UICorner", { CornerRadius = UDim.new(0, 10) }, var1)
	Create("UIStroke", { Color = str3.Border, Thickness = 1 }, var1)
	local tbl1 = { PaddingLeft = UDim.new(0, 14) }
	tbl1.PaddingRight = UDim.new(0, 14)
	tbl1.PaddingTop = UDim.new(0, 14)
	tbl1.PaddingBottom = UDim.new(0, 14)
	Create("UIPadding", tbl1, var1)
	Label(var1, "Title", "Live preview \226\128\162 not sent", 22, 13, str3.Muted)
	local var2 = Label(var1, "Body", "", 24)
	var2.AutomaticSize = Enum.AutomaticSize.Y
	var2.TextYAlignment = Enum.TextYAlignment.Top
	return var1, var2
end

local function ActionDock(arg1, arg2, arg3)
	local tbl1 = { Name = arg3, AnchorPoint = Vector2.new(0, 1), BorderSizePixel = 0, Visible = false }
	tbl1.Position = UDim2.fromScale(0, 1)
	tbl1.Size = UDim2.new(1, 0, 0, 86)
	tbl1.BackgroundColor3 = str3.Background
	local var1 = Create("Frame", tbl1, arg1)
	local tbl2 = { Name = "Divider", Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0 }
	tbl2.BackgroundColor3 = str3.Border
	Create("Frame", tbl2, var1)
	arg2.Size = UDim2.new(1, 0, 1, -96)
	arg2:GetPropertyChangedSignal("Visible"):Connect(function()
		var1.Visible = arg2.Visible
	end)

	return var1
end

local var13 = nil
local function BuildPanel()
	str4 = Instance.new("ScreenGui")
	str4.Name = "AdminPanel"
	str4.Enabled = false
	str4.ResetOnSpawn = false
	str4.DisplayOrder = 1000000
	str4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	str4:SetAttribute("WindowEffectsManaged", true)
	local tbl1 = {
		Name = "Panel",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		Active = true,
	}

	tbl1.Position = UDim2.fromScale(0.5, 0.5)
	tbl1.Size = UDim2.fromOffset(900, 780)
	tbl1.BackgroundColor3 = str3.Background
	local var2 = Create("Frame", tbl1, str4)
	var2:SetAttribute("WindowEffectsManaged", true)
	Create("UICorner", { CornerRadius = UDim.new(0, 12) }, var2)
	Studs(var2, 0.93)
	local var9 = Create("UIScale", { Scale = 1 }, var2)
	tbl1 = function()
		local var1 = str4.AbsoluteSize
		if var1.X < 1 or var1.Y < 1 then
			return
		end

		var9.Scale = math.min(1, math.max(0.1, (var1.X - 20) / 340), (math.max(0.1, (var1.Y - 20) / 700)))
		var2.Size = UDim2.fromOffset(math.clamp((var1.X - 20) / var9.Scale, 340, 900), (math.clamp((var1.Y - 20) / var9.Scale, 700, 860)))
		var2.Position = UDim2.fromScale(0.5, 0.5)
	end

	str4:GetPropertyChangedSignal("AbsoluteSize"):Connect(tbl1)
	Create("UIStroke", { Color = Color3.fromRGB(128, 145, 174), Transparency = 0.65, Thickness = 2 }, var2)
	local var14 = Label(var2, "Title", "Admin panel", 30, 24)
	var14.Font = Enum.Font.GothamBlack
	var14.TextStrokeTransparency = 1
	var14.Position = UDim2.fromOffset(18, 14)
	var14.Size = UDim2.new(1, -94, 0, 30)
	local var15 = Label(var2, "Subtitle", "Live controls  \226\128\162  G to toggle  \226\128\162  /panel to open", 18, 11, str3.Muted)
	var15.Position = UDim2.fromOffset(18, 43)
	var15.Size = UDim2.new(1, -80, 0, 18)
	local var16, var17 = Button(var2, "Close", "X")
	var17.AnchorPoint = Vector2.new(0.5, 0.5)
	var17.Position = UDim2.new(1, -39, 0, 32)
	var17.Size = UDim2.fromOffset(38, 38)
	var16.Activated:Connect(function()
		if str4 then

			local var2 = var7:GetFocusedTextBox()
			if var2 and var2:IsDescendantOf(str4) then
				var2:ReleaseFocus()
			end

			str4.Enabled = false
		end
	end)

	local var18 = nil
	local var19 = nil
	local var20 = nil
	Create("Frame", {
		Name = "DragHandle",
		Size = UDim2.new(1, -76, 0, 60),
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = 110,
	}, var2).InputBegan:Connect(function(arg1)
		if var18 or (not str4.Enabled) then
			return
		end

		if arg1.UserInputType == Enum.UserInputType.MouseButton1 or arg1.UserInputType == Enum.UserInputType.Touch then
			var18 = arg1
			var19 = arg1.Position
			var20 = var2.Position
		end
	end)

	str4:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not str4.Enabled then
			var18 = nil
		end
	end)

	local var21 = var7.InputChanged:Connect(function(arg1)
		if not var18 or (not str4.Enabled) then
			return
		end

		if arg1 ~= var18 and (var18.UserInputType ~= Enum.UserInputType.MouseButton1 or arg1.UserInputType ~= Enum.UserInputType.MouseMovement) then
			return
		end

		local var1 = str4.AbsoluteSize
		local var3 = arg1.Position - var19
		local var4 = var2.AbsoluteSize * 0.5
		var2.Position = UDim2.new(var20.X.Scale, math.clamp(var20.X.Scale * var1.X + var20.X.Offset + var3.X, var4.X, (math.max(var4.X, var1.X - var4.X))) - var20.X.Scale * var1.X, var20.Y.Scale, math.clamp(var20.Y.Scale * var1.Y + var20.Y.Offset + var3.Y, var4.Y, (math.max(var4.Y, var1.Y - var4.Y))) - var20.Y.Scale * var1.Y)
	end)

	local var22 = var7.InputEnded:Connect(function(arg1)
		if arg1 == var18 then
			var18 = nil
		end
	end)

	var2.Destroying:Once(function()
		var21:Disconnect()
		var22:Disconnect()
	end)

	local tbl2 = { Name = "Tabs", Position = UDim2.fromOffset(18, 72), BackgroundTransparency = 1 }
	tbl2.Size = UDim2.new(1, -36, 0, 42)
	local var23 = Create("Frame", tbl2, var2)
	local tbl3 = { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }
	tbl3.SortOrder = Enum.SortOrder.LayoutOrder
	Create("UIListLayout", tbl3, var23)
	tbl3 = { Name = "Content", Position = UDim2.fromOffset(18, 126), BackgroundTransparency = 1 }
	tbl3.Size = UDim2.new(1, -36, 1, -186)
	local var24 = Create("Frame", tbl3, var2)
	var12 = Label(var2, "Status", "Choose a command and who it is for.", 30, 12, str3.Muted)
	var12.AnchorPoint = Vector2.new(0, 1)
	var12.Position = UDim2.new(0, 18, 1, -12)
	var12.Size = UDim2.new(1, -36, 0, 34)
	var12.TextSize = 12
	tbl2 = {}
	tbl3 = {}
	local tbl4 = { Name = "Crates", Text = "Crate drop" }
	local tbl5 = { Name = "Speech", Text = "Announce" }
	local function SelectPage(arg1)
		for k1, v1 in tbl2, nil do
			v1.Visible = k1 == arg1
			tbl3[k1]:SetAttribute("Selected", k1 == arg1)
		end

		local var1
		if arg1 == "Speech" then
			var1 = "Send an announcement to your chosen audience."
		elseif arg1 == "Polls" then
			var1 = "Create a poll or manage the active poll."
		elseif arg1 == "Treadmill" then
			var1 = "Start or stop a shared treadmill event."
		else
			var1 = "Drop surprise crates around the lobby."
		end

		if var12 then
			var12.Text = var1
			var12.TextColor3 = str3.Muted
		end
	end

	for k1, v1 in {
		tbl4,
		tbl5,
		{ Name = "Polls", Text = "Polls" },
		{ Name = "Treadmill", Text = "Treadmill" },
	}, nil do

		local var25, var26 = Button(var23, v1.Name, v1.Text)
		var26.Size = UDim2.new(0.25, -5, 1, 0)
		var26.LayoutOrder = k1
		var25.TextSize = 13
		tbl3[v1.Name] = var25
		local tbl6 = {
			Name = v1.Name,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			Visible = false,
		}

		tbl6.CanvasSize = UDim2.new()
		tbl6.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tbl6.ScrollBarImageColor3 = str3.Border
		tbl6.ScrollingDirection = Enum.ScrollingDirection.Y
		local var27 = Create("ScrollingFrame", tbl6, var24)
		local tbl7 = { PaddingTop = UDim.new(0, 3) }
		tbl7.PaddingLeft = UDim.new(0, 3)
		tbl7.PaddingRight = UDim.new(0, 10)
		tbl7.PaddingBottom = UDim.new(0, 10)
		Create("UIPadding", tbl7, var27)
		tbl7 = { Padding = UDim.new(0, 12) }
		tbl7.SortOrder = Enum.SortOrder.LayoutOrder
		Create("UIListLayout", tbl7, var27)
		tbl2[v1.Name] = var27
		local var28 = v1.Name
		var25.Activated:Connect(function()
			SelectPage(var28)
		end)

		ScopeSelector(var27)
	end

	local var29 = tbl2.Crates
	var29:FindFirstChildOfClass("UIListLayout"):Destroy()
	var29:FindFirstChildOfClass("UIPadding"):Destroy()
	var29.Size = UDim2.new(1, 0, 1, -104)
	var29.AutomaticCanvasSize = Enum.AutomaticSize.None
	var29.ScrollingEnabled = false
	var29.ScrollBarThickness = 0
	var29.ClipsDescendants = false
	local var30 = var29.Audience
	var30.Position = UDim2.fromOffset(3, 0)
	var30.Size = UDim2.new(1, -6, 0, 94)
	local tbl8 = { Name = "RewardPicker", Position = UDim2.fromOffset(3, 102), BackgroundTransparency = 1 }
	tbl8.Size = UDim2.new(1, -6, 0, 140)
	local var31 = Create("Frame", tbl8, var29)
	local var32 = Label(var31, "Title", "2. Choose rewards & set chances", 22, 15)
	var32.Font = Enum.Font.GothamBold
	var32 = Field(var31, "SearchRewards", "Search cars, rarity, cash or speed")
	var32.Position = UDim2.fromOffset(0, 28)
	var32.Size = UDim2.new(1, 0, 0, 38)
	var32.UIPadding.PaddingTop = UDim.new(0, 2)
	var32.UIPadding.PaddingBottom = UDim.new(0, 2)
	local tbl9 = { Name = "RewardTools", Position = UDim2.fromOffset(0, 74), BackgroundTransparency = 1 }
	tbl9.Size = UDim2.new(1, 0, 0, 66)
	tbl8 = Create("Frame", tbl9, var31)
	local var33, var34 = Button(tbl8, "AllRewards", "Browse all")
	local var35, var36 = Button(tbl8, "SelectedRewards", "Selected")
	local var37, var38 = Button(tbl8, "EqualChances", "Equal chances")
	local var39, var40 = Button(tbl8, "DefaultRewards", "Use defaults")
	local var41, var42 = Button(tbl8, "ClearRewards", "Deselect all")
	local tbl10 = {
		Name = "RewardList",
		Position = UDim2.fromOffset(0, 160),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 5,
		ClipsDescendants = true,
	}

	tbl10.Size = UDim2.new(1, 0, 1, -160)
	tbl10.CanvasSize = UDim2.new()
	tbl10.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tbl10.ScrollingDirection = Enum.ScrollingDirection.Y
	tbl10.ScrollBarImageColor3 = str3.Accent
	local var43 = Create("ScrollingFrame", tbl10, var29)
	local tbl11 = { PaddingLeft = UDim.new(0, 3) }
	tbl11.PaddingRight = UDim.new(0, 10)
	tbl11.PaddingTop = UDim.new(0, 3)
	tbl11.PaddingBottom = UDim.new(0, 12)
	Create("UIPadding", tbl11, var43)
	tbl11 = { Padding = UDim.new(0, 8) }
	tbl11.SortOrder = Enum.SortOrder.LayoutOrder
	Create("UIListLayout", tbl11, var43)
	local var44 = Label(var29, "NoRewards", "No matching rewards", 40, 14, str3.Muted)
	var44.Position = UDim2.fromOffset(0, 170)
	var44.TextXAlignment = Enum.TextXAlignment.Center
	var44.Visible = false
	local tbl12 = {
		Name = "CrateActions",
		AnchorPoint = Vector2.new(0, 1),
		BorderSizePixel = 0,
		Visible = false,
	}

	tbl12.Position = UDim2.fromScale(0, 1)
	tbl12.Size = UDim2.new(1, 0, 0, 98)
	tbl12.BackgroundColor3 = str3.Background
	tbl10 = Create("Frame", tbl12, var24)
	local tbl13 = { Name = "Divider", Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0 }
	tbl13.BackgroundColor3 = str3.Border
	Create("Frame", tbl13, tbl10)
	tbl11 = Label(tbl10, "RewardSummary", "", 36, 12, str3.Muted)
	tbl11.Position = UDim2.fromOffset(0, 2)
	local tbl14 = { Name = "ChanceTrack", Position = UDim2.fromOffset(0, 40), BorderSizePixel = 0 }
	tbl14.Size = UDim2.new(1, 0, 0, 4)
	tbl14.BackgroundColor3 = str3.Soft
	tbl12 = Create("Frame", tbl14, tbl10)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, tbl12)
	local tbl15 = { Name = "Fill", Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }
	tbl15.BackgroundColor3 = str3.Accent
	tbl13 = Create("Frame", tbl15, tbl12)
	Create("UICorner", { CornerRadius = UDim.new(0, 2) }, tbl13)
	tbl11.TextSize = 12
	local var45, var46 = Button(tbl10, "DropCrate", "")
	var46.Size = UDim2.new(1, 0, 0, 44)
	var46.Position = UDim2.fromOffset(0, 52)
	var29:GetPropertyChangedSignal("Visible"):Connect(function()
		tbl10.Visible = var29.Visible
	end)

	local tbl16 = {}
	local function Amount(arg1)
		local var1, var2 = arg1:gsub(",", ""):gsub("%s", ""):upper():match("^(%d+%.?%d*)(%a*)$")
		local var4 = ({
			[""] = 1,
			K = 1000,
			M = 1000000,
			B = 1000000000,
			T = 1000000000000,
			QA = 1000000000000000,
		})[var2]

		if var1 then
			if var4 then
				local var5 = tonumber(var1) * var4
				var5 = var5 or nil
			end
		end

		return nil
	end

	local num1 = 0
	local bool1 = false
	local bool2 = false
	local var47 = nil
	local function PackRewards()
		local tbl1 = { Version = var3.CatalogVersion, Cars = "" }
		local tbl2 = {}
		local num1 = 0
		local num2 = 0
		for k1, v1 in tbl16, nil do
			if not v1.Selected then
				continue
			end

			local var2 = tonumber(v1.Chance.Text)
			if not var2 or (var2 % 1 ~= 0 or (var2 < 1 or 100 < var2)) then
				return nil, v1.DisplayName .. ": enter a whole chance from 1% to 100%."
			end

			num1 = num1 + 1
			num2 = num2 + var2
			if v1.CarIndex then
				table.insert(tbl2, v1.CarIndex .. ":" .. var2)
			else
				local var7 = Amount(v1.Amount.Text)
				local var8 = v1.Kind == "Cash" and var3.MaxCashReward or var3.MaxSpeedReward
				if not var7 or (var7 % 1 ~= 0 or (var7 < 1 or var8 < var7)) then
					return nil, v1.Kind .. " amount must be from 1 to " .. var4.Format(var8) .. "."
				end

				tbl1[v1.Kind] = { Amount = var7, Chance = var2 }
			end
		end

		if num1 == 0 then
			return nil, "Choose at least one reward."
		end

		if num2 ~= 100 then
			return nil, num2 .. "% total \226\128\162 Use Equal chances or edit chances to total 100%."
		end

		tbl1.Cars = table.concat(tbl2, ",")
		if 512 < (#var10:JSONEncode(tbl1)) then
			return nil, "This selection is too large."
		end

		local var9 = tbl1
		local var11 = num1
		return var9, var11 .. (if num1 == 1 then " reward" else " rewards") .. " \226\128\162 100% total \226\128\162 Each player gets one"
	end

	local var48 = nil
	local function RefreshRewards(arg1)
		local var9
		if arg1 then
			local var1 = num1 + 1
			num1 = var1
		end

		if bool1 then
			return
		end

		local var2 = var32.Text:lower():match("^%s*(.-)%s*$")
		local var4 = var7:GetFocusedTextBox()
		local num2 = 0
		local num3 = 0
		local num4 = 0
		for k1, v1 in tbl16, nil do
			local var5 = v1.Frame
			if bool2 then
				local var8 = v1.Selected
				if var8 then
					var8 = v1.Search:find(var2, 1, true) ~= nil
				end
			end

			var5.Visible = var9
			if v1.Frame.Visible then
				num4 = num4 + 1
			end

			if v1.Selected then
				num2 = num2 + 1
				num3 = num3 + (tonumber(v1.Chance.Text) or 0)
			end

			v1.Editor.Visible = v1.Selected
			var5 = v1.Check
			var5.Text = if v1.Selected then "\226\156\147" else "+"
			v1.Check:SetAttribute("Selected", v1.Selected)
			v1.Stroke.Color = v1.Selected and str3.Accent or str3.Border
			var5 = v1.Stroke
			var5.Transparency = if v1.Selected then 0.15 else 0.55
			local var9 = v1.Selected and Color3.fromRGB(25, 48, 71) or str3.Surface
			v1.Frame.BackgroundColor3 = var9
			v1.Chance.TextEditable = v1.Selected
			v1.Chance.TextColor3 = v1.Selected and str3.Text or str3.Muted
			var9 = v1.Selected
			var5 = tonumber(v1.Chance.Text)
			if var9 then
				var9 = not var5
				if not var9 then
					var9 = true
					if var5 % 1 == 0 then
						var9 = true
						if var5 >= 1 then
							var9 = 100 < var5
						end
					end
				end
			end

			local var10 = v1.Chance:FindFirstChildOfClass("UIStroke")
			var10.Color = var9 and str3.Error or (var4 == v1.Chance and str3.Accent or str3.Border)
			if not v1.Amount then
				continue
			end

			v1.Amount.TextEditable = v1.Selected
			local var12 = v1.Selected
			var10 = Amount(v1.Amount.Text)
			local var13 = v1.Kind == "Cash" and var3.MaxCashReward or var3.MaxSpeedReward
			if var12 then
				var12 = not var10
				if not var12 then
					var12 = true
					if var10 % 1 == 0 then
						var12 = true
						if var10 >= 1 then
							var12 = var13 < var10
						end
					end
				end
			end

			local var14 = v1.Amount:FindFirstChildOfClass("UIStroke")
			var14.Color = var12 and str3.Error or (var4 == v1.Amount and str3.Accent or str3.Border)
		end

		var44.Visible = num4 == 0
		local var15 = var44
		var15.Text = if bool2 then "No selected rewards match. Browse all to add rewards." else "No rewards found. Try a car name, rarity, cash or speed."
		var35.Text = "Selected (" .. num2 .. ")"
		tbl13.Size = UDim2.fromScale(math.clamp(num3 / 100, 0, 1), 1)
		local var16 = num3 == 100 and Color3.fromRGB(100, 220, 145) or str3.Error
		tbl13.BackgroundColor3 = var16
		var15 = var37
		var16 = false
		if 0 < num2 then
			var16 = num2 <= 100
		end

		var15.Interactable = var16
		var41.Interactable = 0 < num2
		if var47 then
			var47()
		end

		var33:SetAttribute("Selected", not bool2)
		var35:SetAttribute("Selected", bool2)
		local var17, var18 = PackRewards()
		tbl11.Text = var18
		tbl11.TextColor3 = (var17 or num2 == 0) and str3.Muted or str3.Error
		if var48 then
			var48()
		end
	end

	local num2 = 90
	local num3 = 205
	local tbl17 = {
		Kind = "Cash",
		Name = "Cash",
		Amount = 25000,
		Rarity = "Currency",
		Color = Color3.fromRGB(100, 235, 120),
	}

	local tbl18 = {
		tbl17,
		{
			Kind = "Speed",
			Name = "Speed",
			Amount = 1000,
			Rarity = "Training power",
			Color = Color3.fromRGB(num2, num3, 255),
		},
	}

	local tbl19 = { var34, var36, var38, var40, var42 }
	local var49 = nil
	local bool3 = false
	local bool4 = true
	local num4 = 0
	local var50 = nil
	local function RewardInput(arg1, arg2, arg3, arg4)
		local tbl1 = {
			Name = arg2,
			Size = UDim2.fromOffset(arg4, 28),
			PlaceholderText = "",
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			TextSize = 13,
			ClearTextOnFocus = false,
			MultiLine = false,
		}

		tbl1.Text = arg3
		tbl1.BackgroundColor3 = str3.Background
		tbl1.Font = Enum.Font.GothamBold
		tbl1.TextColor3 = str3.Text
		local var1 = Create("TextBox", tbl1, arg1)
		Create("UICorner", { CornerRadius = UDim.new(0, 6) }, var1)
		var1.TextScaled = true
		Create("UITextSizeConstraint", { MinTextSize = 10, MaxTextSize = 13 }, var1)
		local var2 = Create("UIStroke", { Color = str3.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, var1)
		var1.Focused:Connect(function()
			var2.Color = str3.Accent
		end)

		var1.FocusLost:Connect(function()
			RefreshRewards(false)
		end)

		var1:GetPropertyChangedSignal("Text"):Connect(function()
			RefreshRewards(true)
		end)

		return var1
	end

	for k2, v2 in var3.CarIds, nil do
		local var51 = var6.Get(v2)
		local var52 = var51.DisplayName
		local tbl20 = { Kind = "Car", CarId = v2, CarIndex = k2, Name = var52 or (var51.Name or v2) }
		tbl20.Rarity = var51.Rarity
		tbl20.Color = var6.GetRarityInfo(var51.Rarity).Color
		tbl20.Tier = var51.Tier
		table.insert(tbl18, tbl20)
	end

	table.sort(tbl18, function(arg1, arg2)
		if (arg1.Tier or 0) ~= (arg2.Tier or 0) then
			return (arg1.Tier or 0) < (arg2.Tier or 0)
		end

		return arg1.Name < arg2.Name
	end)

	for k3, v3 in tbl18, nil do
		local var53 = v3.CarId
		local tbl21 = { Name = var53 or v3.Kind, BackgroundTransparency = 0.15, BorderSizePixel = 0 }
		tbl21.Size = UDim2.new(1, -8, 0, 72)
		tbl21.BackgroundColor3 = str3.Surface
		tbl21.LayoutOrder = k3
		local var54 = Create("Frame", tbl21, var43)
		Create("UICorner", { CornerRadius = UDim.new(0, 10) }, var54)
		Studs(var54, 0.95)
		local var55 = Create("UIStroke", { Color = str3.Border, Transparency = 0.55, Thickness = 2 }, var54)
		local var56, var57 = Button(var54, "SelectReward", "+")
		var57.Size = UDim2.fromOffset(36, 36)
		var57.Position = UDim2.new(1, -48, 0, 16)
		local var58 = Label(var54, "RewardName", v3.Name, 24, 17)
		var58.Font = Enum.Font.GothamBold
		var58.Position = UDim2.fromOffset(76, 10)
		var58.Size = UDim2.new(1, -136, 0, 24)
		var58.TextScaled = true
		Create("UITextSizeConstraint", { MinTextSize = 11, MaxTextSize = 17 }, var58)
		local tbl22 = { Name = "Preview", Position = UDim2.fromOffset(12, 8), BackgroundTransparency = 1 }
		tbl22.Size = UDim2.fromOffset(56, 56)
		local var59 = Create("Frame", tbl22, var54)
		Create("ImageLabel", { Name = "Image", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = "" }, var59)
		if v3.CarId then
			str1.SetCard(var59, v3.CarId, true)
		else
			local var60 = Label
			tbl22 = var59
			local str2 = "Symbol"
			var60 = var60(tbl22, str2, if v3.Kind == "Cash" then "$" else "\194\187", 56, 34, v3.Color)
			var60.TextXAlignment = Enum.TextXAlignment.Center
			var60.Font = Enum.Font.GothamBlack
			var60.TextStrokeTransparency = 0.65
		end

		local var61 = Label(var54, "Rarity", v3.Rarity, 18, 12, v3.Color)
		var61.Position = UDim2.fromOffset(76, 36)
		var61.Size = UDim2.new(1, -136, 0, 18)
		tbl22 = {
			Kind = v3.Kind,
			CarId = v3.CarId,
			CarIndex = v3.CarIndex,
			Frame = var54,
			Check = var56,
			Stroke = var55,
			Selected = false,
			DisplayName = v3.Name,
			NameLabel = var58,
			RarityLabel = var61,
			Search = (v3.Name .. " " .. (v3.CarId or "") .. " " .. v3.Rarity):lower(),
		}

		local tbl23 = {
			Name = "RewardSettings",
			Position = UDim2.fromOffset(12, 76),
			BackgroundTransparency = 1,
			Visible = false,
		}

		tbl23.Size = UDim2.new(1, -24, 0, 58)
		tbl22.Editor = Create("Frame", tbl23, var54)
		local var62 = 1 / (if v3.CarId then 2 else 3)
		if not v3.CarId then
			tbl22.AmountLabel = Label(tbl22.Editor, "AmountLabel", "Amount", 18, 11, str3.Muted)
			tbl22.AmountLabel.Size = UDim2.new(var62, -8, 0, 18)
			tbl22.Amount = RewardInput(tbl22.Editor, "Amount", var4.Comma(v3.Amount), 100)
			tbl22.Amount.Size = UDim2.new(var62, -8, 0, 34)
			tbl22.Amount.Position = UDim2.fromOffset(0, 22)
		end

		tbl22.ChanceLabel = Label(tbl22.Editor, "ChanceLabel", "Chance (%)", 18, 11, str3.Muted)
		tbl23 = if v3.CarId then 0 else 1
		tbl22.ChanceLabel.Position = UDim2.fromScale(tbl23 * var62, 0)
		tbl22.ChanceLabel.Size = UDim2.new(var62, -8, 0, 18)
		tbl22.Chance = RewardInput(tbl22.Editor, "Chance", "1", 80)
		tbl22.Chance.Size = UDim2.new(var62, -8, 0, 34)
		tbl22.Chance.Position = UDim2.new(tbl23 * var62, 0, 0, 22)
		local var63, var64 = Button(tbl22.Editor, "OnlyReward", "Only this")
		var64.Size = UDim2.new(var62, 0, 0, 34)
		var64.Position = UDim2.new(1 - var62, 0, 0, 22)
		tbl22.OnlySlot = var64
		local tbl24 = {
			Name = "ToggleReward",
			Size = UDim2.new(1, -52, 0, 70),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
		}

		tbl24.ZIndex = var54.ZIndex + 8
		local var65 = Create("TextButton", tbl24, var54)
		var65:SetAttribute("UIEffectsIgnore", true)
		tbl22.Toggle = var65
		table.insert(tbl16, tbl22)
		local function ToggleReward()
			tbl22.Selected = not tbl22.Selected
			RefreshRewards(true)
		end

		var56.Activated:Connect(ToggleReward)
		var65.Activated:Connect(ToggleReward)
		var63.Activated:Connect(function()
			for k1, v1 in tbl16, nil do
				v1.Selected = v1 == tbl22
			end

			tbl22.Chance.Text = "100"
			RefreshRewards(true)
		end)

	end

	var37.Activated:Connect(function()
		local num1 = 0
		for k1, v1 in tbl16, nil do
			if not v1.Selected then
				continue
			end

			num1 = num1 + 1
		end

		if num1 == 0 then
			if var12 then
				var12.Text = "Select rewards before splitting the chances."
				local var1 = str3.Error
				var12.TextColor3 = var1 or str3.Muted
			end

			return
		end

		if 100 < num1 then
			if var12 then
				var12.Text = "Select at most 100 rewards to give each at least 1%."
				local var2 = str3.Error
				var12.TextColor3 = var2 or str3.Muted
			end

			return
		end

		bool1 = true
		local var3 = math.floor(100 / num1)
		local var4 = 100 % num1
		for k2, v2 in tbl16, nil do
			if not v2.Selected then
				continue
			end

			local var5 = v2.Chance
			var5.Text = tostring(var3 + (if 0 < var4 then 1 else 0))
			local var6 = math.max(0, var4 - 1)
		end

		bool1 = false
		RefreshRewards(true)
	end)

	tbl17 = function()
		bool1 = true
		for k1, v1 in tbl16, nil do
			v1.Selected = false
			for k2, v2 in var3.Rewards, nil do
				if v1.Kind ~= v2.Kind then
					continue
				end

				if v1.CarId ~= v2.CarId then
					continue
				end

				v1.Selected = true
				v1.Chance.Text = tostring(v2.Weight)
				if not v1.Amount then
					continue
				end

				v1.Amount.Text = var4.Comma(v2.Amount)
			end
		end

		bool1 = false
		RefreshRewards(true)
	end

	var39.Activated:Connect(function()
		var32.Text = ""
		bool2 = false
		var43.CanvasPosition = Vector2.zero
		tbl17()
	end)

	var41.Activated:Connect(function()
		for k1, v1 in tbl16, nil do
			v1.Selected = false
		end

		RefreshRewards(true)
	end)

	var33.Activated:Connect(function()
		bool2 = false
		var43.CanvasPosition = Vector2.zero
		RefreshRewards(false)
	end)

	var35.Activated:Connect(function()
		bool2 = true
		var43.CanvasPosition = Vector2.zero
		RefreshRewards(false)
	end)

	var32:GetPropertyChangedSignal("Text"):Connect(function()
		var43.CanvasPosition = Vector2.zero
		RefreshRewards(false)
	end)

	var47 = function()
		var43.Position = UDim2.fromOffset(0, 252)
		local num1 = 1
		var43.Size = UDim2.new(1, 0, num1, -252)
		local num2 = 260
		var44.Position = UDim2.fromOffset(0, num2)
		for k1, v1 in tbl19, nil do
			local var1 = if k1 <= 2 then 2 else 3
			v1.Size = UDim2.new(1 / var1, -(var1 - 1) * 6 / var1, 0, 30)
			local var2 = k1 <= 2 and k1 - 1 or k1 - 3
			local var3 = UDim2.new
			local var4 = var2 / var1
			local var5 = var2 * 6 / var1
			local num3 = 0
			v1.Position = var3(var4, var5, num3, if k1 <= 2 then 0 else 36)
		end

		for k2, v2 in tbl16, nil do
			local bool2 = false
			if 720 <= var43.AbsoluteSize.X / var9.Scale then
				bool2 = v2.Selected
			end

			local var6 = v2.Frame
			local var7 = UDim2.new
			local num4 = 1
			local num5 = -8
			local num6 = 0
			local var8
			if v2.Selected then
				if bool2 then
					var8 = 84
				else
					var8 = 144
				end
			else
				var8 = 72
			end

			var6.Size = var7(num4, num5, num6, var8)
			var7 = bool2 and UDim2.new(1, -416, 0, 12) or UDim2.fromOffset(12, 76)
			v2.Editor.Position = var7
			var7 = bool2 and UDim2.fromOffset(356, 58) or UDim2.new(1, -24, 0, 58)
			v2.Editor.Size = var7
			var6 = v2.NameLabel
			var7 = UDim2.new
			num4 = 1
			var6.Size = var7(num4, if bool2 then -504 else -136, 0, 24)
			var6 = v2.RarityLabel
			var7 = UDim2.new
			num4 = 1
			var6.Size = var7(num4, if bool2 then -504 else -136, 0, 18)
			var6 = v2.Toggle
			var7 = UDim2.new
			num4 = 1
			var6.Size = var7(num4, if bool2 then -424 else -52, 0, 70)
		end
	end

	var43:GetPropertyChangedSignal("AbsoluteSize"):Connect(var47)
	var9:GetPropertyChangedSignal("Scale"):Connect(var47)
	var47()
	var48 = function()
		local var3 = var49
		local var4 = var29:GetAttribute("Scope")
		if var3 then
			var3 = false
			if var49.Scope == var4 then
				var3 = var49.Revision == num1
			end
		end

		local var5 = var45
		local var6
		if bool3 then
			var6 = "Dropping..."
		elseif var3 then
			var6 = "Retry delivery"
		elseif var4 == "Global" then
			var6 = "Drop crates \226\128\162 ALL servers"
		else
			var6 = "Drop crates \226\128\162 this server"
		end

		var5.Text = var6
		var6 = not bool3
		var5 = var45
		if var6 then
			var6 = PackRewards() ~= nil
		end

		var5.Interactable = var6
	end

	var29:GetAttributeChangedSignal("Scope"):Connect(var48)
	var29.Destroying:Once(function()
		bool4 = false
		tbl10:Destroy()
		if var50 then
			var50:Disconnect()
		end
	end)

	task.spawn(function()
		local var1 = var11:WaitForChild("AdminResponse")
		if not bool4 then
			return
		end

		var50 = var1.OnClientEvent:Connect(function(arg1)
			if type(arg1) ~= "table" or (not var49 or arg1.RequestId ~= var49.Id) then
				return
			end

			if arg1.Status == "Processing" then
				return
			end

			bool3 = false
			if arg1.Status ~= "OutcomeUnknown" then
				var49 = nil
			end

			var48()
			local var1 = arg1.Message or "The drop could not be sent."
			local var2 = arg1.Success ~= true
			if var12 then
				var12.Text = var1
				var12.TextColor3 = var2 and str3.Error or str3.Muted
			end
		end)
	end)

	var45.Activated:Connect(function()
		if bool3 then
			return
		end

		local var3, var4 = PackRewards()
		if not var3 then
			if var12 then
				var12.Text = var4
				local var5 = str3.Error
				var12.TextColor3 = var5 or str3.Muted
			end

			return
		end

		local var7 = var11:FindFirstChild("AdminRequest")
		if var7 then
			if not var50 then
				if var12 then
					var12.Text = "Crates are still connecting. Try again shortly."
					local var8 = str3.Error
					var12.TextColor3 = var8 or str3.Muted
				end

				return
			end
		end

		local var13 = var29:GetAttribute("Scope")
		if not var49 or (var49.Scope ~= var13 or var49.Revision ~= num1) then
			local tbl1 = { Id = var10:GenerateGUID(false) }
			tbl1.Scope = var13
			tbl1.Revision = num1
			tbl1.Payload = var3
			var49 = tbl1
		end

		bool3 = true
		local var14 = num4 + 1
		num4 = var14
		var48()
		local var15 = var49
		var14 = num4
		local var16 = if var13 == "Global" then "Sending your reward selection to every server..." else "Dropping crates with your selected rewards..."
		if var12 then
			var12.Text = var16
			var12.TextColor3 = str3.Muted
		end

		var7:FireServer(var15.Id, "DropCrates", var15.Scope, var15.Payload)
		task.delay(15, function()
			if bool4 and (bool3 and (var49 == var15 and num4 == var14)) then
				bool3 = false
				var48()
				if var12 then
					var12.Text = "Delivery is not confirmed. Retry uses the same drop to avoid duplicates."
					local var1 = str3.Error
					var12.TextColor3 = var1 or str3.Muted
				end
			end
		end)
	end)

	tbl17()
	local var66 = tbl2.Speech
	local var67 = Stack(var66, "MessageGroup", 8)
	local var68 = Label(var67, "Label", "2. Write announcement", 22, 15)
	var68.Font = Enum.Font.GothamBold
	var68 = Field(var67, "Message", "What would you like to tell players?", 104)
	CharacterHint(var67, var68, 200)
	Label(var67, "Hint", "Players see the announcement for 7 seconds. Text is filtered when sent.", 34, 12, str3.Muted)
	local var69 = ActionDock(var24, var66, "AnnouncementActions")
	local var70, var71 = Preview(var66)
	local var72 = Label(var69, "Validation", "", 32, 12, str3.Muted)
	local var73, var74 = Button(var69, "SendAnnouncement", "")
	var74.Position = UDim2.fromOffset(0, 40)
	var74.Size = UDim2.new(1, 0, 0, 44)
	local var75 = nil
	local bool5 = false
	local function UpdateSpeechScope()
		local var2 = var75
		local var3 = var66:GetAttribute("Scope") == "Global"
		if var2 then
			var2 = false
			if var75.Scope == var66:GetAttribute("Scope") then
				var2 = var75.Message == var68.Text
			end
		end

		local var4 = var73
		local var5
		if bool5 then
			var5 = "Sending..."
		elseif var2 then
			var5 = "Retry delivery"
		elseif var3 then
			var5 = "Send announcement \226\128\162 ALL servers"
		else
			var5 = "Send announcement \226\128\162 this server"
		end

		var4.Text = var5
		var4 = utf8.len(var68.Text)
		local var7 = var4
		var5 = var68.Text:match("%S") ~= nil
		if var7 then
			var7 = false
			if var4 <= 200 then
				var7 = false
				if #var68.Text <= 400 then
					var7 = #var10:JSONEncode({ Message = var68.Text }) <= 512
				end
			end
		end

		local var9 = not bool5
		local var11 = var73
		if var9 then
			var9 = var5
			if var9 then
				var9 = var7 == true
			end
		end

		var11.Interactable = var9
		var11 = var72
		if bool5 then
			var9 = "Waiting for delivery confirmation\226\128\166"
		elseif not var5 then
			var9 = "Write a message to enable sending."
		elseif not var7 then
			var9 = "Message is too long. Shorten it before sending."
		elseif var3 then
			var9 = "Ready \226\128\162 visible across ALL servers for 7 seconds."
		else
			var9 = "Ready \226\128\162 visible in this server for 7 seconds."
		end

		var11.Text = var9
		var9 = var5 and (var7 or str3.Error) or (var3 and Color3.fromRGB(255, 207, 128) or str3.Muted)
		var72.TextColor3 = var9
		var70.Visible = true
		var71.Text = var5 and var68.Text or "Your announcement will appear here as you type."
		var71.TextColor3 = var5 and str3.Text or str3.Muted
	end

	var66:GetAttributeChangedSignal("Scope"):Connect(UpdateSpeechScope)
	var68:GetPropertyChangedSignal("Text"):Connect(UpdateSpeechScope)
	local bool6 = true
	local var76 = nil
	var66.Destroying:Once(function()
		bool6 = false
		if var76 then
			var76:Disconnect()
		end
	end)

	task.spawn(function()
		local var1 = var11:WaitForChild("AdminResponse")
		if not bool6 then
			return
		end

		var76 = var1.OnClientEvent:Connect(function(arg1)
			if type(arg1) ~= "table" or (not var75 or arg1.RequestId ~= var75.Id) then
				return
			end

			if arg1.Status == "Processing" then
				if var12 then
					var12.Text = "The announcement is still processing."
					var12.TextColor3 = str3.Muted
				end

				return
			end

			bool5 = false
			if arg1.Status ~= "OutcomeUnknown" then
				var75 = nil
			end

			UpdateSpeechScope()
			local var1 = arg1.Message or "The announcement could not be sent."
			local var2 = arg1.Success ~= true
			if var12 then
				var12.Text = var1
				var12.TextColor3 = var2 and str3.Error or str3.Muted
			end
		end)
	end)

	UpdateSpeechScope()
	local num5 = 0
	var73.Activated:Connect(function()
		if bool5 then
			return
		end

		local var2 = utf8.len(var68.Text)
		if var2 and (200 >= var2 and 400 >= (#var68.Text)) then
			if 512 < (#var10:JSONEncode({ Message = var68.Text })) then
				if var12 then
					var12.Text = "The message is too long. Shorten it to fit the 200-character limit."
					local var3 = str3.Error
					var12.TextColor3 = var3 or str3.Muted
				end

				return
			end
		end

		if not var68.Text:match("%S") then
			if var12 then
				var12.Text = "Write a message before sending."
				local var4 = str3.Error
				var12.TextColor3 = var4 or str3.Muted
			end

			var68:CaptureFocus()
			return
		end

		local var6 = var11:FindFirstChild("AdminRequest")
		if var6 then
			if not var76 then
				if var12 then
					var12.Text = "Announcements are still connecting. Try again shortly."
					local var7 = str3.Error
					var12.TextColor3 = var7 or str3.Muted
				end

				return
			end
		end

		local var9 = var66:GetAttribute("Scope")
		if not var75 or (var75.Scope ~= var9 or var75.Message ~= var68.Text) then
			local tbl1 = { Id = var10:GenerateGUID(false) }
			tbl1.Scope = var9
			tbl1.Message = var68.Text
			var75 = tbl1
		end

		bool5 = true
		UpdateSpeechScope()
		if var12 then
			var12.Text = "Filtering and sending the announcement..."
			var12.TextColor3 = str3.Muted
		end

		local var13 = num5 + 1
		num5 = var13
		local var14 = var75
		var6:FireServer(var14.Id, "Announcement", var14.Scope, { Message = var14.Message })
		var13 = num5
		task.delay(15, function()
			if bool6 and (bool5 and (var75 == var14 and num5 == var13)) then
				bool5 = false
				UpdateSpeechScope()
				if var12 then
					var12.Text = "Delivery is not confirmed yet. Retry uses the same request to avoid duplicates."
					local var1 = str3.Error
					var12.TextColor3 = var1 or str3.Muted
				end
			end
		end)
	end)

	local var77 = tbl2.Polls
	local var78 = Stack(var77, "QuestionGroup", 8)
	local var79 = Label(var78, "Label", "2. Write question", 22, 15)
	var79.Font = Enum.Font.GothamBold
	var79 = Field(var78, "Question", "What boost should we do next?")
	CharacterHint(var78, var79, 100)
	ToggleReward = Stack(var77, "DurationGroup", 8)
	local var80 = Label(ToggleReward, "Label", "4. Set voting time", 22, 15)
	var80.Font = Enum.Font.GothamBold
	var80 = Field(ToggleReward, "Duration", "60")
	var80.Text = "60"
	Label(ToggleReward, "Hint", "30\226\128\147600 seconds. One vote per player. Polls collect votes; they do not activate boosts.", 36, 12, str3.Muted)
	local num6 = 30
	local num7 = 60
	local var81 = Create("Frame", { Name = "DurationPresets", Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1 }, ToggleReward)
	for k4, v4 in { num6, num7, 120, 300 }, nil do
		local var82 = Button
		local var83 = var81
		local var84 = "Duration" .. v4
		local var85, var86 = var82(var83, var84, if v4 < 60 then "30 sec" else tostring(v4 / 60) .. " min")
		var86.Size = UDim2.new(0.25, -6, 1, 0)
		var86.Position = UDim2.new((k4 - 1) / 4, (k4 - 1) * 2, 0, 0)
		var85.Activated:Connect(function()
			var80.Text = tostring(v4)
		end)

		var80:GetPropertyChangedSignal("Text"):Connect(function()
			var85:SetAttribute("Selected", tonumber(var80.Text) == v4)
		end)

		var85:SetAttribute("Selected", tonumber(var80.Text) == v4)
	end

	var81 = Stack(var77, "OptionsGroup", 8)
	local var87 = Label(var81, "Label", "3. Add answer options", 22, 15)
	var87.Font = Enum.Font.GothamBold
	Label(var81, "Hint", "2\226\128\1476 unique answers \226\128\162 up to 40 characters each", 28, 12, str3.Muted)
	local var88 = nil
	local tbl25 = {}
	local var89 = nil
	var87 = Stack(var81, "Options", 8)
	local function HidePollPreview()
		if var88 then
			var88()
		end
	end

	local function RefreshOptions()
		for k1, v1 in tbl25, nil do
			v1.Row.LayoutOrder = k1
			v1.Row.Name = "Option" .. k1
			v1.Input.PlaceholderText = "Option " .. k1
			v1.RemoveSlot.Visible = 2 < (#tbl25)
			local var1 = v1.Input
			local var2 = UDim2.new
			local num1 = 1
			var1.Size = var2(num1, if 2 < (#tbl25) then -88 else 0, 0, 42)
		end

		if var89 then
			var89.Interactable = #tbl25 < 6
			local var3 = var89
			var3.Text = if #tbl25 < 6 then "+ Add option" else "6 options maximum"
		end

		if var88 then
			var88()
		end
	end

	local function AddOption()
		local var1 = Create("Frame", { Name = "Option", Size = UDim2.new(1, 0, 0, 66), BackgroundTransparency = 1 }, var87)
		local var2 = Field(var1, "Answer", "")
		local var3 = CharacterHint(var1, var2, 40)
		var3.Position = UDim2.fromOffset(2, 44)
		var3.Size = UDim2.new(1, -88, 0, 18)
		local var4, var5 = Button(var1, "Remove", "Remove")
		var5.AnchorPoint = Vector2.new(0.5, 0.5)
		var5.Position = UDim2.new(1, -38, 0, 21)
		var5.Size = UDim2.fromOffset(76, 38)
		var4.TextSize = 12
		local tbl1 = { Row = var1, Input = var2, RemoveSlot = var5 }
		table.insert(tbl25, tbl1)
		var2:GetPropertyChangedSignal("Text"):Connect(HidePollPreview)
		var4.Activated:Connect(function()
			if 2 < (#tbl25) then
				local var4 = tbl25
				local var5 = tbl1
				table.remove(tbl25, table.find(var4, var5))
				var1:Destroy()
				RefreshOptions()
			end
		end)

		RefreshOptions()
	end

	AddOption()
	AddOption()
	tbl25[1].Input.PlaceholderText = "e.g. Treadmill boost"
	tbl25[2].Input.PlaceholderText = "e.g. 100x speed"
	Button(var81, "AddOption", "+ Add option").Activated:Connect(function()
		if #tbl25 < 6 then
			AddOption()
		end
	end)

	var77.Audience.LayoutOrder = 1
	var78.LayoutOrder = 3
	var81.LayoutOrder = 4
	ToggleReward.LayoutOrder = 5
	local var90 = ActionDock(var24, var77, "PollActions")
	local var91 = Label(var90, "Validation", "", 34, 12, str3.Muted)
	local var92, var93 = Button(var90, "StartPoll", "")
	var93.Position = UDim2.fromOffset(0, 40)
	var93.Size = UDim2.new(1, 0, 0, 44)
	local var94, var95 = Preview(var77)
	local var96 = nil
	local var97 = nil
	var96 = var94
	var96.LayoutOrder = 6
	var97 = var95
	var94 = Stack(var77, "LivePoll", 6)
	var94.LayoutOrder = 2
	var95 = Label(var94, "Label", "Current poll", 22, 14)
	var95.Font = Enum.Font.GothamBold
	var95 = Label(var94, "LiveStatus", "Connecting polls...", 32, 13, str3.Muted)
	var95.AutomaticSize = Enum.AutomaticSize.Y
	local tbl26 = {}
	local function ValidatePollDraft()
		local var1 = utf8.len(var79.Text)
		if not var79.Text:match("%S") then
			return "Write a question to get started.", var79
		end

		if not var1 or 100 < var1 then
			return "Question must fit within 100 characters.", var79
		end

		local tbl1 = {}
		local tbl2 = {}
		for k1, v1 in tbl25, nil do
			local var2 = v1.Input.Text
			local var3 = utf8.len(var2)
			if not var2:match("%S") then
				return "Fill in answer " .. k1 .. ".", v1.Input
			end

			if not var3 or 40 < var3 then
				return "Answer " .. k1 .. " exceeds 40 characters.", v1.Input
			end

			local var4 = var2:lower():match("^%s*(.-)%s*$")
			if tbl1[var4] then
				return "Answer " .. k1 .. " duplicates another answer.", v1.Input
			end

			tbl1[var4] = true
			tbl2[k1] = var2
		end

		local var6 = tonumber(var80.Text)
		if not var6 or (var6 % 1 ~= 0 or (var6 < 30 or 600 < var6)) then
			return "Use a whole duration from 30 to 600 seconds.", var80
		end

		if 512 < (#var10:JSONEncode({ Question = var79.Text, Options = tbl2, Duration = var6 })) then
			return "Poll is too long to send. Shorten the question or answers.", var79
		end

		return nil
	end

	local var98 = nil
	local bool7 = false
	local bool8 = false
	local var99 = Button(var94, "EndPoll", "", true)
	local function RefreshPoll()
		local var2 = tbl26[var77:GetAttribute("Scope")]
		local bool2 = false
		if var2 ~= nil then
			bool2 = not var2.Closed
		end

		local var4 = var98
		local var5 = ValidatePollDraft()
		if var4 then
			var4 = var98.Scope == var77:GetAttribute("Scope")
		end

		local var6 = bool7
		var92.Interactable = var6 and (not bool8 and (not var4 and (not bool2 and (not var5))))
		local var7 = var77:GetAttribute("Scope") == "Global"
		var6 = var92
		local var8
		if bool8 then
			var8 = "Working\226\128\166"
		elseif var4 then
			var8 = "Waiting for poll\226\128\166"
		elseif bool2 then
			var8 = "Poll already running"
		elseif var7 then
			var8 = "Start poll \226\128\162 ALL servers"
		else
			var8 = "Start poll \226\128\162 this server"
		end

		var6.Text = var8
		var6 = var91
		if not bool7 then
			var8 = "Connecting to polls\226\128\166"
		else
			if bool8 then
				var8 = "Waiting for server confirmation\226\128\166"
			elseif var4 then
				var8 = "Your global poll is queued. Waiting for it to appear."
			elseif bool2 then
				var8 = "End the current poll before starting another for this audience."
			else
				var8 = var5
				if not var8 then
					var8 = if var7 then "Ready \226\128\162 voting will open across ALL servers." else "Ready \226\128\162 voting will open in this server."
				end
			end
		end

		var6.Text = var8
		var8 = var5 and str3.Muted or (var7 and Color3.fromRGB(255, 207, 128) or str3.Muted)
		var91.TextColor3 = var8
		var8 = true
		var94.Visible = var2 == nil and (not bool7)
		var6 = var99.Parent
		var8 = false
		if var2 ~= nil then
			var8 = not var2.Closed
		end

		var6.Visible = var8
		var8 = bool7
		var99.Interactable = var8 and (not bool8 and (bool2 and (not var2.Closing)))
		if var2 then
			var6 = 0
			for k1, v1 in var2.Counts, nil do
				var6 = var6 + v1
			end

			var8 = var95
			local var9 = var2.Question
			local str1 = " \226\128\162 "
			local var10 = var6
			local str2 = " votes"
			local var11
			if var2.Closed then
				var11 = " \226\128\162 Ended"
			elseif var2.Closing then
				var11 = " \226\128\162 Counting results..."
			else
				var11 = ""
			end

			var8.Text = var9 .. str1 .. var10 .. str2 .. var11
			return
		end

		var6 = var95
		var6.Text = if bool7 then "No active poll for this audience." else "Connecting polls..."
	end

	var80:GetPropertyChangedSignal("Text"):Connect(HidePollPreview)
	var88 = function()
		local str1 = "%S"
		local tbl1 = { var79.Text:match(str1) and var79.Text or "Your question will appear here.", "" }
		for k1, v1 in tbl25, nil do
			table.insert(tbl1, tostring(k1) .. ". " .. (v1.Input.Text:match("%S") and v1.Input.Text or "Answer " .. k1))
		end

		table.insert(tbl1, [[
Voting time: ]] .. var80.Text .. " seconds")

		var97.Text = table.concat(tbl1, [[
]])

		var96.Visible = true
		RefreshPoll()
	end

	local var100 = nil
	var100 = function()
		local var2 = var77:GetAttribute("Scope") == "Global"
		local var3 = var92
		var3.Text = if var2 then "Start global poll" else "Start server poll"
		var3 = var99
		var3.Text = if var2 then "End global poll" else "End server poll"
		if var88 then
			var88()
		end

		RefreshPoll()
	end

	var77:GetAttributeChangedSignal("Scope"):Connect(var100)
	var79:GetPropertyChangedSignal("Text"):Connect(HidePollPreview)
	var100()
	local var101 = nil
	local var102 = nil
	local num8 = 0
	local bool9 = true
	local function SubmitPoll(arg1, arg2)
		if bool8 then
			return
		end

		local var2 = var11:FindFirstChild("AdminRequest")
		if var2 then
			if not var101 or (not bool7) then
				if var12 then
					var12.Text = "Polls are still connecting. Try again shortly."
					local var3 = str3.Error
					var12.TextColor3 = var3 or str3.Muted
				end

				return
			end
		end

		local var4 = var10:JSONEncode(arg2)
		local var5 = var77:GetAttribute("Scope")
		if 512 < (#var4) then
			if var12 then
				var12.Text = "The poll is too long. Shorten the question or answers."
				local var6 = str3.Error
				var12.TextColor3 = var6 or str3.Muted
			end

			return
		end

		if not var102 or (var102.Name ~= arg1 or (var102.Scope ~= var5 or var102.Signature ~= var4)) then
			local tbl1 = { Id = var10:GenerateGUID(false) }
			tbl1.Name = arg1
			tbl1.Scope = var5
			tbl1.Payload = arg2
			tbl1.Signature = var4
			var102 = tbl1
		end

		bool8 = true
		local var7 = num8 + 1
		num8 = var7
		RefreshPoll()
		var7 = num8
		local var8 = var102
		local var9 = if arg1 == "StartPoll" then "Filtering and starting the poll..." else "Ending the poll..."
		if var12 then
			var12.Text = var9
			var12.TextColor3 = str3.Muted
		end

		var2:FireServer(var8.Id, var8.Name, var8.Scope, var8.Payload)
		task.delay(15, function()
			if bool9 and (bool8 and (var102 == var8 and num8 == var7)) then
				bool8 = false
				RefreshPoll()
				if var12 then
					var12.Text = "Delivery is not confirmed. Click again to retry the same request safely."
					local var1 = str3.Error
					var12.TextColor3 = var1 or str3.Muted
				end
			end
		end)
	end

	var92.Activated:Connect(function()
		if not var92.Interactable then
			return
		end

		local var3, var4 = ValidatePollDraft()
		if var3 then
			if var12 then
				var12.Text = var3
				local var5 = str3.Error
				var12.TextColor3 = var5 or str3.Muted
			end

			if var4 then
				var4:CaptureFocus()
			end

			return
		end

		local var7 = tonumber(var80.Text)
		if var7 then
			if var7 % 1 ~= 0 or (var7 < 30 or 600 < var7) then
				if var12 then
					var12.Text = "Set the duration to a whole number from 30 to 600 seconds."
					local var8 = str3.Error
					var12.TextColor3 = var8 or str3.Muted
				end

				var80:CaptureFocus()
				return
			end
		end

		local var10 = utf8.len(var79.Text)
		if var79.Text:match("%S") then
			if not var10 or 100 < var10 then
				if var12 then
					var12.Text = "Write a question up to 100 characters."
					local var11 = str3.Error
					var12.TextColor3 = var11 or str3.Muted
				end

				var79:CaptureFocus()
				return
			end
		end

		local tbl1 = {}
		local tbl2 = {}
		for k1, v1 in tbl25, nil do
			local var13 = v1.Input.Text
			local var15 = utf8.len(var13)
			if var13:match("%S") then
				if not var15 or (40 < var15 or tbl2[var13:lower()]) then
					if var12 then
						var12.Text = "Use different answers with up to 40 characters each."
						local var16 = str3.Error
						var12.TextColor3 = var16 or str3.Muted
					end

					v1.Input:CaptureFocus()
					return
				end
			end

			local var17 = var13:lower()
			tbl2[var17] = true
			tbl1[k1] = var13
		end

		SubmitPoll("StartPoll", { Question = var79.Text, Options = tbl1, Duration = var7 })
	end)

	var99.Activated:Connect(function()
		if not var99.Interactable then
			return
		end

		local var2 = tbl26[var77:GetAttribute("Scope")]
		if var2 and (not var2.Closed) then
			SubmitPoll("EndPoll", { Id = var2.Id })
		end
	end)

	local var103 = nil
	var77.Destroying:Once(function()
		bool9 = false
		if var103 then
			var103:Disconnect()
		end

		if var101 then
			var101:Disconnect()
		end
	end)

	task.spawn(function()
		local var2 = var11:WaitForChild("AdminPollState")
		local var3 = var11:WaitForChild("AdminPollAction")
		local var4 = var11:WaitForChild("AdminResponse")
		if not bool9 then
			return
		end

		var103 = var2.OnClientEvent:Connect(function(arg1)
			if type(arg1) ~= "table" or arg1.Kind ~= "State" then
				return
			end

			tbl26 = { Server = arg1.Server, Global = arg1.Global }
			bool7 = true
			local var2 = tbl26[var98.Scope]
			if var98 and (var2 and (var2.Id == var98.Id or (not var2.Closed))) then
				var98 = nil
			end

			RefreshPoll()
		end)

		var101 = var4.OnClientEvent:Connect(function(arg1)
			if type(arg1) ~= "table" or (not var102 or arg1.RequestId ~= var102.Id) then
				return
			end

			if arg1.Status == "Processing" then
				return
			end

			bool8 = false
			local var3 = tbl26.Global
			if arg1.Success and (var102.Name == "StartPoll" and (var102.Scope == "Global" and (not var3 or var3.Id ~= tostring(var1.UserId) .. ":" .. var102.Id))) then
				local tbl1 = { Scope = "Global", Id = tostring(var1.UserId) .. ":" .. var102.Id }
				var98 = tbl1
				tbl1 = var98
				task.delay(35, function()
					if bool9 and var98 == tbl1 then
						var98 = nil
						RefreshPoll()
						if var12 then
							var12.Text = "The queued poll has not appeared yet. Check server output before starting another."
							local var1 = str3.Error
							var12.TextColor3 = var1 or str3.Muted
						end
					end
				end)

			end

			if arg1.Status ~= "OutcomeUnknown" then
				var102 = nil
			end

			RefreshPoll()
			var3 = arg1.Message or "The poll request could not finish."
			local var4 = arg1.Success ~= true
			if var12 then
				var12.Text = var3
				var12.TextColor3 = var4 and str3.Error or str3.Muted
			end
		end)

		var3:FireServer("Sync")
	end)

	local var104 = tbl2.Treadmill
	local var105 = Stack(var104, "Settings", 8)
	local var106 = Label(var105, "MultiplierLabel", "2. Event multiplier", 22, 15)
	var106.Font = Enum.Font.GothamBold
	var106 = Field(var105, "Multiplier", "100")
	var106.Text = "100"
	local var107 = Label(var105, "DurationLabel", "3. Duration in minutes", 22, 15)
	var107.Font = Enum.Font.GothamBold
	var107 = Field(var105, "Minutes", "10")
	var107.Text = "10"
	Label(var104, "Explanation", "Everyone can use it. Your own treadmill's gain \195\151 event multiplier, with all normal bonuses and click boosts. Running locks your position; jump to leave.", 60, 13, str3.Muted)
	local var108 = Stack(var104, "LiveEvent", 8)
	local var109 = Label(var108, "Title", "Current event", 22, 15)
	var109.Font = Enum.Font.GothamBold
	local var110 = ActionDock(var24, var104, "TreadmillActions")
	var109 = Label(var108, "Details", "Connecting\226\128\166", 52, 14)
	local var111 = Button(var108, "StopEvent", "Stop event", true)
	local var112 = Label(var110, "Hint", "", 34, 12, str3.Muted)
	local var113, var114 = Button(var110, "StartEvent", "Start treadmill event", true)
	var114.Position = UDim2.fromOffset(0, 40)
	var114.Size = UDim2.new(1, 0, 0, 44)
	local tbl27 = {}
	local bool10 = false
	local bool11 = false
	local bool12 = false
	local var115 = nil
	local var116 = nil
	local num9 = 0
	local function Refresh()
		local var1 = var104:GetAttribute("Scope")
		local var2 = tbl27.Server
		local var3 = tonumber(var106.Text)
		local var6 = var3
		local var7 = tbl27[var1]
		var2 = var2 or tbl27.Global
		local var8 = tonumber(var107.Text)
		if var6 then
			var6 = false
			if var3 == var3 then
				var6 = false
				if 0 < var3 then
					var6 = var3 < math.huge
				end
			end
		end

		if var6 then
			var6 = var8
			if var6 then
				var6 = false
				if var8 == var8 then
					var6 = false
					if 0 < var8 then
						var6 = var8 < math.huge
					end
				end
			end

			if var6 then
				local var10 = var8 * 60
				var6 = var10
				if var6 then
					var6 = false
					if var10 == var10 then
						var6 = false
						if 0 < var10 then
							var6 = var10 < math.huge
						end
					end
				end
			end
		end

		local var12 = bool10
		local var13 = var113
		if var12 then
			if var1 ~= "Server" then
				var12 = bool11
				var12 = var12 and (not bool12 and (not var2 and var6))
			end

			var12 = not bool12
			var12 = var12 and (not var2 and var6)
		end

		var13.Interactable = var12
		var12 = bool10
		var13 = var111
		if var12 then
			var12 = not bool12
			if var12 then
				var12 = var7 ~= nil
			end
		end

		var13.Interactable = var12
		var111.Parent.Visible = var7 ~= nil
		var13 = var113
		if bool12 then
			var12 = "Working\226\128\166"
		elseif var2 then
			var12 = "Event already active"
		elseif var1 == "Global" then
			var12 = "Start event \226\128\162 ALL servers"
		else
			var12 = "Start event \226\128\162 this server"
		end

		var13.Text = var12
		var13 = var111
		var13.Text = if var1 == "Global" then "Stop global event" else "Stop server event"
		var13 = var112
		if not bool10 then
			var12 = "Connecting to event status\226\128\166"
		else
			if var1 == "Global" and (not bool11) then
				var12 = "Global event status is unavailable. Try again shortly."
			else
				if bool12 then
					var12 = "Waiting for server confirmation\226\128\166"
				elseif var2 then
					var12 = "Stop the active event or wait for it to finish."
				elseif not var6 then
					var12 = "Enter positive numbers for multiplier and minutes."
				else
					var12 = "Ready \226\128\162 one treadmill event at a time."
				end
			end
		end

		var13.Text = var12
		if var7 then
			var109.Text = var4.Format(var7.Multiplier) .. "x \226\128\162 " .. math.max(0, (math.ceil((var7.EndsAt - workspace:GetServerTimeNow()) / 60))) .. " min remaining"
			return
		end

		var13 = var109
		if var2 then
			var12 = "An event is active for the other audience."
		elseif bool10 then
			var12 = "No active event."
		else
			var12 = "Connecting\226\128\166"
		end

		var13.Text = var12
	end

	local bool13 = true
	local function Submit(arg1, arg2)
		if bool12 or (not bool10) then
			return
		end

		local var2 = var11:FindFirstChild("AdminRequest")
		if var2 then
			if not var115 then
				if var12 then
					var12.Text = "Event controls are still connecting."
					local var3 = str3.Error
					var12.TextColor3 = var3 or str3.Muted
				end

				return
			end
		end

		local var6 = var104:GetAttribute("Scope")
		local var7 = var10:JSONEncode(arg2)
		if not var116 or (var116.Name ~= arg1 or (var116.Scope ~= var6 or var116.Signature ~= var7)) then
			local tbl1 = { Id = var10:GenerateGUID(false) }
			tbl1.Name = arg1
			tbl1.Scope = var6
			tbl1.Payload = arg2
			tbl1.Signature = var7
			var116 = tbl1
		end

		bool12 = true
		local var8 = num9 + 1
		num9 = var8
		Refresh()
		var8 = var116
		local var9 = num9
		local var13 = if arg1 == "StartTreadmill" then "Starting treadmill event\226\128\166" else "Stopping treadmill event\226\128\166"
		if var12 then
			var12.Text = var13
			var12.TextColor3 = str3.Muted
		end

		var2:FireServer(var8.Id, var8.Name, var8.Scope, var8.Payload)
		task.delay(15, function()
			if bool13 and (bool12 and (var116 == var8 and num9 == var9)) then
				bool12 = false
				Refresh()
				if var12 then
					var12.Text = "Delivery is not confirmed. Click again to retry the same request."
					local var1 = str3.Error
					var12.TextColor3 = var1 or str3.Muted
				end
			end
		end)
	end

	var113.Activated:Connect(function()
		if not var113.Interactable then
			return
		end

		local tbl1 = { Multiplier = tonumber(var106.Text) }
		tbl1.Minutes = tonumber(var107.Text)
		Submit("StartTreadmill", tbl1)
	end)

	var111.Activated:Connect(function()
		local var2 = tbl27[var104:GetAttribute("Scope")]
		if var111.Interactable and var2 then
			Submit("StopTreadmill", { Id = var2.Id })
		end
	end)

	var106:GetPropertyChangedSignal("Text"):Connect(Refresh)
	var107:GetPropertyChangedSignal("Text"):Connect(Refresh)
	var104:GetAttributeChangedSignal("Scope"):Connect(Refresh)
	local var117 = nil
	var104.Destroying:Once(function()
		bool13 = false
		if var117 then
			var117:Disconnect()
		end

		if var115 then
			var115:Disconnect()
		end
	end)

	task.spawn(function()
		local var1 = var11:WaitForChild("AdminTreadmillState")
		local var2 = var11:WaitForChild("AdminTreadmillAction")
		local var3 = var11:WaitForChild("AdminResponse")
		if not bool13 then
			return
		end

		var117 = var1.OnClientEvent:Connect(function(arg1)
			if type(arg1) ~= "table" or arg1.Kind ~= "State" then
				return
			end

			tbl27 = { Server = arg1.Server, Global = arg1.Global }
			bool10 = true
			bool11 = arg1.Connected == true
			Refresh()
		end)

		var115 = var3.OnClientEvent:Connect(function(arg1)
			if type(arg1) ~= "table" or (not var116 or var116.Id ~= arg1.RequestId) then
				return
			end

			if arg1.Status == "Processing" then
				return
			end

			bool12 = false
			if arg1.Status ~= "OutcomeUnknown" then
				var116 = nil
			end

			Refresh()
			local var1 = arg1.Message or "The event request could not finish."
			local var3 = arg1.Success ~= true
			if var12 then
				var12.Text = var1
				var12.TextColor3 = var3 and str3.Error or str3.Muted
			end

			var2:FireServer("Sync")
		end)

		var2:FireServer("Sync")
	end)

	Refresh()
	SelectPage("Crates")
	var13 = Create("TextChatCommand", { Name = "AdminPanelCommand", PrimaryAlias = "/panel", AutocompleteVisible = false }, var8)
	var13.Triggered:Connect(function(arg1)
		if arg1 then
			if arg1.UserId == var1.UserId then
				if str4 then
					if var1:GetAttribute("AdminPanelAccess") ~= true then
						return
					end

					var7:GetFocusedTextBox()
					str4.Enabled = true
				end
			end
		end
	end)

	str4.Parent = var5
	tbl1()
end

local function RefreshAccess()
	if var1:GetAttribute("AdminPanelAccess") == true then
		if not not str4 then
			return
		end

		BuildPanel()
		return
	end

	if str4 then

		local var3 = var7:GetFocusedTextBox()
		if var3 and var3:IsDescendantOf(str4) then
			var3:ReleaseFocus()
		end

		str4.Enabled = false
	end

	if var13 then
		var13:Destroy()
		var13 = nil
	end

	if str4 then
		str4:Destroy()
		str4 = nil
		var12 = nil
	end
end

var1:GetAttributeChangedSignal("AdminPanelAccess"):Connect(RefreshAccess)
RefreshAccess()
local function SetOpen(arg1)
	if not str4 or arg1 and var1:GetAttribute("AdminPanelAccess") ~= true then
		return
	end

	local var3 = var7:GetFocusedTextBox()
	if not arg1 and (var3 and var3:IsDescendantOf(str4)) then
		var3:ReleaseFocus()
	end

	str4.Enabled = arg1
end

var7.InputBegan:Connect(function(arg1, arg2)
	if not arg2 then
		if not var7:GetFocusedTextBox() then
			if arg1.KeyCode == Enum.KeyCode.G then
				SetOpen(str4 and (not str4.Enabled))
			end
		end
	end
end)

--- Players.LocalPlayer.PlayerScripts.AdminAnnouncementController [LocalScript]
-- y u r i

local var1 = nil
local var2 = nil
local tbl1 = {}
local num1 = 0
local var3 = utf8.char(57344)
local var4 = game:GetService("TweenService")
local function RefreshVisibility()
	for k1, v1 in var1:GetChildren() do
		if not v1:IsA("GuiObject") or v1 == var2 then
			continue
		end

		if not v1.Visible then
			continue
		end

		var1.Visible = true
		return
	end

	var1.Visible = false
end

local tbl2 = {}
local function Show(arg1, arg2)
	local var6 = 7 - (os.clock() - arg2)
	if var6 <= 0 then
		return
	end

	if 3 <= (#tbl1) then
		table.remove(tbl1, 1).Close()
	end

	local var7 = num1 + 1
	num1 = var7
	var7 = var2:Clone()
	var7.Name = "Announcement" .. num1
	var7.LayoutOrder = num1
	var7.Visible = true
	local var8 = var7.AdminDisplayName
	var8.Text = arg1.AdminDisplayName .. var3 .. ": " .. arg1.Message
	var8.RichText = false
	var8.TextWrapped = true
	var8.TextScaled = true
	var8.UITextSizeConstraint.MinTextSize = 10
	local var9 = table.unpack(var7:GetDescendants())
	local tbl2 = {}
	for k1, v1 in { var7, var9 }, nil do
		local tbl3 = {}
		if v1:IsA("GuiObject") then
			tbl3.BackgroundTransparency = v1.BackgroundTransparency
		end

		if v1:IsA("TextLabel") then
			tbl3.TextTransparency = v1.TextTransparency
			tbl3.TextStrokeTransparency = v1.TextStrokeTransparency
		else
			if v1:IsA("ImageLabel") then
				tbl3.ImageTransparency = v1.ImageTransparency
			else
				if v1:IsA("UIStroke") then
					tbl3.Transparency = v1.Transparency
				end
			end
		end

		if not next(tbl3) then
			continue
		end

		table.insert(tbl2, { Object = v1, Properties = tbl3 })
	end

	local var10 = Instance.new("NumberValue")
	var10.Name = "AnnouncementFade"
	var10.Value = 1
	var10.Parent = var7
	local var11 = Instance.new("UIScale")
	var11.Scale = 0.96
	var11.Parent = var7
	local function SetFade(arg1)
		for k1, v1 in tbl2, nil do
			for k2, v2 in v1.Properties, nil do
				v1.Object[k2] = v2 + (1 - v2) * arg1
			end
		end
	end

	var10.Changed:Connect(SetFade)
	SetFade(1)
	local var12 = var4:Create(var10, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Value = 0 })
	local var13 = var4:Create(var11, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	local bool1 = false
	local tbl4 = { Message = var7 }
	tbl4.Close = function()
		if bool1 or (not var7.Parent) then
			return
		end

		bool1 = true
		var12:Cancel()
		var13:Cancel()
		var12 = var4:Create(var10, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Value = 1 })
		var13 = var4:Create(var11, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.97 })
		var12:Play()
		var13:Play()
		task.delay(0.18, function()
			local var2 = table.find(tbl1, tbl4)
			if var2 then
				table.remove(tbl1, var2)
			end

			var7:Destroy()
			RefreshVisibility()
		end)
	end

	var7.Destroying:Once(function()
		var12:Cancel()
		var13:Cancel()
	end)

	table.insert(tbl1, tbl4)
	var7.Parent = var1
	var1.Visible = true
	var12:Play()
	var13:Play()
	task.delay(math.max(0, var6 - 0.18), tbl4.Close)
end

local tbl3 = {}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("AdminAnnouncement").OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" or (type(arg1.Id) ~= "string" or (type(arg1.Message) ~= "string" or (type(arg1.AdminDisplayName) ~= "string" or tbl2[arg1.Id]))) then
		return
	end

	tbl2[arg1.Id] = true
	task.delay(120, function()
		tbl2[arg1.Id] = nil
	end)

	local var3 = os.clock()
	if var1 then
		Show(arg1, var3)
		return
	end

	if 3 <= (#tbl3) then
		table.remove(tbl3, 1)
	end

	table.insert(tbl3, { Data = arg1, ReceivedAt = var3 })
end)

local var5 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("AdminMessages")
var2 = var5:WaitForChild("MessageTemplate")
var2.Visible = false
RefreshVisibility()
for k1, v1 in tbl3, nil do
	Show(v1.Data, v1.ReceivedAt)
end

table.clear(tbl3)

--- Players.LocalPlayer.PlayerScripts.AdminPollController [LocalScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events")
local var2 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("AdminMessages")
local var3 = var2:WaitForChild("MessageTemplate")
local tbl1 = {}
local var4 = game:GetService("TweenService")
local tbl2 = {}
local function Animate(arg1, arg2)
	if arg1.FadeTween then
		arg1.FadeTween:Cancel()
		arg1.ScaleTween:Cancel()
	end

	local var1 = var4
	local var2 = arg1.Fade
	local var3 = TweenInfo.new
	var3 = var3(if arg2 then 0.18 else 0.2, Enum.EasingStyle.Quad, arg2 and Enum.EasingDirection.In or Enum.EasingDirection.Out)
	arg1.FadeTween = var1:Create(var2, var3, { Value = if arg2 then 1 else 0 })
	var1 = var4
	var2 = arg1.Scale
	var3 = TweenInfo.new
	var3 = var3(if arg2 then 0.18 else 0.24, arg2 and Enum.EasingStyle.Quad or Enum.EasingStyle.Back, arg2 and Enum.EasingDirection.In or Enum.EasingDirection.Out)
	arg1.ScaleTween = var1:Create(var2, var3, { Scale = if arg2 then 0.97 else 1 })
	arg1.FadeTween:Play()
	arg1.ScaleTween:Play()
end

local function RefreshVisibility()
	for k1, v1 in var2:GetChildren() do
		if not v1:IsA("GuiObject") or v1 == var3 then
			continue
		end

		if not v1.Visible then
			continue
		end

		var2.Visible = true
		return
	end

	var2.Visible = false
end

local var5 = utf8.char(57344)
local tbl3 = {}
local var6 = var1:WaitForChild("AdminPollAction")
local function Close(arg1)
	if arg1.Closing then
		return
	end

	arg1.Closing = true
	tbl2[arg1.Scope] = nil
	for k1, v1 in arg1.Rows, nil do
		v1.Button.Interactable = false
	end

	Animate(arg1, true)
	task.delay(0.18, function()
		arg1.Frame:Destroy()
		RefreshVisibility()
	end)
end

local function Build(arg1, arg2)
	local var1 = Instance.new("Frame")
	var1.Name = arg2 .. "PollNotification"
	var1:SetAttribute("WindowEffectsManaged", true)
	var1.AnchorPoint = Vector2.new(0.5, 0.5)
	var1.Size = UDim2.new(var3.Size.X.Scale, var3.Size.X.Offset, 0, 0)
	var1.AutomaticSize = Enum.AutomaticSize.Y
	var1.BackgroundTransparency = 1
	var1.LayoutOrder = if arg2 == "Global" then 1000000 else 1000001
	local tbl1 = { MinSize = Vector2.new(280, 0) }
	tbl1.MaxSize = Vector2.new(620, 1000)
	local var4 = Instance.new("UISizeConstraint")
	for k1, v1 in tbl1, nil do
		var4[k1] = v1
	end

	local var7
	if var4:IsA("GuiButton") then
		var7 = true
		var4:SetAttribute("UIEffectsIgnore", var7)
	end

	var4.Parent = var1
	tbl1 = { Padding = UDim.new(0, 6) }
	tbl1.SortOrder = Enum.SortOrder.LayoutOrder
	tbl1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	var4 = Instance.new("UIListLayout")
	for k2, v2 in tbl1, nil do
		var4[k2] = v2
	end

	if var4:IsA("GuiButton") then
		var4:SetAttribute("UIEffectsIgnore", true)
	end

	var4.Parent = var1
	tbl1 = var3:Clone()
	tbl1.Name = "Question"
	tbl1.LayoutOrder = 1
	tbl1.Size = UDim2.new(1, 0, 0, 44)
	tbl1.AutomaticSize = Enum.AutomaticSize.Y
	tbl1.Visible = true
	var4 = tbl1.AdminDisplayName
	var4.Text = (arg1.AdminDisplayName or "Admin") .. var5 .. ": " .. arg1.Question
	var4.RichText = false
	var4.Size = UDim2.new(1, 0, 0, 44)
	var4.AutomaticSize = Enum.AutomaticSize.Y
	var4.TextScaled = false
	var4.TextSize = 22
	var4.TextWrapped = true
	var4.UITextSizeConstraint.MaxTextSize = 22
	tbl1.Parent = var1
	local var8 = #arg1.Options / 2
	local num1 = 0
	local var9 = math.ceil(var8) * 44 - 6
	local var10 = Instance.new("Frame")
	for k3, v3 in {
		Name = "Answers",
		Size = UDim2.new(1, 0, num1, var9),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
	}, nil do

		var10[k3] = v3
	end

	if var10:IsA("GuiButton") then
		var10:SetAttribute("UIEffectsIgnore", true)
	end

	var10.Parent = var1
	local num2 = 0
	local num3 = 38
	local tbl4 = { CellSize = UDim2.new(0.5, -3, num2, num3), FillDirectionMaxCells = 2 }
	tbl4.CellPadding = UDim2.fromOffset(6, 6)
	tbl4.SortOrder = Enum.SortOrder.LayoutOrder
	tbl4.HorizontalAlignment = Enum.HorizontalAlignment.Center
	local var11 = Instance.new("UIGridLayout")
	for k4, v4 in tbl4, nil do
		var11[k4] = v4
	end

	if var11:IsA("GuiButton") then
		var11:SetAttribute("UIEffectsIgnore", true)
	end

	var11.Parent = var10
	tbl4 = function()
		local var2 = if 0 < var1.AbsoluteSize.X and var1.AbsoluteSize.X < 420 then 1 else 2
		var11.FillDirectionMaxCells = var2
		local var3 = var11
		local var4 = UDim2.new
		local var5 = 1 / var2
		var3.CellSize = var4(var5, if var2 == 2 then -3 else 0, 0, 38)
		var10.Size = UDim2.new(1, 0, 0, math.ceil(#arg1.Options / var2) * 44 - 6)
	end

	var1:GetPropertyChangedSignal("AbsoluteSize"):Connect(tbl4)
	tbl4()
	local var12 = var3.AdminDisplayName:Clone()
	var12.Name = "Timer"
	local num4 = 18
	var12.Size = UDim2.new(1, 0, 0, num4)
	var12.AutomaticSize = Enum.AutomaticSize.None
	var12.TextScaled = false
	var12.TextSize = 14
	var12.TextXAlignment = Enum.TextXAlignment.Center
	var12.RichText = false
	var12.Text = ""
	var12.LayoutOrder = 3
	var12.Parent = var1
	local tbl5 = { Id = arg1.Id, Scope = arg2, Frame = var1, Timer = var12, Rows = {} }
	for k5, v5 in arg1.Options, nil do
		local var13 = Instance.new("Frame")
		for k6, v6 in { Name = "Answer" .. k5, BackgroundTransparency = 1, LayoutOrder = k5 }, nil do
			var13[k6] = v6
		end

		if var13:IsA("GuiButton") then
			var13:SetAttribute("UIEffectsIgnore", true)
		end

		var13.Parent = var10
		local tbl6 = {
			Name = "Vote",
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
		}

		tbl6.Position = UDim2.fromScale(0.5, 0.5)
		tbl6.Size = UDim2.fromScale(1, 1)
		local num5 = 255
		tbl6.BackgroundColor3 = Color3.fromRGB(45, 174, num5)
		local var14 = Instance.new("TextButton")
		for k7, v7 in tbl6, nil do
			var14[k7] = v7
		end

		if var14:IsA("GuiButton") then
			var14:SetAttribute("UIEffectsIgnore", true)
		end

		var14.Parent = var13
		local var15 = Instance.new("UICorner")
		for k8, v8 in { CornerRadius = UDim.new(0, 6) }, nil do
			var15[k8] = v8
		end

		if var15:IsA("GuiButton") then
			var15:SetAttribute("UIEffectsIgnore", true)
		end

		var15.Parent = var14
		local num6 = 255
		tbl6 = Instance.new("UIStroke")
		for k9, v9 in { Color = Color3.fromRGB(132, 193, num6), Transparency = 0.2, Thickness = 2 }, nil do
			tbl6[k9] = v9
		end

		if tbl6:IsA("GuiButton") then
			tbl6:SetAttribute("UIEffectsIgnore", true)
		end

		tbl6.Parent = var14
		local num7 = 205
		local num8 = 225
		local num9 = 255
		local tbl7 = {
			Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(num7, num8, num9)),
			Rotation = 90,
		}

		local var16 = Instance.new("UIGradient")
		for k10, v10 in tbl7, nil do
			var16[k10] = v10
		end

		if var16:IsA("GuiButton") then
			var16:SetAttribute("UIEffectsIgnore", true)
		end

		var16.Parent = var14
		var15 = var3.AdminDisplayName:Clone()
		var15.Name = "AnswerText"
		var15.Size = UDim2.new(1, -56, 1, -4)
		var15.Position = UDim2.new(0, 7, 0.5, 0)
		var15.AnchorPoint = Vector2.new(0, 0.5)
		var15.AutomaticSize = Enum.AutomaticSize.None
		var15.Text = v5
		var15.RichText = false
		var15.TextWrapped = true
		var15.TextScaled = true
		var15.TextXAlignment = Enum.TextXAlignment.Left
		var15.UITextSizeConstraint.MinTextSize = 10
		var15.UITextSizeConstraint.MaxTextSize = 18
		var15.Parent = var14
		var16 = var15:Clone()
		var16.Name = "Percent"
		var16.AnchorPoint = Vector2.new(1, 0.5)
		var16.Position = UDim2.new(1, -7, 0.5, 0)
		local num10 = 1
		var16.Size = UDim2.new(0, 39, num10, -4)
		var16.TextXAlignment = Enum.TextXAlignment.Right
		var16.Text = "0%"
		var16.Parent = var14
		tbl5.Rows[k5] = { Button = var14, Percent = var16, Stroke = tbl6 }
		num7 = function()
			local var2 = tbl3[arg2]
			if tbl5.Closing or (tbl5.Pending or (not var2 or (var2.Id ~= tbl5.Id or (var2.Choice or (var2.Closed or (var2.Closing or (var2.Connected == false or var2.EndsAt <= workspace:GetServerTimeNow()))))))) then
				return
			end

			local tbl1 = {}
			tbl5.Pending = tbl1
			tbl5.Notice = "Sending vote..."
			tbl5.NoticeUntil = os.clock() + 10
			for k1, v1 in tbl5.Rows, nil do
				v1.Button.Interactable = false
			end

			var6:FireServer("Vote", arg2, tbl5.Id, k5)
			task.delay(8, function()
				if not tbl5.Closing and tbl5.Pending == tbl1 then
					tbl5.Pending = nil
					tbl5.Notice = "Tap again to retry your vote"
					tbl5.NoticeUntil = os.clock() + 5
				end
			end)
		end

		var14.Activated:Connect(num7)
	end

	local var17 = Instance.new("NumberValue")
	for k11, v11 in { Value = 1 }, nil do
		var17[k11] = v11
	end

	local var18
	if var17:IsA("GuiButton") then
		var18 = true
		var17:SetAttribute("UIEffectsIgnore", var18)
	end

	var17.Parent = var1
	tbl5.Fade = var17
	var17 = Instance.new("UIScale")
	for k12, v12 in { Scale = 0.96 }, nil do
		var17[k12] = v12
	end

	if var17:IsA("GuiButton") then
		var17:SetAttribute("UIEffectsIgnore", true)
	end

	var17.Parent = var1
	tbl5.Scale = var17
	local var19 = table.unpack(var1:GetDescendants())
	var17 = {}
	for k13, v13 in { var1, var19 }, nil do
		local tbl8 = {}
		if v13:IsA("GuiObject") then
			tbl8.BackgroundTransparency = v13.BackgroundTransparency
		end

		if v13:IsA("TextLabel") then
			tbl8.TextTransparency = v13.TextTransparency
			tbl8.TextStrokeTransparency = v13.TextStrokeTransparency
		else
			if v13:IsA("UIStroke") then
				tbl8.Transparency = v13.Transparency
			end
		end

		if not next(tbl8) then
			continue
		end

		table.insert(var17, { Object = v13, Properties = tbl8 })
	end

	local function SetFade(arg1)
		for k1, v1 in var17, nil do
			for k2, v2 in v1.Properties, nil do
				v1.Object[k2] = v2 + (1 - v2) * arg1
			end
		end
	end

	tbl5.Fade.Changed:Connect(SetFade)
	SetFade(1)
	var1.Destroying:Once(function()
		if tbl5.FadeTween then
			tbl5.FadeTween:Cancel()
			tbl5.ScaleTween:Cancel()
		end
	end)

	tbl2[arg2] = tbl5
	var1.Parent = var2
	RefreshVisibility()
	Animate(tbl5, false)
	return tbl5
end

local var7 = var1:WaitForChild("AdminPollState")
var3.Visible = false
RefreshVisibility()
local function Render()
	local var1 = tbl3.Server
	local var4 = var1
	local var5 = workspace:GetServerTimeNow()
	if var4 then
		var4 = not var1.Closed
		if not var4 then
			var4 = var5 < (tbl1[var1.Id] or 0)
		end
	end

	if var4 then
		var1 = tbl3.Global
		var4 = var1
		if var4 then
			var4 = not var1.Closed
			if not var4 then
				var4 = var5 < (tbl1[var1.Id] or 0)
			end
		end
	end

	local str1 = "Server"
	for k1, v1 in { "Global", str1 }, nil do
		local var8 = tbl2[v1]
		local var9 = tbl3[v1]
		if var8 then
			local var11 = var9
			if var11 then
				var11 = not var9.Closed
				if not var11 then
					var11 = var5 < (tbl1[var9.Id] or 0)
				end
			end

			if not var11 or var8.Id ~= var9.Id then
				Close(var8)
				var8 = nil
			end
		end

		local var13 = var9
		if var13 then
			var13 = not var9.Closed
			if not var13 then
				var13 = var5 < (tbl1[var9.Id] or 0)
			end
		end

		if not var13 then
			continue
		end

		var13 = var8
		var8 = var13 or Build(var9, v1)
		if var9.Closed then
			var8.Pending = nil
			var8.Notice = nil
		end

		var13 = 0
		local num1 = 0
		for k2, v2 in var9.Counts, nil do
			local var14 = math.max(num1, v2)
			var13 = var13 + v2
			num1 = var14
		end

		local var16 = not var9.Closed
		if var16 then
			var16 = not var9.Closing
			if var16 then
				var16 = false
				if var5 < var9.EndsAt then
					var16 = var9.Connected ~= false
				end
			end
		end

		for k3, v3 in var8.Rows, nil do
			local var17 = v3.Percent
			if 0 < var13 then
				local var18 = math.floor(var9.Counts[k3] / var13 * 100 + 0.5)
				var18 = var18 or 0
			end

			var17.Text = 0 .. "%"
			local var19 = var16
			v3.Button.Interactable = var19 and (not var9.Choice and (not var8.Pending))
			v3.Button.Selectable = v3.Button.Interactable
			var17 = var9.Closed
			if var17 then
				var17 = false
				if 0 < var13 then
					var17 = var9.Counts[k3] == num1
				end
			end

			local var20 = var17 and Color3.fromRGB(255, 202, 45) or (var9.Choice == k3 and Color3.fromRGB(65, 225, 105) or Color3.fromRGB(45, 174, 255))
			v3.Button.BackgroundColor3 = var20
			var20 = var17 and Color3.fromRGB(255, 223, 126) or (var9.Choice == k3 and Color3.fromRGB(118, 255, 155) or Color3.fromRGB(132, 193, 255))
			v3.Stroke.Color = var20
		end

		local var21
		if var9.Closed then
			if var13 == 0 then
				var21 = "No votes"
			else
				var21 = "Results"
			end
		else
			if var9.Connected == false then
				var21 = "Reconnecting..."
			elseif not var16 then
				var21 = "Counting votes..."
			else
				var21 = (if var9.Choice then "Voted \226\128\162 " else "") .. math.max(0, (math.ceil(var9.EndsAt - var5))) .. "s"
			end
		end

		if var8.Notice then
			if os.clock() < var8.NoticeUntil then
				var21 = var8.Notice
			end
		end

		local var22 = var8.Timer
		local var23
		if var4 then
			if v1 == "Global" then
				var23 = "Global \226\128\162 "
			else
				var23 = "This server \226\128\162 "
			end
		else
			var23 = ""
		end

		var22.Text = var23 .. var21
	end
end

var7.OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	if arg1.Kind == "State" then
		tbl3 = { Server = arg1.Server, Global = arg1.Global }
		for k1 in tbl1, nil do
			if arg1.Server and arg1.Server.Id ~= k1 or (not arg1.Global or arg1.Global.Id ~= k1) then
				tbl1[k1] = nil
			end
		end

		for k2, v1 in tbl3, nil do
			if not v1.Closed then
				continue
			end

			if tbl1[v1.Id] then
				continue
			end

			tbl1[v1.Id] = workspace:GetServerTimeNow() + 10
		end
	else
		if arg1.Kind == "Vote" then
			local var2 = tbl3[arg1.Scope]
			local var3 = tbl2[arg1.Scope]
			if var2 then
				if var2.Id == arg1.Id then
					if arg1.Success then
						var2.Choice = arg1.Choice
					end

					if var3 and var3.Id == arg1.Id then
						var3.Pending = nil
						var3.Notice = if arg1.Success then "Voted!" else "Vote not confirmed \226\128\162 Tap to retry"
						var3.NoticeUntil = os.clock() + 3
					end
				end
			end
		end
	end

	Render()
end)

var6:FireServer("Sync")
task.spawn(function()
	while var2.Parent do
		Render()
		task.wait(0.25)
	end
end)

--- Players.LocalPlayer.PlayerScripts.AdminCrateController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = var1:WaitForChild("Remotes"):WaitForChild("Events")
local var3 = game:GetService("TweenService")
local var4 = game:GetService("RunService")
local var5 = game:GetService("Players").LocalPlayer
local var6 = require(var1.Configs.AdminCrateConfig)
local var7 = require(var1.Modules.ConfettiEffect)
local var8 = var2:WaitForChild("AdminCrateState")
local var9 = var2:WaitForChild("AdminCrateAction")
local var10 = var1:WaitForChild("Assets"):WaitForChild("AdminCrate")
local var11 = Instance.new("Folder")
var11.Name = "LocalAdminCrates"
var11.Parent = workspace
local var12 = Instance.new("ScreenGui")
var12.Name = "AdminCrateRewards"
var12.ResetOnSpawn = false
var12.IgnoreGuiInset = true
var12.DisplayOrder = 100
var12.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
var12:SetAttribute("WindowEffectsManaged", true)
var12.Parent = var5:WaitForChild("PlayerGui")
local var13 = Instance.new("Frame")
var13.Name = "Confetti"
var13.Size = UDim2.fromScale(1, 1)
var13.BackgroundTransparency = 1
var13.Visible = false
var13.Parent = var12
var7.Prepare(var13)
local var14 = Instance.new("TextLabel")
var14.Name = "Reward"
var14.AnchorPoint = Vector2.new(0.5, 0.5)
var14.Position = UDim2.fromScale(0.5, 0.76)
var14.Size = UDim2.new(0.9, 0, 0, 72)
var14.BackgroundTransparency = 1
var14.Font = Enum.Font.GothamBlack
var14.TextSize = 30
var14.TextScaled = true
var14.TextWrapped = true
var14.TextColor3 = Color3.fromRGB(255, 223, 70)
var14.TextTransparency = 1
var14.ZIndex = 60
var14.Parent = var12
local var15 = Instance.new("UITextSizeConstraint")
var15.MaxTextSize = 30
var15.MinTextSize = 12
var15.Parent = var14
local var16 = Instance.new("UIStroke")
var16.Color = Color3.fromRGB(30, 22, 45)
var16.Thickness = 3
var16.Transparency = 1
var16.Parent = var14
local var17 = Instance.new("UIScale")
var17.Parent = var14
local num1 = 0
local tbl1 = {}
local tbl2 = {}
local function Enable(arg1, arg2)
	for k1, v1 in arg1.Crates, nil do
		v1.Prompt.Enabled = arg2
		v1.Prompt:SetAttribute("PromptAvailable", arg2)
	end
end

local function Claim(arg1, arg2)
	if tbl2[arg1.Id] ~= arg1 or (arg1.Pending or (workspace:GetServerTimeNow() < arg1.LandsAt or arg1.EndsAt <= workspace:GetServerTimeNow())) then
		return
	end

	arg1.Pending = true
	Enable(arg1, false)
	var9:FireServer("Claim", arg1.Id, arg2)
	task.delay(8, function()
		if tbl2[arg1.Id] ~= arg1 or (not arg1.Pending) then
			return
		end

		arg1.Pending = false
		Enable(arg1, workspace:GetServerTimeNow() < arg1.EndsAt)
		var9:FireServer("Sync")
	end)
end

local function Remove(arg1)
	local var2 = tbl2[arg1]
	if not var2 then
		return
	end

	tbl2[arg1] = nil
	for k1, v1 in var2.Crates, nil do
		if v1.Tween then
			v1.Tween:Cancel()
		end

		if v1.Motion then
			v1.MotionConnection:Disconnect()
			v1.Motion:Destroy()
		end

		v1.Model:Destroy()
	end
end

local function Add(arg1, _)
	if tbl2[arg1.Id] or (arg1.Claimed or arg1.EndsAt <= workspace:GetServerTimeNow()) then
		return
	end

	local tbl1 = { Id = arg1.Id, LandsAt = arg1.LandsAt, EndsAt = arg1.EndsAt, Crates = {} }
	tbl2[tbl1.Id] = tbl1
	for k1, v1 in arg1.Positions, nil do
		local var1 = var10:Clone()
		var1.Name = "Crate"
		local var2 = math.clamp(tbl1.LandsAt - workspace:GetServerTimeNow(), 0, var6.FallSeconds)
		local var4 = CFrame.new(v1) * CFrame.Angles(0, math.rad(k1 * 47 % 360), 0)
		var1:PivotTo(var4 + Vector3.new(0, var6.FallHeight * var2 / var6.FallSeconds, 0))
		local var7 = Instance.new("ProximityPrompt")
		var7.Name = "OpenCrate"
		var7.ActionText = "Open"
		var7.ObjectText = "Admin crate"
		var7.MaxActivationDistance = var6.PromptDistance
		var7.HoldDuration = 0.2
		var7.RequiresLineOfSight = false
		var7.Style = Enum.ProximityPromptStyle.Custom
		var7.Enabled = false
		var7:SetAttribute("PromptAvailable", false)
		var7:SetAttribute("OwnerUserId", var5.UserId)
		local var8 = var1.PrimaryPart
		var7.Parent = var8
		local var9 = Instance.new("BillboardGui")
		var9.Name = "CrateLabel"
		var9.Size = UDim2.fromOffset(200, 62)
		var9.StudsOffset = Vector3.new(0, 4.2, 0)
		var9.MaxDistance = 100
		var9.AlwaysOnTop = false
		var9.Parent = var8
		local var12 = Instance.new("TextLabel")
		var12.Name = "Time"
		var12.Size = UDim2.fromScale(1, 1)
		var12.BackgroundTransparency = 1
		var12.Font = Enum.Font.GothamBlack
		var12.TextColor3 = Color3.fromRGB(255, 228, 80)
		var12.TextSize = 18
		var12.Text = "ADMIN CRATE"
		var12.Parent = var9
		local var13 = Instance.new("UIStroke")
		var13.Thickness = 2
		var13.Parent = var12
		var1.Parent = var11
		local tbl3 = { Model = var1, Prompt = var7, Label = var12, Target = var4 }
		table.insert(tbl1.Crates, tbl3)
		var7.Triggered:Connect(function(arg1)
			if arg1 == var5 then
				Claim(tbl1, k1)
			end
		end)

		if 0 >= var2 then
			continue
		end

		local var14 = Instance.new("CFrameValue")
		var14.Value = var1:GetPivot()
		tbl3.Motion = var14
		tbl3.MotionConnection = var14:GetPropertyChangedSignal("Value"):Connect(function()
			if var1.Parent then
				var1:PivotTo(var14.Value)
			end
		end)

		local var15 = TweenInfo.new(var2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		tbl3.Tween = var3:Create(var14, var15, { Value = var4 })
		tbl3.Tween:Play()
	end

	task.delay(math.max(0, tbl1.LandsAt - workspace:GetServerTimeNow()), function()
		if tbl2[tbl1.Id] ~= tbl1 then
			return
		end

		for k1, v1 in tbl1.Crates, nil do
			if not v1.Motion then
				continue
			end

			v1.Tween:Cancel()
			v1.MotionConnection:Disconnect()
			v1.Model:PivotTo(v1.Target)
			v1.Motion:Destroy()
			v1.Motion = nil
		end

		local var2 = not tbl1.Pending
		local var3 = Enable
		local var4 = tbl1
		if var2 then
			var2 = workspace:GetServerTimeNow() < tbl1.EndsAt
		end

		var3(var4, var2)
	end)
end

local bool1 = false
local tbl3 = {}
local function Notify(arg1, arg2)
	local var1 = num1 + 1
	num1 = var1
	var1 = num1
	for k1, v1 in tbl1, nil do
		v1:Cancel()
	end

	var14.Text = arg1
	local var2 = arg2 and Color3.fromRGB(130, 255, 125) or Color3.fromRGB(255, 223, 70)
	var14.TextColor3 = var2
	var14.TextTransparency = 0
	var16.Transparency = 0
	var17.Scale = 0.85
	local var4 = var17
	local var5 = TweenInfo.new(0.2, Enum.EasingStyle.Back)
	local tbl2 = { Scale = 1 }
	local tbl3 = { var3:Create(var4, var5, tbl2) }
	tbl1 = tbl3
	tbl1[1]:Play()
	if arg2 then
		var7.Play(var13)
	end

	task.delay(3, function()
		if var1 ~= num1 then
			return
		end

		local var2 = var16
		local var4 = TweenInfo.new(0.2)
		local tbl2 = { Transparency = 1 }
		local tbl3 = {
			var3:Create(var14, TweenInfo.new(0.2), { TextTransparency = 1 }),
			var3:Create(var2, var4, tbl2),
		}

		tbl1 = tbl3
		for k1, v1 in tbl1, nil do
			v1:Play()
		end
	end)
end

local num2 = 0
local bool2 = true
local var18 = var8.OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	if arg1.Kind == "State" and type(arg1.Drops) == "table" then
		local tbl1 = {}
		for k1, v1 in arg1.Drops, nil do
			tbl1[v1.Id] = true
			if v1.Claimed then
				Remove(v1.Id)
			else
				Add(v1, not bool1)
			end
		end

		for k2 in tbl2, nil do
			if tbl1[k2] then
				continue
			end

			Remove(k2)
		end

		bool1 = true
		return
	end

	if arg1.Kind == "Claim" then
		local var1 = tbl2[arg1.DropId]
		if arg1.Success then
			Remove(arg1.DropId)
			if not not tbl3[arg1.DropId] then
				return
			end

			tbl3[arg1.DropId] = os.clock()
			if not not arg1.AlreadyClaimed then
				return
			end

			Notify("You got " .. (arg1.Reward and arg1.Reward.Label or "a reward") .. "!", true)
			return
		end

		if var1 then
			var1.Pending = false
			local var2 = Enable
			local var3 = var1
			local bool2 = false
			if var1.LandsAt <= workspace:GetServerTimeNow() then
				bool2 = workspace:GetServerTimeNow() < var1.EndsAt
			end

			var2(var3, bool2)
			Notify(arg1.Message or "Try opening the crate again.")
		end
	end
end)

local var19 = var4.Heartbeat:Connect(function(arg1)
	local var1 = num2 + arg1
	num2 = var1
	if num2 < 1 then
		return
	end

	num2 = 0
	var1 = workspace:GetServerTimeNow()
	for k1, v1 in tbl2, nil do
		local var2
		if v1.EndsAt <= var1 then
			Remove(k1)
		else
			for k2, v2 in v1.Crates, nil do
				v2.Label.Text = [[ADMIN CRATE
]] .. math.max(0, (math.ceil(v1.EndsAt - var1))) .. "s"

			end
		end
	end

	for k3, v3 in tbl3, nil do
		if 180 >= os.clock() - v3 then
			continue
		end

		tbl3[k3] = nil
	end
end)

script.Destroying:Once(function()
	bool2 = false
	local var1 = num1 + 1
	num1 = var1
	var18:Disconnect()
	var19:Disconnect()
	for k1 in tbl2, nil do
		Remove(k1)
	end

	for k2, v1 in tbl1, nil do
		v1:Cancel()
	end

	var12:Destroy()
	var11:Destroy()
end)

task.spawn(function()
	for i1 = 1, 3 do
		if not bool2 or bool1 then
			return
		end

		var9:FireServer("Sync")
		task.wait(3)
	end
end)

--- Players.LocalPlayer.PlayerScripts.AdminEventFeedbackController [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local str1 = "OtherSounds"
local var2 = require(var1:WaitForChild("Modules"):WaitForChild(str1))
local var3 = game:GetService("Players")
local var4 = game:GetService("TweenService")
local var5 = var1:WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("AdminEventFeedback")
str1 = { Top = Color3.fromRGB(170, 255, 80), Sound = "Boost" }
str1.Bottom = Color3.fromRGB(30, 215, 255)
local tbl1 = { TreadmillStart = str1 }
str1 = { Top = Color3.fromRGB(255, 174, 244), Sound = "Notification" }
str1.Bottom = Color3.fromRGB(194, 130, 255)
tbl1.TreadmillEnd = str1
str1 = { Top = Color3.fromRGB(255, 242, 83), Sound = "Notification" }
str1.Bottom = Color3.fromRGB(255, 158, 48)
tbl1.Crates = str1
str1 = Instance.new("ScreenGui")
str1.Name = "AdminEventFeedback"
str1.ResetOnSpawn = false
str1.DisplayOrder = 500
str1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
str1:SetAttribute("WindowEffectsManaged", true)
str1.Parent = var3.LocalPlayer:WaitForChild("PlayerGui")
local var6 = Instance.new("TextLabel")
var6.Name = "Event"
var6.AnchorPoint = Vector2.new(0.5, 0.5)
var6.Position = UDim2.fromScale(0.5, 0.25)
var6.Size = UDim2.new(0.9, 0, 0, 70)
var6.BackgroundTransparency = 1
var6.Font = Enum.Font.GothamBlack
var6.TextColor3 = Color3.new(1, 1, 1)
var6.TextScaled = true
var6.TextWrapped = true
var6.RichText = false
var6.Visible = false
var6.ZIndex = 10
var6.Parent = str1
local var7 = Instance.new("UITextSizeConstraint")
var7.MinTextSize = 12
var7.MaxTextSize = 30
var7.Parent = var6
local var8 = Instance.new("UIStroke")
var8.Color = Color3.fromRGB(24, 19, 43)
var8.Thickness = 3
var8.Parent = var6
local var9 = Instance.new("UIGradient")
var9.Rotation = 90
var9.Parent = var6
local var10 = Instance.new("UIScale")
var10.Parent = var6
local tbl2 = {}
local bool1 = true
local tbl3 = {}
local bool2 = false
local num1 = 0
local tbl4 = {}
local function Next()
	if not bool1 then
		return
	end

	local var1 = nil
	repeat
		var1 = table.remove(tbl3, 1)
	until not var1 or workspace:GetServerTimeNow() < var1.ExpiresAt

	if not var1 then
		bool2 = false
		var6.Visible = false
		return
	end

	bool2 = true
	local var3 = num1 + 1
	num1 = var3
	var3 = num1
	local var5 = tbl1[var1.Kind]
	for k1, v1 in tbl2, nil do
		v1:Cancel()
	end

	table.clear(tbl2)
	var6.Text = var1.Text
	var6.TextTransparency = 1
	var6.Position = UDim2.fromScale(0.5, 0.235)
	var6.Visible = true
	var8.Transparency = 1
	var10.Scale = 0.88
	var9.Color = ColorSequence.new(var5.Top, var5.Bottom)
	var2.Play(var5.Sound)
	local var7 = var4:Create(var6, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0, Position = UDim2.fromScale(0.5, 0.25) })
	table.insert(tbl2, var7)
	var7:Play()
	var7 = var4:Create(var8, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0 })
	table.insert(tbl2, var7)
	var7:Play()
	local var11 = Enum.EasingStyle.Back
	local var12 = var4:Create(var10, TweenInfo.new(0.24, var11 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 })
	table.insert(tbl2, var12)
	var12:Play()
	task.delay(3.6, function()
		if not bool1 or num1 ~= var3 then
			return
		end

		local var1 = var4:Create(var6, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 1, Position = UDim2.fromScale(0.5, 0.24) })
		table.insert(tbl2, var1)
		var1:Play()
		var1 = var4:Create(var8, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 1 })
		table.insert(tbl2, var1)
		var1:Play()
		task.delay(0.2, function()
			if bool1 and num1 == var3 then
				Next()
			end
		end)
	end)
end

local var11 = var5.OnClientEvent:Connect(function(arg1)
	if not bool1 or (type(arg1) ~= "table" or (type(arg1.Id) ~= "string" or (120 < (#arg1.Id) or (tbl4[arg1.Id] or (not tbl1[arg1.Kind] or (type(arg1.Text) ~= "string" or (240 < (#arg1.Text) or (type(arg1.ExpiresAt) ~= "number" or (arg1.ExpiresAt ~= arg1.ExpiresAt or (arg1.ExpiresAt <= workspace:GetServerTimeNow() or workspace:GetServerTimeNow() + 15 < arg1.ExpiresAt)))))))))) then
		return
	end

	tbl4[arg1.Id] = true
	task.delay(600, function()
		tbl4[arg1.Id] = nil
	end)

	if 4 <= (#tbl3) then
		table.remove(tbl3, 1)
	end

	table.insert(tbl3, arg1)
	if not bool2 then
		Next()
	end
end)

script.Destroying:Once(function()
	bool1 = false
	local var1 = num1 + 1
	num1 = var1
	var11:Disconnect()
	for k1, v1 in tbl2, nil do
		v1:Cancel()
	end

	table.clear(tbl3)
	str1:Destroy()
end)

--- Players.LocalPlayer.PlayerScripts.EventPrompt [LocalScript]
-- y u r i

task.wait(15)
local var1 = game:GetService("SocialService")
local success, result = pcall(function()
	local str1 = "6290854313178825354"
	return var1:GetEventRsvpStatusAsync(str1)
end)

if not success then
	warn("couldnt check event status:", result)
	return
end

if result == Enum.RsvpStatus.Going then
	return
end

local success, result = pcall(function()
	local str1 = "6290854313178825354"
	return var1:PromptRsvpToEventAsync(str1)
end)

if not success then
	warn("couldnt open event prompt:", result)
end

--- Players.LocalPlayer.PlayerGui.HUD.Left.Shop.Gradient [LocalScript]
-- y u r i

local num1 = 255
local num2 = 0
local num3 = 0
local var1 = ColorSequenceKeypoint.new(0, Color3.fromRGB(num1, num2, num3))
num2 = 255
num3 = 165
local num4 = 0
local var2 = ColorSequenceKeypoint.new(0.2, Color3.fromRGB(num2, num3, num4))
num3 = 255
num4 = 255
local num5 = 0
local var3 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(num3, num4, num5))
num4 = 0
num5 = 255
local num6 = 0
num1 = ColorSequenceKeypoint.new(0.6, Color3.fromRGB(num4, num5, num6))
num5 = 0
num6 = 0
local num7 = 255
num2 = ColorSequenceKeypoint.new(0.8, Color3.fromRGB(num5, num6, num7))
num6 = 255
num7 = 0
local num8 = 255
num4 = 1
local var4 = game:GetService("TweenService")
local var5 = script.Parent:WaitForChild("UIGradient")
var5.Color = ColorSequence.new({
	var1,
	var2,
	var3,
	num1,
	num2,
	ColorSequenceKeypoint.new(num4, Color3.fromRGB(num6, num7, num8)),
})

var5.Rotation = 0
var3 = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
var4:Create(var5, var3, { Offset = Vector2.new(1, 0) }):Play()

--- Players.LocalPlayer.PlayerGui.Notifications.BuySpeed.Sunburst.SunburstLocalScript [LocalScript]
-- y u r i

local num1 = 0
local var1 = script.Parent
game:GetService("RunService").RenderStepped:Connect(function(arg1)
	local var2 = num1 + 20 * arg1
	num1 = var2
	var1.Rotation = num1 % 360
end)

--- Players.LocalPlayer.PlayerGui.Notifications.UpgradeTreadmill.Sunburst.SunburstLocalScript [LocalScript]
-- y u r i

local num1 = 0
local var1 = script.Parent
game:GetService("RunService").RenderStepped:Connect(function(arg1)
	local var2 = num1 + 20 * arg1
	num1 = var2
	var1.Rotation = num1 % 360
end)

--- Players.LocalPlayer.PlayerGui.Notifications.SpeedMultiplier.Sunburst.SunburstLocalScript [LocalScript]
-- y u r i

local num1 = 0
local var1 = script.Parent
game:GetService("RunService").RenderStepped:Connect(function(arg1)
	local var2 = num1 + 20 * arg1
	num1 = var2
	var1.Rotation = num1 % 360
end)

--- Players.LocalPlayer.PlayerGui.Main.Shop.ShopCosmeticsController [LocalScript]
-- y u r i

local str1 = "ShopCosmetics"
script.Destroying:Once((require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild(str1)).Start(script.Parent)))

--- Players.LocalPlayer.PlayerGui.Main.Index.IndexLocal [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local var1 = game:GetService("ReplicatedStorage")
local var2 = script.Parent
local var3 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local var4 = require(var1.Configs.CarConfig)
local var5 = require(var1.Configs.IndexConfig)
local var6 = require(var1.Modules.NumberFormatter)
local var7 = require(var1.Modules.OffsetListLayout)
local var8 = require(var1.Modules.ConfettiEffect)
local var9 = require(var1.Modules.IndexCarPreviews)
local var10 = var3:WaitForChild("HUD"):WaitForChild("Left"):WaitForChild("Index"):WaitForChild("Exclamation")
local var11 = var2.List
var11:SetAttribute("OffsetListKind", "Index")
local var12 = var2.Rewards.Grid
var12:SetAttribute("OffsetListKind", "IndexRewards")
var7.Bind(var11)
var7.Bind(var12)
local var13 = var2.Rewards.ClaimFrame
local var14 = var2.Bar.UnlockBar
local tbl1 = { Unlocked = {}, UnlockCount = 0, ClaimedMilestones = 0, Claimable = false }
local tbl2 = {}
local var15 = nil
local bool1 = false
local bool2 = false
local var16 = nil
local var17 = var1.Remotes.Functions
for k1, v1 in var11:GetChildren() do
	local var18 = v1:IsA("GuiObject")
	if not var18 then
		continue
	end

	v1:Destroy()
end

var11.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
var12.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
local function selection()
	for k1, v1 in pairs(tbl2) do
		local var1 = v1:FindFirstChildOfClass("UIStroke")
		if not var1 then
			continue
		end

		local var2 = if var15 == k1 then Color3.fromRGB(70, 155, 255) else Color3.new(0, 0, 0)
		var1.Color = var2
	end
end

for k2, v2 in ipairs((var4.GetIndexIds())) do
	local var19 = var4.Get(v2)
	local var20 = script.Basic:Clone()
	var20.Name = v2
	var20.LayoutOrder = k2
	var20.Size = UDim2.fromOffset(112, 138)
	var20.Position = UDim2.fromOffset(0, 0)
	var20.Image.Image = ""
	var20.Image.ZIndex = var20.ZIndex + 1
	local var21 = var20:FindFirstChild("Name")
	var21.ZIndex = var20.ZIndex + 2
	var20.Rarity.ZIndex = var20.ZIndex + 2
	var20.Image.Activated:Connect(function()
		var15 = v2
		selection()
	end)

	var20.Rarity:SetAttribute("GradientStyleOverride", var19.GradientStyle)
	var20.Rarity.Text = var4.GetRarity(v2)
	var20.Rarity.TextColor3 = var4.GetRarityInfo(var20.Rarity.Text).Color
	var20.Visible = true
	var20.Parent = var11
	tbl2[v2] = var20
end

var14.InnerBar.AnchorPoint = Vector2.new(0, var14.InnerBar.AnchorPoint.Y)
var14.InnerBar.Position = UDim2.new(0, 0, var14.InnerBar.Position.Y.Scale, var14.InnerBar.Position.Y.Offset)
var2.Bar.Placeholder.Text = "Cars Discovered"
local function render()
	for k1, v1 in pairs(tbl2) do
		local var1 = tbl1.Unlocked[k1] == true
		var9.SetCard(v1, k1, var1)
		local var2 = v1:FindFirstChild("Name")
		local var7 = if var1 then var4.Get(k1).Name or k1 else "???"
		var2.Text = var7
		var2 = v1:FindFirstChild("Name")
		var2.TextColor3 = Color3.new(1, 1, 1)
	end

	var10.Visible = tbl1.Claimable == true
	local var8 = tbl1.ClaimedMilestones + 1
	local var15 = var5.Rewards[var8]
	var14.InnerBar.Size = UDim2.new(if var15 then math.clamp(tbl1.UnlockCount / var15.UnlocksRequired, 0, 1) else 1, 0, var14.InnerBar.Size.Y.Scale, var14.InnerBar.Size.Y.Offset)
	local var17 = var14.UnlocksRequired
	local var18 = if var15 then tostring((math.min(tbl1.UnlockCount, var15.UnlocksRequired))) .. "/" .. tostring(var15.UnlocksRequired) else "MAX"
	var17.Text = var18
	var17 = var13
	local var19
	if tbl1.Claimable then
		var19 = 26
		var18 = Color3.fromRGB(79, 255, var19)
	else
		var19 = 120
		var18 = Color3.fromRGB(120, 120, var19)
	end

	var17.BackgroundColor3 = var18
	var17 = var13.Text
	if bool1 then
		var18 = "Claiming\226\128\166"
	elseif not var15 then
		var18 = "Claimed"
	else
		var18 = "Claim"
	end

	var17.Text = var18
	var18 = bool2
	var13.Button.Active = var18 and (tbl1.Claimable and (not bool1))
	if var16 ~= var8 then
		var16 = var8
		for k2, v2 in var12:GetChildren() do
			if not v2:IsA("GuiObject") then
				continue
			end

			v2:Destroy()
		end

		if var15 then
			var17 = script.GridTemplate:Clone()
			var17.Name = "CashReward"
			var17.LayoutOrder = 1
			var17.Size = UDim2.fromOffset(100, 100)
			var17.Position = UDim2.fromOffset(0, 0)
			var17.Text.Text = "$" .. var6.Format(var15.Cash)
			var17.Text.AnchorPoint = Vector2.new(0.5, 0.5)
			var17.Text.Position = UDim2.fromScale(0.5, 0.8)
			var17.Text.Size = UDim2.fromScale(0.95, 0.4)
			local var20 = var15.Icon
			var17.Icon.Image = var20 or var3.HUD.BottomLeft.Cash.CashIcon.Image
			var17.Visible = true
			var17.Parent = var12
		end
	end

	selection()
end

var1.Remotes.Events.IndexUpdated.OnClientEvent:Connect(function(arg1)
	if type(arg1) ~= "table" then
		return
	end

	tbl1 = arg1
	bool2 = true
	render()
end)

var13.Button.Activated:Connect(function()
	if bool1 or (not bool2 or (not tbl1.Claimable)) then
		return
	end

	bool1 = true
	render()
	local success, result = pcall(function()
		return var17.ClaimIndexReward:InvokeServer()
	end)

	bool1 = false
	if success then
		if result then
			if result.State then
				local var1 = result.State
	if type(var1) == "table" then
					tbl1 = var1
					bool2 = true
					render()
				end
			end

			if result.Success then
				local var4 = var3:FindFirstChild("Notifications")
				var4 = var4 or var3:FindFirstChild("Notification")
				local var5 = var4
				var8.Play(var5 and var4:FindFirstChild("Confetti"))
			end
		end
	end

	render()
end)

render()
task.spawn(function()
	for i1 = 1, 5 do
		local success, result = pcall(function()
			return var17.GetCarIndex:InvokeServer()
		end)

		if success then
			if result then
				if type(result) ~= "table" then
					return
				end

				tbl1 = result
				bool2 = true
				render()
				return
			end
		end

		task.wait(i1)
	end
end)

--- Players.LocalPlayer.PlayerGui.Tutorial.TutorialLocal [LocalScript]
-- y u r i

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local str1 = "LifecycleWait"
local var1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild(str1))
local var2 = game:GetService("Players").LocalPlayer
local var3 = script.Parent
local var4 = game:GetService("RunService")
str1 = game:GetService("TweenService")
local var5 = var2:WaitForChild("PlayerGui")
local var6 = var3:WaitForChild("Instruction")
local var7 = script:WaitForChild("Arrow")
local var8 = script:WaitForChild("Beam")
local var9 = require(game:GetService("ReplicatedStorage").Modules.ConfettiEffect)
var3.ResetOnSpawn = false
var3.IgnoreGuiInset = true
local var10 = math.max(var3.DisplayOrder, 130)
var3.DisplayOrder = var10
var6.Active = false
var6.Interactable = false
var3.Enabled = true
var6.Visible = false
var6.AnchorPoint = Vector2.new(0.5, 0)
var6.Position = UDim2.fromScale(0.5, 0.12)
var6.Size = UDim2.new(0.8, 0, 0, 64)
var6.TextScaled = true
var6.TextWrapped = true
var10 = var6:FindFirstChildOfClass("UIAspectRatioConstraint")
if var10 then
	var10:Destroy()
end

local var11 = var6:FindFirstChildOfClass("UITextSizeConstraint")
var11 = var11 or Instance.new("UITextSizeConstraint")
var11.MinTextSize = 14
var11.MaxTextSize = 32
var11.Parent = var6
local var12 = Instance.new("UISizeConstraint")
var12.MaxSize = Vector2.new(760, 64)
var12.Parent = var6
local var13 = Instance.new("UIScale")
var13.Name = "TutorialPop"
var13.Parent = var6
var7.Parent = var3
var7.Visible = false
var7.AnchorPoint = Vector2.new(0.5, 1)
var7.Size = UDim2.fromOffset(52, 64)
var7.Active = false
var7.Interactable = false
var8.Enabled = false
local var14 = Instance.new("Part")
var14.Name = "TutorialGuidanceTarget"
var14.Size = Vector3.new(1, 1, 1)
var14.Anchored = true
var14.CanCollide = false
var14.CanTouch = false
var14.CanQuery = false
var14.Transparency = 1
var14.Parent = workspace
local var15 = Instance.new("Attachment")
var15.Parent = var14
var8.Attachment0 = var15
var8.Parent = var14
local function visible(arg1)
	local var1 = arg1
	while not var1 and var1 == var5 and var1:IsA("GuiObject") and (not var1.Visible) do
	end

	return var1 == var5
end

local var16 = nil
local var17 = nil
local var18 = nil
local bool1 = false
local function resize()
	local var1 = workspace.CurrentCamera
	local var3 = var1
	if var3 then
		var3 = var1.ViewportSize.Y < 500
	end

	var6.Size = UDim2.new(0.8, 0, 0, if var3 then 44 else 64)
	local var4 = var11
	var4.MaxTextSize = if var3 then 24 else 32
	var4 = var7
	local var5 = UDim2.fromOffset
	local var8 = if var3 then 38 else 52
	var4.Size = var5(var8, if var3 then 38 else 52)
end

local function mobileEscapeHint()
	local var3 = var5:FindFirstChild("Steering")
	if not var3 or (not var3.Enabled) then
		var16 = nil
		return
	end

	local var6 = var3:FindFirstChild("Accelerator")
	if not var6 or (not var6:IsA("GuiButton") or (not visible(var6))) then
		return
	end

	if not var6:GetAttribute("DrivingHeld") then
		var16 = nil
		return var6, "Hold the accelerator to drive!"
	end

	local var7 = var2.Character
	local var8 = var7
	var8 = var8 and var7:FindFirstChildOfClass("Humanoid")
	local var9 = var8
	var9 = var9 and var8.SeatPart
	local var10 = var9
	var10 = var10 and (var9.Parent and var9.Parent:FindFirstChild("Chassis"))
	local var11 = var2:GetAttribute("TutorialTargetPosition")
	if var10 then
		if typeof(var11) == "Vector3" then
			local var12 = Vector3.new(var10.CFrame.LookVector.X, 0, var10.CFrame.LookVector.Z)
			local var14 = Vector3.new(var11.X - var10.Position.X, 0, var11.Z - var10.Position.Z)
			if 0.01 < var12.Magnitude then
				if 3 < var14.Magnitude then
					local var15 = math.atan2(var12:Cross(var14.Unit).Y, (var12:Dot(var14.Unit)))
					if math.abs(var15) < 0.1 then
						var16 = nil
					else
						if 0.25 < math.abs(var15) then
							var16 = if 0 < var15 then "Left" else "Right"
						end
					end
				else
					var16 = nil
				end
			else
				var16 = nil
			end
		end
	end

	if var16 then
		local var19 = var3:FindFirstChild("LeftRight")
		local var20 = var19
		var20 = var20 and var19:FindFirstChild(var16)
		if var20 and visible(var20) then
			return var20, "Keep holding the accelerator. Hold " .. string.upper(var16) .. " to turn!"
		end
	end

	return var6, "Keep holding the accelerator to reach the finish!"
end

local var19 = nil
local var20 = nil
local num1 = 0
local function showMessage(arg1)
	if arg1 ~= var17 then
		var6.Text = arg1
		if var18 then
			var18:Cancel()
		end

		var13.Scale = 0.92
		var18 = str1:Create(var13, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
		var18:Play()
		var17 = arg1
	end

	var6.Visible = true
end

local function celebrate()
	local var3 = var2:GetAttribute("TutorialCompletionTime")
	if bool1 or (not var3 or 10 < workspace:GetServerTimeNow() - var3) then
		return
	end

	bool1 = true
	var6.Text = "Tutorial complete! Steal more cars and train to get faster!"
	var6.Visible = true
	local var4 = var5:FindFirstChild("Notifications")
	local var7 = var4
	var7 = var7 and var4:FindFirstChild("Confetti")
	if var7 then
		var9.Play(var7, "Finish")
	end

	task.delay(4, function()
		if var2:GetAttribute("TutorialPhase") == "Complete" then
			var6.Visible = false
		end
	end)
end

local str2 = "TutorialCanAfford"
local var21 = nil
local var22 = nil
local function findSlot()
	local var1 = var2:GetAttribute("TutorialToolUid")
	for k1, v1 in var5:GetDescendants() do
		if v1.Name ~= "SatchelTool" then
			continue
		end

		if not v1:IsA("ObjectValue") then
			continue
		end

		local var3 = v1.Value
		if not var3 then
			continue
		end

		if var3:GetAttribute("InventoryUid") ~= var1 then
			continue
		end

		local var4 = v1.Parent
		if not var4:IsA("GuiObject") then
			continue
		end

		if not visible(var4) then
			continue
		end

		return var4
	end
end

local function pointAt(arg1)
	local var1 = var7
	local bool2 = false
	if arg1 ~= nil then
		bool2 = false
		if arg1.Parent ~= nil then
			bool2 = visible(arg1)
		end
	end

	var1.Visible = bool2
	if not var7.Visible then
		return
	end

	local var5 = workspace.CurrentCamera
	var1 = arg1.AbsolutePosition.X - var3.AbsolutePosition.X + arg1.AbsoluteSize.X * 0.5
	bool2 = arg1.AbsolutePosition.Y - var3.AbsolutePosition.Y - 8 + math.sin(os.clock() * 4) * 6
	if var5 then
		local var6 = var5.ViewportSize
		var1 = math.clamp(var1, var7.AbsoluteSize.X * 0.5 + 4, (math.max(var7.AbsoluteSize.X * 0.5 + 4, var6.X - var7.AbsoluteSize.X * 0.5 - 4)))
		bool2 = math.clamp(bool2, var7.AbsoluteSize.Y + 4, (math.max(var7.AbsoluteSize.Y + 4, var6.Y - 4)))
	end

	var7.Position = UDim2.fromOffset(var1, bool2)
end

local function refresh()
	resize()
	local var4 = var2:GetAttribute("TutorialPhase")
	local var5 = nil
	if var4 == "Steal" then
		var5 = "Steal your first car! Follow the arrows."
	elseif var4 == "Escape" then
		local var8, var9 = mobileEscapeHint()
		var5 = var9 or "Drive back across the finish line!"
	elseif var4 == "Delivering" then
		var5 = "Securing your car..."
	elseif var4 == "Equip" then
		var5 = "Select your MiniCar in your inventory!"
	elseif var4 == "Place" then
		var5 = "Place your MiniCar in an empty space on your plot!"
	elseif var4 == "BuyTreadmill" then
		var5 = if var2:GetAttribute("TutorialCanAfford") then "Buy your starter treadmill for $" .. tostring(var2:GetAttribute("TutorialPrice") or 10) .. "!" else "Your car is earning cash! Next: buy your $10 treadmill."
	end

	if var4 ~= var19 then
		var19 = var4
		var20 = nil
		num1 = 0
	end

	if var5 then
		showMessage(var5)
	elseif var4 == "Complete" then
		if not bool1 then
			var6.Visible = false
			celebrate()
		end
	else
		var6.Visible = false
	end

	var7.Visible = false
end

for k1, v1 in { "TutorialPhase", str2, "TutorialPrice", "TutorialCompletionTime" }, nil do
	var2:GetAttributeChangedSignal(v1):Connect(refresh)
end

local function bindCharacter(arg1)
	if var2.Character ~= arg1 then
		return
	end

	if var21 then
		var21:Destroy()
		var21 = nil
	end

	var22 = nil
	var8.Attachment1 = nil
	local var4 = var1.Child(arg1, "HumanoidRootPart", function()
		local bool1 = false
		if var2.Parent ~= nil then
			bool1 = var2.Character == arg1
		end

		return bool1
	end)

	if not var4 then
		return
	end

	var22 = var4
	if var22 then
		var21 = Instance.new("Attachment")
		var21.Name = "TutorialBeamOrigin"
		var21.Position = Vector3.new(0, -1, 0)
		var21.Parent = var22
		var8.Attachment1 = var21
	end
end

var2.CharacterAdded:Connect(function(arg1)
	task.spawn(bindCharacter, arg1)
end)

if var2.Character then
	task.spawn(bindCharacter, var2.Character)
end

local var23 = nil
local num2 = 0
local var24 = nil
local var25 = var4.RenderStepped:Connect(function()
	local var3 = workspace.CurrentCamera
	if var3 and var23 ~= var3.ViewportSize then
		var23 = var3.ViewportSize
		resize()
	end

	local var4 = var22
	var4 = var4 and (var22.Parent and var22.Parent:FindFirstChildOfClass("Humanoid"))
	local var6 = var4
	local var9 = var2:GetAttribute("TutorialPhase")
	local var10 = var2:GetAttribute("TutorialTargetPosition")
	if var6 then
		var6 = 0 < var4.Health
	end

	var4 = var6
	var6 = var8
	if var4 then
		if typeof(var10) == "Vector3" then
			if var9 ~= "Complete" then
				if var9 ~= "Loading" then
					local bool4 = true
					bool4 = var9 == "Equip" and false
				end
			end
		end
	end

	var6.Enabled = false
	if var8.Enabled then
		var14.Position = Vector3.new(var10.X, var22.Position.Y - 1.5, var10.Z)
	end

	if var9 == "Equip" then
		if var4 then
			if num1 <= os.clock() then
				var20 = findSlot()
				num1 = os.clock() + 0.35
			end

			pointAt(var20)
			return
		end
	end

	if var9 == "Escape" then
		if var4 then
			if num2 <= os.clock() then
				local var11, var12 = mobileEscapeHint()
				var24 = var11
				var6 = nil
				showMessage(var12 or "Drive back across the finish line!")
				num2 = os.clock() + 0.1
			end

			pointAt(var24)
			return
		end
	end

	var7.Visible = false
	var24 = nil
	var16 = nil
	num2 = 0
end)

script.Destroying:Connect(function()
	var25:Disconnect()
	var14:Destroy()
	if var21 then
		var21:Destroy()
	end
end)

refresh()

--- Players.LocalPlayer.PlayerGui.Feedback.FeedbackController [LocalScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
local str1 = "UIEffects"
local var2 = require(var1:WaitForChild("Modules"):WaitForChild(str1))
local var3 = script.Parent
str1 = var3:WaitForChild("feedbackframe")
local var4 = str1:WaitForChild("sendbutton")
str1:SetAttribute("WindowEffectsManaged", true)
local var5 = game:GetService("HttpService")
local var6 = var1:WaitForChild("Remotes"):WaitForChild("Functions"):WaitForChild("SubmitFeedback")
local var7 = var3:WaitForChild("feedbackbutton"):WaitForChild("Button")
local var8 = str1:WaitForChild("Exit"):WaitForChild("Button")
local var9 = var4:WaitForChild("Button")
local var10 = var4:WaitForChild("Text")
local var11 = str1:WaitForChild("Feedbackbox")
str1.Visible = false
var11.ClearTextOnFocus = false
var11.MultiLine = true
local var12 = var8
local bool1 = false
local bool2 = true
local num1 = 0
local num2 = 0
for k1, v1 in { var7, var12, var9 }, nil do
	var2.BindButton(v1)
end

var7.Activated:Connect(function()
	local var3 = not var2.IsWindowOpen(str1)
	if not var3 then
		var11:ReleaseFocus()
	end

	var2.SetWindow(str1, var3)
end)

var8.Activated:Connect(function()
	var11:ReleaseFocus()
	var2.SetWindow(str1, false)
end)

var9.Activated:Connect(function()
	if bool1 then
		return
	end

	local var2 = num1 - os.clock()
	if 0 < var2 then
		local var3 = "Wait " .. math.ceil(var2) .. "s"
		local var4 = num2 + 1
		num2 = var4
		var10.Text = var3
		var4 = num2
		task.delay(2, function()
			if bool2 and (var4 == num2 and (not bool1)) then
				var10.Text = "Send"
			end
		end)

		return
	end

	local var7 = var11.Text:match("^%s*(.-)%s*$")
	local var12 = utf8.len(var7)
	if not var12 or var12 == 0 then
		local var13 = num2 + 1
		num2 = var13
		var10.Text = "Write feedback"
		var13 = num2
		task.delay(3, function()
			if bool2 and (var13 == num2 and (not bool1)) then
				var10.Text = "Send"
			end
		end)

		return
	end

	if 1000 < var12 then
		local var14 = num2 + 1
		num2 = var14
		var10.Text = "Max 1000 characters"
		var14 = num2
		task.delay(3, function()
			if bool2 and (var14 == num2 and (not bool1)) then
				var10.Text = "Send"
			end
		end)

		return
	end

	bool1 = true
	var11:ReleaseFocus()
	local var15 = num2 + 1
	num2 = var15
	var10.Text = "Sending..."
	var15 = num2
	var9.Active = false
	var9.Selectable = false
	var15 = var11.Text
	local success, result = pcall(function()
		local bool1 = false
		local var1 = var7
		return var6:InvokeServer(var1, var5:GenerateGUID(bool1))
	end)

	if not bool2 then
		return
	end

	bool1 = false
	var9.Active = true
	var9.Selectable = true
	if success and type(result) == "table" then
		local var16 = tonumber(result.RetryAfter) or 0
		num1 = os.clock() + math.clamp(var16, 0, 300)
		if result.Success then
			if var11.Text == var15 then
				var11.Text = ""
			end

			local var17 = num2 + 1
			num2 = var17
			var10.Text = "Sent!"
			var17 = num2
			task.delay(3, function()
				if bool2 and (var17 == num2 and (not bool1)) then
					var10.Text = "Send"
				end
			end)

			return
		end

		if result.Reason == "Cooldown" then
			local var18 = "Wait " .. math.ceil(var16) .. "s"
			local var19 = num2 + 1
			num2 = var19
			var10.Text = var18
			var19 = num2
			task.delay(3, function()
				if bool2 and (var19 == num2 and (not bool1)) then
					var10.Text = "Send"
				end
			end)

			return
		end

		if result.Reason == "Empty" then
			local var20 = num2 + 1
			num2 = var20
			var10.Text = "Write feedback"
			var20 = num2
			task.delay(3, function()
				if bool2 and (var20 == num2 and (not bool1)) then
					var10.Text = "Send"
				end
			end)

			return
		end

		if result.Reason == "TooLong" then
			local var21 = num2 + 1
			num2 = var21
			var10.Text = "Max 1000 characters"
			var21 = num2
			task.delay(3, function()
				if bool2 and (var21 == num2 and (not bool1)) then
					var10.Text = "Send"
				end
			end)

			return
		end

		local var22 = num2 + 1
		num2 = var22
		var10.Text = "Couldn't send"
		var22 = num2
		task.delay(3, function()
			if bool2 and (var22 == num2 and (not bool1)) then
				var10.Text = "Send"
			end
		end)

		return
	end

	local var23 = num2 + 1
	num2 = var23
	var10.Text = "Couldn't send"
	var23 = num2
	task.delay(3, function()
		if bool2 and (var23 == num2 and (not bool1)) then
			var10.Text = "Send"
		end
	end)
end)

script.Destroying:Connect(function()
	bool2 = false
end)

var10.Text = "Send"

--- ReplicatedStorage.ZonePlus v3.2.0 [ModuleScript]
-- y u r i

local var1 = game:GetService("RunService")
local var2 = var1:IsClient()
game:GetService("ReplicatedStorage")
local var3 = require(script.ZonePlusReference)
local var4 = script.ZoneController
local var5 = var1.Heartbeat
var2 = var2 and game:GetService("Players").LocalPlayer
local var6 = game:GetService("HttpService")
local var7 = require(script.Enum).enums
local var8 = require(script.Janitor)
local var9 = require(script.Signal)
local var10 = var3.getObject()
local var11 = var4.Tracker
local var12 = var4.CollectiveWorldModel
local var13 = require(var4)
local var14 = var10
var14 = var14 and var10:FindFirstChild(if game:GetService("RunService"):IsClient() then "Client" else "Server")
if var14 then
	local var16 = var10.Value
	return require(var16)
end

local tbl1 = {}
tbl1.__index = tbl1
if not var14 then
	var3.addToReplicatedStorage()
end

tbl1.enum = var7
tbl1.new = function(arg1)
	local tbl2 = {}
	setmetatable(tbl2, tbl1)
	local var3 = typeof(arg1)
	if var3 ~= "table" and var3 ~= "Instance" then
		error("The zone container must be a model, folder, basepart or table!")
	end

	tbl2.accuracy = var7.Accuracy.High
	tbl2.autoUpdate = true
	tbl2.respectUpdateQueue = true
	local var4 = var8.new()
	tbl2.janitor = var4
	tbl2._updateConnections = var4:add(var8.new(), "destroy")
	tbl2.container = arg1
	tbl2.zoneParts = {}
	tbl2.overlapParams = {}
	tbl2.region = nil
	tbl2.volume = nil
	tbl2.boundMin = nil
	tbl2.boundMax = nil
	tbl2.recommendedMaxParts = nil
	tbl2.zoneId = var6:GenerateGUID()
	tbl2.activeTriggers = {}
	tbl2.occupants = {}
	tbl2.trackingTouchedTriggers = {}
	tbl2.enterDetection = var7.Detection.Centre
	tbl2.exitDetection = var7.Detection.Centre
	tbl2._currentEnterDetection = nil
	tbl2._currentExitDetection = nil
	tbl2.totalPartVolume = 0
	tbl2.allZonePartsAreBlocks = true
	tbl2.trackedItems = {}
	tbl2.settingsGroupName = nil
	tbl2.worldModel = workspace
	tbl2.onItemDetails = {}
	tbl2.itemsToUntrack = {}
	var13.updateDetection(tbl2)
	tbl2.updated = var4:add(var9.new(), "destroy")
	local tbl3 = { "player", "part", "localPlayer", "item" }
	local tbl4 = { "entered", "exited" }
	for k1, v1 in pairs(tbl3) do
		local num1 = 0
		local num2 = 0
		for k2, v2 in pairs(tbl4) do
			local var5 = v2:sub(1, 1):upper() .. v2:sub(2)
			local var10 = var4:add(var9.new(true), "destroy")
			tbl2[v1 .. var5] = var10
			var10.connectionsChanged:Connect(function(arg1)
				if v1 == "localPlayer" and (not var2 and arg1 == 1) then
					local var3 = var5
					error(("Can only connect to 'localPlayer%s' on the client!"):format(var3))
				end

				num2 = num1
				local var4 = num1 + arg1
				num1 = var4
				if num2 == 0 and 0 < num1 then
					var13._registerConnection(tbl2, v1, var5)
					return
				end

				if 0 < num2 and num1 == 0 then
					var13._deregisterConnection(tbl2, v1)
				end
			end)

		end
	end

	tbl1.touchedConnectionActions = {}
	for k3, v3 in pairs(tbl3) do
		local var11 = tbl2[("_%sTouchedZone"):format(v3)]
		if not var11 then
			continue
		end

		tbl2.trackingTouchedTriggers[v3] = {}
		tbl1.touchedConnectionActions[v3] = function(arg1)
			var11(tbl2, arg1)
		end

	end

	tbl2:_update()
	var13._registerZone(tbl2)
	var4:add(function()
		var13._deregisterZone(tbl2)
	end, true)

	return tbl2
end

tbl1.fromRegion = function(arg1, arg2)
	local var1 = Instance.new("Model")
	local function createCube(arg1, arg2)
		if 2024 < arg2.X or (2024 < arg2.Y or 2024 < arg2.Z) then
			local var4 = arg2 * 0.25
			local var5 = arg2 * 0.5
			createCube(arg1 * CFrame.new(-var4.X, -var4.Y, -var4.Z), var5)
			createCube(arg1 * CFrame.new(-var4.X, -var4.Y, var4.Z), var5)
			createCube(arg1 * CFrame.new(-var4.X, var4.Y, -var4.Z), var5)
			createCube(arg1 * CFrame.new(-var4.X, var4.Y, var4.Z), var5)
			createCube(arg1 * CFrame.new(var4.X, -var4.Y, -var4.Z), var5)
			createCube(arg1 * CFrame.new(var4.X, -var4.Y, var4.Z), var5)
			createCube(arg1 * CFrame.new(var4.X, var4.Y, -var4.Z), var5)
			createCube(arg1 * CFrame.new(var4.X, var4.Y, var4.Z), var5)
			return
		end

		local var6 = Instance.new("Part")
		var6.CFrame = arg1
		var6.Size = arg2
		var6.Anchored = true
		var6.Parent = var1
	end

	createCube(arg1, arg2)
	local var2 = tbl1.new(var1)
	var2:relocate()
	return var2
end

tbl1._calculateRegion = function(_, arg2, arg3)
	local tbl1 = { Min = {}, Max = {} }
	for k1, v1 in pairs(tbl1) do
		v1.Values = {}
		v1.parseCheck = function(arg1, arg2)
			if k1 == "Min" then
				return arg1 <= arg2
			end

			if k1 == "Max" then
				return arg2 <= arg1
			end
		end

		v1.parse = function(arg1, arg2)
			for k1, v1 in pairs(arg2) do
				if not arg1.parseCheck(v1, arg1.Values[k1] or v1) then
					continue
				end

				arg1.Values[k1] = v1
			end
		end

	end

	for k2, v2 in pairs(arg2) do
		local var1 = v2.Size * 0.5
		local var2 = v2.CFrame * CFrame.new(var1.X, -var1.Y, -var1.Z)
		local tbl2 = {
			v2.CFrame * CFrame.new(-var1.X, -var1.Y, -var1.Z),
			v2.CFrame * CFrame.new(-var1.X, -var1.Y, var1.Z),
			v2.CFrame * CFrame.new(-var1.X, var1.Y, -var1.Z),
			v2.CFrame * CFrame.new(-var1.X, var1.Y, var1.Z),
			var2,
			v2.CFrame * CFrame.new(var1.X, -var1.Y, var1.Z),
			v2.CFrame * CFrame.new(var1.X, var1.Y, -var1.Z),
			v2.CFrame * CFrame.new(var1.X, var1.Y, var1.Z),
		}

		for k3, v3 in pairs(tbl2) do
			local var3, var4, var5 = v3:GetComponents()
			local tbl3 = { var3, var4, var5 }
			tbl1.Min:parse(tbl3)
			tbl1.Max:parse(tbl3)
		end
	end

	local tbl4 = {}
	local tbl5 = {}
	for k4, v4 in pairs(tbl1) do
		for k5, v5 in pairs(v4.Values) do
			local var6 = k4 == "Min" and tbl4 or tbl5
			local var7 = v5
			if not arg3 then
				var7 = math.floor((v5 + (if k4 == "Min" then -2 else 2) + 2) / 4) * 4
			end

			table.insert(var6, var7)
		end
	end

	local var8 = tbl4
	local var9 = Vector3.new(unpack(var8))
	local var10 = tbl5
	local var11 = Vector3.new(unpack(var10))
	return Region3.new(var9, var11), var9, var11
end

tbl1._displayBounds = function(arg1)
	if not arg1.displayBoundParts then
		arg1.displayBoundParts = true
		for k1, v1 in pairs({ BoundMin = arg1.boundMin, BoundMax = arg1.boundMax }) do
			local var1 = Instance.new("Part")
			var1.Anchored = true
			var1.CanCollide = false
			var1.Transparency = 0.5
			var1.Size = Vector3.new(1, 1, 1)
			var1.Color = Color3.fromRGB(255, 0, 0)
			var1.CFrame = CFrame.new(v1)
			var1.Name = k1
			var1.Parent = workspace
			arg1.janitor:add(var1, "Destroy")
		end
	end
end

tbl1._update = function(arg1)
	arg1._updateConnections:clean()
	local var2 = arg1.container
	local var4 = typeof(var2)
	local num1 = 0
	local tbl1 = {}
	local tbl2 = {}
	local var5
	if var4 == "table" then
		for k1, v1 in pairs(var2) do
			var5 = v1:IsA("BasePart")
			if not var5 then
				continue
			end

			table.insert(tbl1, v1)
		end
	elseif var4 == "Instance" then
		if var2:IsA("BasePart") then
			table.insert(tbl1, var2)
		else
			table.insert(tbl2, var2)
			for k2, v2 in pairs(var2:GetDescendants()) do
				if v2:IsA("BasePart") then
					table.insert(tbl1, v2)
				else
					table.insert(tbl2, v2)
				end
			end
		end
	end

	arg1.zoneParts = tbl1
	arg1.overlapParams = {}
	local bool1 = true
	for k3, v3 in pairs(tbl1) do
		local success, result = pcall(function()
			return v3.Shape.Name
		end)

		if result == "Block" then
			continue
		end

		bool1 = false
	end

	arg1.allZonePartsAreBlocks = bool1
	local var6 = OverlapParams.new()
	var6.FilterType = Enum.RaycastFilterType.Whitelist
	var6.MaxParts = #tbl1
	var6.FilterDescendantsInstances = tbl1
	arg1.overlapParams.zonePartsWhitelist = var6
	local var7 = OverlapParams.new()
	var7.FilterType = Enum.RaycastFilterType.Blacklist
	var7.FilterDescendantsInstances = tbl1
	arg1.overlapParams.zonePartsIgnorelist = var7
	local function update()
		if arg1.autoUpdate then
			local var2 = os.clock()
			if arg1.respectUpdateQueue then
				local var3 = num1 + 1
				num1 = var3
				var2 = var2 + 0.1
			end

			local var4 = nil
			var1.Heartbeat:Connect(function()
				if var2 <= os.clock() then
					var4:Disconnect()
					if arg1.respectUpdateQueue then
						local var1 = num1 - 1
						num1 = var1
					end

					if num1 == 0 and arg1.zoneId then
						arg1:_update()
					end
				end
			end)

		end
	end

	local tbl3 = { "Size", "Position" }
	for k4, v4 in pairs(tbl1) do
		for k5, v5 in pairs(tbl3) do
			arg1._updateConnections:add(v4:GetPropertyChangedSignal(v5):Connect(update), "Disconnect")
		end

		if v4.CollisionGroupId ~= 0 then
			error("Zone parts must belong to the 'Default' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
		end

		local function fn3()
			if v4.CollisionGroupId ~= 0 then
				error("Zone parts must belong to the 'Default' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
			end
		end

		arg1._updateConnections:add(v4:GetPropertyChangedSignal("CollisionGroupId"):Connect(fn3), "Disconnect")
	end

	local tbl4 = { "ChildAdded", "ChildRemoved" }
	for k6, v6 in pairs(tbl2) do
		for k7, v7 in pairs(tbl4) do
			arg1._updateConnections:add(arg1.container[v7]:Connect(function(arg1)
				if arg1:IsA("BasePart") then
					if arg1.autoUpdate then
						local var2 = os.clock()
						if arg1.respectUpdateQueue then
							local var3 = num1 + 1
							num1 = var3
							var2 = var2 + 0.1
						end

						local var4 = nil
						var1.Heartbeat:Connect(function()
							if var2 <= os.clock() then
								var4:Disconnect()
								if arg1.respectUpdateQueue then
									local var1 = num1 - 1
									num1 = var1
								end

								if num1 == 0 and arg1.zoneId then
									arg1:_update()
								end
							end
						end)

					end
				end
			end), "Disconnect")

		end
	end

	local var8, var9, var10 = arg1:_calculateRegion(tbl1)
	local var11, var12, var13 = arg1:_calculateRegion(tbl1, true)
	arg1.region = var8
	arg1.exactRegion = var11
	arg1.boundMin = var9
	arg1.boundMax = var10
	local var14 = var8.Size
	arg1.volume = var14.X * var14.Y * var14.Z
	arg1:_updateTouchedConnections()
	arg1.updated:Fire()
end

tbl1._updateOccupants = function(arg1, arg2, arg3)
	local var2 = arg1.occupants[arg2]
	if not var2 then
		var2 = {}
		arg1.occupants[arg2] = var2
	end

	local tbl1 = {}
	for k1, v1 in pairs(var2) do
		local var4 = arg3[k1]
		if var4 == nil or var4 ~= v1 then
			var2[k1] = nil
			if not tbl1.exited then
				tbl1.exited = {}
			end

			table.insert(tbl1.exited, k1)
		end
	end

	for k2, v2 in pairs(arg3) do
		if var2[k2] ~= nil then
			continue
		end

		local var5 = k2:IsA("Player") and k2.Character or true
		var2[k2] = var5
		if not tbl1.entered then
			tbl1.entered = {}
		end

		table.insert(tbl1.entered, k2)
	end

	return tbl1
end

tbl1._formTouchedConnection = function(arg1, arg2)
	local var1 = "_touchedJanitor" .. arg2
	local var3 = arg1[var1]
	if var3 then
		var3:clean()
	else
		var3 = arg1.janitor:add(var8.new(), "destroy")
		arg1[var1] = var3
	end

	arg1:_updateTouchedConnection(arg2)
end

tbl1._updateTouchedConnection = function(arg1, arg2)
	local var2 = arg1["_touchedJanitor" .. arg2]
	if not var2 then
		return
	end

	for k1, v1 in pairs(arg1.zoneParts) do
		var2:add(v1.Touched:Connect(arg1.touchedConnectionActions[arg2], arg1), "Disconnect")
	end
end

tbl1._updateTouchedConnections = function(arg1)
	for k1, v1 in pairs(arg1.touchedConnectionActions) do
		local var1 = arg1["_touchedJanitor" .. k1]
		if not var1 then
			continue
		end

		var1:cleanup()
		arg1:_updateTouchedConnection(k1)
	end
end

tbl1._disconnectTouchedConnection = function(arg1, arg2)
	local var1 = "_touchedJanitor" .. arg2
	local var3 = arg1[var1]
	if var3 then
		var3:cleanup()
		arg1[var1] = nil
	end
end

tbl1._partTouchedZone = function(arg1, arg2)
	local var1 = arg1.trackingTouchedTriggers.part
	if var1[arg2] then
		return
	end

	local var2 = os.clock()
	local var3 = arg1.janitor:add(var8.new(), "destroy")
	var1[arg2] = var3
	local num1 = 0
	local bool1 = false
	local var4 = arg2.Position
	if not ({ Seat = true, VehicleSeat = true })[arg2.ClassName] and ({ HumanoidRootPart = true })[arg2.Name] then
		arg2.CanTouch = false
	end

	local var6 = math.round(arg2.Size.X * arg2.Size.Y * arg2.Size.Z * 100000) * 1e-05
	local var9 = arg1.totalPartVolume + var6
	arg1.totalPartVolume = var9
	var3:add(var5:Connect(function()
		local var6 = os.clock()
		if num1 <= var6 then
			local var8 = var7.Accuracy.getProperty(arg1.accuracy)
			num1 = var6 + var8
			local var9 = arg1:findPoint(arg2.CFrame)
			var9 = var9 or arg1:findPart(arg2)
			if not bool1 then
				if var9 then
					bool1 = true
					arg1.partEntered:Fire(arg2)
					return
				end

				if not (1.5 < (arg2.Position - var4).Magnitude and var8 <= var6 - var2) then
					return
				end

				if var8 > var6 - var2 then
					return
				end

				var3:cleanup()
				return
			end

			if not var9 then
				bool1 = false
				var4 = arg2.Position
				var2 = os.clock()
				arg1.partExited:Fire(arg2)
			end
		end
	end), "Disconnect")

	var3:add(function()
		var1[arg2] = nil
		arg2.CanTouch = true
		arg1.totalPartVolume = math.round((arg1.totalPartVolume - var6) * 100000) * 1e-05
	end, true)
end

local tbl2 = {
	Ball = function(arg1)
		return "GetPartBoundsInRadius", { arg1.Position, arg1.Size.X }
	end,
	Block = function(arg1)
		return "GetPartBoundsInBox", { arg1.CFrame, arg1.Size }
	end,
	Other = function(arg1)
		return "GetPartsInPart", { arg1 }
	end,
}

tbl1._getRegionConstructor = function(arg1, arg2, arg3)
	local success, result = pcall(function()
		return arg2.Shape.Name
	end)

	local var7 = nil
	local var8 = nil
	if success then
		local var12 = tbl2[result]
		if arg1.allZonePartsAreBlocks and var12 then
			local var13, var14 = var12(arg2)
			var7 = var13
			var8 = var14
		end
	end

	if not var7 then
		var7 = "GetPartsInPart"
		var8 = { arg2 }
	end

	if arg3 then
		table.insert(var8, arg3)
	end

	return var7, var8
end

tbl1.findLocalPlayer = function(arg1)
	if not var2 then
		error("Can only call 'findLocalPlayer' on the client!")
	end

	local var1 = var2
	return arg1:findPlayer(var1)
end

tbl1._find = function(arg1, arg2, arg3)
	var13.updateDetection(arg1)
	for k1, v1 in pairs((var13.getTouchingZones(arg3, false, arg1._currentEnterDetection, var13.trackers[arg2]))) do
		if v1 ~= arg1 then
			continue
		end

		return true
	end

	return false
end

tbl1.findPlayer = function(arg1, arg2)
	local var1 = arg2.Character
	local var2 = var1
	if not (var2 and var1:FindFirstChildOfClass("Humanoid")) then
		return false
	end

	local str1 = "player"
	local var3 = arg2.Character
	return arg1:_find(str1, var3)
end

tbl1.findItem = function(arg1, arg2)
	local str1 = "item"
	local var1 = arg2
	return arg1:_find(str1, var1)
end

tbl1.findPart = function(arg1, arg2)
	local var1, var2 = arg1:_getRegionConstructor(arg2, arg1.overlapParams.zonePartsWhitelist)
	local var3 = var2
	local var4 = arg1.worldModel[var1](arg1.worldModel, unpack(var3))
	if 0 < (#var4) then
		return true, var4
	end

	return false
end

tbl1.getCheckerPart = function(arg1)
	local var2 = arg1.checkerPart
	if not var2 then
		var2 = arg1.janitor:add(Instance.new("Part"), "Destroy")
		var2.Size = Vector3.new(0.1, 0.1, 0.1)
		var2.Name = "ZonePlusCheckerPart"
		var2.Anchored = true
		var2.Transparency = 1
		var2.CanCollide = false
		arg1.checkerPart = var2
	end

	local var4 = arg1.worldModel
	if var4 == workspace then
		var4 = var13.getWorkspaceContainer()
	end

	if var2.Parent ~= var4 then
		var2.Parent = var4
	end

	return var2
end

tbl1.findPoint = function(arg1, arg2)
	local var2 = arg2
	if typeof(arg2) == "Vector3" then
		var2 = CFrame.new(arg2)
	end

	local var3 = arg1:getCheckerPart()
	var3.CFrame = var2
	local var4, var5 = arg1:_getRegionConstructor(var3, arg1.overlapParams.zonePartsWhitelist)
	local var6 = var5
	local var7 = arg1.worldModel[var4](arg1.worldModel, unpack(var6))
	if 0 < (#var7) then
		return true, var7
	end

	return false
end

tbl1._getAll = function(arg1, arg2)
	var13.updateDetection(arg1)
	local var1 = arg1._currentEnterDetection
	local var3 = var13._getZonesAndItems(arg2, { self = true }, arg1.volume, false, var1)[arg1]
	local tbl1 = {}
	if var3 then
		for k1, v1 in pairs(var3) do
			table.insert(tbl1, k1)
		end
	end

	return tbl1
end

tbl1.getPlayers = function(arg1)
	local str1 = "player"
	return arg1:_getAll(str1)
end

tbl1.getItems = function(arg1)
	local str1 = "item"
	return arg1:_getAll(str1)
end

tbl1.getParts = function(arg1)
	local tbl1 = {}
	local var1
	if arg1.activeTriggers.part then
		for k1, v1 in pairs(arg1.trackingTouchedTriggers.part) do
			table.insert(tbl1, k1)
		end

		return tbl1
	end

	for k2, v2 in pairs((arg1.worldModel:GetPartBoundsInBox(arg1.region.CFrame, arg1.region.Size, arg1.overlapParams.zonePartsIgnorelist))) do
		if not arg1:findPart(v2) then
			continue
		end

		table.insert(tbl1, v2)
	end

	return tbl1
end

tbl1.getRandomPoint = function(arg1)
	local var1 = arg1.exactRegion
	local var2 = var1.Size
	local var3 = var1.CFrame
	local var4 = Random.new()
	local var5 = nil
	local var6 = nil
	local var7 = nil
	local var8 = nil
	repeat
		local var9 = -var2.Z / 2
		local var10 = var2.Z / 2
		var5 = var3 * CFrame.new(var4:NextNumber(-var2.X / 2, var2.X / 2), var4:NextNumber(-var2.Y / 2, var2.Y / 2), var4:NextNumber(var9, var10))
		local var11, var12 = arg1:findPoint(var5)
		var7 = var12
		if var11 then
			var8 = true
		end
	until var8

	return var5.Position, var7
end

tbl1.setAccuracy = function(arg1, arg2)
	local var3 = tonumber(arg2)
	if not var3 then
		var3 = var7.Accuracy[arg2]
		if not var3 then
			local var5 = arg2
			error(("'%s' is an invalid enumName!"):format(var5))
		end
	else
		if not var7.Accuracy.getName(var3) then
			local var8 = var3
			error(("%s is an invalid enumId!"):format(var8))
		end
	end

	arg1.accuracy = var3
end

tbl1.setDetection = function(arg1, arg2)
	local var3 = tonumber(arg2)
	if not var3 then
		var3 = var7.Detection[arg2]
		if not var3 then
			local var5 = arg2
			error(("'%s' is an invalid enumName!"):format(var5))
		end
	else
		if not var7.Detection.getName(var3) then
			local var8 = var3
			error(("%s is an invalid enumId!"):format(var8))
		end
	end

	arg1.enterDetection = var3
	arg1.exitDetection = var3
end

tbl1.trackItem = function(arg1, arg2)
	local var1 = arg2:IsA("BasePart")
	local bool1 = false
	bool1 = var1 or arg2:FindFirstChild("HumanoidRootPart")
	assert(var1 or bool1, "Only BaseParts or Characters/NPCs can be tracked!")
	if arg1.trackedItems[arg2] then
		return
	end

	if arg1.itemsToUntrack[arg2] then
		arg1.itemsToUntrack[arg2] = nil
	end

	local var2 = arg1.janitor:add(var8.new(), "destroy")
	local tbl1 = { janitor = var2, item = arg2, isBasePart = var1, isCharacter = bool1 }
	arg1.trackedItems[arg2] = tbl1
	var2:add(arg2.AncestryChanged:Connect(function()
		if not arg2:IsDescendantOf(game) then
			arg1:untrackItem(arg2)
		end
	end), "Disconnect")

	require(var11).itemAdded:Fire(tbl1)
end

tbl1.untrackItem = function(arg1, arg2)
	local var2 = arg1.trackedItems[arg2]
	if var2 then
		var2.janitor:destroy()
	end

	arg1.trackedItems[arg2] = nil
	require(var11).itemRemoved:Fire(var2)
end

tbl1.bindToGroup = function(arg1, arg2)
	arg1:unbindFromGroup()
	local var1 = var13.getGroup(arg2)
	local var2 = (var1 or var13.setGroup(arg2))._memberZones
	var2[arg1.zoneId] = arg1
	arg1.settingsGroupName = arg2
end

tbl1.unbindFromGroup = function(arg1)
	if arg1.settingsGroupName then
		local var3 = var13.getGroup(arg1.settingsGroupName)
		if var3 then
			var3._memberZones[arg1.zoneId] = nil
		end

		arg1.settingsGroupName = nil
	end
end

tbl1.relocate = function(arg1)
	if arg1.hasRelocated then
		return
	end

	local var1 = require(var12).setupWorldModel(arg1)
	arg1.worldModel = var1
	arg1.hasRelocated = true
	local var2 = arg1.container
	if typeof(var2) == "table" then
		var2 = Instance.new("Folder")
		for k1, v1 in pairs(arg1.zoneParts) do
			v1.Parent = var2
		end
	end

	arg1.relocationContainer = arg1.janitor:add(var2, "Destroy", "RelocationContainer")
	var2.Parent = var1
end

tbl1._onItemCallback = function(arg1, arg2, arg3, arg4, arg5)
	local var2 = arg1.onItemDetails[arg4]
	if not var2 then
		var2 = {}
		arg1.onItemDetails[arg4] = var2
	end

	if #var2 == 0 then
		arg1.itemsToUntrack[arg4] = true
	end

	table.insert(var2, arg4)
	arg1:trackItem(arg4)
	if arg1:findItem(arg4) == arg3 then
		arg5()
		if not arg1.itemsToUntrack[arg4] then
			return
		end

		arg1.itemsToUntrack[arg4] = nil
		arg1:untrackItem(arg4)
		return
	end

	local var3 = nil
	arg1[arg2]:Connect(function(arg1)
		if var3 and arg1 == arg4 then
			var3:Disconnect()
			var3 = nil
			arg5()
			if arg1.itemsToUntrack[arg4] then
				arg1.itemsToUntrack[arg4] = nil
				arg1:untrackItem(arg4)
			end
		end
	end)
end

tbl1.onItemEnter = function(arg1, ...)
	arg1:_onItemCallback("itemEntered", true, ...)
end

tbl1.onItemExit = function(arg1, ...)
	arg1:_onItemCallback("itemExited", false, ...)
end

tbl1.destroy = function(arg1)
	arg1:unbindFromGroup()
	arg1.janitor:destroy()
end

tbl1.Destroy = tbl1.destroy
return tbl1

--- ReplicatedStorage.ZonePlus v3.2.0.Enum [ModuleScript]
-- y u r i

local tbl1 = {}
local tbl2 = {
	enums = tbl1,
	createEnum = function(arg1, arg2)
		assert(typeof(arg1) == "string", "bad argument #1 - enums must be created using a string name!")
		assert(typeof(arg2) == "table", "bad argument #2 - enums must be created using a table!")
		local var1 = arg1
		assert(not tbl1[arg1], ("enum '%s' already exists!"):format(var1))
		local tbl2 = {}
		local tbl3 = {}
		local tbl4 = {}
		local tbl5 = {}
		var1 = {
			getName = function(arg1)
				arg1 = tostring(arg1)
				local var1 = tbl2[arg1]
				var1 = var1 or tbl3[arg1]
				if var1 then
					return arg2[var1][1]
				end
			end,
			getValue = function(arg1)
				arg1 = tostring(arg1)
				local var1 = tbl4[arg1]
				var1 = var1 or tbl3[arg1]
				if var1 then
					return arg2[var1][2]
				end
			end,
			getProperty = function(arg1)
				arg1 = tostring(arg1)
				local var1 = tbl4[arg1]
				var1 = var1 or tbl2[arg1]
				if var1 then
					return arg2[var1][3]
				end
			end,
		}

		for k1, v1 in pairs(arg2) do
			local var2 = k1
			assert(typeof(v1) == "table", ("bad argument #2.%s - details must only be comprised of tables!"):format(var2))
			local var3 = v1[1]
			local var4 = k1
			assert(typeof(var3) == "string", ("bad argument #2.%s.1 - detail name must be a string!"):format(var4))
			var4 = k1
			local var5 = var3
			assert(typeof(not tbl4[var3]), ("bad argument #2.%s.1 - the detail name '%s' already exists!"):format(var4, var5))
			var4 = k1
			var5 = var3
			assert(typeof(not var1[var3]), ("bad argument #2.%s.1 - that name is reserved."):format(var4, var5))
			tbl4[tostring(var3)] = k1
			local var6 = v1[2]
			local var7 = tostring(var6)
			local var8 = k1
			local var9 = var7
			assert(typeof(not tbl2[var7]), ("bad argument #2.%s.2 - the detail value '%s' already exists!"):format(var8, var9))
			tbl2[var7] = k1
			local var11 = v1[3]
			if var11 then
				var9 = k1
				local var12 = tostring(var11)
				assert(typeof(not tbl3[var11]), ("bad argument #2.%s.3 - the detail property '%s' already exists!"):format(var9, var12))
				tbl3[tostring(var11)] = k1
			end

			tbl5[var3] = var6
			setmetatable(tbl5, { __index = function(_, arg2)
				return var1[arg2]
			end })

		end

		tbl1[arg1] = tbl5
		return tbl5
	end,
	getEnums = function()
		return tbl1
	end,
}

local var1 = tbl2.createEnum
for k1, v1 in pairs(script:GetChildren()) do
	if not v1:IsA("ModuleScript") then
		continue
	end

	var1(v1.Name, (require(v1)))
end

return tbl2

--- ReplicatedStorage.ZonePlus v3.2.0.Enum.Accuracy [ModuleScript]
-- y u r i

return { { "Low", 1, 1 }, { "Medium", 2, 0.5 }, { "High", 3, 0.1 }, { "Precise", 4, 0 } }

--- ReplicatedStorage.ZonePlus v3.2.0.Enum.Detection [ModuleScript]
-- y u r i

return { { "WholeBody", 1 }, { "Centre", 2 } }

--- ReplicatedStorage.ZonePlus v3.2.0.Janitor [ModuleScript]
-- y u r i

local var1 = newproxy(true)
local var2 = game:GetService("RunService").Heartbeat
local var3 = getmetatable(var1)
var3.__tostring = function()
	return "IndicesReference"
end

var3 = newproxy(true)
local var4 = getmetatable(var3)
var4.__tostring = function()
	return "LinkToInstanceIndex"
end

var4 = { ClassName = "Janitor", __index = { CurrentlyCleaning = true, [var1] = nil } }
var4.new = function()
	return (setmetatable({ CurrentlyCleaning = false, [var1] = nil }, var4))
end

var4.Is = function(arg1)
	local bool1 = false
	if type(arg1) == "table" then
		bool1 = getmetatable(arg1) == var4
	end

	return bool1
end

var4.is = var4.Is
local tbl1 = { ["function"] = true, RBXScriptConnection = "Disconnect" }
var4.__index.Add = function(arg1, arg2, arg3, arg4)
	if arg4 == nil then
		arg4 = newproxy(false)
	end

	if arg4 then
		arg1:Remove(arg4)
		local var3 = arg1[var1]
		if not var3 then
			var3 = {}
			arg1[var1] = var3
		end

		var3[arg4] = arg2
	end

	local var5 = arg3
	if not var5 then
		var5 = tbl1[typeof(arg2)]
		var5 = var5 or "Destroy"
	end

	arg3 = var5
	if type(arg2) ~= "function" and (not arg2[arg3]) then
		local var6 = nil
		local num1 = 2
		local str1 = "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s"
		local var7 = tostring(arg2)
		local var8 = tostring(arg3)
		warn(string.format(str1, var7, var8, debug.traceback(var6, num1)))
	end

	arg1[arg2] = arg3
	return arg2, arg4
end

var4.__index.Give = var4.__index.Add
var4.__index.AddObject = function(arg1, arg2)
	local var1 = newproxy(false)
	return arg1:Add(arg2, false, var1), var1
end

var4.__index.GiveObject = var4.__index.AddObject
var4.__index.Remove = function(arg1, arg2)
	local var5 = arg1[var1]
	if var5 then
		local var8 = var5[arg2]
		if var8 then
			local var10 = arg1[var8]
			if var10 then
				if var10 == true then
					var8()
				else
					local var12 = var8[var10]
					if var12 then
						var12(var8)
					end
				end

				arg1[var8] = nil
			end

			var5[arg2] = nil
		end
	end

	return arg1
end

var4.__index.Get = function(arg1, arg2)
	local var3 = arg1[var1]
	if var3 then
		return var3[arg2]
	end
end

var4.__index.Cleanup = function(arg1)
	if not arg1.CurrentlyCleaning then
		arg1.CurrentlyCleaning = nil
		for k1, v1 in next, arg1 do
			if k1 == var1 then
				continue
			end

			local var3 = type(k1)
			if var3 == "string" or var3 == "number" then
				arg1[k1] = nil
			elseif v1 == true then
				k1()
			else
				local var5 = k1[v1]
				if var5 then
					var5(k1)
				end
			end
		end

		local var7 = arg1[var1]
		if var7 then
			for k2 in next, var7 do
				var7[k2] = nil
			end

			arg1[var1] = {}
		end

		arg1.CurrentlyCleaning = false
	end
end

var4.__index.Clean = var4.__index.Cleanup
var4.__index.Destroy = function(arg1)
	arg1:Cleanup()
end

var4.__call = var4.__index.Cleanup
local tbl2 = { Connected = true }
tbl2.__index = tbl2
tbl2.Disconnect = function(arg1)
	if arg1.Connected then
		arg1.Connected = false
		arg1.Connection:Disconnect()
	end
end

tbl2.__tostring = function(arg1)
	return "Disconnect<" .. tostring(arg1.Connected) .. ">"
end

var4.__index.LinkToInstance = function(arg1, arg2, arg3)
	local var1 = setmetatable({}, tbl2)
	local var4 = arg2.Parent == nil
	local var5 = nil
	local var6 = arg3 and newproxy(false) or var3
	var5 = arg2.AncestryChanged:Connect(function(_, arg2)
		if var1.Connected then
			var4 = arg2 == nil
			if var4 then
				coroutine.wrap(function()
					var2:Wait()
					if not var1.Connected then
						return
					end

					if not var5.Connected then
						arg1:Cleanup()
						return
					end

					while var4 and var5.Connected and var1.Connected do
						var2:Wait()
					end

					if var1.Connected and var4 then
						arg1:Cleanup()
					end
				end)()

			end
		end
	end)

	var1.Connection = var5
	if var4 then
		local var7 = nil
		local var8 = arg2.Parent
		if var1.Connected then
			var4 = var8 == nil
			var7 = nil
			if var4 then
				coroutine.wrap(function()
					var2:Wait()
					if not var1.Connected then
						return
					end

					if not var5.Connected then
						arg1:Cleanup()
						return
					end

					while var4 and var5.Connected and var1.Connected do
						var2:Wait()
					end

					if var1.Connected and var4 then
						arg1:Cleanup()
					end
				end)()

			end
		end
	end

	local var9 = var1
	local str1 = "Disconnect"
	local var10 = var6
	return arg1:Add(var9, str1, var10)
end

var4.__index.LinkToInstances = function(arg1, ...)
	local var1 = var4.new()
	for k1, v1 in ipairs({ ... }) do
		var1:Add(arg1:LinkToInstance(v1, true), "Disconnect")
	end

	return var1
end

for k1, v1 in next, var4.__index do
	local var5 = string.sub(string.lower(k1), 1, 1) .. string.sub(k1, 2)
	var4.__index[var5] = v1
end

return var4

--- ReplicatedStorage.ZonePlus v3.2.0.OldSignal [ModuleScript]
-- y u r i

local var1 = game:GetService("HttpService")
local var2 = game:GetService("RunService").Heartbeat
local tbl1 = {}
tbl1.__index = tbl1
tbl1.ClassName = "Signal"
tbl1.totalConnections = 0
tbl1.new = function(arg1)
	local var1 = setmetatable({}, tbl1)
	if arg1 then
		var1.connectionsChanged = tbl1.new()
	end

	var1.connections = {}
	var1.totalConnections = 0
	var1.waiting = {}
	var1.totalWaiting = 0
	return var1
end

tbl1.Fire = function(arg1, ...)
	for k1, v1 in pairs(arg1.connections) do
		task.spawn(v1.Handler, ...)
	end

	if 0 < arg1.totalWaiting then
		local var1 = table.pack(...)
		for k2, v2 in pairs(arg1.waiting) do
			arg1.waiting[k2] = var1
		end
	end
end

tbl1.fire = tbl1.Fire
tbl1.Connect = function(arg1, arg2)
	if type(arg2) ~= "function" then
		error(("connect(%s)"):format((typeof(arg2))), 2)
	end

	local var2 = var1:GenerateGUID(false)
	local tbl1 = { Connected = true, ConnectionId = var2, Handler = arg2 }
	arg1.connections[var2] = tbl1
	tbl1.Disconnect = function(_)
		arg1.connections[var2] = nil
		tbl1.Connected = false
		local var1 = arg1
		local var3 = var1.totalConnections - 1
		var1.totalConnections = var3
		if arg1.connectionsChanged then
			arg1.connectionsChanged:Fire(-1)
		end
	end

	tbl1.Destroy = tbl1.Disconnect
	tbl1.destroy = tbl1.Disconnect
	tbl1.disconnect = tbl1.Disconnect
	local var3 = arg1.totalConnections + 1
	arg1.totalConnections = var3
	if arg1.connectionsChanged then
		arg1.connectionsChanged:Fire(1)
	end

	return tbl1
end

tbl1.connect = tbl1.Connect
tbl1.Wait = function(arg1)
	local var3 = var1:GenerateGUID(false)
	arg1.waiting[var3] = true
	local var4 = arg1.totalWaiting + 1
	arg1.totalWaiting = var4
	repeat
		var2:Wait()
	until arg1.waiting[var3] ~= true

	var4 = arg1.totalWaiting - 1
	arg1.totalWaiting = var4
	arg1.waiting[var3] = nil
	local var5 = arg1.waiting[var3]
	return unpack(var5)
end

tbl1.wait = tbl1.Wait
tbl1.Destroy = function(arg1)
	if arg1.bindableEvent then
		arg1.bindableEvent:Destroy()
		arg1.bindableEvent = nil
	end

	local var2
	if arg1.connectionsChanged then
		var2 = arg1.totalConnections
		arg1.connectionsChanged:Fire(-var2)
		arg1.connectionsChanged:Destroy()
		arg1.connectionsChanged = nil
	end

	arg1.totalConnections = 0
	for k1, v1 in pairs(arg1.connections) do
		arg1.connections[k1] = nil
	end
end

tbl1.destroy = tbl1.Destroy
tbl1.Disconnect = tbl1.Destroy
tbl1.disconnect = tbl1.Destroy
return tbl1

--- ReplicatedStorage.ZonePlus v3.2.0.Signal [ModuleScript]
-- y u r i

local var1 = nil
local function acquireRunnerThreadAndCallEventHandler(arg1, ...)
	local var2 = var1
	var1 = nil
	arg1(...)
	var1 = var2
end

local tbl1 = {}
tbl1.__index = tbl1
tbl1.new = function(arg1, arg2)
	return (setmetatable({ _connected = true, _signal = arg1, _fn = arg2, _next = false }, tbl1))
end

tbl1.Disconnect = function(arg1)
	assert(arg1._connected, "Can't disconnect a connection twice.", 2)
	arg1._connected = false
	local var1 = arg1._signal
	if var1._handlerListHead == arg1 then
		var1._handlerListHead = arg1._next
	else
		local var2 = var1._handlerListHead
		while var2 and var2._next ~= arg1 do
			var2 = var2._next
		end

		if var2 then
			var2._next = arg1._next
		end
	end

	if var1.connectionsChanged then
		local var3 = var1.totalConnections - 1
		var1.totalConnections = var3
		var1.connectionsChanged:Fire(-1)
	end
end

setmetatable(tbl1, {
	__index = function(_, arg2)
		error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(arg2))), 2)
	end,
	__newindex = function(_, arg2, _)
		error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(arg2))), 2)
	end,
})

local tbl2 = {}
tbl2.__index = tbl2
tbl2.new = function(arg1)
	local var1 = setmetatable({ _handlerListHead = false }, tbl2)
	if arg1 then
		var1.totalConnections = 0
		var1.connectionsChanged = tbl2.new()
	end

	return var1
end

tbl2.Connect = function(arg1, arg2)
	local var1 = tbl1.new(arg1, arg2)
	if arg1._handlerListHead then
		var1._next = arg1._handlerListHead
		arg1._handlerListHead = var1
	else
		arg1._handlerListHead = var1
	end

	if arg1.connectionsChanged then
		local var2 = arg1.totalConnections + 1
		arg1.totalConnections = var2
		arg1.connectionsChanged:Fire(1)
	end

	return var1
end

tbl2.DisconnectAll = function(arg1)
	arg1._handlerListHead = false
	if arg1.connectionsChanged then
		arg1.connectionsChanged:Fire(-arg1.totalConnections)
		arg1.connectionsChanged:Destroy()
		arg1.connectionsChanged = nil
		arg1.totalConnections = 0
	end
end

tbl2.Destroy = tbl2.DisconnectAll
tbl2.destroy = tbl2.DisconnectAll
local function runEventHandlerInFreeThread(...)
	acquireRunnerThreadAndCallEventHandler(...)
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

tbl2.Fire = function(arg1, ...)
	local var2 = arg1._handlerListHead
	while var2 do
		if var2._connected then
			if not var1 then
				var1 = coroutine.create(runEventHandlerInFreeThread)
			end

			task.spawn(var1, var2._fn, ...)
		end

		var2 = var2._next
	end
end

tbl2.Wait = function(arg1)
	local var1 = nil
	local var2 = coroutine.running()
	arg1:Connect(function(...)
		var1:Disconnect()
		task.spawn(var2, ...)
	end)

	return coroutine.yield()
end

return tbl2

--- ReplicatedStorage.ZonePlus v3.2.0.VERSION [ModuleScript]
-- y u r i


--- ReplicatedStorage.ZonePlus v3.2.0.ZoneController [ModuleScript]
-- y u r i

require(script.Parent.Signal)
local var1 = game:GetService("RunService")
local var2 = var1:IsClient()
local var3 = game:GetService("Players")
local var4 = require(script.Tracker)
local var5 = require(script.Parent.Janitor)
local var6 = require(script.CollectiveWorldModel)
local var7 = require(script.Parent.Enum).enums
local tbl1 = { player = var4.new("player") }
tbl1.item = var4.new("item")
local tbl2 = { trackers = tbl1 }
local tbl3 = {}
local num1 = 0
var2 = var2 and var3.LocalPlayer
local tbl4 = {}
tbl2._registerZone = function(arg1)
	tbl4[arg1] = true
	local var1 = arg1.janitor:add(var5.new(), "destroy")
	arg1._registeredJanitor = var1
	var1:add(arg1.updated:Connect(function()
		tbl2._updateZoneDetails()
	end), "Disconnect")

	tbl2._updateZoneDetails()
end

tbl2._deregisterZone = function(arg1)
	tbl4[arg1] = nil
	arg1._registeredJanitor:destroy()
	arg1._registeredJanitor = nil
	tbl2._updateZoneDetails()
end

local num2 = 0
local tbl5 = {}
local tbl6 = {
	player = function(arg1)
		local str1 = "player"
		local var1 = tbl3
		local var2 = num1
		local bool1 = true
		local var3 = arg1
		return tbl2._getZonesAndItems(str1, var1, var2, bool1, var3)
	end,
	localPlayer = function(arg1)
		local var3 = var2.Character
		local tbl3 = {}
		if not var3 then
			return tbl3
		end

		for k1, v1 in pairs((tbl2.getTouchingZones(var3, true, arg1, tbl1.player))) do
			if not v1.activeTriggers.localPlayer then
				continue
			end

			local var5 = tbl3[v1]
			local var6 = var2
			if not var5 then
				var5 = {}
				tbl3[v1] = var5
			end

			local var7 = var6:IsA("Player")
			var5[var6] = var7 and var6.Character or true
		end

		return tbl3
	end,
	item = function(arg1)
		local str1 = "item"
		local var1 = tbl3
		local var2 = num1
		local bool1 = true
		local var3 = arg1
		return tbl2._getZonesAndItems(str1, var1, var2, bool1, var3)
	end,
}

tbl2._registerConnection = function(arg1, arg2)
	local num1 = 0
	for k1, v1 in pairs(arg1.activeTriggers) do
		num1 = num1 + 1
	end

	local var1 = num2 + 1
	num2 = var1
	if num1 == 0 then
		tbl3[arg1] = true
		tbl2._updateZoneDetails()
	end

	var1 = tbl5[arg2]
	tbl5[arg2] = var1 and var1 + 1 or 1
	arg1.activeTriggers[arg2] = true
	if arg1.touchedConnectionActions[arg2] then
		arg1:_formTouchedConnection(arg2)
	end

	if tbl6[arg2] then
		tbl2._formHeartbeat(arg2)
	end
end

tbl2.updateDetection = function(arg1)
	for k1, v1 in pairs({ enterDetection = "_currentEnterDetection", exitDetection = "_currentExitDetection" }) do
		local var2 = arg1[k1]
		local var3 = var4.getCombinedTotalVolumes()
		if var2 == var7.Detection.Automatic then
			var2 = if 729000 < var3 then var7.Detection.Centre else var7.Detection.WholeBody
		end

		arg1[v1] = var2
	end
end

local tbl7 = {}
local var8 = var1.Heartbeat
tbl2._formHeartbeat = function(arg1)
	if tbl7[arg1] then
		return
	end

	local num1 = 0
	local var1 = var8:Connect(function()
		local var2 = os.clock()
		if num1 <= var2 then
			local var3 = nil
			local var4 = nil
			for k1, v1 in pairs(tbl3) do
				local var5 = arg1
				if not k1.activeTriggers[var5] then
					continue
				end

				local var8 = k1.accuracy
				if var3 == nil or var8 < var3 then
					var3 = var8
				end

				var5 = k1
				tbl2.updateDetection(var5)
				local var10 = k1._currentEnterDetection
				if var4 == nil or var10 < var4 then
					var4 = var10
				end
			end

			local var11 = tbl6[arg1](var4)
			local var12 = var3
			local tbl1 = {}
			local tbl4 = {}
			for k2, v2 in pairs(var11) do
				local var13 = k2.settingsGroupName
				var13 = var13 and tbl2.getGroup(k2.settingsGroupName)
				if not var13 then
					continue
				end

				if var13.onlyEnterOnceExitedAll ~= true then
					continue
				end

				for k3, v3 in pairs(v2) do
					local var14 = k2.settingsGroupName
					local var16 = tbl1[var14]
					if not var16 then
						var16 = {}
						var14 = k2.settingsGroupName
						tbl1[var14] = var16
					end

					var16[k3] = k2
				end

				tbl4[k2] = v2
			end

			for k4, v4 in pairs(tbl4) do
				local var17 = tbl1[k4.settingsGroupName]
				if not var17 then
					continue
				end

				for k5, v5 in pairs(v4) do
					local var18 = var17[k5]
					if not var18 or var18 == k4 then
						continue
					end

					local var19 = nil
					v4[k5] = var19
				end
			end

			local tbl5 = { {}, {} }
			for k6, v6 in pairs(tbl3) do
				local var20 = k6.activeTriggers[arg1]
				if not var20 then
					continue
				end

				local var21 = var11[k6]
				var21 = var21 or {}
				var20 = k6.accuracy
				local bool1 = false
				for k7, v7 in pairs(var21) do
					bool1 = true
					break
				end

				if bool1 and var12 < var20 then
					var12 = var20
				end

				local var22 = var21
				local var23 = k6:_updateOccupants(arg1, var22)
				tbl5[1][k6] = var23.exited
				tbl5[2][k6] = var23.entered
			end

			local tbl7 = { "Exited", "Entered" }
			for k8, v8 in pairs(tbl5) do
				local var24 = arg1 .. tbl7[k8]
				for k9, v9 in pairs(v8) do
					local var25 = k9[var24]
					if not var25 then
						continue
					end

					for k10, v10 in pairs(v9) do
						var25:Fire(v10)
					end
				end
			end

			num1 = var2 + var7.Accuracy.getProperty(var12)
		end
	end)

	tbl7[arg1] = var1
end

tbl2._deregisterConnection = function(arg1, arg2)
	local var1 = num2 - 1
	num2 = var1
	if tbl5[arg2] == 1 then
		tbl5[arg2] = nil
		var1 = tbl7[arg2]
		if var1 then
			tbl7[arg2] = nil
			var1:Disconnect()
		end
	else
		var1 = tbl5
		local var2 = var1[arg2] - 1
		var1[arg2] = var2
	end

	arg1.activeTriggers[arg2] = nil
	var1 = 0
	for k1, v1 in pairs(arg1.activeTriggers) do
		var1 = var1 + 1
	end

	if var1 == 0 then
		tbl3[arg1] = nil
		tbl2._updateZoneDetails()
	end

	if arg1.touchedConnectionActions[arg2] then
		arg1:_disconnectTouchedConnection(arg2)
	end
end

local tbl8 = {}
local tbl9 = {}
local tbl10 = {}
local tbl11 = {}
tbl2._updateZoneDetails = function()
	tbl8 = {}
	tbl9 = {}
	tbl10 = {}
	tbl11 = {}
	num1 = 0
	for k1, v1 in pairs(tbl4) do
		local var2 = tbl3[k1]
		if var2 then
			local var3 = num1 + k1.volume
			num1 = var3
		end

		for k2, v2 in pairs(k1.zoneParts) do
			if var2 then
				table.insert(tbl8, v2)
				tbl9[v2] = k1
			end

			table.insert(tbl10, v2)
			tbl11[v2] = k1
		end
	end
end

tbl2._getZonesAndItems = function(arg1, arg2, arg3, arg4, arg5)
	local var2 = arg3
	local var4
	if not var2 then
		for k1, v1 in pairs(arg2) do
			var4 = k1.volume
			var2 = var2 + var4
		end
	end

	local var5 = tbl1[arg1]
	local tbl3 = {}
	local var7
	if var5.totalVolume < var2 then
		for k2, v2 in pairs(var5.items) do
			for k3, v3 in pairs((tbl2.getTouchingZones(v2, arg4, arg5, var5))) do
				if arg4 then
					if not v3.activeTriggers[arg1] then
						continue
					end
				end

				var7 = v2
				if arg1 == "player" then
					var7 = var3:GetPlayerFromCharacter(v2)
				end

				if not var7 then
					continue
				end

				local var9 = tbl3[v3]
				if not var9 then
					var9 = {}
					tbl3[v3] = var9
				end

				local var10 = var7:IsA("Player")
				var9[var7] = var10 and var7.Character or true
			end
		end

		return tbl3
	end

	for k4, v4 in pairs(arg2) do
		if not arg4 or k4.activeTriggers[arg1] then
			local tbl4 = {}
			for k5, v5 in pairs((var6:GetPartBoundsInBox(k4.region.CFrame, k4.region.Size, var5.whitelistParams))) do
				local var11 = var5.partToItem[v5]
				if tbl4[var11] then
					continue
				end

				tbl4[var11] = true
			end

			for k6, v6 in pairs(tbl4) do
				if arg1 == "player" then
					local var13 = var3:GetPlayerFromCharacter(k6)
					if not k4:findPlayer(var13) then
						continue
					end

					local var15 = tbl3[k4]
					if not var15 then
						var15 = {}
						tbl3[k4] = var15
					end

					local var16 = var13:IsA("Player")
					var15[var13] = var16 and var13.Character or true
				else
					if not k4:findItem(k6) then
						continue
					end

					local var18 = tbl3[k4]
					if not var18 then
						var18 = {}
						tbl3[k4] = var18
					end

					local var19 = k6:IsA("Player")
					var18[k6] = var19 and k6.Character or true
				end
			end
		end
	end

	return tbl3
end

tbl2.getZones = function()
	local tbl1 = {}
	for k1, v1 in pairs(tbl4) do
		table.insert(tbl1, k1)
	end

	return tbl1
end

tbl2.getTouchingZones = function(arg1, arg2, arg3, arg4)
	local var2 = nil
	local var3 = nil
	if arg4 then
		arg4.exitDetections[arg1] = nil
		var2 = arg4.exitDetections[arg1]
	end

	local var5 = arg1:IsA("BasePart")
	var3 = var2 or arg3
	local var10 = nil
	local var11 = nil
	local var12 = not var5
	local tbl1 = {}
	if var5 then
		table.insert(tbl1, arg1)
		var10 = arg1.Size
		var11 = arg1.CFrame
	else
		if var3 == var7.Detection.WholeBody then
			local var15, var16 = var4.getCharacterSize(arg1)
			var10 = var15
			var11 = var16
			tbl1 = arg1:GetChildren()
		else
			local var18 = arg1:FindFirstChild("HumanoidRootPart")
			if var18 then
				table.insert(tbl1, var18)
				var10 = var18.Size
				var11 = var18.CFrame
			end
		end
	end

	if not var10 or (not var11) then
		return {}
	end

	local var19 = OverlapParams.new()
	var19.FilterType = Enum.RaycastFilterType.Whitelist
	local var20 = arg2 and tbl8 or tbl10
	var19.MaxParts = #var20
	var19.FilterDescendantsInstances = var20
	local var21 = arg2 and tbl9 or tbl11
	local tbl2 = {}
	local tbl3 = {}
	local tbl4 = {}
	for k1, v1 in pairs((var6:GetPartBoundsInBox(var11, var10, var19))) do
		local var23 = var21[v1]
		local var24
		if var23 and var23.allZonePartsAreBlocks then
			tbl3[var23] = true
			tbl2[v1] = var23
		else
			var24 = tbl4
			table.insert(var24, v1)
		end
	end

	local var26 = #tbl4
	local num1 = 0
	if 0 < var26 then
		local var27 = OverlapParams.new()
		var27.FilterType = Enum.RaycastFilterType.Whitelist
		var27.MaxParts = var26
		var27.FilterDescendantsInstances = tbl4
		for k2, v2 in pairs(tbl1) do
			if not v2:IsA("BasePart") then
				continue
			end

			local bool1 = false
			local var28
			if not var12 or (not var4.bodyPartsToIgnore[v2.Name]) then
				for k3, v3 in pairs((var6:GetPartsInPart(v2, var27))) do
					if tbl2[v3] then
						continue
					end

					local var30 = var21[v3]
					if var30 then
						tbl3[var30] = true
						tbl2[v3] = var30
						num1 = num1 + 1
					end

					if num1 ~= var26 then
						continue
					end

					bool1 = true
					break
				end

				if bool1 then
					break
				end
			end
		end
	end

	local tbl5 = {}
	local var31 = nil
	for k4, v4 in pairs(tbl3) do
		if var31 == nil or k4._currentExitDetection < var31 then
			var31 = k4._currentExitDetection
		end

		table.insert(tbl5, k4)
	end

	if var31 and arg4 then
		arg4.exitDetections[arg1] = var31
	end

	return tbl5, tbl2
end

local tbl12 = {}
tbl2.setGroup = function(arg1, arg2)
	local var2 = tbl12[arg1]
	if not var2 then
		var2 = {}
		tbl12[arg1] = var2
	end

	var2.onlyEnterOnceExitedAll = true
	var2._name = arg1
	var2._memberZones = {}
	if typeof(arg2) == "table" then
		for k1, v1 in pairs(arg2) do
			var2[k1] = v1
		end
	end

	return var2
end

tbl2.getGroup = function(arg1)
	return tbl12[arg1]
end

local var9 = nil
local var10 = string.format
local str1 = "ZonePlus%sContainer"
var10 = var10(str1, if var1:IsClient() then "Client" else "Server")
tbl2.getWorkspaceContainer = function()
	local var1 = var9
	var1 = var1 or workspace:FindFirstChild(var10)
	if not var1 then
		var1 = Instance.new("Folder")
		var1.Name = var10
		var1.Parent = workspace
		var9 = var1
	end

	return var1
end

return tbl2

--- ReplicatedStorage.ZonePlus v3.2.0.ZoneController.CollectiveWorldModel [ModuleScript]
-- y u r i

local var1 = nil
local var2 = game:GetService("RunService")
return {
	setupWorldModel = function(_)
		if var1 then
			return var1
		end

		local var3 = if var2:IsClient() then "ReplicatedStorage" else "ServerStorage"
		var1 = Instance.new("WorldModel")
		var1.Name = "ZonePlusWorldModel"
		var1.Parent = game:GetService(var3)
		return var1
	end,
	_getCombinedResults = function(_, arg2, ...)
		local var2 = workspace[arg2](workspace, ...)
		if var1 then
			for k1, v1 in pairs((var1[arg2](var1, ...))) do
				table.insert(var2, v1)
			end
		end

		return var2
	end,
	GetPartBoundsInBox = function(arg1, arg2, arg3, arg4)
		local str1 = "GetPartBoundsInBox"
		local var1 = arg2
		local var2 = arg3
		local var3 = arg4
		return arg1:_getCombinedResults(str1, var1, var2, var3)
	end,
	GetPartBoundsInRadius = function(arg1, arg2, arg3, arg4)
		local str1 = "GetPartBoundsInRadius"
		local var1 = arg2
		local var2 = arg3
		local var3 = arg4
		return arg1:_getCombinedResults(str1, var1, var2, var3)
	end,
	GetPartsInPart = function(arg1, arg2, arg3)
		local str1 = "GetPartsInPart"
		local var1 = arg2
		local var2 = arg3
		return arg1:_getCombinedResults(str1, var1, var2)
	end,
}

--- ReplicatedStorage.ZonePlus v3.2.0.ZoneController.Tracker [ModuleScript]
-- y u r i

local var1 = game:GetService("Players")
local var2 = game:GetService("RunService").Heartbeat
local var3 = require(script.Parent.Parent.Signal)
local var4 = require(script.Parent.Parent.Janitor)
local tbl1 = {}
tbl1.__index = tbl1
local tbl2 = {}
tbl1.trackers = tbl2
tbl1.itemAdded = var3.new()
tbl1.itemRemoved = var3.new()
tbl1.bodyPartsToIgnore = {
	UpperTorso = true,
	LowerTorso = true,
	Torso = true,
	LeftHand = true,
	RightHand = true,
	LeftFoot = true,
	RightFoot = true,
}

tbl1.getCombinedTotalVolumes = function()
	local num1 = 0
	for k1, v1 in pairs(tbl2) do
		num1 = num1 + k1.totalVolume
	end

	return num1
end

tbl1.getCharacterSize = function(arg1)
	local var1 = arg1
	local var2 = arg1
	var2 = var2 and arg1:FindFirstChild("HumanoidRootPart")
	var1 = var1 and arg1:FindFirstChild("Head")
	if not var2 or (not var1) then
		return nil
	end

	if not var1:IsA("BasePart") then
		var1 = var2
	end

	local var3 = var2.Size
	local var4 = var1.Size.Y
	return var3 * Vector3.new(2, 2, 1) + Vector3.new(0, var4, 0), var2.CFrame * CFrame.new(0, var4 / 2 - var3.Y / 2, 0)
end

tbl1.new = function(arg1)
	local tbl3 = {}
	setmetatable(tbl3, tbl1)
	tbl3.name = arg1
	tbl3.totalVolume = 0
	tbl3.parts = {}
	tbl3.partToItem = {}
	tbl3.items = {}
	tbl3.whitelistParams = nil
	tbl3.characters = {}
	tbl3.baseParts = {}
	tbl3.exitDetections = {}
	tbl3.janitor = var4.new()
	if arg1 == "player" then
		local function fn4()
			local tbl1 = {}
			for k1, v1 in pairs(var1:GetPlayers()) do
				local var2 = v1.Character
				if not var2 then
					continue
				end

				tbl1[var2] = true
			end

			tbl3.characters = tbl1
		end

		local function playerAdded(arg1)
			local function charAdded(arg1)
				local var2 = arg1:WaitForChild("Humanoid", 3)
				if var2 then
					fn4()
					tbl3:update()
					for k1, v1 in pairs(var2:GetChildren()) do
						if not v1:IsA("NumberValue") then
							continue
						end

						v1.Changed:Connect(function()
							tbl3:update()
						end)

					end
				end
			end

			if arg1.Character then
				charAdded(arg1.Character)
			end

			arg1.CharacterAdded:Connect(charAdded)
			arg1.CharacterRemoving:Connect(function(arg1)
				tbl3.exitDetections[arg1] = nil
			end)
		end

		var1.PlayerAdded:Connect(playerAdded)
		for k1, v1 in pairs(var1:GetPlayers()) do
			playerAdded(v1)
		end

		var1.PlayerRemoving:Connect(function(_)
			fn4()
			tbl3:update()
		end)

	elseif arg1 == "item" then
		tbl1.itemAdded:Connect(function(arg1)
			if arg1.isCharacter then
				tbl3.characters[arg1.item] = true
			else
				if arg1.isBasePart then
					tbl3.baseParts[arg1.item] = true
				end
			end

			tbl3:update()
		end)

		tbl1.itemRemoved:Connect(function(arg1)
			tbl3.exitDetections[arg1.item] = nil
			if arg1.isCharacter then
				tbl3.characters[arg1.item] = nil
			else
				if arg1.isBasePart then
					tbl3.baseParts[arg1.item] = nil
				end
			end

			tbl3:update()
		end)

		fn4 = function(arg1, arg2)
			if arg1.isCharacter then
				tbl3.characters[arg1.item] = arg2
			else
				if arg1.isBasePart then
					tbl3.baseParts[arg1.item] = arg2
				end
			end

			tbl3:update()
		end

	end

	tbl2[tbl3] = true
	task.defer(tbl3.update, tbl3)
	return tbl3
end

tbl1._preventMultiFrameUpdates = function(arg1, arg2, ...)
	local var1 = arg1._preventMultiDetails
	arg1._preventMultiDetails = var1 or {}
	var1 = arg1._preventMultiDetails[arg2]
	if not var1 then
		var1 = { calling = false, callsThisFrame = 0, updatedThisFrame = false }
		arg1._preventMultiDetails[arg2] = var1
	end

	local var2 = var1.callsThisFrame + 1
	var1.callsThisFrame = var2
	if var1.callsThisFrame == 1 then
		var2 = table.pack(...)
		task.defer(function()
			var1.callsThisFrame = 0
			if 1 < var1.callsThisFrame then
				local var3 = var2
				arg1[arg2](arg1, unpack(var3))
			end
		end)

		return false
	end

	return true
end

tbl1.update = function(arg1)
	if arg1:_preventMultiFrameUpdates("update") then
		return
	end

	arg1.totalVolume = 0
	arg1.parts = {}
	arg1.partToItem = {}
	arg1.items = {}
	for k1, v1 in pairs(arg1.characters) do
		local var1 = tbl1.getCharacterSize(k1)
		if not var1 then
			continue
		end

		local var2 = arg1.totalVolume + var1.X * var1.Y * var1.Z
		arg1.totalVolume = var2
		var2 = arg1.janitor:add(var4.new(), "destroy", "trackCharacterParts-" .. arg1.name)
		local function updateTrackerOnParentChanged(arg1)
			var2:add(arg1.AncestryChanged:Connect(function()
				if not arg1:IsDescendantOf(game) and (arg1.Parent == nil and var2 ~= nil) then
					var2:destroy()
					var2 = nil
					arg1:update()
				end
			end), "Disconnect")
		end

		for k2, v2 in pairs(k1:GetChildren()) do
			if not v2:IsA("BasePart") then
				continue
			end

			if tbl1.bodyPartsToIgnore[v2.Name] then
				continue
			end

			arg1.partToItem[v2] = k1
			table.insert(arg1.parts, v2)
			var2:add(v2.AncestryChanged:Connect(function()
				if not v2:IsDescendantOf(game) and (v2.Parent == nil and var2 ~= nil) then
					var2:destroy()
					var2 = nil
					arg1:update()
				end
			end), "Disconnect")

		end

		var2:add(k1.AncestryChanged:Connect(function()
			if not k1:IsDescendantOf(game) and (k1.Parent == nil and var2 ~= nil) then
				var2:destroy()
				var2 = nil
				arg1:update()
			end
		end), "Disconnect")

		table.insert(arg1.items, k1)
	end

	for k3, v3 in pairs(arg1.baseParts) do
		local var3 = k3.Size
		local var5 = arg1.totalVolume + var3.X * var3.Y * var3.Z
		arg1.totalVolume = var5
		arg1.partToItem[k3] = k3
		table.insert(arg1.parts, k3)
		table.insert(arg1.items, k3)
	end

	arg1.whitelistParams = OverlapParams.new()
	arg1.whitelistParams.FilterType = Enum.RaycastFilterType.Whitelist
	arg1.whitelistParams.MaxParts = #arg1.parts
	arg1.whitelistParams.FilterDescendantsInstances = arg1.parts
end

return tbl1

--- ReplicatedStorage.ZonePlus v3.2.0.ZonePlusReference [ModuleScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
return {
	addToReplicatedStorage = function()
		if var1:FindFirstChild(script.Name) then
			return false
		end

		local var2 = Instance.new("ObjectValue")
		var2.Name = script.Name
		var2.Value = script.Parent
		var2.Parent = var1
		local var3 = Instance.new("BoolValue")
		local var4 = if game:GetService("RunService"):IsClient() then "Client" else "Server"
		var3.Name = var4
		var3.Value = true
		var3.Parent = var2
		return var2
	end,
	getObject = function()
		local var3 = var1:FindFirstChild(script.Name)
		if var3 then
			return var3
		end

		return false
	end,
}

--- ReplicatedStorage.Configs.CarConfig [ModuleScript]
-- y u r i

local function gradient(arg1)
	local tbl1 = {}
	for k1, v1 in ipairs(arg1) do
		local var1 = v1
		tbl1[k1] = ColorSequenceKeypoint.new((k1 - 1) / (#arg1 - 1), Color3.fromRGB(table.unpack(var1)))
	end

	local var2 = tbl1
	return ColorSequence.new(var2)
end

local tbl1 = { Order = 1, Color = Color3.fromRGB(145, 155, 175), Animated = false }
tbl1.Gradient = gradient({ { 145, 155, 175 }, { 255, 255, 255 }, { 175, 185, 205 } })
local tbl2 = { Common = tbl1 }
tbl1 = { Order = 2, Color = Color3.fromRGB(0, 255, 35), Animated = true }
tbl1.Gradient = gradient({ { 0, 255, 35 }, { 170, 255, 0 }, { 0, 200, 90 } })
tbl2.Uncommon = tbl1
tbl1 = { Order = 3, Color = Color3.fromRGB(0, 80, 255), Animated = true }
tbl1.Gradient = gradient({ { 0, 80, 255 }, { 0, 255, 255 }, { 0, 120, 255 } })
tbl2.Rare = tbl1
tbl1 = { Order = 4, Color = Color3.fromRGB(135, 0, 255), Animated = true }
tbl1.Gradient = gradient({ { 135, 0, 255 }, { 255, 0, 150 }, { 215, 0, 255 } })
tbl2.Epic = tbl1
tbl1 = { Order = 5, Color = Color3.fromRGB(255, 95, 0), Animated = true }
tbl1.Gradient = gradient({ { 255, 95, 0 }, { 255, 245, 0 }, { 255, 155, 0 } })
tbl2.Legendary = tbl1
tbl1 = { Order = 6, Color = Color3.fromRGB(160, 0, 255), Animated = true }
tbl1.Gradient = gradient({ { 160, 0, 255 }, { 22, 0, 48 }, { 255, 255, 255 }, { 255, 0, 210 } })
tbl2.Cosmic = tbl1
tbl1 = { Order = 7, Color = Color3.fromRGB(0, 145, 255), Animated = true }
tbl1.Gradient = gradient({ { 0, 145, 255 }, { 0, 10, 65 }, { 0, 255, 240 }, { 50, 45, 255 } })
tbl2.Ethereal = tbl1
tbl1 = { Order = 8, Color = Color3.fromRGB(255, 0, 40), Animated = true }
tbl1.Gradient = gradient({
	{ 255, 0, 40 },
	{ 255, 160, 0 },
	{ 225, 255, 0 },
	{ 0, 255, 60 },
	{ 0, 230, 255 },
	{ 60, 0, 255 },
	{ 255, 0, 200 },
})

tbl2.Chromatic = tbl1
local tbl3 = {
	TemplateFolder = "Cars",
	DrivingTemplateFolder = "Cars",
	PlotTemplateFolder = "CarsPlot",
	HeldTemplateFolder = "MiniCars",
	Rarities = tbl2,
}

tbl1 = { Order = 9, Color = Color3.fromRGB(255, 0, 110), Animated = true }
tbl1.Gradient = gradient({ { 255, 0, 110 }, { 55, 0, 100 }, { 0, 255, 255 }, { 255, 0, 110 } })
tbl3.Rarities.Secret = tbl1
tbl1 = { Order = 10, Color = Color3.fromRGB(255, 185, 0), Animated = true }
tbl1.Gradient = gradient({ { 255, 40, 0 }, { 255, 230, 0 }, { 255, 255, 255 }, { 160, 0, 255 }, { 255, 40, 0 } })
tbl3.Rarities.Apex = tbl1
tbl1 = { Order = 11, Color = Color3.fromRGB(255, 225, 115), Animated = true }
tbl1.Gradient = gradient({
	{ 255, 170, 0 },
	{ 255, 237, 145 },
	{ 255, 255, 255 },
	{ 255, 255, 255 },
	{ 255, 215, 40 },
	{ 255, 160, 0 },
	{ 255, 255, 255 },
})

tbl3.Rarities.Celestial = tbl1
tbl1 = { Order = 11.5, Color = Color3.fromRGB(255, 20, 210), Animated = true }
tbl1.Gradient = gradient({
	{ 255, 0, 150 },
	{ 170, 0, 255 },
	{ 255, 45, 240 },
	{ 115, 0, 235 },
	{ 255, 165, 250 },
	{ 225, 0, 255 },
	{ 255, 0, 150 },
})

tbl3.Rarities.Infernal = tbl1
tbl1 = { Order = 12, Color = Color3.fromRGB(110, 255, 235), Animated = true }
tbl1.Gradient = gradient({
	{ 20, 100, 255 },
	{ 90, 255, 215 },
	{ 255, 255, 255 },
	{ 170, 70, 255 },
	{ 20, 100, 255 },
})

tbl3.Rarities.Fuse = tbl1
tbl1 = { Order = 12, Color = Color3.new(1, 1, 1), Animated = true }
tbl1.Gradient = gradient({
	{ 0, 0, 0 },
	{ 255, 255, 255 },
	{ 8, 8, 8 },
	{ 255, 255, 255 },
	{ 0, 0, 0 },
	{ 255, 255, 255 },
	{ 0, 0, 0 },
})

tbl3.Rarities.FuseBat = tbl1
tbl1 = { Order = 13, Color = Color3.fromRGB(40, 255, 90), Animated = true }
tbl1.Gradient = gradient({ { 25, 255, 65 }, { 255, 35, 45 }, { 25, 95, 255 }, { 25, 255, 65 } })
tbl3.Rarities.Robux = tbl1
tbl1 = { Order = 14, Color = Color3.fromRGB(110, 220, 255), Animated = false }
tbl1.Gradient = gradient({ { 70, 175, 230 }, { 225, 250, 255 }, { 90, 220, 255 } })
tbl3.Rarities.Prototype = tbl1
tbl3.DefaultRarity = "Common"
tbl3.SellSeconds = 60
tbl3.Cars = {
	GTR = {
		Name = "GTR",
		DisplayName = "GTR",
		Tier = 13,
		Rarity = "Infernal",
		CashPerSecond = 24000000000,
		SellPrice = 1440000000000,
		Image = "",
		Width = 9.6179294586181641,
		Length = 21.5,
		Height = 5.0676860809326172,
	},
	Phantom = {
		Name = "Phantom",
		DisplayName = "Phantom",
		Tier = 13,
		Rarity = "Infernal",
		CashPerSecond = 16000000000,
		SellPrice = 960000000000,
		Image = "",
		Width = 7.4157681465,
		Length = 21.5,
		Height = 6.0132665634,
	},
	AvatarAVTR = {
		Name = "Mercedes AVTR",
		DisplayName = "Mercedes AVTR",
		Tier = 14,
		FuseTier = 7,
		Rarity = "Fuse",
		CashPerSecond = 60000000000,
		SellPrice = 3600000000000,
		Image = "",
		Width = 9.359,
		Length = 21.5,
		Height = 5.368,
	},
	CyberCab = {
		Name = "Cyber Cab",
		DisplayName = "Cyber Cab",
		Tier = 14.5,
		FuseTier = 8,
		Rarity = "Fuse",
		CashPerSecond = 90000000000,
		SellPrice = 5400000000000,
		Image = "",
		Width = 9.7,
		Length = 21.5,
		Height = 6,
	},
	TokyoTowTruck = {
		Name = "Tokyo Tow Truck",
		DisplayName = "Tokyo Tow Truck",
		Tier = 13.5,
		FuseTier = 6,
		Rarity = "Fuse",
		CashPerSecond = 40000000000,
		SellPrice = 2400000000000,
		Image = "",
		Width = 9.7,
		Length = 20.411232,
		Height = 8.842678,
	},
	Ferrari458 = {
		Name = "Ferrari 458",
		DisplayName = "Ferrari 458",
		Tier = 6.5,
		Rarity = "Robux",
		CashPerSecond = 1000000,
		SellPrice = 60000000,
		IndexHidden = true,
		Exclusive = true,
		RobuxExclusive = true,
		Image = "",
		Width = 9.7,
		Length = 19.7488,
		Height = 5.51022,
	},
	Revuelto = {
		Name = "Revuelto",
		DisplayName = "Revuelto",
		Tier = 5,
		Rarity = "Legendary",
		CashPerSecond = 10000,
		SellPrice = 600000,
		IndexHidden = true,
		InviteExclusive = true,
		Image = "",
		Width = 9.681694,
		Length = 21.000797,
		Height = 5.245921,
	},
	Hybrid = {
		Name = "Hybrid",
		DisplayName = "Hybrid",
		Tier = 3.5,
		FuseTier = 1,
		Rarity = "Fuse",
		CashPerSecond = 650,
		SellPrice = 39000,
		Image = "rbxassetid://102581062249805",
		Width = 9.699986457824707,
		Length = 15.273654937744141,
		Height = 5.145233154296875,
	},
	Cyber = {
		Name = "Cyber",
		DisplayName = "Cyber",
		Tier = 5.5,
		FuseTier = 2,
		Rarity = "Fuse",
		CashPerSecond = 100000,
		SellPrice = 6000000,
		Image = "rbxassetid://126555817299747",
		Width = 9.7080812454223633,
		Length = 18.161964416503906,
		Height = 4.146263599395752,
	},
	Racer = {
		Name = "Racer",
		DisplayName = "Racer",
		Tier = 7.5,
		FuseTier = 3,
		Rarity = "Fuse",
		CashPerSecond = 9000000,
		SellPrice = 540000000,
		Image = "rbxassetid://121110423544529",
		Width = 9.7085084915161133,
		Length = 16.769847869873047,
		Height = 4.6822710037231445,
	},
	Void = {
		Name = "Void",
		DisplayName = "Void",
		Tier = 9.5,
		FuseTier = 4,
		Rarity = "Fuse",
		CashPerSecond = 1000000000,
		SellPrice = 60000000000,
		Image = "rbxassetid://111115937943684",
		Width = 9.7000141143798828,
		Length = 18.547946929931641,
		Height = 4.8881902694702148,
	},
	Bat = {
		Name = "Bat",
		DisplayName = "Bat",
		Tier = 13,
		FuseTier = 5,
		Rarity = "Fuse",
		CashPerSecond = 25000000000,
		SellPrice = 1500000000000,
		Image = "rbxassetid://88702374267547",
		Width = 9.6999988555908203,
		Length = 20.422395706176758,
		Height = 6.5862054824829102,
		GradientStyle = "FuseBat",
	},
	Urus = {
		Name = "Lamborghini Urus",
		DisplayName = "Lamborghini Urus",
		Tier = 6,
		Rarity = "Cosmic",
		CashPerSecond = 300000,
		SellPrice = 18000000,
		Image = "rbxassetid://134504186626500",
		Width = 9.26716,
		Length = 21.01923,
		Height = 6.66822,
		Exclusive = true,
		IndexHidden = true,
	},
	LaFerrari = {
		Name = "LaFerrari",
		DisplayName = "LaFerrari",
		Tier = 12,
		Rarity = "Celestial",
		CashPerSecond = 8000000000,
		SellPrice = 480000000000,
		Image = "",
		Width = 9.39337,
		Length = 20.98309,
		Height = 5.02324,
	},
	VisionAMG = {
		Name = "Mercedes Vision AMG",
		DisplayName = "Mercedes Vision AMG",
		Tier = 12,
		Rarity = "Celestial",
		CashPerSecond = 12000000000,
		SellPrice = 720000000000,
		Image = "",
		Width = 8.53935,
		Length = 22.01657,
		Height = 5.54324,
	},
	Acurin = {
		Tier = 2,
		Rarity = "Uncommon",
		CashPerSecond = 40,
		SellPrice = 2400,
		Image = "rbxassetid://98697040659883",
		Width = 9.015,
		Length = 18.872,
		Height = 5.755,
	},
	Audrix = {
		Tier = 6,
		Rarity = "Cosmic",
		CashPerSecond = 200000,
		SellPrice = 12000000,
		Image = "rbxassetid://137657255637352",
		Width = 9.409,
		Length = 19.619,
		Height = 5.835,
	},
	AudrixR8 = {
		Tier = 6,
		Rarity = "Cosmic",
		CashPerSecond = 400000,
		SellPrice = 24000000,
		Image = "rbxassetid://93673909015300",
		Width = 10.058,
		Length = 22.15,
		Height = 5.371,
	},
	Azure = {
		Tier = 5,
		Rarity = "Legendary",
		CashPerSecond = 30000,
		SellPrice = 1800000,
		Image = "rbxassetid://113579371268172",
		Width = 9.465,
		Length = 20.144,
		Height = 5.634,
	},
	BeymarM8 = {
		Tier = 6,
		Rarity = "Cosmic",
		CashPerSecond = 300000,
		SellPrice = 18000000,
		Image = "rbxassetid://97089813192406",
		Width = 9.964,
		Length = 22.24,
		Height = 5.969,
	},
	Bughaci = {
		Tier = 10,
		Rarity = "Secret",
		CashPerSecond = 2000000000,
		SellPrice = 120000000000,
		Image = "rbxassetid://126276548559668",
		Width = 9.411,
		Length = 20.438,
		Height = 5.266,
	},
	Challara = {
		Tier = 3,
		Rarity = "Rare",
		CashPerSecond = 300,
		SellPrice = 18000,
		Image = "rbxassetid://83203014571582",
		Width = 8.382,
		Length = 18.771,
		Height = 5.103,
	},
	ChallaraSRT = {
		Tier = 4,
		Rarity = "Epic",
		CashPerSecond = 3000,
		SellPrice = 180000,
		Image = "rbxassetid://70690376437562",
		Width = 8.052,
		Length = 19.572,
		Height = 5.687,
	},
	Charger = {
		Tier = 3,
		Rarity = "Rare",
		CashPerSecond = 400,
		SellPrice = 24000,
		Image = "rbxassetid://133066372334489",
		Width = 7.909,
		Length = 19.324,
		Height = 5.438,
	},
	Civaru = {
		Tier = 1,
		Rarity = "Common",
		CashPerSecond = 2,
		SellPrice = 120,
		Image = "rbxassetid://103991891856941",
		Width = 7.424,
		Length = 17.518,
		Height = 5.755,
	},
	Corvessa = {
		Tier = 5,
		Rarity = "Legendary",
		CashPerSecond = 20000,
		SellPrice = 1200000,
		Image = "rbxassetid://136295775687195",
		Width = 9.621,
		Length = 19.788,
		Height = 5.282,
	},
	Cosmo = {
		Tier = 8,
		Rarity = "Ethereal",
		CashPerSecond = 40000000,
		SellPrice = 2400000000,
		Image = "rbxassetid://132801754393518",
		Width = 9.331,
		Length = 20.1,
		Height = 4.946,
	},
	Crimson = {
		Tier = 1,
		Rarity = "Common",
		CashPerSecond = 4,
		SellPrice = 240,
		Image = "rbxassetid://127719838743488",
		Width = 8.529,
		Length = 19.696,
		Height = 5.767,
	},
	FormulaX = {
		Tier = 11,
		Rarity = "Apex",
		CashPerSecond = 4000000000,
		SellPrice = 240000000000,
		Image = "rbxassetid://75827149883020",
		Width = 8.934,
		Length = 22.235,
		Height = 4.698,
	},
	Nebula = {
		Tier = 4,
		Rarity = "Epic",
		CashPerSecond = 4000,
		SellPrice = 240000,
		Image = "rbxassetid://93545922176231",
		Width = 8.96,
		Length = 19.716,
		Height = 5.441,
	},
	NebulaX = {
		Tier = 9,
		Rarity = "Ethereal",
		CashPerSecond = 200000000,
		SellPrice = 12000000000,
		Image = "rbxassetid://130317197425063",
		Width = 9.219,
		Length = 21.177,
		Height = 4.393,
	},
	Nissaru = {
		Tier = 2,
		Rarity = "Uncommon",
		CashPerSecond = 20,
		SellPrice = 1200,
		Image = "rbxassetid://105340844051590",
		Width = 8.506,
		Length = 20.341,
		Height = 6.056,
	},
	NissaruR32 = {
		Tier = 2,
		Rarity = "Uncommon",
		CashPerSecond = 30,
		SellPrice = 1800,
		Image = "rbxassetid://84600914480049",
		Width = 8.389,
		Length = 18.964,
		Height = 5.933,
	},
	Paganzo = {
		Tier = 9,
		Rarity = "Ethereal",
		CashPerSecond = 400000000,
		SellPrice = 24000000000,
		Image = "rbxassetid://125698138208943",
		Width = 9.474,
		Length = 21.149,
		Height = 4.805,
	},
	RSX = {
		Tier = 1,
		Rarity = "Common",
		CashPerSecond = 5,
		SellPrice = 300,
		Image = "rbxassetid://82485938109955",
		Width = 8.54,
		Length = 19.99,
		Height = 5.814,
	},
	RosellaR = {
		Tier = 8,
		Rarity = "Ethereal",
		CashPerSecond = 20000000,
		SellPrice = 1200000000,
		Image = "rbxassetid://77581651016005",
		Width = 9.151,
		Length = 20.368,
		Height = 5.233,
	},
	Scintara = {
		Tier = 9,
		Rarity = "Ethereal",
		CashPerSecond = 300000000,
		SellPrice = 18000000000,
		Image = "rbxassetid://83814885792071",
		Width = 9.288,
		Length = 21.863,
		Height = 4.95,
	},
	SkylanceR = {
		Tier = 5,
		Rarity = "Legendary",
		CashPerSecond = 40000,
		SellPrice = 2400000,
		Image = "rbxassetid://108891275478197",
		Width = 9.238,
		Length = 19.687,
		Height = 5.414,
	},
	Spectra = {
		Tier = 7,
		Rarity = "Cosmic",
		CashPerSecond = 2000000,
		SellPrice = 120000000,
		Image = "rbxassetid://102129424637317",
		Width = 9.001,
		Length = 20.431,
		Height = 5.58,
	},
	Spyra = {
		Tier = 7,
		Rarity = "Cosmic",
		CashPerSecond = 2500000,
		SellPrice = 150000000,
		Image = "rbxassetid://131308179708793",
		Width = 9.03,
		Length = 21.057,
		Height = 5.292,
	},
	Suncharge = {
		Tier = 3,
		Rarity = "Rare",
		CashPerSecond = 200,
		SellPrice = 12000,
		Image = "rbxassetid://129373160591027",
		Width = 8.03,
		Length = 19.624,
		Height = 5.354,
	},
	Toyoso = {
		Tier = 1,
		Rarity = "Common",
		CashPerSecond = 3,
		SellPrice = 180,
		Image = "rbxassetid://89791052276651",
		Width = 8.066,
		Length = 18.782,
		Height = 5.746,
	},
	Velocita = {
		Tier = 8,
		Rarity = "Ethereal",
		CashPerSecond = 30000000,
		SellPrice = 1800000000,
		Image = "rbxassetid://89727906977436",
		Width = 9.665,
		Length = 19.327,
		Height = 5.036,
	},
	Verde = {
		Tier = 7,
		Rarity = "Cosmic",
		CashPerSecond = 4000000,
		SellPrice = 240000000,
		Image = "rbxassetid://114436679468826",
		Width = 9.254,
		Length = 20.198,
		Height = 5.072,
	},
	Viper = {
		Tier = 7,
		Rarity = "Cosmic",
		CashPerSecond = 3000000,
		SellPrice = 180000000,
		Image = "rbxassetid://74082949334772",
		Width = 9.824,
		Length = 21.78,
		Height = 5.404,
	},
	Vipra = {
		Tier = 4,
		Rarity = "Epic",
		CashPerSecond = 2000,
		SellPrice = 120000,
		Image = "rbxassetid://117929590369102",
		Width = 9.458,
		Length = 19.235,
		Height = 5.435,
	},
	Xythera = {
		Tier = 10,
		Rarity = "Secret",
		CashPerSecond = 3000000000,
		SellPrice = 180000000000,
		Image = "rbxassetid://140516117770311",
		Width = 9.328,
		Length = 21.4,
		Height = 4.348,
	},
}

tbl3.Tiers = {
	{ Rarity = "Common", Cars = { "Civaru", "Toyoso", "Crimson", "RSX" } },
	{ Rarity = "Uncommon", Cars = { "Nissaru", "NissaruR32", "Acurin" } },
	{ Rarity = "Rare", Cars = { "Suncharge", "Challara", "Charger" } },
	{ Rarity = "Epic", Cars = { "Vipra", "ChallaraSRT", "Nebula" } },
	{ Rarity = "Legendary", Cars = { "Corvessa", "Azure", "SkylanceR" } },
	{ Rarity = "Cosmic", Cars = { "Audrix", "BeymarM8", "AudrixR8" } },
	{ Rarity = "Cosmic", Cars = { "Spectra", "Spyra", "Viper", "Verde" } },
	{ Rarity = "Ethereal", Cars = { "RosellaR", "Velocita", "Cosmo" } },
	{ Rarity = "Ethereal", Cars = { "NebulaX", "Scintara", "Paganzo" } },
	{ Rarity = "Secret", Cars = { "Bughaci", "Xythera" } },
	{ Rarity = "Apex", Cars = { "FormulaX" } },
	{ Rarity = "Celestial", Cars = { "LaFerrari", "VisionAMG" } },
	{ Rarity = "Infernal", Cars = { "Phantom", "GTR" } },
}

tbl3.LargestFootprint = { Width = 10.058, Length = 22.24, Height = 6.056 }
tbl3.Default = { Rarity = "Common", CashPerSecond = 1, Width = 10.058, Length = 22.24, Height = 6.056 }
tbl3.Get = function(arg1)
	local var1 = tbl3.Cars[tostring(arg1)]
	return var1 or tbl3.Default
end

tbl3.Exists = function(arg1)
	return tbl3.Cars[tostring(arg1)] ~= nil
end

tbl3.GetRarity = function(arg1)
	local var1 = tbl3.Get(arg1).Rarity
	return var1 or tbl3.DefaultRarity
end

tbl3.GetRarityInfo = function(arg1)
	local var1 = tbl3.Rarities[tostring(arg1)]
	return var1 or tbl3.Rarities[tbl3.DefaultRarity]
end

tbl3.GetCashPerSecond = function(arg1)
	return tonumber(tbl3.Get(arg1).CashPerSecond) or 0
end

tbl3.GetSellPrice = function(arg1)
	local var1 = tonumber(tbl3.Get(arg1).SellPrice)
	return (math.max(0, (math.floor(var1 or tbl3.GetCashPerSecond(arg1) * tbl3.SellSeconds))))
end

tbl3.GetIds = function()
	local tbl1 = {}
	for k1 in pairs(tbl3.Cars) do
		table.insert(tbl1, k1)
	end

	table.sort(tbl1, function(arg1, arg2)
		local var1 = tbl3.Cars[arg1]
		local var2 = tbl3.Cars[arg2]
		if var1.Tier ~= var2.Tier then
			return var1.Tier < var2.Tier
		end

		if var1.CashPerSecond ~= var2.CashPerSecond then
			return var1.CashPerSecond < var2.CashPerSecond
		end

		return arg1 < arg2
	end)

	return tbl1
end

tbl3.IsIndexCar = function(arg1)
	local var2 = tbl3.Exists(arg1)
	if var2 then
		var2 = tbl3.Get(arg1).IndexHidden ~= true
	end

	return var2
end

tbl3.GetIndexIds = function()
	local tbl1 = {}
	for k1, v1 in ipairs(tbl3.GetIds()) do
		if not tbl3.IsIndexCar(v1) then
			continue
		end

		table.insert(tbl1, v1)
	end

	return tbl1
end

return tbl3

--- ReplicatedStorage.Configs.PlotConfig [ModuleScript]
-- y u r i

local tbl1 = {
	PlotsFolderName = "Plots",
	SlotFolderName = "CarPos",
	CarsFolderName = "Cars",
	MinLevel = 0,
	BaseSlots = 8,
	SlotsPerLevel = { 10, 12, 14, 16, 32, [0] = 8 },
	MaxLevel = 5,
	GroundFloorMaxLevel = 4,
	SecondFloorLevel = 5,
	ParkingVerticalTolerance = 12,
	LayoutVersion = 3,
	UpgradeCosts = { 1000000, 100000000, 10000000000, 140000000000000, [0] = 10000 },
	UpgradeCooldown = 0.6,
	HoverLift = 0.035,
	DefaultClearance = { Front = 11.96, Back = 11.97, Left = 6.48, Right = 5.67 },
	MinFitMargin = 0.25,
}

tbl1.GetSlotCount = function(arg1)
	local var1 = tonumber(arg1)
	local var2 = math.floor(var1 or tbl1.MinLevel)
	arg1 = math.clamp(var2, tbl1.MinLevel, tbl1.MaxLevel)
	local var3 = tbl1.SlotsPerLevel[arg1]
	return var3 or tbl1.SlotsPerLevel[tbl1.MinLevel]
end

tbl1.GetMinimumLevelForSlot = function(arg1)
	arg1 = math.max(0, (math.floor(tonumber(arg1) or 0)))
	for i1 = tbl1.MinLevel, tbl1.MaxLevel do
		if arg1 > tbl1.GetSlotCount(i1) then
			continue
		end

		return i1
	end

	return tbl1.MaxLevel
end

tbl1.IsPlayablePlot = function(arg1)
	local var1 = arg1
	local var2 = tonumber(var1 and arg1.Name)
	var1 = false
	if typeof(arg1) == "Instance" then
		var1 = arg1:IsA("Model")
		if var1 then
			var1 = false
			if var2 ~= nil then
				var1 = false
				if 1 <= var2 then
					var1 = false
					if var2 % 1 == 0 then
						var1 = arg1:GetAttribute("PlotTemplate") ~= true
					end
				end
			end
		end
	end

	return var1
end

return tbl1

--- ReplicatedStorage.Configs.TrailConfig [ModuleScript]
-- y u r i

local function cardGradient(arg1, arg2)
	local num1 = 248
	local num2 = 248
	local num3 = 248
	local var1 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(num1, num2, num3))
	local num4 = 1
	num1 = arg2
	local tbl1 = { ColorSequenceKeypoint.new(0, arg1), var1, ColorSequenceKeypoint.new(num4, num1) }
	return ColorSequence.new(tbl1)
end

local num1 = 185
local num2 = 12
local num3 = 35
local tbl1 = { Red = cardGradient(Color3.fromRGB(255, 65, 75), Color3.fromRGB(num1, num2, num3)) }
num1 = 230
num2 = 165
num3 = 15
tbl1.Banana = cardGradient(Color3.fromRGB(255, 225, 25), Color3.fromRGB(num1, num2, num3))
num1 = 15
num2 = 105
num3 = 225
tbl1.Water = cardGradient(Color3.fromRGB(35, 225, 255), Color3.fromRGB(num1, num2, num3))
num1 = 235
num2 = 45
num3 = 10
tbl1.Fire = cardGradient(Color3.fromRGB(255, 175, 20), Color3.fromRGB(num1, num2, num3))
num1 = 40
num2 = 130
num3 = 25
tbl1.Leaf = cardGradient(Color3.fromRGB(145, 225, 40), Color3.fromRGB(num1, num2, num3))
num1 = 190
num2 = 120
num3 = 10
tbl1.VIP = cardGradient(Color3.fromRGB(255, 215, 55), Color3.fromRGB(num1, num2, num3))
num1 = 40
num2 = 20
num3 = 65
tbl1.Ink = cardGradient(Color3.fromRGB(150, 90, 255), Color3.fromRGB(num1, num2, num3))
num1 = 120
num2 = 65
num3 = 235
tbl1.Glitch = cardGradient(Color3.fromRGB(235, 90, 255), Color3.fromRGB(num1, num2, num3))
num1 = 10
num2 = 115
num3 = 40
tbl1.Matrix = cardGradient(Color3.fromRGB(25, 255, 130), Color3.fromRGB(num1, num2, num3))
num1 = 55
num2 = 20
num3 = 120
tbl1.Galaxy = cardGradient(Color3.fromRGB(180, 65, 255), Color3.fromRGB(num1, num2, num3))
num1 = 180
num2 = 85
num3 = 255
tbl1.Aurora = cardGradient(Color3.fromRGB(25, 195, 255), Color3.fromRGB(num1, num2, num3))
num3 = 255
local num4 = 65
local num5 = 90
local var1 = ColorSequenceKeypoint.new(0, Color3.fromRGB(num3, num4, num5))
num4 = 255
num5 = 210
local num6 = 35
num1 = ColorSequenceKeypoint.new(0.16, Color3.fromRGB(num4, num5, num6))
num5 = 60
num6 = 235
local num7 = 110
num2 = ColorSequenceKeypoint.new(0.32, Color3.fromRGB(num5, num6, num7))
num6 = 248
num7 = 248
local num8 = 248
num3 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(num6, num7, num8))
num7 = 35
num8 = 215
local num9 = 255
num4 = ColorSequenceKeypoint.new(0.68, Color3.fromRGB(num7, num8, num9))
num8 = 100
num9 = 100
local num10 = 255
num5 = ColorSequenceKeypoint.new(0.84, Color3.fromRGB(num8, num9, num10))
num9 = 230
num10 = 60
local num11 = 255
num7 = 1
tbl1.Rainbow = ColorSequence.new({
	var1,
	num1,
	num2,
	num3,
	num4,
	num5,
	ColorSequenceKeypoint.new(num7, Color3.fromRGB(num9, num10, num11)),
})

local tbl2 = {
	Trails = {
		Galaxy = {
			Name = "Galaxy",
			Order = 10,
			Price = 105000000000000,
			SpeedMultiplier = 1.75,
			MovementMultiplier = 1.15,
			DevProductId = 3712582458,
			Rarity = "Cosmic",
			Image = "rbxassetid://114973969585469",
		},
		Rainbow = {
			Name = "Rainbow",
			Order = 12,
			Price = 5e+16,
			SpeedMultiplier = 2,
			MovementMultiplier = 1.2,
			DevProductId = 3712582136,
			Rarity = "Chromatic",
			Image = "rbxassetid://139330533171525",
		},
		Aurora = {
			Name = "Aurora",
			Order = 11,
			Price = 1400000000000000,
			SpeedMultiplier = 1.85,
			MovementMultiplier = 1.17,
			DevProductId = 3712582702,
			Rarity = "Ethereal",
			Image = "rbxassetid://107032270039101",
		},
		Matrix = {
			Name = "Matrix",
			Order = 9,
			Price = 7000000000000,
			SpeedMultiplier = 1.6,
			MovementMultiplier = 1.12,
			DevProductId = 3712582200,
			Rarity = "Cosmic",
			Image = "rbxassetid://80236790399065",
		},
		Glitch = {
			Name = "Glitch",
			Order = 8,
			Price = 560000000000,
			SpeedMultiplier = 1.5,
			MovementMultiplier = 1.1,
			DevProductId = 3712582389,
			Rarity = "Cosmic",
			Image = "rbxassetid://112137029203204",
		},
		Ink = {
			Name = "Ink",
			Order = 7,
			Price = 35000000000,
			SpeedMultiplier = 1.4,
			MovementMultiplier = 1.08,
			DevProductId = 3712582332,
			Rarity = "Legendary",
			Image = "rbxassetid://112890852102298",
		},
		Leaf = {
			Name = "Leaf",
			Order = 5,
			Price = 140000000,
			SpeedMultiplier = 1.25,
			MovementMultiplier = 1.05,
			DevProductId = 3712582247,
			Rarity = "Epic",
			Image = "rbxassetid://138698084926486",
		},
		VIP = {
			Name = "VIP",
			Order = 6,
			Price = 2100000000,
			SpeedMultiplier = 1.3,
			MovementMultiplier = 1.06,
			DevProductId = 3712582050,
			Rarity = "Legendary",
			Image = "rbxassetid://116975414128720",
		},
		Fire = {
			Name = "Fire",
			Order = 4,
			Price = 7000000,
			SpeedMultiplier = 1.2,
			MovementMultiplier = 1.04,
			DevProductId = 3712582561,
			Rarity = "Epic",
			Image = "rbxassetid://109333269083874",
		},
		Water = {
			Name = "Water",
			Order = 3,
			Price = 50000,
			SpeedMultiplier = 1.15,
			MovementMultiplier = 1.03,
			DevProductId = 3712581939,
			Rarity = "Rare",
			Image = "rbxassetid://120042540342318",
		},
		Banana = {
			Name = "Banana",
			Order = 2,
			Price = 2500,
			SpeedMultiplier = 1.1,
			MovementMultiplier = 1.02,
			DevProductId = 3712582620,
			Rarity = "Uncommon",
			Image = "rbxassetid://112039239759785",
		},
		Red = {
			Name = "Red",
			Order = 1,
			Price = 100,
			SpeedMultiplier = 1.05,
			MovementMultiplier = 1.01,
			DevProductId = 3712581970,
			Rarity = "Common",
			Image = "rbxassetid://77915122741706",
		},
	},
	CardGradients = tbl1,
}

var1 = 115
num1 = 115
num2 = 130
tbl1 = cardGradient(Color3.fromRGB(190, 190, 200), Color3.fromRGB(var1, num1, num2))
tbl2.GetCardGradient = function(arg1)
	local var1 = tbl2.CardGradients[tostring(arg1 or "")]
	return var1 or tbl1
end

tbl2.Get = function(arg1)
	return tbl2.Trails[tostring(arg1 or "")]
end

tbl2.Exists = function(arg1)
	return tbl2.Get(arg1) ~= nil
end

tbl2.GetPrice = function(arg1)
	local var2 = tbl2.Get(arg1)
	if var2 then
		local var4 = tonumber(var2.Price)
		if not var4 then
			return 0
		end
	end

	return 0
end

tbl2.GetSpeedMultiplier = function(arg1)
	local var2 = tbl2.Get(arg1)
	if var2 then
		local var3 = math.max(1, tonumber(var2.SpeedMultiplier) or 1)
		var3 = var3 or 1
	end

	return 1
end

tbl2.GetMovementMultiplier = function(arg1)
	local var2 = tbl2.Get(arg1)
	if var2 then
		local var3 = math.max(1, tonumber(var2.MovementMultiplier) or 1)
		var3 = var3 or 1
	end

	return 1
end

tbl2.GetDevProductId = function(arg1)
	local var2 = tbl2.Get(arg1)
	if var2 then
		local var3 = math.max(0, (math.floor(tonumber(var2.DevProductId) or 0)))
		var3 = var3 or 0
	end

	return 0
end

tbl2.HasRobuxOption = function(arg1)
	return 0 < tbl2.GetDevProductId(arg1)
end

tbl2.GetImage = function(arg1)
	local var2 = tbl2.Get(arg1)
	if var2 then
		local var3 = tostring(var2.Image or "")
		var3 = var3 or ""
	end

	return ""
end

tbl2.GetOrder = function(arg1)
	local var2 = tbl2.Get(arg1)
	if var2 then
		local var4 = tonumber(var2.Order)
		if not var4 then
			return math.huge
		end
	end

	return math.huge
end

tbl2.GetByDevProductId = function(arg1)
	arg1 = tonumber(arg1) or 0
	for k1, v1 in pairs(tbl2.Trails) do
		if 0 >= arg1 then
			continue
		end

		if tonumber(v1.DevProductId) ~= arg1 then
			continue
		end

		return k1, v1
	end

	return nil, nil
end

tbl2.GetOrderedIds = function()
	local tbl1 = {}
	for k1 in pairs(tbl2.Trails) do
		table.insert(tbl1, k1)
	end

	table.sort(tbl1, function(arg1, arg2)
		return tbl2.GetOrder(arg1) < tbl2.GetOrder(arg2)
	end)

	return tbl1
end

return tbl2

--- ReplicatedStorage.Configs.DrivingConfig [ModuleScript]
-- y u r i

return {
	Tag = "DrivableCar",
	ForwardSpeed = 48,
	ReverseSpeed = 24,
	Acceleration = 32,
	Braking = 60,
	SteeringAngle = 35,
	SteeringRate = 24,
	SteeringServoSpeed = 14,
	MovementResponse = 0.12,
	TurnResponse = 14,
	BodySway = {
		Enabled = true,
		Pitch = 9,
		Roll = 13,
		Bounce = 0.32,
		LeanSeconds = 0.22,
		BounceSeconds = 0.34,
	},
	MobileSteeringMultiplier = 0.2,
	TurnRate = 600,
	EntryDistance = 6,
	EntryCooldown = 3,
	InputTimeout = 0.5,
	SendInterval = 0.05,
	CameraMinZoom = 14,
	CameraMaxZoom = 40,
}

--- ReplicatedStorage.Configs.ZoneConfig [ModuleScript]
-- y u r i

local num1 = 245
local num2 = 255
local num3 = 255
local tbl1 = { Color3.fromRGB(120, 225, 255), Color3.fromRGB(num1, num2, num3) }
local tbl2 = {
	Enabled = true,
	Name = "Plains\240\159\153\130",
	Colors = tbl1,
	ChaseSpeed = 3,
	ReturnSpeed = 12,
	CatchupEnabled = false,
	ChaseAcceleration = 5,
	ChaseRange = 360,
	WakeDistance = 360,
	JumpHeight = 3,
	JumpSeconds = 0.65,
	CatchGrace = 8,
	CarSpeed = 48,
	OutlineMargin = 0.5,
}

tbl2.Cars = { "Civaru", "Acurin", "Toyoso" }
local tbl3 = { tbl2 }
num1 = 210
num2 = 225
num3 = 255
tbl1 = { Color3.fromRGB(120, 175, 255), Color3.fromRGB(num1, num2, num3) }
tbl3[2] = { Enabled = true, CatchInset = 0.5, Name = "Plains\240\159\152\132", Colors = tbl1 }
num1 = 255
num2 = 180
num3 = 235
tbl1 = { Color3.fromRGB(200, 125, 255), Color3.fromRGB(num1, num2, num3) }
tbl3[3] = { Enabled = true, Name = "Desert\240\159\152\175", Colors = tbl1 }
num1 = 255
num2 = 245
num3 = 175
tbl1 = { Color3.fromRGB(255, 195, 60), Color3.fromRGB(num1, num2, num3) }
tbl3[4] = { Enabled = true, Name = "Magma\240\159\164\168", Colors = tbl1 }
num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(135, 220, 255), Color3.new(num1, num2, num3) }
tbl3[5] = { Enabled = true, Name = "Ice\240\159\152\182", Colors = tbl1 }
num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(100, 220, 130), Color3.new(num1, num2, num3) }
tbl3[6] = { Enabled = true, Name = "Jungle\240\159\152\167", Colors = tbl1 }
num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(255, 160, 190), Color3.new(num1, num2, num3) }
tbl3[7] = {
	Enabled = true,
	Name = "Wasteland\240\159\164\144",
	CatchupEnabled = false,
	ChaseAcceleration = 240,
	ChaseCruiseRatio = 0.96,
	Colors = tbl1,
}

num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(100, 190, 255), Color3.new(num1, num2, num3) }
tbl3[8] = { Enabled = true, Name = "Coral\240\159\152\159", Colors = tbl1 }
num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(180, 220, 255), Color3.new(num1, num2, num3) }
tbl3[9] = { Enabled = true, Name = "Monster\240\159\152\160", Colors = tbl1 }
num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(175, 130, 255), Color3.new(num1, num2, num3) }
tbl3[10] = { Enabled = true, Name = "Galaxy\240\159\152\161", Colors = tbl1 }
num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(255, 100, 90), Color3.new(num1, num2, num3) }
tbl3[11] = { Enabled = true, Name = "Martian\240\159\152\136", Colors = tbl1 }
num1 = 1
num2 = 1
num3 = 1
tbl1 = { Color3.fromRGB(255, 210, 40), Color3.new(num1, num2, num3) }
tbl3[12] = {
	Enabled = true,
	Name = "Palace \240\159\143\176",
	EventOnly = true,
	CatchInset = 1,
	Colors = tbl1,
}

num1 = 255
num2 = 190
num3 = 50
tbl1 = { Color3.fromRGB(255, 65, 20), Color3.fromRGB(num1, num2, num3) }
tbl3[13] = {
	Enabled = true,
	Name = "Underworld \240\159\148\165",
	EventOnly = true,
	SignRarity = "Infernal",
	ChaseAcceleration = 420,
	CatchInset = 0.4,
	CatchGrace = 2.2,
	JumpHeight = 1.4,
	Colors = tbl1,
}

local tbl4 = {
	TickRate = 20,
	Catchup = {
		UndertrainedFraction = 1,
		ClosingFraction = 0.45,
		MinClosingSpeed = 12,
		MaxClosingSpeed = 100,
		FlatRadius = 35,
		MaxMultiplier = 2.5,
		MaxSpeed = 480,
		StartDistance = 65,
		EndDistance = 22,
		ExtraSpeed = 110,
		MinExtraSpeed = 24,
		Gain = 2,
		Acceleration = 1200,
		Braking = 1600,
		UndertrainedCatchGrace = 0.65,
	},
	ZonePollInterval = 0.15,
	PromptDistance = 12,
	ParkingDistance = 26,
	ParkingServerTolerance = 6,
	RespawnSeconds = 8,
	AbandonedSeconds = 60,
	RagdollSeconds = 2.5,
	FinishCaptureWindow = 0.3,
	FinishCaptureMaxDistance = 60,
	Impact = {
		SpeedScale = 0.95,
		MinimumSpeed = 45,
		MaximumSpeed = 600,
		BaseUp = 32,
		UpScale = 0.14,
		MaximumUp = 90,
	},
	LaunchSpeed = 48,
	LaunchUp = 28,
	ChaseFovIncrease = 12,
	ChaseMusicId = "",
	PoliceSirenId = "",
	ConfettiEnabled = true,
	ConfettiParticleCount = 192,
	ConfettiDuration = 3.8,
	FinishConfettiParticleCount = 256,
	FinishConfettiMobileCount = 128,
	FinishConfettiDuration = 6,
	FinishFovDip = 6,
	Zones = tbl3,
}

tbl3 = require(script.Parent.CarConfig)
tbl2 = {}
tbl2[2] = 380
tbl2[4] = 45000
tbl2[7] = 2000000
local num4 = 2500000
local var1 = require(script.Parent.SpeedConfig)
tbl4.ChaseCruiseRatio = 0.9
local tbl5 = {}
tbl5[10] = { "NebulaX", "Scintara", "Paganzo" }
local str1 = "Paganzo"
tbl5[11] = { "NebulaX", "Scintara", str1 }
tbl1 = {
	17,
	500,
	5000,
	50000,
	200000,
	700000,
	num4,
	18000000,
	700000000,
	2500000000,
	10000000000,
	50000000000,
	200000000000,
}

for k1, v1 in tbl4.Zones, nil do
	if k1 == 12 then
		v1.Catchup = table.clone(tbl4.Catchup)
		v1.Catchup.FlatRadius = 70
		v1.Catchup.StartDistance = 100
		v1.Catchup.EndDistance = 55
	end

	v1.CarTier = k1
	local var2 = tbl5[k1]
	local var3 = table.clone(var2 or (tbl3.Tiers[k1] and tbl3.Tiers[k1].Cars or (v1.Cars or {})))
	v1.Cars = var3
	v1.RecommendedSpeedPower = tbl1[k1]
	var3 = tbl2[k1]
	v1.ChaserSpeedPower = var3 or tbl1[k1]
	if k1 == 1 then
		var3 = 3
	else
		local var4 = v1.ChaseCruiseRatio
		var3 = var1.PowerToWalkSpeed(v1.ChaserSpeedPower) * (var4 or tbl4.ChaseCruiseRatio)
	end

	v1.ChaseSpeed = var3
	var3 = v1.ChaseSpeed
	v1.ChaseSpeed = var3 or 10 + (k1 - 1) * 8
	v1.ReturnSpeed = 32 + (k1 - 1) * 8
	var3 = v1.ChaseRange or 360
	v1.ChaseRange = var3
	var3 = v1.WakeDistance or 360
	v1.WakeDistance = var3
	var3 = v1.JumpHeight or 3
	v1.JumpHeight = var3
	var3 = v1.CatchGrace or 1.8
	v1.CatchGrace = var3
end

tbl4.Get = function(arg1)
	local var2 = tbl4.Zones[tonumber(arg1)]
	if var2 then
		return var2
	end

	local num1 = 160
	local num2 = 190
	local num3 = 255
	local tbl1 = { Enabled = false, Name = "Zone " .. tostring(arg1) }
	local tbl2 = { Color3.new(1, 1, 1), Color3.fromRGB(num1, num2, num3) }
	tbl1.Colors = tbl2
	return tbl1
end

return tbl4

--- ReplicatedStorage.Configs.TreadmillConfig [ModuleScript]
-- y u r i

return {
	AFKRejoinEnabled = true,
	AFKRejoinSeconds = 1020,
	AFKRetrySeconds = 15,
	TickSeconds = 1,
	ScanSeconds = 0.05,
	EffectDistance = 120,
	Tiers = {
		{ Name = "Starter", Price = 10, SpeedPerSecond = 5 },
		{ Name = "Celebrity", Price = 1000, SpeedPerSecond = 20, ProductId = 3712732526 },
		{ Name = "Golden", Price = 20000, SpeedPerSecond = 75, ProductId = 3712732580 },
		{ Name = "Freeze", Price = 2100000, SpeedPerSecond = 250, ProductId = 3712732647 },
		{ Name = "Flame", Price = 35000000, SpeedPerSecond = 750, ProductId = 3712732711 },
		{ Name = "Sci-Fi", Price = 560000000, SpeedPerSecond = 2000, ProductId = 3712732799 },
		{
			Name = "Lucky Block",
			Price = 8400000000,
			SpeedPerSecond = 5000,
			ProductId = 3712732880,
		},
		{ Name = "Hacker", Price = 140000000000, SpeedPerSecond = 10000, ProductId = 3712732936 },
		{
			Name = "Demonic",
			Price = 2100000000000,
			SpeedPerSecond = 15000,
			ProductId = 3712732985,
		},
		{
			Name = "Angelic",
			Price = 35000000000000,
			SpeedPerSecond = 27000,
			ProductId = 3712733038,
		},
		{
			Name = "Devil",
			Price = 140000000000000,
			SpeedPerSecond = 50000,
			ProductId = 3713428906,
		},
		{
			Name = "Clockwork",
			Price = 420000000000000,
			SpeedPerSecond = 100000,
			ProductId = 3713873625,
		},
		{
			Name = "Overgrown",
			Price = 1400000000000000,
			SpeedPerSecond = 250000,
			ProductId = 3713873663,
		},
		{
			Name = "Abyssal",
			Price = 8400000000000000,
			SpeedPerSecond = 750000,
			ProductId = 3713873704,
		},
		{ Name = "Prismatic", Price = 2.8e+16, SpeedPerSecond = 2000000, ProductId = 3713873745 },
	},
}

--- ReplicatedStorage.Configs.SpeedConfig [ModuleScript]
-- y u r i

local tbl1 = {
	StartingSpeed = 17,
	BaseWalkSpeed = 17,
	FirstLevelCost = 100,
	LevelCostGrowth = 1.15,
	WalkSpeedPerLevel = 1.9517241379310344,
	LegacyMaxWalkSpeed = 300,
	MaxWalkSpeed = 315,
	EndgamePowerPerStud = 5000000000,
	MaxSpeedPower = 9007199254740991,
}

tbl1.EndgameStartPower = tbl1.StartingSpeed + tbl1.FirstLevelCost / (tbl1.LevelCostGrowth - 1) * (tbl1.LevelCostGrowth ^ ((tbl1.LegacyMaxWalkSpeed - tbl1.BaseWalkSpeed) / tbl1.WalkSpeedPerLevel) - 1)
tbl1.EndgameCapPower = tbl1.EndgameStartPower + (tbl1.MaxWalkSpeed - tbl1.LegacyMaxWalkSpeed) * tbl1.EndgamePowerPerStud
tbl1.NormalizePower = function(arg1)
	local var2 = tonumber(arg1)
	if not var2 or (var2 ~= var2 or var2 == -math.huge) then
		return tbl1.StartingSpeed
	end

	if var2 == math.huge then
		return tbl1.MaxSpeedPower
	end

	return (math.clamp(math.floor(var2), tbl1.StartingSpeed, tbl1.MaxSpeedPower))
end

tbl1.PowerToWalkSpeed = function(arg1)
	local var1 = tbl1.NormalizePower(arg1)
	return (math.min(tbl1.MaxWalkSpeed, math.min(tbl1.LegacyMaxWalkSpeed, tbl1.BaseWalkSpeed + math.log(1 + (var1 - tbl1.StartingSpeed) * (tbl1.LevelCostGrowth - 1) / tbl1.FirstLevelCost) / math.log(tbl1.LevelCostGrowth) * tbl1.WalkSpeedPerLevel) + math.clamp((var1 - tbl1.EndgameStartPower) / tbl1.EndgamePowerPerStud, 0, tbl1.MaxWalkSpeed - tbl1.LegacyMaxWalkSpeed)))
end

tbl1.ResolveWalkSpeed = function(arg1, arg2, arg3)
	if arg3 then
		return tbl1.BaseWalkSpeed
	end

	local var2 = tonumber(arg2) or 1
	if var2 ~= var2 then
		var2 = 1
	end

	local var3 = tbl1.NormalizePower(arg1)
	return (math.min(tbl1.MaxWalkSpeed, math.min(tbl1.LegacyMaxWalkSpeed, math.min(tbl1.LegacyMaxWalkSpeed, tbl1.BaseWalkSpeed + math.log(1 + (var3 - tbl1.StartingSpeed) * (tbl1.LevelCostGrowth - 1) / tbl1.FirstLevelCost) / math.log(tbl1.LevelCostGrowth) * tbl1.WalkSpeedPerLevel) * math.max(1, var2)) + math.clamp((var3 - tbl1.EndgameStartPower) / tbl1.EndgamePowerPerStud, 0, tbl1.MaxWalkSpeed - tbl1.LegacyMaxWalkSpeed)))
end

return tbl1

--- ReplicatedStorage.Configs.GlobalLeaderboardConfig [ModuleScript]
-- y u r i

local var1 = require(script.Parent.ReleaseConfig)
return {
	Namespace = var1.DataVersion .. "-Global",
	StudioSuffix = var1.StudioSuffix,
	RefreshSeconds = 75,
	TopCount = 100,
	ExcludedUserIds = { [4479030213] = true, [1227688240] = true },
	MoneyMetric = "Income",
	RenderDistance = 180,
	RowHeight = 78,
	RowGap = 8,
}

--- ReplicatedStorage.Configs.IndexConfig [ModuleScript]
-- y u r i

return { Rewards = {
	{ UnlocksRequired = 1, Cash = 25 },
	{ UnlocksRequired = 5, Cash = 2500 },
	{ UnlocksRequired = 10, Cash = 100000 },
	{ UnlocksRequired = 20, Cash = 100000000 },
	{ UnlocksRequired = 32, Cash = 50000000000 },
	{ UnlocksRequired = 34, Cash = 500000000000 },
} }

--- ReplicatedStorage.Configs.ShopConfig [ModuleScript]
-- y u r i

local tbl1 = {
	Cash = {
		Small = { ProductId = 3712580883, Amount = 24000 },
		Medium = { ProductId = 3712580985, Amount = 200000 },
		Large = { ProductId = 3712581088, Amount = 800000 },
		Massive = { ProductId = 3712581140, Amount = 5000000 },
	},
	Speed = {
		Small = { ProductId = 3712581633, Amount = 150000 },
		Medium = { ProductId = 3712581452, Amount = 1000000 },
		Large = { ProductId = 3712581557, Amount = 10000000 },
		Massive = { ProductId = 3712581240, Amount = 1000000000 },
	},
	Gamepasses = {
		Cash = { PassId = 1977039239, Multiplier = 2 },
		Speed = { PassId = 1978923068, Multiplier = 2 },
	},
	OfflineLoot = { ProductId = 3712639465, MinimumAwaySeconds = 180 },
	CaughtSpeed = {
		{ ProductId = 3712639530 },
		{ ProductId = 3712639590 },
		{ ProductId = 3712639646 },
		{ ProductId = 3712640101 },
		{ ProductId = 3712640081 },
		{ ProductId = 3712640064 },
		{ ProductId = 3712640027 },
		{ ProductId = 3712639990 },
		{ ProductId = 3712639964 },
		{ ProductId = 3712639924 },
		{ ProductId = 3712639723 },
	},
}

local var1 = require(script.Parent.ZoneConfig)
for k1, v1 in tbl1.CaughtSpeed, nil do
	v1.Amount = var1.Get(k1).RecommendedSpeedPower
end

tbl1.StarterPack = {
	ProductId = 3713193708,
	CashAmount = 5000000,
	SpeedAmount = 10000,
	CarId = "Urus",
	DisplayPrice = 49,
}

tbl1.Boosts = {
	Personal = {
		Treadmill = {
			Multiplier = 2,
			Offers = {
				["10_Treadmill"] = { ProductId = 3713193851, DurationSeconds = 600 },
				["30_Treadmill"] = { ProductId = 3713193889, DurationSeconds = 1800 },
			},
		},
		Cash = {
			Multiplier = 2,
			Offers = {
				["10_Cash"] = { ProductId = 3713193916, DurationSeconds = 600 },
				["30_Cash"] = { ProductId = 3713193941, DurationSeconds = 1800 },
			},
		},
	},
	Global = {
		ProductId = 3713193990,
		DurationSeconds = 480,
		TreadmillMultiplier = 1.5,
		CashMultiplier = 1.2,
		DisplayPrice = 10000,
	},
}

return tbl1

--- ReplicatedStorage.Configs.TutorialConfig [ModuleScript]
-- y u r i

local var1 = require(script.Parent.ReleaseConfig)
return {
	Version = var1.TutorialVersion,
	FunnelName = var1.TutorialFunnel,
	PollInterval = 0.35,
	Steps = {
		"Spawned",
		"EnteredFirstCar",
		"CarSecured",
		"MiniCarEquipped",
		"CarPlaced",
		"StarterTreadmillBought",
		"TutorialCompleted",
	},
}

--- ReplicatedStorage.Configs.FreeGiftConfig [ModuleScript]
-- y u r i

return { GroupId = 465590932, SpeedReward = 10000, DeclineTextSeconds = 2 }

--- ReplicatedStorage.Configs.RareCarConfig [ModuleScript]
-- y u r i

return {
	ZoneId = 11,
	MinInterval = 360,
	MaxInterval = 480,
	DisplaySeconds = 7,
	Cars = {
		{ Id = "Bughaci", Weight = 3 },
		{ Id = "Xythera", Weight = 3 },
		{ Id = "FormulaX", Weight = 1 },
	},
}

--- ReplicatedStorage.Configs.CombatConfig [ModuleScript]
-- y u r i

return {
	BatRange = 7,
	BatCooldown = 0.8,
	BatKnockback = 48,
	BatLift = 28,
	BatRagdollSeconds = 2,
	TrapSeconds = 5,
	MaxTraps = 3,
	PlaceDistance = 25,
	SafeLineClearance = 25,
	TrapSize = Vector3.new(11, 1.2, 13),
	TrapArmSeconds = 0.75,
	ScanInterval = 0.05,
	PickupDistance = 12,
}

--- ReplicatedStorage.Configs.ReleaseConfig [ModuleScript]
-- y u r i

local tbl1 = {
	DataVersion = "SAC-Launch-20260913-v1",
	StudioSuffix = "_Studio",
	TutorialVersion = "Launch_20260913_v1",
	TutorialFunnel = "SAC_Launch_Tutorial_v1",
}

return table.freeze(tbl1)

--- ReplicatedStorage.Configs.TreadmillMultiplierConfig [ModuleScript]
-- y u r i

local tbl1 = {}
tbl1[2] = { ProductId = 3712737397, RobuxPrice = 249 }
tbl1[4] = { ProductId = 3712737821, RobuxPrice = 249 }
tbl1[8] = { ProductId = 3712737858, RobuxPrice = 249 }
tbl1[16] = { ProductId = 3712737899, RobuxPrice = 249 }
tbl1[32] = { ProductId = 3712737952, RobuxPrice = 249 }
tbl1[64] = { ProductId = 3712738004, RobuxPrice = 249 }
return { MaxLevel = 6, Upgrades = tbl1 }

--- ReplicatedStorage.Configs.RaceConfig [ModuleScript]
-- y u r i

return {
	Enabled = true,
	IntermissionSeconds = 280,
	JoinSeconds = 20,
	InviteSeconds = 10,
	StagingSeconds = 8,
	CountdownSeconds = 3,
	RaceSeconds = 100,
	ResultsSeconds = 2,
	FinishPresentationSeconds = 4,
	MinimumPlayers = 1,
	MaximumPlayers = 5,
	UsePlayerSpeed = false,
	CarSpeed = 100,
	Laps = 2,
	Boost = { Multiplier = 1.4, Duration = 2.5, CameraFovIncrease = 8, CameraTweenSeconds = 0.25 },
	CameraFovIncrease = 14,
	CameraFovInSeconds = 0.7,
	CameraFovOutSeconds = 0.55,
	SteerAssist = {
		Enabled = true,
		MobileOnly = true,
		Strength = 0,
		MobileStrength = 0.5,
		MaxCorrection = 0,
		MobileMaxCorrection = 0.14,
		LookAheadSeconds = 0.5,
	},
	DesktopSteering = { Multiplier = 0.8, Response = 6, ReturnResponse = 9, FullSteeringSpeed = 12 },
	SampleSeconds = 0.05,
	SeatTimeout = 12,
	MaximumResets = 12,
	TrackMargin = 1,
	TrackEdgeTolerance = 2,
	BorderCrossingTolerance = 0.5,
	MaxGroundHeight = 12,
	Maps = {
		"StudCircuit",
		"JungleIslandCircuit",
		"RainbowGalaxyCircuit",
		"NeonReefCircuit",
		"FrostpeakSummit",
		"UnderworldCalderaCircuit",
	},
	CashRewardIcon = "rbxassetid://79332996402969",
	SpeedRewardIcon = "rbxassetid://103215736808819",
}

--- ReplicatedStorage.Configs.StudioTestConfig [ModuleScript]
-- y u r i

return { Enabled = false, InMemoryProfiles = false }

--- ReplicatedStorage.Configs.CelestialSpawnConfig [ModuleScript]
-- y u r i

return {
	ZoneId = 12,
	IntervalSeconds = 300,
	AvailableSeconds = 300,
	BaseDenominator = 13,
	PityAfterSeconds = 3600,
	PityDenominator = 5,
	PityDecrease = 0.4,
	Cars = { "LaFerrari", "VisionAMG" },
}

--- ReplicatedStorage.Configs.FuseConfig [ModuleScript]
-- y u r i

return {
	Tiers = {
		{
			Name = "Hybrid",
			CarId = "Hybrid",
			Duration = 60,
			SkipProductId = 3713322818,
			Ingredients = { "RSX", "NissaruR32", "Charger" },
		},
		{
			Name = "Cyber",
			CarId = "Cyber",
			Duration = 300,
			SkipProductId = 3713322834,
			Ingredients = { "Nebula", "Corvessa", "SkylanceR" },
		},
		{
			Name = "Racer",
			CarId = "Racer",
			Duration = 900,
			SkipProductId = 3713322856,
			Ingredients = { "AudrixR8", "Spyra", "Verde" },
		},
		{
			Name = "Void",
			CarId = "Void",
			Duration = 2700,
			SkipProductId = 3713322876,
			Ingredients = { "Cosmo", "Scintara", "Paganzo" },
		},
		{
			Name = "Bat",
			CarId = "Bat",
			Duration = 7200,
			SkipProductId = 3713322890,
			Ingredients = { "Bughaci", "VisionAMG", "Xythera" },
		},
		{
			Name = "Tokyo Tow Truck",
			CarId = "TokyoTowTruck",
			Duration = 43200,
			SkipProductId = 0,
			Ingredients = { "LaFerrari", "Phantom", "Xythera" },
		},
		{
			Name = "Mercedes AVTR",
			CarId = "AvatarAVTR",
			Duration = 57600,
			SkipProductId = 0,
			Ingredients = { "VisionAMG", "GTR", "Xythera" },
		},
		{
			Name = "Cyber Cab",
			CarId = "CyberCab",
			Duration = 64800,
			SkipProductId = 0,
			Ingredients = { "FormulaX", "LaFerrari", "Phantom" },
		},
	},
	PromptDistance = 14,
	ServerDistance = 24,
}

--- ReplicatedStorage.Configs.DontLeaveGiftConfig [ModuleScript]
-- y u r i

return {
	CashReward = 1000000,
	SpeedReward = 25000,
	PulseSeconds = 0.85,
	PulseTransparency = 0.85,
	DingSound = "Notification",
}

--- ReplicatedStorage.Configs.Ferrari458Config [ModuleScript]
-- y u r i

return {
	ProductId = 3713873783,
	CarId = "Ferrari458",
	EntitlementKey = "Ferrari458ProductV1",
	OwnedAttribute = "Ferrari458Owned",
	PendingAttribute = "Ferrari458PurchasePending",
	PodiumName = "PodiumFerrari458",
	PromptName = "Ferrari458PurchasePrompt",
	PromptDistance = 14,
	RotationDegreesPerSecond = 14,
}

--- ReplicatedStorage.Configs.UnderworldSpawnConfig [ModuleScript]
-- y u r i

return {
	ZoneId = 13,
	IntervalSeconds = 300,
	AvailableSeconds = 300,
	BaseDenominator = 13,
	PityAfterSeconds = 3600,
	PityDenominator = 5,
	PityDecrease = 0.4,
	Cars = { "Phantom", "GTR" },
}

--- ReplicatedStorage.Configs.TreadmillClickConfig [ModuleScript]
-- y u r i

return {
	MinInterval = 5,
	MaxInterval = 15,
	Duration = 2.5,
	Multipliers = { 2, 3 },
	Paid = {
		ProductId = 3716039764,
		MinInterval = 20,
		MaxInterval = 30,
		OfferSeconds = 6,
		Duration = 2.5,
		Multiplier = 20,
	},
	PulseSeconds = 0.45,
	PulseScale = 1.1,
}

--- ReplicatedStorage.Configs.AdminCrateConfig [ModuleScript]
-- y u r i

local tbl1 = {
	Center = Vector3.new(55, 2, 0),
	AreaSize = Vector2.new(38, 360),
	Spacing = 7,
	FallHeight = 65,
	FallSeconds = 2,
	Lifetime = 60,
	ClaimDistance = 12,
	PromptDistance = 10,
	MaxActiveDrops = 3,
	CatalogVersion = 1,
	MaxCashReward = 1000000000000000,
	MaxSpeedReward = 1000000000000,
}

tbl1.CarIds = {
	"Acurin",
	"Audrix",
	"AudrixR8",
	"AvatarAVTR",
	"Azure",
	"Bat",
	"BeymarM8",
	"Bughaci",
	"CyberCab",
	"Challara",
	"ChallaraSRT",
	"Charger",
	"Civaru",
	"Corvessa",
	"Cosmo",
	"Crimson",
	"Cyber",
	"Ferrari458",
	"FormulaX",
	"GTR",
	"Hybrid",
	"LaFerrari",
	"Nebula",
	"NebulaX",
	"Nissaru",
	"NissaruR32",
	"Paganzo",
	"Phantom",
	"RSX",
	"Racer",
	"Revuelto",
	"RosellaR",
	"Scintara",
	"SkylanceR",
	"Spectra",
	"Spyra",
	"Suncharge",
	"TokyoTowTruck",
	"Toyoso",
	"Urus",
	"Velocita",
	"Verde",
	"Viper",
	"Vipra",
	"VisionAMG",
	"Void",
	"Xythera",
}

tbl1.Rewards = {
	{ Kind = "Cash", Amount = 25000, Weight = 45 },
	{ Kind = "Speed", Amount = 1000, Weight = 35 },
	{ Kind = "Car", CarId = "Suncharge", Weight = 10 },
	{ Kind = "Car", CarId = "Vipra", Weight = 7 },
	{ Kind = "Car", CarId = "Corvessa", Weight = 3 },
}

return tbl1

--- ReplicatedStorage.Modules.BigNumber [ModuleScript]
-- y u r i

local function normalize(arg1, arg2)
	if arg1 ~= arg1 or (arg1 == math.huge or arg1 == -math.huge) then
		return { Mantissa = 0, Exponent = 0 }
	end

	if arg1 == 0 then
		return { Mantissa = 0, Exponent = 0 }
	end

	arg1 = math.abs(arg1)
	local var1 = if arg1 < 0 then -1 else 1
	while 10 <= arg1 do
		arg1 = arg1 / 10
		arg2 = arg2 + 1
	end

	while arg1 < 1 do
		arg1 = arg1 * 10
		arg2 = arg2 - 1
	end

	arg1 = math.round(arg1 * 100000000000000) / 100000000000000
	if 10 <= arg1 then
		arg1 = arg1 / 10
		arg2 = arg2 + 1
	end

	return { Mantissa = var1 * arg1, Exponent = arg2 }
end

local tbl1 = {
	new = function(arg1, arg2)
		return (normalize(tonumber(arg1) or 0, tonumber(arg2) or 0))
	end,
	fromNumber = function(arg1)
		return (normalize(tonumber(arg1) or 0, 0))
	end,
	fromData = function(arg1)
		if type(arg1) == "table" then
			return (normalize(tonumber(arg1.Mantissa) or 0, tonumber(arg1.Exponent) or 0))
		end

		return (normalize(tonumber(arg1) or 0, 0))
	end,
}

tbl1.isZero = function(arg1)
	return tbl1.fromData(arg1).Mantissa == 0
end

tbl1.negate = function(arg1)
	local var1 = tbl1.fromData(arg1)
	return (normalize(-var1.Mantissa, var1.Exponent))
end

tbl1.add = function(arg1, arg2)
	local var1 = tbl1.fromData(arg1)
	local var2 = tbl1.fromData(arg2)
	if var1.Mantissa == 0 then
		return var2
	end

	if var2.Mantissa == 0 then
		return var1
	end

	if var1.Exponent < var2.Exponent then
		local var4 = var2
		var2 = var1
		var1 = var4
	end

	local var6 = var1.Exponent - var2.Exponent
	if 16 < var6 then
		return var1
	end

	return (normalize(var1.Mantissa + var2.Mantissa / 10 ^ var6, var1.Exponent))
end

tbl1.sub = function(arg1, arg2)
	local var1 = arg2
	local var2 = arg1
	return tbl1.add(var2, tbl1.negate(var1))
end

tbl1.mul = function(arg1, arg2)
	local var1 = tbl1.fromData(arg1)
	local var3 = tbl1.fromData(arg2)
	if var1.Mantissa == 0 or var3.Mantissa == 0 then
		return { Mantissa = 0, Exponent = 0 }
	end

	return (normalize(var1.Mantissa * var3.Mantissa, var1.Exponent + var3.Exponent))
end

tbl1.div = function(arg1, arg2)
	local var1 = tbl1.fromData(arg2)
	local var2 = tbl1.fromData(arg1)
	if var1.Mantissa == 0 then
		return { Mantissa = 0, Exponent = 0 }
	end

	return (normalize(var2.Mantissa / var1.Mantissa, var2.Exponent - var1.Exponent))
end

tbl1.compare = function(arg1, arg2)
	local var1 = tbl1.sub(arg1, arg2)
	if 0 < var1.Mantissa then
		return 1
	end

	if var1.Mantissa < 0 then
		return -1
	end

	return 0
end

tbl1.isNegative = function(arg1)
	return tbl1.fromData(arg1).Mantissa < 0
end

tbl1.toNumber = function(arg1)
	local var1 = tbl1.fromData(arg1)
	return var1.Mantissa * 10 ^ var1.Exponent
end

tbl1.toData = function(arg1)
	local var1 = tbl1.fromData(arg1)
	return { Mantissa = var1.Mantissa, Exponent = var1.Exponent }
end

return tbl1

--- ReplicatedStorage.Modules.NumberFormatter [ModuleScript]
-- y u r i

local tbl1 = {
	"",
	"K",
	"M",
	"B",
	"T",
	"Qa",
	"Qi",
	"Sx",
	"Sp",
	"Oc",
	"No",
	"Dc",
	"Ud",
	"Dd",
	"Td",
	"Qad",
	"Qid",
	"Sxd",
	"Spd",
	"Ocd",
	"Nod",
	"Vg",
}

local var1 = require(game:GetService("ReplicatedStorage").Modules.BigNumber)
local tbl2 = { Comma = function(arg1)
	local var1 = string.format("%d", (math.floor(tonumber(arg1) or 0)))
	local str2 = ""
	if string.sub(var1, 1, 1) == "-" then
		var1 = string.sub(var1, 2)
		str2 = "-"
	end

	local var2 = var1
	repeat
		local var3, var4 = string.gsub(var2, "^(%d+)(%d%d%d)", "%1,%2")
		local var5 = nil
		var2 = var3
	until var4 == 0

	return str2 .. var2
end }

tbl2.Format = function(arg1, arg2)
	local var2 = var1.fromData(arg1)
	if var2.Mantissa == 0 then
		return "0"
	end

	local var6 = var2.Exponent
	local var7 = if var2.Mantissa < 0 then "-" else ""
	local var8 = math.abs(var2.Mantissa)
	if var6 < 3 then
		return var7 .. tbl2.Comma(var8 * 10 ^ var6)
	end

	local var9 = math.floor(var6 / 3)
	local var12 = arg2
	local var13 = var8 * 10 ^ (var6 - var9 * 3)
	if not var12 then
		if var13 < 10 then
			var12 = 2
		else
			var12 = if var13 < 100 then 1 else 0
		end
	end

	local var14 = string.format("%." .. var12 .. "f", var13)
	local var15 = var7
	if string.find(var14, "%.") then
		var14 = string.gsub(string.gsub(var14, "0+$", ""), "%.$", "")
	end

	local var17 = tbl1[var9 + 1]
	local var18
	if var17 then
		var18 = var17
	else
		local var19 = var9 - #tbl1
		var18 = string.char(math.floor(var19 / 26) % 26 + 97) .. string.char(var19 % 26 + 97)
	end

	return var15 .. var14 .. var18
end

tbl2.Time = function(arg1)
	arg1 = math.max(0, (math.floor(tonumber(arg1) or 0)))
	local var7 = math.floor(arg1 / 3600)
	local var8 = math.floor(arg1 % 3600 / 60)
	local var9 = arg1 % 60
	if 0 < var7 then
		local str2 = "%dh %02dm %02ds"
		local var10 = var7
		local var11 = var8
		local var12 = var9
		return string.format(str2, var10, var11, var12)
	end

	if 0 < var8 then
		local str4 = "%dm %02ds"
		local var15 = var8
		local var16 = var9
		return string.format(str4, var15, var16)
	end

	local str5 = "%ds"
	local var17 = var9
	return string.format(str5, var17)
end

return tbl2

--- ReplicatedStorage.Modules.CarPlacement [ModuleScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
local var2 = require(var1.Configs.PlotConfig)
local var3 = require(var1.Configs.CarConfig)
local tbl1 = { GetSlotFolder = function(arg1)
	return arg1 and arg1:FindFirstChild(var2.SlotFolderName) or nil
end }

tbl1.GetSlotMarker = function(arg1, arg2)
	local var2 = tbl1.GetSlotFolder(arg1)
	if var2 then
		local var3 = var2:FindFirstChild((tostring(arg2)))
		var3 = var3 or nil
	end

	return nil
end

tbl1.GetSlotCount = function(arg1)
	local var2 = tbl1.GetSlotFolder(arg1)
	if not var2 then
		return 0
	end

	local num1 = 0
	for k1, v1 in ipairs(var2:GetChildren()) do
		if not v1:IsA("BasePart") then
			continue
		end

		if not tonumber(v1.Name) then
			continue
		end

		num1 = num1 + 1
	end

	return num1
end

tbl1.GetFloorY = function(arg1, arg2)
	local var1 = arg1
	var1 = var1 and arg1:FindFirstChild("Build")
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("Bottom")
	if not var2 or (not var2:IsA("BasePart")) then
		return nil
	end

	local num1 = 0
	if arg2 then
		local var5 = tbl1.GetSlotMarker(arg1, arg2)
		if var5 then
			if var5:GetAttribute("FloorIndex") == 2 then
				if not arg1:FindFirstChild("SecondFloor") then
					return nil
				end

				local str1 = "FloorOffset"
				num1 = tonumber(var5:GetAttribute(str1)) or 0
				if num1 <= 0 then
					return nil
				end
			end
		end
	end

	return var2.Position.Y + var2.Size.Y / 2 + num1
end

tbl1.GetGroundAnchor = function(arg1)
	local var1 = arg1
	var1 = var1 and arg1.PrimaryPart
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("GroundAnchor")
	return var2 and (var2:IsA("Attachment") and var2) or nil
end

tbl1.GetFootprint = function(arg1)
	if typeof(arg1) == "Instance" then
		local var4 = arg1:GetAttribute("CarWidth")
		local var5 = arg1:GetAttribute("CarLength")
		local var6 = arg1:GetAttribute("CarHeight")
		if var4 and var5 then
			return { Width = var4, Length = var5, Height = var6 or 0 }
		end

		local var7 = arg1.Name
		return var3.Get(var7)
	end

	local var8 = arg1
	return var3.Get(var8)
end

tbl1.GetClearance = function(arg1)
	local str1 = "ClearFront"
	local var1 = tonumber(arg1:GetAttribute(str1))
	local var3 = var2.DefaultClearance
	str1 = "ClearBack"
	local tbl1 = { Front = var1 or var3.Front }
	var1 = tonumber(arg1:GetAttribute(str1))
	tbl1.Back = var1 or var3.Back
	str1 = "ClearLeft"
	var1 = tonumber(arg1:GetAttribute(str1))
	tbl1.Left = var1 or var3.Left
	str1 = "ClearRight"
	var1 = tonumber(arg1:GetAttribute(str1))
	tbl1.Right = var1 or var3.Right
	return tbl1
end

tbl1.GetSlotCFrame = function(arg1, arg2)
	local var3 = tbl1.GetSlotMarker(arg1, arg2)
	local var4 = tbl1.GetFloorY(arg1, arg2)
	if not var3 or (not var4) then
		return nil
	end

	local var5 = Vector3.new(var3.Position.X, var4, var3.Position.Z)
	local var6 = tbl1.GetSlotMarker
	local var7 = arg1
	var6 = var6(var7, if arg2 % 2 == 1 then arg2 + 1 else arg2 - 1)
	var7 = Vector3.new(var6.Position.X - var5.X, 0, var6.Position.Z - var5.Z)
	if var6 and (var6:IsA("BasePart") and 0.01 < var7.Magnitude) then
		local var8 = var5
		local var9 = var5 + var7
		return CFrame.lookAt(var8, var9)
	end

	local var10, var11 = var3.CFrame:ToEulerAnglesYXZ()
	return CFrame.new(var5) * CFrame.Angles(0, var11, 0)
end

tbl1.SetAnchored = function(arg1, arg2)
	for k1, v1 in ipairs(arg1:GetDescendants()) do
		if not v1:IsA("BasePart") then
			continue
		end

		v1.Anchored = arg2
	end
end

tbl1.PlaceCar = function(arg1, arg2, arg3, arg4)
	local var2 = tbl1.GetSlotCFrame(arg2, arg3)
	if not arg1 or (not var2) then
		return false
	end

	if arg4 ~= false then
		tbl1.SetAnchored(arg1, true)
	end

	local var4 = tbl1.GetGroundAnchor(arg1)
	if var4 then
		arg1:PivotTo(var2 * var4.CFrame:Inverse())
	else
		local var5, var6 = arg1:GetBoundingBox()
		arg1:PivotTo(var2 * arg1:GetPivot():ToObjectSpace(var5 * CFrame.new(0, -var6.Y / 2, 0)):Inverse())
	end

	arg1:SetAttribute("Slot", arg3)
	return true
end

tbl1.CheckFit = function(arg1, arg2, arg3)
	local var3 = tbl1.GetSlotMarker(arg2, arg3)
	if not var3 then
		return { Fits = false, Reason = "no such slot" }
	end

	local var4 = tbl1.GetFootprint(arg1)
	local var5 = tbl1.GetClearance(var3)
	local var6 = var4.Length / 2
	local var7 = var4.Width / 2
	local tbl2 = {
		Front = var5.Front - var6,
		Back = var5.Back - var6,
		Left = var5.Left - var7,
		Right = var5.Right - var7,
	}

	local var8 = math.min(tbl2.Front, tbl2.Back, tbl2.Left, tbl2.Right)
	return {
		Fits = var2.MinFitMargin <= var8,
		Margins = tbl2,
		WorstMargin = var8,
		Footprint = var4,
		Reason = if var2.MinFitMargin <= var8 then "ok" else "too tight",
	}
end

tbl1.CheckSlotAgainstAllCars = function(arg1, arg2)
	local tbl2 = {}
	local num1 = math.huge
	local var1 = nil
	for k1 in pairs(var3.Cars) do
		local var2 = tbl1.CheckFit(k1, arg1, arg2)
		if not var2.Fits then
			table.insert(tbl2, k1)
		end

		if not var2.WorstMargin then
			continue
		end

		if var2.WorstMargin >= num1 then
			continue
		end

		num1 = var2.WorstMargin
		var1 = k1
	end

	return { Fits = #tbl2 == 0, Failures = tbl2, WorstMargin = num1, WorstCar = var1 }
end

return tbl1

--- ReplicatedStorage.Modules.CarHandling [ModuleScript]
-- y u r i

local var1 = require(game.ReplicatedStorage.Configs.DrivingConfig)
local var2 = require(game.ReplicatedStorage.Configs.SpeedConfig)
local var3 = require(script.Parent.WheelSpin)
return {
	Create = function(arg1)
		local var2 = arg1:FindFirstChild("Chassis")
		local var3 = var2
		assert(var3 and arg1:FindFirstChild("Wheels"), "Incomplete car rig")
		local tbl1 = { car = arg1, chassis = var2, motors = {}, servos = {}, steer = 0 }
		var3 = 0
		local bool1 = true
		if arg1:GetAttribute("ZoneSpawn") ~= true then
			bool1 = arg1:GetAttribute("RaceVehicle") == true
		end

		tbl1.arcade = bool1
		if bool1 then
			local var5 = arg1:FindFirstChild("DriveCollisionHull")
			local var6
			if not var5 then
				var5 = Instance.new("Part")
				var5.Name = "DriveCollisionHull"
				local var7 = var2:FindFirstChild("GroundAnchor")
				var6 = arg1:GetAttribute("CarWidth")
				local var8 = (var6 or var2.Size.X) * 0.96
				local var9 = arg1:GetAttribute("CarLength")
				var5.Size = Vector3.new(var8, 1.2, (var9 or var2.Size.Z) * 0.94)
				local var10 = var7 and var7.Position.Y or -var2.Size.Y / 2
				var5.CFrame = var2.CFrame * CFrame.new(0, var10 + 0.6 + (if arg1:GetAttribute("RaceVehicle") == true and arg1:GetAttribute("RaceSurfaceFollow") == true then 2 else 0), 0)
				var5.Transparency = 1
				var5.Anchored = false
				var5.Massless = true
				var5.CanCollide = true
				var5.CanTouch = false
				var5.CastShadow = false
				var5.CollisionGroup = var2.CollisionGroup
				var5.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0, 0, 100, 100)
				var5.Parent = arg1
				var8 = Instance.new("WeldConstraint")
				var6 = "HullWeld"
				var8.Name = var6
				var8.Part0 = var2
				var8.Part1 = var5
				var8.Parent = var5
			end

			if arg1:GetAttribute("RaceVehicle") == true then
				if arg1:GetAttribute("RaceSurfaceFollow") == true then
					local var13 = var2:FindFirstChild("GroundAnchor")
					var6 = "RampContactShoes"
					local var14 = var13 and var13.Position.Y or -var2.Size.Y / 2
					if not arg1:FindFirstChild(var6) then
						local var15 = Instance.new("Folder")
						var15.Name = "RampContactShoes"
						var15.Parent = arg1
						local var16 = math.min(4.5, var5.Size.X * 0.48)
						var6 = Instance.new("Part")
						var6.Name = "RoundedRoadContact"
						var6.Shape = Enum.PartType.Ball
						var6.Size = Vector3.new(1, 1, 1) * (var16 * 2)
						var6.CFrame = var2.CFrame * CFrame.new(0, var14 + var16, 0)
						var6.Transparency = 1
						var6.Anchored = false
						var6.Massless = true
						var6.CanCollide = true
						var6.CanTouch = false
						var6.CanQuery = false
						var6.CastShadow = false
						var6.CollisionGroup = var2.CollisionGroup
						var6.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0, 0, 100, 100)
						var6.Parent = var15
						local var17 = Instance.new("WeldConstraint")
						var17.Part0 = var2
						var17.Part1 = var6
						var17.Parent = var6
					end
				end
			end

			tbl1.hull = var5
			var2.CanCollide = false
			for k1, v1 in arg1.Wheels:GetChildren() do
				if not v1:IsA("BasePart") then
					continue
				end

				v1.CanCollide = false
			end
		end

		for k2, v2 in ipairs(arg1:GetDescendants()) do
			if not v2:IsA("BasePart") then
				continue
			end

			if v2.Massless then
				continue
			end

			var3 = var3 + v2:GetMass()
		end

		local var18 = var2:FindFirstChild("DriveAssistAttachment")
		var18 = var18 or Instance.new("Attachment")
		var18.Name = "DriveAssistAttachment"
		var18.Parent = var2
		if bool1 then
			local var19 = var2:FindFirstChild("DriveUpright")
			var19 = var19 or Instance.new("AlignOrientation")
			var19.Name = "DriveUpright"
			var19.Attachment0 = var18
			var19.Mode = Enum.OrientationAlignmentMode.OneAttachment
			var19.RigidityEnabled = false
			var19.Responsiveness = 80
			var19.MaxAngularVelocity = math.rad(var1.TurnRate or 360)
			var19.CFrame = var2.CFrame.Rotation
			var19.Parent = var2
			tbl1.upright = var19
			local var20 = var2:FindFirstChild("DriveDownforce")
			var20 = var20 or Instance.new("VectorForce")
			var20.Name = "DriveDownforce"
			var20.Attachment0 = var18
			var20.RelativeTo = Enum.ActuatorRelativeTo.World
			var20.ApplyAtCenterOfMass = true
			var20.Force = Vector3.new(0, 0, 0)
			var20.Parent = var2
			tbl1.down = var20
		end

		local var21 = var2:FindFirstChild("DriveAssist")
		var21 = var21 or Instance.new("LinearVelocity")
		var21.Name = "DriveAssist"
		var21.Attachment0 = var18
		var21.RelativeTo = Enum.ActuatorRelativeTo.World
		var21.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
		var21.PrimaryTangentAxis = Vector3.new(1, 0, 0)
		var21.SecondaryTangentAxis = Vector3.new(0, 0, 1)
		var21.ForceLimitsEnabled = true
		var21.ForceLimitMode = Enum.ForceLimitMode.Magnitude
		var21.MaxForce = 0
		var21.PlaneVelocity = Vector2.zero
		var21.Parent = var2
		tbl1.assist = var21
		tbl1.mass = var3
		local var22 = var2:FindFirstChild("SteeringAssist")
		var22 = var22 or Instance.new("Torque")
		var22.Name = "SteeringAssist"
		var22.Attachment0 = var18
		var22.RelativeTo = Enum.ActuatorRelativeTo.World
		var22.Torque = Vector3.new(0, 0, 0)
		var22.Parent = var2
		tbl1.yaw = var22
		local var23 = var2:FindFirstChild("SharpSteering")
		var23 = var23 or Instance.new("AngularVelocity")
		var23.Name = "SharpSteering"
		var23.Attachment0 = var18
		var23.RelativeTo = Enum.ActuatorRelativeTo.World
		var23.AngularVelocity = Vector3.new(0, 0, 0)
		var23.MaxTorque = 0
		var23.Parent = var2
		tbl1.turn = var23
		local var24 = RaycastParams.new()
		var24.FilterType = Enum.RaycastFilterType.Exclude
		var24.FilterDescendantsInstances = { arg1 }
		var24.RespectCanCollide = true
		tbl1.groundParams = var24
		tbl1.wheelbase = arg1:GetAttribute("Wheelbase") or 12
		tbl1.track = arg1:GetAttribute("Track") or 7
		local str1 = "FL"
		for k3, v3 in ipairs({ "FR", str1, "RR", "RL" }) do
			local var25 = arg1.Wheels:FindFirstChild(v3)
			local var26 = var25
			local var27 = arg1:FindFirstChild(v3 .. "_Motor", true)
			assert(var26 and (var27 and var27:IsA("HingeConstraint")), "Missing wheel motor " .. v3)
			local var28 = var25.Size.Y / 2
			var26 = if var27.Attachment0.WorldAxis:Dot(var2.CFrame.RightVector) < 0 then 1 else -1
			var27.ActuatorType = Enum.ActuatorType.Motor
			var27.MotorMaxTorque = var3 * workspace.Gravity * var28 * 0.3
			var27.MotorMaxAcceleration = var1.Braking / var28
			var27.AngularVelocity = 0
			table.insert(tbl1.motors, { hinge = var27, wheel = var25, radius = var28, sign = var26 })
		end

		local str2 = "FL"
		for k4, v4 in ipairs({ "FR", str2 }) do
			local var29 = var2:FindFirstChild(v4 .. "_Steer")
			local var30 = var29
			assert(var30 and var29:IsA("HingeConstraint"), "Missing steering joint")
			var29.ActuatorType = Enum.ActuatorType.Servo
			var29.ServoMaxTorque = var3 * workspace.Gravity * tbl1.wheelbase
			var29.AngularSpeed = var1.SteeringServoSpeed or 18
			var29.LimitsEnabled = true
			var29.LowerAngle = -42
			var29.UpperAngle = 42
			var29.TargetAngle = 0
			table.insert(tbl1.servos, { hinge = var29, side = v4 })
		end

		return tbl1
	end,
	Step = function(arg1, arg2, arg3, arg4)
		local var52
		local var4 = arg1.car
		local var5 = arg1.chassis
		if var4:GetAttribute("AutoDriving") then
			arg1.assist.Enabled = false
			arg1.yaw.Enabled = false
			arg1.turn.Enabled = false
			if arg1.upright then
				arg1.upright.Enabled = false
				arg1.down.Enabled = false
			end

			return
		end

		local str1 = "DriveSpeed"
		local var6 = tonumber(var4:GetAttribute(str1))
		local str2 = "ReverseSpeed"
		local var7 = tonumber(var4:GetAttribute(str2))
		arg4 = math.clamp(arg4, 0.0041666666666666666, 0.1)
		var6 = var6 or var1.ForwardSpeed
		var7 = var7 or var1.ReverseSpeed
		if var4:GetAttribute("RaceVehicle") then
			var6 = math.clamp(var6, 17, var2.MaxWalkSpeed)
			var7 = math.clamp(var7, 5, 105)
		else
			if var4:GetAttribute("ZoneSpawn") then
				var6 = if var6 == var6 and var6 < math.huge then math.max(0, var6) else 0
				if var7 == var7 and var7 < math.huge then
					var7 = math.max(0, var7)
				else
					var7 = 0
				end
			else
				var6 = math.clamp(var6, 10, 90)
				var7 = math.clamp(var7, 5, 40)
			end
		end

		local var8 = -var5.CFrame:VectorToObjectSpace(var5.AssemblyLinearVelocity).Z
		arg1.groundParams.CollisionGroup = var5.CollisionGroup
		str2 = var5:FindFirstChild("GroundAnchor")
		str1 = arg2 * (if 0 <= arg2 then var6 else var7)
		local var9 = if str2 then math.abs(str2.Position.Y) + 2.5 else (var4:GetAttribute("CarHeight") or 6) + 2
		local var11 = workspace:Raycast(var5.Position + Vector3.new(0, 0.5, 0), Vector3.new(0, -var9 - 0.5, 0), arg1.groundParams)
		if not (var11 and 0.45 < var11.Normal.Y) then
			var11 = nil
		end

		local bool1 = false
		if var4:GetAttribute("RaceVehicle") == true then
			bool1 = var4:GetAttribute("RaceSurfaceFollow") == true
		end

		local var12 = Vector3.new(0, 1, 0)
		local var13
		if bool1 then
			local var14 = if var11 and 0.7 < var11.Normal.Y then var11.Normal else arg1.surfaceNormal or Vector3.new(0, 1, 0)
			if var11 then
				if var11.Instance:GetAttribute("RaceRoadSurface") == true then
					local var15 = Vector3.new(var5.CFrame.LookVector.X, 0, var5.CFrame.LookVector.Z)
					local var16 = if 0.001 < var15.Magnitude then var15.Unit else Vector3.new(0, 0, -1)
					local var17 = var16 * math.max(3, arg1.wheelbase * 0.45)
					local var18 = workspace:Raycast(var5.Position + var17 + Vector3.new(0, 3, 0), Vector3.new(-0, -1, -0) * (var9 + 7), arg1.groundParams)
					local var19 = var18 and (0.7 < var18.Normal.Y and (var18.Instance:GetAttribute("RaceRoadSurface") == true and var18.Position)) or nil
					local var20 = workspace:Raycast(var5.Position + -var17 + Vector3.new(0, 3, 0), Vector3.new(-0, -1, -0) * (var9 + 7), arg1.groundParams)
					local var21 = var16:Cross(Vector3.new(0, 1, 0)) * math.max(2, arg1.track * 0.45)
					local var22 = var20 and (0.7 < var20.Normal.Y and (var20.Instance:GetAttribute("RaceRoadSurface") == true and var20.Position)) or nil
					var20 = workspace:Raycast(var5.Position + -var21 + Vector3.new(0, 3, 0), Vector3.new(-0, -1, -0) * (var9 + 7), arg1.groundParams)
					var18 = workspace:Raycast(var5.Position + var21 + Vector3.new(0, 3, 0), Vector3.new(-0, -1, -0) * (var9 + 7), arg1.groundParams)
					local var23 = var20 and (0.7 < var20.Normal.Y and (var20.Instance:GetAttribute("RaceRoadSurface") == true and var20.Position)) or nil
					var13 = var18 and (0.7 < var18.Normal.Y and (var18.Instance:GetAttribute("RaceRoadSurface") == true and var18.Position)) or nil
					var18 = (var13 - var23):Cross(var19 - var22).Unit
					local function support(arg1)
						local var1 = workspace:Raycast(var5.Position + arg1 + Vector3.new(0, 3, 0), Vector3.new(-0, -1, -0) * (var9 + 7), arg1.groundParams)
						return var1 and (0.7 < var1.Normal.Y and (var1.Instance:GetAttribute("RaceRoadSurface") == true and var1.Position)) or nil
					end

					if var19 and (var22 and (var23 and (var13 and 0.7 < var18.Y))) then
						var14 = var18
					end
				end
			end

			local var24 = (arg1.surfaceNormal or var14):Lerp(var14, 1 - math.exp(-12 * arg4)).Unit
			arg1.surfaceNormal = var24
			var12 = arg1.surfaceNormal
		end

		local var25 = arg1.assist
		local bool3 = false
		if var11 ~= nil then
			bool3 = not var5.Anchored
		end

		var25.Enabled = bool3
		var25 = Vector3.new(var5.CFrame.LookVector.X, 0, var5.CFrame.LookVector.Z)
		var25 = if 0.001 < var25.Magnitude then var25.Unit else Vector3.new(0, 0, -1)
		bool3 = var25 * arg2 + var25:Cross(Vector3.new(0, 1, 0)) * arg3
		local var26 = math.min(1, bool3.Magnitude)
		local var27 = if 0.001 < bool3.Magnitude then bool3.Unit * var6 * var26 else Vector3.new(0, 0, 0)
		str1 = var27:Dot(var25)
		local var28
		if arg1.arcade then
			if not var5.Anchored then
				support = var5.AssemblyLinearVelocity
				local var29 = str2 and str2.Position.Y or -2
				local var30 = math.max(1.2, (var4:GetAttribute("CarHeight") or 4) - 0.6)
				local var31 = var4:GetAttribute("CarWidth")
				local var32 = var4:GetAttribute("CarLength")
				var13 = (var31 or var5.Size.X) + 0.3
				local var33 = Vector3.new(var13, var30, (var32 or var5.Size.Z) + 0.3)
				local var34 = Vector3.new(support.X, 0, support.Z)
				local var35 = CFrame.lookAt(var5.Position + Vector3.new(0, var29 + 0.4 + var30 / 2, 0), var5.Position + Vector3.new(0, var29 + 0.4 + var30 / 2, 0) + var25)
				var13 = math.min(900, (math.max(8, math.max(var27.Magnitude, var34.Magnitude) * (arg4 + 0.12) + 3)))
				var31 = arg1.groundParams
				if bool1 then
					if var11 then
						if var11.Instance:GetAttribute("RaceRoadSurface") == true then
							local var36 = arg1.surfaceObstacleParams
							var36 = var36 or RaycastParams.new()
							arg1.surfaceObstacleParams = var36
							arg1.surfaceObstacleParams.FilterType = Enum.RaycastFilterType.Exclude
							arg1.surfaceObstacleParams.FilterDescendantsInstances = { var4, var11.Instance.Parent }
							arg1.surfaceObstacleParams.RespectCanCollide = true
							arg1.surfaceObstacleParams.CollisionGroup = var5.CollisionGroup
							var31 = arg1.surfaceObstacleParams
						end
					end
				end

				local function restrict(arg1)
					if arg1.Magnitude < 0.01 then
						return
					end

					local var2 = workspace:Blockcast(var35, var33, arg1.Unit * var13, var31)
					if not var2 then
						return
					end

					if bool1 and (0.7 < var2.Normal.Y and var2.Instance:GetAttribute("RaceRoadSurface") == true) then
						return
					end

					local var3 = Vector3.new(var2.Normal.X, 0, var2.Normal.Z)
					if var3.Magnitude < 0.05 then
						var27 = Vector3.new(0, 0, 0)
						var34 = Vector3.new(0, 0, 0)
						return
					end

					var3 = var3.Unit
					local var4 = math.max(0, var2.Distance - 0.7) / math.max(0.08, arg4 + 0.06)
					local var5 = var27
					local var7 = -var5:Dot(var3)
					var27 = if var4 < var7 then var5 + var3 * (var7 - var4) else var5
					var5 = var34
					var7 = -var5:Dot(var3)
					var34 = if var4 < var7 then var5 + var3 * (var7 - var4) else var5
				end

				restrict(var27)
				if 3 < var34.Magnitude then
					restrict(var34)
				end

				var32 = 12
				if bool1 and var11 then
					var32 = -var34:Dot(var12) / math.max(0.7, var12.Y) + 1.5
				end

				var5.AssemblyLinearVelocity = Vector3.new(var34.X, math.min(support.Y, var32), var34.Z)
				str1 = var27:Dot(var25)
				arg1.down.Enabled = true
				var28 = workspace.Gravity
				local var37 = arg1.down
				local num1 = 0
				local var38 = -arg1.mass * var28
				local var39 = var38 * (if var11 then 0.15 else 0.5)
				var37.Force = Vector3.new(num1, var39, 0)
			end
		end

		arg1.assist.PlaneVelocity = Vector2.new(var27.X, var27.Z)
		support = math.max(var1.Acceleration, var6 / var1.MovementResponse)
		arg1.assist.MaxForce = arg1.mass * support
		local bool4 = true
		if math.abs(arg2) >= 0.05 then
			bool4 = var8 * arg2 < -1
		end

		for k1, v1 in ipairs(arg1.motors) do
			if arg1.arcade then
				local var40 = var5:GetVelocityAtPosition(v1.wheel.Position):Dot(var25)
				v1.hinge.MotorMaxAcceleration = 60
				restrict = v1.hinge
				local var41 = var3.AngularSpeed
				restrict.AngularVelocity = var41(if var11 then var40 else 0, v1.radius) * v1.sign
			else
				local var42 = v1.hinge
				var42.MotorMaxAcceleration = (if bool4 then math.max(var1.Braking, support) else support) / v1.radius
				v1.hinge.AngularVelocity = str1 / v1.radius * v1.sign
			end
		end

		arg1.steer = math.clamp(arg3, -1, 1)
		local var43 = math.rad(var1.TurnRate or 360)
		local var44 = if 0.05 < var27.Magnitude then var27.Unit else var25
		local var46 = math.atan2(var25:Cross(var44).Y, (var25:Dot(var44)))
		restrict = arg1.assist.Enabled
		local var47 = if var11 and (not var5.Anchored) then math.clamp(var46 * var1.TurnResponse, -var43, var43) else 0
		local var48 = math.clamp(-var46, -math.rad(var1.SteeringAngle), (math.rad(var1.SteeringAngle)))
		arg1.yaw.Enabled = restrict and (not arg1.arcade)
		restrict = arg1.assist.Enabled
		arg1.turn.Enabled = restrict and (not arg1.arcade)
		if arg1.arcade then
			arg1.upright.Enabled = not var5.Anchored
			arg1.upright.MaxTorque = arg1.mass * workspace.Gravity * arg1.wheelbase * 80
			arg1.upright.MaxAngularVelocity = math.clamp(math.max(math.abs(var47), math.acos((math.clamp(var5.CFrame.UpVector:Dot(var12), -1, 1))) * 12, 0.05), 0.05, var43)
			if bool1 then
				arg1.upright.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), (var44 - var12 * var44:Dot(var12)).Unit, var12)
			else
				arg1.upright.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), var44)
			end

			if var5.Anchored then
				arg1.down.Enabled = false
			end
		end

		arg1.turn.MaxTorque = arg1.mass * workspace.Gravity * arg1.wheelbase * 200
		arg1.turn.AngularVelocity = Vector3.new(0, var47, 0)
		restrict = arg1.mass * (arg1.wheelbase ^ 2 + arg1.track ^ 2) / 12
		local var49 = var5.AssemblyAngularVelocity
		arg1.yaw.Torque = var5.CFrame.UpVector:Cross(Vector3.new(0, 1, 0)) * restrict * 70 - Vector3.new(var49.X, 0, var49.Z) * restrict * 12
		for k2, v2 in ipairs(arg1.servos) do
			local var50 = -var48
			local num2 = 0
			if 0.001 < math.abs(var50) then
				local var51 = arg1.wheelbase / math.tan((math.abs(var50)))
				if 0 < var50 then
					local bool7 = true
					if v2.side ~= "FL" then
						bool7 = false
						if var50 < 0 then
							bool7 = v2.side == "FR"
						end
					end
				end

				local num3 = 1
				local var53 = math.atan(arg1.wheelbase / math.max(num3, var51 + (if var52 then -arg1.track / 2 else arg1.track / 2)))
				num3 = math.deg(var53)
				num2 = num3 * math.sign(var50)
			end

			v2.hinge.TargetAngle = math.clamp(num2, v2.hinge.LowerAngle, v2.hinge.UpperAngle)
		end
	end,
}

--- ReplicatedStorage.Modules.CarAssets [ModuleScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("CollectionService")
local var3 = require(var1.Configs.CarConfig)
local var4 = require(var1.Modules.CarBillboard)
local tbl1 = {
	ParkedTag = "ParkedCar",
	GetId = function(arg1)
		if typeof(arg1) == "Instance" then
			local var1 = arg1:GetAttribute("CarId")
			arg1 = var1 or (arg1:GetAttribute("SourceCar") or arg1.Name)
		end

		local str1 = "^%s*(.-)%s*$"
		return tostring(arg1):match(str1)
	end,
}

local function find(arg1, arg2, arg3)
	if not arg1 then
		return nil
	end

	arg2 = tbl1.GetId(arg2)
	for k1, v1 in ipairs(arg1:GetChildren()) do
		if not v1:IsA(arg3) then
			continue
		end

		if tbl1.GetId(v1) ~= arg2 then
			continue
		end

		return v1
	end

	return nil
end

tbl1.GetPlotTemplate = function(arg1)
	local var4 = find(var1.Assets:FindFirstChild("PlotCars"), arg1, "Model")
	if var4 then
		return var4
	end

	local var5 = workspace:FindFirstChild(var3.PlotTemplateFolder)
	local var6 = game:GetService("ServerStorage")
	local var7 = var6:FindFirstChild("OtherStuff")
	return (find(var5 or game:GetService("RunService"):IsServer() and var7:FindFirstChild(var3.PlotTemplateFolder), arg1, "Model"))
end

tbl1.GetDrivingTemplate = function(arg1)
	return (find(var1.Assets:FindFirstChild(var3.DrivingTemplateFolder), arg1, "Model"))
end

tbl1.GetHeldTemplate = function(arg1)
	return (find(var1.Assets:FindFirstChild(var3.HeldTemplateFolder), arg1, "Tool"))
end

local function clone(arg1, arg2)
	if not arg1 then
		return nil
	end

	local var1 = arg1:Clone()
	var1.Name = tbl1.GetId(arg1)
	var1:SetAttribute("CarId", var1.Name)
	local var2 = var3.Get(var1.Name)
	var1:SetAttribute("Tier", var2.Tier)
	var1:SetAttribute("Rarity", var2.Rarity)
	var1:SetAttribute("CashPerSecond", var2.CashPerSecond)
	local var4 = var1.Name
	var1:SetAttribute("SellPrice", var3.GetSellPrice(var4))
	var1:SetAttribute("CarRepresentation", arg2)
	var1:SetAttribute("TemplateSource", arg1:GetFullName())
	return var1
end

local function secureRevueltoPanels(arg1)
	if tbl1.GetId(arg1) ~= "Revuelto" then
		return
	end

	local str1 = "CarbonTrim"
	local var1 = assert(arg1:FindFirstChild("Chassis"), "Revuelto missing chassis")
	local var2 = assert(arg1:FindFirstChild("Body"), "Revuelto missing body")
	for k1, v1 in ipairs({ "BodyShell", str1, "Windows" }) do
		local var3 = assert(var2:FindFirstChild(v1), "Revuelto missing " .. v1)
		local var5 = var3:FindFirstChild("AssemblyWeld")
		local var6 = var1.CFrame:ToObjectSpace(var3.CFrame)
		if var5 then
			var5:Destroy()
		end

		local var7 = Instance.new("Weld")
		var7.Name = "AssemblyWeld"
		var7.C0 = var6
		var7.C1 = CFrame.identity
		var7.Part0 = var1
		var7.Part1 = var3
		var7.Enabled = true
		var7.Parent = var3
	end

	arg1:SetAttribute("BodyWeldRepairVersion", 2)
end

tbl1.CloneDriving = function(arg1)
	local var2 = clone(tbl1.GetDrivingTemplate(arg1), "Driving")
	if var2 then
		secureRevueltoPanels(var2)
	end

	return var2
end

tbl1.CloneHeld = function(arg1)
	local var5 = clone(tbl1.GetHeldTemplate(arg1), "Held")
	if var5 then
		local var6 = arg1
		local var7 = var3.Get(tbl1.GetId(var6)).Image
		var7 = var7 or var5.TextureId
		var5.TextureId = var7
		local var8 = arg1
		var4.Attach(var5, tbl1.GetId(var8))
	end

	return var5
end

local function chassisFrame(arg1, arg2)
	if arg1:GetAttribute("CanonicalPlotFrame") and arg1.PrimaryPart then
		return arg1.PrimaryPart.CFrame
	end

	local var3 = arg2:FindFirstChild("Body")
	local var4 = arg2:FindFirstChild("Chassis")
	local num1 = -1
	local var5 = nil
	if not var3 or (not var4) then
		return nil
	end

	for k1, v1 in ipairs(arg1:GetDescendants()) do
		if not v1:IsA("MeshPart") then
			continue
		end

		local var6 = v1.Size.X * v1.Size.Y * v1.Size.Z
		if num1 >= var6 then
			continue
		end

		for k2, v2 in ipairs(var3:GetDescendants()) do
			if not v2:IsA("MeshPart") then
				continue
			end

			if v2.MeshId ~= v1.MeshId then
				continue
			end

			if (v2.Size - v1.Size).Magnitude >= 0.02 then
				continue
			end

			var5 = v1.CFrame * v2.CFrame:ToObjectSpace(var4.CFrame)
			break
		end
	end

	return var5
end

tbl1.ClonePlot = function(arg1)
	local var5 = tbl1.GetPlotTemplate(arg1)
	local var6 = tbl1.GetDrivingTemplate(arg1)
	if not var5 or (not var6) then
		return nil
	end

	local var7 = clone(var5, "Plot")
	local var9 = chassisFrame(var7, var6)
	if not var9 then
		var7:Destroy()
		warn("[CarAssets] Cannot align plot model for", arg1)
		return nil
	end

	for k1, v1 in ipairs(var7:GetDescendants()) do
		if v1:IsA("BasePart") then
			v1.Anchored = true
			v1.CanCollide = false
			v1.CanTouch = false
		else
			if not v1:IsA("LuaSourceContainer") then
				continue
			end

			v1:Destroy()
		end
	end

	local var10 = var7
	for k2, v2 in ipairs(var2:GetTags(var10)) do
		var2:RemoveTag(var7, v2)
	end

	local var11 = Instance.new("Part")
	var11.Name = "DisplayRoot"
	local var12 = var6.Chassis
	var11.Size = var12.Size
	var11.CFrame = var9
	var11.Transparency = 1
	var11.Anchored = true
	var11.CanCollide = false
	var11.CanTouch = false
	var11.CastShadow = false
	var11.Parent = var7
	local var14 = var12:FindFirstChild("GroundAnchor")
	if var14 then
		var14:Clone().Parent = var11
	end

	var7.PrimaryPart = var11
	local str1 = "CarLength"
	for k3, v3 in ipairs({ "CarWidth", str1, "CarHeight" }) do
		local var15 = v3
		var7:SetAttribute(v3, var6:GetAttribute(var15))
	end

	local var16 = Instance.new("Part")
	var16.Name = "EntryZone"
	var16.Size = var6.EntryZone.Size
	var16.CFrame = var9 * var12.CFrame:ToObjectSpace(var6.EntryZone.CFrame)
	var16.Transparency = 1
	var16.Anchored = true
	var16.CanCollide = false
	var16.CanQuery = false
	var16.CanTouch = true
	var16.CastShadow = false
	var16.Parent = var7
	local var17 = Instance.new("ClickDetector")
	var17.Name = "EnterCar"
	var17.MaxActivationDistance = var6.EnterCar.MaxActivationDistance
	var17.Parent = var7
	local var18 = arg1
	var4.Attach(var7, tbl1.GetId(var18))
	var2:AddTag(var7, tbl1.ParkedTag)
	return var7
end

return tbl1

--- ReplicatedStorage.Modules.CarBillboard [ModuleScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("CollectionService")
local var3 = require(var1.Configs.CarConfig)
local var4 = require(var1.Modules.NumberFormatter)
local var5 = var1:WaitForChild("Assets"):WaitForChild("Billboards"):WaitForChild("CarBillboard")
local function label(arg1, arg2)
	for k1, v1 in ipairs(arg1:GetChildren()) do
		if not v1:IsA("TextLabel") then
			continue
		end

		if v1.Name:lower() ~= arg2 then
			continue
		end

		return v1
	end
end

local tbl1 = { AnimationTag = "CarRarityGradient" }
tbl1.Attach = function(arg1, arg2)
	local var6 = arg1:IsA("Tool")
	local var8 = if var6 then arg1:FindFirstChild("Handle") else arg1.PrimaryPart
	if not var8 then
		return nil
	end

	local var10 = arg1:FindFirstChild("CarBillboard")
	if var10 then
		var10:Destroy()
	end

	local var11 = var5:Clone()
	local var13 = var11:FindFirstChildWhichIsA("BillboardGui")
	if var13 and var6 then
		var13.Size = UDim2.fromScale(4.05, 2.4)
	end

	local var14 = var13
	var14 = var14 and var13:FindFirstChild("root")
	local var15 = var14
	local var16 = var14
	local var17 = var14
	var15 = var15 and label(var14, "cash")
	var16 = var16 and label(var14, "rarity")
	var17 = var17 and label(var14, "name")
	if not var15 or (not var16 or (not var17)) then
		var11:Destroy()
		warn("[CarBillboard] Template is missing root/Cash, Rarity, or Name")
		return nil
	end

	local var18 = var3.Get(arg2)
	local var19 = var3.GetRarity(arg2)
	local var20 = var18.GradientStyle or var19
	local var21 = var3.GetCashPerSecond(arg2)
	local var23 = var3.GetRarityInfo(var20)
	local var24 = nil
	var15.Text = "$" .. (if math.abs(var21) < 1000 and var21 % 1 ~= 0 then string.format("%.2f", var21):gsub("0+$", ""):gsub("%.$", "") else var4.Format(var21)) .. "/s"
	var16.Text = var19
	var16.TextColor3 = Color3.new(1, 1, 1)
	var16.TextStrokeTransparency = 1
	var17.Text = var18.DisplayName or arg2
	var17.TextColor3 = Color3.new(1, 1, 1)
	local var25 = var17:FindFirstChildWhichIsA("UIGradient")
	if var20 == "FuseBat" then
		local var26 = var25
		var25 = var26 or Instance.new("UIGradient")
		var25.Color = var23.Gradient
		var25.Enabled = true
		var25:SetAttribute("GradientStyle", "FuseBat")
		var25.Parent = var17
		var2:AddTag(var25, tbl1.AnimationTag)
	elseif var25 then
		var25.Enabled = false
	end

	local var27 = var16:FindFirstChildWhichIsA("UIGradient")
	var27 = var27 or Instance.new("UIGradient")
	var27.Name = "UIGradient"
	var27:SetAttribute("GradientStyle", var20)
	var27.Color = var23.Gradient
	var27.Transparency = NumberSequence.new(0)
	var27.Offset = Vector2.zero
	var27.Rotation = 0
	var27.Enabled = true
	var27.Parent = var16
	var2:RemoveTag(var27, tbl1.AnimationTag)
	if var23.Animated then
		var2:AddTag(var27, tbl1.AnimationTag)
	end

	local num1 = -math.huge
	local num2 = math.huge
	local num3 = -math.huge
	for k1, v1 in ipairs(arg1:GetDescendants()) do
		if not v1:IsA("BasePart") then
			continue
		end

		if v1.Transparency >= 1 then
			continue
		end

		local num4 = 1
		local var28 = var8.CFrame:ToObjectSpace(v1.CFrame)
		local var29 = v1.Size / 2
		for k2, v2 in ipairs({ -1, num4 }) do
			local num5 = 1
			for k3, v3 in ipairs({ -1, num5 }) do
				local num6 = 1
				for k4, v4 in ipairs({ -1, num6 }) do
					local var30 = var28:PointToWorldSpace((Vector3.new(v2 * var29.X, v3 * var29.Y, v4 * var29.Z)))
					num1 = math.max(num1, var30.Y)
					num2 = math.min(num2, var30.Z)
					num3 = math.max(num3, var30.Z)
				end
			end
		end
	end

	if num1 == -math.huge then
		num1 = var8.Size.Y / 2
		num2 = -var8.Size.Z / 2
		num3 = var8.Size.Z / 2
	end

	var11.Name = "CarBillboard"
	var11.CFrame = var8.CFrame * CFrame.new(0, num1 + var13.Size.Y.Scale / 2 + 0.5, num2 + (num3 - num2) * 0.15)
	var11.Transparency = 1
	var11.Anchored = var8.Anchored
	var11.CanCollide = false
	var11.CanTouch = false
	var11.CanQuery = false
	var11.Massless = true
	var11.CastShadow = false
	local var31 = Instance.new("WeldConstraint")
	var31.Name = "BillboardWeld"
	var31.Part0 = var8
	var31.Part1 = var11
	var31.Parent = var11
	var13.Adornee = var11
	var13.Enabled = true
	var13.MaxDistance = if var6 then 50 else 150
	var13.AlwaysOnTop = var6
	var13.LightInfluence = 0
	var13.StudsOffset = Vector3.new(0, 0, 0)
	var13.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
	var11:SetAttribute("CarId", arg2)
	var11:SetAttribute("Rarity", var19)
	var11:SetAttribute("CashPerSecond", var21)
	var11.Parent = arg1
	if var6 then
		local var33 = arg1.AncestryChanged:Connect(function()
			local var2 = arg1.Parent
			local var3 = var13
			local bool2 = false
			if var2 ~= nil then
				bool2 = var2:IsA("Model")
				if bool2 then
					bool2 = var2:FindFirstChildOfClass("Humanoid") ~= nil
				end
			end

			var3.Enabled = bool2
		end)

		arg1.Destroying:Once(function()
			var33:Disconnect()
		end)

		local var35 = arg1.Parent
		local bool2 = false
		if var35 ~= nil then
			bool2 = var35:IsA("Model")
			if bool2 then
				bool2 = var35:FindFirstChildOfClass("Humanoid") ~= nil
			end
		end

		var13.Enabled = bool2
	end

	return var11
end

return tbl1

--- ReplicatedStorage.Modules.ZoneRegions [ModuleScript]
-- y u r i

local tbl1 = { Contains = function(arg1, arg2)
	local var1 = arg1.CFrame:PointToObjectSpace(arg2)
	local var2 = arg1.Size / 2
	local bool2 = false
	if math.abs(var1.X) <= var2.X then
		bool2 = false
		if math.abs(var1.Y) <= var2.Y then
			bool2 = math.abs(var1.Z) <= var2.Z
		end
	end

	return bool2
end }

tbl1.Get = function(arg1)
	local var2 = workspace:FindFirstChild("ZoneParts")
	if not var2 then
		return nil
	end

	local var4 = var2:FindFirstChild("Safe")
	if var4 and (var4:IsA("BasePart") and tbl1.Contains(var4, arg1)) then
		return 0
	end

	local var5 = nil
	for k1, v1 in ipairs(var2:GetChildren()) do
		local var6 = tonumber(v1.Name)
		if not var6 then
			continue
		end

		if not v1:IsA("BasePart") then
			continue
		end

		if not tbl1.Contains(v1, arg1) then
			continue
		end

		var5 = math.max(var5 or var6, var6)
	end

	return var5
end

return tbl1

--- ReplicatedStorage.Modules.ConfettiEffect [ModuleScript]
-- y u r i

local num1 = 255
local num2 = 145
local num3 = 220
local var1 = require(game.ReplicatedStorage.Configs.ZoneConfig)
local var2 = game:GetService("UserInputService")
local tbl1 = {}
local function getEffect(arg1)
	local var2 = tbl1[arg1]
	if var2 then
		return var2
	end

	arg1.Active = false
	arg1.BackgroundTransparency = 1
	arg1.ClipsDescendants = true
	local var3 = math.max(arg1.ZIndex, 50)
	arg1.ZIndex = var3
	var2 = { frame = arg1, particles = {} }
	tbl1[arg1] = var2
	arg1.Destroying:Connect(function()
		var2.destroyed = true
		local var1 = var2
		if var1.connection then
			var1.connection:Disconnect()
			var1.connection = nil
		end

		for k1, v1 in ipairs(var1.particles) do
			v1.ui.Visible = false
		end

		if var1.frame.Parent then
			var1.frame.Visible = false
		end

		tbl1[arg1] = nil
	end)

	return var2
end

local function getParticle(arg1, arg2)
	local var2 = arg1.particles[arg2]
	if var2 then
		return var2
	end

	local var3 = Instance.new("Frame")
	var3.Name = "ConfettiPiece"
	var3.Visible = false
	var3.AnchorPoint = Vector2.new(0.5, 0.5)
	var3.BorderSizePixel = 0
	var3.Active = false
	var3.ZIndex = arg1.frame.ZIndex + 1
	var3.Parent = arg1.frame
	var2 = { ui = var3 }
	arg1.particles[arg2] = var2
	return var2
end

local var3 = game:GetService("RunService")
local var4 = require(game.ReplicatedStorage.Modules.OtherSounds)
local tbl2 = {
	Color3.fromRGB(255, 95, 120),
	Color3.fromRGB(255, 215, 75),
	Color3.fromRGB(100, 240, 160),
	Color3.fromRGB(90, 200, 255),
	Color3.fromRGB(185, 125, 255),
	Color3.fromRGB(num1, num2, num3),
}

local var5 = Random.new()
return {
	Prepare = function(arg1, arg2)
		local var4 = arg2 == "Finish"
		if not var1.ConfettiEnabled or (not arg1 or (not arg1:IsA("Frame"))) then
			return
		end

		local var5 = getEffect(arg1)
		if not var5.preparing then
			local var6 = #var5.particles
			local var7 = math.clamp(if var4 then var1.FinishConfettiParticleCount or 256 else var1.ConfettiParticleCount or 192, 12, 256)
			local var8 = if var4 then var1.FinishConfettiMobileCount or 128 else 96
			if (if var2.TouchEnabled then math.min(var7, var8) else var7) <= var6 then
				return
			end
		end

		var5.preparing = true
		task.spawn(function()
			local var7 = var4
			local num1 = 1
			local var8 = math.clamp(if var7 then var1.FinishConfettiParticleCount or 256 else var1.ConfettiParticleCount or 192, 12, 256)
			local var9 = if var7 then var1.FinishConfettiMobileCount or 128 else 96
			for i1 = num1, if var2.TouchEnabled then math.min(var8, var9) else var8 do
				if var5.destroyed then
					break
				end

				if var5.connection then
					break
				end

				getParticle(var5, i1)
				if i1 % 8 ~= 0 then
					continue
				end

				var3.Heartbeat:Wait()
			end

			var5.preparing = false
		end)
	end,
	Play = function(arg1, arg2)
		local var6 = arg2 == "Finish"
		if not var1.ConfettiEnabled or (not arg1 or (not arg1:IsA("Frame"))) then
			return false
		end

		local var7 = getEffect(arg1)
		if var7.connection then
			var7.connection:Disconnect()
			var7.connection = nil
		end

		for k1, v1 in ipairs(var7.particles) do
			v1.ui.Visible = false
		end

		if var7.frame.Parent then
			var7.frame.Visible = false
		end

		local var8 = arg1.AbsoluteSize
		if var8.X < 1 or var8.Y < 1 then
			return false
		end

		local var9 = math.clamp(if var6 then var1.FinishConfettiParticleCount or 256 else var1.ConfettiParticleCount or 192, 12, 256)
		local var10 = if var6 then var1.FinishConfettiMobileCount or 128 else 96
		local var11 = if var2.TouchEnabled then math.min(var9, var10) else var9
		var9 = if var6 then var1.FinishConfettiDuration or 6 else var1.ConfettiDuration or 3.8
		local var12 = math.clamp(var8.Y / 850, 0.7, 1.4)
		var10 = if var6 then var9 - 2.1 else 0
		local function launch(arg1, arg2, arg3)
			arg1.birth = arg3
			arg1.dead = false
			local var2 = if arg2 % 2 == 0 then 1 else -1
			local var3 = var8.X
			arg1.x = var3 * (if var2 == 1 then 0.08 else 0.92)
			arg1.y = var8.Y * var5:NextNumber(0.82, 1.02)
			arg1.vx = var2 * var8.X * var5:NextNumber(0.22, 0.55)
			arg1.vy = -var8.Y * var5:NextNumber(1, 1.5)
			arg1.gravity = var8.Y * 0.9
			arg1.delay = math.floor((arg2 - 1) / (var11 / 3)) * 0.22
			if arg2 % 3 == 0 then
				arg1.x = var8.X * var5:NextNumber(0.04, 0.96)
				arg1.y = -var8.Y * var5:NextNumber(0.02, 0.35)
				arg1.vx = var8.X * var5:NextNumber(-0.08, 0.08)
				arg1.vy = var8.Y * var5:NextNumber(0.04, 0.12)
				arg1.gravity = var8.Y * 0.25
			end

			arg1.phase = var5:NextNumber(0, 6.2831853071795862)
			arg1.spin = var5:NextNumber(-300, 300)
			arg1.rotation = var5:NextNumber(0, 360)
			arg1.width = var5:NextInteger(6, 11) * var12
			arg1.height = var5:NextInteger(10, 18) * var12
			local var4 = arg1.ui
			var4.BackgroundColor3 = tbl2[(arg2 - 1) % #tbl2 + 1]
			var4.BackgroundTransparency = 0
			var4.Size = UDim2.fromOffset(arg1.width, arg1.height)
			var4.Position = UDim2.fromOffset(arg1.x, arg1.y)
			var4.Visible = arg1.delay == 0
		end

		for i1 = 1, var11 do
			launch(getParticle(var7, i1), i1, 0)
		end

		var7.elapsed = 0
		arg1.Visible = true
		var4.Play("Confetti")
		var7.connection = var3.RenderStepped:Connect(function(arg1)
			local var1 = var7
			local var2 = var1.elapsed + arg1
			var1.elapsed = var2
			if arg1:IsDescendantOf(game) then
				if var9 <= var7.elapsed then
					var1 = var7
					if var1.connection then
						var1.connection:Disconnect()
						var1.connection = nil
					end

					for k1, v1 in ipairs(var1.particles) do
						v1.ui.Visible = false
					end

					if var1.frame.Parent then
						var1.frame.Visible = false
					end

					return
				end
			end

			var1 = math.clamp((var7.elapsed - (var9 - 0.8)) / 0.8, 0, 1)
			for i1 = 1, var11 do
				local var3 = var7.particles[i1]
				if var3.dead then
					continue
				end

				local var4 = var7.elapsed - var3.birth - var3.delay
				if var4 < 0 then
					continue
				end

				local var12 = var3.y + var3.vy * var4 + 0.5 * var3.gravity * var4 * var4
				local var13 = var3.x + var3.vx * var4 + math.sin(var4 * 7 + var3.phase) * var8.X * 0.008
				if var8.Y + 24 < var12 then
					if 0 < var3.vy + var3.gravity * var4 then
						if var6 and var7.elapsed < var10 then
							launch(var3, i1, var7.elapsed)
						else
							var3.dead = true
							if not var3.ui.Visible then
								continue
							end

							var3.ui.Visible = false
							continue
						end
					else
						local bool2 = false
						if -24 <= var13 then
							bool2 = false
							if var13 <= var8.X + 24 then
								bool2 = false
								if -24 <= var12 then
									bool2 = var12 <= var8.Y + 24
								end
							end
						end

						if var3.ui.Visible ~= bool2 then
							var3.ui.Visible = bool2
						end

						if not bool2 then
							continue
						end

						var3.ui.Position = UDim2.fromOffset(var13, var12)
						var3.ui.Rotation = var3.rotation + var3.spin * var4
						if 0 >= var1 then
							continue
						end

						var3.ui.BackgroundTransparency = var1
					end
				else
					local bool4 = false
					if -24 <= var13 then
						bool4 = false
						if var13 <= var8.X + 24 then
							bool4 = false
							if -24 <= var12 then
								bool4 = var12 <= var8.Y + 24
							end
						end
					end

					if var3.ui.Visible ~= bool4 then
						var3.ui.Visible = bool4
					end

					if not bool4 then
						continue
					end

					var3.ui.Position = UDim2.fromOffset(var13, var12)
					var3.ui.Rotation = var3.rotation + var3.spin * var4
					if 0 >= var1 then
						continue
					end

					var3.ui.BackgroundTransparency = var1
				end
			end
		end)

		return true
	end,
	Stop = function(arg1)
		local var2 = tbl1[arg1]
		if var2 then
			if var2.connection then
				var2.connection:Disconnect()
				var2.connection = nil
			end

			for k1, v1 in ipairs(var2.particles) do
				v1.ui.Visible = false
			end

			if var2.frame.Parent then
				var2.frame.Visible = false
			end
		end
	end,
}

--- ReplicatedStorage.Modules.ShopRegions [ModuleScript]
-- y u r i

local function child(arg1, arg2)
	if not arg1 then
		return nil
	end

	for k1, v1 in arg1:GetChildren() do
		if v1.Name:lower() ~= arg2:lower() then
			continue
		end

		return v1
	end
end

local tbl1 = { Get = function(arg1)
	local var3 = child(workspace, "lobby")
	if arg1 == "FreeGift" then
		local var4 = var3
		local str2 = "daily rewards"
		return child(var4, str2)
	end

	local var5 = child(var3, "shops")
	local var6 = arg1
	return child(var5, var6)
end }

tbl1.Part = function(arg1)
	local var1 = tbl1.Get(arg1)
	local str1 = "touchpart"
	return child(var1, str1)
end

tbl1.Contains = function(arg1, arg2, arg3)
	if not arg1 or (not arg1:IsA("BasePart")) then
		return false
	end

	local var2 = arg1.CFrame:PointToObjectSpace(arg2)
	local var3 = arg1.Size * 0.5
	local var4 = arg3 or 0
	if arg1:IsA("Part") then
		if arg1.Shape == Enum.PartType.Cylinder then
			local bool1 = false
			if math.abs(var2.X) <= var3.X + var4 then
				bool1 = (var2.Y / (var3.Y + var4)) ^ 2 + (var2.Z / (var3.Z + var4)) ^ 2 <= 1
			end

			return bool1
		end
	end

	local bool3 = false
	if math.abs(var2.X) <= var3.X + var4 then
		bool3 = false
		if math.abs(var2.Y) <= var3.Y + var4 then
			bool3 = math.abs(var2.Z) <= var3.Z + var4
		end
	end

	return bool3
end

tbl1.PlayerInside = function(arg1, arg2, arg3)
	local var1 = arg1.Character
	local var2 = var1
	local var3 = var1
	var2 = var2 and var1:FindFirstChild("HumanoidRootPart")
	local var5 = var2
	var3 = var3 and var1:FindFirstChildOfClass("Humanoid")
	if var5 then
		var5 = var3
		if var5 then
			var5 = false
			if 0 < var3.Health then
				var5 = not var3.SeatPart
				var5 = var5 and (not var1:GetAttribute("Ragdolled") and tbl1.Contains(tbl1.Part(arg2), var2.Position, arg3))
			end
		end
	end

	return var5
end

return tbl1

--- ReplicatedStorage.Modules.UIEffects [ModuleScript]
-- y u r i

local var1 = game:GetService("SoundService")
local tbl1 = {}
local var2 = game:GetService("TweenService")
local var3 = game:GetService("UserInputService")
local var4 = game:GetService("Lighting")
local var5 = setmetatable({}, { __mode = "k" })
local var6 = setmetatable({}, { __mode = "k" })
local var7 = setmetatable({}, { __mode = "k" })
local var8 = setmetatable({}, { __mode = "k" })
local num1 = 0
local var9 = nil
local tbl2 = {
	Play = function(arg1, arg2)
		if arg1 ~= "Open" then
			if arg1 == "Close" then
				if typeof(arg2) ~= "Instance" then
					return
				end

				local var3 = if arg2:IsA("ScreenGui") then arg2 else arg2:FindFirstAncestorOfClass("ScreenGui")
				if not var3 or var3.Name ~= "Main" then
					return
				end
			end
		end

		local var4 = var1:FindFirstChild("UI")
		local var5 = var4
		var5 = var5 and var4:FindFirstChild(arg1)
		if not var5 or (not var5:IsA("Sound")) then
			return
		end

		local var6 = os.clock()
		if var6 - (tbl1[arg1] or 0) < 0.04 then
			return
		end

		tbl1[arg1] = var6
		var5.TimePosition = 0
		var1:PlayLocalSound(var5)
	end,
	FreezeText = function()
		return function()
		end
	end,
	IsWindowOpen = function(arg1)
		local var2 = var5[arg1]
		if var2 then
			return var2.open
		end

		return arg1.Visible
	end,
}

local function refreshBlur()
	local var3 = var4:FindFirstChild("ShopBlur")
	if not var3 then
		var3 = Instance.new("BlurEffect")
		var3.Name = "ShopBlur"
		var3.Size = 0
		var3.Enabled = false
		var3.Parent = var4
	end

	local var5 = num1 + 1
	num1 = var5
	var5 = num1
	local var7 = next(var6) ~= nil
	if var9 then
		var9:Cancel()
	end

	var3.Enabled = true
	local var8 = if var7 then 0.18 else 0.14
	local var10 = var2
	local var11 = var3
	local var12 = TweenInfo.new(var8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	var9 = var10:Create(var11, var12, { Size = if var7 then 18 else 0 })
	var9:Play()
	if not var7 then
		task.delay(var8, function()
			if var5 == num1 then
				var3.Enabled = false
			end
		end)

	end
end

tbl2.SetWindow = function(arg1, arg2)
	if arg2 and (arg1.Parent and arg1.Parent.Name == "Main") then
		for k1, v1 in arg1.Parent:GetChildren() do
			if v1 == arg1 then
				continue
			end

			if not v1:IsA("GuiObject") then
				continue
			end

			if (v1.Name == "Shop" or (v1.Name == "Index" or (v1.Name == "Sell" or (v1.Name == "Trails" or v1.Name == "Fuse")))) and tbl2.IsWindowOpen(v1) then
				tbl2.SetWindow(v1, false)
			end
		end
	end

	arg1:SetAttribute("WindowEffectsManaged", true)
	local var3 = var5[arg1]
	if not var3 then
		local var4 = Instance.new("UIScale")
		var4.Name = "UIWindowScale"
		var4.Scale = 0.8
		var4.Parent = arg1
		var3 = { open = false, scale = var4, revision = 0 }
		var5[arg1] = var3
		arg1.Destroying:Once(function()
			if var3.tween then
				var3.tween:Cancel()
			end

			var6[arg1] = nil
			var5[arg1] = nil
			refreshBlur()
		end)

	end

	if var3.open == arg2 then
		return
	end

	var3.open = arg2
	local var7 = var3.revision + 1
	var3.revision = var7
	var7 = var3.revision
	if var3.tween then
		var3.tween:Cancel()
	end

	if var3.restore then
		var3.restore()
		var3.restore = nil
	end

	if arg2 then
		var6[arg1] = true
		if not arg1.Visible then
			var3.scale.Scale = 0.8
		end

		arg1.Visible = true
	else
		var6[arg1] = nil
		tbl2.Reset(arg1)
	end

	local var8 = tbl2.Play
	var8(if arg2 then "Open" else "Close", arg1)
	refreshBlur()
	var3.restore = tbl2.FreezeText(arg1, var3.scale.Scale)
	var8 = if arg2 then 0.18 else 0.14
	local var9 = var2
	local var10 = var3.scale
	local var11 = TweenInfo.new(var8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	var3.tween = var9:Create(var10, var11, { Scale = if arg2 then 1 else 0.8 })
	var3.tween:Play()
	task.delay(var8, function()
		if var3.revision ~= var7 or (not arg1.Parent) then
			return
		end

		if not var3.open then
			arg1.Visible = false
		end

		if var3.restore then
			var3.restore()
			var3.restore = nil
		end
	end)
end

tbl2.Reset = function(arg1)
	for k1, v1 in pairs(var8) do
		if k1 == arg1 or k1:IsDescendantOf(arg1) then
			table.clear(v1.hovered)
			if v1.tween then
				v1.tween:Cancel()
				v1.tween = nil
			end

			v1.scale.Scale = v1.base
			if not v1.restore then
				continue
			end

			v1.restore()
			v1.restore = nil
		end
	end
end

tbl2.BindButton = function(arg1)
	if var7[arg1] or (not arg1:IsA("GuiButton") or (not arg1.Parent or arg1:GetAttribute("UIEffectsIgnore"))) then
		return
	end

	local var1 = arg1.Parent
	while var1 do
		if var1:IsA("BillboardGui") or var1:IsA("SurfaceGui") then
			return
		end

		var1 = var1.Parent
	end

	local var4 = if arg1:GetAttribute("UIEffectsScaleSelf") then arg1 else arg1.Parent
	if not var4:IsA("GuiObject") then
		var4 = arg1
	end

	local var6 = var8[var4]
	if not var6 then
		local var9 = var4:FindFirstChild("UIHoverScale")
		var9 = var9 or Instance.new("UIScale")
		var9.Name = "UIHoverScale"
		var9.Scale = 1
		var9.Parent = var4
		var6 = { scale = var9, hovered = {}, base = var9.Scale }
		var8[var4] = var6
	end

	local tbl1 = {}
	var7[arg1] = tbl1
	local function animate(arg1, arg2)
		local var1 = var6.hovered
		local var3 = arg1
		var1[var3] = if arg1 then true else nil
		var1 = next(var6.hovered) ~= nil
		if var1 and (not var6.restore) then
			var6.restore = tbl2.FreezeText(var4)
		end

		if var6.tween then
			var6.tween:Cancel()
		end

		var3 = var6
		local var5 = var2
		local var7 = var6.scale
		local var8 = TweenInfo.new(arg2 or 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local var9 = var6.base
		var3.tween = var5:Create(var7, var8, { Scale = var9 * (if var1 then 1.05 else 1) })
		var3 = var6.tween
		var3:Play()
		if not var1 then
			task.delay(0.13, function()
				if var6.tween == var3 and (not next(var6.hovered) and var6.restore) then
					var6.restore()
					var6.restore = nil
				end
			end)

		end
	end

	local function fn3()
		if var3:GetLastInputType() == Enum.UserInputType.Touch then
			return
		end

		tbl2.Play("Hover")
		animate(true)
	end

	table.insert(tbl1, arg1.MouseEnter:Connect(fn3))
	fn3 = function()
		animate(false)
	end

	table.insert(tbl1, arg1.MouseLeave:Connect(fn3))
	fn3 = function()
		tbl2.Play("Hover")
		animate(true)
	end

	table.insert(tbl1, arg1.SelectionGained:Connect(fn3))
	fn3 = function()
		animate(false)
	end

	table.insert(tbl1, arg1.SelectionLost:Connect(fn3))
	local function press()
		if not var6.restore then
			var6.restore = tbl2.FreezeText(var4)
		end

		if var6.tween then
			var6.tween:Cancel()
		end

		local var1 = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		var6.tween = var2:Create(var6.scale, var1, { Scale = var6.base * 0.94 })
		var6.tween:Play()
	end

	local var10 = press
	table.insert(tbl1, arg1.MouseButton1Down:Connect(var10))
	var10 = function()
		animate(var6.hovered[arg1] == true, 0.12)
	end

	table.insert(tbl1, arg1.MouseButton1Up:Connect(var10))
	var10 = function()
		tbl2.Play("Click")
		if var3:GetLastInputType() == Enum.UserInputType.Touch then
			var6.hovered[arg1] = nil
		end

		if not next(var6.hovered) then
			press()
			task.delay(0.1, function()
				if arg1.Parent then
					animate(var6.hovered[arg1] == true, 0.12)
				end
			end)

		end
	end

	table.insert(tbl1, arg1.Activated:Connect(var10))
	arg1.Destroying:Once(function()
		var6.hovered[arg1] = nil
		for k1, v1 in tbl1, nil do
			v1:Disconnect()
		end

		var7[arg1] = nil
	end)
end

return tbl2

--- ReplicatedStorage.Modules.MiniCarSlots [ModuleScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
local bool1 = false
local var2 = nil
local var3 = require(var1.Modules.CarAssets)
local tbl1 = {}
local function visible(arg1)
	local var1 = arg1.AbsoluteSize
	local var2 = arg1.AbsolutePosition
	if var1.X < 2 or var1.Y < 2 then
		return false
	end

	local var3 = arg1
	while var3 do
		if var3:IsA("GuiObject") then
			if not var3.Visible then
				return false
			end

			local var6 = var3.AbsolutePosition
			local var7 = var3.AbsoluteSize
			if var3.ClipsDescendants and (var2.X + var1.X <= var6.X or (var6.X + var7.X <= var2.X or (var2.Y + var1.Y <= var6.Y or var6.Y + var7.Y <= var2.Y))) then
				return false
			end
		else
			if var3:IsA("ScreenGui") then
				return var3.Enabled
			end
		end

		var3 = var3.Parent
	end

	return false
end

local function build(arg1, arg2)
	local var4 = nil
	local var5
	if arg2.combatKind then
		local var6 = var1.Assets:FindFirstChild("CombatTools")
		local var8 = var6
		if var8 then
			var8 = var6:FindFirstChild(if arg2.combatKind == "Bat" then "Bat" else "TrapModel")
		end

		if not var8 then
			return
		end

		var5 = "Model"
		if var8:IsA(var5) then
			var4 = var8:Clone()
		else
			var4 = Instance.new("Model")
			for k1, v1 in var8:GetChildren() do
				if not v1:IsA("BasePart") then
					continue
				end

				v1:Clone().Parent = var4
			end
		end
	else
		local var9 = var3.GetHeldTemplate(arg2.id)
		local var10 = var9
		var10 = var10 and var9:FindFirstChild("Car")
		if var10 then
			var5 = "Model"
			if not var10:IsA(var5) then
				return
			end
		end

		var4 = var10:Clone()
	end

	for k2, v2 in var4:GetDescendants() do
		if v2:IsA("LuaSourceContainer") or (v2:IsA("Constraint") or (v2:IsA("JointInstance") or (v2:IsA("WeldConstraint") or (v2:IsA("Sound") or (v2:IsA("ParticleEmitter") or (v2:IsA("Trail") or v2:IsA("Beam"))))))) then
			v2:Destroy()
		else
			if not v2:IsA("BasePart") then
				continue
			end

			if 1 <= v2.Transparency then
				v2:Destroy()
			else
				v2.Anchored = true
				v2.CanCollide = false
				v2.CanTouch = false
				v2.CanQuery = false
			end
		end
	end

	local var11 = Instance.new("ViewportFrame")
	var11.Name = "MiniCarPreview"
	var11.BackgroundTransparency = 1
	var11.AnchorPoint = Vector2.new(0.5, 0)
	var11.Position = UDim2.fromScale(0.5, 0.03)
	var11.Size = UDim2.fromScale(0.96, 0.75)
	var11.Ambient = Color3.fromRGB(210, 210, 220)
	var11.LightColor = Color3.new(1, 1, 1)
	var11.LightDirection = Vector3.new(-1, -1, -1)
	var11.ZIndex = arg2.icon.ZIndex
	var4.Parent = var11
	if arg2.combatKind == "Bat" then
		local num4 = 0
		local num5 = 0
		local num6 = -0.73303828583761843
		var4:PivotTo(CFrame.Angles(num4, num5, num6))
	end

	local var12, var13 = var4:GetBoundingBox()
	local var14 = Vector3.new(0.8, 0.55, -1).Unit
	local var15 = CFrame.lookAt(var12.Position, var12.Position - var14)
	local num7 = 0
	for k3, v3 in var4:GetDescendants() do
		if not v3:IsA("BasePart") then
			continue
		end

		for i1 = -1, 1, 2 do
			for i2 = -1, 1, 2 do
				for i3 = -1, 1, 2 do
					local var16 = v3.Size * Vector3.new(i1, i2, i3) * 0.5
					local var17 = var15:PointToObjectSpace(v3.CFrame:PointToWorldSpace(var16))
					num7 = math.max(num7, var17.Z + math.abs(var17.X) / 0.36703409377127416, var17.Z + math.abs(var17.Y) / 0.28674538575880792)
				end
			end
		end
	end

	local var18 = Instance.new("Camera")
	var18.FieldOfView = 32
	var18.CFrame = CFrame.lookAt(var12.Position + var14 * num7 * 1.04, var12.Position)
	var18.Parent = var11
	var11.CurrentCamera = var18
	var11.Parent = arg1
	arg2.view = var11
end

local var4 = setmetatable({}, { __mode = "k" })
local function queue()
	if bool1 then
		return
	end

	bool1 = true
	task.defer(function()
		bool1 = false
		var2()
	end)
end

local function watchAncestors(arg1)
	local var1 = arg1.Parent
	while not var1 and (not var4[var1]) do
	end
end

var2 = function()
	for k1, v1 in pairs(tbl1) do
		if not v1.id then
			if v1.combatKind then
				if visible(k1) then
					if v1.view then
						continue
					end

					build(k1, v1)
				else
					if not v1.view then
						continue
					end

					v1.view:Destroy()
					v1.view = nil
				end
			else
				if not v1.view then
					continue
				end

				v1.view:Destroy()
				v1.view = nil
			end
		end
	end
end

local var5 = require(var1.Configs.CarConfig)
return { SetTool = function(arg1, arg2, arg3, arg4)
	local var4 = tbl1[arg1]
	if not var4 then
		var4 = {
			icon = arg3,
			label = arg4,
			labelSize = arg4.Size,
			labelPosition = arg4.Position,
			labelAnchor = arg4.AnchorPoint,
			labelTextSize = arg4.TextSize,
			labelColor = arg4.TextColor3,
		}

		tbl1[arg1] = var4
		arg1:GetPropertyChangedSignal("Visible"):Connect(queue)
		arg1:GetPropertyChangedSignal("AbsolutePosition"):Connect(queue)
		arg1:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue)
		arg1.AncestryChanged:Connect(function()
			watchAncestors(arg1)
			if bool1 then
				return
			end

			bool1 = true
			task.defer(function()
				bool1 = false
				var2()
			end)
		end)

		arg3:GetPropertyChangedSignal("ZIndex"):Connect(function()
			if var4.view then
				var4.view.ZIndex = arg3.ZIndex
			end
		end)

		arg1.Destroying:Once(function()
			local var1 = var4
			if var1.view then
				var1.view:Destroy()
				var1.view = nil
			end

			tbl1[arg1] = nil
		end)

		watchAncestors(arg1)
	end

	local var6 = arg2
	var6 = var6 and var3.GetId(arg2)
	local var7 = arg2
	var6 = var6 and var5.Exists(var6) or nil
	var7 = var7 and arg2:GetAttribute("CombatKind")
	if var4.id == var6 then
		if var4.combatKind ~= var7 then
			local var10 = var4
			if var10.view then
				var10.view:Destroy()
				var10.view = nil
			end

			var4.id = var6
			var4.combatKind = var7
		end
	end

	arg1:SetAttribute("MiniCarId", var6)
	local bool2 = false
	if var6 == nil then
		bool2 = var7 == nil
	end

	arg3.Visible = bool2
	if var7 then
		arg3.Image = ""
		arg4.Visible = true
		arg4.Text = if var7 == "Bat" then "Bat" else arg2.Name
		arg4.TextColor3 = Color3.fromRGB(255, 230, 160)
		arg4.AnchorPoint = Vector2.new(0.5, 1)
		arg4.Position = UDim2.fromScale(0.5, 0.97)
		arg4.Size = UDim2.new(1, -6, 0.2, 0)
		arg4.TextSize = math.clamp(arg1.AbsoluteSize.X / 5.5, 10, 14)
		arg4.TextWrapped = false
		arg4.TextTruncate = Enum.TextTruncate.AtEnd
	elseif var6 then
		arg3.Image = ""
		arg4.Visible = true
		bool2 = var5.Get(var6).DisplayName
		bool2 = bool2 or (var5.Get(var6).Name or var6)
		arg4.Text = bool2
		local var11 = var6
		arg4.TextColor3 = var5.GetRarityInfo(var5.GetRarity(var11)).Color
		arg4.AnchorPoint = Vector2.new(0.5, 1)
		arg4.Position = UDim2.fromScale(0.5, 0.97)
		arg4.Size = UDim2.new(1, -6, 0.2, 0)
		arg4.TextSize = math.clamp(arg1.AbsoluteSize.X / 5.5, 10, 14)
		arg4.TextWrapped = false
		arg4.TextTruncate = Enum.TextTruncate.AtEnd
	else
		arg4.Size = var4.labelSize
		arg4.Position = var4.labelPosition
		arg4.AnchorPoint = var4.labelAnchor
		arg4.TextSize = var4.labelTextSize
		arg4.TextWrapped = true
		arg4.TextColor3 = var4.labelColor
	end

	if not bool1 then
		bool1 = true
		task.defer(function()
			bool1 = false
			var2()
		end)

	end
end }

--- ReplicatedStorage.Modules.PromptPolicy [ModuleScript]
-- y u r i

local var1 = workspace:WaitForChild("Plots")
local tbl1 = { GetPlot = function(arg1)
	local var2 = arg1.Parent
	while not var2 and var2 == workspace and var2.Parent == var1 do
	end
end }

tbl1.CanShow = function(arg1, arg2)
	if not arg1.Enabled or (not arg1:IsDescendantOf(workspace)) then
		return false
	end

	if arg1:GetAttribute("TutorialDuplicateHidden") then
		return false
	end

	local var1 = arg1:GetAttribute("OwnerUserId")
	var1 = var1 or arg1:GetAttribute("TutorialOwnerUserId")
	if var1 and var1 ~= arg2.UserId then
		return false
	end

	local var3 = tbl1.GetPlot(arg1)
	if var3 and (var3:GetAttribute("Owner") ~= arg2.UserId or var3:GetAttribute("Taken") ~= true) then
		return false
	end

	return arg1:GetAttribute("PromptAvailable") ~= false
end

tbl1.GetHighlightTarget = function(arg1)
	local var2 = arg1:FindFirstChild("HighlightTarget")
	if var2 and var2:IsA("ObjectValue") then
		return var2.Value
	end

	local var3 = tbl1.GetPlot(arg1)
	local var4 = nil
	local var5 = nil
	local var6 = arg1.Parent
	while var6 do
		if var6 == workspace or var6 == var3 then
			break
		end

		if var6:IsA("Model") then
			var4 = var4 or var6
			if var6:GetAttribute("CarId") or var6:GetAttribute("CarRepresentation") then
				return var6
			end
		else
			if var6:IsA("BasePart") then
				var5 = var5 or var6
			end
		end

		var6 = var6.Parent
	end

	return var4 or var5
end

return tbl1

--- ReplicatedStorage.Modules.OffsetListLayout [ModuleScript]
-- y u r i

local var1 = setmetatable({}, { __mode = "k" })
local function scaleOf(arg1)
	local num1 = 1
	local var1 = arg1
	while var1 and var1:IsA("GuiObject") do
		for k1, v1 in var1:GetChildren() do
			if not v1:IsA("UIScale") then
				continue
			end

			num1 = num1 * v1.Scale
		end

		var1 = var1.Parent
	end

	return (math.max(0.01, num1))
end

return { Bind = function(arg1)
	if var1[arg1] then
		return
	end

	local var2 = arg1:FindFirstChildOfClass("UIGridLayout")
	local var4 = arg1:GetAttribute("OffsetListKind")
	var2 = var2 or arg1:FindFirstChildOfClass("UIListLayout")
	if not var4 or (not var2) then
		return
	end

	var1[arg1] = {}
	local var5 = arg1:FindFirstChildOfClass("UIPadding")
	var5 = var5 or Instance.new("UIPadding")
	var5.Parent = arg1
	local bool1 = false
	local function refresh()
		if not arg1.Parent then
			return
		end

		local var1 = scaleOf(arg1)
		local var3 = if arg1:IsA("ScrollingFrame") then arg1.AbsoluteWindowSize else arg1.AbsoluteSize
		local var8 = var3.X / var1
		local var9 = var3.Y / var1
		if var8 < 2 or var9 < 2 then
			return
		end

		local var10 = if var4 == "ShopCards" or var4 == "IndexRewards" then 0 else 10
		var5.PaddingLeft = UDim.new(0, var10)
		var5.PaddingRight = UDim.new(0, var10)
		var5.PaddingTop = UDim.new(0, var10)
		var5.PaddingBottom = UDim.new(0, var10)
		local var11 = if var4 == "Trails" then 12 else 10
		local var12 = math.max(1, var8 - var10 * 2)
		local var13 = math.max(1, var9 - var10 * 2)
		local var14 = nil
		local var15
		if var2:IsA("UIGridLayout") then
			local var16
			if var4 == "ShopCards" then
				var16 = 4
			else
				var16 = if var4 == "IndexRewards" then 3 else math.max(2, (math.floor(var3.X / 140)))
			end

			if var4 == "Index" then
				var16 = math.max(var16, (math.ceil((var12 + var11) / (math.max(64, var13 * 112 / 138) + var11))))
			end

			local var17 = math.max(1, (math.floor((var12 - (var16 - 1) * var11) / var16)))
			if var4 == "IndexRewards" then
				var17 = math.min(var17, (math.floor(var13)))
			end

			local var18 = UDim2.fromOffset
			local var19 = var17
			if var4 == "ShopCards" then
				var15 = math.floor(var13)
			else
				var15 = if var4 == "Index" then math.floor(var17 * 138 / 112) else var17
			end

			var14 = var18(var19, var15)
			var2.CellSize = var14
			var15 = var11
			var2.CellPadding = UDim2.fromOffset(var15, var11)
		else
			var2.Padding = UDim.new(0, var11)
		end

		for k1, v1 in arg1:GetChildren() do
			if not v1:IsA("GuiObject") then
				continue
			end

			local var21 = nil
			if var14 then
				var21 = var14
			else
				if var4 == "Trails" then
					var21 = UDim2.fromOffset(math.floor((math.max(var13 * 0.77, var12 * (if (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 1000) < 700 then 0.62 else 0.3)))), (math.floor(var13)))
				else
					var21 = UDim2.fromOffset(math.floor(var12 * (v1:GetAttribute("ListWidthRatio") or 1)), (math.floor(var12 * (v1:GetAttribute("ListHeightRatio") or 0.1))))
				end
			end

			if v1.Size ~= var21 then
				v1.Size = var21
			end

			if v1.Position.X.Scale ~= 0 or v1.Position.Y.Scale ~= 0 then
				v1.Position = UDim2.fromOffset(0, 0)
			end
		end

		if arg1:IsA("ScrollingFrame") then
			arg1.AutomaticCanvasSize = Enum.AutomaticSize.None
			var16 = var2.AbsoluteContentSize / var1
			local var23 = if var4 == "Trails" then UDim2.fromOffset(math.ceil(var16.X + var10 * 2), 0) else UDim2.fromOffset(0, (math.ceil(var16.Y + var10 * 2)))
			if arg1.CanvasSize ~= var23 then
				arg1.CanvasSize = var23
			end
		end
	end

	local function queue()
		if bool1 then
			return
		end

		bool1 = true
		task.defer(function()
			bool1 = false
			refresh()
		end)
	end

	local var6 = queue
	local tbl2 = {
		arg1:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue),
		arg1.ChildAdded:Connect(queue),
		arg1.ChildRemoved:Connect(queue),
		var2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(var6),
	}

	if arg1:IsA("ScrollingFrame") then
		local var8 = queue
		table.insert(tbl2, arg1:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(var8))
	end

	arg1.Destroying:Once(function()
		for k1, v1 in tbl2, nil do
			v1:Disconnect()
		end

		var1[arg1] = nil
	end)

	refresh()
end }

--- ReplicatedStorage.Modules.LeaderboardValue [ModuleScript]
-- y u r i

local var1 = require(game.ReplicatedStorage.Modules.BigNumber)
return {
	Encode = function(arg1)
		local var2 = var1.fromData(arg1)
		if var2.Mantissa <= 0 or var2.Exponent < 0 then
			return 0
		end

		assert(var2.Exponent <= 8000, "Leaderboard value exceeds supported exponent")
		return (var2.Exponent + 1) * 1000000000000 + math.floor((var2.Mantissa - 1) * 100000000000 + 0.5)
	end,
	Decode = function(arg1)
		if not arg1 or arg1 <= 0 then
			local num3 = 0
			local num4 = 0
			return var1.new(num3, num4)
		end

		local var2 = 1 + arg1 % 1000000000000 / 100000000000
		local var3 = math.floor(arg1 / 1000000000000) - 1
		return var1.new(var2, var3)
	end,
}

--- ReplicatedStorage.Modules.IndexCarPreviews [ModuleScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
require(var1.Configs.CarConfig)
local bool1 = false
local var2 = nil
local var3 = require(var1.Modules.CarAssets)
local tbl1 = {}
local function visible(arg1)
	local var1 = arg1.AbsoluteSize
	local var2 = arg1.AbsolutePosition
	if var1.X < 2 or var1.Y < 2 then
		return false
	end

	local var3 = arg1
	while var3 do
		if var3:IsA("GuiObject") then
			if not var3.Visible then
				return false
			end

			local var6 = var3.AbsolutePosition
			local var7 = var3.AbsoluteSize
			if var3.ClipsDescendants and (var2.X + var1.X <= var6.X or (var6.X + var7.X <= var2.X or (var2.Y + var1.Y <= var6.Y or var6.Y + var7.Y <= var2.Y))) then
				return false
			end
		else
			if var3:IsA("ScreenGui") then
				return var3.Enabled
			end
		end

		var3 = var3.Parent
	end

	return false
end

local function build(arg1, arg2)
	local var1 = var3.GetHeldTemplate(arg2.id)
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("Car")
	if not var2 or (not var2:IsA("Model")) then
		return
	end

	local var4 = var2:Clone()
	for k1, v1 in var4:GetDescendants() do
		if v1:IsA("LuaSourceContainer") or (v1:IsA("Constraint") or (v1:IsA("JointInstance") or (v1:IsA("WeldConstraint") or (v1:IsA("Sound") or (v1:IsA("ParticleEmitter") or (v1:IsA("Trail") or v1:IsA("Beam"))))))) then
			v1:Destroy()
		else
			if not v1:IsA("BasePart") then
				continue
			end

			if 1 <= v1.Transparency then
				v1:Destroy()
			else
				v1.Anchored = true
				v1.CanCollide = false
				v1.CanTouch = false
				v1.CanQuery = false
			end
		end
	end

	local var5 = Instance.new("ViewportFrame")
	var5.Name = "MiniCarPreview"
	var5.BackgroundTransparency = 1
	var5.AnchorPoint = Vector2.new(0.5, 0.5)
	var5.Position = UDim2.fromScale(0.5, 0.52)
	var5.Size = UDim2.fromScale(0.94, 0.55)
	local var6 = if arg2.unlocked then Color3.new(1, 1, 1) else Color3.new(0, 0, 0)
	var5.ImageColor3 = var6
	var5.Ambient = Color3.fromRGB(210, 210, 220)
	var5.LightColor = Color3.new(1, 1, 1)
	var5.LightDirection = Vector3.new(-1, -1, -1)
	var5.ZIndex = arg2.icon.ZIndex
	var4.Parent = var5
	local var7, var8 = var4:GetBoundingBox()
	local var9 = Vector3.new(0.8, 0.55, -1).Unit
	local var10 = CFrame.lookAt(var7.Position, var7.Position - var9)
	local num1 = 0
	for k2, v2 in var4:GetDescendants() do
		if not v2:IsA("BasePart") then
			continue
		end

		for i1 = -1, 1, 2 do
			for i2 = -1, 1, 2 do
				for i3 = -1, 1, 2 do
					local var11 = v2.Size * Vector3.new(i1, i2, i3) * 0.5
					local var12 = var10:PointToObjectSpace(v2.CFrame:PointToWorldSpace(var11))
					num1 = math.max(num1, var12.Z + math.abs(var12.X) / 0.397741162222494, var12.Z + math.abs(var12.Y) / 0.28674538575880792)
				end
			end
		end
	end

	local var13 = Instance.new("Camera")
	var13.FieldOfView = 32
	var13.CFrame = CFrame.lookAt(var7.Position + var9 * num1 * 1.04, var7.Position)
	var13.Parent = var5
	var5.CurrentCamera = var13
	var5.Parent = arg1
	arg2.view = var5
end

local var4 = setmetatable({}, { __mode = "k" })
local function queue()
	if bool1 then
		return
	end

	bool1 = true
	task.defer(function()
		bool1 = false
		var2()
	end)
end

local function watchAncestors(arg1)
	local var1 = arg1.Parent
	while not var1 and (not var4[var1]) do
	end
end

var2 = function()
	for k1, v1 in pairs(tbl1) do
		if v1.id then
			if visible(k1) then
				if v1.view then
					continue
				end

				build(k1, v1)
			else
				if not v1.view then
					continue
				end

				v1.view:Destroy()
				v1.view = nil
			end
		else
			if not v1.view then
				continue
			end

			v1.view:Destroy()
			v1.view = nil
		end
	end
end

return { SetCard = function(arg1, arg2, arg3)
	local var3 = tbl1[arg1]
	if not var3 then
		var3 = { icon = arg1.Image }
		tbl1[arg1] = var3
		arg1:GetPropertyChangedSignal("AbsolutePosition"):Connect(queue)
		arg1:GetPropertyChangedSignal("AbsoluteSize"):Connect(queue)
		arg1:GetPropertyChangedSignal("Visible"):Connect(queue)
		arg1.Destroying:Once(function()
			local var1 = var3
			if var1.view then
				var1.view:Destroy()
				var1.view = nil
			end

			tbl1[arg1] = nil
		end)

		watchAncestors(arg1)
	end

	if var3.id ~= arg2 then
		local var5 = var3
		if var5.view then
			var5.view:Destroy()
			var5.view = nil
		end

		var3.id = arg2
	end

	var3.unlocked = arg3
	var3.icon.Image = ""
	if var3.view then
		local var6 = var3.view
		local var7 = if arg3 then Color3.new(1, 1, 1) else Color3.new(0, 0, 0)
		var6.ImageColor3 = var7
	end

	if not bool1 then
		bool1 = true
		task.defer(function()
			bool1 = false
			var2()
		end)

	end
end }

--- ReplicatedStorage.Modules.OtherSounds [ModuleScript]
-- y u r i

local var1 = game:GetService("RunService")
local var2 = game:GetService("SoundService")
return { Play = function(arg1)
	if not var1:IsClient() then
		return false
	end

	local var3 = var2:FindFirstChild("Other")
	local var4 = var3
	var4 = var4 and var3:FindFirstChild(arg1)
	if not var4 or (not var4:IsA("Sound") or var4.SoundId == "") then
		return false
	end

	var4.TimePosition = 0
	var2:PlayLocalSound(var4)
	return true
end }

--- ReplicatedStorage.Modules.MusicPlayer [ModuleScript]
-- y u r i

local tbl1 = {}
tbl1.__index = tbl1
tbl1.new = function(arg1)
	local var1 = setmetatable({
		service = arg1,
		chasing = false,
		racing = false,
		muted = false,
		raceMuted = false,
		alive = true,
	}, tbl1)

	var1.runtime = Instance.new("Folder")
	var1.runtime.Name = "LocalMusicPlayback"
	var1.runtime.Parent = arg1
	var1.normal = { name = "Music", revision = 0, failed = {}, lastIndex = 0 }
	var1.chase = { name = "ChaseMusic", revision = 0, failed = {}, lastIndex = 0 }
	var1.race = { name = "RaceMusic", revision = 0, failed = {}, lastIndex = 0 }
	var1.selected = var1.normal
	return var1
end

tbl1._isMuted = function(arg1, arg2)
	if arg2 == arg1.race then
		return arg1.raceMuted
	end

	return arg1.muted
end

tbl1._active = function(arg1)
	if arg1.racing then
		return arg1.race
	end

	if arg1.chasing then
		return arg1.chase
	end

	return arg1.normal
end

local function tracks(arg1)
	local tbl1 = {}
	if not arg1 then
		return tbl1
	end

	if arg1:IsA("Sound") then
		if arg1.SoundId ~= "" then
			table.insert(tbl1, arg1)
		end
	else
		for k1, v1 in arg1:GetDescendants() do
			if not v1:IsA("Sound") then
				continue
			end

			if v1.SoundId == "" then
				continue
			end

			table.insert(tbl1, v1)
		end
	end

	table.sort(tbl1, function(arg1, arg2)
		local str1 = "Order"
		local var1 = tonumber(arg1:GetAttribute(str1)) or 0
		str1 = "Order"
		local var3 = tonumber(arg2:GetAttribute(str1)) or 0
		if var1 ~= var3 then
			return var1 < var3
		end

		return arg1.Name < arg2.Name
	end)

	return tbl1
end

tbl1._next = function(arg1, arg2)
	local var1 = arg2.revision + 1
	arg2.revision = var1
	if arg2.ended then
		arg2.ended:Disconnect()
		arg2.ended = nil
	end

	if arg2.sound then
		arg2.sound:Stop()
		arg2.sound:Destroy()
		arg2.sound = nil
	end

	arg2.source = nil
	local var2 = arg2.name
	var1 = tracks(arg1.service:FindFirstChild(var2))
	local var3 = os.clock()
	for i1 = 1, #var1 do
		local var4 = (arg2.lastIndex + i1 - 1) % #var1 + 1
		local var5 = var1[var4]
		if (arg2.failed[var5] or 0) > var3 then
			continue
		end

		arg2.lastIndex = var4
		local var6 = var5:Clone()
		var6.Name = arg2.name .. "Player"
		var6.Looped = false
		var6.PlayOnRemove = false
		var6:Stop()
		var6.TimePosition = 0
		local var7 = if arg1:_isMuted(arg2) then 0 else var5.Volume
		var6.Volume = var7
		var6.Parent = arg1.runtime
		arg2.source = var5
		arg2.sound = var6
		arg2.started = var3
		arg2.wasPlaying = false
		var7 = arg2.revision
		arg2.ended = var6.Ended:Connect(function()
			if arg1.alive and (arg2.revision == var7 and arg1:_active() == arg2) then
				arg1:_next(arg2)
			end
		end)

		var6:Play()
		return
	end
end

tbl1._switch = function(arg1)
	local var2 = arg1:_active()
	if var2 == arg1.selected then
		return
	end

	local var4 = arg1.selected
	if var4 == arg1.normal then
		if var4.sound then
			var4.sound:Pause()
		end
	else
		local var5 = var4.revision + 1
		var4.revision = var5
		if var4.ended then
			var4.ended:Disconnect()
			var4.ended = nil
		end

		if var4.sound then
			var4.sound:Stop()
			var4.sound:Destroy()
			var4.sound = nil
		end

		var4.source = nil
	end

	arg1.selected = var2
	if var2 == arg1.normal and var2.sound then
		var2.started = os.clock()
		var2.sound:Resume()
		return
	end

	arg1:_next(var2)
end

tbl1.SetMuted = function(arg1, arg2)
	arg1.muted = arg2 == true
	local var1 = arg1.chase
	for k1, v1 in { arg1.normal, var1 }, nil do
		if not v1.sound then
			continue
		end

		if not v1.source then
			continue
		end

		local var2 = v1.sound
		local var3 = if arg1:_isMuted(v1) then 0 else v1.source.Volume
		var2.Volume = var3
	end
end

tbl1.SetRaceMuted = function(arg1, arg2)
	arg1.raceMuted = arg2 == true
	local var1 = arg1.race
	if var1.sound then
		if var1.source then
			local var2 = var1.sound
			var2.Volume = if arg1.raceMuted then 0 else var1.source.Volume
		end
	end
end

tbl1.SetChasing = function(arg1, arg2)
	arg1.chasing = arg2 == true
	arg1:_switch()
end

tbl1.SetRacing = function(arg1, arg2)
	arg1.racing = arg2 == true
	arg1:_switch()
end

tbl1.Update = function(arg1)
	if not arg1.alive then
		return
	end

	local var1 = arg1:_active()
	local var3 = arg1.service:FindFirstChild(var1.name)
	if var1.source and (not var3 or (var1.source == var3 or (not var1.source:IsDescendantOf(var3))) and var1.source.SoundId ~= var1.sound.SoundId) then
		local var4 = var1.revision + 1
		var1.revision = var4
		if var1.ended then
			var1.ended:Disconnect()
			var1.ended = nil
		end

		if var1.sound then
			var1.sound:Stop()
			var1.sound:Destroy()
			var1.sound = nil
		end

		var1.source = nil
	end

	if not var1.sound then
		arg1:_next(var1)
		return
	end

	local var5 = var1.sound
	local var6 = if arg1:_isMuted(var1) then 0 else var1.source.Volume
	var5.Volume = var6
	var5.PlaybackSpeed = var1.source.PlaybackSpeed
	var5.SoundGroup = var1.source.SoundGroup
	if var5.IsPlaying then
		var1.wasPlaying = true
	end

	if (var5.IsLoaded or 12 < os.clock() - var1.started) and var5.IsLoaded and (var1.wasPlaying and (not var5.IsPlaying and (not var5.IsPaused))) then
		var1.failed[var1.source] = os.clock() + 60
		arg1:_next(var1)
	end
end

tbl1.Destroy = function(arg1)
	if not arg1.alive then
		return
	end

	arg1.alive = false
	local var1 = arg1.normal
	local var2 = var1.revision + 1
	var1.revision = var2
	if var1.ended then
		var1.ended:Disconnect()
		var1.ended = nil
	end

	if var1.sound then
		var1.sound:Stop()
		var1.sound:Destroy()
		var1.sound = nil
	end

	var1.source = nil
	var1 = arg1.chase
	var2 = var1.revision + 1
	var1.revision = var2
	if var1.ended then
		var1.ended:Disconnect()
		var1.ended = nil
	end

	if var1.sound then
		var1.sound:Stop()
		var1.sound:Destroy()
		var1.sound = nil
	end

	var1.source = nil
	var1 = arg1.race
	var2 = var1.revision + 1
	var1.revision = var2
	if var1.ended then
		var1.ended:Disconnect()
		var1.ended = nil
	end

	if var1.sound then
		var1.sound:Stop()
		var1.sound:Destroy()
		var1.sound = nil
	end

	var1.source = nil
	arg1.runtime:Destroy()
end

return tbl1

--- ReplicatedStorage.Modules.FinishCelebration [ModuleScript]
-- y u r i

local var1 = game:GetService("TweenService")
local tbl1 = {}
local num1 = 0
local var2 = nil
local var3 = require(game.ReplicatedStorage.Configs.CarConfig)
local tbl2 = { Stop = function()
	local var1 = num1 + 1
	num1 = var1
	for k1, v1 in tbl1, nil do
		v1:Cancel()
	end

	table.clear(tbl1)
	if var2 then
		var2.Visible = false
	end
end }

local var4 = nil
local var5 = nil
local var6 = nil
tbl2.Play = function(arg1, arg2)
	tbl2.Stop()
	local var7 = arg1:FindFirstChild("Notifications")
	var7 = var7 or arg1:FindFirstChild("Notification")
	if not var7 then
		return
	end

	if var2 then
		if var2.Parent ~= var7 then
			if var2 then
				var2:Destroy()
			end

			var2 = Instance.new("CanvasGroup")
			var2.Name = "FinishCelebration"
			var2.AnchorPoint = Vector2.new(0.5, 0.5)
			var2.Position = UDim2.fromScale(0.5, 0.25)
			var2.Size = UDim2.fromScale(0.65, 0.15)
			var2.BackgroundTransparency = 1
			var2.ZIndex = 60
			var2.Active = false
			var2.Parent = var7
			local var8 = Instance.new("UISizeConstraint")
			var8.MaxSize = Vector2.new(720, 150)
			var8.Parent = var2
			var4 = Instance.new("UIScale")
			var4.Parent = var2
			var5 = Instance.new("TextLabel")
			var5.Name = "Title"
			var5.BackgroundTransparency = 1
			var5.Size = UDim2.fromScale(1, 0.66)
			var5.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
			var5.TextScaled = true
			var5.Text = "CAR SECURED!"
			var5.TextColor3 = Color3.fromRGB(140, 255, 155)
			var5.ZIndex = 61
			var5.Parent = var2
			local var9 = Instance.new("UIStroke")
			var9.Color = Color3.fromRGB(15, 55, 30)
			var9.Thickness = 2.5
			var9.Parent = var5
			var6 = var5:Clone()
			var6.Name = "CarName"
			var6.Position = UDim2.fromScale(0.05, 0.69)
			var6.Size = UDim2.fromScale(0.9, 0.28)
			var6.TextColor3 = Color3.new(1, 1, 1)
			var6.Parent = var2
		end
	end

	local var10 = if type(arg2) == "string" then arg2 else ""
	local var11 = var6
	local var12 = if var3.Exists(var10) then var3.Get(var10).Name or var10 else "SAFE AND SOUND"
	var11.Text = var12
	var2.Visible = true
	var2.GroupTransparency = 1
	var2.Position = UDim2.fromScale(0.5, 0.28)
	var4.Scale = 0.82
	local var13 = var1:Create(var2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.24) })
	table.insert(tbl1, var13)
	var13:Play()
	var13 = var1:Create(var4, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
	table.insert(tbl1, var13)
	var13:Play()
	var11 = num1
	task.delay(2.05, function()
		if num1 ~= var11 or (not var2 or (not var2.Parent)) then
			return
		end

		local var3 = var1:Create(var2, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 1, Position = UDim2.fromScale(0.5, 0.2) })
		table.insert(tbl1, var3)
		var3:Play()
		var3 = var1:Create(var4, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.96 })
		table.insert(tbl1, var3)
		var3:Play()
		task.delay(0.46, function()
			if num1 == var11 and var2 then
				var2.Visible = false
			end
		end)
	end)
end

return tbl2

--- ReplicatedStorage.Modules.CarInteractionReach [ModuleScript]
-- y u r i

local var1 = require(game.ReplicatedStorage.Configs.ZoneConfig)
local tbl1 = { DistanceToBody = function(arg1, arg2)
	local var2 = arg1:FindFirstChild("Chassis")
	if not var2 or (not var2:IsA("BasePart")) then
		return math.huge
	end

	local str1 = "CarWidth"
	local var3 = tonumber(arg1:GetAttribute(str1))
	local str2 = "CarLength"
	local var4 = tonumber(arg1:GetAttribute(str2))
	local str3 = "CarHeight"
	local var5 = tonumber(arg1:GetAttribute(str3))
	str1 = var2:FindFirstChild("GroundAnchor")
	var3 = var3 or var2.Size.X
	var4 = var4 or var2.Size.Z
	var5 = var5 or var2.Size.Y
	str3 = var2.CFrame:PointToObjectSpace(arg2) - Vector3.new(0, (if str1 and str1:IsA("Attachment") then str1.Position.Y else -var5 / 2) + var5 / 2, 0)
	local var6 = Vector3.new(var3, var5, var4) / 2
	return (str3 - Vector3.new(math.clamp(str3.X, -var6.X, var6.X), math.clamp(str3.Y, -var6.Y, var6.Y), (math.clamp(str3.Z, -var6.Z, var6.Z)))).Magnitude
end }

tbl1.CanStealFrom = function(arg1, arg2)
	local var3 = arg1:FindFirstChild("Chassis")
	if not var3 or (not var3:IsA("BasePart")) then
		return false
	end

	if tbl1.DistanceToBody(arg1, arg2) <= 6 then
		return true
	end

	local var4 = var3:FindFirstChild("StealAttachment")
	local var5 = var4
	var5 = var5 and var4:FindFirstChild("StealPrompt")
	local var6 = if var4 and var4:IsA("Attachment") then var4.WorldPosition else var3.Position
	return (arg2 - var6).Magnitude <= (if var5 and var5:IsA("ProximityPrompt") then var5.MaxActivationDistance else var1.PromptDistance) + 2
end

return tbl1

--- ReplicatedStorage.Modules.CashHudPulse [ModuleScript]
-- y u r i

local var1 = game:GetService("Players")
local num1 = 0
local tbl1 = {}
local var2 = nil
local var3 = game:GetService("TweenService")
return { Play = function()
	local var4 = var1.LocalPlayer:FindFirstChild("PlayerGui")
	local var5 = var4
	var5 = var5 and var4:FindFirstChild("HUD")
	local var6 = var5
	var6 = var6 and (var5:FindFirstChild("BottomLeft") and var5.BottomLeft:FindFirstChild("Cash"))
	local var7 = var6
	var7 = var7 and var6:FindFirstChild("CashNumber")
	if not var7 then
		return
	end

	local var8 = num1 + 1
	num1 = var8
	var8 = num1
	for k1, v1 in tbl1, nil do
		v1:Cancel()
	end

	table.clear(tbl1)
	local var9 = var6:FindFirstChild("CashClaimScale")
	var9 = var9 or Instance.new("UIScale")
	var9.Name = "CashClaimScale"
	var9.Parent = var6
	local var10 = var7:FindFirstChildOfClass("UIGradient")
	var10 = var10 or Instance.new("UIGradient")
	var10.Parent = var7
	if not var2 or var2.label ~= var7 then
		var2 = {
			label = var7,
			color = var7.TextColor3,
			gradient = var10,
			colors = var10.Color,
			offset = var10.Offset,
			rotation = var10.Rotation,
			enabled = var10.Enabled,
		}

	end

	var7.TextColor3 = Color3.new(1, 1, 1)
	var10.Enabled = true
	local num2 = 15
	local num3 = 230
	local num4 = 45
	local var11 = ColorSequenceKeypoint.new(0, Color3.fromRGB(num2, num3, num4))
	num3 = 210
	num4 = 255
	local num5 = 120
	local var12 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(num3, num4, num5))
	num4 = 0
	num5 = 255
	local num6 = 105
	num2 = 1
	var10.Color = ColorSequence.new({ var11, var12, ColorSequenceKeypoint.new(num2, Color3.fromRGB(num4, num5, num6)) })
	var10.Rotation = 20
	var10.Offset = Vector2.new(-1, 0)
	var12 = var3:Create(var9, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.13 })
	table.insert(tbl1, var12)
	var12:Play()
	local var13 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	var12 = var3:Create(var10, var13, { Offset = Vector2.new(1, 0) })
	table.insert(tbl1, var12)
	var12:Play()
	task.delay(0.18, function()
		if var8 ~= num1 or (not var9.Parent) then
			return
		end

		local var1 = var3:Create(var9, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 })
		table.insert(tbl1, var1)
		var1:Play()
	end)

	task.delay(0.9, function()
		if var8 ~= num1 or (not var7.Parent) then
			return
		end

		var7.TextColor3 = var2.color
		var10.Color = var2.colors
		var10.Offset = var2.offset
		var10.Rotation = var2.rotation
		var10.Enabled = var2.enabled
	end)
end }

--- ReplicatedStorage.Modules.WheelSpin [ModuleScript]
-- y u r i

return { AngularSpeed = function(arg1, arg2)
	if arg1 ~= arg1 or math.abs(arg1) == math.huge then
		return 0
	end

	local var1 = arg1 / math.max(0.1, arg2)
	local var3 = math.abs(var1)
	return math.sign(var1) * (if var3 <= 4 then var3 else (1 - math.exp(-(var3 - 4) / 8)) * 8 + 4)
end }

--- ReplicatedStorage.Modules.CombatPolicy [ModuleScript]
-- y u r i

return {
	FiniteVector = function(arg1)
		local bool2 = false
		if typeof(arg1) == "Vector3" then
			bool2 = false
			if arg1.X == arg1.X then
				bool2 = false
				if arg1.Y == arg1.Y then
					bool2 = false
					if arg1.Z == arg1.Z then
						bool2 = false
						if math.abs(arg1.X) < 10000000 then
							bool2 = false
							if math.abs(arg1.Y) < 10000000 then
								bool2 = math.abs(arg1.Z) < 10000000
							end
						end
					end
				end
			end
		end

		return bool2
	end,
	TutorialProtected = function(arg1)
		local var2 = not arg1
		if not var2 then
			var2 = true
			if type(arg1.Tutorial) == "table" then
				var2 = arg1.Tutorial.Completed ~= true
			end
		end

		return var2
	end,
	MovingDriver = function(arg1, arg2, arg3, arg4)
		local bool2 = false
		if arg1 == "Driven" then
			bool2 = arg2
			if bool2 then
				bool2 = not arg3
				if bool2 then
					bool2 = 2 <= arg4
				end
			end
		end

		return bool2
	end,
	SafeDistance = function(arg1, arg2)
		local var1 = arg1.CFrame:PointToObjectSpace(arg2)
		local var2 = math.max(0, math.abs(var1.X) - arg1.Size.X / 2)
		local var3 = math.max(0, math.abs(var1.Z) - arg1.Size.Z / 2)
		return (math.sqrt(var2 * var2 + var3 * var3))
	end,
	SweptHit = function(arg1, arg2, arg3, arg4)
		local var1 = arg1:PointToObjectSpace(arg3)
		local str1 = "Y"
		local var2 = arg1:PointToObjectSpace(arg4) - var1
		local num1 = 0
		local num2 = 1
		for k1, v1 in { "X", str1, "Z" }, nil do
			if math.abs(var2[v1]) < 1e-06 then
				if arg2[v1] >= math.abs(var1[v1]) then
					continue
				end

				return false
			else
				local var3 = (-arg2[v1] - var1[v1]) / var2[v1]
				local var4 = (arg2[v1] - var1[v1]) / var2[v1]
				num2 = math.min(num2, (math.max(var3, var4)))
				num1 = math.max(num1, (math.min(var3, var4)))
				if num2 >= num1 then
					continue
				end

				return false
			end
		end

		return true
	end,
}

--- ReplicatedStorage.Modules.CarParking [ModuleScript]
-- y u r i

return {
	Capture = function(arg1, arg2)
		local tbl1 = { car = arg1, chassis = arg2, parts = {}, joints = {} }
		for k1, v1 in arg1:GetDescendants() do
			if v1:IsA("BasePart") then
				tbl1.parts[v1] = arg2.CFrame:ToObjectSpace(v1.CFrame)
			else
				if v1:IsA("WeldConstraint") or (v1:IsA("Constraint") or v1:IsA("Motor6D")) then
					table.insert(tbl1.joints, v1)
				end
			end
		end

		return tbl1
	end,
	Restore = function(arg1)
		local var1 = arg1.car
		local var3 = arg1.chassis
		if not var1.Parent or (not var3.Parent) then
			return false
		end

		local var4 = var3.CFrame.LookVector * Vector3.new(1, 0, 1)
		if var4.Magnitude < 0.01 then
			var4 = Vector3.new(0, 1, 0):Cross(var3.CFrame.RightVector * Vector3.new(1, 0, 1))
		end

		local var5 = var3:FindFirstChild("GroundAnchor")
		local var6 = RaycastParams.new()
		var6.FilterType = Enum.RaycastFilterType.Exclude
		var4 = if 0.01 < var4.Magnitude then var4.Unit else Vector3.new(0, 0, -1)
		local var7 = var3.Position
		local tbl1 = { var1 }
		for k1, v1 in game.Players:GetPlayers() do
			if not v1.Character then
				continue
			end

			local var8 = v1.Character
			table.insert(tbl1, var8)
		end

		var6.FilterDescendantsInstances = tbl1
		var6.RespectCanCollide = true
		var6.CollisionGroup = var3.CollisionGroup
		local var10 = workspace:Raycast(var7 + Vector3.new(0, 4, 0), Vector3.new(0, -28, 0), var6)
		if var10 and (0.8 < var10.Normal.Y and var5) then
			var7 = Vector3.new(var7.X, var10.Position.Y - var5.Position.Y + 0.05, var7.Z)
		end

		local var11 = CFrame.lookAt(var7, var7 + var4)
		local tbl2 = {}
		for k2, v2 in arg1.joints, nil do
			if not v2.Parent then
				continue
			end

			tbl2[v2] = v2.Enabled
			v2.Enabled = false
			if v2:IsA("HingeConstraint") then
				v2.AngularVelocity = 0
				v2.TargetAngle = 0
			end

			if not v2:IsA("Motor6D") then
				continue
			end

			v2.Transform = CFrame.identity
		end

		for k3 in arg1.parts, nil do
			if not k3.Parent then
				continue
			end

			k3.Anchored = true
		end

		for k4, v3 in arg1.parts, nil do
			if not k4.Parent then
				continue
			end

			k4.CFrame = var11 * v3
			k4.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			k4.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end

		for k5, v4 in tbl2, nil do
			if not k5.Parent then
				continue
			end

			k5.Enabled = v4
		end

		return true
	end,
}

--- ReplicatedStorage.Modules.LifecycleWait [ModuleScript]
-- y u r i

return {
	Child = function(arg1, arg2, arg3)
		while true do
			if not arg3() then
				break
			end

			local var1 = arg1:FindFirstChild(arg2)
			var1 = var1 or arg1:WaitForChild(arg2, 1)
			if not arg3() then
				return nil
			end

			if not var1 then
				continue
			end

			return var1
		end

		return nil
	end,
	Until = function(arg1, arg2)
		while true do
			if not arg2() then
				break
			end

			local var2 = arg1()
			if var2 then
				return var2
			end

			task.wait(0.1)
		end

		return nil
	end,
}

--- ReplicatedStorage.Modules.MobileDrivingControls [ModuleScript]
-- y u r i

game:GetService("Players")
local var1 = game:GetService("UserInputService")
local var2 = game:GetService("GuiService")
local var3 = game:GetService("TweenService")
local var4 = require(script.Parent.UIEffects)
local tbl1 = {}
tbl1.__index = tbl1
tbl1._paint = function(_, arg2, arg3, arg4)
	arg2.button:SetAttribute("DrivingHeld", arg3)
	if arg2.tween then
		arg2.tween:Cancel()
	end

	if arg2.colorTween then
		arg2.colorTween:Cancel()
	end

	local var1 = arg2.baseScale
	local var4 = var1 * (if arg3 then 1.08 else 1)
	var1 = if arg3 then arg2.color:Lerp(Color3.new(0, 0, 0), 0.22) else arg2.color
	if arg4 then
		arg2.scale.Scale = var4
		arg2.tint[arg2.colorProperty] = var1
		return
	end

	local var5 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	arg2.tween = var3:Create(arg2.scale, var5, { Scale = var4 })
	arg2.colorTween = var3:Create(arg2.tint, var5, { [arg2.colorProperty] = var1 })
	arg2.tween:Play()
	arg2.colorTween:Play()
end

tbl1._release = function(arg1, arg2, arg3)
	local var2 = arg1.inputs[arg2]
	if not var2 then
		return
	end

	arg1.inputs[arg2] = nil
	var2.connection:Disconnect()
	local var3 = var2.entry
	local var4 = math.max(0, var3.count - 1)
	var3.count = var4
	arg1:_paint(var3, 0 < var3.count, arg3)
end

tbl1.Clear = function(arg1)
	local tbl1 = {}
	for k1 in arg1.inputs, nil do
		table.insert(tbl1, k1)
	end

	for k2, v1 in tbl1, nil do
		arg1:_release(v1, true)
	end
end

tbl1._begin = function(arg1, arg2, arg3)
	if not arg1.enabled or (var2.MenuIsOpen or (var1:GetFocusedTextBox() or arg1.inputs[arg3])) then
		return
	end

	if arg3.UserInputType ~= Enum.UserInputType.Touch and arg3.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	local var3 = arg2.count + 1
	arg2.count = var3
	local tbl1 = {
		entry = arg2,
		connection = arg3:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if arg3.UserInputState == Enum.UserInputState.End or arg3.UserInputState == Enum.UserInputState.Cancel then
				arg1:_release(arg3)
			end
		end),
	}

	arg1.inputs[arg3] = tbl1
	arg1:_paint(arg2, true)
	var4.Play("Click")
end

tbl1._hide = function(arg1, arg2, arg3)
	if not arg2 or arg1.hidden[arg2] then
		return
	end

	local tbl1 = {
		property = arg3,
		value = arg2[arg3],
		connection = arg2:GetPropertyChangedSignal(arg3):Connect(function()
			if arg1.nativeSuppressed and arg2[arg3] ~= false then
				arg2[arg3] = false
			end
		end),
	}

	arg1.hidden[arg2] = tbl1
	arg2[arg3] = false
end

tbl1._hideNativeAndHud = function(arg1)
	local var2 = arg1.player:FindFirstChildOfClass("PlayerGui")
	if not var2 then
		return
	end

	local var3 = var2:FindFirstChild("HUD")
	local var4 = var3
	arg1:_hide(var4 and var3:FindFirstChild("BottomLeft"), "Visible")
	local var6 = var2:FindFirstChild("TouchGui")
	if var6 then
		arg1:_hide(var6, "Enabled")
		for k1, v1 in var6:GetDescendants() do
			if not v1:IsA("GuiObject") then
				continue
			end

			if v1.Name == "TouchControlFrame" or v1.Name == "JumpButton" then
				arg1:_hide(v1, "Visible")
			end
		end
	end
end

tbl1._suppressNative = function(arg1, arg2)
	if arg1.nativeSuppressed == arg2 then
		if arg2 then
			arg1:_hideNativeAndHud()
		end

		return
	end

	arg1.nativeSuppressed = arg2
	local var1
	local var3
	if arg2 then
		arg1.previousTouchControls = var2.TouchControlsEnabled
		var2.TouchControlsEnabled = false
		arg1:_hideNativeAndHud()
		local var4 = arg1.player.Character
		var4 = var4 and arg1.player.Character:FindFirstChildOfClass("Humanoid")
		if not var4 then
			return
		end

		var4.Jump = false
		var1 = Vector3.new(0, 0, 0)
		var3 = false
		var4:Move(var1, var3)
		return
	end

	for k1, v1 in arg1.hidden, nil do
		v1.connection:Disconnect()
		if not k1.Parent then
			continue
		end

		k1[v1.property] = v1.value
	end

	table.clear(arg1.hidden)
	if arg1.previousTouchControls ~= nil then
		var2.TouchControlsEnabled = arg1.previousTouchControls
		arg1.previousTouchControls = nil
	end
end

tbl1._enable = function(arg1, arg2)
	if arg1.enabled ~= arg2 then
		arg1:Clear()
		arg1.enabled = arg2
	end

	if arg1.gui and arg1.gui.Enabled ~= arg2 then
		arg1.gui.Enabled = arg2
	end

	local var2 = arg1.player:GetAttribute("RaceFinishing")
	local var4 = arg2
	var2 = var2 or arg1.player:GetAttribute("RaceFinishCamera")
	if not var4 then
		var4 = not arg1.destroyed
		if var4 then
			var4 = var1.TouchEnabled
			if var4 then
				var4 = var1.PreferredInput == Enum.PreferredInput.Touch
			end

			if var4 then
				var4 = var2 == true
			end
		end
	end

	arg1:_suppressNative(var4)
end

tbl1._unbind = function(arg1)
	arg1:_enable(false)
	local var1 = arg1.buttonConnections
	for k1, v1 in var1, nil do
		v1:Disconnect()
	end

	table.clear(var1)
	for k2, v2 in arg1.buttons, nil do
		arg1:_paint(v2, false, true)
		if not v2.createdScale then
			continue
		end

		v2.scale:Destroy()
	end

	table.clear(arg1.buttons)
	arg1.gui = nil
	if arg1.jumpFrame and arg1.jumpFrame.Parent then
		arg1.jumpFrame.Visible = arg1.jumpVisible
	end

	arg1.jumpFrame = nil
	arg1.jumpVisible = nil
end

tbl1._bind = function(arg1, arg2, arg3, arg4, arg5, arg6)
	arg1:_unbind()
	arg1.gui = arg2
	arg2.Enabled = false
	arg1.jumpFrame = arg6.Parent
	arg1.jumpVisible = arg1.jumpFrame.Visible
	local function fn2()
		if arg2.Enabled ~= arg1.enabled then
			arg2.Enabled = arg1.enabled
		end
	end

	table.insert(arg1.buttonConnections, arg2:GetPropertyChangedSignal("Enabled"):Connect(fn2))
	for k1, v1 in { Left = arg3, Right = arg4, Accelerator = arg5, JumpOut = arg6 }, nil do
		v1:SetAttribute("UIEffectsIgnore", true)
		v1.AutoButtonColor = false
		local var1 = if k1 == "JumpOut" then v1.Parent else v1
		local var3 = var1:FindFirstChildOfClass("UIScale")
		local var5 = var3 == nil
		if not var3 then
			var3 = Instance.new("UIScale")
			var3.Name = "DrivingPressScale"
			var3.Parent = var1
		end

		local var6 = if v1:IsA("ImageButton") then v1 else var1:FindFirstChild("Studs") or v1
		local var7 = if var6:IsA("ImageLabel") or var6:IsA("ImageButton") then "ImageColor3" else "BackgroundColor3"
		local tbl1 = {
			button = v1,
			scale = var3,
			baseScale = var3.Scale,
			createdScale = var5,
			tint = var6,
			colorProperty = var7,
			color = var6[var7],
			count = 0,
		}

		arg1.buttons[k1] = tbl1
		arg1:_paint(tbl1, false, true)
		local function fn4(arg1)
			arg1:_begin(tbl1, arg1)
		end

		table.insert(arg1.buttonConnections, v1.InputBegan:Connect(fn4))
		fn4 = function()
			local tbl2 = {}
			for k1, v1 in arg1.inputs, nil do
				if v1.entry ~= tbl1 then
					continue
				end

				if k1.UserInputType ~= Enum.UserInputType.MouseButton1 then
					continue
				end

				table.insert(tbl2, k1)
			end

			for k2, v2 in tbl2, nil do
				arg1:_release(v2)
			end
		end

		table.insert(arg1.buttonConnections, v1.MouseLeave:Connect(fn4))
		if k1 ~= "JumpOut" then
			continue
		end

		fn4 = function()
			if arg1.enabled and (not var2.MenuIsOpen) then
				arg1:Clear()
				arg1.exit()
			end
		end

		table.insert(arg1.buttonConnections, v1.Activated:Connect(fn4))
	end
end

tbl1._refresh = function(arg1)
	if arg1.destroyed then
		return
	end

	local var2 = arg1.player:FindFirstChildOfClass("PlayerGui")
	local var3 = var2
	var3 = var3 and var2:FindFirstChild("Steering")
	local var4 = var3
	local var5 = var3
	var4 = var4 and var3:FindFirstChild("LeftRight")
	local var6 = var4
	local var7 = var4
	local var8 = var3
	var5 = var5 and var3:FindFirstChild("JumpOut")
	local var9 = var5
	local var10 = var3
	var6 = var6 and var4:FindFirstChild("Left")
	var7 = var7 and var4:FindFirstChild("Right")
	var8 = var8 and var3:FindFirstChild("Accelerator")
	var9 = var9 and var5:FindFirstChild("Button")
	if not (var10 and (var3:IsA("ScreenGui") and (var6 and (var6:IsA("GuiButton") and (var7 and (var7:IsA("GuiButton") and (var8 and (var8:IsA("GuiButton") and (var9 and var9:IsA("GuiButton")))))))))) then
		arg1:_unbind()
		if var3 and var3:IsA("ScreenGui") then
			var3.Enabled = false
		end

		return
	end

	if var3 ~= arg1.gui or (not arg1.buttons.Left or (arg1.buttons.Left.button ~= var6 or (arg1.buttons.Right.button ~= var7 or (arg1.buttons.Accelerator.button ~= var8 or arg1.buttons.JumpOut.button ~= var9)))) then
		arg1:_bind(var3, var6, var7, var8, var9)
	end

	local var11 = arg1.player:GetAttribute("RaceFinishing")
	local var13 = arg1.driving
	var11 = var11 or arg1.player:GetAttribute("RaceFinishCamera")
	if var13 then
		var13 = var1.TouchEnabled
		if var13 then
			var13 = var1.PreferredInput == Enum.PreferredInput.Touch
		end

		var13 = var13 and (not var11)
	end

	arg1:_enable(var13)
	local bool2 = false
	if arg1.jumpVisible ~= false then
		bool2 = not arg1.player:GetAttribute("RaceParticipant")
	end

	var5.Visible = bool2
end

tbl1.SetDriving = function(arg1, arg2)
	arg1.driving = arg2 == true
	arg1:_refresh()
end

tbl1.IsTouchDriving = function(arg1)
	local var3 = arg1.driving
	if var3 then
		var3 = var1.TouchEnabled
		if var3 then
			var3 = var1.PreferredInput == Enum.PreferredInput.Touch
		end
	end

	return var3
end

tbl1.GetAxes = function(arg1)
	if not arg1.enabled or (var2.MenuIsOpen or var1:GetFocusedTextBox()) then
		return 0, 0
	end

	local var3 = 0 < arg1.buttons.Left.count
	local var4 = 0 < arg1.buttons.Right.count
	local var5 = if 0 < arg1.buttons.Accelerator.count then 1 else 0
	local var6 = if var4 then 1 else 0
	return var5, var6 - (if var3 then 1 else 0)
end

tbl1.new = function(arg1, arg2)
	local var3 = setmetatable({
		player = arg1,
		exit = arg2,
		driving = false,
		enabled = false,
		buttons = {},
		inputs = {},
		hidden = {},
		connections = {},
		buttonConnections = {},
	}, tbl1)

	local function fn2()
		var3:_refresh()
	end

	table.insert(var3.connections, var1:GetPropertyChangedSignal("PreferredInput"):Connect(fn2))
	fn2 = function()
		var3:_refresh()
	end

	table.insert(var3.connections, var1:GetPropertyChangedSignal("TouchEnabled"):Connect(fn2))
	fn2 = function(arg1)
		var3:_release(arg1)
	end

	table.insert(var3.connections, var1.InputEnded:Connect(fn2))
	fn2 = function(arg1)
		local var6 = var3.inputs[arg1]
		local var7 = var6.entry.button
		local var8 = var7.AbsolutePosition
		local var9 = var7.AbsoluteSize
		if var6 and (arg1.UserInputType == Enum.UserInputType.Touch and (arg1.Position.X < var8.X or (var8.X + var9.X < arg1.Position.X or (arg1.Position.Y < var8.Y or var8.Y + var9.Y < arg1.Position.Y)))) then
			var3:_release(arg1)
		end
	end

	table.insert(var3.connections, var1.InputChanged:Connect(fn2))
	fn2 = function()
		var3:Clear()
	end

	table.insert(var3.connections, var1.WindowFocusReleased:Connect(fn2))
	fn2 = function()
		var3:Clear()
	end

	table.insert(var3.connections, var2.MenuOpened:Connect(fn2))
	fn2 = function()
		var3:Clear()
	end

	table.insert(var3.connections, var1.TextBoxFocused:Connect(fn2))
	fn2 = function()
		if var3.nativeSuppressed and var2.TouchControlsEnabled then
			var2.TouchControlsEnabled = false
		end
	end

	table.insert(var3.connections, var2:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(fn2))
	local tbl2 = {
		PlayerGui = true,
		Steering = true,
		LeftRight = true,
		Left = true,
		Right = true,
		Accelerator = true,
		JumpOut = true,
		Button = true,
		HUD = true,
		BottomLeft = true,
		TouchGui = true,
		TouchControlFrame = true,
		JumpButton = true,
	}

	local function changed(arg1)
		if not tbl2[arg1.Name] or var3.refreshPending then
			return
		end

		var3.refreshPending = true
		task.defer(function()
			var3.refreshPending = false
			var3:_refresh()
		end)
	end

	local var4 = changed
	table.insert(var3.connections, arg1.DescendantAdded:Connect(var4))
	var4 = changed
	table.insert(var3.connections, arg1.DescendantRemoving:Connect(var4))
	local function fn5()
		var3:SetDriving(false)
	end

	table.insert(var3.connections, arg1.CharacterRemoving:Connect(fn5))
	fn2 = "RaceFinishing"
	for k1, v1 in { "RaceParticipant", fn2, "RaceFinishCamera" }, nil do
		local function fn7()
			var3:_refresh()
		end

		table.insert(var3.connections, arg1:GetAttributeChangedSignal(v1):Connect(fn7))
	end

	var3:_refresh()
	return var3
end

tbl1.Destroy = function(arg1)
	arg1.destroyed = true
	arg1:_unbind()
	local var1 = arg1.connections
	for k1, v1 in var1, nil do
		v1:Disconnect()
	end

	table.clear(var1)
end

return tbl1

--- ReplicatedStorage.Modules.RaceSteerAssist [ModuleScript]
-- y u r i

local tbl1 = { Target = function(arg1, arg2, arg3, arg4, arg5)
	local var2 = arg1[arg2]
	if not var2 or (not var2.Parent) then
		return nil
	end

	local var3 = var2.Position
	local var5 = Vector3.new(var3.X, 0, var3.Z)
	if 1 < arg2 then
		local var6 = arg1[arg2 - 1].Position
		var3 = Vector3.new(var6.X, 0, var6.Z)
	else
		local var7 = var2.CFrame.LookVector
		var3 = var5 - Vector3.new(var7.X, 0, var7.Z) * 100
	end

	local var8 = var5 - var3
	if var8.Magnitude < 0.01 then
		return nil
	end

	local var9 = arg3.Position
	local var10 = Vector3.new(var9.X, 0, var9.Z)
	local var11 = var8.Unit
	var9 = var3 + var11 * math.clamp((var10 - var3):Dot(var11), 0, var8.Magnitude)
	local var12 = (var10 - var9):Dot((Vector3.new(-var11.Z, 0, var11.X)))
	local var13 = var2.Size.X * 0.5
	if var13 - 2 < math.abs(var12) or 12 < math.abs(arg3.Position.Y - var2.Position.Y) then
		return nil
	end

	local var17 = math.clamp(12 + arg4 * arg5, 22, 95)
	local var18 = (var5 - var9).Magnitude
	local var19 = nil
	local var20 = arg2
	if var17 <= var18 then
		var19 = var9 + var11 * var17
	else
		var17 = var17 - var18
		var19 = var5
		while true do
			if var20 >= (#arg1) or 0 >= var17 then
				break
			end

			local var21 = arg1[var20 + 1].Position
			local var22 = Vector3.new(var21.X, 0, var21.Z)
			var21 = var22 - var19
			if 0.01 < var21.Magnitude then
				var11 = var21.Unit
				if var17 <= var21.Magnitude then
					var19 = var19 + var11 * var17
					var17 = 0
				else
					var19 = var22
				end
			end

			var17 = var17 - var21.Magnitude
			var20 = var20 + 1
		end
	end

	return var19 + Vector3.new(-var11.Z, 0, var11.X) * math.clamp(var12 * 0.7, -var13 * 0.65, var13 * 0.65)
end }

tbl1.Step = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if not arg1 then
		return arg5
	end

	if not arg8 or (arg8.Enabled == false or arg8.MobileOnly and arg6 ~= true) then
		arg1.Correction = 0
		return arg5
	end

	local var1 = arg2.LookVector
	local var3 = Vector3.new(arg3.X, 0, arg3.Z):Dot((Vector3.new(var1.X, 0, var1.Z)))
	if arg4 <= 0.05 or var3 < 5 then
		arg1.Correction = 0
		return arg5
	end

	local var5 = tbl1.Target(arg1.Gates, arg1.NextGate, arg2, var3, arg8.LookAheadSeconds)
	if not var5 then
		arg1.Correction = 0
		return arg5
	end

	local var6 = arg2.Position
	local var7 = arg2:VectorToObjectSpace(var5 - Vector3.new(var6.X, 0, var6.Z))
	var1 = math.atan2(var7.X, -var7.Z)
	local var8 = 1 - math.clamp((math.abs(var1) - 1.0471975511965976) / 0.69813170079773179, 0, 1)
	local var9 = math.clamp(var1 / (math.max(0.3, arg8.LookAheadSeconds) * math.rad(arg9)), -0.3, 0.3)
	var6 = if arg6 then arg8.MobileStrength else arg8.Strength
	local var10 = if arg6 then arg8.MobileMaxCorrection else arg8.MaxCorrection
	local var11 = (arg1.Correction or 0) + (math.clamp((var9 - arg5) * var6 * var8 * (if arg5 * var9 < -0.001 then 0.25 else 1), -var10, var10) - (arg1.Correction or 0)) * (1 - math.exp(math.clamp(arg7, 0, 0.1) * -8))
	arg1.Correction = var11
	return (math.clamp(arg5 + arg1.Correction, -1, 1))
end

return tbl1

--- ReplicatedStorage.Modules.RaceFinishPresentation [ModuleScript]
-- y u r i

local var1 = game:GetService("TweenService")
local var2 = game:GetService("SoundService")
local var3 = nil
local var4 = game:GetService("RunService")
local var5 = game:GetService("Lighting")
local var6 = game:GetService("Players").LocalPlayer
local tbl1 = {
	IsActive = function()
		return var3 ~= nil
	end,
	Stop = function()
		local var2 = var3
		if not var2 then
			return
		end

		var3 = nil
		var4:UnbindFromRenderStep("RaceFinishReplayCamera")
		for k1, v1 in var2.tweens, nil do
			v1:Cancel()
		end

		if var2.clone then
			var2.clone:Destroy()
		end

		if var2.blur then
			var2.blur:Destroy()
		end

		for k2, v2 in var2.hidden, nil do
			if not k2.Parent then
				continue
			end

			k2.LocalTransparencyModifier = v2
		end

		for k3, v3 in var2.screens, nil do
			if not k3.Parent then
				continue
			end

			k3.Enabled = v3
		end

		if var2.panel and var2.panel.Parent then
			var2.panel.Visible = false
		end

		if var2.scale then
			var2.scale.Scale = 1
		end

		var6:SetAttribute("RaceFinishCamera", nil)
		local var5 = var6.Character
		local var7 = var5
		local var8 = var5
		local var10 = workspace.CurrentCamera
		var7 = var7 and var5:FindFirstChildOfClass("Humanoid")
		var8 = var8 and var5:FindFirstChild("HumanoidRootPart")
		if var10 and var7 then
			var10.CameraSubject = var7
			var10.CameraType = Enum.CameraType.Custom
			if var8 then
				local var12 = var8.Position + Vector3.new(0, 2, 0)
				var10.CFrame = CFrame.lookAt(var12 + Vector3.new(0, 8, 18), var12)
				var10.Focus = CFrame.new(var12)
			end
		end
	end,
}

local function sound(arg1, arg2)
	local var1 = var2:FindFirstChild("Race")
	local var3 = var1
	var3 = var3 and var1:FindFirstChild(arg1)
	if var3 then
		local var4 = var3:Clone()
		var4.PlaybackSpeed = arg2 or 1
		var4.Parent = var2
		var2:PlayLocalSound(var4)
		game:GetService("Debris"):AddItem(var4, 5)
	end
end

tbl1.Play = function(arg1, arg2)
	tbl1.Stop()
	if type(arg1) ~= "table" or (typeof(arg1.CarCF) ~= "CFrame" or typeof(arg1.FinishCF) ~= "CFrame") then
		return
	end

	local tbl2 = { tweens = {}, hidden = {}, screens = {}, panel = arg2 }
	var3 = tbl2
	var6:SetAttribute("RaceFinishCamera", true)
	for k1, v1 in var6.PlayerGui:GetChildren() do
		if not v1:IsA("ScreenGui") then
			continue
		end

		if v1.Name == "Race" then
			continue
		end

		if v1.Name == "Steering" then
			continue
		end

		if v1.Name == "TouchGui" then
			continue
		end

		if v1.Name == "BackpackGui" then
			continue
		end

		tbl2.screens[v1] = v1.Enabled
		v1.Enabled = false
	end

	local var2 = arg1.FinishCF
	local var7 = var2.LookVector
	local var8 = arg1.CarCF.Position - var7 * (arg1.CarCF.Position - var2.Position):Dot(var7)
	local var9 = arg1.Car
	local var10 = var9:Clone()
	local var11 = CFrame.new(var8 - var7 * 18) * arg1.CarCF.Rotation
	local var12 = CFrame.new(var8 + var7 * 22) * arg1.CarCF.Rotation
	if typeof(var9) == "Instance" and (var9:IsA("Model") and var10) then
		var10.Name = "RaceFinishReplay"
		tbl2.clone = var10
		var10:SetAttribute("RaceVehicle", nil)
		var10:SetAttribute("DriverUserId", nil)
		for k2, v2 in var10:GetDescendants() do
			if v2:IsA("LuaSourceContainer") or (v2:IsA("JointInstance") or (v2:IsA("Constraint") or (v2:IsA("WeldConstraint") or (v2:IsA("ProximityPrompt") or (v2:IsA("LayerCollector") or v2:IsA("Sound")))))) then
				v2:Destroy()
			else
				if not v2:IsA("BasePart") then
					continue
				end

				v2.Anchored = true
				v2.CanCollide = false
				v2.CanTouch = false
				v2.CanQuery = false
				v2.LocalTransparencyModifier = 0
			end
		end

		var10:PivotTo(var11)
		var10.Parent = workspace
		for k3, v3 in var9:GetDescendants() do
			if not v3:IsA("BasePart") then
				continue
			end

			tbl2.hidden[v3] = v3.LocalTransparencyModifier
			v3.LocalTransparencyModifier = 1
		end
	end

	local var13 = os.clock()
	var10 = var8 + var2.RightVector * 27 + Vector3.new(0, 12, 0) + var7 * 12
	var4:BindToRenderStep("RaceFinishReplayCamera", Enum.RenderPriority.Camera.Value + 10, function()
		if var3 ~= tbl2 then
			return
		end

		local var2 = var11:Lerp(var12, 1 - (1 - math.clamp((os.clock() - var13) / 1.25, 0, 1)) ^ 2)
		if tbl2.clone then
			tbl2.clone:PivotTo(var2)
		end

		local var5 = workspace.CurrentCamera
		if var5 then
			var5.CameraType = Enum.CameraType.Scriptable
			local var6 = var2.Position + Vector3.new(0, 1.5, 0)
			var5.CFrame = CFrame.lookAt(var10, var6)
			var5.Focus = CFrame.new(var6)
		end
	end)

	task.delay(0.75, function()
		if var3 ~= tbl2 then
			return
		end

		local var2 = Instance.new("BlurEffect")
		var2.Name = "RaceFinishBlur"
		var2.Size = 0
		var2.Parent = var5
		tbl2.blur = var2
		local var4 = var1:Create(var2, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = 18 })
		table.insert(tbl2.tweens, var4)
		var4:Play()
		if arg2 and arg2.Parent then
			arg2.AnchorPoint = Vector2.new(0.5, 0.5)
			arg2.Position = UDim2.fromScale(0.5, 0.5)
			local var7 = arg2:FindFirstChild("Place")
			if var7 then
				local var8 = math.max(1, (math.floor(tonumber(arg1.Place) or 1)))
				if 11 <= var8 % 100 and var8 % 100 <= 13 then
					var4 = "th"
				else
					if var8 % 10 == 1 then
						var4 = "st"
					else
						if var8 % 10 == 2 then
							var4 = "nd"
						else
							var4 = if var8 % 10 == 3 then "rd" else "th"
						end
					end
				end

				var7.Text = tostring(var8) .. var4
				local var9
				if var8 == 1 then
					var9 = Color3.fromRGB(255, 210, 35)
				elseif var8 == 2 then
					var9 = Color3.fromRGB(220, 235, 255)
				elseif var8 == 3 then
					var9 = Color3.fromRGB(255, 145, 55)
				else
					var9 = Color3.new(1, 1, 1)
				end

				var7.TextColor3 = var9
			end

			local var10 = arg2:FindFirstChild("FinishPopScale")
			var10 = var10 or Instance.new("UIScale")
			var10.Name = "FinishPopScale"
			var10.Parent = arg2
			tbl2.scale = var10
			var10.Scale = 0.55
			arg2.Visible = true
			local var11 = Enum.EasingStyle.Back
			local var12 = var1:Create(var10, TweenInfo.new(0.4, var11 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 })
			table.insert(tbl2.tweens, var12)
			var12:Play()
		end

		local var13 = sound
		local var14 = if arg1.Place == 1 then "FinishWin" else "Finish"
		if arg1.Place == 2 then
			var4 = 1.08
		elseif arg1.Place == 3 then
			var4 = 1
		else
			var4 = 0.95
		end

		var13(var14, var4)
	end)

	task.delay(math.clamp(tonumber(arg1.Duration) or 4, 1, 10) + 2, function()
		if var3 == tbl2 then
			tbl1.Stop()
		end
	end)
end

local var7 = nil
local var8 = nil
local var9 = nil
tbl1.Lap = function(arg1)
	if var7 then
		var7:Cancel()
	end

	if var8 and (var8.Parent and var9) then
		var8.TextColor3 = var9
	end

	var8 = arg1
	local var2 = arg1
	var9 = var2 and arg1.TextColor3
	if arg1 then
		arg1.TextColor3 = Color3.fromRGB(255, 40, 45)
		local var3 = TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		var7 = var1:Create(arg1, var3, { TextColor3 = var9 })
		var7:Play()
	end

	sound("LapPing", 1.15)
end

return tbl1

--- ReplicatedStorage.Modules.RaceBurnoutEffects [ModuleScript]
-- y u r i

local tbl1 = { CollectRear = function(arg1)
	local var3 = arg1:FindFirstChild("Wheels")
	local var4 = arg1:FindFirstChild("Chassis")
	if not var3 or (not var4) then
		return nil
	end

	local tbl1 = {}
	for k1, v1 in arg1:GetDescendants() do
		if not v1:IsA("WeldConstraint") then
			if not v1:IsA("JointInstance") then
				continue
			end
		end

		local var5 = v1.Part0
		local var6 = v1.Part1
		if not var5 or (not var6) then
			continue
		end

		local var7 = tbl1[var5]
		tbl1[var5] = var7 or {}
		var7 = tbl1[var6]
		tbl1[var6] = var7 or {}
		table.insert(tbl1[var5], var6)
		table.insert(tbl1[var6], var5)
	end

	local str1 = "RR"
	local tbl2 = {}
	for k2, v2 in { "RL", str1 }, nil do
		local var9 = var3:FindFirstChild(v2)
		if not var9 then
			return nil
		end

		local tbl3 = { [var9] = true }
		local tbl4 = { var9 }
		local num1 = 1
		local tbl5 = {}
		while true do
			if not tbl4[num1] then
				break
			end

			local var10 = tbl4[num1]
			if var10 == var4 or var10 == arg1:FindFirstChild("DriverSeat") then
				return nil
			end

			if var10:IsDescendantOf(arg1) and var10.Transparency < 1 then
				table.insert(tbl5, var10)
			end

			local var11 = tbl1[var10]
			for k3, v3 in var11 or {}, nil do
				if tbl3[v3] then
					continue
				end

				tbl3[v3] = true
				table.insert(tbl4, v3)
			end

			num1 = num1 + 1
		end

		if #tbl5 == 0 then
			return nil
		end

		table.insert(tbl2, { Wheel = var9, Parts = tbl5 })
	end

	return tbl2
end }

tbl1.Start = function(arg1)
	local var2 = tbl1.CollectRear(arg1)
	if not var2 then
		return nil
	end

	local str1 = "RaceOwnerUserId"
	local var3 = arg1:GetAttribute(str1)
	local var4 = Instance.new("Model")
	var4.Name = "CountdownBurnout_" .. tostring(var3 or arg1.Name)
	local var5 = arg1.Chassis
	local tbl2 = { Car = arg1, Chassis = var5, Folder = var4, Rows = {}, Smoke = {}, Phase = 0 }
	for k1, v1 in var2, nil do
		local var6 = var5.CFrame:PointToObjectSpace(v1.Wheel.Position)
		for k2, v2 in v1.Parts, nil do
			local var7 = v2:Clone()
			if not var7 then
				continue
			end

			for k3, v3 in var7:GetDescendants() do
				if v3:IsA("BasePart") or (v3:IsA("Constraint") or (v3:IsA("JointInstance") or (v3:IsA("LuaSourceContainer") or (v3:IsA("Attachment") or (v3:IsA("ParticleEmitter") or (v3:IsA("Light") or v3:IsA("Sound"))))))) then
					v3:Destroy()
				end
			end

			var7.Name = "SpinningRearWheel"
			var7.Anchored = true
			var7.CanCollide = false
			var7.CanTouch = false
			var7.CanQuery = false
			var7.CastShadow = false
			var7.LocalTransparencyModifier = 0
			var7.Parent = var4
			local tbl3 = { Source = v2, Copy = var7, Pivot = var6, Local = var5.CFrame:ToObjectSpace(v2.CFrame) }
			tbl3.Transparency = v2.LocalTransparencyModifier
			table.insert(tbl2.Rows, tbl3)
			v2.LocalTransparencyModifier = 1
		end

		local var8 = Instance.new("Part")
		var8.Name = "RearTyreSmoke"
		var8.Size = Vector3.new(0.1, 0.1, 0.1)
		var8.Transparency = 1
		var8.Anchored = true
		var8.CanCollide = false
		var8.CanTouch = false
		var8.CanQuery = false
		var8.CastShadow = false
		var8.Parent = var4
		local var9 = Instance.new("ParticleEmitter")
		var9.Name = "CountdownSmoke"
		var9.Texture = "rbxasset://textures/particles/smoke_main.dds"
		local num1 = 132
		local num2 = 145
		local num3 = 163
		var9.Color = ColorSequence.new(Color3.fromRGB(210, 220, 232), Color3.fromRGB(num1, num2, num3))
		num3 = 1
		local num4 = 1
		var9.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.35),
			NumberSequenceKeypoint.new(0.3, 0.55),
			NumberSequenceKeypoint.new(num3, num4),
		})

		num3 = 1
		num4 = 5
		var9.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.4),
			NumberSequenceKeypoint.new(0.4, 3),
			NumberSequenceKeypoint.new(num3, num4),
		})

		var9.Lifetime = NumberRange.new(0.6, 1.05)
		var9.Rate = 38
		var9.Speed = NumberRange.new(6, 11)
		var9.Drag = 2
		var9.EmissionDirection = Enum.NormalId.Back
		var9.SpreadAngle = Vector2.new(22, 25)
		var9.Acceleration = Vector3.new(0, 3, 0)
		var9.Rotation = NumberRange.new(0, 360)
		var9.RotSpeed = NumberRange.new(-40, 40)
		var9.LightInfluence = 0.25
		var9.LightEmission = 0.05
		var9.Parent = var8
		local var10 = v1.Wheel.Size.Y
		local tbl4 = { Part = var8, Emitter = var9, Offset = var6 + Vector3.new(0, -var10 * 0.38, 1) }
		table.insert(tbl2.Smoke, tbl4)
	end

	local var11 = workspace.CurrentCamera
	var4.Parent = var11 or workspace
	tbl1.Step(tbl2, 0)
	return tbl2
end

tbl1.Step = function(arg1, arg2)
	local var1 = arg2
	local var2 = (arg1.Phase + math.min(var1, 0.1) * 20) % 6.2831853071795862
	arg1.Phase = var2
	var2 = arg1.Chassis.CFrame
	for k1, v1 in arg1.Rows, nil do
		if v1.Source.Parent then
			v1.Source.LocalTransparencyModifier = 1
		end

		v1.Copy.CFrame = var2 * CFrame.new(v1.Pivot) * CFrame.Angles(-arg1.Phase, 0, 0) * CFrame.new(-v1.Pivot) * v1.Local
	end

	for k2, v2 in arg1.Smoke, nil do
		v2.Part.CFrame = var2 * CFrame.new(v2.Offset)
	end
end

tbl1.Stop = function(arg1)
	if arg1.Stopped then
		return
	end

	arg1.Stopped = true
	for k1, v1 in arg1.Rows, nil do
		if v1.Source.Parent then
			v1.Source.LocalTransparencyModifier = v1.Transparency
		end

		v1.Copy:Destroy()
	end

	for k2, v2 in arg1.Smoke, nil do
		v2.Emitter.Enabled = false
	end

	task.delay(1.1, function()
		arg1.Folder:Destroy()
	end)
end

return tbl1

--- ReplicatedStorage.Modules.PlaytimeFormatter [ModuleScript]
-- y u r i

return { Format = function(arg1)
	local var2 = tonumber(arg1)
	if var2 then
		if var2 ~= var2 or math.abs(var2) == math.huge then
			var2 = 0
		end
	end

	var2 = math.clamp(math.floor(var2), 0, 9007199254740991)
	local var7 = math.floor(var2 / 86400)
	local var8 = math.floor(var2 / 3600) % 24
	local var9 = math.floor(var2 / 60) % 60
	if 0 < var7 then
		local str2 = "%dd %02dh"
		local var10 = var7
		local var11 = var8
		return string.format(str2, var10, var11)
	end

	if 0 < var8 then
		local str4 = "%dh %02dm"
		local var14 = var8
		local var15 = var9
		return string.format(str4, var14, var15)
	end

	if 0 < var9 then
		local str6 = "%dm %02ds"
		local var18 = var9
		local var19 = var2 % 60
		return string.format(str6, var18, var19)
	end

	local str7 = "%ds"
	local var20 = var2
	return string.format(str7, var20)
end }

--- ReplicatedStorage.Modules.MinotaurAnimator [ModuleScript]
-- y u r i

local tbl1 = {}
tbl1.__index = tbl1
local var1 = nil
local function loadClips()
	if var1 then
		return var1
	end

	local var2 = game.ReplicatedStorage.Assets:FindFirstChild("ChaserAnimations")
	local var3 = var2
	var3 = var3 and var2:FindFirstChild("Minotaur")
	if not var3 then
		return nil
	end

	local str1 = "Sleep"
	local tbl1 = { RigScale = var3:GetAttribute("RigScale") }
	for k1, v1 in { "Chase", str1 }, nil do
		local var5 = var3:FindFirstChild(v1)
		if not var5 then
			return nil
		end

		local var6 = var5:GetKeyframes()
		if #var6 ~= var5:GetAttribute("FrameCount") then
			return nil
		end

		table.sort(var6, function(arg1, arg2)
			return arg1.Time < arg2.Time
		end)

		local tbl2 = {}
		for k2, v2 in var6, nil do
			local tbl3 = {}
			for k3, v3 in v2:GetDescendants() do
				if not v3:IsA("Pose") then
					continue
				end

				if v3.Name == "MinotaurBody" then
					continue
				end

				tbl3[v3.Name] = v3.CFrame
			end

			local num1 = 0
			for k4 in tbl3, nil do
				num1 = num1 + 1
			end

			if num1 ~= var3:GetAttribute("BoneCount") then
				return nil
			end

			local var7 = v2.Time
			table.insert(tbl2, { Time = var7, Bones = tbl3 })
		end

		if #tbl2 < 2 or tbl2[#tbl2].Time <= 0 then
			return nil
		end

		tbl1[v1] = { Frames = tbl2, Duration = tbl2[#tbl2].Time }
	end

	var1 = tbl1
	return tbl1
end

tbl1.new = function(arg1)
	local var2 = loadClips()
	if not var2 then
		return nil
	end

	local tbl2 = {}
	for k1, v1 in arg1:GetDescendants() do
		if not v1:IsA("Bone") then
			continue
		end

		tbl2[v1.Name] = v1
	end

	local var3 = var2.Chase.Frames
	for k2 in var3[1].Bones, nil do
		if tbl2[k2] then
			continue
		end

		return nil
	end

	return (setmetatable({
		Model = arg1,
		Bones = tbl2,
		Clips = var2,
		Time = 0,
		Blend = 1,
		State = nil,
		Previous = {},
	}, tbl1))
end

tbl1.Sample = function(arg1, arg2, arg3)
	local var1 = assert(arg1.Clips[arg2], "Unknown minotaur clip")
	local var2 = var1.Frames
	local var3 = arg3 % var1.Duration
	local var4 = math.min(#var2 - 1, math.floor(var3 / var1.Duration * (#var2 - 1)) + 1)
	local var5 = var2[var4]
	local var6 = var2[var4 + 1]
	local var7 = math.clamp((var3 - var5.Time) / (var6.Time - var5.Time), 0, 1)
	local tbl1 = {}
	local var8 = arg1.Model:GetScale() / arg1.Clips.RigScale
	for k1, v1 in var5.Bones, nil do
		local var9 = v1:Lerp(var6.Bones[k1] or v1, var7)
		tbl1[k1] = CFrame.new(var9.Position * var8) * var9.Rotation
	end

	return tbl1
end

tbl1.SetState = function(arg1, arg2, arg3)
	if arg1.State == arg2 then
		return
	end

	arg1.Previous = {}
	for k1, v1 in arg1.Bones, nil do
		arg1.Previous[k1] = v1.Transform
	end

	arg1.State = arg2
	arg1.Time = 0
	arg1.Blend = if arg3 then 1 else 0
end

tbl1.Step = function(arg1, arg2, arg3, arg4, arg5)
	arg1:SetState(arg3, arg5)
	local var1 = arg1.Time + math.max(0, arg2) * math.clamp(arg4 or 1, 0, 3)
	arg1.Time = var1
	var1 = math.min(1, arg1.Blend + math.max(0, arg2) / 0.35)
	arg1.Blend = var1
	local var2 = arg1.Blend
	local var3 = arg1.Time
	var1 = arg1.Blend * arg1.Blend * (3 - 2 * var2)
	for k1, v1 in arg1:Sample(arg3, var3) do
		local var4 = arg1.Bones[k1]
		if not var4 then
			continue
		end

		if not var4.Parent then
			continue
		end

		local var5 = arg1.Previous[k1]
		var4.Transform = (var5 or CFrame.identity):Lerp(v1, var1)
	end
end

tbl1.Reset = function(arg1)
	for k1, v1 in arg1.Bones, nil do
		if not v1.Parent then
			continue
		end

		v1.Transform = CFrame.identity
	end
end

return tbl1

--- ReplicatedStorage.Modules.LeaderboardStoreNames [ModuleScript]
-- y u r i

local tbl1 = { MaxLength = 50 }
tbl1.Resolve = function(arg1, arg2, arg3)
	local var1 = nil
	if arg2 == "Money" then
		var1 = if arg1.MoneyMetric == "Income" then "IncomePacked" else "CashPacked"
	elseif arg2 == "Speed" then
		var1 = "Speed"
	elseif arg2 == "Playtime" then
		var1 = if arg3 then "Playtime" else "PlaytimeSeconds"
	else
		return nil, "Unknown leaderboard metric: " .. tostring(arg2)
	end

	if type(arg1.Namespace) ~= "string" or arg1.Namespace == "" then
		return nil, "Missing leaderboard namespace"
	end

	local var2 = arg3 and arg1.StudioSuffix or ""
	if type(var2) ~= "string" then
		return nil, "Invalid Studio leaderboard suffix"
	end

	local var3 = arg1.Namespace .. "-" .. var1 .. var2
	if tbl1.MaxLength < (#var3) then
		return nil, "Leaderboard datastore name exceeds 50 characters (" .. (#var3) .. "): " .. arg2
	end

	return var3
end

return tbl1

--- ReplicatedStorage.Modules.ShopCosmetics [ModuleScript]
-- y u r i

local num1 = 255
local num2 = 218
local num3 = 35
local var1 = ColorSequenceKeypoint.new(0, Color3.fromRGB(num1, num2, num3))
num2 = 255
num3 = 255
local num4 = 255
local var2 = ColorSequenceKeypoint.new(0.48, Color3.fromRGB(num2, num3, num4))
num3 = 255
num4 = 132
local num5 = 20
num1 = 1
local var3 = ColorSequence.new({ var1, var2, ColorSequenceKeypoint.new(num1, Color3.fromRGB(num3, num4, num5)) })
local num6 = 1
local num7 = 1
local var4 = game:GetService("CollectionService")
local var5 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.35, 1),
	NumberSequenceKeypoint.new(0.44, 0.85),
	NumberSequenceKeypoint.new(0.5, 0.4),
	NumberSequenceKeypoint.new(0.56, 0.85),
	NumberSequenceKeypoint.new(0.65, 1),
	NumberSequenceKeypoint.new(num6, num7),
})

var1 = function(arg1)
	local var1 = arg1:FindFirstChild("List")
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("2_StarterPack")
	if not var2 then
		return
	end

	local var6 = var2:FindFirstChild("UIGradient")
	if not var6 or (not var6:IsA("UIGradient")) then
		return
	end

	var2.BackgroundColor3 = Color3.new(1, 1, 1)
	var6.Color = var3
	var6.Transparency = NumberSequence.new(0)
	var6.Enabled = true
	var6.Offset = Vector2.zero
	var6.Rotation = 15
	var6:SetAttribute("GradientStyle", "ShopStarterPack")
	var6:SetAttribute("GradientPhase", 0.6)
	var4:AddTag(var6, "CarRarityGradient")
end

var2 = function(arg1)
	local var2 = arg1:FindFirstChild("ShopShineOverlay")
	if var2 and (not var2:IsA("Frame")) then
		return nil
	end

	if not var2 then
		var2 = Instance.new("Frame")
		var2.Name = "ShopShineOverlay"
		var2:SetAttribute("ShopCosmetic", true)
		var2.Parent = arg1
	end

	var2.AnchorPoint = Vector2.zero
	var2.Position = UDim2.fromScale(0, 0)
	var2.Size = UDim2.fromScale(1, 1)
	var2.AutomaticSize = Enum.AutomaticSize.None
	var2.BackgroundColor3 = Color3.new(1, 1, 1)
	var2.BackgroundTransparency = 0.12
	var2.BorderSizePixel = 0
	var2.Active = false
	var2.Selectable = false
	var2.ZIndex = arg1.ZIndex + 1
	var2.Visible = false
	local var3 = arg1:FindFirstChildOfClass("UICorner")
	var3 = var3 or arg1.Parent:FindFirstChildOfClass("UICorner")
	if var3 then
		local var4 = var2:FindFirstChildOfClass("UICorner")
		var4 = var4 or Instance.new("UICorner")
		var4.CornerRadius = var3.CornerRadius
		var4.Parent = var2
	end

	local var6 = var2:FindFirstChildOfClass("UIGradient")
	var6 = var6 or Instance.new("UIGradient")
	var6.Name = "WhiteGlint"
	local num1 = 1
	local num2 = 1
	local num3 = 1
	var6.Color = ColorSequence.new(Color3.new(num1, num2, num3))
	var6.Transparency = var5
	var6.Rotation = 20
	var6.Offset = Vector2.new(-1.35, 0)
	var6.Parent = var2
	for k1, v1 in arg1.Parent:GetDescendants() do
		if v1:IsDescendantOf(var2) then
			continue
		end

		if v1:IsA("GuiButton") then
			continue
		end

		if v1:IsA("TextLabel") or v1:IsA("ImageLabel") and v1.Name ~= "Studs" then
			local var7 = math.max(v1.ZIndex, var2.ZIndex + 1)
			v1.ZIndex = var7
		end
	end

	return { button = arg1, overlay = var2, gradient = var6 }
end

local var6 = game:GetService("RunService")
local tbl1 = { Configure = function(arg1)
	var1(arg1)
	local tbl1 = {}
	for k1, v1 in arg1:GetDescendants() do
		local var3 = v1:IsA("GuiButton")
		if not var3 then
			continue
		end

		table.insert(tbl1, v1)
	end

	table.sort(tbl1, function(arg1, arg2)
		return arg1:GetFullName() < arg2:GetFullName()
	end)

	local tbl2 = {}
	for k2, v2 in tbl1, nil do
		local var4 = var2(v2)
		if not var4 then
			continue
		end

		var4.phase = (k2 - 1) * 0.17
		tbl2[v2] = var4
	end

	return tbl2
end }

local function onScreen(arg1, arg2)
	if not arg1:IsDescendantOf(arg2) then
		return false
	end

	local var1 = arg1.AbsoluteSize
	local var2 = arg1.AbsolutePosition
	if var1.X <= 0 or var1.Y <= 0 then
		return false
	end

	local var3 = arg1
	while var3 do
		if var3:IsA("GuiObject") then
			if not var3.Visible then
				return false
			end

			local var6 = var3.AbsolutePosition
			local var7 = var3.AbsoluteSize
			if var3.ClipsDescendants and (var2.X + var1.X <= var6.X or (var6.X + var7.X <= var2.X or (var2.Y + var1.Y <= var6.Y or var6.Y + var7.Y <= var2.Y))) then
				return false
			end
		else
			if var3:IsA("ScreenGui") then
				return var3.Enabled
			end
		end

		var3 = var3.Parent
	end

	return false
end

tbl1.Start = function(arg1)
	assert(var6:IsClient(), "Shop cosmetics must animate on the client")
	local bool1 = false
	local tbl2 = {}
	local var1 = tbl1.Configure(arg1)
	local num1 = 0
	local function fn2(arg1)
		if not arg1:IsA("GuiButton") then
			return
		end

		task.defer(function()
			if bool1 or (var1[arg1] or (not arg1:IsDescendantOf(arg1))) then
				return
			end

			local var4 = var2(arg1)
			if var4 then
				var4.phase = num1 % 3.8
				var1[arg1] = var4
			end
		end)
	end

	table.insert(tbl2, arg1.DescendantAdded:Connect(fn2))
	local num2 = 0
	fn2 = function(arg1)
		if not arg1.Parent or (not arg1.Visible) then
			return
		end

		local var2 = num1 + arg1
		num1 = var2
		var2 = num2 + arg1
		num2 = var2
		if num2 < 0.033333333333333333 then
			return
		end

		num2 = 0
		for k1, v1 in var1, nil do
			if not k1:IsDescendantOf(arg1) then
				if v1.overlay.Parent then
					v1.overlay.Visible = false
				end

				var1[k1] = nil
			else
				local var4 = (num1 + v1.phase) % 3.8
				local bool2 = false
				if var4 < 1.1 then
					bool2 = onScreen(k1, arg1)
				end

				v1.overlay.Visible = bool2
				if not bool2 then
					continue
				end

				v1.gradient.Offset = Vector2.new(-1.35 + 2.7 * (var4 / 1.1), 0)
			end
		end
	end

	table.insert(tbl2, var6.RenderStepped:Connect(fn2))
	local function stop()
		if bool1 then
			return
		end

		bool1 = true
		for k1, v1 in tbl2, nil do
			v1:Disconnect()
		end

		for k2, v2 in var1, nil do
			if not v2.overlay.Parent then
				continue
			end

			v2.overlay.Visible = false
		end

		table.clear(var1)
	end

	fn2 = stop
	table.insert(tbl2, arg1.Destroying:Connect(fn2))
	return stop
end

return tbl1

--- ReplicatedStorage.Modules.RaceLighting [ModuleScript]
-- y u r i

local tbl1 = { Ambient = Color3.fromRGB(132, 93, 87) }
tbl1.OutdoorAmbient = Color3.fromRGB(146, 104, 94)
local tbl2 = {
	Color = Color3.fromRGB(175, 95, 73),
	Density = 0.24,
	Haze = 1,
	Glare = 0,
	Offset = 0.05,
}

tbl2.Decay = Color3.fromRGB(77, 27, 22)
tbl1.Atmosphere = tbl2
local tbl3 = { UnderworldCalderaCircuit = tbl1 }
tbl2 = {
	Color = Color3.fromRGB(64, 180, 206),
	Density = 0.43,
	Haze = 2.1,
	Glare = 0,
	Offset = 0.05,
}

tbl2.Decay = Color3.fromRGB(8, 71, 117)
tbl3.NeonReefCircuit = { Atmosphere = tbl2 }
local tbl4 = { "Color", "Decay", "Density", "Haze", "Glare", "Offset" }
return { new = function(arg1)
	local var1 = Instance.new("ColorCorrectionEffect")
	var1.Name = "NeonReefUnderwaterTint"
	var1.TintColor = Color3.fromRGB(185, 242, 255)
	var1.Saturation = 0.12
	var1.Contrast = 0.04
	var1.Brightness = 0.015
	var1.Enabled = false
	var1.Parent = arg1
	return {
		Lighting = arg1,
		Tint = var1,
		Restore = function(arg1)
			arg1.Tint.Enabled = false
			local var1 = arg1.Snapshot
			arg1.Snapshot = nil
			arg1.Theme = nil
			if not var1 then
				return
			end

			arg1.Ambient = var1.Ambient
			arg1.OutdoorAmbient = var1.OutdoorAmbient
			for k1, v1 in var1.Atmospheres, nil do
				if not k1.Parent then
					continue
				end

				for k2, v2 in v1, nil do
					k1[k2] = v2
				end
			end
		end,
		Apply = function(arg1, arg2)
			if not tbl3[arg2] then
				arg1:Restore()
				return
			end

			if arg1.Theme ~= arg2 then
				arg1:Restore()
				arg1.Snapshot = { Ambient = arg1.Ambient, OutdoorAmbient = arg1.OutdoorAmbient, Atmospheres = {} }
				arg1.Theme = arg2
			end

			local var1 = tbl3[arg2]
			local var2 = arg1.Snapshot
			if var1.Ambient then
				arg1.Ambient = var1.Ambient
			end

			if var1.OutdoorAmbient then
				arg1.OutdoorAmbient = var1.OutdoorAmbient
			end

			local var4 = arg1:FindFirstChildOfClass("Atmosphere")
			if var4 then
				local var5
				local var6
				if not var2.Atmospheres[var4] then
					local tbl1 = {}
					for k1, v1 in tbl4, nil do
						tbl1[v1] = var4[v1]
					end

					var2.Atmospheres[var4] = tbl1
				end

				for k2, v2 in var1.Atmosphere, nil do
					var4[k2] = v2
				end
			end

			arg1.Tint.Enabled = arg2 == "NeonReefCircuit"
		end,
		Destroy = function(arg1)
			arg1:Restore()
			arg1.Tint:Destroy()
		end,
	}
end }

--- ReplicatedStorage.Modules.CarDrivingVisuals [ModuleScript]
-- y u r i

local function ClearBody(arg1)
	for k1, v1 in arg1.Connections, nil do
		v1:Disconnect()
	end

	table.clear(arg1.Connections)
	for k2, v2 in arg1.Hidden, nil do
		if not k2.Parent then
			continue
		end

		k2.LocalTransparencyModifier = v2
	end

	table.clear(arg1.Hidden)
	if arg1.Model then
		arg1.Model:Destroy()
		arg1.Model = nil
	end
end

local var1 = game:GetService("CollectionService")
local var2 = require(game.ReplicatedStorage.Configs.DrivingConfig)
local function BuildBody(arg1, arg2)
	ClearBody(arg1)
	arg1.Body = arg2
	arg1.Dirty = false
	if not arg2 then
		return
	end

	local var3 = arg2:Clone()
	if not var3 then
		return
	end

	local var4 = var3:GetDescendants()
	table.insert(var4, var3)
	local num1 = 0
	for k1, v1 in var4, nil do
		for k2, v2 in var1:GetTags(v1) do
			var1:RemoveTag(v1, v2)
		end

		if v1:IsA("LuaSourceContainer") or (v1:IsA("Constraint") or (v1:IsA("JointInstance") or (v1:IsA("WeldConstraint") or (v1:IsA("ParticleEmitter") or (v1:IsA("Trail") or (v1:IsA("Beam") or v1:IsA("Light"))))))) then
			v1:Destroy()
		else
			if v1:IsA("Sound") then
				v1.PlayOnRemove = false
				v1:Destroy()
			else
				if not v1:IsA("BasePart") then
					continue
				end

				v1.Anchored = true
				v1.CanCollide = false
				v1.CanTouch = false
				v1.CanQuery = false
				v1.Massless = true
				v1.LocalTransparencyModifier = 0
				num1 = num1 + 1
			end
		end
	end

	local function Changed()
		arg1.Dirty = true
	end

	local var5 = Changed
	table.insert(arg1.Connections, arg2.DescendantAdded:Connect(var5))
	var5 = Changed
	table.insert(arg1.Connections, arg2.DescendantRemoving:Connect(var5))
	if num1 == 0 then
		var3:Destroy()
		return
	end

	local var6 = Instance.new("Model")
	var6.Name = "DrivingBodyVisual"
	var3.Parent = var6
	var6.WorldPivot = arg1.Chassis.CFrame
	arg1.Model = var6
	local var7 = arg2:GetDescendants()
	table.insert(var7, arg2)
	for k3, v3 in var7, nil do
		if not v3:IsA("BasePart") then
			continue
		end

		arg1.Hidden[v3] = v3.LocalTransparencyModifier
		v3.LocalTransparencyModifier = 1
	end
end

return {
	Create = function(arg1)
		if var2.BodySway.Enabled == false then
			return nil
		end

		local var3 = arg1:FindFirstChild("Chassis")
		if not var3 then
			return nil
		end

		return {
			Car = arg1,
			Chassis = var3,
			Connections = {},
			Hidden = {},
			Dirty = true,
			Lean = Vector3.new(0, 0, 0),
			LeanVelocity = Vector3.new(0, 0, 0),
			Bounce = 0,
			BounceVelocity = 0,
			Throttle = 0,
			Steering = 0,
		}
	end,
	Input = function(arg1, arg2, arg3)
		if arg1 then
			if not arg1.Destroyed then
				local var1 = arg1.Chassis.Anchored
				if var1 or (arg1.Car:GetAttribute("RaceLocked") or (arg1.Car:GetAttribute("CaptureResolving") or arg1.Car:GetAttribute("AutoDriving"))) then
					return
				end
			end
		end

		arg2 = math.clamp(arg2, -1, 1)
		arg3 = math.clamp(arg3, -1, 1)
		local var3 = var2.BodySway
		local var4 = arg2 - arg1.Throttle
		local var5 = arg3 - arg1.Steering
		local var6 = 2 / var3.LeanSeconds
		local var7 = arg1.LeanVelocity + Vector3.new(var4 * var3.Pitch, 0, var5 * var3.Roll) * var6 * 1.8
		arg1.LeanVelocity = Vector3.new(math.clamp(var7.X, -var3.Pitch * var6 * 2.5, var3.Pitch * var6 * 2.5), 0, (math.clamp(var7.Z, -var3.Roll * var6 * 2.5, var3.Roll * var6 * 2.5)))
		if 0.25 < math.max(math.abs(var4), (math.abs(var5))) then
			local var9 = var3.Bounce * 3.1415926535897931 / var3.BounceSeconds * 1.8
			local var10 = math.min(arg1.BounceVelocity + var9, var9)
			arg1.BounceVelocity = var10
		end

		arg1.Throttle = arg2
		arg1.Steering = arg3
	end,
	Render = function(arg1, arg2)
		if not arg1 or (arg1.Destroyed or (not arg1.Car.Parent)) then
			return
		end

		local var3 = workspace.CurrentCamera
		if not var3 then
			return
		end

		if arg1.Camera ~= var3 then
			arg1.Camera = var3
			arg1.Dirty = true
		end

		local var5 = arg1.Car:FindFirstChild("Body")
		if arg1.Dirty or arg1.Body ~= var5 then
			BuildBody(arg1, var5)
		end

		if not arg1.Model then
			return
		end

		arg1.Model.Parent = var3
		local var6 = arg1.Chassis.Anchored
		if var6 or (arg1.Car:GetAttribute("RaceLocked") or (arg1.Car:GetAttribute("CaptureResolving") or arg1.Car:GetAttribute("AutoDriving"))) then
			arg1.Throttle = 0
			arg1.Steering = 0
		end

		local var7 = var2.BodySway
		local var8 = Vector3.new(arg1.Throttle * var7.Pitch * 0.22, 0, arg1.Steering * var7.Roll * 0.22)
		local var9 = 2 / var7.LeanSeconds
		local var10 = math.clamp(arg2 or 0.016666666666666666, 0, 0.1)
		local var11 = var9 * 0.8
		local var12 = arg1.Lean - var8
		local var13 = math.cos(var11 * var10)
		local var14 = arg1.LeanVelocity
		local var15 = math.sin(var11 * var10)
		local var16 = math.exp(-0.6 * var9 * var10)
		arg1.Lean = var8 + (var12 * var13 + (var14 + var12 * 0.6 * var9) / var11 * var15) * var16
		arg1.LeanVelocity = (var14 * var13 - (var14 * 0.6 * var9 + var12 * var9 * var9) / var11 * var15) * var16
		var9 = 3.1415926535897931 / var7.BounceSeconds
		var11 = var9 * 0.8
		var12 = arg1.Bounce - 0
		var13 = math.cos(var11 * var10)
		var14 = arg1.BounceVelocity
		var15 = math.sin(var11 * var10)
		var16 = math.exp(-0.6 * var9 * var10)
		arg1.Bounce = 0 + (var12 * var13 + (var14 + var12 * 0.6 * var9) / var11 * var15) * var16
		arg1.BounceVelocity = (var14 * var13 - (var14 * 0.6 * var9 + var12 * var9 * var9) / var11 * var15) * var16
		arg1.Model:PivotTo(arg1.Chassis.CFrame * CFrame.new(0, arg1.Bounce, 0) * CFrame.Angles(math.rad(arg1.Lean.X), 0, (math.rad(arg1.Lean.Z))))
	end,
	Destroy = function(arg1)
		if not arg1 or arg1.Destroyed then
			return
		end

		arg1.Destroyed = true
		ClearBody(arg1)
	end,
}

--- ReplicatedStorage.RaceMaps.Underworld Caldera Circuit.UnderworldLocalAtmosphere [Script]
-- y u r i

local var1 = nil
local var2 = game:GetService("Lighting")
local num1 = 0
local var3 = script.Parent
local var4 = game:GetService("Players")
local function enable()
	if var1 then
		return
	end

	local var3 = var2:FindFirstChildOfClass("Atmosphere")
	var1 = {
		Ambient = var2.Ambient,
		OutdoorAmbient = var2.OutdoorAmbient,
		Atmosphere = var3,
		Values = {},
	}

	var2.Ambient = Color3.fromRGB(132, 93, 87)
	var2.OutdoorAmbient = Color3.fromRGB(146, 104, 94)
	if var3 then
		local str1 = "Decay"
		for k1, v1 in ipairs({ "Color", str1, "Density", "Haze", "Glare", "Offset" }) do
			var1.Values[v1] = var3[v1]
		end

		var3.Color = Color3.fromRGB(175, 95, 73)
		var3.Decay = Color3.fromRGB(77, 27, 22)
		var3.Density = 0.24
		var3.Haze = 1
		var3.Glare = 0
		var3.Offset = 0.05
	end
end

local var5 = nil
var5 = game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var5 = num1 + arg1
	num1 = var5
	if num1 < 0.25 then
		return
	end

	num1 = 0
	var5 = var3:FindFirstChild("05 Molten Lava Basin")
	local var6 = var5
	local var7 = var4.LocalPlayer
	local var8 = var7
	var6 = var6 and var5:FindFirstChild("LavaBasin")
	local var11 = workspace.CurrentCamera
	var8 = var8 and (var7.Character and var7.Character:FindFirstChild("HumanoidRootPart"))
	local var12
	if var6 then
		if var11 then
			if var8 then
				if var3:IsDescendantOf(workspace) then
					local var16 = var6.CFrame:PointToObjectSpace(var8.Position)
					var12 = 780
					local bool2 = false
					if math.abs(var16.X) < var12 then
						var12 = 570
						bool2 = false
						if math.abs(var16.Z) < var12 then
							var12 = -20
							bool2 = false
							if var12 < var16.Y then
								var12 = 355
								bool2 = var16.Y < var12
							end
						end
					end

					if bool2 then
						var16 = var6.CFrame:PointToObjectSpace(var11.CFrame.Position)
						var12 = 780
						bool2 = false
						if math.abs(var16.X) < var12 then
							var12 = 570
							bool2 = false
							if math.abs(var16.Z) < var12 then
								var12 = -20
								bool2 = false
								if var12 < var16.Y then
									var12 = 355
									bool2 = var16.Y < var12
								end
							end
						end

						if bool2 then
							enable()
							return
						end
					end
				end
			end
		end
	end

	if not var1 then
		return
	end

	local var17 = var1
	var1 = nil
	var2.Ambient = var17.Ambient
	var2.OutdoorAmbient = var17.OutdoorAmbient
	if var17.Atmosphere and var17.Atmosphere.Parent then
		for k1, v1 in var17.Values, nil do
			var17.Atmosphere[k1] = v1
		end
	end
end)

script.Destroying:Connect(function()
	var5:Disconnect()
	if not var1 then
		return
	end

	local var3 = var1
	var1 = nil
	var2.Ambient = var3.Ambient
	var2.OutdoorAmbient = var3.OutdoorAmbient
	if var3.Atmosphere and var3.Atmosphere.Parent then
		for k1, v1 in var3.Values, nil do
			var3.Atmosphere[k1] = v1
		end
	end
end)

--- ReplicatedStorage.RaceMaps.Rainbow Galaxy Circuit.RainbowFlow [Script]
-- y u r i

local var1 = game:GetService("RunService")
local var2 = script.Parent
while not var2:IsDescendantOf(workspace) do
	var2.AncestryChanged:Wait()
end

local tbl1 = {}
local tbl2 = {}
local function register(arg1)
	if not arg1:IsA("BasePart") then
		return
	end

	local var1 = arg1:GetAttribute("RainbowFlowHue")
	if typeof(var1) ~= "number" then
		return
	end

	local tbl2 = { hue = math.floor(var1 * 512 + 0.5) % 512 }
	tbl2.saturation = math.floor((arg1:GetAttribute("RainbowFlowSaturation") or 0.76) * 100 + 0.5)
	tbl1[arg1] = tbl2
end

for k1, v1 in var2:GetDescendants() do
	register(v1)
end

local num1 = 1
local num2 = 0
local num3 = 0.016666666666666666
local var3 = nil
var3 = var1.Heartbeat:Connect(function(arg1)
	local var1 = num2 + arg1
	num2 = var1
	var1 = num1 + arg1
	num1 = var1
	local num4 = 0.15
	var1 = num3 + (math.min(arg1, num4) - num3) * 0.04
	num3 = var1
	var1 = if 0.025 < num3 then 0.083333333333333329 else 0.041666666666666664
	if num2 < var1 then
		return
	end

	local var3 = num2 % var1
	num2 = var3
	var3 = workspace.CurrentCamera
	if not var3 then
		return
	end

	local var4
	if 0.35 <= num1 then
		num1 = 0
		table.clear(tbl2)
		for k1, v1 in tbl1, nil do
			if not k1:IsDescendantOf(workspace) then
				continue
			end

			if (k1.Position - var3.CFrame.Position).Magnitude >= 420 then
				continue
			end

			local var5 = var3:WorldToViewportPoint(k1.Position)
			if 0 >= var5.Z then
				continue
			end

			if -120 >= var5.X then
				continue
			end

			var4 = var3.ViewportSize
			if var5.X >= var4.X + 120 then
				continue
			end

			if -120 >= var5.Y then
				continue
			end

			if var5.Y >= var4.Y + 120 then
				continue
			end

			local var6 = v1.hue * 101 + v1.saturation
			local var8 = tbl2[var6]
			if not var8 then
				var8 = { hue = v1.hue / 512, saturation = v1.saturation / 100, parts = {} }
				tbl2[var6] = var8
			end

			table.insert(var8.parts, k1)
		end
	end

	local var9 = math.max(4, var2:GetAttribute("RainbowFlowCycleSeconds") or 24)
	local var10 = workspace:GetServerTimeNow() % var9 / var9
	for k2, v2 in tbl2, nil do
		local var11 = Color3.fromHSV((v2.hue - var10) % 1, v2.saturation, 1)
		for k3, v3 in v2.parts, nil do
			if not tbl1[v3] then
				continue
			end

			v3.Color = var11
		end
	end
end)

local var4 = var2.DescendantAdded:Connect(function(arg1)
	register(arg1)
	num1 = 1
end)

local var5 = var2.DescendantRemoving:Connect(function(arg1)
	tbl1[arg1] = nil
	num1 = 1
end)

script.Destroying:Connect(function()
	var3:Disconnect()
	var4:Disconnect()
	var5:Disconnect()
end)

--- Workspace.LOBBY.SHOPS.TRAILS.Union.DashedRing.Script [Script]
-- Failed to get bytecode:
--[[
nil
--]]

--- Workspace.LOBBY.SHOPS.SELL.Union.DashedRing.Script [Script]
-- Failed to get bytecode:
--[[
nil
--]]

--- Workspace.LOBBY.DAILY REWARDS.Model.Union.DashedRing.Script [Script]
-- Failed to get bytecode:
--[[
nil
--]]

--- Workspace.Bacon.READ ME (Delete after reading) [Script]
-- Failed to get bytecode:
--[[
nil
--]]

--- Workspace.hspspjl.Health [Script]
-- Failed to get bytecode:
--[[
nil
--]]

