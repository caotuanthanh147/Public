local function touchTransmitter(targetName)
	local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
	local function touch(x)
		x = x:FindFirstAncestorWhichIsA("Part")
		if x then
			if firetouchinterest then
				task.spawn(function()
					firetouchinterest(x, root, 1)
					wait()
					firetouchinterest(x, root, 0)
				end)
			end
			x.CFrame = root.CFrame
		end
	end
	if targetName then
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("TouchTransmitter") and (descendant.Name == targetName or descendant.Parent.Name == targetName) then
				touch(descendant)
			end
		end
	else
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("TouchTransmitter") then
				touch(descendant)
			end
		end
	end
end

return {
    ["MozelleSquidGames"] = function()
        touchTransmitter("Winner")
    end,
    ["StanelyRoom"] = function()
        touchTransmitter("EndTouch")
    end,
    ["FloodFillMine"] = function()
        touchTransmitter("Bubble")
    end,
    ["Splitsville_Wipeout"] = function()
        touchTransmitter("EndCheckpoint")
    end,
    ["Obby"] = function()
        touchTransmitter("EndPart")
    end,
    ["IntenseObby"] = function()
        touchTransmitter("ENDBLOCK")
    end,
    ["FindThePath"] = function()
        touchTransmitter("win_zone")
    end,
    ["GASA4"] = function()
        touchTransmitter("ExtractionBox")
    end,
    ["Minefield"] = function()
        touchTransmitter("WinPart")
    end,
    ["WhoKilledYouObby"] = function()
        touchTransmitter("WinPart")
    end,
}