_G.ResetEnabled = true
local coinFarm = true
local CoinFails = {}      
local Blacklisted = {}    
local function isValidCoin(obj)
    return obj
        and obj.Parent
        and obj:IsA("MeshPart")
        and obj:FindFirstChild("ProjectileHitTrigger")
end
local function getCoins()
    local coins = {}
    local added = {}
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant.Name == "Coins" then
            for _, coin in pairs(descendant:GetChildren()) do
                if isValidCoin(coin) and not added[coin] and not Blacklisted[coin] then
                    table.insert(coins, coin)
                    added[coin] = true
                end
            end
        end
        if descendant:IsA("MeshPart")
            and descendant.Name:lower() == "coin"
            and descendant:FindFirstChild("ProjectileHitTrigger")
            and not added[descendant]
            and not Blacklisted[descendant]
        then
            table.insert(coins, descendant)
            added[descendant] = true
        end
    end
    return coins
end
local function coinsRemaining()
    return #getCoins() > 0
end
local function collectCoins()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    repeat
        local coins = getCoins()
        for _, coin in pairs(coins) do
            if isValidCoin(coin) and not Blacklisted[coin] then
                local existedBefore = coin.Parent ~= nil
                hrp.CFrame = coin.CFrame
                task.wait(0.25)
                if existedBefore and coin.Parent ~= nil then
                    CoinFails[coin] = (CoinFails[coin] or 0) + 1
                    if CoinFails[coin] >= 10 then
                        Blacklisted[coin] = true
                    end
                else
                    CoinFails[coin] = nil
                end
            end
        end
    until not coinsRemaining()
    local roof = workspace:FindFirstChild("Elevator")
        and workspace.Elevator:FindFirstChild("Roof")
    if roof then
        hrp.CFrame = roof.CFrame + Vector3.new(0, 5, 0)
    end
end
local localPlayer = game:GetService("Players").LocalPlayer
function inLob()
    local success, result = pcall(function()
        local lobby = workspace:WaitForChild("Lobby", 0.5)
        if not lobby then return nil end
        local centerLobby = lobby:WaitForChild("CenterLobby", 0.5)
        if not centerLobby then return nil end
        local props = centerLobby:WaitForChild("Props", 0.5)
        if not props then return nil end
        local painting = props:WaitForChild("MagicPainting", 0.5)
        return painting
    end)
    return success and result ~= nil
end
local function isDead()
    local success, result = pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        local deathScreen = playerGui:WaitForChild("DeathScreen")
        return deathScreen.Enabled
    end)
    return success and result == true
end
local function start()
    game:GetService("ReplicatedStorage").RE.PutInElevator:FireServer()
end
local function respawn()
    game:GetService("ReplicatedStorage").RE.Respawn:FireServer()
end
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
task.spawn(function()
    while task.wait(3) do
        if inLob() then
            start()
        end
    end
end)
task.spawn(function()
    while task.wait(3) do
        if isDead() then
            respawn()
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(1)
        if coinFarm and coinsRemaining() then
            collectCoins()
        end
    end
end)
local Players = game:GetService("Players")
local elevator = workspace:WaitForChild("Elevator")
local FloorActions = loadstring(game:HttpGet("https://raw.githubusercontent.com/caotuanthanh147/Public/refs/heads/main/floor1-50(test).lua"))()
local function safeCall(fn)
    task.spawn(function()
        local ok, err = pcall(fn)
        if not ok then
            warn("Floor action error:", err)
        end
    end)
end
local function getFloor()
    local currentRoom = workspace.Values.CurrentRoom.Value
    if currentRoom and currentRoom ~= elevator then
        local floorName = currentRoom.Name
        print("Floor found:", floorName)
        task.wait(3)
        if coinFarm then
            collectCoins()
        end
        while coinFarm and coinsRemaining() do
            task.wait(1)
        end
        local action = FloorActions[floorName]
        if action then
            while workspace.Values.CurrentRoom.Value == currentRoom do
                safeCall(action)
                task.wait(0.5) 
            end
        else
            print("No script or rest/shop/intermission for:", floorName)
        end
    end
end
getFloor()
workspace.Values.CurrentRoom:GetPropertyChangedSignal("Value"):Connect(function()
    task.wait(0.1)
    getFloor()
end)