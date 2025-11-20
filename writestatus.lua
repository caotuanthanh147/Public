local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local userId = tostring(Players.LocalPlayer.UserId)
local function writeStatus(status)
    local data = { status = status, timestamp = os.time() }
    local jsonText = HttpService:JSONEncode(data)
        writefile(userId .. ".status", jsonText)
end
writeStatus("online")
spawn(function()
    while true do
        wait(15)  
        writeStatus("online")
    end
end)
if game:IsA("DataModel") then
    game:BindToClose(function()
        writeStatus("disconnected")
    end)
end