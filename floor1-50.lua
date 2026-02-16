local function getRoot()
	local char = (speaker and speaker.Character) or (game.Players.LocalPlayer and game.Players.LocalPlayer.Character)
	if not char then return nil end
	local root = (type(getRoot) == "function" and getRoot(char)) or char:FindFirstChildWhichIsA("BasePart")
	return root
end
local function fti(parent, rootPart)
	if not parent then return end
	local root = getRoot()
	if not root then return end
	local function trigger(part)
		if firetouchinterest then
			task.spawn(function()
				firetouchinterest(part, root, 1)  
				task.wait()
				firetouchinterest(part, root, 0)  
			end)
		else
			part.CFrame = root.CFrame
		end
	end
	if parent.ClassName == "TouchInterest" or parent:IsA("TouchTransmitter") then
		local part = parent:FindFirstAncestorWhichIsA("BasePart")
		if part then trigger(part) end
		return
	end
	for _, desc in ipairs(parent:GetDescendants()) do
		if desc.ClassName == "TouchInterest" or desc:IsA("TouchTransmitter") then
			local part = desc:FindFirstAncestorWhichIsA("BasePart")
			if part then trigger(part) end
		end
	end
end
local function getFloor()
	local currentRoom = workspace.Values.CurrentRoom.Value
	if currentRoom and currentRoom.Name ~= "elevator" then
		local floorName = currentRoom.Name
		local floorModel = workspace:FindFirstChild(floorName)
		if floorModel then
			return floorModel
		end
	end
	return nil
end
local function touch(rootPart)
	local floorModel = getFloor()
	if floorModel then
		fti(floorModel, rootPart)
	end
end

return {
    ["MozelleSquidGames"] = function()
        touch(workspace.MozelleSquidGames.Needed.Winner)
    end,
    ["StanelyRoom"] = function()
        touch(workspace.StanelyRoom.Build.Generated.Ending.EndTouch)
    end,
    ["FloodFillMine"] = function()
        touch(workspace.FloodFillMine.Build.Shield.Bubble)
    end,
    ["Splitsville_Wipeout"] = function()
        touch(workspace.Splitsville_Wipeout.Checkpoints.EndCheckpoint)
    end,
    ["Obby"] = function()
        touch(workspace.Obby.Build.EndPart)
    end,
    ["IntenseObby"] = function()
        touch(workspace.IntenseObby.ENDBLOCK)
    end,
    ["FindThePath"] = function()
        touch(workspace.FindThePath.Build.End.win_zone)
    end,
    ["GASA4"] = function()
        touch(workspace.GASA4.Build.ExtractionBox)
    end,
    ["Minefield"] = function()
        touch(workspace.Minefield.Build.WinPart)
    end,
    ["WhoKilledYouObby"] = function()
        touch(workspace.WhoKilledYouObby.Build.Ending.WinPart)
    end,
}