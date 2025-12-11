local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local userId = tostring(localPlayer.UserId)
local function isPlayerValid()
    return localPlayer and localPlayer.Parent and Players:FindFirstChild(localPlayer.Name) ~= nil
end
local function writeOnlineStatus()
    local data = { 
        status = "online", 
        timestamp = os.time()
    }
    local success, jsonText = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if success then
        pcall(function()
            writefile(userId .. ".status", jsonText)
        end)
    end
end
writeOnlineStatus()
while isPlayerValid() do
    wait(30)
    writeOnlineStatus()
end
