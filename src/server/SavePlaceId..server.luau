local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("AddPlaceRequest")
local GameDataManager = require(game.ServerScriptService.Server:WaitForChild("GameDataManager"))
local HttpService = game:GetService("HttpService")
local serverUrlDetails = "https://able-infrequent-honey.glitch.me/get_game_details"
local MarketplaceService = game:GetService("MarketplaceService")

local function fetchGameStats(placeId, retries)
	retries = retries or 0
	if retries > 3 then
		warn("Failed to fetch stats after 3 retries for Place ID:", placeId)
		return nil
	end

	print("Fetching stats for Place ID:", placeId)
	local url = serverUrlDetails .. "?place_id=" .. placeId
	local success, response = pcall(function()
		return HttpService:GetAsync(url)
	end)

	if success then
		local gameData = HttpService:JSONDecode(response)
		if gameData and not gameData.error then
			return gameData
		end
	end

	warn("Retrying fetchGameStats for Place ID:", placeId)
	return fetchGameStats(placeId, retries + 1)
end

local function fetchGameInfo(placeId, retries)
	retries = retries or 0
	if retries > 3 then
		warn("Failed to fetch info after 3 retries for Place ID:", placeId)
		return nil
	end

	local success, productInfo = pcall(function()
		return MarketplaceService:GetProductInfo(placeId)
	end)

	if success then
		return {
			name = productInfo.Name or "Unknown Game",
			description = productInfo.Description or "No description available",
			thumbnailUrl = "rbxthumb://type=Asset&id=" .. placeId .. "&w=768&h=432",
			creator = productInfo.Creator.Name,
		}
	end

	warn("Retrying fetchGameInfo for Place ID:", placeId)
	return fetchGameInfo(placeId, retries + 1)
end

ServerTriggerEvent.OnServerEvent:Connect(function(player, placeId)
	if typeof(placeId) ~= "number" or placeId <= 0 then
		warn(player.Name .. " provided an invalid Place ID:", tostring(placeId))
		return
	end

	print(player.Name .. " triggered the event with data: " .. tostring(placeId))
	local doesExist = GameDataManager.DoesGameExist(placeId)
	if doesExist then
		print("Game already exists")
		return
	end

	local gameInfo = fetchGameInfo(placeId)
	local gameStats = fetchGameStats(placeId)
	print("GameInfo:", gameInfo and HttpService:JSONEncode(gameInfo) or "nil")
	print("GameStats:", gameStats and HttpService:JSONEncode(gameStats) or "nil")

	if gameInfo and gameStats then
		print(placeId .. " type " .. typeof(placeId))
		wait(0.1)
		GameDataManager.SaveGameData(
			placeId,
			gameInfo.name,
			gameInfo.creator,
			gameInfo.description,
			gameInfo.thumbnailUrl,
			gameStats.activePlayers,
			gameStats.camera,
			gameStats.created,
			gameStats.favorites,
			gameStats.genre,
			gameStats.serverSize,
			gameStats.updated,
			gameStats.visits,
			gameStats.voiceChat,
			0,
			0
		)

		print("Game data saved for Place ID:", placeId)
	else
		warn("Failed to fetch game details for Place ID:", placeId)
	end
end)
