local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ListDataEvent = ReplicatedStorage:WaitForChild("ListDataEvent")
local HttpService = game:GetService("HttpService")
local LoadingStopRequest = ReplicatedStorage:WaitForChild("LoadingStopRequest")
local serverUrl = "https://handsome-wave-jingle.glitch.me/get_game_details"
local ChangePageRequest = ReplicatedStorage:WaitForChild("ChangePageRequest")
local amountPages
local amountGames
local arrayPlaceIdsSortedBy = {}
local arrayPlaceIdsFilteredBy = {}
local arrayPlaceIdsSearched = {}
local filterRequest = ReplicatedStorage:WaitForChild("FilterRequest")
local GameDataManager = require(game.ServerScriptService.Server:WaitForChild("GameDataManager"))
local searchRequest = ReplicatedStorage:WaitForChild("SearchRequest")

local function sendGameDataToClient(player, gamesData, placeId)
	local gameName = gamesData.Name
	local gameDescription = gamesData.Description
	local gameCreator = gamesData.Creator
	local thumbnailUrl = gamesData.Thumbnail
	local gameVisits = gamesData.Visits
	local gameGenre = gamesData.Genre
	local gameActive = gamesData.ActivePlayers
	local gameBookmarks = gamesData.Bookmarks
	local gameRating = gamesData.Rating

	wait(0.01)
	ListDataEvent:FireClient(
		player,
		gameName,
		gameDescription,
		gameCreator,
		thumbnailUrl,
		gameVisits,
		gameGenre,
		gameActive,
		placeId,
		gameBookmarks,
		gameRating
	)
end

local function searchDataToSend(player, indexToAdd, array)
	if indexToAdd == 1 then
		for i, placeId in ipairs(array) do
			wait(0.01)

			if i ~= #arrayPlaceIdsSortedBy then
				local gamesData = GameDataManager.GetGameData(placeId)
				if i <= 20 and i >= 1 then
					sendGameDataToClient(player, gamesData[1], placeId)
				end
			end

			if i == 20 or i == #array then
				LoadingStopRequest:FireClient(player)
				amountPages = math.ceil(#array / 20)
				amountGames = #array

				ChangePageRequest:FireClient(player, amountPages)
				break
			end
		end
	else
		local startIndex = (indexToAdd - 1) * 20 + 1

		for i = startIndex, #array do
			wait(0.01)

			local placeId = array[i]
			local gamesData = GameDataManager.GetGameData(placeId)

			if i <= indexToAdd * 20 and i >= startIndex then
				sendGameDataToClient(player, gamesData[1], placeId)
			end

			if i == indexToAdd * 20 or i == #array then
				LoadingStopRequest:FireClient(player)
				break
			end
		end
	end
end

ListDataEvent.OnServerEvent:Connect(function(player, indexToAdd, SortByWhat)
	if SortByWhat ~= nil then
		arrayPlaceIdsSortedBy = {}
		local arrayPlaceIds = GameDataManager.SortByField(SortByWhat)
		for i, placeId in ipairs(arrayPlaceIds) do
			table.insert(arrayPlaceIdsSortedBy, placeId)
			if i == #arrayPlaceIds then
				break
			end
		end
	end
	print(arrayPlaceIdsSortedBy)
	if #arrayPlaceIdsFilteredBy == 0 and #arrayPlaceIdsSearched == 0 then
		searchDataToSend(player, indexToAdd, arrayPlaceIdsSortedBy)
	elseif #arrayPlaceIdsSearched ~= 0 then
		searchDataToSend(player, indexToAdd, arrayPlaceIdsSearched)
	else
		searchDataToSend(player, indexToAdd, arrayPlaceIdsFilteredBy)
	end
end)

filterRequest.OnServerEvent:Connect(
	function(player, genre, creationFrom, creationTo, updateFrom, updateTo, ratingFrom, ratingTo)
		local arrayPlaceIds = GameDataManager.ApplyFilters(
			arrayPlaceIdsSortedBy,
			genre,
			creationFrom,
			creationTo,
			updateFrom,
			updateTo,
			ratingFrom,
			ratingTo
		)
		if #arrayPlaceIds == 0 then
			LoadingStopRequest:FireClient(player)
			return
		end
		print(arrayPlaceIds)
		arrayPlaceIdsFilteredBy = {}
		for i, placeId in ipairs(arrayPlaceIds) do
			table.insert(arrayPlaceIdsFilteredBy, placeId)
			if i == #arrayPlaceIds then
				break
			end
		end

		print(arrayPlaceIdsFilteredBy)
		searchDataToSend(player, 1, arrayPlaceIdsFilteredBy)
	end
)

searchRequest.OnServerEvent:Connect(function(player, searchText)
	local arrayPlaceIds = GameDataManager.SearchInside(searchText)
	if #arrayPlaceIds == 0 then
		LoadingStopRequest:FireClient(player)
		return
	end
	print(arrayPlaceIds)
	arrayPlaceIdsSearched = {}
	for i, placeId in ipairs(arrayPlaceIds) do
		table.insert(arrayPlaceIdsSearched, placeId)
		if i == #arrayPlaceIds then
			break
		end
	end

	print(arrayPlaceIdsSearched)
	searchDataToSend(player, 1, arrayPlaceIdsSearched)
end)
