local Players = game:GetService("Players")
local function getLocalHRP(timeoutSeconds)
    local plr = Players.LocalPlayer
    if not plr then return nil end
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then return hrp end
    if timeoutSeconds then
        local ok, obj = pcall(function() return char:WaitForChild("HumanoidRootPart", timeoutSeconds) end)
        if ok then return obj end
    end
    return char:FindFirstChild("HumanoidRootPart")
end
local function touchTransmitter(targetName)
    local root = getLocalHRP(5) 
    if not root then
        warn("touchTransmitter: no HumanoidRootPart found for LocalPlayer")
        return
    end
    local foundAny = false
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("TouchTransmitter") then
            local parentName = descendant.Parent and descendant.Parent.Name
            if (not targetName) or descendant.Name == targetName or parentName == targetName then
                local part = descendant:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    foundAny = true
                    pcall(function()
                        if firetouchinterest then
                            firetouchinterest(part, root, 1)
                            task.wait() 
                            firetouchinterest(part, root, 0)
                        else
                            local orig = part.CFrame
                            part.CFrame = root.CFrame
                            task.wait(0.05)
                            part.CFrame = orig
                        end
                    end)
                end
            end
        end
    end
    if not foundAny then
        warn("touchTransmitter: no matching TouchTransmitter found for target:", targetName)
    end
end


return {
    ["MozelleSquidGames"] = function()
        print("Running MozelleSquidGames action")
        touchTransmitter("Winner")
    end,
    ["StanelyRoom"] = function()
        print("Running StanelyRoom action")
        touchTransmitter("EndTouch")
    end,
    ["FloodFillMine"] = function()
        print("Running FloodFillMine action")
        touchTransmitter("Bubble")
    end,
    ["Splitsville_Wipeout"] = function()
        print("Running Splitsville_Wipeout action")
        touchTransmitter("EndCheckpoint")
    end,
    ["Obby"] = function()
        print("Running Obby action")
        touchTransmitter("EndPart")
    end,
    ["IntenseObby"] = function()
        print("Running IntenseObby action")
        touchTransmitter("ENDBLOCK")
    end,
    ["FindThePath"] = function()
        print("Running FindThePath action")
        touchTransmitter("win_zone")
    end,
    ["GASA4"] = function()
        print("Running GASA4 action")
        touchTransmitter("ExtractionBox")
    end,
    ["Minefield"] = function()
        print("Running Minefield action")
        touchTransmitter("WinPart")
    end,
    ["WhoKilledYouObby"] = function()
        print("Running WhoKilledYouObby action")
        touchTransmitter("WinPart")
    end,
    ["TeapotDodgeball"] = function()
        print("Running TeapotDodgeball action")
        touchTransmitter("Finish")
    end,
    ["Superhighway"] = function()
        print("Running Superhighway action")
        touchTransmitter("WinPoint")
    end,
    ["SuperDropper"] = function()
        print("Running SuperDropper action")
        touchTransmitter("WinPool")
    end,
    ["SLIDE_9999999999_FEET_DOWN_RAINBOW"] = function()
        print("Running SLIDE_9999999999_FEET_DOWN_RAINBOW action")
        touchTransmitter("MiddleRing")
    end,
}