local DataStoreService = game:GetService("DataStoreService")
local tutorialsDataStore = DataStoreService:GetDataStore("TutorialsDataStore")

local function saveTutorial(placeId, playerUser, tutorialText, tutorialTitle)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		local existingTutorials = tutorialsDataStore:GetAsync(key) or {}

		table.insert(existingTutorials, {
			text = tutorialText,
			timestamp = os.time(),
			nickname = playerUser,
			title = tutorialTitle,
		})

		tutorialsDataStore:SetAsync(key, existingTutorials)
	end)

	if success then
		print("Tutorial saved successfully for Place:", placeId, "Player:", playerUser)
	else
		warn("Failed to review tutorial for Place:", placeId, "Player:", playerUser, "Error:", errorMessage)
	end
end

local function getTutorials(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, tutorials = pcall(function()
		return tutorialsDataStore:GetAsync(key)
	end)

	if success then
		if tutorials and #tutorials > 0 then
			return tutorials
		else
			return {}
		end
	else
		warn("Failed to retrieve tutorials for Place:", placeId, "Error:", tutorials)
		return nil, "Error: " .. tostring(tutorials)
	end
end

local function printTutorials(placeId)
	local key = "Place_" .. tostring(placeId)
	local success, tutorials = pcall(function()
		return tutorialsDataStore:GetAsync(key)
	end)

	if success then
		if tutorials and #tutorials > 0 then
			for i, tutorial in ipairs(tutorials) do
				local timeAgo = os.time() - tutorial.timestamp
				local formattedTime = string.format("%d seconds ago", timeAgo)
				print(string.format("[%s] %s: %s", formattedTime, tutorial.nickname, tutorial.text))
			end
		else
			print("No tutorial found for Place:", placeId)
		end
	else
		warn("Failed to retrieve tutorials for Place:", placeId, "Error:", tutorials)
	end
end

local function clearTutorials(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		tutorialsDataStore:SetAsync(key, {})
	end)

	if success then
		print("All tutorials cleared for Place:", placeId)
	else
		warn("Failed to clear tutorials for Place:", placeId, "Error:", errorMessage)
	end
end

local TutorialsModule = {}
TutorialsModule.SaveTutorial = saveTutorial
TutorialsModule.GetTutorials = getTutorials
TutorialsModule.PrintTutorial = printTutorials
TutorialsModule.ClearTutorial = clearTutorials
return TutorialsModule
