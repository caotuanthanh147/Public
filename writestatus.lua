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
    local success1, errorTitle = pcall(function()
        return CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.TitleFrame.ErrorTitle
    end)
    local success2, errorMessage = pcall(function()
        return CoreGui.RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage
    end)
    if success1 and errorTitle then
        local isDefault = false
        for _, defaultText in ipairs(DEFAULT_TEXTS) do
            if errorTitle.Text == defaultText then
                isDefault = true
                break
            end
        end
        if not isDefault then
            return true
        end
    end
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
        if checkDisconnect() then
            writeStatus("disconnected")
            running = false
        end
    end
end
task.spawn(function()
    while running do
        local hasError = checkDisconnect()
        if hasError then
            markDisconnected()
            break
        end
        task.wait(0.5)
    end
end)
CoreGui.DescendantAdded:Connect(function(descendant)
    if not running then return end
    local fullName = descendant:GetFullName()
    if string.find(fullName, "ErrorTitle") or string.find(fullName, "ErrorMessage") then
        task.wait(0.1)
        local hasError = checkDisconnect()
        if hasError then
            markDisconnected()
        end
    end
end)
writeStatus("online")
while running do
    writeStatus("online")
    task.wait(15) 
end