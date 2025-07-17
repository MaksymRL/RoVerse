local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local serverUrl = "https://able-infrequent-honey.glitch.me/get_game_details"
local DetailsDataEvent = ReplicatedStorage:WaitForChild("DetailsDataEvent")

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
