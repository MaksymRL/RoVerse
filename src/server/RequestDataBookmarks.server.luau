local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BookmarksDataEvent = ReplicatedStorage:WaitForChild("BookmarksDataEvent")

-- Function to fetch game information (name)
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

-- Function to fetch game thumbnail
local function getGameThumbnail(placeId)
	return "rbxthumb://type=Asset&id=" .. placeId .. "&w=768&h=432"
end

-- Function to send game data to client
local function sendGameDataToClient(player, placeId)
	local gameName = getGameInfo(placeId)
	local thumbnailUrl = getGameThumbnail(placeId)

	-- Check if the player is still in the game
	if player and player.Parent then
		BookmarksDataEvent:FireClient(player, gameName, thumbnailUrl, placeId)
	end
end

-- Handle client request for game data
BookmarksDataEvent.OnServerEvent:Connect(function(player)
	local bookmarksManager = require(game.ServerScriptService:WaitForChild("BookmarksManager"))

	-- Ensure data is loaded
	while not bookmarksManager.IsDataLoaded() do
		task.wait(0.1)
	end

	local arrayPlaceIds = bookmarksManager.GetPlaceIds()
	-- Send each place ID's data to the client
	for i, placeId in ipairs(arrayPlaceIds) do
		task.wait(0.5) -- Avoid overwhelming the client

		-- Stop sending data if the player leaves
		if not player or not player.Parent then
			print("Player left during data transmission")
			break
		end

		sendGameDataToClient(player, placeId)

		-- Stop after the last place ID
		if i == #arrayPlaceIds then
			print("Finished sending all data for", player.Name)
		end
	end
end)

