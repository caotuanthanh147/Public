local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local localPlayer = Players.LocalPlayer
local USER_ID = tostring(localPlayer.UserId)
local STATUS_FILE = USER_ID .. ".status"
local running = true
local DEFAULT_TEXTS = {"Warning", "Label", ""}
local function writeStatus(status)
    if not running then return end
    writefile(
        STATUS_FILE,
        HttpService:JSONEncode({
            status = status,
            timestamp = os.time()
        })
    )
end
local function checkDisconnect()
    local success2, errorMessage = pcall(function()
        return CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage
    end)
    if success2 and errorMessage then
        local isDefault = false
        for _, defaultText in ipairs(DEFAULT_TEXTS) do
            if errorMessage.Text == defaultText then
                isDefault = true
                break
            end
        end
        if not isDefault then
            return true
        end
    end
    return false
end
local function markDisconnected()
    if running then
        task.wait(5)
        if checkDisconnect() then
            task.wait(5)
            writeStatus("disconnected")
            running = false
            task.wait(5)
        end
    end
end
writeStatus("online")
while running and task.wait(15) do
    local hasError = checkDisconnect()
    if hasError then
        markDisconnected()
        break
    end
    writeStatus("online")
    task.wait(15)
end