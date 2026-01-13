local webhookURL = "https://discord.com/api/webhooks/1366639235188133999/n_z3dLMYFqUTrimhI3s_HZNFWfcX9GDh0nTVOzvWkQ9DBkHCgtDaAiUJBQv4KggFTUxe"
local userID = "479476519308099585"
local playerName = game:GetService("Players").LocalPlayer.Name
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
    local players = game:GetService("Players")
    local playerList = {}
    for _, player in ipairs(players:GetPlayers()) do
        table.insert(playerList, player.Name)
    end
    local playerTable = {
        serverTime = os.time(),
        playerCount = #playerList,
        players = playerList
    }
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
    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode({content = message})
    })
end
local rs = game:GetService("RunService")
if shouldDisableRendering() then
    rs:Set3dRenderingEnabled(false)
end
SendHeartbeat()
while true do
    task.wait(600)
    SendHeartbeat()
end