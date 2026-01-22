local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local LocalPlayer = game.Players.LocalPlayer
local autoPlayEnabled = true
local function autoPlayLoop()
    while autoPlayEnabled do
        if LocalPlayer:GetAttribute("IsYourTurn") then
            Events.EndTurn:FireServer()
        end
        task.wait(0.1)
    end
end
task.spawn(autoPlayLoop)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("NodeSelect")
local syncStats = ReplicatedStorage:WaitForChild("Events"):WaitForChild("SyncStats")
local currentRow = 0
local fragmentsTreasure = 0
local modes = {"Elite", "Rest", "Boss", "Event"}
local modeIndex = 1
local function sendNode(nodeType, isBoss)
    currentRow = currentRow + 1
    local args = {
        {
            Override = true,
            RowToUnlock = currentRow,
            Name = "Boss",      
            NodeType = nodeType
        }
    }
    remote:FireServer(unpack(args))
end
while true do
    sendNode("Boss", true)
    wait(1)
end