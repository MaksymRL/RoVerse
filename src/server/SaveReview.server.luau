local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveReviewRequest")
local reviewManager = require(game.ServerScriptService.Server:WaitForChild("ReviewsManager"))

-- Function to handle the event and save the comment
ServerTriggerEvent.OnServerEvent:Connect(function(player, reviewText, placeid, reviewTitle, reviewRating)
	print(player.Name .. " triggered the event with comment: " .. tostring(reviewText))

	-- Ensure the SaveComment function matches your expected parameters
	reviewManager.SaveReview(placeid, player.DisplayName, reviewText, reviewTitle, reviewRating) -- Adjusted to pass player.UserId
end)
