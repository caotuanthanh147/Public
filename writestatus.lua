local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
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
local function requestPostDecoded(url, body)
    if not running then return nil end
    local res = HttpService:RequestAsync({
        Url = url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(body)
    })
    if not running or not res or not res.Success or not res.Body then
        return nil
    end
    return HttpService:JSONDecode(res.Body)
end
local function getPresence()
    if not running then return nil end
    local body = { userIds = { tonumber(USER_ID) } }
    local data =
        requestPostDecoded("https://presence.roblox.com/v1/presence/users", body)
        or requestPostDecoded("https://presence.roproxy.com/v1/presence/users", body)
    if data and data.userPresences and data.userPresences[1] then
        return data.userPresences[1].userPresenceType
    end
    return nil
end
local function presenceToLabel(p)
    if p == 0 then return "disconnected" end
    if p == 1 or p == 2 or p == 3 then return "online" end
end
writeStatus("online")
task.spawn(function()
    while running do
        if not localPlayer or not localPlayer.Parent then
            running = false
            break
        end
        local presence = getPresence()
        if not running then break end
        if presence ~= nil then
            local label = presenceToLabel(presence)
            if label then
                writeStatus(label)
            end
        end
        task.wait(1)
    end
end)