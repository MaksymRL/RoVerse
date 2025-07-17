local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local serverUrl = "https://able-infrequent-honey.glitch.me/get_game_details"
local DetailsDataEvent = ReplicatedStorage:WaitForChild("DetailsDataEvent")

--local function fetchGameStats(placeId)
--	local url = serverUrl .. "?place_id=" .. placeId
--	local success, response = pcall(function()
--		return HttpService:GetAsync(url)
--	end)

--	if success then
--		local gameData = HttpService:JSONDecode(response)
--		if gameData and not gameData.error then
--			return gameData
--		end
--	end

--	warn("Failed to fetch stats for Place ID:", placeId)
--	return nil
--end

--local function fetchGameInfo(placeId)
--	local success, productInfo = pcall(function()
--		return MarketplaceService:GetProductInfo(placeId)
--	end)

--	if success then
--		return {
--			name = productInfo.Name or "Unknown Game",
--			description = productInfo.Description or "No description available",
--			thumbnailUrl = "rbxthumb://type=Asset&id=" .. placeId .. "&w=768&h=432",
--			print("skibidi sigma")
--		}
--	end

--	warn("Failed to fetch game info for Place ID:", placeId)
--	return nil
--end

DetailsDataEvent.OnServerEvent:Connect(function(player, placeId)
	local GameDataManager = require(game.ServerScriptService.Server:WaitForChild("GameDataManager"))

	if not placeId then
		warn("Invalid Place ID received.")
		return
	end

	local gameData = GameDataManager.GetGameData(placeId)
	local gameStats = gameData[1]
	if gameStats then
		print(gameStats.created)
		print(gameStats.updated)
		DetailsDataEvent:FireClient(player, {

			gameName = gameStats.Name,
			gameDescription = gameStats.Description,
			thumbnailUrl = gameStats.Thumbnail,
			gameActive = gameStats.ActivePlayers,
			gameCamera = gameStats.Camera,
			gameCreated = gameStats.Created,
			gameFavorites = gameStats.Favorites,
			gameGenre = gameStats.Genre,
			gameServerSize = gameStats.ServerSize,
			gameUpdated = gameStats.Updated,
			gameVisits = gameStats.Visits,
			gameVoiceChat = gameStats.VoiceChat,
		})
	else
		warn("Failed to fetch game details for Place ID:", placeId)
	end
end)
