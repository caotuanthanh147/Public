local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local userId = tostring(localPlayer.UserId)
local function writeStatus(status)
    local data = { status = status, timestamp = os.time() }
    local jsonText = HttpService:JSONEncode(data)
    writefile(userId .. ".status", jsonText)
end
spawn(function()
    while true do
        wait(30) 
        local playerStillExists = false
        for _, player in pairs(Players:GetPlayers()) do
            if player == localPlayer then
                playerStillExists = true
                break
            end
        end
        if not playerStillExists then
            writeStatus("disconnected")
            break 
        end
    end
end)
writeStatus("online")
spawn(function()
    while true do
        wait(30)
        writeStatus("online")
    end
end)
if game:IsA("DataModel") then
    game:BindToClose(function()
        writeStatus("disconnected")
    end)
end