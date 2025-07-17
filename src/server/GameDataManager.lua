local DataStoreService = game:GetService("DataStoreService")
local GameDataStore = DataStoreService:GetDataStore("GameData")
-- Function to save a comment for a player in a specific game
local function saveGameData(placeId,gameName,gameCreator,gameDescription,thumbnailUrl,gameActive,gameCamera,gameCreated,gameFavorites,gameGenre,gameServerSize,gameUpdated,gameVisits,gameVoiceChat,gameBookmarks,gameRating)


	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)
	local indexKey = "PlaceIndex"
	local success, errorMessage = pcall(function()

		local existingGames = GameDataStore:GetAsync(key) or {}


		table.insert(existingGames, {
			Id = placeId,
			Name = gameName,
			Creator = gameCreator,
			Description = gameDescription,
			Thumbnail = thumbnailUrl,
			ActivePlayers = gameActive,
			Camera = gameCamera,
			Created = gameCreated,
			Favorites = gameFavorites,
			Genre = gameGenre,
			ServerSize = gameServerSize,
			Updated = gameUpdated,
			Visits = gameVisits,
			VoiceChat = gameVoiceChat,
			Bookmarks = gameBookmarks,
			Rating = gameRating
		})


		-- Save updated comments back to the DataStore
		GameDataStore:SetAsync(key, existingGames)

		local placeIndex = GameDataStore:GetAsync(indexKey) or {}
		if not table.find(placeIndex, placeId) then
			table.insert(placeIndex, placeId)
			GameDataStore:SetAsync(indexKey, placeIndex) -- Save the updated index
		end
	end)

	if success then
		print("Game saved successfully for Place:", placeId)
	else
		warn("Failed to save game for Place:", placeId, "Error:", errorMessage)
	end
end

-- Function to get all comments for a specific game (place)
local function getGameData(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, games = pcall(function()
		return GameDataStore:GetAsync(key)
	end)

	if success then
		if games and #games > 0 then
			-- Return the comments data
			return games
		else
			-- Return an empty table if no comments are found
			return {}
		end
	else
		warn("Failed to retrieve game :", placeId, "Error:", games)
		return nil, "Error: " .. tostring(games) -- Return nil and an error message
	end
end

-- Function to clear all comments for a specific game (place)
local function clearGameData(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, errorMessage = pcall(function()
		-- Set the comments array to empty
		GameDataStore:SetAsync(key, {})
	end)

	if success then
		print("Place cleared:", placeId)
	else
		warn("Failed to clear Place:", placeId, "Error:", errorMessage)
	end
end


local function printGameData(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)
	local success, comments = pcall(function()
		return GameDataStore:GetAsync(key)
	end)

	if success then
		if comments and #comments > 0 then
			-- Iterate through comments and print each one
			for i, comment in ipairs(comments) do

				print("id:".. string.sub(comment.Id,1,20),
					("Name") .. string.sub(comment.Name,1,20) ,
					("Creator") ..string.sub(comment.Creator,1,20),
					("Description") ..string.sub(comment.Description,1,20) ,
					("Thumbnail") ..string.sub(comment.Thumbnail,1,20) ,
					("ActivePlayers") ..string.sub(comment.ActivePlayers ,1,20) ,
					("Camera") ..string.sub(comment.Camera ,1,20) ,
					("Created") ..string.sub(comment.Created ,1,20) ,
					("Favorites") ..string.sub(comment.Favorites ,1,20) ,
					("Genre") ..string.sub(comment.Genre,1,20) ,
					("ServerSize") ..string.sub(comment.ServerSize,1,20) ,
					("Updated") ..string.sub(comment.Updated,1,20) ,
					("Visits") ..string.sub(comment.Visits,1,20) ,
					("Voicechat") ..string.sub(comment.VoiceChat,1,20))

			end
		else
			print("No gamedata found for Place:", placeId)
		end
	else
		warn("Failed to retrieve comments for Place:", placeId, "Error:", comments)
	end
end
-- Function to check if a game already exists in the DataStore by placeId
local function doesGameExist(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, gameData = pcall(function()
		return GameDataStore:GetAsync(key)
	end)

	if success then
		if gameData then
			-- If game data exists, return true (game exists)
			return true
		else
			-- If no game data is found, return false (game does not exist)
			return false
		end
	else
		warn("Failed to check if game exists for Place:", placeId, "Error:", gameData)
		return false -- If there's an error, consider the game not existing
	end
end

-- Function to retrieve a list of all stored placeIds
local function getAllPlaceIds()
	local indexKey = "PlaceIndex" -- The key where all placeIds are stored
	local allPlaceIds = {}

	local success, placeIds = pcall(function()
		return GameDataStore:GetAsync(indexKey)
	end)

	if success and placeIds then
		return placeIds
	else
		warn("Failed to retrieve Place IDs:", placeIds)
		return {}  -- Return an empty table if no Place IDs are found
	end
end

local function sortAllGamesByField(fieldName)
	local indexKey = "PlaceIndex" -- The key for storing all place IDs

	-- Step 1: Retrieve the list of place IDs
	local success, placeIds = pcall(function()
		return GameDataStore:GetAsync(indexKey)
	end)

	if not success or not placeIds then
		warn("Failed to retrieve Place IDs for sorting")
		return nil, "Error: Could not retrieve Place IDs"
	end

	-- Step 2: Gather all game data
	local allGames = {}
	for _, placeId in ipairs(placeIds) do
		local key = "Place_" .. tostring(placeId)
		local success, games = pcall(function()
			return GameDataStore:GetAsync(key)
		end)

		if success and games then
			-- Add games from this placeId to the allGames table
			for _, game in ipairs(games) do
				table.insert(allGames, {placeId = placeId, game = game}) -- Store placeId with each game
			end
		else
			warn("Failed to retrieve games for Place:", placeId)
		end
	end

	local function removeNonAlpha(str)
		return str:gsub("[^%a]", ""):lower()
	end

	local function compareDates(dateStr1, dateStr2)
		-- Convert the date strings into DateTime objects
		local date1 = DateTime.fromIsoDate(dateStr1)
		local date2 = DateTime.fromIsoDate(dateStr2)

		-- Compare their Unix timestamps (the number of seconds since the Unix epoch)
		if date1.UnixTimestamp > date2.UnixTimestamp then
			return 1, 0 -- date1 is more recent
		else
			return 0, 1 -- date2 is more recent
		end
	end

	if fieldName == "Name" then
		table.sort(allGames, function(a, b)
			local nameA = removeNonAlpha(a.game[fieldName] or "")
			local nameB = removeNonAlpha(b.game[fieldName] or "")
			return nameA < nameB
		end)
	elseif fieldName == "Updated" then
		table.sort(allGames, function(a, b)
			local updatedA = a.game[fieldName] or ""
			local updatedB = b.game[fieldName] or ""
			local dateA, dateB = compareDates(updatedA, updatedB)
			return dateA > dateB -- Sort by the most recent date
		end)
	else

		-- Step 3: Sort the combined game data based on the field
		table.sort(allGames, function(a, b)

			return tonumber(a.game[fieldName]) > tonumber(b.game[fieldName])
		end)
	end
	-- Step 4: Extract sorted placeIds
	local sortedPlaceIds = {}
	for _, entry in ipairs(allGames) do
		table.insert(sortedPlaceIds, entry.placeId) -- Extract the placeId from the sorted games
	end

	print("Games sorted by field:", fieldName)
	return sortedPlaceIds
end


-- Examples of usage:
local function sortAllGamesByActivePlayers()
	return sortAllGamesByField("ActivePlayers")
end

local function sortAllGamesByLatestUpdate()
	return sortAllGamesByField("Updated")
end

local function sortAllGamesByVisits()
	return sortAllGamesByField("Visits")
end

local function sortAllGamesByName()
	return sortAllGamesByField("Name")
end

local function sortAllGamesByRating()
	return sortAllGamesByField("Rating")
end

local function sortAllGamesByBookmarks()
	return sortAllGamesByField("Bookmarks")
end

local function addFieldToGameData(newFieldName, defaultValue)
	local indexKey = "PlaceIndex" -- The key where all place IDs are stored

	-- Retrieve all place IDs
	local success, placeIds = pcall(function()
		return GameDataStore:GetAsync(indexKey)
	end)

	if not success or not placeIds then
		warn("Failed to retrieve Place IDs for adding a field")
		return
	end

	-- Iterate through all place IDs and add the new field to each game's data
	for _, placeId in ipairs(placeIds) do
		local key = "Place_" .. tostring(placeId)

		local success, games = pcall(function()
			return GameDataStore:GetAsync(key)
		end)

		if success and games then
			-- Add the new field to each game
			for _, game in ipairs(games) do
				if game[newFieldName] == nil then
					game[newFieldName] = defaultValue
				end
			end

			-- Save the updated data back to the DataStore
			local saveSuccess, saveError = pcall(function()
				GameDataStore:SetAsync(key, games)
			end)

			if saveSuccess then
				print("Field added successfully for Place:", placeId)
			else
				warn("Failed to save updated data for Place:", placeId, "Error:", saveError)
			end
		else
			warn("Failed to retrieve games for Place:", placeId)
		end
	end
end



local function applyFilters(arrayPlaceIdsSortedBy, genre, creationFrom, creationTo, updateFrom, updateTo, ratingFrom, ratingTo)

	local filteredGames = {} -- Store the filtered results
	if ratingFrom == nil then
		ratingFrom = 0
	end

	if ratingTo == nil then 
		ratingTo = 0
	end

	print("The genre filter :" .. genre)
	print("The creation from filter :" .. creationFrom)
	print("The creation to filter :" .. creationTo)
	print("The update from filter :" .. updateFrom)
	print("The update to  filter :" .. updateTo)
	print("The rating from filter :" .. ratingFrom)
	print("The rating to filter :" .. ratingTo)
	for _, placeId in ipairs(arrayPlaceIdsSortedBy) do
		local key = "Place_" .. tostring(placeId)

		local success, gameINeed = pcall(function()
			return GameDataStore:GetAsync(key)
		end)

		if success and gameINeed[1] then
			-- Check each filter criterion
			local matchesGenre = false
			if(genre == "All") then
				matchesGenre = true
			else 
				matchesGenre = not genre or gameINeed[1].Genre == genre
			end

			print("Genre :" .. gameINeed[1].Genre)
			local matchesCreationDate = true
			if tonumber(creationFrom) or tonumber(creationTo) then
				print(gameINeed[1])
				local gameCreated = tonumber(DateTime.fromIsoDate(gameINeed[1].Created):FormatUniversalTime("YYYY", "en-us"))
				print(gameCreated)
				print(tonumber(creationFrom))
				if tonumber(creationFrom) then
					matchesCreationDate = matchesCreationDate and gameCreated >= tonumber(creationFrom)
				end
				if tonumber(creationTo) then
					matchesCreationDate = matchesCreationDate and gameCreated <= tonumber(creationTo)
				end
			end

			local matchesUpdateDate = true
			if tonumber(updateFrom) or tonumber(updateTo) then
				local gameUpdated = tonumber(DateTime.fromIsoDate(gameINeed[1].Updated):FormatUniversalTime("YYYY", "en-us"))
				if tonumber(updateFrom) then
					matchesUpdateDate = matchesUpdateDate and gameUpdated >= tonumber(updateFrom)
				end
				if tonumber(updateTo) then
					matchesUpdateDate = matchesUpdateDate and gameUpdated <= tonumber(updateTo)
				end
			end

			local matchesRating = true
			if tonumber(ratingFrom) or tonumber(ratingTo) then
				local gameRating = tonumber(gameINeed[1].Rating) or 0
				if tonumber(ratingFrom) then
					matchesRating = matchesRating and gameRating >= ratingFrom
				end
				if tonumber(ratingTo) then
					matchesRating = matchesRating and gameRating <= ratingTo
				end
			end
			print("matchesGenre :" .. tostring(matchesGenre) .. "matchesCreationDate :" .. tostring(matchesCreationDate) .. "matchesUpdateDate :" .. tostring(matchesUpdateDate) .. "matches rating :" .. tostring(matchesRating))	 
			-- Add game to filtered results if it matches all criteria
			if matchesGenre and matchesCreationDate and matchesUpdateDate and matchesRating then  

				table.insert(filteredGames, gameINeed[1].Id)
			end
		else
			warn("Failed to retrieve game for Place:", placeId)
		end
	end

	return filteredGames
end


local function searchInside(searchString)
	local indexKey = "PlaceIndex" -- The key for storing all place IDs
	local results = {}

	-- Step 1: Retrieve the list of place IDs
	local success, placeIds = pcall(function()
		return GameDataStore:GetAsync(indexKey)
	end)

	if not success or not placeIds then
		warn("Failed to retrieve Place IDs for searching")
		return results -- Return an empty table if no place IDs are found
	end

	-- Step 2: Iterate through the place IDs and search for games
	for _, placeId in ipairs(placeIds) do
		local key = "Place_" .. tostring(placeId)

		local success, gameINeed = pcall(function()
			return GameDataStore:GetAsync(key)
		end)

		if success and gameINeed then
			local searchLower = string.lower(searchString)

			-- Check if searching by creator
			if string.sub(searchLower, 1, 1) == "@" then
				local creatorName = gameINeed[1].Creator or ""
				if string.find(string.lower(creatorName), string.sub(searchLower, 2)) then
					table.insert(results, gameINeed[1].Id)
				end
			else
				-- Check if searching by game name
				local gameName = gameINeed[1].Name or ""
				if string.find(string.lower(gameName), searchLower) then
					table.insert(results, gameINeed[1].Id)
				end
			end
		else
			warn("Failed to retrieve games for Place:", placeId)
		end
	end

	return results -- Return the list of games that match the search
end



-- Export functions for external access
local GamesModule = {}
GamesModule.SaveGameData = saveGameData
GamesModule.GetGameData = getGameData
GamesModule.ClearGameData = clearGameData
GamesModule.PrintGameData = printGameData
GamesModule.DoesGameExist = doesGameExist
GamesModule.GetAllPlaceIds = getAllPlaceIds
GamesModule.SortByActivePlayers = sortAllGamesByActivePlayers
GamesModule.SortByLastUpdate = sortAllGamesByLatestUpdate
GamesModule.SortyByVisits = sortAllGamesByVisits
GamesModule.SortByName = sortAllGamesByName
GamesModule.SortByRating = sortAllGamesByRating
GamesModule.SortByBookmarks = sortAllGamesByBookmarks
GamesModule.AddField = addFieldToGameData
GamesModule.SortByField = sortAllGamesByField
GamesModule.ApplyFilters = applyFilters
GamesModule.SearchInside = searchInside
return GamesModule


