local DataStoreService = game:GetService("DataStoreService")
local bookmarksStore = DataStoreService:GetDataStore("BookmarksStore")

-- Directly use the list of Place IDs you provided
local placeIds = {} 
local dataLoaded = false
-- Save Place IDs
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
		table.remove(placeIds, index) -- Remove the Place ID from the list
		savePlaceIds() -- Save the updated list
		print("Place ID removed:", placeIdToRemove)
	else
		print("Place ID not found:", placeIdToRemove)
	end
end

-- Load Place IDs
local function loadPlaceIds()
	print("Loading Place IDs...")  -- Debugging line
	local success, loadedPlaceIds = pcall(function()
		return bookmarksStore:GetAsync("SavedPlaceIds")
	end)
	if success then
		if loadedPlaceIds then
			print("Place IDs loaded:", loadedPlaceIds)
			placeIds = loadedPlaceIds
			dataLoaded = true
		else
			-- No Place IDs found, we already have the placeIds defined at the start
			print("No Place IDs found in DataStore. Using defaults.")
			savePlaceIds()  -- Save the default Place IDs to DataStore
		end
	else
		warn("Failed to load Place IDs:", loadedPlaceIds)
		-- Fallback: Use the hardcoded placeIds
		print("Using default Place IDs (hardcoded).")
		savePlaceIds()  -- Save the hardcoded Place IDs to DataStore
	end

	-- Debugging: Print the actual contents of placeIds
	print("Final placeIds table: ", table.concat(placeIds, ", "))
end

-- Add a new Place ID
local function addPlaceId(newPlaceId)
	if not table.find(placeIds, newPlaceId) then
		table.insert(placeIds, newPlaceId)
		savePlaceIds()  -- Save the updated Place IDs list
		print("Place ID added:", newPlaceId)
	else
		print("Place ID already exists:", newPlaceId)
	end
end

-- Get current Place IDs
local function getPlaceIds()
	print("Returning Place IDs:", placeIds)  -- Debugging line
	return placeIds
end
local function printPlaceIds()
	print(placeIds)
end	
-- Initialize placeIds when the script is required
loadPlaceIds()
local function isDataLoaded()
	return dataLoaded
end

-- Return functions for external access
return {
	AddPlaceId = addPlaceId,
	RemovePlaceId = removePlaceId,
	GetPlaceIds = getPlaceIds,
	IsDataLoaded = isDataLoaded,
	PrintPlaceIds = printPlaceIds
}