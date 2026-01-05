getgenv().TomatoAutoFarm = true
local ALERTS_ENABLED = true
local EXITREGION_MAX_ATTEMPTS = 50
local CHECK_DELAY = 0
local BUTTON_DELAY = 0
local EXITREGION_WAIT = 0
local LocalPlayer = game:GetService("Players").LocalPlayer
local Multiplayer = Workspace.Multiplayer
local TARGET_POSITION = Vector3.new(-20, -144, 53)
local TELEPORT_RADIUS = 50
local TELEPORT_DESTINATION = workspace.Lobby.PlayHere
local CLMAIN = LocalPlayer.PlayerScripts.CL_MAIN_GameScript
local CLMAINenv = getsenv(CLMAIN)
local gameAlert = CLMAINenv.newAlert
local Alert
if CLMAINenv then
    Alert = function(...)
        if ALERTS_ENABLED then
            local Output = tostring(...)
            gameAlert(Output, nil, nil, "rainbow")
            print(Output)
        end
    end
else
    Alert = print
end
function isRandomString(str)
    if #str == 0 then return false end
    for i = 1, #str do
        local ltr = str:sub(i, i)
        if ltr:lower() == ltr then
            return false
        end
    end
    return true
end
local function GetChar()
    return LocalPlayer.Character or (LocalPlayer.CharacterAdded:wait() and LocalPlayer.Character)
end
local function Check(Flag)
    local HumanoidRootPart = GetChar():FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return false end
    if Flag == "InLift" then
        if HumanoidRootPart.Position.X < 50 and HumanoidRootPart.Position.Z > 70 then
            return true
        end
    elseif Flag == "InGame" then
        if HumanoidRootPart.Position.X > 50 then
            return true
        end
    end
    return false
end
local function CheckNearTargetPosition()
    local character = GetChar()
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return false end
    local distance = (HumanoidRootPart.Position - TARGET_POSITION).Magnitude
    return distance <= TELEPORT_RADIUS
end
local function TeleportToLobby()
    local character = GetChar()
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end
    if TELEPORT_DESTINATION and TELEPORT_DESTINATION:IsA("Part") then
        HumanoidRootPart.CFrame = TELEPORT_DESTINATION.CFrame
        Alert("Teleported to Lobby PlayHere!")
    else
        Alert("Warning: Teleport destination not found!")
    end
end
local MapDetect
local ConnectMap
local function OnMapLoad(Map)
    local MapName = Map:WaitForChild("Settings"):GetAttribute("MapName")
    if MapName then
        Alert("Map Loaded!" .. MapName)
    end
    if Check("InGame") == false then
        Alert("Skipping due to InGame == false.")
    end
    local Buttons = {}
    for i, MapObject in pairs(Map:GetDescendants()) do
        if isRandomString(MapObject.Name) and MapObject.ClassName == "Model" then
            local Hitbox
            for i, Candidate in pairs(MapObject:GetChildren()) do
                if Candidate:IsA("BasePart") and tostring(Candidate.BrickColor) ~= "Medium stone grey" then
                    Hitbox = Candidate
                    break
                end
            end
            if Hitbox and isRandomString(Hitbox.Name) then
                Hitbox.Name = "Hitbox"
                table.insert(Buttons, MapObject)
            end
        end
    end
    local HumanoidRootPart = GetChar().HumanoidRootPart
    local OriginalCFrame = HumanoidRootPart.CFrame
    local LostPage = Map:FindFirstChild("_LostPage", true)
    if LostPage then
        HumanoidRootPart.CFrame = LostPage.CFrame
        task.wait()
        HumanoidRootPart.CFrame = OriginalCFrame
        Alert("Got Lost Page.")
    end
    local Escapee = Map:FindFirstChild("NPC", true)
    if Escapee then
        Escapee = Escapee.Parent
        if Escapee then
            Escapee = Escapee.Contact
        else
            Escapee = Map:FindFirstChild("Contact", true)
        end
        if Escapee then
            local OriginalCFrame = HumanoidRootPart.CFrame
            HumanoidRootPart.CFrame = Escapee.CFrame
            task.wait()
            HumanoidRootPart.CFrame = OriginalCFrame
            Alert("Got Escapee.")
        end
    end
    Alert("Commencing Auto Farm")
    local CurrentButton = nil
    local Humanoid = GetChar().Humanoid
    local GodMode
    GodMode = Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        Humanoid.Health = 1000
    end)
    local Attempts = 0
    local DifferentScan = false
    while task.wait(CHECK_DELAY) and Check("InGame") do
        local ExitRegion = Map:FindFirstChild("ExitRegion", true)
        local HumanoidRootPart = GetChar().HumanoidRootPart
        Humanoid.Jump = true
        local FailedScan = true
        if not ExitRegion then
            for i, Button in pairs(Buttons) do
                local ButtonHitbox = Button:FindFirstChild("Hitbox")
                if ButtonHitbox then
                    CurrentButton = Button
                    local ButtonID = tostring(i)
                    local ButtonColor = tostring(Button.Hitbox.BrickColor)
                    local TouchFound = Button:FindFirstChild("TouchInterest", true)
                    local GuiFound = Button:FindFirstChildWhichIsA("BillboardGui", true)
                    if (TouchFound and GuiFound) then
                        FailedScan = false
                        HumanoidRootPart.Anchored = false
                        local OriginalCFrame = HumanoidRootPart.CFrame
                        HumanoidRootPart.CFrame = CFrame.new(ButtonHitbox.Position)
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
                        task.wait(.1)
                        HumanoidRootPart.Anchored = true
                        task.wait(BUTTON_DELAY)
                    end
                end
            end
            if FailedScan == true then
                DifferentScan = true
            end
        elseif ExitRegion then
            HumanoidRootPart.Anchored = false
            if Attempts < EXITREGION_MAX_ATTEMPTS then
                Attempts += 1
                HumanoidRootPart.CFrame = ExitRegion.CFrame 
                Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                HumanoidRootPart.Velocity = Vector3.new(50, -1, 50)
                task.wait()
                if (HumanoidRootPart.Position - ExitRegion.Position).Magnitude <= 5 then
                    Attempts += 1
                end
            else
                Alert("Teleported to ExitRegion.")
                break
            end
        end
    end
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(EXITREGION_WAIT)
    Alert("Complete.")
    GodMode:Disconnect()
    GodMode = nil
    Alert("Preparing for next Map! Resetting..")
    GetChar().Head:Destroy()
    Alert("Waiting for Player..")
    task.wait(2)
    local HumanoidRootPart = GetChar():WaitForChild("HumanoidRootPart")
    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
    repeat
        task.wait()
        HumanoidRootPart.Velocity = Vector3.new(0, 0, 100)
    until Check("InLift")
end
ConnectMap = function()
    MapDetect = Multiplayer.ChildAdded:Connect(function(NewMap)
        MapDetect:Disconnect()
        MapDetect = nil
        NewMap:GetPropertyChangedSignal("Name"):Wait()
        OnMapLoad(NewMap)
        Alert("Connecting..")
    end)
end
if _G.LoopCancel ~= nil then
    _G.LoopCancel = true
    task.wait(.1)
end
_G.LoopCancel = false
Alert("Ready! Starting Update Loop.")
while wait() do
    local function Cancel()
        Alert("Update Loop cancelled.")
        if MapDetect then
            MapDetect:Disconnect()
            MapDetect = nil
        end
    end
    if CheckNearTargetPosition() then
        TeleportToLobby()
    end
    if Check("InLift") == true and not MapDetect then
        ConnectMap()
    elseif Check("InLift") == false and MapDetect then
        MapDetect:Disconnect()
        MapDetect = nil
    end
    if _G.LoopCancel == true then
        _G.LoopCancel = false
        Cancel()
        break
    end
    if getgenv().TomatoAutoFarm == false then
        Alert("Auto Farm Paused!")
        repeat wait() until getgenv().TomatoAutoFarm == true or _G.LoopCancel == true
        Alert("Auto Farm Resumed!")
    end
end