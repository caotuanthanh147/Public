local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Sanses = workspace.Sanses
local player = Players.LocalPlayer
getgenv().AutoFarm = true
local isActive = true
local function startFarming()
    isActive = true
    while getgenv().AutoFarm and isActive do
        local allDescendants = Sanses:GetDescendants()
        for _, descendant in ipairs(allDescendants) do
            if not getgenv().AutoFarm or not isActive then 
                break 
            end
            if descendant:IsA("ClickDetector") then
                local parent = descendant.Parent
                if parent then
                    fireclickdetector(descendant)
                end
            end
        end
        task.wait()
    end
end
if player.Character then
    spawn(startFarming)
end
player.CharacterAdded:Connect(function(character)
    if getgenv().AutoFarm then
        spawn(startFarming)
    end
end)
player.CharacterRemoving:Connect(function()
    isActive = false
end)