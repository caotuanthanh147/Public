local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local USER_ID = tostring(localPlayer.UserId)
local STATUS_FILE = USER_ID .. ".status"
local function writeStatus(status)
    writefile(
        STATUS_FILE,
        HttpService:JSONEncode({
            status = status,
            timestamp = os.time()
        })
    )
end
writeStatus("online")