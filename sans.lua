local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Sanses = workspace.Sanses
local player = Players.LocalPlayer
getgenv().AutoFarm = true
local isActive = true
local function isWithinRange(position)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local playerPosition = player.Character.HumanoidRootPart.Position
    local distance = (playerPosition - position).Magnitude
    return distance <= 50
end
local function startFarming()
    isActive = true
    while getgenv().AutoFarm and isActive do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = character.HumanoidRootPart.Position
            local allDescendants = Sanses:GetDescendants()
            for _, descendant in ipairs(allDescendants) do
                if not getgenv().AutoFarm or not isActive then break end
                if descendant:IsA("ClickDetector") then
                    local parent = descendant.Parent
                    if parent then
                        local targetPosition
                        if parent:IsA("BasePart") then
                            targetPosition = parent.Position
                        elseif parent:FindFirstChildWhichIsA("BasePart") then
                            targetPosition = parent:FindFirstChildWhichIsA("BasePart").Position
                        elseif parent:IsA("Model") and parent.PrimaryPart then
                            targetPosition = parent.PrimaryPart.Position
                        else
                            continue
                        end
                        if isWithinRange(targetPosition) then
                            fireclickdetector(descendant)
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end
if player.Character then
    spawn(startFarming)
end
player.CharacterAdded:Connect(function(character)
    task.wait()
    if getgenv().AutoFarm then
        spawn(startFarming)
    end
end)
player.CharacterRemoving:Connect(function()
    isActive = false
end)