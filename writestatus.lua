local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local userId = tostring(localPlayer.UserId)
local isActive = true
Players.PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        isActive = false
    end
end)
local parentConn = localPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if not localPlayer.Parent then
        isActive = false
        parentConn:Disconnect()
    end
end)
local function writeStatus(status)
    local data = { status = status, timestamp = os.time() }
    local success, jsonText = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if success then
        pcall(function()
            writefile(userId .. ".status", jsonText)
        end)
    end
end
writeStatus("online")
while isActive do
    wait(30)
    writeStatus("online")
end
