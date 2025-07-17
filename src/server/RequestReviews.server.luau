local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ReviewsDataEvent = ReplicatedStorage:WaitForChild("ReviewDataEvent")

local function sendGameDataToClient(player, review)
	local text = review.text
	local nickname = review.nickname
	local currentTime = os.time()
	local timeDifference = os.difftime(currentTime, review.timestamp)
	local title = review.title
	local rating = review.rating

	local timeString
	if timeDifference < 60 then
		timeString = string.format("%d seconds ago", timeDifference)
	elseif timeDifference < 3600 then
		timeString = string.format("%d minutes ago", math.floor(timeDifference / 60))
	elseif timeDifference < 86400 then
		timeString = string.format("%d hours ago", math.floor(timeDifference / 3600))
	else
		timeString = string.format("%d days ago", math.floor(timeDifference / 86400))
	end

	if player and player.Parent then
		print("Review sent to client with")
		ReviewsDataEvent:FireClient(player, text, nickname, timeString, review.timestamp, title, rating)
	end
end

ReviewsDataEvent.OnServerEvent:Connect(function(player, placeId)
	local reviewsManager = require(game.ServerScriptService.Server:WaitForChild("ReviewsManager"))

	reviewsManager.PrintReviews(placeId)
	local arrayReviews = reviewsManager.GetReviews(placeId, player.DisplayName)
	print("Reviews count: " .. #arrayReviews)

	for i, review in ipairs(arrayReviews) do
		task.wait(0.5)
		if not player or not player.Parent then
			print("Player left during data transmission")
			break
		end

		sendGameDataToClient(player, review)
	end
end)
