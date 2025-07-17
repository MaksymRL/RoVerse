local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveReviewRequest")
local reviewManager = require(game.ServerScriptService.Server:WaitForChild("ReviewsManager"))

ServerTriggerEvent.OnServerEvent:Connect(function(player, reviewText, placeid, reviewTitle, reviewRating)
	print(player.Name .. " triggered the event with comment: " .. tostring(reviewText))

	reviewManager.SaveReview(placeid, player.DisplayName, reviewText, reviewTitle, reviewRating)
end)
