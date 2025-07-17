local DataStoreService = game:GetService("DataStoreService")
local tutorialsDataStore = DataStoreService:GetDataStore("TutorialsDataStore")

-- Function to save a comment for a player in a specific game
local function saveTutorial(placeId, playerUser, tutorialText, tutorialTitle)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, errorMessage = pcall(function()
		-- Load existing comments for this place
		local existingTutorials = tutorialsDataStore:GetAsync(key) or {}

		-- Add the new comment with a timestamp
		table.insert(existingTutorials, {
			text = tutorialText,
			timestamp = os.time(), -- Save the time of the comment
			nickname = playerUser,
			title = tutorialTitle
		})

		-- Save updated comments back to the DataStore
		tutorialsDataStore:SetAsync(key, existingTutorials)
	end)

	if success then
		print("Tutorial saved successfully for Place:", placeId, "Player:", playerUser)
	else
		warn("Failed to review tutorial for Place:", placeId, "Player:", playerUser, "Error:", errorMessage)
	end
end

-- Function to get all comments for a specific game (place)
local function getTutorials(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, tutorials = pcall(function()
		return tutorialsDataStore:GetAsync(key)
	end)

	if success then
		if tutorials and #tutorials > 0 then
			-- Return the comments data
			return tutorials
		else
			-- Return an empty table if no comments are found
			return {}
		end
	else
		warn("Failed to retrieve tutorials for Place:", placeId, "Error:", tutorials)
		return nil, "Error: " .. tostring(tutorials) -- Return nil and an error message
	end
end

-- Function to print all comments for a specific game (place)
local function printTutorials(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)
	local success, tutorials = pcall(function()
		return tutorialsDataStore:GetAsync(key)
	end)

	if success then
		if tutorials and #tutorials > 0 then
			-- Iterate through comments and print each one
			for i, tutorial in ipairs(tutorials) do
				local timeAgo = os.time() - tutorial.timestamp
				local formattedTime = string.format("%d seconds ago", timeAgo) -- You can customize the time format
				print(string.format("[%s] %s: %s", formattedTime, tutorial.nickname, tutorial.text))
			end
		else
			print("No tutorial found for Place:", placeId)
		end
	else
		warn("Failed to retrieve tutorials for Place:", placeId, "Error:", tutorials)
	end
end

-- Function to clear all comments for a specific game (place)
local function clearTutorials(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, errorMessage = pcall(function()
		-- Set the comments array to empty
		tutorialsDataStore:SetAsync(key, {})
	end)

	if success then
		print("All tutorials cleared for Place:", placeId)
	else
		warn("Failed to clear tutorials for Place:", placeId, "Error:", errorMessage)
	end
end

-- Export functions for external access
local TutorialsModule = {}
TutorialsModule.SaveTutorial = saveTutorial
TutorialsModule.GetTutorials = getTutorials
TutorialsModule.PrintTutorial = printTutorials
TutorialsModule.ClearTutorial = clearTutorials
return TutorialsModule



