local DataStoreService = game:GetService("DataStoreService")
local bookmarksStore = DataStoreService:GetDataStore("BookmarksStore")

local placeIds = {}
local dataLoaded = false

local function savePlaceIds()
	local success, errorMessage = pcall(function()
		bookmarksStore:SetAsync("SavedPlaceIds", placeIds)
	end)
	if success then
		print("Place IDs saved successfully.")
	else
		warn("Failed to save Place IDs:", errorMessage)
	end
end

local function removePlaceId(placeIdToRemove)
	local index = table.find(placeIds, placeIdToRemove)
	if index then
		table.remove(placeIds, index)
		savePlaceIds()
		print("Place ID removed:", placeIdToRemove)
	else
		print("Place ID not found:", placeIdToRemove)
	end
end

local function loadPlaceIds()
	print("Loading Place IDs...")
	local success, loadedPlaceIds = pcall(function()
		return bookmarksStore:GetAsync("SavedPlaceIds")
	end)
	if success then
		if loadedPlaceIds then
			print("Place IDs loaded:", loadedPlaceIds)
			placeIds = loadedPlaceIds
			dataLoaded = true
		else
			print("No Place IDs found in DataStore. Using defaults.")
			savePlaceIds()
		end
	else
		warn("Failed to load Place IDs:", loadedPlaceIds)

		print("Using default Place IDs (hardcoded).")
		savePlaceIds()
	end

	print("Final placeIds table: ", table.concat(placeIds, ", "))
end

local function addPlaceId(newPlaceId)
	if not table.find(placeIds, newPlaceId) then
		table.insert(placeIds, newPlaceId)
		savePlaceIds()
		print("Place ID added:", newPlaceId)
	else
		print("Place ID already exists:", newPlaceId)
	end
end

local function getPlaceIds()
	print("Returning Place IDs:", placeIds)
	return placeIds
end
local function printPlaceIds()
	print(placeIds)
end

loadPlaceIds()
local function isDataLoaded()
	return dataLoaded
end

return {
	AddPlaceId = addPlaceId,
	RemovePlaceId = removePlaceId,
	GetPlaceIds = getPlaceIds,
	IsDataLoaded = isDataLoaded,
	PrintPlaceIds = printPlaceIds,
}
