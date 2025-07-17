local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guitotoggle = launcherGui:WaitForChild("GuisPlace")

local function toggleFrameVisibility()
	guitotoggle.Visible = not guitotoggle.Visible
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
		toggleFrameVisibility()
	end
end)
