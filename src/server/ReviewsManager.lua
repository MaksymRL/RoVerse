local DataStoreService = game:GetService("DataStoreService")
local reviewsDataStore = DataStoreService:GetDataStore("ReviewsDataStore")

local function saveReview(placeId, playerUser, reviewText, reviewTitle, reviewRating)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		local existingReviews = reviewsDataStore:GetAsync(key) or {}

		table.insert(existingReviews, {
			text = reviewText,
			timestamp = os.time(),
			nickname = playerUser,
			title = reviewTitle,
			rating = reviewRating,
		})

		reviewsDataStore:SetAsync(key, existingReviews)
	end)

	if success then
		print("Review saved successfully for Place:", placeId, "Player:", playerUser)
	else
		warn("Failed to load review for Place:", placeId, "Player:", playerUser, "Error:", errorMessage)
	end
end

local function getReviews(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, reviews = pcall(function()
		return reviewsDataStore:GetAsync(key)
	end)

	if success then
		if reviews and #reviews > 0 then
			return reviews
		else
			return {}
		end
	else
		warn("Failed to retrieve reviews for Place:", placeId, "Error:", reviews)
		return nil, "Error: " .. tostring(reviews)
	end
end

local function printReviews(placeId)
	local key = "Place_" .. tostring(placeId)
	local success, reviews = pcall(function()
		return reviewsDataStore:GetAsync(key)
	end)

	if success then
		if reviews and #reviews > 0 then
			for i, review in ipairs(reviews) do
				local timeAgo = os.time() - review.timestamp
				local formattedTime = string.format("%d seconds ago", timeAgo)
				print(string.format("[%s] %s: %s", formattedTime, review.nickname, review.text))
			end
		else
			print("No reviews found for Place:", placeId)
		end
	else
		warn("Failed to retrieve reviews for Place:", placeId, "Error:", reviews)
	end
end

local function clearReviews(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		reviewsDataStore:SetAsync(key, {})
	end)

	if success then
		print("All reviews cleared for Place:", placeId)
	else
		warn("Failed to clear reviews for Place:", placeId, "Error:", errorMessage)
	end
end

local ReviewsModule = {}
ReviewsModule.SaveReview = saveReview
ReviewsModule.GetReviews = getReviews
ReviewsModule.PrintReviews = printReviews
ReviewsModule.ClearReviews = clearReviews
return ReviewsModule
