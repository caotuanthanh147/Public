local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local function findInstances(targetName, className)
    local results = {}
    local searchRoot = Workspace
    if targetName then
        local obj = Workspace:FindFirstChild(targetName)
        if obj and obj:IsA("Folder") then
            searchRoot = obj
        end
    end
    for _, descendant in ipairs(searchRoot:GetDescendants()) do
        if descendant:IsA(className) then
            if not targetName or descendant.Name == targetName or (descendant.Parent and descendant.Parent.Name == targetName) then
                table.insert(results, descendant)
            end
        end
    end
    return results
end
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
local function teleportToTarget(targetName, offsetY)
    offsetY = offsetY or 3
    local parts = findInstances(targetName, "BasePart")
    if #parts == 0 then
        local models = findInstances(targetName, "Model")
        for _, model in ipairs(models) do
            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if part then
                parts = {part}
                break
            end
        end
    end
    if #parts == 0 then return false end
    local targetPart = parts[1]
    local player = Players.LocalPlayer
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.CFrame = targetPart.CFrame * CFrame.new(0, offsetY, 0)
    return true
end
local function fireProximityPrompts(targetName, offsetY)
    local prompts = findInstances(targetName, "ProximityPrompt")
    if #prompts == 0 then return false end
    local teleportTarget
    if targetName then
        teleportTarget = Workspace:FindFirstChild(targetName, true)
    end
    if not teleportTarget then
        teleportTarget = prompts[1].Parent
    end
    local yOffset = 3
    if offsetY then
        if type(offsetY) == "number" then
            yOffset = offsetY
        elseif typeof(offsetY) == "Vector3" then
            yOffset = offsetY.Y
        end
    end
    if teleportTarget then
        teleportToTarget(teleportTarget.Name, yOffset)
        task.wait(0.3)
    end
    for _, prompt in ipairs(prompts) do
        if fireproximityprompt then
            fireproximityprompt(prompt)
        end
        task.wait(0.05)
    end
    return true
end
local function fireClickDetectors(targetName)
    local detectors = findInstances(targetName, "ClickDetector")
    if #detectors == 0 then return false end
    for _, detector in ipairs(detectors) do
        if fireclickdetector then
            fireclickdetector(detector)
        end
        task.wait(0.05)
    end
    return true
end
local function fireTouchInterests(targetName, opts)
    opts = opts or {}
    local maxWait = opts.maxWait or 5
    local interval = opts.interval or 0.15
    local hrpTimeout = opts.hrpTimeout or 3
    local root = getLocalHRP(hrpTimeout)
    if not root then
        return false
    end
    local elapsed = 0
    while elapsed <= maxWait do
        local transmitters = findInstances(targetName, "TouchTransmitter")
        if #transmitters > 0 then
            for _, tx in ipairs(transmitters) do
                local part = tx:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    local ok, err = pcall(function()
                        if firetouchinterest then
                            firetouchinterest(part, root, 1)
                            task.wait()
                            firetouchinterest(part, root, 0)
                        else
                            local origCF = part.CFrame
                            part.CFrame = root.CFrame
                            task.wait(0.05)
                            part.CFrame = origCF
                        end
                    end)
                    if not ok then
                    end
                end
                task.wait(0.05)
            end
            return true
        end
        task.wait(interval)
        elapsed = elapsed + interval
    end
    return false
end
return {
    ["MozelleSquidGames"] = function()
        print("Running MozelleSquidGames action")
        fireTouchInterests("Winner")
    end,
    ["StanelyRoom"] = function()
        print("Running StanelyRoom action")
        fireTouchInterests("EndTouch")
    end,
    ["FloodFillMine"] = function()
        print("Running FloodFillMine action")
        fireTouchInterests("Bubble")
    end,
    ["Splitsville_Wipeout"] = function()
        print("Running Splitsville_Wipeout action")
        fireTouchInterests("EndCheckpoint")
    end,
    ["Obby"] = function()
        print("Running Obby action")
        fireTouchInterests("EndPart")
    end,
    ["IntenseObby"] = function()
        print("Running IntenseObby action")
        fireTouchInterests("ENDBLOCK")
    end,
    ["FindThePath"] = function()
        print("Running FindThePath action")
        fireTouchInterests("win_zone")
    end,
    ["GASA4"] = function()
        print("Running GASA4 action")
        fireTouchInterests("ExtractionBox")
    end,
    ["Minefield"] = function()
        print("Running Minefield action")
        fireTouchInterests("WinPart")
    end,
    ["WhoKilledYouObby"] = function()
        print("Running WhoKilledYouObby action")
        fireTouchInterests("WinPart")
    end,
    ["GumballMachine"] = function()
        print("Running GumballMachine action")
        fireTouchInterests("WinPart")
    end,
    ["3008_Room"] = function()
        print("Running 3008_Room action")
        fireClickDetectors("Lampert")
    end,
    ["Superhighway"] = function()
        print("Running Superhighway action")
        fireTouchInterests("WinPoint")
    end,
    ["SuperDropper"] = function()
        print("Running SuperDropper action")
        fireTouchInterests("WinPool")
    end,
    ["RandomMazeWindows"] = function()
        print("Running RandomMazeWindows action")
        fireTouchInterests("Build")
    end,
    ["Jeremy"] = function()
        print("Running Jeremy action")
        teleportToTarget("Button", 3)
    end,
    ["FunnyMaze"] = function()
        print("Running FunnyMaze action")
        fireClickDetectors("FinalNotes")
    end,
    ["SnowySlope"] = function()
    print("Running SnowySlope action")
    fireTouchInterests("WinPart")
end,
}