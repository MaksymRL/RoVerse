local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guitotoggle = launcherGui:WaitForChild("GuisPlace") -- The frame you want to toggle visibility for

-- This function will toggle the visibility of the frame
local function toggleFrameVisibility()
	guitotoggle.Visible = not guitotoggle.Visible
end

-- Listen for key press (Q key in this case)
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return -- Ignore if the input is already being processed by the game (like typing in chat)
	end

	-- Check if the "Q" key is pressed
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Q then
		toggleFrameVisibility() -- Toggle the frame visibility
	end
end)
