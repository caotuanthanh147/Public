local webhookURL = "https://discord.com/api/webhooks/1366639235188133999/n_z3dLMYFqUTrimhI3s_HZNFWfcX9GDh0nTVOzvWkQ9DBkHCgtDaAiUJBQv4KggFTUxe"
local userID = "479476519308099585"
local playerName = game:GetService("Players").LocalPlayer.Name
local enablePing = true
local searchCollection = workspace.Entities
local notifiedEntities = {}
local function CheckForHighRarity()
    for _, entity in ipairs(searchCollection:GetChildren()) do
        local rarityValue = entity:FindFirstChild("Rarity")
        if rarityValue and rarityValue.Value > 4000000 then
            if not notifiedEntities[entity] then
                local pingPart = enablePing and ("<@" .. userID .. "> ") or ""
                local message = string.format(
                    "%sPlayer **%s** found a sans with rarity **%d**",
                    pingPart,
                    playerName,
                    rarityValue.Value
                )
                request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = game:GetService("HttpService"):JSONEncode({content = message})
                })
                notifiedEntities[entity] = true
                entity.AncestryChanged:Connect(function()
                    if not entity.Parent then
                        notifiedEntities[entity] = nil
                    end
                end)
            end
        end
    end
end
while true do
    task.wait(5) 
    CheckForHighRarity()
end