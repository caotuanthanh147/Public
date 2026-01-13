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
local function markDisconnected()
    if running then
        writeStatus("disconnected")
        running = false
        if parentConn then
            parentConn:Disconnect()
        end
    end
end
CoreGui.DescendantAdded:Connect(function(o)
    if not running then return end
    if o.Name == "ErrorPrompt" then
        markDisconnected()
    end
end)
writeStatus("online")
while running do
    writeStatus("online")
    task.wait(15)
end