local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local targetPosition = Vector3.new(-2498, 3454, -38770)
local teleportPosition = Vector3.new(4035, 32, 858)
local checkRadius = 800
local checkInterval = 20
local function findPumpkinTeleporter()
    local ascensionMaps = workspace:FindFirstChild("Ascension Trial Maps")
    if not ascensionMaps then return nil end
    local halloweenTown = ascensionMaps:FindFirstChild("Halloween Town")
    if not halloweenTown then return nil end
    local teleporters = halloweenTown:FindFirstChild("Teleporters")
    if not teleporters then return nil end
    local pumpkinTeleporter = teleporters:FindFirstChild("Pumpkin Caverns Teleporter")
    if not pumpkinTeleporter then return nil end
    local tele = pumpkinTeleporter:FindFirstChild("Tele")
    if not tele then return nil end
    return tele:FindFirstChildOfClass("TouchTransmitter")
end
local function fireTouchInterest(part, targetPart)
    if part and targetPart then
        if firetouchinterest then
            firetouchinterest(part, targetPart, 1)
            task.wait()
            firetouchinterest(part, targetPart, 0)
        end
    end
end
local function checkAndTeleport()
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local lastAwayTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local currentPosition = humanoidRootPart.Position
        local distance = (currentPosition - targetPosition).Magnitude
        if distance > checkRadius then
            if tick() - lastAwayTime >= checkInterval then
                humanoidRootPart.CFrame = CFrame.new(teleportPosition)
                local touchTransmitter = findPumpkinTeleporter()
                if touchTransmitter then
                    local telePart = touchTransmitter.Parent
                    if telePart then
                        fireTouchInterest(telePart, humanoidRootPart)
                    end
                end
                task.wait(0.5) 
                humanoidRootPart.CFrame = CFrame.new(targetPosition)
                lastAwayTime = tick()
            end
        else
            lastAwayTime = tick()
        end
    end)
    return connection
end
checkAndTeleport()