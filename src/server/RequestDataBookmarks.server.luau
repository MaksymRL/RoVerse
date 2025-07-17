local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BookmarksDataEvent = ReplicatedStorage:WaitForChild("BookmarksDataEvent")

local function getGameInfo(placeId)
	local success, productInfo = pcall(function()
		return MarketplaceService:GetProductInfo(placeId)
	end)
	if success and productInfo then
		return productInfo.Name
	else
		warn("Failed to fetch game info for Place ID:", placeId)
		return "Unknown Game"
	end
end

local function getGameThumbnail(placeId)
	return "rbxthumb://type=Asset&id=" .. placeId .. "&w=768&h=432"
end

local function sendGameDataToClient(player, placeId)
	local gameName = getGameInfo(placeId)
	local thumbnailUrl = getGameThumbnail(placeId)

	if player and player.Parent then
		BookmarksDataEvent:FireClient(player, gameName, thumbnailUrl, placeId)
	end
end

BookmarksDataEvent.OnServerEvent:Connect(function(player)
	local bookmarksManager = require(game.ServerScriptService:WaitForChild("BookmarksManager"))

	while not bookmarksManager.IsDataLoaded() do
		task.wait(0.1)
	end

	local arrayPlaceIds = bookmarksManager.GetPlaceIds()

	for i, placeId in ipairs(arrayPlaceIds) do
		task.wait(0.5)

		if not player or not player.Parent then
			print("Player left during data transmission")
			break
		end

		sendGameDataToClient(player, placeId)

		if i == #arrayPlaceIds then
			print("Finished sending all data for", player.Name)
		end
	end
end)
