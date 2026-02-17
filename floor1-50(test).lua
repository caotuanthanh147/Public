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
local Workspace = game:GetService("Workspace")
local function getRefPartFromPrompt(prompt)
    local parent = prompt and prompt.Parent
    if not parent then return nil end
    if parent:IsA("BasePart") then
        return parent
    elseif parent:IsA("Model") then
        return parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end
local function fireProximityPrompts(targetName, offsetY, opts)
    opts = opts or {}
    offsetY = type(offsetY) == "number" and offsetY or 3
    local prompts = findInstances(targetName, "ProximityPrompt")
    if #prompts == 0 then return false end
    local root = getLocalHRP(opts.hrpTimeout or 3)
    if not root then
        local fallbackParent = prompts[1].Parent
        if fallbackParent then
            teleportToTarget(fallbackParent.Name, offsetY)
            task.wait(opts.postTeleportWait or 0.3)
        end
        if fireproximityprompt then
            fireproximityprompt(prompts[1])
            return true
        end
        return false
    end
    local closestPrompt, closestPart, closestDist = nil, nil, math.huge
    for _, prompt in ipairs(prompts) do
        local refPart = getRefPartFromPrompt(prompt)
        if refPart then
            local dist = (refPart.Position - root.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPrompt = prompt
                closestPart = refPart
            end
        end
    end
    if not closestPrompt then
        closestPrompt = prompts[1]
        closestPart = getRefPartFromPrompt(closestPrompt)
    end
    if closestPrompt and closestPart then
        local teleportTarget = closestPrompt.Parent
        if teleportTarget then
            teleportToTarget(teleportTarget.Name, offsetY)
            task.wait(opts.postTeleportWait or 0.3)
        else
            root.CFrame = closestPart.CFrame + Vector3.new(0, offsetY, 0)
            task.wait(opts.postTeleportWait or 0.08)
        end
        if fireproximityprompt then
            fireproximityprompt(closestPrompt)
            task.wait(opts.afterFireWait or 0.05)
            return true
        else
            root.CFrame = closestPart.CFrame + Vector3.new(0, offsetY, 0)
            task.wait(opts.afterFireWait or 0.1)
            return true
        end
    end
    return false
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
    ["BrokenSchool"] = function()
        print("Running BrokenSchool action")
        teleportToTarget("Roof", 3)
    end,
    ["SnowySlope"] = function()
        print("Running SnowySlope action")
        fireTouchInterests("WinPart")
    end,
["Forest_TwoStudCamp"] = function()
    print("Running Forest_TwoStudCamp action")
    task.wait(10)

    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local firewoodPart = workspace.Forest_TwoStudCamp.Build.Firewood:GetChildren()[3]
    root.CFrame = firewoodPart.CFrame * CFrame.new(0, 0, -3)
    for j = 1, 3 do
        fireproximityprompt(firewoodPart.ProximityPrompt)
        task.wait(0.3)
    end

    task.wait(0.3)

    local cauldronPart = workspace.Forest_TwoStudCamp.Build.Cauldron.PromptPart
    root.CFrame = cauldronPart.CFrame * CFrame.new(0, 0, -3)
    for j = 1, 3 do
        fireproximityprompt(cauldronPart.ProximityPrompt)
        task.wait(0.3)
    end

    task.wait(0.5)
end,
    ["FunnyMaze"] = function()
        print("Running FunnyMaze action")
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
        print("Running UES action")
        for i = 1, 50 do
            fireProximityPrompts("cardboard_box", 3)
            task.wait(4)
        end
    end,
["ButtonCompetition"] = function()
    print("Running ButtonCompetition action")

    local buttonsFolder = Workspace
        :WaitForChild("ButtonCompetition")
        :WaitForChild("Build")
        :WaitForChild("Buttons")

    for _, child in ipairs(buttonsFolder:GetDescendants()) do
        local detector = child:FindFirstChildOfClass("ClickDetector")
        if detector and fireclickdetector then
            task.spawn(function()
                fireclickdetector(detector)
            end)
        end
    end
end,
    ["ElevatorShaft"] = function()
        print("Running ElevatorShaft action")
        fireProximityPrompts("Levers", 3)
    end,
["SurvivalTheArea51"] = function()
    print("Running SurvivalTheArea51 action")
    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local prompts = {
        workspace.SurvivalTheArea51.Build.JeremyRoom.Generator,
        workspace.SurvivalTheArea51.Build.KillerRoom.Generator,
        workspace.SurvivalTheArea51.Build.DougRoom.Generator,
        workspace.SurvivalTheArea51.Build.AngryWallRoom.Generator,
        workspace.SurvivalTheArea51.Build.Generator,
        workspace.SurvivalTheArea51.Build.EndRoom.Generator,
    }

    for _, part in ipairs(prompts) do
        root.CFrame = part.CFrame * CFrame.new(0, 0, -3)
        fireproximityprompt(part.ProximityPrompt)
        task.wait(1)
    end
end,
    ["WALL_OF"] = function()
        print("Running WALL_OF action")
        fireTouchInterests("EndCheckpoint")
    end,
    ["Normal_Dance"] = function()
        print("Running Normal_Dance action")
        r()
    end,
    ["SLIDE_9999999999_FEET_DOWN_RAINBOW"] = function()
        print("Running SLIDE_9999999999_FEET_DOWN_RAINBOW action")
        fireTouchInterests("MiddleRing")
    end,
    ["CliffsideChaos"] = function()
        print("Running CliffsideChaos action")
        teleportToTarget("Roof", 3)
    end,
    ["bugbo"] = function()
        print("Running bugbo action")
        task.wait(10)
        fireClickDetectors("Rocks")
    end,
    ["InfectedRacing"] = function()
        print("Running InfectedRacing action")
        r()
    end,
    ["SuspiciouslyLongRoom"] = function()
        print("Running SuspiciouslyLongRoom action")
        fireTouchInterests("WinPool")
    end,
    ["TeapotDodgeball"] = function()
    print("Running TeapotDodgeball action")
        fireTouchInterests("Finish")
        task.wait(0.5)
end,
["SlimYim"] = function()
    print("Running SlimYim action")
    r()
end,
["JermpopFactory"] = function()
    print("Running JermpopFactory action")
    local Workspace = game:GetService("Workspace")

    local cleanupButtons =
        Workspace:WaitForChild("JermpopFactory")
        :WaitForChild("Build")
        :WaitForChild("CleanupButtons")
    if cleanupButtons then
        for _, child in pairs(cleanupButtons:GetDescendants()) do
            local prim = child:FindFirstChild("Prim")
            if prim then
                local hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and prim:IsA("BasePart") then
                    hrp.CFrame = prim.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.3)
                end
                local prompt = prim:FindFirstChildOfClass("ProximityPrompt")
                if prompt and fireproximityprompt then
                    fireproximityprompt(prompt)
                end
            end
            task.wait(0.1)
        end
    end
end,
["RedBallTemple"] = function()
    print("Running RedBallTemple action")
    r()
end,
["RedballDiner"] = function()
    print("Running RedballDiner action")
    r()
end,
["OldRobloxHouse"] = function()
    print("Running OldRobloxHouse action")
    r()
end,
["PetCaptureDeluxe"] = function()
    print("Running PetCaptureDeluxe action")
    local Workspace = game:GetService("Workspace")

    local ActiveMonsters =
        Workspace:WaitForChild("PetCaptureDeluxe")
            :WaitForChild("Build")
            :WaitForChild("ActiveMonsters")
    if activeMonsters then
        for _, descendant in ipairs(activeMonsters:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") and fireproximityprompt then
                local part = descendant.Parent
                if part and part:IsA("BasePart") then
                    local hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = part.CFrame * CFrame.new(0, 3, 0)
                        task.wait(0.3)
                    end
                end
                fireproximityprompt(descendant)
                task.wait(0.1)
            end
        end
    end
end,
["UnsteadyFloor"] = function()
    print("Running UnsteadyFloor action")
    fireTouchInterests("END")
end,
["THEROCK"] = function()
    print("Running THEROCK action")
    fireTouchInterests("Buttons")
end,
["ElevatorInsideAx5"] = function()
    print("Running ElevatorInsideAx5 action")
    r()
end,
["FunTimesAtSquishyFlood"] = function()
    print("Running FunTimesAtSquishyFlood action")
    fireTouchInterests("Winparts")
end,
}