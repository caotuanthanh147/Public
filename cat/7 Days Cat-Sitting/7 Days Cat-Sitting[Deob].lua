--- Players.LocalPlayer.PlayerScripts.LobbyPromptPolicyRunner [LocalScript]
-- y u r i

local str1 = "LobbyPromptPolicy"
require(game.ReplicatedStorage:WaitForChild(str1)).Start()
local var1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("EndingsGui")
local var2 = var1:WaitForChild("Panel")
local var3 = game:GetService("ReplicatedStorage"):WaitForChild("Endings")
local tbl1 = {}
local tbl2 = {}
local var4 = var3:WaitForChild("Catalog")
local var5 = var2:WaitForChild("Templates")
local var6 = var2:WaitForChild("List")
local var7 = var2.Header:WaitForChild("Count")
local bool1 = false
local function render(arg1)
	tbl1 = arg1
	for k1, v1 in tbl2, nil do
		local bool1 = false
		v1.Visible = bool1
	end

	local var1 = var4:GetChildren()
	table.sort(var1, function(arg1, arg2)
		local var5
		local var3 = arg1:GetAttribute("Order") or 99
		local var4 = arg2:GetAttribute("Order") or 99
		if var3 == var4 then
			local bool1 = true
			if arg1.Name >= arg2.Name then
				bool1 = var3 < var4
			end
		end

		return var5
	end)

	local num1 = 0
	for k2, v2 in var1, nil do
		local var3 = tbl2[v2]
		if not var3 then
			var3 = var5.Row:Clone()
			tbl2[v2] = var3
			var3.Parent = var6
		end

		local var9 = arg1[v2.Name]
		local bool2 = false
		if var9 ~= nil then
			bool2 = var9 ~= false
		end

		local var10 = v2:GetAttribute("Title")
		var3.Title.Text = var10 or v2.Name
		local var11 = if bool2 then "Unlocked" else "Locked"
		if typeof(var9) == "number" and 0 < var9 then
			var11 = var11 .. " \194\183 " .. os.date("%b %d, %Y", var9)
		end

		var3.Sub.Text = var11
		local str1 = "BadgeID"
		var3:SetAttribute("BadgeID", v2:GetAttribute(str1))
		var10 = v2:GetAttribute("IconImageId")
		local var12 = var10 and "rbxassetid://" .. string.format("%.0f", var10) or ""
		var3.Icon.Thumbnail.Image = var12
		var3.Icon.Mark.Visible = false
		var12 = bool2 and Color3.fromRGB(255, 214, 10) or Color3.fromRGB(58, 58, 60)
		var3.Icon.BackgroundColor3 = var12
		var12 = bool2 and Color3.new(1, 1, 1) or Color3.fromRGB(190, 190, 195)
		var3.Title.TextColor3 = var12
		local var13 = var3.Icon.Thumbnail
		var13.ImageTransparency = if bool2 then 0 else 0.2
		if bool2 then
			num1 = num1 + 1
		end

		var3.LayoutOrder = k2
		var3.Visible = true
	end

	var7.Text = string.format("%d / %d unlocked", num1, #var1)
end

local function queueRender()
	if bool1 then
		return
	end

	bool1 = true
	task.defer(function()
		bool1 = false
		render(tbl1)
	end)
end

local var8 = game:GetService("TweenService")
str1 = game:GetService("GuiService")
local var9 = game:GetService("UserInputService")
local var10 = game:GetService("ContextActionService")
local var11 = var1:WaitForChild("OpenButton")
local var12 = var2.Header:WaitForChild("Close")
local var13 = var2:WaitForChild("UIScale")
local var14 = var3:WaitForChild("Get")
local bool2 = false
local function watchEntry(arg1)
	arg1.AttributeChanged:Connect(queueRender)
	if bool1 then
		return
	end

	bool1 = true
	task.defer(function()
		bool1 = false
		render(tbl1)
	end)
end

for k1, v1 in var4:GetChildren() do
	v1.AttributeChanged:Connect(queueRender)
if not bool1 then
		bool1 = true
		task.defer(function()
			bool1 = false
			render(tbl1)
		end)

	end
end

var4.ChildAdded:Connect(watchEntry)
var4.ChildRemoved:Connect(queueRender)
local function closePanel()
	if not bool2 then
		return
	end

	bool2 = false
	local var1 = var8:Create(var13, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.85 })
	var1:Play()
	var1.Completed:Wait()
	if not bool2 then
		var2.Visible = false
	end

	if str1.SelectedObject and str1.SelectedObject:IsDescendantOf(var2) then
		str1.SelectedObject = nil
	end
end

local function open()
	if bool2 then
		return
	end

	bool2 = true
	var2.Visible = true
	var13.Scale = 0.85
	var8:Create(var13, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	task.spawn(function()
		local success, result = pcall(var14.InvokeServer, var14)
		local var1 = render
		if success then
			local var2 = type(result) == "table" and result or {}
		end

		var1({})
	end)

	if var9:GetLastInputType().Name:find("Gamepad") then
		str1.SelectedObject = var12
	end
end

var11.Activated:Connect(function()
	if bool2 then
		closePanel()
		return
	end

	open()
end)

var12.Activated:Connect(closePanel)
var10:BindAction("CloseEndings", function(_, arg2)
	if arg2 == Enum.UserInputState.Begin and bool2 then
		closePanel()
		return Enum.ContextActionResult.Sink
	end

	return Enum.ContextActionResult.Pass
end, false, Enum.KeyCode.ButtonB)

local var15 = var12
for k2, v2 in { var11, var15 }, nil do
	local var16 = v2:FindFirstChildOfClass("UIScale")
	v2.MouseEnter:Connect(function()
		if var16 then
			var8:Create(var16, TweenInfo.new(0.15), { Scale = 1.05 }):Play()
		end
	end)

	v2.MouseLeave:Connect(function()
		if var16 then
			var8:Create(var16, TweenInfo.new(0.15), { Scale = 1 }):Play()
		end
	end)

end

local tbl3 = {}
str1 = workspace:WaitForChild("Lobby"):WaitForChild("Important")
local var17 = game:GetService("RunService")
var8 = function(arg1)
	if arg1:IsA("BasePart") and (arg1.Name == "GlowEdge" and arg1:FindFirstAncestor("TeleportPod")) then
		tbl3[arg1] = true
		arg1.Destroying:Once(function()
			tbl3[arg1] = nil
		end)

	end
end

for k3, v3 in str1:GetDescendants() do
	var8(v3)
end

str1.DescendantAdded:Connect(var8)
var17.Heartbeat:Connect(function()
	local var1 = os.clock() % 2.4 / 2.4 * 3.1415926535897931
	local var2 = 0.5 - math.cos(var1 * 2) * 0.5
	for k1 in tbl3, nil do
		k1.Transparency = var2
	end
end)

var2 = game:GetService("Players").LocalPlayer
var6 = var2:WaitForChild("PlayerGui"):WaitForChild("CatShopGui")
var5 = var6:WaitForChild("Panel")
var7 = var5:WaitForChild("Preview")
tbl3 = game:GetService("ReplicatedStorage")
Color3.fromRGB(221, 210, 193)
var8 = game:GetService("RunService")
str1 = game:GetService("TweenService")
var9 = game:GetService("GuiService")
var10 = game:GetService("UserInputService")
local var18 = game:GetService("ProximityPromptService")
local var19 = game:GetService("ContextActionService")
local var20 = game:GetService("MarketplaceService")
var12 = var5:WaitForChild("UIScale")
var13 = var7:WaitForChild("Action")
var3 = var5:WaitForChild("Skins")
var14 = var5:WaitForChild("Templates")
var4 = var5:WaitForChild("CashColumn")
tbl2 = tbl3:WaitForChild("CatSkins")
tbl1 = tbl3:WaitForChild("Shop")
render = Color3.fromRGB(43, 33, 27)
bool1 = Color3.fromRGB(138, 123, 108)
queueRender = Color3.fromRGB(243, 237, 227)
open = Color3.fromRGB(107, 74, 46)
closePanel = Color3.fromRGB(63, 94, 68)
local var21 = Color3.fromRGB(216, 207, 193)
local tbl4 = { key = "Common", label = "Common", color = Color3.fromRGB(66, 135, 245) }
local tbl5 = { key = "Cool", label = "Cool", color = Color3.fromRGB(155, 89, 230) }
local tbl6 = { tbl4, tbl5, { key = "Epic", label = "Epic", color = Color3.fromRGB(225, 62, 62) } }
tbl5 = Color3.new(1, 1, 1)
bool2 = {}
tbl4 = {}
for k4, v4 in tbl6, nil do
	tbl4[v4.key] = v4
end

local tbl7 = { cash = 0, owned = { Orange = true }, equipped = "Orange" }
local tbl8 = {}
local str2 = "Orange"
local var22 = nil
local function frame(arg1, arg2)
	arg1:ClearAllChildren()
	local var1 = arg2:Clone()
	var1.Parent = arg1
	local var2 = Instance.new("Camera")
	var2.FieldOfView = 34
	var2.Parent = arg1
	arg1.CurrentCamera = var2
	local var5 = var1:FindFirstChild("Head")
	local var6, var7 = var1:GetBoundingBox()
	local var8 = var1:FindFirstChild("Body")
	if var5 then
		if var8 then
			local var9 = Vector3.new(var5.Position.X - var8.Position.X, 0, var5.Position.Z - var8.Position.Z)
			var9 = var9 or var6.LookVector
		end
	end

	local var10 = var6.LookVector
	var10 = 0.01 < var10.Magnitude and var10.Unit or Vector3.new(0, 0, -1)
	var2.CFrame = CFrame.lookAt(var6.Position + (var10 * 0.75 + var10:Cross(Vector3.new(0, 1, 0)) * 0.65).Unit * var7.Magnitude * 1.35 + Vector3.new(0, var7.Magnitude * 0.25, 0), var6.Position)
	return var1, var6.Position
end

local function refreshCards()
	for k1, v1 in tbl8, nil do
		local var1 = v1.Price
		local var2 = tbl2[k1]:GetAttribute("Price") or 0
		local var3
		if tbl7.equipped == k1 then
			var3 = "Equipped"
		else
			if tbl7.owned[k1] then
				var3 = "Owned"
			elseif var2 == 0 then
				var3 = "Free"
			else
				var3 = tostring(var2) .. " cash"
			end
		end

		var1.Text = var3
		v1.Price.TextColor3 = tbl7.equipped == k1 and closePanel or render
		var1 = tbl4[v1:GetAttribute("RarityKey") or "Common"]
		var2 = k1 == str2 and render or (var1 or tbl6[1]).color:Lerp(tbl5, 0.25)
		v1.Outline.Color = var2
		var3 = v1.Outline
		var3.Thickness = if k1 == str2 then 2.5 else 1.5
	end
end

local function refreshPreview()
	local var1 = tbl2[str2]
	local var2 = tbl4[var1:GetAttribute("Rarity") or "Common"]
	local var3 = var1:GetAttribute("DisplayName")
	var7.SkinName.Text = var3 or str2
	var2 = var2 or tbl6[1]
	var7.Rarity.BackgroundColor3 = var2.color
	var7.Rarity.BackgroundTransparency = 0
	var7.Rarity.Text.TextColor3 = tbl5
	var7.BackgroundColor3 = var2.color:Lerp(tbl5, 0.8)
	var7.View.BackgroundColor3 = var2.color:Lerp(tbl5, 0.58)
	local var5 = var7:FindFirstChildOfClass("UIStroke")
	if var5 then
		var5.Color = var2.color:Lerp(tbl5, 0.3)
	end

	var7.Rarity.Text.Text = string.upper(var2.label)
	var3 = var1:GetAttribute("Price") or 0
	var13.Active = true
	if tbl7.equipped == str2 then
		var7.Info.Text = "Equipped"
		var13.Text = "Equipped"
		var13.BackgroundColor3 = var21
		var13.TextColor3 = bool1
		var13.Active = false
	else
		if tbl7.owned[str2] then
			var7.Info.Text = "Owned"
			var13.Text = "Equip"
			var13.BackgroundColor3 = closePanel
			var13.TextColor3 = queueRender
		else
			if var3 <= tbl7.cash then
				var7.Info.Text = tostring(var3) .. " cash"
				var13.Text = "Buy for " .. tostring(var3)
				var13.BackgroundColor3 = open
				var13.TextColor3 = queueRender
			else
				var7.Info.Text = "You need " .. tostring(var3 - tbl7.cash) .. " more cash"
				var13.Text = "Not enough cash"
				var13.BackgroundColor3 = var21
				var13.TextColor3 = bool1
				var13.Active = false
			end
		end
	end

	bool2.Text = tostring(tbl7.cash)
end

local var23 = nil
local var24 = nil
local var25 = nil
local function select(arg1)
	if not tbl2:FindFirstChild(arg1) then
		arg1 = "Orange"
	end

	str2 = arg1
	if var22 then
		var22:Disconnect()
	end

	local var1, var2 = frame(var7.View, tbl2[arg1])
	local var3 = os.clock()
	local var4 = var1:GetPivot()
	var22 = var8.RenderStepped:Connect(function()
		if not var1.Parent then
			var22:Disconnect()
			return
		end

		var1:PivotTo(CFrame.new(var2) * CFrame.Angles(0, (os.clock() - var3) * 0.6, 0) * CFrame.new(-var2) * var4)
	end)

	refreshCards()
	refreshPreview()
end

local bool3 = false
local function build()
	for k1, v1 in var3:GetChildren() do
		if not v1:IsA("Frame") then
			continue
		end

		v1:Destroy()
	end

	tbl8 = {}
	var23 = var14.CrateBanner:Clone()
	var23.Visible = true
	var23.LayoutOrder = 0
	var23.Parent = var3
	var23.Open.Activated:Connect(function()
		if var24 then
			var24()
		end
	end)

	if var25 then
		var25()
	end

	for k2, v2 in tbl6, nil do
		local var1 = var14.Section:Clone()
		var1.Name = v2.key
		var1.LayoutOrder = k2
		var1.Visible = true
		var1.Header.Dot.BackgroundColor3 = v2.color
		var1.Header.Text.Text = v2.label
		var1.Header.Text.TextColor3 = render
		local tbl1 = {}
		for k3, v3 in tbl2:GetChildren() do
			if (v3:GetAttribute("Rarity") or "Common") ~= v2.key then
				continue
			end

			table.insert(tbl1, v3)
		end

		table.sort(tbl1, function(arg1, arg2)
			return (arg1:GetAttribute("Order") or 99) < (arg2:GetAttribute("Order") or 99)
		end)

		var1.Soon.Visible = #tbl1 == 0
		local num1 = 0
		var1.Cards.Visible = num1 < (#tbl1)
		for k4, v4 in tbl1, nil do
			local var2 = var14.Card:Clone()
			var2.Name = v4.Name
			var2.LayoutOrder = k4
			var2.Visible = true
			local var4 = v4:GetAttribute("DisplayName")
			var2.SkinName.Text = var4 or v4.Name
			var2.Bar.Visible = false
			var2.BackgroundColor3 = v2.color:Lerp(tbl5, 0.72)
			var2.View.BackgroundColor3 = v2.color:Lerp(tbl5, 0.55)
			var2:SetAttribute("RarityKey", v2.key)
			var2.Parent = var1.Cards
			frame(var2.View, v4)
			var2.Activated:Connect(function()
				select(v4.Name)
			end)

			var2.SelectionGained:Connect(function()
				select(v4.Name)
			end)

			var2.MouseEnter:Connect(function()
				if v4.Name ~= str2 then
					var2.Outline.Color = v2.color
				end
			end)

			var2.MouseLeave:Connect(refreshCards)
			tbl8[v4.Name] = var2
		end

		var1.Parent = var3
	end

	local var5 = Instance.new("Frame")
	var5.Name = "BottomSpacer"
	var5.BackgroundTransparency = 1
	var5.LayoutOrder = 999
	var5.Size = UDim2.new(1, 0, 0, 2000)
	local var6 = Instance.new("UIAspectRatioConstraint")
	var6.AspectRatio = 2.6
	var6.Parent = var5
	var5.Parent = var3
end

local bool4 = false
var13.Activated:Connect(function()
	if bool4 or (not var13.Active) then
		return
	end

	bool4 = true
	local var1 = str2
	if tbl7.owned[var1] then
		local success, result, var2 = pcall(tbl1.Equip.InvokeServer, tbl1.Equip, var1)
		if success and (result and type(var2) == "table") then
			tbl7 = var2
		end
	else
		var13.Text = "\226\128\166"
		local success, result, var3, var4 = pcall(tbl1.Buy.InvokeServer, tbl1.Buy, var1)
		if success and type(var4) == "table" then
			tbl7 = var4
		end
	end

	bool4 = false
	refreshCards()
	refreshPreview()
end)

local var26 = var5:WaitForChild("Close")
var26.Activated:Connect(function()
	if not bool3 then
		return
	end

	bool3 = false
	var6.Enabled = false
	var5.CrateOverlay.Visible = false
	if var22 then
		var22:Disconnect()
		var22 = nil
	end

	if var9.SelectedObject and var9.SelectedObject:IsDescendantOf(var6) then
		var9.SelectedObject = nil
	end
end)

local var27 = var26:FindFirstChildOfClass("UIScale")
var26.MouseEnter:Connect(function()
	if var27 then
		str1:Create(var27, TweenInfo.new(0.1), { Scale = 1.05 }):Play()
	end
end)

var26.MouseLeave:Connect(function()
	if var27 then
		str1:Create(var27, TweenInfo.new(0.1), { Scale = 1 }):Play()
	end
end)

local bool5 = false
var19:BindAction("CloseCatShop", function(_, arg2)
	if arg2 == Enum.UserInputState.Begin then
		if bool3 then
	if not not bool3 then
				bool3 = false
				var6.Enabled = false
				var5.CrateOverlay.Visible = false
				if var22 then
					var22:Disconnect()
					var22 = nil
				end

				if var9.SelectedObject and var9.SelectedObject:IsDescendantOf(var6) then
					var9.SelectedObject = nil
				end
			end

			return Enum.ContextActionResult.Sink
		end
	end

	return Enum.ContextActionResult.Pass
end, bool5, Enum.KeyCode.ButtonB)

local function fn12()
	if bool3 then
		return
	end

	bool3 = true
	var6.Enabled = true
	var12.Scale = 0.94
	str1:Create(var12, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	if not next(tbl8) then
		build()
	end

	select(str2)
	task.spawn(function()
		local success, result = pcall(tbl1.GetState.InvokeServer, tbl1.GetState)
		if success and type(result) == "table" then
			tbl7 = result
		end

		if bool3 then
			select(tbl7.equipped or "Orange")
		end
	end)

	if var10:GetLastInputType().Name:find("Gamepad") then
		var9.SelectedObject = tbl8[str2]
	end
end

var18.PromptTriggered:Connect(function(arg1)
	if arg1.Name == "CatShopPrompt" then
		fn12()
	end
end)

for k5, v5 in var4:GetChildren() do
	local var28 = v5:FindFirstChild("Card")
	local var29 = v5:GetAttribute("ProductId")
	var28 = var28 and v5.Card:FindFirstChild("Buy")
	if not var29 or (not var28) then
		continue
	end

	var28.Activated:Connect(function()
		var20:PromptProductPurchase(var2, var29)
	end)

	local var30 = v5.Position.Y.Scale
	var28.MouseEnter:Connect(function()
		local var1 = TweenInfo.new(0.12)
		str1:Create(v5, var1, { Position = UDim2.new(0, 0, var30 - 0.01, 0) }):Play()
	end)

	var28.MouseLeave:Connect(function()
		local var1 = TweenInfo.new(0.12)
		str1:Create(v5, var1, { Position = UDim2.new(0, 0, var30, 0) }):Play()
	end)

end

local tbl9 = {}
for k6, v6 in var4:GetDescendants() do
	if not v6:IsA("UIGradient") then
		continue
	end

	table.insert(tbl9, v6)
end

var8.RenderStepped:Connect(function()
	if not bool3 then
		return
	end

	local var1 = os.clock()
	for k1, v1 in tbl9, nil do
		v1.Rotation = var1 * 40 % 360
		v1.Offset = Vector2.new(math.sin(var1 * 0.8) * 0.15, 0)
	end
end)

local var31 = var5:WaitForChild("CrateOverlay")
local var32 = nil
local function setOpenButton()
	if not var23 then
		return
	end

	local var1 = var23.Open
	local var2 = var32 and var32.cost or 10
	if var32 and (not var32.allowed) then
		var1.Text = "Unavailable"
		var1.BackgroundColor3 = var21
		var1.TextColor3 = bool1
		var23.Dupes.Text = "Crates aren't available in your region"
	else
		if tbl7.cash < var2 then
			var1.Text = "Open \194\183 " .. var2
			var1.BackgroundColor3 = var21
			var1.TextColor3 = bool1
		else
			var1.Text = "Open \194\183 " .. var2
			var1.BackgroundColor3 = open
			var1.TextColor3 = queueRender
		end
	end

	if var32 and var32.odds then
		local tbl1 = {}
		for k1, v1 in var32.odds, nil do
			table.insert(tbl1, v1.rarity .. " " .. v1.chance .. "%")
		end

		var23.Odds.Text = table.concat(tbl1, "  \194\183  ")
	end
end

local var33 = var31:WaitForChild("Reel"):WaitForChild("Strip")
local bool6 = false
local function buildReel(arg1)
	var33:ClearAllChildren()
	for k1, v1 in arg1, nil do
		local var1 = tbl2:FindFirstChild(v1)
		if not var1 then
			continue
		end

		local var2 = tbl4[var1:GetAttribute("Rarity") or "Common"]
		local var3 = var14.ReelCard:Clone()
		var3.Name = "C" .. k1
		var3.Visible = true
		var3.AnchorPoint = Vector2.new(0, 0.5)
		var3.Size = UDim2.new(0.19, 0, 0.86, 0)
		var3.Position = UDim2.new((k1 - 1) * 0.205, 0, 0.5, 0)
		var2 = var2 or tbl6[1]
		var3.BackgroundColor3 = var2.color:Lerp(tbl5, 0.72)
		var3.View.BackgroundColor3 = var2.color:Lerp(tbl5, 0.55)
		var3.Bar.BackgroundColor3 = var2.color
		var3.Outline.Color = var2.color:Lerp(tbl5, 0.25)
		var3.SkinName.Text = var1:GetAttribute("DisplayName") or v1
		var3.Parent = var33
		frame(var3.View, var1)
	end
end

local var34 = nil
var24 = function()
	if bool6 then
		return
	end

	local var1 = var32 and var32.cost or 10
	if var32 and (not var32.allowed) then
		return
	end

	if tbl7.cash < var1 then
		if var23 then
			var23.Dupes.Text = "You need " .. var1 - tbl7.cash .. " more cash"
		end

		return
	end

	bool6 = true
	var31.Visible = true
	var31.Result.Text = ""
	var31.ResultSub.Text = "Rolling\226\128\166"
	var31.Again.Visible = false
	var31.Done.Visible = false
	var33:ClearAllChildren()
	local success, result = pcall(tbl1.OpenCrate.InvokeServer, tbl1.OpenCrate)
	if not success or (type(result) ~= "table" or (not result.ok)) then
		bool6 = false
		local var3 = type(result) == "table" and result.reason or "error"
		local var4 = var31.Result
		local var5
		if var3 == "cash" then
			var5 = "Not enough cash"
		elseif var3 == "restricted" then
			var5 = "Not available in your region"
		else
			var5 = "Couldn't open \226\128\148 try again"
		end

		var4.Text = var5
		var31.ResultSub.Text = ""
		var4 = result.state
		if type(result) == "table" and (result.state and type(var4) == "table") then
			tbl7 = var4
		end

		var31.Again.Visible = false
		var31.Done.Visible = true
		refreshPreview()
		setOpenButton()
		return
	end

	local var6 = result.state
	if type(var6) == "table" then
		tbl7 = var6
	end

	buildReel(result.reel)
	var33.Position = UDim2.new(0.405, 0, 0, 0)
	local var7 = TweenInfo.new(5.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local var9 = str1:Create(var33, var7, { Position = UDim2.new(0.5 - ((result.winAt - 1) * 0.205 + 0.095) + (math.random() - 0.5) * 0.19 * 0.7, 0, 0, 0) })
	var5 = var31:FindFirstChild("Tick")
	local tbl3 = {}
	var7 = 0
	if var5 then
		local var10 = var5:Clone()
		var10.Name = "TickVoice"
		var10.Parent = var31
		tbl3[1] = var10
		var10 = var5:Clone()
		var10.Name = "TickVoice"
		var10.Parent = var31
		tbl3[2] = var10
		var10 = var5:Clone()
		var10.Name = "TickVoice"
		var10.Parent = var31
		tbl3[3] = var10
		var10 = var5:Clone()
		var10.Name = "TickVoice"
		var10.Parent = var31
		tbl3[4] = var10
	end

	local var11 = nil
	var9:Play()
	var9.Completed:Wait()
	var8.RenderStepped:Connect(function()
		local var2 = math.floor((0.5 - var33.Position.X.Scale) / 0.205)
		if var2 ~= var11 then
			if var11 ~= nil and 0 < (#tbl3) then
				local var3 = var7 % #tbl3 + 1
				var7 = var3
				var3 = tbl3[var7]
				var3.PlaybackSpeed = 0.95 + math.random() * 0.1
				var3.TimePosition = 0
				var3:Play()
			end

			var11 = var2
		end
	end):Disconnect()

	task.delay(0.5, function()
		for k1, v1 in tbl3, nil do
			v1:Destroy()
		end
	end)

	local var12 = tbl2:FindFirstChild(result.win)
	local var13 = tbl6[1]
	local var15 = var33:FindFirstChild("C" .. result.winAt)
	var13 = var12 and (tbl4[var12:GetAttribute("Rarity") or "Common"] or tbl6[1]) or tbl6[1]
	if var15 then
		var15.Outline.Color = render
		var15.Outline.Thickness = 3
		local var16 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		str1:Create(var15, var16, { Size = UDim2.new(0.20520000000000002, 0, 0.93, 0) }):Play()
	end

	var31.Result.Text = "You got " .. (var12 and var12:GetAttribute("DisplayName") or result.win) .. "!"
	var31.Result.TextColor3 = var13.color:Lerp(render, 0.35)
	var31.ResultSub.Text = result.duplicate and "Already owned \226\128\148 " .. result.refund .. " cash back" or var13.label .. " \194\183 added to your cats"
	var34 = result.win
	var31.Again.Text = var1 <= tbl7.cash and "Open another \194\183 " .. var1 or "Need " .. var1 - tbl7.cash .. " more cash"
	var31.Again.BackgroundColor3 = var1 <= tbl7.cash and open or var21
	var31.Again.TextColor3 = var1 <= tbl7.cash and queueRender or bool1
	var31.Again.Visible = true
	var31.Done.Visible = true
	bool6 = false
	refreshCards()
	refreshPreview()
	setOpenButton()
end

var31.Again.Activated:Connect(function()
	var24()
end)

var6:GetAttributeChangedSignal("DebugOpenCrate"):Connect(function()
	task.spawn(var24)
end)

var31.Done.Activated:Connect(function()
	if bool6 then
		return
	end

	var31.Visible = false
	if var34 then
		select(var34)
	end
end)

task.spawn(function()
	local var1 = var2:WaitForChild("leaderstats", 30)
	local var3 = var1
	var3 = var3 and var1:WaitForChild("Cash", 10)
	if var3 then
		var3.Changed:Connect(function()
			setOpenButton()
		end)

	end
end)

var8.Heartbeat:Connect(function()
	if not bool3 then
		return
	end

	local var1 = var2.Character
	local var3 = workspace:FindFirstChild("Lobby")
	var3 = var3 and (workspace.Lobby:FindFirstChild("Parts") and workspace.Lobby.Parts:FindFirstChild("CatShop"))
	local var4 = var3
	var1 = var1 and var2.Character:FindFirstChild("HumanoidRootPart")
	var4 = var4 and var3:FindFirstChild("CounterTop")
	if var1 then
		if var4 then
			if 18 < (var1.Position - var4.Position).Magnitude then
				if not bool3 then
					return
				end

				bool3 = false
				var6.Enabled = false
				var5.CrateOverlay.Visible = false
				if var22 then
					var22:Disconnect()
					var22 = nil
				end

				if var9.SelectedObject and var9.SelectedObject:IsDescendantOf(var6) then
					var9.SelectedObject = nil
				end
			end
		end
	end
end)

task.spawn(function()
	local var1 = var2:WaitForChild("leaderstats", 30)
	local var3 = var1
	var3 = var3 and var1:WaitForChild("Cash", 10)
	if var3 then
		tbl7.cash = var3.Value
		var3.Changed:Connect(function(arg1)
			tbl7.cash = arg1
			if bool3 then
				refreshPreview()
			end
		end)

	end
end)

str1 = game:GetService("Players").LocalPlayer
var10 = str1:WaitForChild("PlayerGui"):WaitForChild("CashGui"):WaitForChild("Pill")
var18 = var10:WaitForChild("Value")
var2 = nil
var20 = 0
var8 = game:GetService("RunService")
var19 = var10:WaitForChild("Gain")
tbl3 = game:GetService("TweenService")
var12 = function(arg1)
	if arg1 <= 0 then
		return
	end

	var19.Text = "+" .. tostring(arg1)
	var19.Position = UDim2.new(0.88, 0, 0, 0)
	var19.TextTransparency = 0.1
	local var1 = TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	tbl3:Create(var19, var1, { Position = UDim2.new(0.88, 0, -0.35, 0), TextTransparency = 1 }):Play()
end

task.spawn(function()
	local var1 = str1:WaitForChild("leaderstats", 60)
	local var3 = var1
	var3 = var3 and var1:WaitForChild("Cash", 30)
	if not var3 then
		return
	end

	var20 = var3.Value
	var18.Text = tostring((math.floor(var20 + 0.5)))
	local var4 = var3.Value
	var3.Changed:Connect(function(arg1)
		var12(arg1 - var4)
		var4 = arg1
		if var2 then
			var2:Disconnect()
		end

		local var1 = os.clock()
		local var3 = var20
		var2 = var8.RenderStepped:Connect(function()
			local var4 = math.min(1, (os.clock() - var1) / 0.6)
			var20 = var3 + (arg1 - var3) * (1 - (1 - var4) ^ 3)
			var18.Text = tostring((math.floor(var20 + 0.5)))
			if 1 <= var4 then
				var2:Disconnect()
				var2 = nil
			end
		end)
	end)
end)

var8 = workspace:WaitForChild("LobbyPets", 60)
var17 = game:GetService("Players")
tbl3 = game:GetService("RunService")
var6 = function(arg1)
	var18.Text = tostring((math.floor(arg1 + 0.5)))
end

var5 = function(arg1)
	if var2 then
		var2:Disconnect()
	end

	local var1 = os.clock()
	local var3 = var20
	var2 = var8.RenderStepped:Connect(function()
		local var4 = math.min(1, (os.clock() - var1) / 0.6)
		var20 = var3 + (arg1 - var3) * (1 - (1 - var4) ^ 3)
		var18.Text = tostring((math.floor(var20 + 0.5)))
		if 1 <= var4 then
			var2:Disconnect()
			var2 = nil
		end
	end)
end

if var8 then
	var9 = RaycastParams.new()
	var9.FilterType = Enum.RaycastFilterType.Exclude
	str1 = {}
	var18 = function(arg1)
		local var1 = arg1:FindFirstChild("RootPart")
		var1 = var1 or arg1.PrimaryPart
		local var4 = arg1:FindFirstChild("Head")
		local var5 = arg1:FindFirstChild("Body")
		if not var1 or (not var4 or (not var5)) then
			return nil
		end

		local num1 = math.huge
		for k1, v1 in arg1:GetDescendants() do
			if not v1:IsA("BasePart") then
				continue
			end

			num1 = math.min(num1, v1.Position.Y - v1.Size.Y / 2)
		end

		local var6 = Vector3.new(var4.Position.X - var5.Position.X, 0, var4.Position.Z - var5.Position.Z)
		local var7 = 0.01 < var6.Magnitude and var6.Unit or Vector3.new(0, 0, -1)
		local var8 = math.atan2(-var7.X, -var7.Z)
		return {
			root = var1,
			pos = var1.Position,
			rootOffset = var1.Position.Y - num1,
			frontYaw = var8,
			rot0 = var1.CFrame.Rotation,
			yaw = var8,
		}
	end

	tbl3.RenderStepped:Connect(function(arg1)
		local tbl1 = { var8 }
		for k1, v1 in var17:GetPlayers() do
			if not v1.Character then
				continue
			end

			table.insert(tbl1, v1.Character)
		end

		var9.FilterDescendantsInstances = tbl1
		for k2, v2 in var8:GetChildren() do
			local var2 = str1[v2]
			if not var2 then
				var2 = var18(v2)
				if not var2 then
					continue
				end

				str1[v2] = var2
			end

			local var3 = var17:GetPlayerByUserId(v2:GetAttribute("Owner") or 0)
			local var4 = var3
			var4 = var4 and (var3.Character and var3.Character:FindFirstChild("HumanoidRootPart"))
			if not var4 then
				continue
			end

			if not var2.root.Parent then
				continue
			end

			local var5 = var4.Position + var4.CFrame.RightVector * 2.2 - var4.CFrame.LookVector * 2.6
			if 40 < Vector3.new(var5.X - var2.pos.X, 0, var5.Z - var2.pos.Z).Magnitude then
				var2.pos = var5
			end

			local var6 = var2.pos:Lerp(Vector3.new(var5.X, var2.pos.Y, var5.Z), 1 - math.exp(-6 * arg1))
			local var7 = workspace:Raycast(Vector3.new(var6.X, var4.Position.Y + 2, var6.Z), Vector3.new(0, -20, 0), var9)
			local var10 = Vector3.new(var6.X - var2.pos.X, 0, var6.Z - var2.pos.Z)
			var2.pos = Vector3.new(var6.X, (var7 and var7.Position.Y or var4.Position.Y - 3) + var2.rootOffset, var6.Z)
			local var11 = Vector3.new(var4.CFrame.LookVector.X, 0, var4.CFrame.LookVector.Z)
			local var12 = 0.02 * (arg1 * 60) < var10.Magnitude and var10.Unit or (0.01 < var11.Magnitude and var11.Unit or Vector3.new(0, 0, -1))
			local var13 = var2.yaw + ((math.atan2(-var12.X, -var12.Z) - var2.yaw + 3.1415926535897931) % 6.2831853071795862 - 3.1415926535897931) * (1 - math.exp(-8 * arg1))
			var2.yaw = var13
			var2.root.CFrame = CFrame.new(var2.pos) * CFrame.Angles(0, var2.yaw - var2.frontYaw, 0) * var2.rot0
		end

		for k3 in str1, nil do
			if k3.Parent == var8 then
				continue
			end

			str1[k3] = nil
		end
	end)

	var10 = function(arg1)
		return (math.atan2(-arg1.X, -arg1.Z))
	end

end

tbl3 = game:GetService("SoundService")
var9 = tbl3:WaitForChild("UIHover", 10)
var18 = 0
var8 = game:GetService("UserInputService")
var10 = tbl3:WaitForChild("UIClick", 10)
var19 = setmetatable({}, { __mode = "k" })
var20 = function()
	if not var9 or os.clock() - var18 < 0.06 then
		return
	end

	if var8:GetLastInputType() == Enum.UserInputType.Touch then
		return
	end

	var18 = os.clock()
	tbl3:PlayLocalSound(var9)
end

var2 = function()
	if var10 then
		tbl3:PlayLocalSound(var10)
	end
end

str1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
var6 = function(arg1)
	if var19[arg1] or (not arg1:IsA("GuiButton") or arg1:GetAttribute("NoUISound")) then
		return
	end

	var19[arg1] = true
	arg1.MouseEnter:Connect(function()
		if arg1.Visible and arg1.Active then
			var20()
		end
	end)

	arg1.SelectionGained:Connect(var20)
	arg1.Activated:Connect(var2)
end

for k7, v7 in str1:GetDescendants() do
	var6(v7)
end

str1.DescendantAdded:Connect(var6)

--- Players.LocalPlayer.PlayerScripts.LobbyWeatherRunner [LocalScript]
-- y u r i

local var1 = game:GetService("ReplicatedStorage")
local str1 = "LobbyMusicController"
require(var1:WaitForChild(str1)).Start()
str1 = "LobbyWeatherController"
require(var1:WaitForChild(str1)).Start()
str1 = "LobbySurfaceRain"
require(var1:WaitForChild(str1)).Start()

--- Players.LocalPlayer.PlayerGui.CustomMouseIcon [LocalScript]
-- y u r i

local var1 = game:GetService("Players").LocalPlayer:GetMouse()
var1.Icon = "rbxassetid://16971310980"

--- ReplicatedStorage.LobbyPromptPolicy [ModuleScript]
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

--- ReplicatedStorage.LobbyWeatherController [ModuleScript]
-- y u r i

local tbl1 = {}
local var1 = Random.new()
local bool1 = false
local tbl2 = {}
local var2 = nil
local var3 = game:GetService("CollectionService")
local var4 = game:GetService("RunService")
local var5 = game:GetService("SoundService")
local var6 = nil
local function watchLight(arg1)
	if not arg1:IsA("Light") or tbl1[arg1] then
		return
	end

	local tbl2 = {
		base = arg1.Brightness,
		last = arg1.Brightness,
		seed = var1:NextNumber(0, 1000),
		dipStart = 0,
		dipDuration = 0,
		dipDepth = 0,
	}

	tbl2.nextDip = os.clock() + var1:NextNumber(8, 22)
	tbl1[arg1] = tbl2
end

local tbl3 = { Stop = function()
	bool1 = false
	for k1, v1 in tbl2, nil do
		v1:Disconnect()
	end

	table.clear(tbl2)
	for k2, v2 in tbl1, nil do
		if not k2.Parent then
			continue
		end

		if math.abs(k2.Brightness - v2.last) >= 0.0001 then
			continue
		end

		k2.Brightness = v2.base
	end

	table.clear(tbl1)
	if var2 then
		for k3, v3 in var2:GetChildren() do
			if not v3:IsA("Sound") then
				continue
			end

			v3:Stop()
		end
	end
end }

tbl3.Start = function()
	if bool1 then
		return
	end

	bool1 = true
	local var7 = workspace:WaitForChild("Lobby"):WaitForChild("Important"):WaitForChild("LobbyWeather")
	var2 = var5:WaitForChild("LobbyWeather")
	var6 = var2:WaitForChild("IndoorRain")
	local str1 = "Thunder02"
	local tbl4 = { var2:WaitForChild("Thunder01"), var2:WaitForChild(str1) }
	local function interval(arg1, arg2, arg3, arg4)
		local var2 = var7:GetAttribute(arg1)
		local var3 = var7:GetAttribute(arg2)
		if type(var2) == "number" then
			if var2 ~= var2 or var2 == math.huge then
				var2 = arg3
			end
		end

		if type(var3) ~= "number" or (var3 ~= var3 or var3 == math.huge) then
			var3 = arg4
		end

		var2 = math.max(1, var2)
		local var4 = var2
		local var5 = math.max(var2, var3)
		return var1:NextNumber(var4, var5)
	end

	for k1, v1 in var3:GetTagged("LobbyFlickerLight") do
		watchLight(v1)
	end

	local var8 = watchLight
	table.insert(tbl2, var3:GetInstanceAddedSignal("LobbyFlickerLight"):Connect(var8))
	var8 = function(arg1)
		local var2 = tbl1[arg1]
		if var2 and (arg1.Parent and math.abs(arg1.Brightness - var2.last) < 0.0001) then
			arg1.Brightness = var2.base
		end

		tbl1[arg1] = nil
	end

	table.insert(tbl2, var3:GetInstanceRemovedSignal("LobbyFlickerLight"):Connect(var8))
	var6:Play()
	local num1 = 0
	local var9 = os.clock() + interval("ThunderMinSeconds", "ThunderMaxSeconds", 25, 55)
	local function fn3(arg1)
		if not var7.Parent then
			tbl3.Stop()
			return
		end

		local var2 = num1 + arg1
		num1 = var2
		if num1 < 0.033333333333333333 then
			return
		end

		num1 = 0
		var2 = os.clock()
		for k1, v1 in tbl1, nil do
			local var3
			if not k1.Parent then
				var3 = tbl1
				var3[k1] = nil
			else
				if 0.0001 < math.abs(k1.Brightness - v1.last) then
					v1.base = k1.Brightness
				end

				if v1.nextDip <= var2 then
					v1.dipStart = var2
					v1.dipDuration = var1:NextNumber(0.25, 0.65)
					v1.dipDepth = var1:NextNumber(0.04, 0.09)
					v1.nextDip = var2 + interval("FlickerMinSeconds", "FlickerMaxSeconds", 8, 22)
				end

				local var5 = (var2 - v1.dipStart) / math.max(v1.dipDuration, 0.001)
				var3 = 0
				if 0 <= var5 then
					if var5 < 1 then
						var3 = math.sin(var5 * 3.1415926535897931) * v1.dipDepth
					end
				end

				local var6 = k1.Enabled and v1.base * (1 - math.clamp(math.noise(var2 * 1.8, v1.seed) * 0.5 + 0.5, 0, 1) * 0.025 - var3) or v1.base
				k1.Brightness = var6
				v1.last = k1.Brightness
			end
		end

		if var9 <= var2 then
			local bool1 = false
			for k2, v2 in tbl4, nil do
				if not v2.IsPlaying then
					continue
				end

				bool1 = true
				break
			end

			if not bool1 then
				local var8 = tbl4[var1:NextInteger(1, #tbl4)]
				var8.PlaybackSpeed = var1:NextNumber(0.94, 1.04)
				var8:Play()
				var9 = var2 + interval("ThunderMinSeconds", "ThunderMaxSeconds", 25, 55)
			end
		end
	end

	table.insert(tbl2, var4.Heartbeat:Connect(fn3))
end

return tbl3

--- ReplicatedStorage.LobbySurfaceRain [ModuleScript]
-- y u r i

local var1 = Random.new()
local tbl1 = {}
local function reset(arg1, arg2)
	local var2 = arg1.kind == "Drip"
	local var3 = var2 and var1:NextNumber(0.9, 1.7) or var1:NextNumber(0.22, 0.4)
	arg1.duration = var3
	var3 = var2 and var1:NextNumber(0.03, 0.3) or var1:NextNumber(0.12, 0.5)
	arg1.delay = var3
	var3 = arg2 and var1:NextNumber(0, arg1.duration + arg1.delay) or 0
	arg1.age = var3
	arg1.x = var1:NextNumber(0.015, 0.985)
	arg1.y = var1:NextNumber(0.015, 0.985)
	var3 = var2 and var1:NextNumber(0.06, 0.18) or 0
	arg1.travel = var3
	var3 = var2 and var1:NextNumber(0.004, 0.007) or var1:NextNumber(0.009, 0.016)
	arg1.width = var3
	var3 = var2 and var1:NextNumber(0.06, 0.12) or arg1.width * arg1.aspect
	arg1.height = var3
	var3 = var2 and var1:NextNumber(0.65, 0.85) or var1:NextNumber(0.5, 0.7)
	arg1.opacity = var3
	arg1.label.ImageTransparency = 1
end

local var2 = game:GetService("RunService")
local var3 = nil
local tbl2 = {
	Step = function(arg1)
		for k1, v1 in tbl1, nil do
			local var1 = v1.label
			if not var1.Parent then
				continue
			end

			local var2 = v1.age + arg1
			v1.age = var2
			if v1.duration + v1.delay <= v1.age then
				reset(v1, false)
			end

			var2 = v1.age / v1.duration
			if 1 <= var2 then
				var1.ImageTransparency = 1
			else
				local var3 = math.min(var2 / 0.12, 1) * math.min((1 - var2) / 0.35, 1)
				var1.Position = UDim2.fromScale(v1.x, v1.y + v1.travel * var2 * var2)
				local var4 = v1.kind == "Impact" and 0.25 + 0.75 * var2 or 1
				var1.Size = UDim2.fromScale(v1.width * var4, v1.height * var4)
				var1.ImageTransparency = 1 - v1.opacity * math.max(0, var3)
			end
		end
	end,
	Stop = function()
		if var3 then
			var3:Disconnect()
			var3 = nil
		end

		for k1, v1 in tbl1, nil do
			if not v1.label.Parent then
				continue
			end

			v1.label.ImageTransparency = 1
		end

		table.clear(tbl1)
	end,
}

tbl2.Start = function()
	if var3 then
		return
	end

	local var1 = workspace:WaitForChild("Lobby"):WaitForChild("Important"):WaitForChild("LobbyWeather")
	for k1, v1 in var1:GetChildren() do
		local var4 = v1:FindFirstChild("Rain2D")
		if not var4 then
			continue
		end

		if not var4:IsA("SurfaceGui") then
			continue
		end

		for k2, v2 in var4:WaitForChild("Canvas"):GetChildren() do
			if not v2:IsA("ImageLabel") then
				continue
			end

			local tbl3 = { label = v2, kind = v2:GetAttribute("RainKind") }
			tbl3.aspect = var4:GetAttribute("PaneAspect") or 1
			reset(tbl3, true)
			table.insert(tbl1, tbl3)
		end
	end

	local num1 = 0
	var3 = var2.Heartbeat:Connect(function(arg1)
		if not var1.Parent then
			tbl2.Stop()
			return
		end

		local var2 = num1 + arg1
		num1 = var2
		if num1 < 0.033333333333333333 then
			return
		end

		tbl2.Step(num1)
		num1 = 0
	end)
end

return tbl2

--- ReplicatedStorage.LobbyMusicController [ModuleScript]
-- y u r i

local var1 = nil
local var2 = game:GetService("SoundService")
return {
	Start = function()
		var1 = var2:WaitForChild("LobbyMusic")
		if not var1.IsPlaying then
			var1:Play()
		end
	end,
	Stop = function()
		if var1 then
			var1:Stop()
		end
	end,
}

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

--- Workspace.hspspjl.Health [Script]
-- Failed to get bytecode:
--[[
nil
--]]

