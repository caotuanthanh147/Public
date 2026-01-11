local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Events = ReplicatedStorage.Events
local VIM = game:GetService("VirtualInputManager")
getgenv().AutoEvent = true
getgenv().AutoRest = true
local OFFSET_X = 35
local OFFSET_Y = 50
local currentRow = 0
local function hasEnemies()
    local entities = workspace.Entities
    return entities and #entities:GetChildren() > 0
end
local function sendNode(nodeType)
    currentRow = currentRow + 1
    local args = {
        {
            Override = true,
            RowToUnlock = currentRow,
            Name = "Boss",      
            NodeType = nodeType
        }
    }
    Events.NodeSelect:FireServer(unpack(args))
end
local function clickDialogueOptions()
    local npcName = "Luscious Big Brother of the Middle"
    local initialEntities = workspace:FindFirstChild("Entities")
    local initialTarget = initialEntities and initialEntities:FindFirstChild(npcName)
    if hasEnemies() and not initialTarget then
        return false
    end
    local dialogueContainer = LocalPlayer.PlayerGui.DungeonGui.DialogueContainer
    local container = dialogueContainer.Container
    local eventName = container.EventName
    if eventName and eventName.Text == "A Mysterious Coupon" then
        local targetNow = workspace:FindFirstChild("Entities") and workspace.Entities:FindFirstChild(npcName)
        if hasEnemies() and not targetNow then
            return false
        end
        local function clickOptionByText(targetText)
            for i = 1, 3 do
                local opt = container["Options"..i]
                if opt then
                    local optTextObj = opt:FindFirstChild("OptionText")
                    if optTextObj and optTextObj.Text == targetText then
                        local posX = opt.AbsolutePosition.X + (opt.AbsoluteSize.X / 2) + OFFSET_X
                        local posY = opt.AbsolutePosition.Y + (opt.AbsoluteSize.Y / 2) + OFFSET_Y
                        local ok, err = pcall(function()
                            VIM:SendMouseButtonEvent(posX, posY, 0, true, game, 1)
                            task.wait(0.01)
                            VIM:SendMouseButtonEvent(posX, posY, 0, false, game, 1)
                        end)
                        if not ok then
                            return false
                        end
                        task.wait(0.12) 
                        return true
                    end
                end
            end
            return false
        end
        local firstClicked = clickOptionByText("Something like this could be very valuable.")
        if not firstClicked then
        end
        local secondClicked = clickOptionByText("Continue")
        if not secondClicked then
        end
        local timeout = 5
        local startTime = tick()
        wait(5)
        local target = workspace:FindFirstChild("Entities") and workspace.Entities:FindFirstChild(npcName)
        while target and target.Parent and (tick() - startTime) < timeout do
            task.wait(0.25)
        end
        if not target or not target.Parent then
            Events.BeginTeleport:FireServer(true)
            return true
        else
            return false
        end
    end
    local validOptions = {
        "Continue",
        "Something like this could be very valuable."
    }
    for i = 1, 3 do
        local option = container["Options"..i]
        if option then
            local optionTextObj = option:FindFirstChild("OptionText")
            if optionTextObj then
                local optionText = optionTextObj.Text
                if optionText ~= "" and optionText ~= nil then
                    for _, validText in ipairs(validOptions) do
                        if optionText == validText then
                            local posX = option.AbsolutePosition.X + (option.AbsoluteSize.X / 2) + OFFSET_X
                            local posY = option.AbsolutePosition.Y + (option.AbsoluteSize.Y / 2) + OFFSET_Y
                            local ok, err = pcall(function()
                                VIM:SendMouseButtonEvent(posX, posY, 0, true, game, 1)
                                task.wait(0.01)
                                VIM:SendMouseButtonEvent(posX, posY, 0, false, game, 1)
                            end)
                            if not ok then
                                return false
                            end
                            return true
                        end
                    end
                else
                end
            else
            end
        else
        end
    end
    return false
end
local function clickRestOption()
    if not getgenv().AutoRest then return false end
    if hasEnemies() then return false end
    local restContainer = LocalPlayer.PlayerGui.DungeonGui:FindFirstChild("RestContainer")
    if not restContainer then return false end
    local option2 = restContainer.Container:FindFirstChild("Options2")
    if not option2 then return false end
    local optionText = option2:FindFirstChild("OptionText")
    if not optionText then return false end
    local posX = option2.AbsolutePosition.X + (option2.AbsoluteSize.X / 2) + OFFSET_X
    local posY = option2.AbsolutePosition.Y + (option2.AbsoluteSize.Y / 2) + OFFSET_Y
    if posX >= 100 and posY >= 100 then
        VIM:SendMouseButtonEvent(posX, posY, 0, true, game, 1)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(posX, posY, 0, false, game, 1)
        return true
    end
    return false
end
local function autoEventLoop()
    while getgenv().AutoEvent do
        if hasEnemies() then
            task.wait(1)
        else
            local clicked = clickDialogueOptions()
            if not clicked then
                local rested = clickRestOption()
                if not rested then
                    sendNode("Event")
                    task.wait(0.2)
                    local attempts = 0
                    while attempts < 5 and not clicked do
                        task.wait(0.2)
                        clicked = clickDialogueOptions()
                        attempts = attempts + 1
                    end
                else
                    task.wait(0.2) 
                end
            else
                task.wait(0.2)
            end
            task.wait(0.2)
        end
    end
end
task.spawn(autoEventLoop)