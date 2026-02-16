local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local function r()
    local character = Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
        end
    end
end
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
        if descendant:IsA(className) and (not targetName or descendant.Name == targetName or descendant.Parent.Name == targetName) then
            table.insert(results, descendant)
        end
    end
    return results
end
local function getLocalHRP(timeoutSeconds)
    local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp or not timeoutSeconds then return hrp end
    local ok, obj = pcall(char.WaitForChild, char, "HumanoidRootPart", timeoutSeconds)
    return ok and obj or nil
end
local function teleportToTarget(targetName, offsetY)
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
    local hrp = getLocalHRP()
    if not hrp then return false end
    hrp.CFrame = parts[1].CFrame * CFrame.new(0, offsetY or 3, 0)
    return true
end
local function fireProximityPrompts(targetName, offsetY)
    local prompts = findInstances(targetName, "ProximityPrompt")
    if #prompts == 0 then return false end
    local teleportTarget = Workspace:FindFirstChild(targetName, true) or prompts[1].Parent
    if teleportTarget then
        teleportToTarget(teleportTarget.Name, type(offsetY) == "number" and offsetY or 3)
        task.wait(0.3)
    end
    for _, prompt in ipairs(prompts) do
        if fireproximityprompt then
            fireproximityprompt(prompt)
            task.wait(0.05)
        end
    end
    return true
end
local function fireClickDetectors(targetName)
    local detectors = findInstances(targetName, "ClickDetector")
    if #detectors == 0 then return false end
    for _, detector in ipairs(detectors) do
        if fireclickdetector then
            fireclickdetector(detector)
            task.wait(0.05)
        end
    end
    return true
end
local function fireTouchInterests(targetName, opts)
    opts = opts or {}
    local root = getLocalHRP(opts.hrpTimeout or 3)
    if not root then return false end
    local maxWait = opts.maxWait or 5
    local elapsed = 0
    while elapsed <= maxWait do
        local transmitters = findInstances(targetName, "TouchTransmitter")
        if #transmitters > 0 then
            for _, tx in ipairs(transmitters) do
                local part = tx:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    pcall(function()
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
                    task.wait(0.05)
                end
            end
            return true
        end
        task.wait(opts.interval or 0.15)
        elapsed = elapsed + (opts.interval or 0.15)
    end
    return false
end
wait(7)
return {
    ["MozelleSquidGames"] = function() fireTouchInterests("Winner") end,
    ["StanelyRoom"] = function() fireTouchInterests("EndTouch") end,
    ["FloodFillMine"] = function() fireTouchInterests("Bubble") end,
    ["Splitsville_Wipeout"] = function() fireTouchInterests("EndCheckpoint") end,
    ["Obby"] = function() fireTouchInterests("EndPart") end,
    ["IntenseObby"] = function() fireTouchInterests("ENDBLOCK") end,
    ["FindThePath"] = function() fireTouchInterests("win_zone") end,
    ["GASA4"] = function() fireTouchInterests("ExtractionBox") end,
    ["Minefield"] = function() fireTouchInterests("WinPart") end,
    ["WhoKilledYouObby"] = function() fireTouchInterests("WinPart") end,
    ["GumballMachine"] = function() fireTouchInterests("WinPart") end,
    ["3008_Room"] = function() fireClickDetectors("Lampert") end,
    ["Superhighway"] = function() fireTouchInterests("WinPoint") end,
    ["SuperDropper"] = function() fireTouchInterests("WinPool") end,
    ["RandomMazeWindows"] = function() fireTouchInterests("Build") end,
    ["Jeremy"] = function() teleportToTarget("Button", 3) end,
    ["BrokenSchool"] = function() teleportToTarget("Roof", 3) end,
    ["SnowySlope"] = function() fireTouchInterests("WinPart") end,
    ["Forest_TwoStudCamp"] = function()
        task.wait(10)
        for i = 1, 30 do
            fireProximityPrompts("Firewood", 3)
            task.wait(0.3)
            fireProximityPrompts("Cauldron", 3)
            task.wait(0.5)
        end
    end,
    ["FunnyMaze"] = function()
        local finalNotes = Workspace.FunnyMaze.Build.FinalNotes
        for _, child in ipairs(finalNotes:GetChildren()) do
            local detector = child:FindFirstChildOfClass("ClickDetector")
            if detector and fireclickdetector then
                fireclickdetector(detector)
                task.wait(0.05)
            end
        end
    end,
    ["UES"] = function()
        for i = 1, 50 do
            fireProximityPrompts("cardboard_box", 3)
            task.wait(2)
        end
    end,
    ["ButtonCompetition"] = function()
        task.wait(3)
        for i = 1, 100 do
            fireClickDetectors("Button")
            task.wait(0.2)
        end
    end,
    ["ElevatorShaft"] = function() fireProximityPrompts("Levers", 3) end,
    ["SurvivalTheArea51"] = function()
        for _, location in ipairs({"AngryWallRoom", "DougRoom", "JeremyRoom", "KillerRoom", "Generator", "EndRoom"}) do
            fireProximityPrompts(location, 3)
            task.wait(1)
        end
    end,
    ["WALL_OF"] = function() fireTouchInterests("EndCheckpoint") end,
    ["Normal_Dance"] = r,
    ["SLIDE_9999999999_FEET_DOWN_RAINBOW"] = function() fireTouchInterests("MiddleRing") end,
    ["CliffsideChaos"] = function() teleportToTarget("Roof", 3) end,
    ["bugbo"] = function() fireClickDetectors("Rocks") end,
    ["InfectedRacing"] = r,
}