local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local lp = game:GetService("Players").LocalPlayer
local noCollisionConnection = nil
_G.GASA4CanSteal = _G.GASA4CanSteal or false
_G.GASA4ListenerSet = _G.GASA4ListenerSet or false
local function setupGASA4Listener()
    if _G.GASA4ListenerSet then return end
    _G.GASA4ListenerSet = true
    local stateEvent = workspace:WaitForChild("GASA4")
        :WaitForChild("RoomScript")
        :WaitForChild("StateChange")
    stateEvent.OnClientEvent:Connect(function(state)
        _G.GASA4CanSteal = (state == true)
        print("[GASA4] CanSteal =", _G.GASA4CanSteal)
    end)
end
local function touchPart(part, root)
    if not part or not part:IsA("BasePart") then return end
    if not root or not root:IsA("BasePart") then return end
    if firetouchinterest then
        firetouchinterest(part, root, 1)
        task.wait()
        firetouchinterest(part, root, 0)
    end
end
local function enableNoCollision()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanTouch = false
        end
    end
    noCollisionConnection = workspace.DescendantAdded:Connect(function(obj)
        if obj:IsA("BasePart") then
            obj.CanTouch = false
        end
    end)
end
local function disableNoCollision()
    if noCollisionConnection then
        noCollisionConnection:Disconnect()
        noCollisionConnection = nil
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanTouch = true
        end
    end
end
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
        fireTouchInterests("Winner")
    end,
    ["StanelyRoom"] = function()
        fireTouchInterests("EndTouch")
    end,
    ["Splitsville_Wipeout"] = function()
        fireTouchInterests("EndCheckpoint")
    end,
    ["Obby"] = function()
        fireTouchInterests("EndPart")
    end,
    ["IntenseObby"] = function()
        fireTouchInterests("ENDBLOCK")
    end,
    ["FindThePath"] = function()
        fireTouchInterests("win_zone")
    end,
    ["GASA4"] = function()
        fireTouchInterests("ExtractionBox")
    end,
    ["Minefield"] = function()
        fireTouchInterests("WinPart")
    end,
    ["WhoKilledYouObby"] = function()
        fireTouchInterests("WinPart")
    end,
    ["GumballMachine"] = function()
        fireTouchInterests("WinPart")
    end,
    ["3008_Room"] = function()
        fireClickDetectors("Lampert")
    end,
    ["Superhighway"] = function()
        fireTouchInterests("WinPoint")
    end,
    ["SuperDropper"] = function()
        fireTouchInterests("WinPool")
        task.wait(0.5)
        fireTouchInterests("ReturnPortal")
    end,
    ["RandomMazeWindows"] = function()
        fireTouchInterests("Build")
    end,
["Jeremy"] = function()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local jeremy = workspace:WaitForChild("Jeremy")
    local build = jeremy:WaitForChild("Build")
    local button = build:WaitForChild("Button")
    local clicker = button:WaitForChild("Clicker")
    root.CFrame = clicker.CFrame * CFrame.new(0, 0.5, 0)
end,
    ["BrokenSchool"] = function()
        teleportToTarget("Roof", 3)
    end,
    ["SnowySlope"] = function()
        fireTouchInterests("WinPart")
    end,
["Forest_TwoStudCamp"] = function()
    local root = getLocalHRP()
    if not root then return end
    local build = workspace:WaitForChild("Forest_TwoStudCamp"):WaitForChild("Build")
    local firewoodFolder = build:WaitForChild("Firewood")
    local firePrompt = firewoodFolder:FindFirstChildWhichIsA("ProximityPrompt", true)
    if firePrompt and firePrompt.Enabled and firePrompt.Parent and firePrompt.Parent:IsA("BasePart") then
        root.CFrame = firePrompt.Parent.CFrame * CFrame.new(0, 0, -3)
        task.wait(0.175)
        if fireproximityprompt then
            fireproximityprompt(firePrompt)
        end
        task.wait(0.25)
    end
    local cauldronPart = build:WaitForChild("Cauldron"):WaitForChild("PromptPart")
    local cauldronPrompt = cauldronPart:FindFirstChildWhichIsA("ProximityPrompt", true)
    if cauldronPrompt and cauldronPrompt.Enabled then
        root.CFrame = cauldronPart.CFrame * CFrame.new(0, 0, -3)
        task.wait(0.175)
        if fireproximityprompt then
            fireproximityprompt(cauldronPrompt)
        end
        task.wait(0.25)
    end
end,
    ["FunnyMaze"] = function()
        local finalNotes = Workspace.FunnyMaze.Build.FinalNotes
        for _, child in pairs(finalNotes:GetChildren()) do
            local detector = child:FindFirstChildOfClass("ClickDetector")
            if detector and fireclickdetector then
                fireclickdetector(detector)
                task.wait(0.05)
            end
        end
    end,
["UES"] = function()
    fireProximityPrompts("cardboard_box", 3)
    task.wait(4)
end,
["ButtonCompetition"] = function()
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
    local root = getLocalHRP()
    if not root then return end
    local leversFolder = workspace:WaitForChild("ElevatorShaft")
        :WaitForChild("Build")
        :WaitForChild("Levers")
    for _, obj in pairs(leversFolder:GetDescendants()) do
        if obj.Name == "ClickPart" and obj:IsA("BasePart") then
            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled == true then
                root.CFrame = obj.CFrame
                if fireproximityprompt then
                    fireproximityprompt(prompt, 1)
                end
                task.wait(1)
                return
            end
        end
    end
end,
["SurvivalTheArea51"] = function()
    local root = getLocalHRP()
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
        fireTouchInterests("EndCheckpoint")
    end,
    ["Normal_Dance"] = function()
        r()
    end,
    ["SLIDE_9999999999_FEET_DOWN_RAINBOW"] = function()
        fireTouchInterests("MiddleRing")
    end,
    ["CliffsideChaos"] = function()
        teleportToTarget("Roof", 3)
    end,
["bugbo"] = function()
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
        r()
    end,
    ["SuspiciouslyLongRoom"] = function()
        fireTouchInterests("WinPool")
    end,
    ["TeapotDodgeball"] = function()
        fireTouchInterests("Finish")
        task.wait(0.5)
end,
["SlimYim"] = function()
    r()
end,
["JermpopFactory"] = function()
    local hrp = getLocalHRP()
    local cleanupButtons = workspace:WaitForChild("JermpopFactory")
        :WaitForChild("Build")
        :WaitForChild("CleanupButtons")
    local fired = {}
    for _, obj in ipairs(cleanupButtons:GetDescendants()) do
        local prim = obj:FindFirstChild("Prim")
        if prim and prim:IsA("BasePart") then
            local prompt = prim:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and prompt.Enabled == true and not fired[prompt] then
                fired[prompt] = true
                hrp.CFrame = prim.CFrame * CFrame.new(0, 3, 0)
                task.wait(0.25)
                if fireproximityprompt then
                    fireproximityprompt(prompt)
                end
                break
            end
        end
        task.wait(0.05)
    end
end,
["RedBallTemple"] = function()
    r()
end,
["RedballDiner"] = function()
    r()
end,
["OldRobloxHouse"] = function()
    r()
end,
["PetCaptureDeluxe"] = function()
    local Players = game:GetService("Players")
    local activeMonsters =
        Workspace:WaitForChild("PetCaptureDeluxe")
            :WaitForChild("Build")
            :WaitForChild("ActiveMonsters")
    if activeMonsters then
        local descendant = activeMonsters:FindFirstChildWhichIsA("ProximityPrompt", true)
        if descendant and fireproximityprompt then
            local part = descendant.Parent
            if part then
                local hrp = getLocalHRP()
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
    fireTouchInterests("END")
end,
["THEROCK"] = function()
end,
["ElevatorInsideAx5"] = function()
    r()
end,
["FunTimesAtSquishyFlood"] = function()
    task.wait(20)
    local root = getLocalHRP(3)
    local tar = workspace:WaitForChild("FunTimesAtSquishyFlood")
        :WaitForChild("Build")
        :WaitForChild("Winparts")
    for _, obj in pairs(tar:GetDescendants()) do
        if obj:IsA("TouchTransmitter") then
            local part = obj.Parent
            touchPart(part, root)
            task.wait(0.05)
        end
    end
end,
["PizzaDelivery"] = function()
    local root = getLocalHRP(3)
    if not root then return end
    local build = workspace:WaitForChild("PizzaDelivery"):WaitForChild("Build")
    local pizzaBoxesFolder = build:WaitForChild("PizzaBoxes")
    local pizzaDoorsFolder = build:WaitForChild("PizzaDoors")
    for _, pizza in pairs(pizzaBoxesFolder:GetChildren()) do
        if pizza:IsA("BasePart") and pizza:FindFirstChild("TouchInterest") then
            touchPart(pizza, root)
            task.wait(0.02)
        end
    end
    for _, door in pairs(pizzaDoorsFolder:GetDescendants()) do
        if door:IsA("BasePart") and door:FindFirstChild("TouchInterest") then
            touchPart(door, root)
            task.wait(0.02)
        end
    end
end,
["Birthday"] = function()
    local destructibles = workspace:WaitForChild("Birthday")
        :WaitForChild("Build")
        :WaitForChild("destructible")
    for _, obj in pairs(destructibles:GetDescendants()) do
        if obj:IsA("ClickDetector") and fireclickdetector then
            fireclickdetector(obj)
        end
    end
end,
["CardboardRoom"] = function()
    local cardboardRoom = Workspace:WaitForChild("CardboardRoom")
    local build = cardboardRoom:WaitForChild("Build")
    local doors = build:WaitForChild("Doors")
    for _, descendant in pairs(doors:GetDescendants()) do
        if descendant:IsA("ClickDetector") and fireclickdetector then
            fireclickdetector(descendant)
        end
    end
end,
["InfectionApartment"] = function()
    local Players = game:GetService("Players")
    local hrp = getLocalHRP(1)
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
    r()
end,
["HotelFloor6"] = function()
    r()
end,
["ColorTheTiles"] = function()
    r()
end,
["FourCorners"] = function()
    r()
end,
["FloodFillMine"] = function()
    local hrp = getLocalHRP(1)
    if not hrp then return end
    local area = workspace:WaitForChild("FloodFillMine")
    local build = area:WaitForChild("Build")
    local blocksFolder = build:WaitForChild("Blocks")
    local currentRoom = workspace:WaitForChild("Values"):WaitForChild("CurrentRoom").Value
    local breakRemote = currentRoom:WaitForChild("BreakBlock")
    local blocks = blocksFolder:GetChildren()
    local brokeAny = false
    for i = 1, #blocks do
        local block = blocks[i]
        if block and block:IsA("BasePart") and block.Name == "CoinBlock" then
            brokeAny = true
            hrp.CFrame = block.CFrame * CFrame.new(0, 3, 0)
            task.wait(0.08)
            breakRemote:FireServer(block.Position)
            task.wait(0.12)
        end
    end
    if not brokeAny then
        if fireTouchInterests then
            fireTouchInterests("Bubble")
        end
    end
end,
["KnowledgeOffice"] = function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local knowledgeOffice = workspace:WaitForChild("KnowledgeOffice")
    local build = knowledgeOffice:WaitForChild("Build")
    local folder = build:WaitForChild("Folder")
    local targetBoard = nil
    local targetPrompt = nil
    for _, obj in pairs(folder:GetDescendants()) do
        if obj.Name == "ProblemBoard" then
            local pp = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            if pp then
                targetBoard = obj
                targetPrompt = pp
                break
            end
        end
    end
    if not targetBoard or not targetPrompt then return end
    if fireproximityprompt then
        fireproximityprompt(targetPrompt)
    end
    task.wait(1)
    local playerGui = lp:WaitForChild("PlayerGui")
    local floorGui = playerGui:WaitForChild("FloorGUI")
    local qFrameOuter = floorGui:WaitForChild("QuestionFrame")
    local qFrameInner = qFrameOuter:WaitForChild("QuestionFrame")
    local questionLabel = qFrameInner:WaitForChild("Question")
        :WaitForChild("TextLabel")
    local questionText = questionLabel.Text
    if not questionText or questionText == "" then return end
    local function solveArithmetic(expr)
        expr = tostring(expr)
        expr = expr:gsub("%s+", "")
        expr = expr:gsub("=", "")
        expr = expr:gsub("×", "*"):gsub("x", "*"):gsub("X", "*")
        expr = expr:gsub("÷", "/")
        if expr:find("[^%d%+%-%*/%(%).]") then
            return nil
        end
        local ok, result = pcall(function()
            return loadstring("return " .. expr)()
        end)
        if not ok or result == nil then return nil end
        if math.abs(result - math.floor(result)) < 1e-9 then
            return tostring(math.floor(result))
        end
        return tostring(result)
    end
    local answer = solveArithmetic(questionText)
    if not answer then return end
    local checkAnswer = knowledgeOffice:WaitForChild("CheckAnswer")
    checkAnswer:InvokeServer(targetBoard, answer)
end,
["TNTRun"] = function()
    r()
end,
["GASA4"] = function()
    setupGASA4Listener()
    if not _G.GASA4CanSteal then
        return
    end
    local root = getLocalHRP(3)
    if not root then return end
    local build = workspace:WaitForChild("GASA4"):WaitForChild("Build")
    local collectables = build:WaitForChild("Collectables")
    local stealables = build:WaitForChild("Stealables")
    local extractionBox = build:WaitForChild("ExtractionBox")
    local function doPrompt(part)
        if not part or not part:IsA("BasePart") then return false end
        local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
        if not prompt or not prompt.Enabled then return false end
        if not fireproximityprompt then return false end
        root.CFrame = part.CFrame * CFrame.new(0, 0, -3)
        task.wait(0.175)
        fireproximityprompt(prompt)
        print("doPrompt called on:", part:GetFullName())
        task.wait()
        return true
    end
    for _, item in ipairs(collectables:GetChildren()) do
        local part = item:FindFirstChildWhichIsA("BasePart")
        if part and doPrompt(part) then
            touchPart(extractionBox, root)
            return
        end
    end
    for _, item in ipairs(stealables:GetChildren()) do
        local part = item:FindFirstChild("ThingButton")
        if part and part:IsA("BasePart") and doPrompt(part) then
            touchPart(extractionBox, root)
            return
        end
    end
end,
}