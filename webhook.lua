local plr = game:GetService("Players")
local rs = game:GetService("RunService")
local cgui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local memoryThresh = 1200
local memoryEnabled = false
local memoryConnection
local webhookURL = "https://discord.com/api/webhooks/1366639235188133999/n_z3dLMYFqUTrimhI3s_HZNFWfcX9GDh0nTVOzvWkQ9DBkHCgtDaAiUJBQv4KggFTUxe"
local userID = "479476519308099585"
local playerName = Players.LocalPlayer.Name
local enablePing = false
local joinTime = os.time()
local function shouldDisableRendering()
    if #Settings.NoRender == 0 then
        return false
    end
    local current = game.PlaceId
    for _, id in ipairs(Settings.NoRender) do
        if id == current then
            return true
        end
    end
    return false
end
local function toggleMemoryMonitoring(state)
    memoryEnabled = state
    if not memoryEnabled then
        rs:Set3dRenderingEnabled(true)
        if memoryConnection then
            memoryConnection:Disconnect()
            memoryConnection = nil
        end
        return
    end
    local ps = cgui:WaitForChild("RobloxGui"):WaitForChild("PerformanceStats")
    for _, b in pairs(ps:GetDescendants()) do
        if b:IsA("TextButton") and b.Name == "PS_Button" then
            local tp = b:FindFirstChild("StatsMiniTextPanelClass")
            local tl = tp and tp:FindFirstChild("TitleLabel")
            if tl and string.find(tl.Text:lower(), "mem") then
                local v = tp:FindFirstChild("ValueLabel")
                if v then
                    memoryConnection = v:GetPropertyChangedSignal("Text"):Connect(function()
                        if not memoryEnabled or not v or not v.Parent then return end
                        local memValue = tonumber(v.Text:match("%d+%.?%d*"))
                        if memValue and memValue > memoryThresh then
                            rs:Set3dRenderingEnabled(true)
                            task.delay(1, function()
                                if shouldDisableRendering() and memoryEnabled then
                                    rs:Set3dRenderingEnabled(false)
                                end
                            end)
                        end
                    end)
                end
                break
            end
        end
    end
end
local function SendHeartbeat()
    local elapsedSeconds = os.time() - joinTime
    local hours = math.floor(elapsedSeconds / 3600)
    local minutes = math.floor((elapsedSeconds % 3600) / 60)
    local pingPart = enablePing and ("<@" .. userID .. "> ") or ""
    local timeString
    if hours > 0 then
        timeString = string.format("%d hour%s and %d minute%s",
            hours, hours == 1 and "" or "s",
            minutes, minutes == 1 and "" or "s")
    else
        timeString = string.format("%d minute%s",
            minutes, minutes == 1 and "" or "s")
    end
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(playerList, player.Name)
    end
    local playerNamesText = ""
    for i, name in ipairs(playerList) do
        playerNamesText = playerNamesText .. string.format("%d. %s\n", i, name)
    end
    local message = string.format(
        "%sPlayer %s has been in the server for %s\n\nPlayers in Server (%d):\n%s",
        pingPart,
        playerName,
        timeString,
        #playerList,
        playerNamesText
    )
    local success, err = pcall(function()
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({content = message})
        })
    end)
    if not success then
        warn("Failed to send heartbeat:", err)
    end
end
if shouldDisableRendering() then
    rs:Set3dRenderingEnabled(false)
    task.spawn(function()
        task.wait(2) 
        toggleMemoryMonitoring(true)
    end)
end
SendHeartbeat()
task.spawn(function()
    while true do
        task.wait(600)
        SendHeartbeat()
    end
end)
