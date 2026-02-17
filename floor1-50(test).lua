local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local function r()
    if not _G.ResetEnabled then return end
    if inLob() then return end
    local character = Players.LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid:ChangeState(Enum.HumanoidStateType.Dead)
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
        task.wait(3)
        fireTouchInterests("ReturnPortal")
    end,
    ["RandomMazeWindows"] = function()
        print("Running RandomMazeWindows action")
        fireTouchInterests("Build")
    end,
["Jeremy"] = function()
    print("Running Jeremy action")

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    local jeremy = workspace:WaitForChild("Jeremy")
    local build = jeremy:WaitForChild("Build")
    local button = build:WaitForChild("Button")
    local clicker = button:WaitForChild("Clicker")

    root.CFrame = clicker.CFrame * CFrame.new(0, -2, 0)
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
    local root = getLocalHRP()
    if not root then return end
    local forest = workspace:WaitForChild("Forest_TwoStudCamp")
    local build = forest:WaitForChild("Build")
    local firewoodFolder = build:WaitForChild("Firewood")
    local firePrompt = firewoodFolder:FindFirstChildWhichIsA("ProximityPrompt", true)
    if firePrompt and firePrompt.Parent and firePrompt.Parent:IsA("BasePart") then
        root.CFrame = firePrompt.Parent.CFrame * CFrame.new(0, 0, -3)
        for j = 1, 2 do
            fireproximityprompt(firePrompt)
            task.wait(0.3)
        end
    end
    task.wait(0.3)
    local cauldronPart = build:WaitForChild("Cauldron"):WaitForChild("PromptPart")
    root.CFrame = cauldronPart.CFrame * CFrame.new(0, 0, -3)
    local cauldronPrompt = cauldronPart:FindFirstChildWhichIsA("ProximityPrompt", true)
    if cauldronPrompt then
        for j = 1, 2 do
            fireproximityprompt(cauldronPrompt)
            task.wait(0.3)
        end
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
    fireProximityPrompts("cardboard_box", 3)
    task.wait(4)
end,
["ButtonCompetition"] = function()
    print("Running ButtonCompetition action")
    task.wait(10)

    local buttonsFolder = Workspace
        :WaitForChild("ButtonCompetition")
        :WaitForChild("Build")
        :WaitForChild("Buttons")

    for _, child in pairs(buttonsFolder:GetDescendants()) do
        local detector = child:FindFirstChildOfClass("ClickDetector")
        if detector and fireclickdetector then
            fireclickdetector(detector)
        end
    end
end,
["ElevatorShaft"] = function()
    print("Running ElevatorShaft action")
    local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, lever in pairs(workspace.ElevatorShaft.Build.Levers:GetDescendants()) do
        local prompt = lever.ClickPart.ProximityPrompt
        root.CFrame = lever.ClickPart.CFrame * CFrame.new(0, 0, -3)
        fireproximityprompt(prompt)
        task.wait(0.3)
    end
end,
["SurvivalTheArea51"] = function()
    print("Running SurvivalTheArea51 action")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local build = workspace:WaitForChild("SurvivalTheArea51"):WaitForChild("Build")
    local gens = {
        build:WaitForChild("JeremyRoom"):WaitForChild("Generator"),
        build:WaitForChild("KillerRoom"):WaitForChild("Generator"),
        build:WaitForChild("DougRoom"):WaitForChild("Generator"),
        build:WaitForChild("AngryWallRoom"):WaitForChild("Generator"),
        build:WaitForChild("Generator"),
        build:WaitForChild("EndRoom"):WaitForChild("Generator"),
    }
    for i = 1, #gens do
        local part = gens[i]
        local prompt = part and part:FindFirstChildOfClass("ProximityPrompt")
        if prompt and prompt.Enabled then
            root.CFrame = part.CFrame * CFrame.new(0, 0, -3)
            task.wait(0.2)
            if fireproximityprompt then
                fireproximityprompt(prompt)
            end
            task.wait(1)
            return
        end
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

    local rocks = workspace:WaitForChild("bugbo")
        :WaitForChild("Build")
        :WaitForChild("Rocks")

    for _, child in pairs(rocks:GetDescendants()) do
        local detector = child:FindFirstChildOfClass("ClickDetector")
        if detector and fireclickdetector then
            fireclickdetector(detector)
            task.wait(0.05)
        end
    end
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
                if hrp then
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

    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")

    local activeMonsters =
        Workspace:WaitForChild("PetCaptureDeluxe")
            :WaitForChild("Build")
            :WaitForChild("ActiveMonsters")

    if activeMonsters then
        local descendant = activeMonsters:FindFirstChildWhichIsA("ProximityPrompt", true)
        if descendant and fireproximityprompt then
            local part = descendant.Parent
            if part then
                local char = Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = part.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.3)
                end
            end

            fireproximityprompt(descendant)
            task.wait(0.1)
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
["PizzaDelivery"] = function()
    print("Running PizzaDelivery action")
    local root = getLocalHRP(3)
    if not root then return end
    local build = workspace:WaitForChild("PizzaDelivery"):WaitForChild("Build")
    local pizzaBoxesFolder = build:WaitForChild("PizzaBoxes")
    local pizzaDoorsFolder = build:WaitForChild("PizzaDoors")
    local function touchPart(part)
        if not part or not part:IsA("BasePart") then return end
        if firetouchinterest then
            firetouchinterest(part, root, 1)
            task.wait()
            firetouchinterest(part, root, 0)
        end
    end
    for _, pizza in ipairs(pizzaBoxesFolder:GetChildren()) do
        if pizza:IsA("BasePart") and pizza:FindFirstChild("TouchInterest") then
            touchPart(pizza)
            task.wait(0.02)
        end
    end
    for _, door in ipairs(pizzaDoorsFolder:GetDescendants()) do
        if door:IsA("BasePart") and door:FindFirstChild("TouchInterest") then
            touchPart(door)
            task.wait(0.02)
        end
    end
end,
["PizzaDelivery"] = function()
    print("Running PizzaDelivery action")
    local root = getLocalHRP(3)
    if not root then return end
    local build = workspace:WaitForChild("PizzaDelivery"):WaitForChild("Build")
    local pizzaBoxesFolder = build:WaitForChild("PizzaBoxes")
    local pizzaDoorsFolder = build:WaitForChild("PizzaDoors")
    local function touchPart(part)
        if not part or not part:IsA("BasePart") then return end
        if firetouchinterest then
            firetouchinterest(part, root, 1)
            task.wait()
            firetouchinterest(part, root, 0)
        end
    end
    for _, pizza in ipairs(pizzaBoxesFolder:GetChildren()) do
        if pizza:IsA("BasePart") and pizza:FindFirstChild("TouchInterest") then
            touchPart(pizza)
            task.wait(0.02)
        end
    end
    for _, door in ipairs(pizzaDoorsFolder:GetDescendants()) do
        if door:IsA("BasePart") and door:FindFirstChild("TouchInterest") then
            touchPart(door)
            task.wait(0.02)
        end
    end
end,
["Birthday"] = function()
    print("Running Birthday action")
    local destructibles = workspace:WaitForChild("Birthday")
        :WaitForChild("Build")
        :WaitForChild("destructible")
    for _, obj in ipairs(destructibles:GetDescendants()) do
        if obj:IsA("ClickDetector") and fireclickdetector then
            fireclickdetector(obj)
        end
    end
end,
["CardboardRoom"] = function()
    print("Running CardboardRoom action")

    local cardboardRoom = Workspace:WaitForChild("CardboardRoom")
    local build = cardboardRoom:WaitForChild("Build")
    local doors = build:WaitForChild("Doors")

    for _, descendant in ipairs(doors:GetDescendants()) do
        if descendant:IsA("ClickDetector") and fireclickdetector then
            fireclickdetector(descendant)
        end
    end
end,
["InfectionApartment"] = function()
    print("Running InfectionApartment action")
    local Players = game:GetService("Players")
    local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local powerBoxes = workspace:WaitForChild("InfectionApartment")
        :WaitForChild("Immune")
        :WaitForChild("PowerBoxes")
    local boxes = powerBoxes:GetChildren()
    for i = 1, #boxes do
        local child = boxes[i]
        local valve = child and child:FindFirstChild("Valve")
        if valve then
            local availableIcon = valve:FindFirstChild("AvaliableIcon")
            if availableIcon and availableIcon.Enabled == true then
                local valvePrompt = valve:FindFirstChild("ValvePrompt")
                local prompt = valvePrompt and valvePrompt:FindFirstChildOfClass("ProximityPrompt")
                if prompt and fireproximityprompt then
                    hrp.CFrame = valve.CFrame * CFrame.new(0, 0, -3)
                    task.wait(0.25)
                    fireproximityprompt(prompt)
                    task.wait(0.2)
                    return
                end
            end
        end
    end
end,
["MozellesCastle"] = function()
    print("Running MozellesCastle action")
    r()
end,
["HotelFloor6"] = function()
    print("Running HotelFloor6 action")
    r()
end,
["ColorTheTiles"] = function()
    print("Running ColorTheTiles action")
    r()
end,
}