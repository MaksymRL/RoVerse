local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveTutorialRequest")
local tutorialsManager = require(game.ServerScriptService.Server:WaitForChild("TutorialsManager"))

ServerTriggerEvent.OnServerEvent:Connect(function(player, reviewText, placeid, reviewTitle, reviewRating)
	print(player.Name .. " triggered the event with comment: " .. tostring(reviewText))

	tutorialsManager.SaveTutorial(placeid, player.DisplayName, reviewText, reviewTitle)
end)
