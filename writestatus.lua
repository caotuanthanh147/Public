local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local USER_ID = tostring(localPlayer.UserId)
local STATUS_FILE = USER_ID .. ".status"
local running = true
local lastStatus = nil
local function writeStatus(status)
    if not running then return end
    lastStatus = status
    writefile(
        STATUS_FILE,
        HttpService:JSONEncode({
            status = status,
            timestamp = os.time()
        })
    )
end
local parentConn
parentConn = localPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if not localPlayer.Parent then
        running = false
        parentConn:Disconnect()
    end
end)
Players.PlayerRemoving:Connect(function(p)
    if p == localPlayer then
        running = false
    end
end)
local function markDisconnected()
    if running then
        writeStatus("disconnected")
        running = false
        if parentConn then
            parentConn:Disconnect()
        end
    end
end
task.spawn(function()
    while running do
        local rg = CoreGui:FindFirstChild("RobloxPromptGui")
        if rg then
            local overlay = rg:FindFirstChild("promptOverlay")
            if overlay then
                local err = overlay:FindFirstChild("ErrorPrompt")
                if err then
                    markDisconnected()
                    break
                end
            end
        end
        task.wait(0.1)
    end
end)
CoreGui.DescendantAdded:Connect(function(o)
    if not running then return end
    if o.Name == "ErrorPrompt" then
        markDisconnected()
    end
end)
writeStatus("online")
while running do
    if not localPlayer or not localPlayer.Parent then
        running = false
        break
    end
    writeStatus("online")
    task.wait(15)
end