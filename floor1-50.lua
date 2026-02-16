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
local function findTouchTransmittersForTarget(targetName)
    local matches = {}
    local total = 0
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("TouchTransmitter") then
            total = total + 1
            local parentName = (descendant.Parent and descendant.Parent.Name) or ""
            if (not targetName) or descendant.Name == targetName or parentName == targetName then
                local part = descendant:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    table.insert(matches, {transmitter = descendant, part = part})
                end
            end
        end
    end
    return matches, total
end
local function touchTransmitter(targetName, opts)
    opts = opts or {}
    local maxWait = opts.maxWait or 5           
    local interval = opts.interval or 0.15      
    local hrpTimeout = opts.hrpTimeout or 3
    local root = getLocalHRP(hrpTimeout)
    if not root then
        warn("touchTransmitter: no HumanoidRootPart for LocalPlayer")
        return
    end
    local elapsed = 0
    local lastTotal = 0
    while elapsed <= maxWait do
        local matches, total = findTouchTransmittersForTarget(targetName)
        lastTotal = total
        if #matches > 0 then
            print(("TouchTransmitter found for target: %s (matches=%d, scanned=%d)"):format(tostring(targetName), #matches, total))
            for _, entry in ipairs(matches) do
                local part = entry.part
                local ok, err = pcall(function()
                    if firetouchinterest then
                        firetouchinterest(part, root, 1)
                        task.wait()
                        firetouchinterest(part, root, 0)
                    else
                        local ok2, orig = pcall(function() return part.CFrame end)
                        if ok2 then
                            local origCF = orig
                            part.CFrame = root.CFrame
                            task.wait(0.05)
                            part.CFrame = origCF
                        end
                    end
                end)
                if not ok then
                    warn("touchTransmitter: fire error for part", part and part:GetFullName() or "unknown", "-", err)
                end
                task.wait(0.05) 
            end
            return true
        end
        task.wait(interval)
        elapsed = elapsed + interval
    end
    warn(("touchTransmitter: no matching TouchTransmitter for target '%s' after %.2fs (scanned %d transmitters)"):format(tostring(targetName), maxWait, lastTotal))
    return false
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
}