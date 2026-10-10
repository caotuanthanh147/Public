--- Players.LocalPlayer.PlayerScripts.PromptPolicyRunner [LocalScript]
-- y u r i

local str1 = "Policy"
require(game:GetService("ReplicatedStorage"):WaitForChild("PromptPolicy"):WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerScripts.HouseAmbience.AmbienceController [ModuleScript]
-- y u r i

local bool1 = false
local var1 = game:GetService("Players")
local var2 = game:GetService("RunService")
return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local var3 = workspace:WaitForChild("House")
	local var4 = var1.LocalPlayer
	local var5 = var3:WaitForChild("Important"):WaitForChild("HouseAmbience"):WaitForChild("Outdoors")
	local var6 = Vector3.new(inf, inf, inf)
	local var7 = Vector3.new(-inf, -inf, -inf)
	for k1, v1 in var3:WaitForChild("Parts"):WaitForChild("InteriorLayout"):WaitForChild("RoomBounds"):GetChildren() do
		local var8 = v1:GetAttribute("Min")
		if typeof(var8) ~= "Vector3" then
			continue
		end

		local var9 = v1:GetAttribute("Max")
		if typeof(var9) ~= "Vector3" then
			continue
		end

		var6 = var6:Min(var8)
		var7 = var7:Max(var9)
	end

	assert(var6.X < var7.X, "House ambience requires valid room bounds")
	local bool2 = false
	local tbl1 = {}
	local function register(arg1)
		if not arg1:IsA("Sound") or (not arg1.Looped) then
			return
		end

		if arg1.Name == "NightCrickets" then
			tbl1[arg1] = true
			if bool2 then
				if not not arg1.IsPlaying then
					return
				end

				arg1:Play()
				return
			end

			arg1:Stop()
			return
		end

		if not arg1.IsPlaying then
			arg1:Play()
		end
	end

	var5.DescendantAdded:Connect(register)
	var5.DescendantRemoving:Connect(function(arg1)
		if arg1:IsA("Sound") then
			tbl1[arg1] = nil
			arg1:Stop()
		end
	end)

	var6 = var6 - Vector3.new(0.35, 1, 0.35)
	var7 = var7 + Vector3.new(0.35, 0.5, 0.35)
	local function setOutside(arg1)
		if bool2 == arg1 then
			return
		end

		bool2 = arg1
		for k1 in tbl1, nil do
			if arg1 then
				if k1.IsPlaying then
					continue
				end

				k1:Play()
			else
				k1:Stop()
			end
		end
	end

	for k2, v2 in var5:GetDescendants() do
		register(v2)
	end

	var4.CharacterRemoving:Connect(function()
		if bool2 == false then
			return
		end

		bool2 = false
		for k1 in tbl1, nil do
			k1:Stop()
		end
	end)

	local num1 = 0
	var2.Heartbeat:Connect(function(arg1)
		local var1 = num1 + arg1
		num1 = var1
		if num1 < 0.1 then
			return
		end

		num1 = 0
		var1 = var4.Character
		local var2 = var1
		local var3 = var1
		var2 = var2 and var1:FindFirstChild("HumanoidRootPart")
		var3 = var3 and var1:FindFirstChildOfClass("Humanoid")
		if var2 then
			if not var2:IsDescendantOf(workspace) or (not var3 or var3.Health <= 0) then
				if bool2 == false then
					return
				end

				bool2 = false
				for k1 in tbl1, nil do
					k1:Stop()
				end

				return
			end
		end

		local var5 = var2.Position
		local var8 = if bool2 then 0 else 0.2
		local bool3 = false
		if var6.X - var8 <= var5.X then
			bool3 = false
			if var5.X <= var7.X + var8 then
				bool3 = false
				if var6.Y <= var5.Y then
					bool3 = false
					if var5.Y <= var7.Y then
						bool3 = false
						if var6.Z - var8 <= var5.Z then
							bool3 = var5.Z <= var7.Z + var8
						end
					end
				end
			end
		end

		setOutside(not bool3)
	end)
end }

--- Players.LocalPlayer.PlayerScripts.HouseAmbience.AmbienceRunner [LocalScript]
-- y u r i

local str1 = "AmbienceController"
require(script.Parent:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerScripts.HouseAmbience.LightBuzzController [ModuleScript]
-- y u r i

local tbl1 = {}
local bool1 = false
local var1 = game:GetService("CollectionService")
local function bind(arg1)
	if tbl1[arg1] or (not arg1:IsA("Light") or (not arg1.Parent)) then
		return
	end

	local tbl2 = { connections = {} }
	tbl1[arg1] = tbl2
	local var1 = arg1.Parent
	local str1 = "Brightness"
	local function update()
		local var3 = var1:FindFirstChild("LightBuzz")
		if tbl2.sound and tbl2.sound ~= var3 then
			tbl2.sound:Stop()
		end

		local var4 = var3 and (var3:IsA("Sound") and var3) or nil
		tbl2.sound = var4
		if not tbl2.sound then
			return
		end

		if arg1:IsDescendantOf(workspace) then
			if arg1.Enabled then
				if 0 < arg1.Brightness then
					if not not tbl2.sound.IsPlaying then
						return
					end

					tbl2.sound:Play()
					return
				end
			end
		end

		tbl2.sound:Stop()
	end

	for k1, v1 in { "Enabled", str1 }, nil do
		local var2 = update
		table.insert(tbl2.connections, arg1:GetPropertyChangedSignal(v1):Connect(var2))
	end

	local var3 = update
	table.insert(tbl2.connections, var1.ChildAdded:Connect(var3))
	var3 = update
	table.insert(tbl2.connections, var1.ChildRemoved:Connect(var3))
	var3 = function()
		if arg1.Parent == var1 then
			if not arg1:IsDescendantOf(workspace) then
				local var4 = arg1
				local var6 = tbl1[var4]
				if not var6 then
					return
				end

				tbl1[var4] = nil
				for k1, v1 in var6.connections, nil do
					v1:Disconnect()
				end

				if not var6.sound then
					return
				end

				var6.sound:Stop()
				return
			end
		end

		update()
	end

	table.insert(tbl2.connections, arg1.AncestryChanged:Connect(var3))
	update()
end

local function unbind(arg1)
	local var2 = tbl1[arg1]
	if not var2 then
		return
	end

	tbl1[arg1] = nil
	for k1, v1 in var2.connections, nil do
		v1:Disconnect()
	end

	if var2.sound then
		var2.sound:Stop()
	end
end

return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	var1:GetInstanceAddedSignal("BuzzingLight"):Connect(bind)
	var1:GetInstanceRemovedSignal("BuzzingLight"):Connect(unbind)
	for k1, v1 in var1:GetTagged("BuzzingLight") do
		bind(v1)
	end
end }

--- Players.LocalPlayer.PlayerScripts.HouseAmbience.LightBuzzRunner [LocalScript]
-- y u r i

local str1 = "LightBuzzController"
require(script.Parent:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerScripts.CatEffects.CatSleepEffects [ModuleScript]
-- y u r i

local bool1 = false
local var1 = game:GetService("CollectionService")
local var2 = game:GetService("RunService")
return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local tbl1 = {}
	var1:GetInstanceAddedSignal("CatSleepEffects"):Connect(function(arg1)
		tbl1[arg1] = { time = 0 }
	end)

	var1:GetInstanceRemovedSignal("CatSleepEffects"):Connect(function(arg1)
		local var2 = tbl1[arg1]
		if var2 and (var2.gui and var2.gui.Parent) then
			var2.gui.Enabled = false
		end

		tbl1[arg1] = nil
	end)

	for k1, v1 in var1:GetTagged("CatSleepEffects") do
		tbl1[v1] = { time = 0 }
	end

	var2.RenderStepped:Connect(function(arg1)
		for k1, v1 in tbl1, nil do
			local var3 = k1:FindFirstChild("Head")
			local var4
			local var5
			if var3 then
				if var3:FindFirstChild("SleepIndicator") then
					local var8 = var3:WaitForChild("SleepIndicator")
					if v1.gui ~= var8 then
						v1.gui = var8
						var5 = "Z3"
						local tbl2 = { var8:WaitForChild("Z1"), var8:WaitForChild("Z2"), var8:WaitForChild(var5) }
						v1.labels = tbl2
						v1.time = 0
					end

					local var10 = k1:IsDescendantOf(workspace)
					if var10 then
						var10 = false
						if k1:GetAttribute("AIState") == "Sleeping" then
							var10 = k1:GetAttribute("AIEnabled") ~= false
						end
					end

					var8.Enabled = var10
					if var10 then
						local var11 = v1.time + arg1
						v1.time = var11
						for k2, v2 in v1.labels, nil do
							local var12 = (v1.time / 2.6 + (k2 - 1) / 3) % 1
							local var13 = math.min(1, var12 / 0.16, (1 - var12) / 0.2)
							v2.Position = UDim2.new(0.3 + 0.36 * var12, 0, 0.86 - 0.7 * var12, 0)
							local var14 = 0.22 + var12 * 0.16
							v2.Size = UDim2.new(var14, 0, var14, 0)
							v2.TextTransparency = 1 - var13
							v2.TextStrokeTransparency = 1 - var13 * 0.6
							v2.Rotation = -8 + var12 * 16
						end
					else
						v1.time = 0
						continue
					end
				else
					if not v1.gui then
						continue
					end

					v1.gui.Enabled = false
					v1.gui = nil
				end
			else
				if not v1.gui then
					continue
				end

				v1.gui.Enabled = false
				v1.gui = nil
			end
		end
	end)
end }

--- Players.LocalPlayer.PlayerScripts.CatEffects.CatSleepRunner [LocalScript]
-- y u r i

local str1 = "CatSleepEffects"
require(script.Parent:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerScripts.Phone.PhoneController [ModuleScript]
-- y u r i

local var1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PhoneGui")
local var2 = var1:WaitForChild("PhoneButton")
local var3 = var1:WaitForChild("Phone")
local var4 = var3:WaitForChild("Screen")
local var5 = var4:WaitForChild("TopBar")
local str1 = "PhoneAudio"
local var6 = require(script.Parent:WaitForChild(str1))
var6.Bind(var1)
local var7 = game:GetService("TweenService")
local function bounce(arg1, arg2)
	local var2 = arg1:FindFirstChildOfClass("UIScale")
	if not var2 then
		return
	end

	local var3 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	var7:Create(var2, var3, { Scale = arg2 }):Play()
end

local var8 = var4:WaitForChild("Messages")
local var9 = var4:WaitForChild("Templates")
local num1 = 0
local var10 = var2:WaitForChild("Badge")
str1 = 0
local bool1 = false
local var11 = game:GetService("UserInputService")
local var12 = var3:WaitForChild("UIScale")
local function setBadge()
	var10.Visible = 0 < str1
	var10.Count.Text = tostring((math.min(str1, 99)))
	if 0 < str1 then
		local var3 = var10:FindFirstChildOfClass("UIScale")
		if var3 then
			var3.Scale = 0.5
			var7:Create(var3, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		end

		bounce(var2, 1.08)
		task.delay(0.2, function()
			bounce(var2, 1)
		end)

	end
end

local var13 = game:GetService("GuiService")
local var14 = var5:WaitForChild("Close")
local var15 = game:GetService("ContextActionService")
local var16 = game:GetService("ReplicatedStorage"):WaitForChild("Phone")
local var17 = var4:WaitForChild("BottomBar"):WaitForChild("Camera")
local tbl1 = {
	Open = function()
		if bool1 then
			return
		end

		bool1 = true
		var3.Visible = true
		var11.MouseIconEnabled = true
		var12.Scale = 0.7
		var7:Create(var12, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
		str1 = 0
		setBadge()
		var6.Play(var1, "Open")
		task.defer(function()
			task.wait()
			var8.CanvasPosition = Vector2.new(0, (math.max(0, var8.AbsoluteCanvasSize.Y - var8.AbsoluteWindowSize.Y)))
		end)

		if var11.GamepadEnabled and var11:GetLastInputType().Name:find("Gamepad") then
			var13.SelectedObject = var14
		end
	end,
	Close = function()
		if not bool1 then
			return
		end

		bool1 = false
		local var2 = var7:Create(var12, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.7 })
		var2:Play()
		var2.Completed:Wait()
		if not bool1 then
			var3.Visible = false
		end

		if var13.SelectedObject and var13.SelectedObject:IsDescendantOf(var3) then
			var13.SelectedObject = nil
		end

		var6.Play(var1, "Close")
	end,
}

tbl1.Toggle = function()
	if bool1 then
		tbl1.Close()
		return
	end

	tbl1.Open()
end

tbl1.IsOpen = function()
	return bool1
end

local var18 = nil
local function addRow(arg1, arg2)
	local var1 = var9[arg1]:Clone()
	local var2 = num1 + 1
	num1 = var2
	var1.LayoutOrder = num1
	var2 = var1:FindFirstChild("Text", true)
	if arg2 and var2 then
		var2.Text = arg2
		var1.Size = UDim2.new(1, 0, math.max(1, (math.ceil(#arg2 / 26))) * 0.05 + 0.02, 0)
		local var4 = var1:FindFirstChild("Bubble")
		if var4 and arg1 ~= "Typing" then
			var4.Size = UDim2.new(math.clamp(#arg2 * 0.03 + 0.12, 0.22, 0.74), 0, 1, 0)
		end
	end

	var1.Visible = true
	var1.Parent = var8
	local var6 = var1:FindFirstChild("Bubble")
	if var6 then
		local var10 = Instance.new("UIScale")
		var10.Scale = 0.6
		var10.Parent = var6
		var7:Create(var10, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end

	task.defer(function()
		task.wait()
		var8.CanvasPosition = Vector2.new(0, (math.max(0, var8.AbsoluteCanvasSize.Y - var8.AbsoluteWindowSize.Y)))
	end)

	return var1
end

tbl1.ShowTyping = function(_)
	if var18 then
		return
	end

	var5.Status.Text = "typing\226\128\166"
	var18 = addRow("Typing")
	local var1 = var18.Bubble.Text
	task.spawn(function()
		local num1 = 0
		while var18 and var18.Parent do
			num1 = num1 % 3 + 1
			var1.Text = string.rep("\226\128\162", num1)
			task.wait(0.35)
		end
	end)
end

tbl1.HideTyping = function()
	if var18 then
		var18:Destroy()
		var18 = nil
	end

	var5.Status.Text = "online"
end

tbl1.Receive = function(arg1, arg2)
	tbl1.HideTyping()
	if arg1 and arg1 ~= "" then
		var5.Contact.Text = arg1
	end

	addRow("Incoming", arg2)
	if not bool1 then
		local var2 = str1 + 1
		str1 = var2
		setBadge()
	end

	var6.Play(var1, "Notify")
end

tbl1.Send = function(arg1)
	addRow("Outgoing", arg1)
	var6.Play(var1, "Send")
	var16.Reply:FireServer(arg1)
end

tbl1.Stamp = function(arg1)
	addRow("Stamp", arg1)
end

local var19 = nil
var15:BindAction("TogglePhone", function(_, arg2)
	if arg2 == Enum.UserInputState.Begin and (not var19 or (not var19.IsOpen())) then
		tbl1.Toggle()
	end

	return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.P, Enum.KeyCode.DPadUp)

var15:BindAction("ClosePhone", function(_, arg2)
	if arg2 == Enum.UserInputState.Begin and bool1 then
		tbl1.Close()
		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Pass
end, false, Enum.KeyCode.ButtonB)

var2.Activated:Connect(tbl1.Toggle)
local num2 = 0
var15:BindAction("PhoneScroll", function(_, arg2, arg3)
	if not bool1 then
		return Enum.ContextActionResult.Pass
	end

	num2 = arg2 == Enum.UserInputState.Change and arg3.Position.Y or 0
	return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.Thumbstick2, Enum.KeyCode.Thumbstick1)

game:GetService("RunService").Heartbeat:Connect(function(arg1)
	if bool1 and 0.15 < math.abs(num2) then
		var8.CanvasPosition = Vector2.new(0, (math.clamp(var8.CanvasPosition.Y - num2 * 700 * arg1, 0, (math.max(0, var8.AbsoluteCanvasSize.Y - var8.AbsoluteWindowSize.Y)))))
	end
end)

var14.NextSelectionDown = var17
var17.NextSelectionUp = var14
var14.Activated:Connect(tbl1.Close)
local var20 = var14
local function hookButton(arg1)
	arg1.MouseEnter:Connect(function()
		bounce(arg1, 1.05)
	end)

	arg1.MouseLeave:Connect(function()
		bounce(arg1, 1)
	end)

	arg1.SelectionGained:Connect(function()
		bounce(arg1, 1.05)
	end)

	arg1.SelectionLost:Connect(function()
		bounce(arg1, 1)
	end)

	arg1.MouseButton1Down:Connect(function()
		bounce(arg1, 0.96)
	end)

	arg1.MouseButton1Up:Connect(function()
		bounce(arg1, 1.05)
	end)
end

for k1, v1 in { var2, var20, var17 }, nil do
	hookButton(v1)
end

local var21 = var11.KeyboardEnabled
var2.KeyHint.Visible = var21 and (not var11.TouchEnabled)
var2.Selectable = false
var11.LastInputTypeChanged:Connect(function(arg1)
	local var1 = var2.KeyHint
	local var3 = if arg1.Name:find("Gamepad") then "D-Up" else "P"
	var1.Text = var3
	var2.KeyHint.Visible = not (arg1 == Enum.UserInputType.Touch)
end)

local var22 = Instance.new("BindableEvent")
var22.Name = "CameraRequested"
var22.Parent = script
tbl1.CameraRequested = var22.Event
var17.Activated:Connect(function()
	var22:Fire()
end)

local str2 = "CameraController"
var21 = function(arg1)
	workspace:FindFirstChild("House")
	local var1 = arg1
	while var1 do
		if not var1.Parent then
			break
		end

		local var2 = var1.Parent
		if var2.Name == "Cabinets" or var2.Parent and (var2.Parent.Name == "Important" or var2.Parent.Name == "Parts") then
			return var1
		end

		if var1 == workspace then
			break
		end

		local var3 = var2
	end

	return arg1
end

var19 = require(script.Parent:WaitForChild(str2))
tbl1.AddPhoto = function(arg1, arg2)
	local var2 = var9.OutgoingPhoto:Clone()
	local var3 = num1 + 1
	num1 = var3
	var2.LayoutOrder = num1
	var2.Visible = true
	local var4 = arg1
	var4 = var4 and var21(arg1)
	var3 = var2.Bubble.Shot
	if var4 and (var4:IsA("Model") or var4:IsA("BasePart")) then
		local var10 = var4:Clone()
		for k1, v1 in var10:GetDescendants() do
			if v1:IsA("LuaSourceContainer") or (v1:IsA("ProximityPrompt") or (v1:IsA("Sound") or (v1:IsA("ParticleEmitter") or (v1:IsA("Fire") or (v1:IsA("Smoke") or v1:IsA("Light")))))) then
				v1:Destroy()
			end
		end

		var10.Parent = var3
		local var15 = nil
		local var16 = nil
		if var10:IsA("Model") then
			local var17, var18 = var10:GetBoundingBox()
			var15 = var17
			var16 = var18
		else
			var15 = var10.CFrame
			var16 = var10.Size
		end

		local var19 = Instance.new("Camera")
		var19.FieldOfView = 50
		var19.Parent = var3
		var19.CFrame = CFrame.lookAt(var15.Position - (arg2 and arg2.LookVector or Vector3.new(0, -0.3, -1)) * (math.max(var16.Magnitude, 2) * 1.05 / 0.46630765815499858), var15.Position)
		var3.CurrentCamera = var19
	else
		var3.Empty.Visible = true
	end

	var2.Parent = var8
	local var20 = Instance.new("UIScale")
	var20.Scale = 0.6
	var20.Parent = var2.Bubble
	var7:Create(var20, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	var6.Play(var1, "Send")
	task.defer(function()
		task.wait()
		var8.CanvasPosition = Vector2.new(0, (math.max(0, var8.AbsoluteCanvasSize.Y - var8.AbsoluteWindowSize.Y)))
	end)
end

var22.Event:Connect(function()
	tbl1.Close()
	var2.Visible = false
	var19.Open()
end)

var19.Closed:Connect(function()
	var2.Visible = true
end)

var19.Captured:Connect(function(arg1, arg2)
	tbl1.AddPhoto(arg1, arg2)
	tbl1.Open()
end)

var16.Typing.OnClientEvent:Connect(function(arg1, arg2)
	if arg2 then
		tbl1.ShowTyping(arg1)
		return
	end

	tbl1.HideTyping()
end)

var16.Message.OnClientEvent:Connect(function(arg1, arg2, arg3)
	if arg3 then
		tbl1.Stamp(arg3)
	end

	tbl1.Receive(arg1, arg2)
end)

return tbl1

--- Players.LocalPlayer.PlayerScripts.Phone.PhoneRunner [LocalScript]
-- y u r i

local str1 = "ChoreMarkerController"
require(script.Parent:WaitForChild(str1)).Start()
str1 = "NightAudio"
local str2 = "PhoneController"
require(script.Parent:WaitForChild(str2))
local var1 = require(script.Parent:WaitForChild(str1))
game:GetService("CollectionService")
local var2 = nil
local var3 = nil
str1 = game:GetService("Players").LocalPlayer
local tbl1 = {}
for k1, v1 in workspace:WaitForChild("House"):WaitForChild("Parts"):WaitForChild("InteriorLayout"):WaitForChild("RoomBounds"):GetChildren() do
	local var4 = v1:GetAttribute("Min")
	local var5 = v1:GetAttribute("Max")
	if not var4 or (not var5) then
		continue
	end

	table.insert(tbl1, { name = v1.Name, min = var4, max = var5 })
end

local tbl2 = {}
local function roomAt(arg1)
	for k1, v1 in tbl1, nil do
		if v1.min.X > arg1.X then
			continue
		end

		if arg1.X > v1.max.X then
			continue
		end

		if v1.min.Z > arg1.Z then
			continue
		end

		if arg1.Z > v1.max.Z then
			continue
		end

		return v1.name
	end

	return nil
end

local function track(arg1)
	if not arg1:IsA("ProximityPrompt") or tbl2[arg1] then
		return
	end

	local var2 = arg1:GetAttribute("Room")
	if not var2 then
		return
	end

	tbl2[arg1] = { room = var2, dist = arg1.MaxActivationDistance }
	arg1.Destroying:Once(function()
		tbl2[arg1] = nil
	end)
end

for k2, v2 in workspace:GetDescendants() do
	track(v2)
end

workspace.DescendantAdded:Connect(function(arg1)
	if arg1:IsA("ProximityPrompt") then
		task.defer(track, arg1)
	end
end)

local var6 = nil
local function apply()
	for k1, v1 in tbl2, nil do
		local var1 = v1.room == var6 and v1.dist or 0
		if k1.MaxActivationDistance == var1 then
			continue
		end

		k1.MaxActivationDistance = var1
	end
end

task.spawn(function()
	while true do
		local var1 = str1.Character
		local var2 = var1
		var2 = var2 and var1:FindFirstChild("HumanoidRootPart")
		local var4 = var2 and roomAt(var2.Position) or nil
		if var4 ~= var6 then
			var6 = var4
		end

		apply()
		task.wait(0.2)
	end
end)

roomAt = game:GetService("ReplicatedStorage"):WaitForChild("Laser")
str1 = game:GetService("UserInputService")
str2 = game:GetService("RunService")
local var7 = game:GetService("Players").LocalPlayer
tbl2 = roomAt:WaitForChild("Point")
var6 = roomAt:WaitForChild("LaserDot"):Clone()
var6.Name = "LocalLaserDot"
tbl1 = workspace.CurrentCamera
var6.Parent = tbl1
local var8 = Vector2.zero
str1.InputChanged:Connect(function(arg1)
	if arg1.KeyCode == Enum.KeyCode.Thumbstick2 then
		var8 = Vector2.new(arg1.Position.X, -arg1.Position.Y)
	end
end)

local var9 = nil
str1.InputBegan:Connect(function(arg1, arg2)
	if arg1.UserInputType == Enum.UserInputType.Touch and (not arg2) then
		var9 = Vector2.new(arg1.Position.X, arg1.Position.Y)
	end
end)

str1.InputChanged:Connect(function(arg1, arg2)
	if arg1.UserInputType == Enum.UserInputType.Touch and (not arg2) then
		var9 = Vector2.new(arg1.Position.X, arg1.Position.Y)
	end
end)

local var10 = nil
local var11 = nil
apply = var6:FindFirstChild("Beam")
local function aimPoint()
	local var2 = str1:GetLastInputType()
	local var3 = tbl1.ViewportSize
	if var2 == Enum.UserInputType.Touch then
		if var9 then
			return var9, false
		end

		return Vector2.new(var3.X / 2, var3.Y / 2), true
	end

	if var2.Name:find("Gamepad") then
		local var5 = 0.15 < var8.Magnitude and var8 * (var3.Y * 0.25) or Vector2.zero
		return Vector2.new(var3.X / 2 + var5.X, var3.Y / 2 + var5.Y), true
	end

	return str1:GetMouseLocation(), true
end

local num1 = 0
local function start(arg1)
	if var10 then
		var10:Disconnect()
	end

	var11 = arg1
	local var1 = RaycastParams.new()
	var1.FilterType = Enum.RaycastFilterType.Exclude
	var10 = str2.RenderStepped:Connect(function()
		if arg1.Parent then
			if arg1.Parent ~= var7.Character then
				if var10 then
					var10:Disconnect()
					var10 = nil
				end

				var11 = nil
				var6.Transparency = 1
				var6.PointLight.Enabled = false
				if apply then
					apply.Enabled = false
				end

				tbl2:FireServer(nil, false)
				return
			end
		end

		local var2 = arg1:FindFirstChild("Handle")
		local var3 = var2
		local var4, var5 = aimPoint()
		var3 = var3 and var2:FindFirstChild("Tip")
		if var5 then
			local var8 = tbl1:ViewportPointToRay(var4.X, var4.Y)
			var8 = var8 or tbl1:ScreenPointToRay(var4.X, var4.Y)
		end

		local str1 = "LaserDots"
		local var9 = tbl1:ScreenPointToRay(var4.X, var4.Y)
		local tbl3 = { var7.Character, var6, workspace:FindFirstChild(str1) }
		var1.FilterDescendantsInstances = tbl3
		local var12 = workspace:Raycast(var9.Origin, var9.Direction * 200, var1)
		tbl3 = var12 and var12.Position + var12.Normal * 0.05 or var9.Origin + var9.Direction * 200
		var6.CFrame = CFrame.new(tbl3)
		var6.Transparency = 0
		var6.PointLight.Enabled = true
		if apply then
			apply.Attachment0 = var3
			apply.Enabled = var3 ~= nil
		end

		local var13 = os.clock()
		if 0.05 <= var13 - num1 then
			num1 = var13
			tbl2:FireServer(tbl3, true)
		end
	end)
end

local function stop()
	if var10 then
		var10:Disconnect()
		var10 = nil
	end

	var11 = nil
	var6.Transparency = 1
	var6.PointLight.Enabled = false
	if apply then
		apply.Enabled = false
	end

	tbl2:FireServer(nil, false)
end

local function watch(arg1)
	arg1.ChildAdded:Connect(function(arg1)
		if arg1:IsA("Tool") and arg1:GetAttribute("Laser") then
			start(arg1)
		end
	end)

	arg1.ChildRemoved:Connect(function(arg1)
		if arg1 == var11 then
			if var10 then
				var10:Disconnect()
				var10 = nil
			end

			var11 = nil
			var6.Transparency = 1
			var6.PointLight.Enabled = false
			if apply then
				apply.Enabled = false
			end

			tbl2:FireServer(nil, false)
		end
	end)

	for k1, v1 in arg1:GetChildren() do
		if not v1:IsA("Tool") then
			continue
		end

		if not v1:GetAttribute("Laser") then
			continue
		end

		start(v1)
	end
end

if var7.Character then
	watch(var7.Character)
end

var7.CharacterAdded:Connect(watch)
local var13 = workspace:WaitForChild("LaserDots", 30)
local function hideOwn(arg1)
	if arg1.Name == tostring(var7.UserId) then
		arg1.LocalTransparencyModifier = 1
		local var2 = arg1:FindFirstChild("Beam")
		if var2 then
			var2.Enabled = false
		end

		arg1:GetPropertyChangedSignal("Transparency"):Connect(function()
			arg1.LocalTransparencyModifier = 1
		end)

		if var2 then
			var2:GetPropertyChangedSignal("Enabled"):Connect(function()
				if var2.Enabled then
					var2.Enabled = false
				end
			end)

		end
	end
end

if var13 then
	for k3, v3 in var13:GetChildren() do
		hideOwn(v3)
	end

	var13.ChildAdded:Connect(hideOwn)
end

str2 = game:GetService("ReplicatedStorage"):WaitForChild("Meal"):WaitForChild("Eat")
var7 = function(arg1)
	if not arg1:IsA("Tool") or (not arg1:GetAttribute("Meal") or (not arg1:GetAttribute("Hot"))) then
		return
	end

	arg1.Activated:Connect(function()
		str2:FireServer()
	end)
end

str1 = game:GetService("Players").LocalPlayer
tbl1 = function(arg1)
	arg1.ChildAdded:Connect(var7)
	for k1, v1 in arg1:GetChildren() do
		var7(v1)
	end
end

if str1.Character then
	roomAt = str1.Character
	roomAt.ChildAdded:Connect(var7)
	for k4, v4 in roomAt:GetChildren() do
		var7(v4)
	end
end

str1.CharacterAdded:Connect(tbl1)
var7 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SleepGui")
tbl1 = var7:WaitForChild("Black")
roomAt = tbl1:WaitForChild("Title")
str1 = game:GetService("TweenService")
game:GetService("ReplicatedStorage"):WaitForChild("Night"):WaitForChild("Event").OnClientEvent:Connect(function(arg1, arg2)
	if arg1 == "Cut" then
		var7.Enabled = true
		tbl1.Visible = true
		roomAt.TextTransparency = 1
		tbl1.BackgroundTransparency = 0
		return
	end

	if arg1 == "Sleep" then
		var7.Enabled = true
		var1.Sleep()
		tbl1.Visible = true
		roomAt.TextTransparency = 1
		if 0.01 >= tbl1.BackgroundTransparency then
			return
		end

		tbl1.BackgroundTransparency = 1
		str1:Create(tbl1, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 0 }):Play()
		return
	end

	if arg1 == "Night" then
		roomAt.Text = "Night " .. tostring(arg2)
		var1.Night()
		str1:Create(roomAt, TweenInfo.new(0.8), { TextTransparency = 0 }):Play()
		return
	end

	if arg1 == "Wake" then
		var1.Wake()
		str1:Create(roomAt, TweenInfo.new(0.6), { TextTransparency = 1 }):Play()
		local var2 = str1:Create(tbl1, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 })
		var2:Play()
		var2.Completed:Once(function()
			if 1 <= tbl1.BackgroundTransparency then
				tbl1.Visible = false
				var7.Enabled = false
			end
		end)

	end
end)

var7 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SkipGui")
tbl1 = var7:WaitForChild("Panel")
roomAt = tbl1:WaitForChild("Vote")
var6 = false
track = game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("Skip")
roomAt.Activated:Connect(function()
	local var1 = not var6
	var6 = var1
	var1 = roomAt.Label
	var1.Text = if var6 then "Cancel vote" else "Vote to skip"
	local var2 = var6 and Color3.fromRGB(58, 58, 60) or Color3.fromRGB(10, 132, 255)
	roomAt.BackgroundColor3 = var2
	var1 = track
	var1:FireServer(if var6 then "Vote" else "Unvote")
end)

local var14 = roomAt:FindFirstChildOfClass("UIScale")
str1 = game:GetService("TweenService")
roomAt.MouseEnter:Connect(function()
	if var14 then
		str1:Create(var14, TweenInfo.new(0.15), { Scale = 1.04 }):Play()
	end
end)

roomAt.MouseLeave:Connect(function()
	if var14 then
		str1:Create(var14, TweenInfo.new(0.15), { Scale = 1 }):Play()
	end
end)

tbl2 = tbl1:WaitForChild("Count")
track.OnClientEvent:Connect(function(arg1, arg2, arg3)
	if arg1 == "Count" then
		tbl2.Text = string.format("%d / %d voted", arg2 or 0, arg3 or 1)
		return
	end

	if arg1 == "Hide" then
		var7.Enabled = false
	end
end)

local function render()
	local var1 = roomAt.Label
	var1.Text = if var6 then "Cancel vote" else "Vote to skip"
	local var2 = var6 and Color3.fromRGB(58, 58, 60) or Color3.fromRGB(10, 132, 255)
	roomAt.BackgroundColor3 = var2
end

var8 = roomAt.Label
var8.Text = if var6 then "Cancel vote" else "Vote to skip"
var8 = var6 and Color3.fromRGB(58, 58, 60) or Color3.fromRGB(10, 132, 255)
roomAt.BackgroundColor3 = var8
str2 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MouseLockGui")
local var15 = game:GetService("UserInputService")
tbl1 = str2:WaitForChild("Modal")
roomAt = false
var7 = str2:WaitForChild("Hint")
var15.InputBegan:Connect(function(arg1, _)
	if not str2.Enabled then
		return
	end

	if arg1.KeyCode == Enum.KeyCode.LeftControl or arg1.KeyCode == Enum.KeyCode.RightControl then
		local var1 = not roomAt
		roomAt = var1
		tbl1.Visible = roomAt
		var1 = var7
		var1.Text = if roomAt then "Ctrl to lock mouse" else "Ctrl to unlock mouse"
	end
end)

var15.LastInputTypeChanged:Connect(function()
	local var1 = var15.KeyboardEnabled
	str2.Enabled = var1 and (var15.MouseEnabled and (not var15.TouchEnabled))
end)

render = var15.KeyboardEnabled
str2.Enabled = render and (var15.MouseEnabled and (not var15.TouchEnabled))
tbl1.Visible = roomAt
tbl2 = function()
	local var1 = var15.KeyboardEnabled
	return var1 and (var15.MouseEnabled and (not var15.TouchEnabled))
end

track = function()
	tbl1.Visible = roomAt
	local var1 = var7
	var1.Text = if roomAt then "Ctrl to lock mouse" else "Ctrl to unlock mouse"
end

var7.Text = if roomAt then "Ctrl to lock mouse" else "Ctrl to unlock mouse"
var6 = "CameraController"
str2 = game:GetService("Players").LocalPlayer
roomAt = require(script.Parent:WaitForChild(var6))
track = function()
	local var2 = str2.Character
	if not var2 then
		return false
	end

	for k1, v1 in var2:GetChildren() do
		if not v1:IsA("Tool") then
			continue
		end

		return true
	end

	return false
end

var7 = workspace.CurrentCamera
tbl2 = 0
tbl1 = game:GetService("ReplicatedStorage"):WaitForChild("Cat"):WaitForChild("Pet")
str1 = game:GetService("UserInputService")
var6 = function(arg1, arg2)
	if roomAt.IsOpen() or track() then
		return
	end

	local var2 = workspace:FindFirstChild("Cat")
	if not var2 then
		return
	end

	local var3 = arg2 and var7:ViewportPointToRay(arg1.X, arg1.Y) or var7:ScreenPointToRay(arg1.X, arg1.Y)
	local var4 = RaycastParams.new()
	var4.FilterType = Enum.RaycastFilterType.Exclude
	var4.FilterDescendantsInstances = { str2.Character }
	local var8 = workspace:Raycast(var3.Origin, var3.Direction * 40, var4)
	if var8 then
		if var8.Instance:IsDescendantOf(var2) then
			local var10 = os.clock()
			if var10 - tbl2 < 0.35 then
				return
			end

			tbl2 = var10
			tbl1:FireServer()
		end
	end
end

str1.InputBegan:Connect(function(arg1, arg2)
	if arg2 then
		return
	end

	local var2 = arg1.UserInputType
	if var2 == Enum.UserInputType.MouseButton1 then
		var6(str1:GetMouseLocation(), true)
		return
	end

	if var2 == Enum.UserInputType.Touch then
		var6(Vector2.new(arg1.Position.X, arg1.Position.Y), false)
		return
	end

	if arg1.KeyCode == Enum.KeyCode.ButtonA or arg1.KeyCode == Enum.KeyCode.ButtonR2 then
		local var4 = var7.ViewportSize
		var6(Vector2.new(var4.X / 2, var4.Y / 2), true)
	end
end)

local var16 = game:GetService("Players")
tbl1 = var16.LocalPlayer
roomAt = tbl1:WaitForChild("PlayerGui")
var14 = "EndingAudio"
tbl2 = roomAt:WaitForChild("EndingGui")
require(script.Parent:WaitForChild(var14)).Bind(tbl2)
var6 = game:GetService("ReplicatedStorage"):WaitForChild("Ending")
track = tbl2:WaitForChild("Backdrop")
hideOwn = track:WaitForChild("Voters")
aimPoint = track:WaitForChild("Restart")
local bool1 = false
local tbl3 = {}
local var17 = hideOwn:WaitForChild("Thumb")
local var18 = nil
start = track:WaitForChild("Revive")
watch = track:WaitForChild("Sub")
var13 = track:WaitForChild("Countdown")
stop = track:WaitForChild("Lobby")
str1 = game:GetService("TweenService")
var7 = game:GetService("UserInputService")
str2 = game:GetService("GuiService")
var6:WaitForChild("Show").OnClientEvent:Connect(function(arg1, arg2, arg3, arg4)
	if not tbl2.Enabled then
		var18 = workspace.CurrentCamera.FieldOfView
	end

	track.Title.Text = arg1 or ""
	track.Desc.Text = arg3 or ""
	local var1 = track.Kicker
	var1.Text = if arg4 then "PASSED" else "FAILED"
	local var3 = arg4 and Color3.fromRGB(48, 230, 96) or Color3.fromRGB(255, 56, 56)
	track.Kicker.TextColor3 = var3
	start.Visible = not arg4
	watch.Visible = not arg4
	var1 = aimPoint
	var3 = UDim2.new
	var1.Position = var3(if arg4 then 0.34 else 0.25, 0, 0.73, 0)
	var1 = track.Voters
	var3 = UDim2.new
	var1.Position = var3(if arg4 then 0.34 else 0.25, 0, 0.66, 0)
	var1 = var13
	var3 = UDim2.new
	var1.Position = var3(if arg4 then 0.34 else 0.25, 0, 0.81, 0)
	var1 = stop
	var3 = UDim2.new
	local num1 = 0.73
	var1.Position = var3(if arg4 then 0.66 else 0.75, 0, num1, 0)
	var2 = {}
	for k1, v1 in roomAt:GetChildren() do
		local var4 = v1:IsA("ScreenGui")
		var4 = tbl2
		var4 = sleep
		if not var4 or v1 == var4 or v1 == var4 then
			continue
		end

		var4 = v1.Enabled
		if not var4 then
			continue
		end

		table.insert(var2, v1)
	end

	var1 = track.Badge
	var1.Text = if arg2 then "Badge unlocked" else ""
	track.BackgroundTransparency = 1
	var1 = roomAt:FindFirstChild("SleepGui")
	for k2, v2 in roomAt:GetChildren() do
		if not v2:IsA("ScreenGui") or v2 == tbl2 or v2 == var1 then
			continue
		end

		v2.Enabled = false
	end

	tbl2.Enabled = true
	var3 = str1:Create(track, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0 })
	var3:Play()
	var3.Completed:Once(function()
		if var1 then
			var1.Enabled = false
		end
	end)

	bool1 = false
	local var5 = aimPoint.Label
	var5.Text = if bool1 then "CANCEL" else "RESTART"
	local var6 = bool1 and Color3.fromRGB(58, 58, 60) or Color3.fromRGB(10, 132, 255)
	aimPoint.BackgroundColor3 = var6
	var13.Text = ""
	var7.MouseIconEnabled = true
	if var7:GetLastInputType().Name:find("Gamepad") then
		str2.SelectedObject = aimPoint
	end
end)

local function setThumbs(arg1)
	local tbl1 = {}
	for k1, v1 in arg1, nil do
		tbl1[v1] = true
		local var2 = tbl3[v1]
		if not var2 then
			var2 = var17:Clone()
			var2.Visible = true
			var2.Parent = hideOwn
			tbl3[v1] = var2
			task.spawn(function()
				local success, result = pcall(var16.GetUserThumbnailAsync, var16, v1, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				if success and var2.Parent then
					var2.Image = result
				end
			end)

		end

		var2.LayoutOrder = k1
	end

	for k2, v2 in tbl3, nil do
		if tbl1[k2] then
			continue
		end

		v2:Destroy()
		tbl3[k2] = nil
	end
end

var6:WaitForChild("Voters").OnClientEvent:Connect(function(arg1, arg2)
	local var1 = arg1
	setThumbs(var1 or {})
	local var2 = var13
	if arg2 then
		var1 = "Restarting in " .. tostring(arg2)
		var1 = var1 or ""
	end

	var2.Text = ""
	var1 = arg1
	var2 = false
	for k1, v1 in var1 or {}, nil do
		if v1 ~= tbl1.UserId then
			continue
		end

		var2 = true
	end

	bool1 = var2
	var1 = aimPoint.Label
	var1.Text = if bool1 then "CANCEL" else "RESTART"
	local var3 = bool1 and Color3.fromRGB(58, 58, 60) or Color3.fromRGB(10, 132, 255)
	aimPoint.BackgroundColor3 = var3
end)

var14 = var6:WaitForChild("Vote")
aimPoint.Activated:Connect(function()
	local var1 = not bool1
	bool1 = var1
	var1 = aimPoint.Label
	var1.Text = if bool1 then "CANCEL" else "RESTART"
	local var2 = bool1 and Color3.fromRGB(58, 58, 60) or Color3.fromRGB(10, 132, 255)
	aimPoint.BackgroundColor3 = var2
	var14:FireServer(bool1)
end)

var11 = var6:WaitForChild("Lobby")
stop.Activated:Connect(function()
	stop.Label.Text = "TELEPORTING\226\128\166"
	var11:FireServer()
end)

var10 = var6:WaitForChild("Revive")
start.Activated:Connect(function()
	var10:FireServer()
end)

var6:WaitForChild("Hide").OnClientEvent:Connect(function()
	tbl2.Enabled = false
	bool1 = false
	local var1 = aimPoint.Label
	var1.Text = if bool1 then "CANCEL" else "RESTART"
	local num1 = 60
	num1 = 255
	local var4 = bool1 and Color3.fromRGB(58, 58, num1) or Color3.fromRGB(10, 132, num1)
	aimPoint.BackgroundColor3 = var4
	setThumbs({})
	var13.Text = ""
	stop.Label.Text = "BACK TO LOBBY"
	var1 = var2
	for k1, v1 in var1 or {}, nil do
		if not v1.Parent then
			continue
		end

		v1.Enabled = true
	end

	var2 = nil
	var1 = roomAt:FindFirstChild("JumpscareGui")
	if var1 then
		var1.Enabled = false
	end

	var4 = roomAt:FindFirstChild("RunGui")
	if var4 then
		var4.Enabled = false
	end

	if var3 then
		var3()
	end

	local var5 = workspace.CurrentCamera
	for k2, v2 in var5:GetChildren() do
		if not v2:IsA("Model") then
			continue
		end

		v2:Destroy()
	end

	var5.CameraType = Enum.CameraType.Custom
	if var18 then
		var5.FieldOfView = var18
	end

	local var6 = tbl1.Character
	local var8 = var6
	var8 = var8 and (var6:FindFirstChildOfClass("Humanoid") or var6:WaitForChild("Humanoid", 5))
	if var8 then
		var5.CameraSubject = var8
	end

	tbl1.CharacterAdded:Once(function(arg1)
		task.wait(0.2)
		local var1 = arg1
		var1 = var1 and (arg1:FindFirstChildOfClass("Humanoid") or arg1:WaitForChild("Humanoid", 5))
		if var1 then
			var5.CameraSubject = var1
		end
	end)

	var7.MouseIconEnabled = true
	var7.MouseBehavior = Enum.MouseBehavior.Default
	str2.SelectedObject = nil
end)

local var19 = start
for k5, v5 in { aimPoint, var19, stop }, nil do
	local var20 = v5:FindFirstChildOfClass("UIScale")
	v5.MouseEnter:Connect(function()
		if var20 then
			str1:Create(var20, TweenInfo.new(0.15), { Scale = 1.04 }):Play()
		end
	end)

	v5.MouseLeave:Connect(function()
		if var20 then
			str1:Create(var20, TweenInfo.new(0.15), { Scale = 1 }):Play()
		end
	end)

	v5.SelectionGained:Connect(function()
		if var20 then
			str1:Create(var20, TweenInfo.new(0.15), { Scale = 1.04 }):Play()
		end
	end)

	v5.SelectionLost:Connect(function()
		if var20 then
			str1:Create(var20, TweenInfo.new(0.15), { Scale = 1 }):Play()
		end
	end)

end

var15 = game:GetService("RunService")
str2 = workspace.CurrentCamera
game:GetService("ReplicatedStorage"):WaitForChild("Night"):WaitForChild("Attack").OnClientEvent:Connect(function(arg1, arg2)
	if arg1 ~= "Start" then
		return
	end

	local var1 = os.clock()
	local var2 = nil
	var15.RenderStepped:Connect(function()
		if (arg2 or 8) + 1 < os.clock() - var1 then
			var2:Disconnect()
			return
		end

		str2.CFrame = str2.CFrame * CFrame.Angles(math.rad((math.random() - 0.5) * 0.9), math.rad((math.random() - 0.5) * 0.9), (math.rad((math.random() - 0.5) * 0.9 * 1.5)))
	end)
end)

var7 = nil
str2 = workspace.CurrentCamera
var15 = game:GetService("RunService")
game:GetService("ReplicatedStorage"):WaitForChild("Night"):WaitForChild("Cutscene").OnClientEvent:Connect(function(arg1, arg2, arg3)
	local var1
	if arg1 == "Bed" then
		if var7 then
			var7:Disconnect()
		end

		for k1, v1 in game.Players.LocalPlayer.PlayerGui:GetChildren() do
			if not v1:IsA("ScreenGui") then
				continue
			end

			if v1.Name == "SleepGui" then
				continue
			end

			if v1.Name == "EndingGui" then
				continue
			end

			if not v1.Enabled then
				continue
			end

			local var3 = var2
			var2 = var3 or {}
			table.insert(var2, v1)
			v1.Enabled = false
		end

		str2.CameraType = Enum.CameraType.Scriptable
		local var4 = os.clock()
		local var5 = CFrame.lookAt(arg2, arg3)
		local function fn2()
			local var1 = os.clock() - var4
			str2.CFrame = var5 * CFrame.new(0, math.sin(var1 * 1.6) * 0.06, 0) * CFrame.Angles(math.rad(math.sin(var1 * 0.9) * 0.6), math.rad(math.sin(var1 * 0.7) * 0.8), (math.rad(math.sin(var1 * 0.5) * 1.2)))
		end

		var7 = var15.RenderStepped:Connect(fn2)
		return
	end

	if arg1 == "Fixed" then
		if var7 then
			var7:Disconnect()
		end

		for k2, v2 in game.Players.LocalPlayer.PlayerGui:GetChildren() do
			if not v2:IsA("ScreenGui") then
				continue
			end

			if v2.Name == "SleepGui" then
				continue
			end

			if v2.Name == "EndingGui" then
				continue
			end

			if not v2.Enabled then
				continue
			end

			local var6 = var2
			var2 = var6 or {}
			table.insert(var2, v2)
			v2.Enabled = false
		end

		str2.CameraType = Enum.CameraType.Scriptable
		local var8 = arg3
		var7 = var15.RenderStepped:Connect(function(arg1)
			local var1 = workspace:FindFirstChild("Cat")
			local var2 = var8:Lerp(var1 and (var1.PrimaryPart and var1.PrimaryPart.Position) or arg3, 1 - math.exp(-3 * arg1))
			var8 = var2
			str2.CFrame = CFrame.lookAt(arg2, var8)
		end)

		return
	end

	if arg1 == "Top" then
		if var7 then
			var7:Disconnect()
		end

		for k3, v3 in game.Players.LocalPlayer.PlayerGui:GetChildren() do
			if not v3:IsA("ScreenGui") then
				continue
			end

			if v3.Name == "SleepGui" then
				continue
			end

			if v3.Name == "EndingGui" then
				continue
			end

			if not v3.Enabled then
				continue
			end

			local var9 = var2
			var2 = var9 or {}
			table.insert(var2, v3)
			v3.Enabled = false
		end

		str2.CameraType = Enum.CameraType.Scriptable
		local var10 = os.clock()
		var7 = var15.RenderStepped:Connect(function()
			local var1 = os.clock() - var10
			str2.CFrame = CFrame.lookAt(arg3 + (arg2 - arg3) * math.max(0, 1 - math.min(var1 / 8, 1) * 0.3), arg3) * CFrame.Angles(math.rad(math.sin(var1 * 0.6) * 0.4), 0, (math.rad(math.sin(var1 * 0.4) * 0.6)))
		end)

		return
	end

	if arg1 == "Stare" then
		local var11 = str2.CFrame
		if var7 then
			var7:Disconnect()
		end

		local var12 = os.clock()
		var7 = var15.RenderStepped:Connect(function()
			str2.CFrame = var11 * CFrame.new(0, 0, -math.min((os.clock() - var12) * 0.15, 0.6)) * CFrame.Angles(math.rad((math.random() - 0.5) * 0.15), math.rad((math.random() - 0.5) * 0.15), 0)
		end)

	end
end)

var16 = game:GetService("ReplicatedStorage")
str2 = game:GetService("Players")
tbl1 = str2.LocalPlayer:WaitForChild("PlayerGui")
roomAt = tbl1:WaitForChild("JumpscareGui")
str1 = game:GetService("SoundService")
track = workspace.CurrentCamera
var15 = game:GetService("RunService")
tbl2 = roomAt:WaitForChild("Black"):WaitForChild("View")
var16:WaitForChild("Night"):WaitForChild("Jumpscare").OnClientEvent:Connect(function(arg1, arg2, arg3)
	local var1 = var16:FindFirstChild("Jumpscares")
	local var3 = var1
	var3 = var3 and var1:FindFirstChild(arg1)
	if not var3 then
		return
	end

	local var5
	if arg3 == "fly" then
		local var6 = var3:Clone()
		for k1, v1 in var6:GetDescendants() do
			if not v1:IsA("BasePart") then
				continue
			end

			v1.Anchored = true
			v1.CanCollide = false
		end

		var6.Parent = workspace
		local var7 = var6.PrimaryPart
		var7 = var7 or var6:FindFirstChildWhichIsA("BasePart")
		local var9 = str1:FindFirstChild("Jumpscare")
		local var10 = var7.Size.Y / 2
		local var11 = var7.CFrame:ToObjectSpace(var6:GetPivot())
		if var9 and var9.SoundId ~= "" then
			local var12 = var9:Clone()
			var12.Parent = str1
			var12:Play()
			var12.Ended:Once(function()
				var12:Destroy()
			end)

		end

		local var13 = Vector3.new(track.CFrame.LookVector.X, 0, track.CFrame.LookVector.Z)
		local var14 = track.CFrame.Position
		if var13.Magnitude < 0.01 then
			var13 = Vector3.new(0, 0, -1)
		end

		local var17 = RaycastParams.new()
		var17.FilterType = Enum.RaycastFilterType.Exclude
		var17.FilterDescendantsInstances = { var6, str2.LocalPlayer.Character }
		local var18 = os.clock()
		track.CameraType = Enum.CameraType.Scriptable
		local var19 = nil
		local var20 = track.CameraType
		local var21 = var14.Y + 1 - var10 * 0.82
		var13 = var13.Unit
		var15.RenderStepped:Connect(function()
			local var2 = os.clock() - var18
			if (arg2 or 2) < var2 then
				var19:Disconnect()
				var6:Destroy()
				track.CameraType = var20
				return
			end

			local var3 = math.min(1, var2 / 0.9)
			local var4 = Vector3.new(var14.X, var21, var14.Z) + var13 * (var3 * var3 * -13.5 + 18)
			var6:PivotTo(CFrame.lookAt(var4, (Vector3.new(var14.X, var4.Y, var14.Z))) * CFrame.Angles(0, math.rad((math.random() - 0.5) * 3), 0) * var11)
			track.CFrame = CFrame.lookAt(var14, var4 + Vector3.new(0, var10 * 0.82, 0)) * CFrame.Angles(math.rad((math.random() - 0.5) * 1.2), math.rad((math.random() - 0.5) * 1.2), 0)
		end)

		return
	end

	for k2, v2 in tbl1:GetChildren() do
		local var22 = v2:IsA("ScreenGui")
		if not var22 then
			continue
		end

		var22 = v2.Name
		var22 = roomAt
		if var22 == "EndingGui" or v2 == var22 then
			continue
		end

		var22 = v2.Enabled
		if not var22 then
			continue
		end

		var22 = var2
		var2 = var22 or {}
		table.insert(var2, v2)
		var22 = false
		v2.Enabled = var22
	end

	tbl2:ClearAllChildren()
	local var23 = var3:Clone()
	for k3, v3 in var23:GetDescendants() do
		if not v3:IsA("BasePart") then
			continue
		end

		v3.Anchored = true
		v3.CanCollide = false
	end

	var23.Parent = tbl2
	local var24, var25 = var23:GetBoundingBox()
	local var26 = var24.LookVector
	local var28 = Vector3.new(var26.X, 0, var26.Z)
	if not var3:GetAttribute("JumpscareKeepTilt") then
		if 0.2 < var28.Magnitude then
			var26 = var28.Unit
		end
	end

	local var30 = var3:GetAttribute("JumpscareDist")
	local var31 = var3:GetAttribute("JumpscareFocus") or 0.38
	if not var30 then
		var30 = math.max(var25.X * 0.7, var25.Y * 0.32)
	end

	local var32 = Instance.new("Camera")
	var32.FieldOfView = 60
	var32.Parent = tbl2
	tbl2.CurrentCamera = var32
	roomAt.Enabled = true
	local var34 = str1:FindFirstChild("Jumpscare")
	if var34 and var34.SoundId ~= "" then
		local var35 = var34:Clone()
		var35.Parent = str1
		var35:Play()
		var35.Ended:Once(function()
			var35:Destroy()
		end)

	end

	local var36 = os.clock()
	local var37 = nil
	var15.RenderStepped:Connect(function()
		local var2 = os.clock() - var36
		if (arg2 or 1.5) < var2 then
			var37:Disconnect()
			roomAt.Enabled = false
			tbl2:ClearAllChildren()
			return
		end

		local var3 = var24.Position + Vector3.new(0, var25.Y * var31, 0)
		var32.CFrame = CFrame.lookAt(var3 + var26 * (var30 * (1 - math.min(var2 / (arg2 or 1.5), 1) * 0.35)) + Vector3.new(math.random() - 0.5, math.random() - 0.5, 0) * var25.Y * 0.03, var3)
	end)
end)

str2 = game:GetService("Players").LocalPlayer
roomAt = str2:WaitForChild("PlayerGui"):WaitForChild("StareGui")
track = 0
var7 = workspace.CurrentCamera
var6 = os.clock()
tbl1 = game:GetService("ReplicatedStorage"):WaitForChild("Cat"):WaitForChild("Stare")
tbl2 = roomAt.Bar.Fill
game:GetService("RunService").Heartbeat:Connect(function(arg1)
	local var1 = workspace:FindFirstChild("Cat")
	local var2 = var1
	var2 = var2 and var1:FindFirstChild("CreepyCatHead")
	local var3 = var2
	var3 = var3 and var2.PrimaryPart
	if var3 then
		if workspace:GetAttribute("CreepyHead") ~= true then
			if roomAt.Enabled then
				roomAt.Enabled = false
			end

			track = 0
			return
		end
	end

	local var4 = var3.Position - var7.CFrame.Position
	local bool1 = false
	if var4.Magnitude < 40 and math.acos((math.clamp(var7.CFrame.LookVector:Dot(var4.Unit), -1, 1))) < 0.24434609527920614 then
		local var5 = RaycastParams.new()
		var5.FilterType = Enum.RaycastFilterType.Exclude
		var5.FilterDescendantsInstances = { str2.Character, var1 }
		bool1 = workspace:Raycast(var7.CFrame.Position, var4, var5) == nil
	end

	if bool1 then
		local var8 = track + arg1
		track = var8
		var8 = os.clock()
		if 0.4 <= var8 - var6 then
			tbl1:FireServer(track)
			track = 0
			var6 = var8
		end
	end

	local var9 = workspace:GetAttribute("CreepyStare") or 0
	roomAt.Enabled = bool1
	tbl2.Size = UDim2.new(var9, 0, 1, 0)
end)

tbl1 = 0
var7 = 0
game:GetService("ReplicatedStorage"):WaitForChild("Night"):WaitForChild("Shake").OnClientEvent:Connect(function(arg1, arg2)
	local var1 = math.max(tbl1, arg1 or 0.5)
	tbl1 = var1
	var1 = math.max(var7, os.clock() + (arg2 or 0.5))
	var7 = var1
end)

str2 = workspace.CurrentCamera
game:GetService("RunService").RenderStepped:Connect(function()
	if var7 < os.clock() then
		tbl1 = 0
		return
	end

	local var1 = tbl1 * 0.35
	str2.CFrame = str2.CFrame * CFrame.Angles(math.rad((math.random() - 0.5) * var1), math.rad((math.random() - 0.5) * var1), (math.rad((math.random() - 0.5) * var1 * 0.6)))
	local var2 = tbl1 * 0.97
	tbl1 = var2
end)

var7 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RunGui")
str1 = game:GetService("RunService")
tbl1 = var7:WaitForChild("Main")
roomAt = var7:WaitForChild("Ghost1")
tbl2 = var7:WaitForChild("Ghost2")
game:GetService("ReplicatedStorage"):WaitForChild("Night"):WaitForChild("Run").OnClientEvent:Connect(function(arg1, arg2)
	if arg1 ~= "Run" then
		return
	end

	var7.Enabled = true
	local var1 = os.clock()
	local var2 = nil
	str1.RenderStepped:Connect(function()
		if (arg2 or 4) < os.clock() - var1 then
			var2:Disconnect()
			var7.Enabled = false
			return
		end

		local var3 = (math.random() - 0.5) * 0.04
		local var4 = (math.random() - 0.5) * 0.04
		tbl1.Position = UDim2.new(0.5 + var3, 0, 0.45 + var4, 0)
		roomAt.Position = UDim2.new(0.5 + var3 + (math.random() - 0.5) * 0.03, 0, 0.45 + var4, 0)
		tbl2.Position = UDim2.new(0.5 + var3 - (math.random() - 0.5) * 0.03, 0, 0.45 + var4, 0)
		local var5 = tbl1
		local var6 = if math.random() < 0.12 then 1 else 0
		var5.TextTransparency = var6
		tbl1.Rotation = (math.random() - 0.5) * 6
		var6 = math.random() < 0.08 and Color3.new(1, 1, 1) or Color3.fromRGB(255, 20, 20)
		tbl1.TextColor3 = var6
		tbl1.Size = UDim2.new(0.5 + (math.random() - 0.5) * 0.06, 0, 0.22, 0)
	end)
end)

str2 = game:GetService("Players").LocalPlayer
var7 = str2:WaitForChild("PlayerGui"):WaitForChild("CashGui")
workspace:GetAttributeChangedSignal("TutorialDone"):Connect(function()
	if workspace:GetAttribute("TutorialDone") == true then
		var7.Enabled = true
	end
end)

var15 = game:GetService("TweenService")
str1 = game:GetService("RunService")
tbl1 = var7:WaitForChild("Pill")
if workspace:GetAttribute("TutorialDone") == true then
	var7.Enabled = true
end

tbl2 = tbl1:WaitForChild("Value")
render = nil
var6 = 0
track = tbl1:WaitForChild("Gain")
var11 = function(arg1)
	if arg1 <= 0 then
		return
	end

	track.Text = "+" .. tostring(arg1)
	track.Position = UDim2.new(0.88, 0, 0, 0)
	track.TextTransparency = 0.1
	local var1 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	var15:Create(track, var1, { Position = UDim2.new(0.88, 0, -0.35, 0), TextTransparency = 1 }):Play()
end

num1 = function()
	local var1 = str2:WaitForChild("leaderstats", 60)
	local var2 = var1
	var2 = var2 and var1:WaitForChild("Cash", 30)
	if not var2 then
		return
	end

	var6 = var2.Value
	tbl2.Text = tostring((math.floor(var6 + 0.5)))
	local var3 = var2.Value
	var2.Changed:Connect(function(arg1)
		var11(arg1 - var3)
		var3 = arg1
		if render then
			render:Disconnect()
		end

		local var1 = os.clock()
		local var2 = var6
		render = str1.RenderStepped:Connect(function()
			local var3 = math.min(1, (os.clock() - var1) / 0.6)
			var6 = var2 + (arg1 - var2) * (1 - (1 - var3) ^ 3)
			tbl2.Text = tostring((math.floor(var6 + 0.5)))
			if 1 <= var3 then
				render:Disconnect()
				render = nil
			end
		end)
	end)
end

task.spawn(num1)
var15 = game:GetService("SoundService")
var7 = var15:WaitForChild("UIHover", 10)
roomAt = 0
str1 = game:GetService("UserInputService")
tbl1 = var15:WaitForChild("UIClick", 10)
tbl2 = setmetatable({}, { __mode = "k" })
track = function()
	if not var7 or os.clock() - roomAt < 0.06 then
		return
	end

	if str1:GetLastInputType() == Enum.UserInputType.Touch then
		return
	end

	roomAt = os.clock()
	var15:PlayLocalSound(var7)
end

var6 = function()
	if tbl1 then
		var15:PlayLocalSound(tbl1)
	end
end

str2 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
var14 = function(arg1)
	tbl2.Text = tostring((math.floor(arg1 + 0.5)))
end

render = function(arg1)
	if tbl2[arg1] or (not arg1:IsA("GuiButton") or arg1:GetAttribute("NoUISound")) then
		return
	end

	tbl2[arg1] = true
	arg1.MouseEnter:Connect(function()
		if arg1.Visible and arg1.Active then
			track()
		end
	end)

	arg1.SelectionGained:Connect(track)
	arg1.Activated:Connect(var6)
end

for k6, v6 in str2:GetDescendants() do
	render(v6)
end

str2.DescendantAdded:Connect(render)

--- Players.LocalPlayer.PlayerScripts.Phone.PhoneAudio [ModuleScript]
-- y u r i

local var1 = game:GetService("Debris")
local var2 = setmetatable({}, { __mode = "k" })
local tbl1 = { Play = function(arg1, arg2)
	local var2 = arg1:FindFirstChild("Sounds")
	local var3 = var2
	var3 = var3 and var2:FindFirstChild(arg2)
	if not var3 or (not var3:IsA("Sound") or var3.SoundId == "") then
		return
	end

	local var4 = var3:Clone()
	var4.Looped = false
	var4.Parent = arg1
	var4.Ended:Once(function()
		var4:Destroy()
	end)

	var1:AddItem(var4, 10)
	var4:Play()
end }

tbl1.Bind = function(arg1)
	if var2[arg1] then
		return
	end

	var2[arg1] = true
	local var1 = setmetatable({}, { __mode = "k" })
	local function visible(arg1)
		if not arg1.Enabled then
			return false
		end

		local var1 = arg1
		while not var1 and var1 == arg1 and var1:IsA("GuiObject") and (not var1.Visible) do
		end

		return var1 == arg1
	end

	local num1 = -math.huge
	local function hook(arg1)
		if not arg1:IsA("GuiButton") or var1[arg1] then
			return
		end

		var1[arg1] = true
		local function hover()
			if arg1.Name == "Backdrop" or (not arg1.Interactable or (not visible(arg1))) then
				return
			end

			local var1 = os.clock()
			if var1 - num1 < 0.06 then
				return
			end

			num1 = var1
			tbl1.Play(arg1, "Hover")
		end

		arg1.MouseEnter:Connect(hover)
		arg1.SelectionGained:Connect(hover)
		arg1.Activated:Connect(function()
			if arg1.Interactable then
				tbl1.Play(arg1, "Click")
			end
		end)
	end

	arg1.DescendantAdded:Connect(hook)
	for k1, v1 in arg1:GetDescendants() do
		hook(v1)
	end
end

return tbl1

--- Players.LocalPlayer.PlayerScripts.Phone.CameraController [ModuleScript]
-- y u r i

game:GetService("ContextActionService")
local var1 = game:GetService("Players").LocalPlayer
local var2 = var1:WaitForChild("PlayerGui"):WaitForChild("CameraGui")
local var3 = var2:WaitForChild("View")
local var4 = game:GetService("TweenService")
local var5 = game:GetService("UserInputService")
local var6 = var3:WaitForChild("BarBottom"):WaitForChild("Shutter")
local var7 = var3:WaitForChild("BarTop"):WaitForChild("Cancel")
local var8 = var3.BarBottom:WaitForChild("Hint")
local var9 = var2:WaitForChild("Flash")
local var10 = var2:FindFirstChild("Sounds")
local var11 = game:GetService("ReplicatedStorage"):WaitForChild("Phone"):WaitForChild("Photo")
local var12 = Instance.new("BindableEvent")
var12.Name = "Captured"
var12.Parent = script
local var13 = Instance.new("BindableEvent")
var13.Name = "Closed"
var13.Parent = script
local var14 = workspace.CurrentCamera
local bool1 = false
local var15 = nil
local bool2 = false
local function raycastTarget()
	local var2 = RaycastParams.new()
	var2.FilterType = Enum.RaycastFilterType.Exclude
	var2.FilterDescendantsInstances = { var1.Character }
	local var3 = workspace:Raycast(var14.CFrame.Position, var14.CFrame.LookVector * 60, var2)
	return var3 and var3.Instance or nil
end

local function play(arg1)
	local var1 = var10
	var1 = var1 and var10:FindFirstChild(arg1)
	if not var1 or var1.SoundId == "" then
		return
	end

	local var3 = var1:Clone()
	var3.Parent = var2
	var3:Play()
	var3.Ended:Once(function()
		var3:Destroy()
	end)
end

local tbl1 = {
	Captured = var12.Event,
	Closed = var13.Event,
	Open = function()
		if bool1 then
			return
		end

		bool1 = true
		var15 = {
			mode = var1.CameraMode,
			minZoom = var1.CameraMinZoomDistance,
			maxZoom = var1.CameraMaxZoomDistance,
			fov = var14.FieldOfView,
		}

		var1.CameraMode = Enum.CameraMode.LockFirstPerson
		var2.Enabled = true
		local var6 = var5:GetLastInputType()
		if var6 == Enum.UserInputType.Touch then
			var8.Text = "Tap the button to take a photo"
		else
			if var6.Name:find("Gamepad") then
				var8.Text = "R2 to take photo \194\183 B to cancel"
			else
				var8.Text = "Click or E to take photo \194\183 Q to cancel"
			end
		end

		var4:Create(var14, TweenInfo.new(0.25), { FieldOfView = 55 }):Play()
		if var5:GetLastInputType().Name:find("Gamepad") then
			var6 = game:GetService("GuiService")
			var6.SelectedObject = nil
		end
	end,
	Close = function()
		if not bool1 then
			return
		end

		bool1 = false
		var2.Enabled = false
		if var15 then
			var1.CameraMode = var15.mode
			var1.CameraMinZoomDistance = var15.minZoom
			var1.CameraMaxZoomDistance = var15.maxZoom
			local var3 = TweenInfo.new(0.25)
			var4:Create(var14, var3, { FieldOfView = var15.fov }):Play()
		end

		var13:Fire()
	end,
}

tbl1.Snap = function()
	if not bool1 or bool2 then
		return
	end

	bool2 = true
	play("Shutter")
	local var1 = raycastTarget()
	var9.BackgroundTransparency = 0
	var4:Create(var9, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
	local var3 = var6:FindFirstChildOfClass("UIScale")
	local var5 = var14.CFrame
	if var3 then
		var3.Scale = 0.85
		var4:Create(var3, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end

	task.wait(0.3)
	var11:FireServer(var5, var1)
	var12:Fire(var1, var5)
	tbl1.Close()
	bool2 = false
end

tbl1.IsOpen = function()
	return bool1
end

var6.Activated:Connect(tbl1.Snap)
var7.Activated:Connect(tbl1.Close)
var5.InputBegan:Connect(function(arg1, arg2)
	if not bool1 or arg2 then
		return
	end

	if arg1.UserInputType == Enum.UserInputType.MouseButton1 or (arg1.KeyCode == Enum.KeyCode.E or (arg1.KeyCode == Enum.KeyCode.ButtonR2 or arg1.KeyCode == Enum.KeyCode.ButtonA)) then
		tbl1.Snap()
		return
	end

	if arg1.KeyCode == Enum.KeyCode.Q or arg1.KeyCode == Enum.KeyCode.ButtonB then
		tbl1.Close()
	end
end)

var5.LastInputTypeChanged:Connect(function()
	if bool1 then
		local var3 = var5:GetLastInputType()
		if var3 == Enum.UserInputType.Touch then
			var8.Text = "Tap the button to take a photo"
			return
		end

		if var3.Name:find("Gamepad") then
			var8.Text = "R2 to take photo \194\183 B to cancel"
			return
		end

		var8.Text = "Click or E to take photo \194\183 Q to cancel"
	end
end)

return tbl1

--- Players.LocalPlayer.PlayerScripts.Phone.NightAudio [ModuleScript]
-- y u r i

local tbl1 = {}
local var1 = game:GetService("SoundService")
local var2 = game:GetService("Debris")
local var3 = game:GetService("ReplicatedStorage"):WaitForChild("Night"):WaitForChild("Sounds")
local tbl2 = { Stop = function()
	for k1 in tbl1, nil do
		local var1 = tbl1[k1]
		if not var1 then
			continue
		end

		var1:Stop()
		var1:Destroy()
		tbl1[k1] = nil
	end
end }

local function play(arg1)
	local var5 = tbl1[arg1]
	if var5 then
		var5:Stop()
		var5:Destroy()
		tbl1[arg1] = nil
	end

	var5 = var3:FindFirstChild(arg1)
	if not var5 then
		return
	end

	local var6 = var5:Clone()
	var6.Name = "NightAudio_" .. arg1
	var6.Parent = var1
	tbl1[arg1] = var6
	var6.Ended:Once(function()
		local var3 = arg1
		local var4 = tbl1[var3]
		if tbl1[arg1] == var6 and var4 then
			var4:Stop()
			var4:Destroy()
			tbl1[var3] = nil
		end
	end)

	var2:AddItem(var6, 20)
	local function begin()
		if tbl1[arg1] ~= var6 or (not var6.Parent) then
			return
		end

		var6:Play()
		local var1 = var5:GetAttribute("MaxDuration")
		if type(var1) == "number" and 0 < var1 then
			task.delay(var1, function()
				local var3 = arg1
				local var4 = tbl1[var3]
				if tbl1[arg1] == var6 and var4 then
					var4:Stop()
					var4:Destroy()
					tbl1[var3] = nil
				end
			end)

		end
	end

	if var6.IsLoaded then
		begin()
		return
	end

	var6.Loaded:Once(begin)
end

tbl2.Sleep = function()
	tbl2.Stop()
	play("BedRustle")
	play("Breathing")
end

tbl2.Night = function()
	local var2 = tbl1.BedRustle
	if var2 then
		var2:Stop()
		var2:Destroy()
		tbl1.BedRustle = nil
	end

	play("NightBass")
end

tbl2.Wake = function()
	tbl2.Stop()
	play("WakeRustle")
end

task.spawn(function()
	pcall(function()
		game:GetService("ContentProvider"):PreloadAsync(var3:GetChildren())
	end)
end)

game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(tbl2.Stop)
return tbl2

--- Players.LocalPlayer.PlayerScripts.Phone.ChoreMarkerController [ModuleScript]
-- y u r i

local function targetPosition(arg1)
	if not arg1 or (not arg1:IsDescendantOf(workspace)) then
		return nil
	end

	if arg1:IsA("BasePart") then
		return arg1.Position
	end

	if arg1:IsA("Attachment") then
		return arg1.WorldPosition
	end

	if arg1:IsA("Model") then
		return arg1:GetPivot().Position
	end

	return nil
end

local var1 = game:GetService("Players")
local var2 = game:GetService("ReplicatedStorage")
local var3 = game:GetService("RunService")
local bool1 = false
local tbl1 = { Update = function(arg1, arg2, arg3, arg4, arg5)
	local var1 = arg1:GetAttribute("Text")
	if typeof(var1) == "string" and arg3.Text ~= var1 then
		arg3.Text = var1
	end

	local var2 = arg1:FindFirstChild("Target")
	local var3 = var2
	var3 = var3 and targetPosition(var2.Value)
	if arg1:GetAttribute("Enabled") ~= true or (not var3 or (not arg4 or (not arg5))) then
		arg2.Visible = false
		return
	end

	if (arg5.Position - var3).Magnitude <= 5 or 80 < (arg4.CFrame.Position - var3).Magnitude then
		arg2.Visible = false
		return
	end

	local var4 = arg1:GetAttribute("Offset")
	if typeof(var4) ~= "Vector3" then
		var4 = Vector3.new(0, 3, 0)
	end

	local var5, var6 = arg4:WorldToViewportPoint(var3 + var4)
	local var7 = arg4.ViewportSize
	if not var6 or (var5.Z <= 0 or (var7.X <= 0 or var7.Y <= 0)) then
		arg2.Visible = false
		return
	end

	arg2.Position = UDim2.fromScale(var5.X / var7.X, var5.Y / var7.Y)
	arg2.Visible = true
end }

tbl1.Start = function()
	if bool1 then
		return
	end

	bool1 = true
	task.spawn(function()
		local var4 = var2:WaitForChild("Tutorial"):WaitForChild("ChoreMarkerState")
		var4:WaitForChild("Target")
		local var5 = var1.LocalPlayer
		local var6 = var5:WaitForChild("PlayerGui"):WaitForChild("ChoreMarkerGui"):WaitForChild("Root")
		local var7 = var6:WaitForChild("Pill"):WaitForChild("Text")
		var3.RenderStepped:Connect(function()
			local var1 = var5.Character
			local var2 = var1
			tbl1.Update(var4, var6, var7, workspace.CurrentCamera, var2 and var1:FindFirstChild("HumanoidRootPart"))
		end)
	end)
end

return tbl1

--- Players.LocalPlayer.PlayerScripts.Phone.EndingAudio [ModuleScript]
-- y u r i

local var1 = setmetatable({}, { __mode = "k" })
local var2 = game:GetService("ContentProvider")
return { Bind = function(arg1)
	if var1[arg1] then
		return
	end

	var1[arg1] = true
	local var3 = arg1:WaitForChild("Backdrop")
	local bool1 = false
	local var4 = arg1:WaitForChild("Sounds"):WaitForChild("OutroMusic")
	local function sync()
		local var1 = arg1.Enabled
		var1 = var1 and var3.Visible
		if var1 == bool1 then
			return
		end

		bool1 = var1
		if bool1 then
			var4:Play()
			return
		end

		var4:Stop()
	end

	local var5 = arg1:GetPropertyChangedSignal("Enabled"):Connect(sync)
	local var6 = var3:GetPropertyChangedSignal("Visible"):Connect(sync)
	arg1.Destroying:Once(function()
		var5:Disconnect()
		var6:Disconnect()
		var4:Stop()
		var1[arg1] = nil
	end)

	task.spawn(function()
		pcall(function()
			var2:PreloadAsync({ var4 })
		end)
	end)

	local var7 = arg1.Enabled
	var7 = var7 and var3.Visible
	if var7 == bool1 then
	elseif var7 then
		var4:Play()
	else
		var4:Stop()
	end
end }

--- Players.LocalPlayer.PlayerScripts.Objective.ObjectiveController [ModuleScript]
-- y u r i

local var1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ObjectiveGui")
local var2 = var1:WaitForChild("Bar")
local var3 = game:GetService("TweenService")
local var4 = var2:WaitForChild("Text")
local var5 = var2:WaitForChild("UIScale")
local var6 = var1:FindFirstChild("Sounds")
local var7 = game:GetService("ReplicatedStorage"):WaitForChild("Objective"):WaitForChild("Set")
var2.Visible = false
local num1 = 0
local function hide(arg1)
	if arg1 ~= num1 then
		return
	end

	var3:Create(var4, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
	local var1 = var3:Create(var5, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.8 })
	var1:Play()
	var1.Completed:Wait()
	if arg1 == num1 then
		var2.Visible = false
	end
end

local function play(arg1)
	local var2 = var6
	var2 = var2 and var6:FindFirstChild(arg1)
	if not var2 or var2.SoundId == "" then
		return
	end

	local var3 = var2:Clone()
	var3.Parent = var1
	var3:Play()
	var3.Ended:Once(function()
		var3:Destroy()
	end)
end

local tbl1 = { Set = function(arg1)
	local var1 = num1 + 1
	num1 = var1
	var1 = num1
	if arg1 ~= nil then
		if arg1 == "" then
			if var2.Visible then
				hide(var1)
			end

			return
		end
	end

	var4.Text = arg1
	var4.TextTransparency = 1
	var2.Visible = true
	var5.Scale = 0.7
	var3:Create(var5, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	var3:Create(var4, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
	play("Objective")
	task.delay(5, hide, var1)
end }

var7.OnClientEvent:Connect(tbl1.Set)
return tbl1

--- Players.LocalPlayer.PlayerScripts.Objective.ObjectiveRunner [LocalScript]
-- y u r i

local str1 = "ObjectiveController"
require(script.Parent:WaitForChild(str1))

--- Players.LocalPlayer.PlayerScripts.LitterCleaning.LitterController [ModuleScript]
-- y u r i

local bool1 = false
local var1 = game:GetService("Players")
local var2 = game:GetService("ContextActionService")
local var3 = game:GetService("GuiService")
local var4 = game:GetService("UserInputService")
local var5 = game:GetService("RunService")
return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local var6 = var1.LocalPlayer
	local var7 = var6:WaitForChild("PlayerGui"):WaitForChild("LitterCleaningGui")
	local var8 = var7:WaitForChild("Panel")
	local var9 = var8:WaitForChild("Board")
	local var10 = var9:WaitForChild("Bag")
	local var11 = nil
	local tbl1 = {}
	local tbl2 = {}
	local var12 = Vector2.zero
	local tbl3 = {}
	local var13 = nil
	local var14 = nil
	local var15 = nil
	local bool2 = false
	local var16 = game.ReplicatedStorage:WaitForChild("LitterCleaning"):WaitForChild("Event")
	local function hide()
		if var11 then
			local var1 = tbl1[var11.index]
			var1.ZIndex = 3
			var1.Position = tbl2[var11.index]
		end

		var11 = nil
		var12 = Vector2.zero
		table.clear(tbl3)
		var10.BackgroundTransparency = 1
		var2:UnbindAction("LitterCarry")
		var13 = nil
		var7.Enabled = false
		var2:UnbindAction("LitterCancel")
		if var3.SelectedObject then
			if var3.SelectedObject:IsDescendantOf(var7) then
				var3.SelectedObject = var14 and (var14.Parent and var14) or nil
			end
		end

		if var15 ~= nil then
			var4.MouseIconEnabled = var15
		end
	end

	local num1 = -math.huge
	local function inside(arg1)
		local var3 = arg1.X.Scale
		local var4 = arg1.Y.Scale
		local bool2 = false
		if var10.Position.X.Scale <= var3 then
			bool2 = false
			if var3 <= var10.Position.X.Scale + var10.Size.X.Scale then
				bool2 = false
				if var10.Position.Y.Scale <= var4 then
					bool2 = var4 <= var10.Position.Y.Scale + var10.Size.Y.Scale
				end
			end
		end

		return bool2
	end

	local tbl4 = {}
	local tbl5 = {}
	local function drop()
		if not var11 then
			return
		end

		num1 = os.clock()
		local var1 = var11.index
		local var3 = tbl1[var1]
		local var4 = inside(var3.Position)
		local var5 = var3.Position.X.Scale
		local var6 = var3.Position.Y.Scale
		local var7 = not var4
		if var11 then
			local var9 = tbl1[var11.index]
			var9.ZIndex = 3
			if var7 then
				var9.Position = tbl2[var11.index]
			end
		end

		var11 = nil
		var12 = Vector2.zero
		table.clear(tbl3)
		var10.BackgroundTransparency = 1
		var2:UnbindAction("LitterCarry")
		if var4 then
			tbl4[var1] = true
			var3.ImageTransparency = 0.45
			var16:FireServer("Drop", var13, var1, var5, var6)
			return
		end

		var16:FireServer("AbortDrag", var13)
		var8.Status.Text = "Drag the poop into the bag."
	end

	local function cancel()
		if var13 and (not bool2) then
			var16:FireServer("Cancel", var13)
		end

		hide()
	end

	local function pick(arg1, arg2)
		if not var13 or (bool2 or (var11 or (tbl5[arg1] or tbl4[arg1]))) then
			return
		end

		if not arg2 and os.clock() - num1 < 0.2 then
			return
		end

		local var1 = Vector2.zero
		var1 = arg2 and Vector2.new(arg2.Position.X, arg2.Position.Y) - (tbl1[arg1].AbsolutePosition + tbl1[arg1].AbsoluteSize / 2)
		var11 = { index = arg1, input = arg2, offset = var1 }
		tbl1[arg1].ZIndex = 5
		var16:FireServer("Grab", var13, arg1)
		if not arg2 then
			var8.Status.Text = "Move with stick / D-pad. A to drop."
			var2:BindActionAtPriority("LitterCarry", function(_, arg2, arg3)
				if arg3.KeyCode == Enum.KeyCode.ButtonA then
					if arg2 == Enum.UserInputState.Begin then
						drop()
					end
				else
					if arg3.KeyCode == Enum.KeyCode.Thumbstick1 then
						local var1 = arg2 == Enum.UserInputState.End and Vector2.zero or Vector2.new(arg3.Position.X, -arg3.Position.Y)
						var12 = var1
					else
						tbl3[arg3.KeyCode] = arg2 ~= Enum.UserInputState.End
					end
				end

				return Enum.ContextActionResult.Sink
			end, false, 4100, Enum.KeyCode.ButtonA, Enum.KeyCode.Thumbstick1, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight)

		end
	end

	for i1 = 1, 5 do
		local var17 = var9:WaitForChild("Poop" .. i1)
		tbl1[i1] = var17
		tbl2[i1] = var17.Position
		var17.InputBegan:Connect(function(arg1)
			if arg1.UserInputType == Enum.UserInputType.MouseButton1 or arg1.UserInputType == Enum.UserInputType.Touch then
				pick(i1, arg1)
			end
		end)

		var17.Activated:Connect(function(arg1)
			if arg1 and string.find(arg1.UserInputType.Name, "Gamepad", 1, true) then
				pick(i1, nil)
			end
		end)

	end

	var4.InputChanged:Connect(function(arg1)
		if not var11 or (not var11.input) then
			return
		end

		local var2 = var11.input.UserInputType == Enum.UserInputType.Touch
		if var2 and arg1 ~= var11.input or not var2 and arg1.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		local var3 = var9.AbsoluteSize
		if var3.X <= 0 or var3.Y <= 0 then
			return
		end

		local var4 = Vector2.new(arg1.Position.X, arg1.Position.Y) - var9.AbsolutePosition - var11.offset
		tbl1[var11.index].Position = UDim2.fromScale(math.clamp(var4.X / var3.X, 0.04, 0.96), (math.clamp(var4.Y / var3.Y, 0.06, 0.94)))
		local var5 = var10
		local var6 = if inside(tbl1[var11.index].Position) then 0.7 else 1
		var5.BackgroundTransparency = var6
	end)

	var4.InputEnded:Connect(function(arg1)
		if var11 and (var11.input and (arg1 == var11.input or var11.input.UserInputType == Enum.UserInputType.MouseButton1 and arg1.UserInputType == Enum.UserInputType.MouseButton1)) then
			drop()
		end
	end)

	var5.RenderStepped:Connect(function(arg1)
		if not var11 or var11.input then
			return
		end

		local var1 = 0.18 < var12.Magnitude and var12 or Vector2.zero
		local var2 = Vector2.new
		local var3 = if tbl3[Enum.KeyCode.DPadRight] then 1 else 0
		local var4 = var3 - (if tbl3[Enum.KeyCode.DPadLeft] then 1 else 0)
		local var5 = if tbl3[Enum.KeyCode.DPadDown] then 1 else 0
		var1 = var1 + var2(var4, var5 - (if tbl3[Enum.KeyCode.DPadUp] then 1 else 0))
		var2 = tbl1[var11.index]
		var4 = UDim2.fromScale(math.clamp(var2.Position.X.Scale + var1.X * arg1 * 0.65, 0.04, 0.96), (math.clamp(var2.Position.Y.Scale + var1.Y * arg1 * 0.65, 0.06, 0.94)))
		var2.Position = var4
		var4 = var10
		var3 = if inside(var2.Position) then 0.7 else 1
		var4.BackgroundTransparency = var3
	end)

	var4.WindowFocusReleased:Connect(function()
		if var11 then
			var16:FireServer("AbortDrag", var13)
			if var11 then
				local var1 = tbl1[var11.index]
				var1.ZIndex = 3
				var1.Position = tbl2[var11.index]
			end

			var11 = nil
			var12 = Vector2.zero
			table.clear(tbl3)
			var10.BackgroundTransparency = 1
			var2:UnbindAction("LitterCarry")
		end
	end)

	var8.Exit.Activated:Connect(cancel)
	var16.OnClientEvent:Connect(function(arg1, arg2, arg3)
		local var1
		if arg1 == "Start" then
			if var7.Enabled then
				hide()
			end

			var13 = arg2
			bool2 = false
			table.clear(tbl5)
			table.clear(tbl4)
			var14 = var3.SelectedObject
			var15 = var4.MouseIconEnabled
			var4.MouseIconEnabled = true
			for k1, v1 in tbl1, nil do
				v1.Visible = true
				v1.ImageTransparency = 0
				v1.Position = tbl2[k1]
				v1.ZIndex = 3
			end

			var8.Progress.Text = "0 / 5 cleaned"
			var8.Meter.Fill.Size = UDim2.fromScale(0, 1)
			var8.Status.Text = "Drag the poop into the bag."
			var7.Enabled = true
			if string.find(var4:GetLastInputType().Name, "Gamepad", 1, true) then
				var3.SelectedObject = tbl1[1]
				var8.Status.Text = "Select poop and press A to pick it up."
			end

			local bool1 = false
			var2:BindActionAtPriority("LitterCancel", function(_, arg2)
				if arg2 == Enum.UserInputState.Begin then
					if var13 and (not bool2) then
						var16:FireServer("Cancel", var13)
					end

					hide()
				end

				return Enum.ContextActionResult.Sink
			end, bool1, 4200, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)

			return
		end

		if arg2 ~= var13 then
			return
		end

		if arg1 == "Retry" then
			if var11 then
				if var11.index == arg3 then
					if var11 then
						local var5 = tbl1[var11.index]
						var5.ZIndex = 3
						var5.Position = tbl2[var11.index]
					end

					var11 = nil
					var12 = Vector2.zero
					table.clear(tbl3)
					var10.BackgroundTransparency = 1
					var2:UnbindAction("LitterCarry")
				end
			end

			if not (tbl1[arg3] and (not tbl5[arg3])) then
				return
			end

			if not not tbl5[arg3] then
				return
			end

			tbl4[arg3] = nil
			tbl1[arg3].Position = tbl2[arg3]
			tbl1[arg3].ImageTransparency = 0
			return
		end

		if arg1 == "Collected" then
			tbl5[arg3.index] = true
			tbl4[arg3.index] = nil
			tbl1[arg3.index].Visible = false
			var8.Progress.Text = arg3.found .. " / 5 cleaned"
			var8.Meter.Fill.Size = UDim2.fromScale(arg3.found / 5, 1)
			local var9 = var7.Sounds:FindFirstChild("Found")
			if var9 then
				var9:Stop()
				var9:Play()
			end

			local var17 = arg3.index
			if var3.SelectedObject ~= tbl1[var17] then
				return
			end

			for k2, v2 in tbl1, nil do
				if tbl5[k2] then
					continue
				end

				var3.SelectedObject = v2
				return
			end

			return
		end

		if arg1 == "Win" or arg1 == "End" then
			bool2 = true
			if var11 then
				local var18 = tbl1[var11.index]
				var18.ZIndex = 3
				var18.Position = tbl2[var11.index]
			end

			var11 = nil
			var12 = Vector2.zero
			table.clear(tbl3)
			var10.BackgroundTransparency = 1
			var2:UnbindAction("LitterCarry")
			local var19 = var8.Status
			var19.Text = if arg1 == "Win" then "Litter box cleaned." else arg3 or "Cleaning ended."
			var19 = var7.Sounds:FindFirstChild("Win")
			if arg1 == "Win" and var19 then
				var19:Stop()
				var19:Play()
			end

			task.delay(1.5, function()
				if var13 == arg2 then
					hide()
				end
			end)

		end
	end)

	var6.CharacterRemoving:Connect(cancel)
end }

--- Players.LocalPlayer.PlayerScripts.LitterCleaning.LitterRunner [LocalScript]
-- y u r i

local str1 = "LitterController"
require(script.Parent:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerScripts.FeedingAudio.FeedingAudio [ModuleScript]
-- y u r i

local var1 = game:GetService("Debris")
local bool1 = false
local var2 = game:GetService("ReplicatedStorage")
local function play(arg1, arg2)
	if not arg2 or (not arg2:IsA("BasePart") or (not arg2:IsDescendantOf(workspace))) then
		return nil
	end

	local var2 = arg1:Clone()
	var2.Name = "Feeding" .. arg1.Name
	var2.Parent = arg2
	var2:Play()
	if not var2.Looped then
		local var3 = var2:GetAttribute("MaxDuration")
		var1:AddItem(var2, type(var3) == "number" and (0 < var3 and var3) or 15)
		var2.Ended:Once(function()
			var2:Destroy()
		end)

	end

	return var2
end

local var3 = game:GetService("RunService")
return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local var1 = var2:WaitForChild("FeedingAudio")
	local var4 = var1:WaitForChild("Sounds")
	local var5 = var4:WaitForChild("Pickup")
	local var6 = var4:WaitForChild("Fill")
	var1:WaitForChild("Event").OnClientEvent:Connect(function(arg1, arg2)
		if arg1 == "Pickup" then
			play(var5, arg2)
			return
		end

		if arg1 == "Fill" then
			play(var6, arg2)
		end
	end)

	local num1 = 0
	local var7 = nil
	local var8 = var4:WaitForChild("Eat")
	var3.Heartbeat:Connect(function(arg1)
		local var1 = num1 + arg1
		num1 = var1
		if num1 < 0.1 then
			return
		end

		num1 = 0
		var1 = workspace:FindFirstChild("House")
		local var2 = var1
		var2 = var2 and var1:FindFirstChild("Important")
		local var3 = var2
		var3 = var3 and var2:FindFirstChild("Kitchen")
		local var4 = var3
		local var5 = workspace:FindFirstChild("Cat")
		local var6 = var5
		local var9 = var5
		var4 = var4 and var3:FindFirstChild("FoodBowl")
		local var11 = var4
		var6 = var6 and (var5:FindFirstChild("Head") or var5.PrimaryPart)
		var9 = var9 and var5:FindFirstChildOfClass("Humanoid")
		if var11 then
			var11 = false
			if var4:GetAttribute("State") == "Eating" then
				var11 = var5
				if var11 then
					var11 = false
					if var5:GetAttribute("Hold") == true then
						var11 = var6
						if var11 then
							var11 = not var9
							if not var11 then
								var11 = 0 < var9.Health
							end
						end
					end
				end
			end
		end

		if var7 and (not var11 or var7.Parent ~= var6) then
			var7:Stop()
			var7:Destroy()
			var7 = nil
		end

		if var11 and (not var7) then
			var7 = play(var8, var6)
		end
	end)
end }

--- Players.LocalPlayer.PlayerScripts.FeedingAudio.Runner [LocalScript]
-- y u r i

local str1 = "FeedingAudio"
require(script.Parent:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerScripts.MailTask.MailController [ModuleScript]
-- y u r i

local bool1 = false
local var1 = game:GetService("ReplicatedStorage")
local var2 = game:GetService("Debris")
local var3 = game:GetService("TweenService")
return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local var4 = var1:WaitForChild("MailTask")
	local var5 = var4:WaitForChild("Sounds")
	local function sound(arg1, arg2)
		local var3 = var5:FindFirstChild(arg1)
		if not var3 or (not arg2 or (not arg2:IsDescendantOf(workspace))) then
			return
		end

		local var4 = var3:Clone()
		var4.Parent = arg2
		var4:Play()
		var4.Ended:Once(function()
			var4:Destroy()
		end)

		var2:AddItem(var4, 8)
	end

	local var6 = var4:WaitForChild("MailVisual")
	local function collect(arg1, arg2)
		sound("Collect", arg2)
		local var4 = workspace.CurrentCamera
		if not var4 or 100 < (var4.CFrame.Position - arg1.Position).Magnitude then
			return
		end

		local var5 = var6:Clone()
		var5:PivotTo(arg1)
		var5.Parent = workspace
		var2:AddItem(var5, 3)
		local var7 = Instance.new("CFrameValue")
		var7.Value = arg1
		local var8 = var7.Changed:Connect(function(arg1)
			if var5.Parent then
				var5:PivotTo(arg1)
			end
		end)

		local var9 = arg1 * CFrame.new(0, 0.65, 1.85) * CFrame.Angles(-0.20943951023931956, 0, 0.13962634015954636)
		local var10 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local var11 = var3:Create(var7, var10, { Value = var9 })
		var11:Play()
		var11.Completed:Wait()
		local var12 = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local var13 = var9 * CFrame.new(0, 0.3, 0.6)
		local var14 = var3:Create(var7, var12, { Value = var13 })
		var14:Play()
		var14.Completed:Wait()
		for k1, v1 in var5:GetDescendants() do
			if not v1:IsA("BasePart") then
				continue
			end

			var3:Create(v1, TweenInfo.new(0.15), { Transparency = 1 }):Play()
		end

		task.wait(0.15)
		var8:Disconnect()
		var7:Destroy()
		var5:Destroy()
	end

	var4:WaitForChild("Effects").OnClientEvent:Connect(function(arg1, arg2, arg3)
		if arg1 == "Sound" then
			sound(arg2, arg3)
			return
		end

		if arg1 == "Collect" then
			collect(arg2, arg3)
		end
	end)
end }

--- Players.LocalPlayer.PlayerScripts.MailTask.Runner [LocalScript]
-- y u r i

local str1 = "MailController"
require(script.Parent:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerScripts.MealAudio.MealAudio [ModuleScript]
-- y u r i

local var1 = game:GetService("Debris")
local bool1 = false
local var2 = game:GetService("ReplicatedStorage")
local function play(arg1, arg2)
	if typeof(arg2) ~= "Instance" or (not arg2:IsA("BasePart") or (not arg2:IsDescendantOf(workspace))) then
		return
	end

	local var3 = arg2:FindFirstChild("MealAudio_" .. arg1.Name)
	if var3 then
		var3:Destroy()
	end

	local var4 = arg1:Clone()
	var4.Name = "MealAudio_" .. arg1.Name
	var4.Parent = arg2
	local function begin()
		if not var4.Parent then
			return
		end

		var4.TimePosition = arg1:GetAttribute("StartTime") or 0
		var4:Play()
		local var1 = arg1:GetAttribute("MaxDuration")
		if not var4.Looped and (type(var1) == "number" and 0 < var1) then
			task.delay(var1, function()
				if var4.Parent then
					var4:Destroy()
				end
			end)

		end
	end

	if not var4.Looped then
		var1:AddItem(var4, 15)
		var4.Ended:Once(function()
			var4:Destroy()
		end)

	end

	if var4.IsLoaded then
		begin()
		return var4
	end

	var4.Loaded:Once(begin)
	return var4
end

local var3 = game:GetService("RunService")
return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local var1 = var2:WaitForChild("Meal")
	local var4 = var1:WaitForChild("Sounds")
	task.spawn(function()
		pcall(function()
			game:GetService("ContentProvider"):PreloadAsync(var4:GetChildren())
		end)
	end)

	var1:WaitForChild("Audio").OnClientEvent:Connect(function(arg1, arg2)
		local var2 = var4:FindFirstChild(arg1)
		if var2 and (var2:IsA("Sound") and (not var2.Looped)) then
			play(var2, arg2)
		end
	end)

	local num1 = 0
	local var5 = nil
	local var6 = var4:WaitForChild("Hum")
	var3.Heartbeat:Connect(function(arg1)
		local var1 = num1 + arg1
		num1 = var1
		if num1 < 0.1 then
			return
		end

		num1 = 0
		var1 = workspace:FindFirstChild("House")
		local var2 = var1
		var2 = var2 and var1:FindFirstChild("Important")
		local var3 = var2
		var3 = var3 and var2:FindFirstChild("Kitchen")
		local var4 = var3
		var4 = var4 and var3:FindFirstChild("Cabinets")
		local var7 = var4
		var7 = var7 and var4:FindFirstChild("Microwave")
		local var8 = var7
		var8 = var8 and var7:FindFirstChild("Carcass")
		local var9 = var8
		local var11 = var7
		var9 = var9 and var8:FindFirstChild("Turntable")
		if var11 then
			var11 = false
			if var7:GetAttribute("State") == "Cooking" then
				var11 = var9
			end
		end

		if var5 and (not var11 or var5.Parent ~= var9) then
			var5:Stop()
			var5:Destroy()
			var5 = nil
		end

		if var11 and (not var5) then
			var5 = play(var6, var9)
		end
	end)
end }

--- Players.LocalPlayer.PlayerScripts.MealAudio.Runner [LocalScript]
-- y u r i

local str1 = "MealAudio"
require(script.Parent:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerGui.CustomMouseIcon [LocalScript]
-- y u r i

local var1 = game:GetService("Players").LocalPlayer:GetMouse()
var1.Icon = "rbxassetid://16971310980"

--- ReplicatedStorage.CatAnimationTracks [ModuleScript]
-- y u r i

local var1 = game:GetService("RunService")
local var2 = game:GetService("KeyframeSequenceProvider")
local tbl1 = {}
tbl1.__index = tbl1
tbl1.new = function(arg1, arg2)
	local var2 = arg1
	assert(var2 and arg1:IsA("Model"), "Expected a Cat model")
	var2 = var1:IsServer()
	assert(var2 or (not var1:IsRunning()), "Control NPC tracks from the server")
	var2 = not arg2
	assert(var2 or var1:IsStudio(), "Local clips are Studio-only")
	var2 = assert(assert(arg1:FindFirstChildOfClass("Humanoid"), "Cat needs a Humanoid"):FindFirstChildOfClass("Animator"), "Cat needs an Animator")
	return (setmetatable({
		Cat = arg1,
		Animator = var2,
		Tracks = {},
		PreviewAssets = {},
		StudioPreview = arg2 == true,
		Destroyed = false,
	}, tbl1))
end

local tbl2 = {
	Walk = Enum.AnimationPriority.Movement,
	Idle = Enum.AnimationPriority.Idle,
	Sleep = Enum.AnimationPriority.Action,
}

tbl1.Load = function(arg1, arg2)
	assert(not arg1.Destroyed, "Animation player was destroyed")
	assert(tbl2[arg2], "Unknown Cat animation: " .. tostring(arg2))
	if arg1.Tracks[arg2] then
		return arg1.Tracks[arg2]
	end

	local var1 = nil
	if arg1.StudioPreview then
		var1 = Instance.new("Animation")
		local var3 = assert(assert(assert(arg1.Cat:FindFirstChild("AnimSaves"), "Missing AnimSaves").Value, "Missing saved clips"):FindFirstChild(arg2), "Missing clip " .. arg2)
		var1.Name = arg2 .. "StudioPreview"
		var1.AnimationId = var2:RegisterKeyframeSequence(var3)
		table.insert(arg1.PreviewAssets, var1)
	else
		var1 = assert(assert(arg1.Cat:FindFirstChild("Animations"), "Missing Animations folder"):FindFirstChild(arg2), "Missing Animation " .. arg2)
		assert(var1:IsA("Animation"), "Expected Animation instance")
		local bool1 = false
		if var1.AnimationId ~= "" then
			bool1 = var1.AnimationId ~= "rbxassetid://0"
		end

		assert(bool1, "Publish " .. arg2 .. " and set Cat.Animations." .. arg2 .. ".AnimationId")
	end

	local var4 = arg1.Animator:LoadAnimation(var1)
	var4.Name = arg2
	var4.Looped = true
	var4.Priority = tbl2[arg2]
	arg1.Tracks[arg2] = var4
	return var4
end

tbl1.Play = function(arg1, arg2, arg3, arg4)
	local var2 = arg3
	local var3 = arg1:Load(arg2)
	if not var2 then
		var2 = if arg2 == "Sleep" then 0.6 else 0.2
	end

	local bool2 = false
	if type(var2) == "number" then
		bool2 = false
		if 0 <= var2 then
			bool2 = var2 < math.huge
		end
	end

	assert(bool2, "Invalid fade time")
	local var4 = arg4 or 1
	local var5 = var4
	local bool4 = false
	if type(var5) == "number" then
		bool4 = false
		if 0 <= var4 then
			bool4 = var4 < math.huge
		end
	end

	assert(bool4, "Invalid animation speed")
	for k1, v1 in arg1.Tracks, nil do
		if k1 == arg2 then
			continue
		end

		if not v1.IsPlaying then
			continue
		end

		v1:Stop(var2)
	end

	if var3.IsPlaying then
		var3:AdjustSpeed(var4)
		return var3
	end

	var3:Play(var2, 1, var4)
	return var3
end

tbl1.Stop = function(arg1, arg2)
	for k1, v1 in arg1.Tracks, nil do
		v1:Stop(arg2 or 0.2)
	end
end

tbl1.Destroy = function(arg1)
	if arg1.Destroyed then
		return
	end

	arg1.Destroyed = true
	for k1, v1 in arg1.Tracks, nil do
		v1:Stop(0)
		v1:Destroy()
	end

	for k2, v2 in arg1.PreviewAssets, nil do
		v2:Destroy()
	end

	table.clear(arg1.Tracks)
	table.clear(arg1.PreviewAssets)
end

return tbl1

--- ReplicatedStorage.PromptPolicy.Policy [ModuleScript]
-- y u r i

local bool1 = false
local var1 = setmetatable({}, { __mode = "k" })
return { Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local function register(arg1)
		if not arg1:IsA("ProximityPrompt") or var1[arg1] then
			return
		end

		var1[arg1] = true
		arg1.ClickablePrompt = false
		local var2 = arg1:GetPropertyChangedSignal("ClickablePrompt"):Connect(function()
			if arg1.ClickablePrompt then
				arg1.ClickablePrompt = false
			end
		end)

		arg1.Destroying:Once(function()
			var2:Disconnect()
			var1[arg1] = nil
		end)
	end

	game.DescendantAdded:Connect(register)
	for k1, v1 in game:GetDescendants() do
		register(v1)
	end

	game:GetService("ProximityPromptService").PromptShown:Connect(register)
end }

--- Workspace.Cat.AnimationTracks [ModuleScript]
-- y u r i

local var1 = game:GetService("RunService")
local var2 = game:GetService("KeyframeSequenceProvider")
local tbl1 = {}
tbl1.__index = tbl1
tbl1.new = function(arg1, arg2)
	local var2 = arg1
	assert(var2 and arg1:IsA("Model"), "Expected a Cat model")
	var2 = var1:IsServer()
	assert(var2 or (not var1:IsRunning()), "Control NPC tracks from the server")
	var2 = not arg2
	assert(var2 or var1:IsStudio(), "Local clips are Studio-only")
	var2 = assert(assert(arg1:FindFirstChildOfClass("Humanoid"), "Cat needs a Humanoid"):FindFirstChildOfClass("Animator"), "Cat needs an Animator")
	return (setmetatable({
		Cat = arg1,
		Animator = var2,
		Tracks = {},
		PreviewAssets = {},
		StudioPreview = arg2 == true,
		Destroyed = false,
	}, tbl1))
end

local tbl2 = {
	Walk = Enum.AnimationPriority.Movement,
	Idle = Enum.AnimationPriority.Idle,
	Sleep = Enum.AnimationPriority.Action,
}

tbl1.Load = function(arg1, arg2)
	assert(not arg1.Destroyed, "Animation player was destroyed")
	assert(tbl2[arg2], "Unknown Cat animation: " .. tostring(arg2))
	if arg1.Tracks[arg2] then
		return arg1.Tracks[arg2]
	end

	local var1 = nil
	if arg1.StudioPreview then
		var1 = Instance.new("Animation")
		local var3 = assert(assert(assert(arg1.Cat:FindFirstChild("AnimSaves"), "Missing AnimSaves").Value, "Missing saved clips"):FindFirstChild(arg2), "Missing clip " .. arg2)
		var1.Name = arg2 .. "StudioPreview"
		var1.AnimationId = var2:RegisterKeyframeSequence(var3)
		table.insert(arg1.PreviewAssets, var1)
	else
		var1 = assert(assert(arg1.Cat:FindFirstChild("Animations"), "Missing Animations folder"):FindFirstChild(arg2), "Missing Animation " .. arg2)
		assert(var1:IsA("Animation"), "Expected Animation instance")
		local bool1 = false
		if var1.AnimationId ~= "" then
			bool1 = var1.AnimationId ~= "rbxassetid://0"
		end

		assert(bool1, "Publish " .. arg2 .. " and set Cat.Animations." .. arg2 .. ".AnimationId")
	end

	local var4 = arg1.Animator:LoadAnimation(var1)
	var4.Name = arg2
	var4.Looped = true
	var4.Priority = tbl2[arg2]
	arg1.Tracks[arg2] = var4
	return var4
end

tbl1.Play = function(arg1, arg2, arg3, arg4)
	local var2 = arg3
	local var3 = arg1:Load(arg2)
	if not var2 then
		var2 = if arg2 == "Sleep" then 0.6 else 0.2
	end

	local bool2 = false
	if type(var2) == "number" then
		bool2 = false
		if 0 <= var2 then
			bool2 = var2 < math.huge
		end
	end

	assert(bool2, "Invalid fade time")
	local var4 = arg4 or 1
	local var5 = var4
	local bool4 = false
	if type(var5) == "number" then
		bool4 = false
		if 0 <= var4 then
			bool4 = var4 < math.huge
		end
	end

	assert(bool4, "Invalid animation speed")
	for k1, v1 in arg1.Tracks, nil do
		if k1 == arg2 then
			continue
		end

		if not v1.IsPlaying then
			continue
		end

		v1:Stop(var2)
	end

	if var3.IsPlaying then
		var3:AdjustSpeed(var4)
		return var3
	end

	var3:Play(var2, 1, var4)
	return var3
end

tbl1.Stop = function(arg1, arg2)
	for k1, v1 in arg1.Tracks, nil do
		v1:Stop(arg2 or 0.2)
	end
end

tbl1.Destroy = function(arg1)
	if arg1.Destroyed then
		return
	end

	arg1.Destroyed = true
	for k1, v1 in arg1.Tracks, nil do
		v1:Stop(0)
		v1:Destroy()
	end

	for k2, v2 in arg1.PreviewAssets, nil do
		v2:Destroy()
	end

	table.clear(arg1.Tracks)
	table.clear(arg1.PreviewAssets)
end

return tbl1

--- Workspace.hspspjl.WalkSounds [LocalScript]
-- y u r i

local var1 = script.Parent
local var2 = var1:WaitForChild("Humanoid")
local tbl1 = {
	[Enum.Material.Grass] = "rbxassetid://379482039",
	[Enum.Material.Ground] = "rbxassetid://379482039",
	[Enum.Material.Metal] = "rbxassetid://1439074022",
	[Enum.Material.DiamondPlate] = "rbxassetid://1439074022",
	[Enum.Material.Pebble] = "rbxassetid://267882971",
	[Enum.Material.Wood] = "rbxassetid://2015989574",
	[Enum.Material.WoodPlanks] = "rbxassetid://2015989574",
	[Enum.Material.Plastic] = "rbxassetid://833564121",
	[Enum.Material.SmoothPlastic] = "rbxassetid://833564121",
	[Enum.Material.Sand] = "rbxassetid://265653329",
	[Enum.Material.Fabric] = "rbxassetid://133705377",
	[Enum.Material.Carpet] = "rbxassetid://133705377",
	[Enum.Material.Concrete] = "rbxassetid://833564121",
	[Enum.Material.Cobblestone] = "rbxassetid://833564121",
	[Enum.Material.Pavement] = "rbxassetid://833564121",
	[Enum.Material.Rock] = "rbxassetid://833564121",
	[Enum.Material.CorrodedMetal] = "rbxassetid://1439074022",
}

local var3 = var1:WaitForChild("HumanoidRootPart"):WaitForChild("Running")
var2:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
	local var4 = tbl1[var2.FloorMaterial]
	if var4 then
		var3.SoundId = var4
		var3.Volume = 0.2
	end
end)

--- Workspace.hspspjl.Health [Script]
-- Failed to get bytecode:
--[[
nil
--]]

