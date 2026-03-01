local LocalPlayer, LP = game:GetService("Players").LocalPlayer, game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local solo = true
task.spawn(function()
    while solo do 
        task.wait(1)
        local playerCount = #Players:GetPlayers()
        if playerCount > 1 then
game:GetService("TeleportService"):Teleport(129279692364812, LocalPlayer)
            break 
        end
    end
end)
local Character, Char
local HumanoidRootPart, HRP
local Humanoid, Hum
pcall(function()
Character, Char = LocalPlayer.Character, LocalPlayer.Character
end)
pcall(function()
HumanoidRootPart, HRP = Character.HumanoidRootPart, Character.HumanoidRootPart
end)
pcall(function()
Humanoid, Hum = Character.Humanoid, Character.Humanoid
end)
LocalPlayer.CharacterAdded:Connect(function(char)
pcall(function()
Character, Char = nil, nil
HumanoidRootPart, HRP = nil, nil
Humanoid, Hum = nil, nil
task.wait()
Character, Char = char, char
repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
HumanoidRootPart, HRP = char.HumanoidRootPart, char.HumanoidRootPart
repeat task.wait() until Character:FindFirstChild("Humanoid")
Humanoid, Hum = char.Humanoid, char.Humanoid
end)
end)
function CreateMessage(a)
local instancename = (a=="Message" and a) or "Hint"
local msg = Instance.new(instancename,game:GetService("CoreGui"))
msg.Text = ""
return msg
end
local msg = CreateMessage()
msg.Text = "Loading API Module... (0/1)"
local loadmoduleattempt = 0
local Module = nil
repeat task.wait()
local lodsuc, loderr = pcall(function()
Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/NewNexer/NexerHub/refs/heads/main/Global-Module.luau"))()
end)
if not lodsuc then
loadmoduleattempt += 1
msg.Text = "Failed loading API Module, re-trying... ( Attempt "..tostring(loadmoduleattempt).." )"
task.wait(1)
elseif lodsuc and Module.IsWorking ~= nil then
msg.Text = "Loading API Module... (1/1)"
task.wait(1)
else
loadmoduleattempt += 1
msg.Text = "Failed loading API Module, re-trying... ( Attempt "..tostring(loadmoduleattempt).." )"
task.wait(1)
end
until msg.Text == "Loading API Module... (1/1)"
task.wait(1)
msg.Text = "Launching Rayfield..."
local Rayfield = Module:GetWorkingRayfield()
task.delay(2,function()
msg:Destroy()
end)
AuthorKey = ""..((AuthorKey ~= nil and AuthorKey) or "Unknown")..""
GameKey = ""..((GameKey ~= nil and GameKey) or "Unknown")..""
local Window = Rayfield:CreateWindow({
   Name = ""..AuthorKey.." Hub : Nullscape",
   Icon = 0,    
   LoadingTitle = ""..string.sub(AuthorKey,1,1).."H:"..GameKey:gsub("(%S)%S+","%1"):gsub("%s+","").."",
   LoadingSubtitle = "By "..AuthorKey.."",
   Theme = "Amethyst",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "lesbian",
      FileName = "config"
   },
})
local rs = game:GetService("RunService")
local Heartbeat = {}
rs.Heartbeat:Connect(function()
for i,v in next, Heartbeat do
if v~=nil then
task.spawn(v)
end
end
end)
local NG_aura_enabled = false
local GG_aura_enabled = false
function GiftAura(...)
local a,b,c,d = ...
if a=="Normal" then
NG_aura_enabled = b
if b~=true then return end
task.spawn(function()
while task.wait(.1) do
if NG_aura_enabled==false then break end
for i,v in next, workspace:WaitForChild("ItemPools", 9e9):WaitForChild("NormalGifts", 9e9):GetChildren() do
if HRP~=nil and v:GetAttribute("StartPosition")~=nil and v:GetAttribute("Collected")==false and v:GetAttribute("ClientCollected")==false and (HRP.Position-v:GetAttribute("StartPosition")).magnitude<c then
game:GetService("ReplicatedStorage"):WaitForChild("Events", 9e9):WaitForChild("GiftCollected", 9e9):FireServer(v)
v:SetAttribute("ClientCollected",true)
task.wait(d)
end
end
end
end)
elseif a=="Golden" then
GG_aura_enabled = b
if b~=true then return end
task.spawn(function()
while task.wait(.1) do
if GG_aura_enabled==false then break end
for i,v in next, workspace:WaitForChild("ItemPools", 9e9):WaitForChild("GoldenGifts", 9e9):GetChildren() do
if HRP~=nil and v:GetAttribute("StartPosition")~=nil and v:GetAttribute("Collected")==false and v:GetAttribute("ClientCollected")==false and (HRP.Position-v:GetAttribute("StartPosition")).magnitude<c then
game:GetService("ReplicatedStorage"):WaitForChild("Events", 9e9):WaitForChild("GiftCollected", 9e9):FireServer(v)
v:SetAttribute("ClientCollected",true)
task.wait(d)
end
end
end
end)
end
end
function GetAvailableGift(a)
local AvailableGift = workspace.Spawn
if a=="Any" then
for i,v in next, workspace:WaitForChild("ItemPools", 9e9):WaitForChild("NormalGifts", 9e9):GetChildren() do
if v and v:GetAttribute("StartPosition")~=nil and v:GetAttribute("Collected")==false and v:GetAttribute("ClientCollected")==false and v.Transparency~=1 then
AvailableGift = v
end
end
for i,v in next, workspace:WaitForChild("ItemPools", 9e9):WaitForChild("GoldenGifts", 9e9):GetChildren() do
if v and v:GetAttribute("StartPosition")~=nil and v:GetAttribute("Collected")==false and v:GetAttribute("ClientCollected")==false and v.Transparency~=1 then
AvailableGift = v
end
end
elseif a=="Closest" then
local ClosestDistance = math.huge
for i,v in next, workspace:WaitForChild("ItemPools", 9e9):WaitForChild("NormalGifts", 9e9):GetChildren() do
if HRP~=nil and v and v:GetAttribute("StartPosition")~=nil and v:GetAttribute("Collected")==false and v:GetAttribute("ClientCollected")==false and (HRP.Position-v:GetAttribute("StartPosition")).magnitude<ClosestDistance and v.Transparency~=1 then
ClosestDistance = (HRP.Position-v:GetAttribute("StartPosition")).magnitude
AvailableGift = v
end
end
for i,v in next, workspace:WaitForChild("ItemPools", 9e9):WaitForChild("GoldenGifts", 9e9):GetChildren() do
if HRP~=nil and v and v:GetAttribute("StartPosition")~=nil and v:GetAttribute("Collected")==false and v:GetAttribute("ClientCollected")==false and (HRP.Position-v:GetAttribute("StartPosition")).magnitude<ClosestDistance and v.Transparency~=1 then
ClosestDistance = (HRP.Position-v:GetAttribute("StartPosition")).magnitude
AvailableGift = v
end
end
end
return AvailableGift
end
local G_Speed = 0.16
local G_AutoFarmEnabled = false
local G_CanEscape = true
local G_X, G_Y = 0, 0
function GiftAutoFarm(a)
G_AutoFarmEnabled = a
if a~=true then return end
task.spawn(function()
while task.wait(.1) do
if G_AutoFarmEnabled==false then workspace.Beacon.CanTouch = true task.wait(.1) break end
local AvailableGift = GetAvailableGift("Closest")
if AvailableGift.Name~="Spawn" then
workspace.Beacon.CanTouch = G_CanEscape
local GiftPosition = AvailableGift:GetAttribute("StartPosition")
local Speed = ((GiftPosition-HumanoidRootPart.Position).magnitude<51 and G_Speed) or (G_Speed+1) 
if Speed>1 then
HumanoidRootPart.Anchored = true
end
local Tween = game:GetService("TweenService"):Create(HumanoidRootPart,TweenInfo.new(Speed,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),{Position=(GiftPosition + Vector3.new(G_X,G_Y,0))}):Play()
repeat task.wait() until AvailableGift:GetAttribute("ClientCollected")==true or (HumanoidRootPart.Position - GiftPosition).Magnitude < 4 or G_AutoFarmEnabled==false
if Tween~=nil then Tween:Cancel() Tween=nil end
HumanoidRootPart.Anchored = false
repeat task.wait() until AvailableGift:GetAttribute("Collected")==true or G_AutoFarmEnabled==false
else
workspace.Beacon.CanTouch = true
task.wait(.1)
end
end
end)
end
local Tab1 = Window:CreateTab("Gifts",0)
local NG_Distance, NG_Cooldown = 40, 0.12
Tab1:CreateSlider({Name = "Pick up speed"; Range = {0,0.5}; Flag = "Lesbian12"; Increment = 0.02; Suffix = " seconds"; CurrentValue = 0.12; Callback = function(Value)
NG_Cooldown = tonumber(Value)
end; })
Tab1:CreateSlider({Name = "Pick up distance"; Range = {0,50}; Flag = "Lesbian13"; Increment = 1; Suffix = " studs"; CurrentValue = 40; Callback = function(Value)
NG_Distance = tonumber(Value)
end; })
Tab1:CreateToggle({Name = "Enable pick-up aura"; CurrentValue = false; Flag = "Lesbian1"; Callback = function(Value)
GiftAura("Normal",Value,NG_Distance,NG_Cooldown)
end; })
local GG_Distance, GG_Cooldown = 40, 0.12
Tab1:CreateSlider({Name = "Pick-Up Speed"; Range = {0,0.5}; Flag = "Lesbian14"; Increment = 0.02; Suffix = " seconds"; CurrentValue = 0.12; Callback = function(Value)
GG_Cooldown = tonumber(Value)
end; })
Tab1:CreateSlider({Name = "Pick-Up Distance"; Range = {0,50}; Flag = "Lesbian15"; Increment = 1; Suffix = " studs"; CurrentValue = 40; Callback = function(Value)
GG_Distance = tonumber(Value)
end; })
Tab1:CreateToggle({Name = "Enable Pick-Up Aura"; CurrentValue = false; Flag = "Lesbian2"; Callback = function(Value)
GiftAura("Golden",Value,GG_Distance,GG_Cooldown)
end; })
local CanEscapeintobeam = true
local beacon = workspace.Beacon
local HRP
local function bindCharacter(char)
    HRP = char and char:FindFirstChild("HumanoidRootPart")
    if not HRP and char then
        HRP = char:WaitForChild("HumanoidRootPart", 5)
    end
end
bindCharacter(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(bindCharacter)
local CanEscapeintobeam = true
local AutoEscapeEnabled = false
local AutoTouchEnabled = false
local autoEscapeThread = nil
local autoTouchThread  = nil
local function anyAvailableGifts()
    local pools = workspace:FindFirstChild("ItemPools")
    if not pools then return false end
    local function checkPool(name)
        local pool = pools:FindFirstChild(name)
        if not pool then return false end
        for _, v in pairs(pool:GetChildren()) do
            local startPos = v:GetAttribute("StartPosition")
            local collected = v:GetAttribute("Collected")
            local clientCollected = v:GetAttribute("ClientCollected")
            if startPos ~= nil and collected == false and clientCollected == false and v.Transparency ~= 1 then
                return true
            end
        end
        return false
    end
    return checkPool("NormalGifts") or checkPool("GoldenGifts")
end
local function touchPart(part, root)
    if not part or not part:IsA("BasePart") then return end
    if not root or not root:IsA("BasePart") then return end
    if typeof(firetouchinterest) == "function" then
        pcall(function() firetouchinterest(part, root, 1) end)
        task.wait()
        pcall(function() firetouchinterest(part, root, 0) end)
    end
end
local function endRound(enabled)
    AutoTouchEnabled = enabled
    autoTouchThread = nil
    if enabled then
        local threadKey = {}
        autoTouchThread = threadKey
        task.spawn(function()
            while AutoTouchEnabled and autoTouchThread == threadKey do
                if beacon and HRP and beacon.Transparency == 0 and not anyAvailableGifts() then
                    for _, desc in pairs(beacon:GetChildren()) do
                        if desc.ClassName == "TouchTransmitter" then
                            touchPart(desc.Parent, HRP)
                            task.wait(0.03)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end
Tab1:CreateToggle({
    Name = "End Round",
    Flag = "lesbian101",
    CurrentValue = false,
    Callback = function(val)
        endRound(val)
    end
})
Tab1:CreateSlider({Name = "Auto-Farm Pick Up Speed"; Range = {0,1}; Flag = "Lesbian16"; Increment = 0.02; Suffix = " seconds per gift"; CurrentValue = 0.24; Callback = function(Value)
G_Speed = tonumber(Value)
end; })
Tab1:CreateSlider({Name = "Tween Offset (X)"; Range = {0,10}; Flag = "Lesbian17"; Increment = 1; Suffix = " studs"; CurrentValue = 0; Callback = function(Value)
G_X = tonumber(Value)
end; })
Tab1:CreateSlider({Name = "Tween Offset (Y)"; Range = {0,10}; Flag = "Lesbian18"; Increment = 1; Suffix = " studs"; CurrentValue = 0; Callback = function(Value)
G_Y = tonumber(Value)
end; })
Tab1:CreateToggle({Name = "Can't Escape into Beam during Auto-Farm"; CurrentValue = false; Flag = "Lesbian3"; Callback = function(Value)
G_CanEscape = not Value
end; })
Tab1:CreateToggle({Name = "Enable Auto-Farm"; CurrentValue = false; Flag = "Lesbian4"; Callback = function(Value)
GiftAutoFarm(Value)
end; })
local Tab3 = Window:CreateTab("Enemies",0)
function GetEnemies(a,b)
for i,v in next, workspace.Enemies:GetChildren() do
if v and v.Name==a then
b(v)
end
end
end
local deleted_instances = {}
local function RemoveInstance(inst)
    if not inst or not inst:IsA("Instance") then return end
    local key = tostring(inst)
    if deleted_instances[key] then return end
    deleted_instances[key] = { Instance = inst, Parent = inst.Parent }
    inst.Parent = nil
end
local function RestoreInstance(inst)
    if not inst then return end
    local key = tostring(inst)
    local rec = deleted_instances[key]
    if rec and rec.Instance and rec.Parent then
        if not rec.Instance.Parent then
            rec.Instance.Parent = rec.Parent
        end
        deleted_instances[key] = nil
    end
end
local function safeDestroy(inst)
    pcall(function()
        if inst and inst:IsA("Instance") then
            inst:Destroy()
        end
    end)
end
local function stripTouchParts(obj)
    if not obj then return end
    pcall(function()
        if obj:IsA("BasePart") then
            obj.CanTouch = false
        end
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanTouch = false
            end
            pcall(function() if child.Name == "TouchInterest" then child:Destroy() end end)
            pcall(function()
                if child:IsA("TouchTransmitter") then child:Destroy() end
            end)
        end
        pcall(function() if obj:FindFirstChild("TouchInterest") then obj.TouchInterest:Destroy() end end)
        pcall(function() local tt = obj:FindFirstChildOfClass("TouchTransmitter"); if tt then tt:Destroy() end end)
    end)
end
local function applyToEnemy(e)
    if not e or not e:IsA("Model") and not e:IsA("BasePart") then
    end
    local name = e.Name or ""
    if AutoEnemyManagerSettings.Immunity2D then
        stripTouchParts(e)
    end
    if name == "Bell" then
        pcall(function()
            if e:FindFirstChild("ClientEvent") then RemoveInstance(e.ClientEvent) end
            if e:FindFirstChild("Ring") then RemoveInstance(e.Ring) end
        end)
        if AutoEnemyManagerSettings.RemoveBellCompletely then
            pcall(function() RemoveInstance(e) end)
        end
    elseif name == "Mart" then
        pcall(function()
            if e:FindFirstChild("Mart") then RemoveInstance(e.Mart) end
        end)
        if AutoEnemyManagerSettings.RemoveMartCompletely then
            pcall(function() RemoveInstance(e) end)
        end
    elseif name == "Baby" then
        pcall(function()
            if e:FindFirstChild("Scream") then RemoveInstance(e.Scream) end
        end)
        if AutoEnemyManagerSettings.RemoveBabyCompletely then
            pcall(function() RemoveInstance(e) end)
        end
    elseif name == "Flesh" then
        pcall(function() RemoveInstance(e) end)
    elseif name == "Skinwalker" or name == "SkinwalkerModel" then
        pcall(function()
            for _, desc in pairs(e:GetDescendants()) do
                if desc.Name == "TouchInterest" or desc:IsA("TouchTransmitter") then
                    pcall(function() desc:Destroy() end)
                end
            end
            RemoveInstance(e)
        end)
    elseif name == "Dozer" or name == "KooKoo" or name == "Voidbreaker" then
        pcall(function()
            if e:FindFirstChild("AI") then
                RemoveInstance(e.AI)
            end
        end)
    elseif name == "Springer" then
        pcall(function() if e:FindFirstChild("ShockwaveEvent") then RemoveInstance(e.ShockwaveEvent) end end)
    end
end
local function applyToSkinwalkerDesc(c)
    if AutoEnemyManagerSettings.SkinwalkerImmunity then
        if c:IsA("BasePart") then
            pcall(function()
                c.CanTouch = false
                if c:FindFirstChild("TouchInterest") then c.TouchInterest:Destroy() end
                local tt = c:FindFirstChildOfClass("TouchTransmitter")
                if tt then tt:Destroy() end
            end)
        end
    end
end
AutoEnemyManagerSettings = AutoEnemyManagerSettings or {}
AutoEnemyManagerSettings.Immunity2D = false
AutoEnemyManagerSettings.SkinwalkerImmunity = false
AutoEnemyManagerSettings.RemoveBellCompletely = true     
AutoEnemyManagerSettings.RemoveMartCompletely = false    
AutoEnemyManagerSettings.RemoveBabyCompletely = false
AutoEnemyManagerSettings.Enabled = false
local childAddedConn_Enemies = nil
local descendantAddedConn_Skinwalkers = nil
local function applyToAllExisting()
    pcall(function()
        if workspace:FindFirstChild("Enemies") then
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                pcall(function() applyToEnemy(v) end)
            end
        end
        if workspace:FindFirstChild("Skinwalkers") then
            for _, v in pairs(workspace.Skinwalkers:GetChildren()) do
                pcall(function() applyToEnemy(v) end)
            end
        end
    end)
end
local function disableAutoManager()
    AutoEnemyManagerSettings.Enabled = false
    if childAddedConn_Enemies then
        pcall(function() childAddedConn_Enemies:Disconnect() end)
        childAddedConn_Enemies = nil
    end
    if descendantAddedConn_Skinwalkers then
        pcall(function() descendantAddedConn_Skinwalkers:Disconnect() end)
        descendantAddedConn_Skinwalkers = nil
    end
    for k, rec in pairs(deleted_instances) do
        pcall(function()
            if rec and rec.Instance and rec.Parent then
                if not rec.Instance.Parent then
                    rec.Instance.Parent = rec.Parent
                end
            end
        end)
    end
    deleted_instances = {}
end
local function enableAutoManager()
    AutoEnemyManagerSettings.Enabled = true
    applyToAllExisting()
    if workspace:FindFirstChild("Enemies") then
        childAddedConn_Enemies = workspace.Enemies.ChildAdded:Connect(function(c)
            if AutoEnemyManagerSettings.Enabled then
                pcall(function() applyToEnemy(c) end)
            end
        end)
    end
    if workspace:FindFirstChild("Skinwalkers") then
        descendantAddedConn_Skinwalkers = workspace.Skinwalkers.DescendantAdded:Connect(function(c)
            if AutoEnemyManagerSettings.Enabled then
                pcall(function() applyToSkinwalkerDesc(c) end)
            end
        end)
    end
end
Tab3:CreateToggle({
    Name = "Auto Enemy Manager",
    CurrentValue = false,
    Flag = "lesbian100",
    Callback = function(val)
        if val then
            AutoEnemyManagerSettings.Immunity2D = true        
            AutoEnemyManagerSettings.SkinwalkerImmunity = true
            AutoEnemyManagerSettings.Enabled = true
            enableAutoManager()
        else
            AutoEnemyManagerSettings.Immunity2D = false
            AutoEnemyManagerSettings.SkinwalkerImmunity = false
            disableAutoManager()
        end
    end
})
local Immunity_2D = false
local SkilwalkerImmunity = false
workspace.Enemies.ChildAdded:Connect(function(c)
if Immunity_2D~=true then return end
if c:IsA("BasePart") then
c.CanTouch=false
pcall(function() c.TouchInterest:Destroy() end)
pcall(function() c:FindFirstChildOfClass("TouchTransmitter"):Destroy() end)
end
end)
workspace.Skinwalkers.DescendantAdded:Connect(function(c)
if SkilwalkerImmunity~=true then return end
if c:IsA("BasePart") then
c.CanTouch=false
pcall(function() c.TouchInterest:Destroy() end)
pcall(function() c:FindFirstChildOfClass("TouchTransmitter"):Destroy() end)
end
end)
local antivoidtpplace = "Center of the Map"
if workspace:FindFirstChild("AntiVoid")==nil then
local a = workspace.KillVoid:Clone()
a.Position = workspace.KillVoid.Position + Vector3.new(0,20,0)
a.CanTouch = false
pcall(function() a.TouchInterest:Destroy() end)
pcall(function() a:FindFirstChildOfClass("TouchTransmitter"):Destroy() end)
task.wait()
a.CanCollide = false
a.Transparency = 1
a.Name = "AntiVoid"
a.Parent = workspace
a.Touched:Connect(function(h)
if h:IsA("Part") and game.Players:GetPlayerFromCharacter(h.Parent) then
if antivoidtpplace == "Center of the Map" then
game.Players:GetPlayerFromCharacter(h.Parent).Character.HumanoidRootPart.CFrame = workspace.Spawn.CFrame * CFrame.new(0,22,0)
elseif antivoidtpplace == "Random Gift" then
local AvailableGift = GetAvailableGift("Any")
local GiftPosition = AvailableGift:GetAttribute("StartPosition")
game.Players:GetPlayerFromCharacter(h.Parent).Character.HumanoidRootPart.CFrame = CFrame.new(GiftPosition.X,(GiftPosition.Y+22),GiftPosition.Z)
end
end
end)
end
local AutoRemoveIceTiles = false
workspace.CurrentRooms.DescendantAdded:Connect(function(c)
if AutoRemoveIceTiles~=true then return end
if c:IsA("BasePart") and c.Material==Enum.Material.Ice then
c.Material=Enum.Material.Plastic
end
end)
local AutoRemoveGravityDebuff = false
workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
if workspace.Gravity<110 then
workspace.Gravity = 110
end
end)
local AutoProtectTripminess = false
if workspace:FindFirstChild("ProtectedTripmines") == nil then
local a = Instance.new("Folder")
a.Name = "ProtectedTripmines"
a.Parent = workspace
end
workspace.CurrentRooms.ChildAdded:Once(function()
for i,v in next, workspace.ProtectedTripmines:GetChildren() do
if v then v:Destroy() end
end
end)
function AutoProtectTripmines()
task.spawn(function()
while task.wait(.1) do
if AutoProtectTripminess==false then break end
for i,v in next, workspace:WaitForChild("ItemPools", 9e9):WaitForChild("Tripmines", 9e9):GetChildren() do
if v and not v:GetAttribute("uuid") or v:GetAttribute("uuid")==nil then v:SetAttribute("uuid",tostring(game:GetService("HttpService"):GenerateGUID(false))) end
if HRP~=nil and v and v:GetAttribute("StartPosition")~=nil and workspace:FindFirstChild("ProtectedTripmines") and workspace.ProtectedTripmines:FindFirstChild(v:GetAttribute("uuid"))==nil then
local sizeoffset = tonumber(v.Size.X) + 2.5
local a = Instance.new("Part")
a.Name = v:GetAttribute("uuid")
a.Position = v:GetAttribute("StartPosition")
a.Size = Vector3.new(sizeoffset,sizeoffset,sizeoffset)
a.Anchored = true
a.Parent = workspace.ProtectedTripmines
v:GetPropertyChangedSignal("Transparency"):Once(function()
a:Destroy()
end)
task.wait(.01)
end
end
end
end)
end
local Tab4 = Window:CreateTab("Immunities",0)
Tab4:CreateToggle({Name = "Immunity to all 2D enemies"; CurrentValue = false; Flag = "Lesbian5"; Callback = function(Value)
Immunity_2D = Value
for _,c in next, workspace.Enemies:GetChildren() do
if c:IsA("BasePart") then
c.CanTouch = not Value
if Value==true then
pcall(function() c.TouchInterest:Destroy() end)
pcall(function() c:FindFirstChildOfClass("TouchTransmitter"):Destroy() end)
end
end
end
end; })
Tab4:CreateToggle({Name = "Immunity to all skinwalker types"; CurrentValue = false; Flag = "Lesbian6"; Callback = function(Value)
SkilwalkerImmunity = Value
for _,c in next, workspace.Skinwalkers:GetDescendants() do
if c:IsA("BasePart") then
c.CanTouch = not Value
if Value==true then
pcall(function() c.TouchInterest:Destroy() end)
pcall(function() c:FindFirstChildOfClass("TouchTransmitter"):Destroy() end)
end
end
end
end; })
local ImmunityToClientEnemies = false
workspace.Enemies.ChildAdded:Connect(function()
if ImmunityToClientEnemies~=true then return end
pcall(function() GetEnemies("Dozer",function(a) a.AI:Destroy() end) end)
pcall(function() GetEnemies("Voidbreaker",function(a) a.AI:Destroy() end) end)
pcall(function() GetEnemies("KooKoo",function(a) a.AI:Destroy() end) end)
end)
Tab4:CreateToggle({Name = "Immunity to all client enemies"; CurrentValue = false; Flag = "Lesbian7"; Callback = function(Value)
ImmunityToClientEnemies = Value
if Value==true and game.ReplicatedStorage.Events:FindFirstChild("DiedFunction") then
RemoveInstance(game.ReplicatedStorage.Events:FindFirstChild("DiedFunction"))
end
if Value==false and game.ReplicatedStorage.Events:FindFirstChild("DiedFunction")==nil then
RestoreInstance("DiedFunction")
end
end; })
Tab4:CreateDropdown({Name = "Anti Void Teleport Place"; Options = {"Center of the Map","Random Gift"}; CurrentOption = "Center of the Map"; MultiSelection = false; Callback = function(Value)
antivoidtpplace = Rayfield:GetDropdownValue(Value)
end; })
Tab4:CreateToggle({Name = "Immunity to Void"; CurrentValue = false; Flag = "Lesbian8"; Callback = function(Value)
workspace.AntiVoid.CanTouch = Value
workspace.AntiVoid.CanCollide = Value
end; })
local curLv = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Main.List.TheHidden.Level.Text
local lvLim = 59
local leave = workspace:WaitForChild("Lobby", 1)
    :WaitForChild("LobbyReturn", 1)
    :WaitForChild("ProximityPrompt", 1)
local AutoBuffEnabled = false
local autoThread = nil
local function continue()
    game:GetService("ReplicatedStorage").Events.EndScreen:FireServer()
end
local function setAutoBuff(state)
    AutoBuffEnabled = state
    autoThread = nil
    if state then
        local threadKey = {}
        autoThread = threadKey
        task.spawn(function()
            while AutoBuffEnabled and autoThread == threadKey do
                local endScreen = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("EndScreen")
                if endScreen and endScreen.Enabled == true then
                    endScreen.Enabled = false
                    pcall(function()
                        continue()
                    end)
                    task.wait(0.5)
                end
                if HRP then
                    local distance = (HRP.Position - Vector3.new(-1, 54, 1)).Magnitude
                    if distance <= 50 then
                        local currentLevelText = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Main.List.TheHidden.Level.Text
                        local currentLevel = tonumber(currentLevelText:match("%d+"))
                        if currentLevel and currentLevel >= lvLim then
                            if leave then
                                HRP.CFrame = leave.Parent.CFrame  
                                task.wait(.175)
                                pcall(function()
                                    fireproximityprompt(leave)
                                end)
                                task.wait(2)
                            end
                        else
                            local startPrompt = workspace:FindFirstChild("GameStart")
                            if startPrompt and startPrompt:FindFirstChild("ProximityPrompt") then
                                HRP.CFrame = startPrompt.CFrame  
                                task.wait(.175) 
                                pcall(function()
                                    fireproximityprompt(startPrompt.ProximityPrompt)
                                end)
                            end
                            local selectFolder = workspace:FindFirstChild("Select")
                            if selectFolder then
                                local chosen = nil
                                for _, optName in ipairs({"3", "2", "1"}) do
                                    local opt = selectFolder:FindFirstChild(optName)
                                    if opt and opt.Enabled == true then
                                        local buffPrompt = opt:FindFirstChild("ProximityPrompt")
                                        if buffPrompt then
                                            chosen = { part = opt, prompt = buffPrompt }
                                            break
                                        end
                                    end
                                end
                                if chosen then
                                    HRP.CFrame = chosen.part.CFrame
                                    task.wait(.175)
                                    pcall(function()
                                        fireproximityprompt(chosen.prompt)
                                    end)
                                end
                            end
                        end
                    end
                end
                task.wait(0.5) 
            end
        end)
    end
end
Tab4:CreateToggle({
    Name = "Auto Start/End",
    CurrentValue = false,
    Flag = "Lesbian102",
    Callback = function(val)
        setAutoBuff(val)
    end
})
local AutoDeleteEnabled = false
local deleteThread = nil
local function setAutoDelete(state)
    AutoDeleteEnabled = state
    deleteThread = nil
    if state then
        local threadKey = {}
        deleteThread = threadKey
        task.spawn(function()
            while AutoDeleteEnabled and deleteThread == threadKey do
                local tripmines = workspace.ItemPools.Tripmines:GetChildren()
                for _, tripmine in ipairs(tripmines) do
                    pcall(function()
                        tripmine:Destroy()
                    end)
                end
                task.wait(1)
            end
        end)
    end
end
Tab4:CreateToggle({
    Name = "Auto Delete Tripmines",
    CurrentValue = false,
    Flag = "lesbian103",
    Callback = function(val)
        setAutoDelete(val)
    end
})
Rayfield:LoadConfiguration()