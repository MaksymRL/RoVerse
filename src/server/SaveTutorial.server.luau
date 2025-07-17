local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveTutorialRequest")
local tutorialsManager = require(game.ServerScriptService.Server:WaitForChild("TutorialsManager"))

-- Function to handle the event and save the comment
ServerTriggerEvent.OnServerEvent:Connect(function(player, reviewText, placeid, reviewTitle, reviewRating)
	print(player.Name .. " triggered the event with comment: " .. tostring(reviewText))

	-- Ensure the SaveComment function matches your expected parameters
	tutorialsManager.SaveTutorial(placeid, player.DisplayName, reviewText, reviewTitle) -- Adjusted to pass player.UserId
end)
