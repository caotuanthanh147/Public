do
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local yOffsetDp = 30
    local xOffsetDp = 5
    local function getInsaneButton()
        local pg = localPlayer and localPlayer:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local visibilityRestrict = pg:FindFirstChild("VisibilityRestrict")
        if not visibilityRestrict then return nil end
        return visibilityRestrict:FindFirstChild("InsaneButton")
    end
    local function clickGuiButton(button)
        if not button or not button:IsA("GuiButton") then return false end
        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(360, 640)
        local dpScale = (viewport.X ~= 0) and (viewport.X / 360) or 1
        local xOffsetPx = math.floor(xOffsetDp * dpScale + 0.5)  
        local yOffsetPx = math.floor(yOffsetDp * dpScale + 0.5)
        local x = math.floor(button.AbsolutePosition.X + button.AbsoluteSize.X/2 + xOffsetPx)
        local y = math.floor(button.AbsolutePosition.Y + button.AbsoluteSize.Y/2 + yOffsetPx)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
        if not success then
            warn("Click failed:", err)
        end
        return success
    end
    task.spawn(function()
        while true do
            local button = getInsaneButton()
            if button and button:IsA("GuiButton") and button.Visible then
                clickGuiButton(button)
            end
            task.wait(0.1)
        end
    end)
end
do
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    local function rejoin()
        if #Players:GetPlayers() <= 1 then
            localPlayer:Kick("\nRejoining...")
            wait()
            TeleportService:Teleport(PlaceId, localPlayer)
        else
            TeleportService:TeleportToPlaceInstance(PlaceId, JobId, localPlayer)
        end
    end
    local shouldRejoin = false
    task.spawn(function()
        while true do
                sethiddenproperty(localPlayer, "SimulationRadius", 11240)
                sethiddenproperty(localPlayer, "MaxSimulationRadius", 11240)
            local mobFolder = game.Workspace:FindFirstChild("MobFolder")
            if mobFolder then
                local arvan = mobFolder:FindFirstChild("Arvan")
                if arvan and arvan:IsA("Model") then
                    local humanoid = arvan:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        if humanoid.Health > 0 then
                            humanoid.Health = 0
                            task.wait(0.1)
                            if humanoid.Health <= 0 then
                                shouldRejoin = true
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    task.spawn(function()
        while true do
            if shouldRejoin then
                task.wait(1)
                rejoin()
            end
            task.wait(0.1)
        end
    end)
end
do
    if game.PlaceId == 6788463055 then
    game:GetService('TeleportService'):Teleport(103071254740796, LocalPlayer)
    end
end