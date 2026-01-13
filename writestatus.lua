local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local USER_ID = tostring(localPlayer.UserId)
local STATUS_FILE = USER_ID .. ".status"
local running = true
local lastStatus = nil
local parentConn 
local CODES = {"264","273","279","266","277"}
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
            parentConn = nil
        end
    end
end
parentConn = CoreGui.DescendantAdded:Connect(function(o)
    if not running then return end
    if o.Name == "ErrorPrompt" then
        local function hasCodeInText(obj)
            local ok, txt = pcall(function() return obj.Text end)
            if ok and type(txt) == "string" then
                for _, code in ipairs(CODES) do
                    if string.find(txt, code, 1, true) then
                        return true
                    end
                end
            end
            return false
        end
        if hasCodeInText(o) then
            markDisconnected()
            return
        end
        for _, v in ipairs(o:GetDescendants()) do
            if hasCodeInText(v) then
                markDisconnected()
                return
            end
        end
    end
end)
writeStatus("online")
while running do
    writeStatus("online")
    task.wait(15)
end