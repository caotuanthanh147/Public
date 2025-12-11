local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")  
local localPlayer = Players.LocalPlayer
local userId = tostring(localPlayer.UserId)
local scriptActive = true
local cleanupConnections = {}
local function writeStatus(status)
    if not scriptActive then
        return  
    end
    if not localPlayer or not localPlayer.Parent then
        scriptActive = false
        return
    end
    local success, errorMessage = pcall(function()
        local data = { 
            status = status, 
            timestamp = os.time(),
            userId = userId
        }
        local jsonText = HttpService:JSONEncode(data)
        writefile(userId .. ".status", jsonText)
    end)
    if not success then
        warn("[Status Monitor] Failed to write status:", errorMessage)
    end
end
local function monitorPlayerExistence()
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
        if player == localPlayer then
            scriptActive = false
            writeStatus("disconnected")
            for _, connection in pairs(cleanupConnections) do
                connection:Disconnect()
            end
        end
    end)
    table.insert(cleanupConnections, playerRemovingConnection)
    local heartbeatConnection = RunService.Heartbeat:Connect(function()
        if not scriptActive then
            heartbeatConnection:Disconnect()
            return
        end
        if not localPlayer or not localPlayer.Parent then
            scriptActive = false
            writeStatus("disconnected")
            heartbeatConnection:Disconnect()
            playerRemovingConnection:Disconnect()
            return
        end
        local playerStillExists = false
        for _, player in pairs(Players:GetPlayers()) do
            if player == localPlayer then
                playerStillExists = true
                break
            end
        end
        if not playerStillExists then
            scriptActive = false
            writeStatus("disconnected")
            heartbeatConnection:Disconnect()
            playerRemovingConnection:Disconnect()
        end
    end)
    table.insert(cleanupConnections, heartbeatConnection)
end
local function mainStatusLoop()
    writeStatus("online")
    monitorPlayerExistence()
    local lastStatusUpdate = os.time()
    while scriptActive do
        local currentTime = os.time()
        if currentTime - lastStatusUpdate >= 30 then
            writeStatus("online")
            lastStatusUpdate = currentTime
        end
        wait(1)  
        if not localPlayer or not localPlayer.Parent then
            scriptActive = false
            writeStatus("disconnected")
            break
        end
    end
    writeStatus("disconnected")
    for _, connection in pairs(cleanupConnections) do
        pcall(function() connection:Disconnect() end)
    end
end
if game:IsA("DataModel") then
    game:BindToClose(function()
        scriptActive = false
        writeStatus("disconnected")
        wait(0.5)
    end)
end
local success, err = pcall(function()
    mainStatusLoop()
end)
if not success then
    warn("[Status Monitor] Script encountered an error:", err)
    pcall(function()
        writeStatus("disconnected")
    end)
end