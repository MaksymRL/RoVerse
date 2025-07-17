local DataStoreService = game:GetService("DataStoreService")
local reviewsDataStore = DataStoreService:GetDataStore("ReviewsDataStore")

-- Function to save a comment for a player in a specific game
local function saveReview(placeId, playerUser, reviewText, reviewTitle, reviewRating)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, errorMessage = pcall(function()
		-- Load existing comments for this place
		local existingReviews = reviewsDataStore:GetAsync(key) or {}

		-- Add the new comment with a timestamp
		table.insert(existingReviews, {
			text = reviewText,
			timestamp = os.time(), -- Save the time of the comment
			nickname = playerUser,
			title = reviewTitle,
			rating = reviewRating
		})

		-- Save updated comments back to the DataStore
		reviewsDataStore:SetAsync(key, existingReviews)
	end)

	if success then
		print("Review saved successfully for Place:", placeId, "Player:", playerUser)
	else
		warn("Failed to load review for Place:", placeId, "Player:", playerUser, "Error:", errorMessage)
	end
end

-- Function to get all comments for a specific game (place)
local function getReviews(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, reviews = pcall(function()
		return reviewsDataStore:GetAsync(key)
	end)

	if success then
		if reviews and #reviews > 0 then
			-- Return the comments data
			return reviews
		else
			-- Return an empty table if no comments are found
			return {}
		end
	else
		warn("Failed to retrieve reviews for Place:", placeId, "Error:", reviews)
		return nil, "Error: " .. tostring(reviews) -- Return nil and an error message
	end
end

-- Function to print all comments for a specific game (place)
local function printReviews(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)
	local success, reviews = pcall(function()
		return reviewsDataStore:GetAsync(key)
	end)

	if success then
		if reviews and #reviews > 0 then
			-- Iterate through comments and print each one
			for i, review in ipairs(reviews) do
				local timeAgo = os.time() - review.timestamp
				local formattedTime = string.format("%d seconds ago", timeAgo) -- You can customize the time format
				print(string.format("[%s] %s: %s", formattedTime, review.nickname, review.text))
			end
		else
			print("No reviews found for Place:", placeId)
		end
	else
		warn("Failed to retrieve reviews for Place:", placeId, "Error:", reviews)
	end
end

-- Function to clear all comments for a specific game (place)
local function clearReviews(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, errorMessage = pcall(function()
		-- Set the comments array to empty
		reviewsDataStore:SetAsync(key, {})
	end)

	if success then
		print("All reviews cleared for Place:", placeId)
	else
		warn("Failed to clear reviews for Place:", placeId, "Error:", errorMessage)
	end
end

-- Export functions for external access
local ReviewsModule = {}
ReviewsModule.SaveReview = saveReview
ReviewsModule.GetReviews = getReviews
ReviewsModule.PrintReviews = printReviews
ReviewsModule.ClearReviews = clearReviews
return ReviewsModule