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
			wait(0.01) -- Small delay to avoid overwhelming the client

			if i ~= #arrayPlaceIdsSortedBy then
				local gamesData = GameDataManager.GetGameData(placeId)
				if i <= 20 and i >= 1 then
					sendGameDataToClient(player, gamesData[1], placeId)
				end
			end

			-- Stop when it reaches the last item
			if i == 20 or i == #array then
				LoadingStopRequest:FireClient(player)
				amountPages = math.ceil(#array / 20)
				amountGames = #array

				ChangePageRequest:FireClient(player, amountPages)
				break -- Break the loop when the last item is reached
			end
		end
	else
		local startIndex = (indexToAdd - 1) * 20 + 1 -- Calculate the starting index for this page

		for i = startIndex, #array do
			wait(0.01) -- Small delay to avoid overwhelming the client

			local placeId = array[i]
			local gamesData = GameDataManager.GetGameData(placeId)

			-- Only send the game data for this page
			if i <= indexToAdd * 20 and i >= startIndex then
				sendGameDataToClient(player, gamesData[1], placeId)
			end

			-- Stop when it reaches the last item
			if i == indexToAdd * 20 or i == #array then
				LoadingStopRequest:FireClient(player)
				break -- Break the loop when the last item is reached
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

-- details

--local serverUrlDetails = "https://able-infrequent-honey.glitch.me/get_game_details"

--local function fetchGameStats(placeId)
--	local url = serverUrlDetails .. "?place_id=" .. placeId
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
--			print("skibidi sigma"),
--			creator = productInfo.Creator.Name
--		}
--	end

--	warn("Failed to fetch game info for Place ID:", placeId)
--	return nil
--end

--ListDataEvent.OnServerEvent:Connect(function(player, placeId)
--	local GameDataManager = require(game.ServerScriptService:WaitForChild("GameDataManager"))
--	local placeIdsManager = require(game.ServerScriptService:WaitForChild("PlaceIdManager"))

--	local arrayPlaceIds =  placeIdsManager.GetPlaceIds()
--	print(arrayPlaceIds)

--	for i, placeId in ipairs(arrayPlaceIds) do
--		task.wait(0.5)  -- Small delay to avoid overwhelming the client
--		GameDataManager.ClearGameData(placeId)

--		-- Stop when it reaches the last item
--		if i == #arrayPlaceIds then

--			--ChangePageRequest:FireClient(player,amountPages)
--			break  -- Break the loop when the last item is reached
--		end
--	end

--	for i, placeId in ipairs(arrayPlaceIds) do
--		task.wait(0.5)  -- Small delay to avoid overwhelming the client
--		local gameStats = fetchGameStats(placeId)
--		local gameInfo = fetchGameInfo(placeId)
--		local gameName, gameDescription, gameCreatorAct = getGameInfo(placeId)
--		if gameStats and gameInfo then
--			GameDataManager.SaveGameData(placeId,gameInfo.name,
--				gameCreatorAct,
--				gameInfo.description,
--				gameInfo.thumbnailUrl,
--				gameStats.activePlayers,
--				gameStats.camera,
--				gameStats.created,
--				gameStats.favorites,
--				gameStats.genre,
--				gameStats.serverSize,
--				gameStats.updated,
--				gameStats.visits,
--				gameStats.voiceChat)
--		end
--GameDataManager.PrintGameData(placeId)
--		-- Stop when it reaches the last item
--		if i == #arrayPlaceIds then
--			print("Reached last item:", placeId)
--			LoadingStopRequest:FireClient(player)
--			amountPages = math.ceil(#arrayPlaceIds / 20)
--			print("the amount of pages is" .. amountPages .. " and type is " .. typeof(amountPages))
--			--ChangePageRequest:FireClient(player,amountPages)
--			break  -- Break the loop when the last item is reached
--		end
--	end
--end)
