local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local USER_ID = tostring(localPlayer.UserId)
local MAIN_FILE = USER_ID .. ".main"
local function writeMainFile()
    writefile(
        MAIN_FILE,
        HttpService:JSONEncode({
            status = "online",
            timestamp = os.time()
        })
    )
end
writeMainFile()