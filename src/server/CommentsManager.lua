local DataStoreService = game:GetService("DataStoreService")
local commentsDataStore = DataStoreService:GetDataStore("PlayerComments")

-- Function to save a comment for a player in a specific game
local function saveComment(placeId, playerUser, commentText)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, errorMessage = pcall(function()
		-- Load existing comments for this place
		local existingComments = commentsDataStore:GetAsync(key) or {}

		-- Add the new comment with a timestamp
		table.insert(existingComments, {
			text = commentText,
			timestamp = os.time(), -- Save the time of the comment
			nickname = playerUser
		})

		-- Save updated comments back to the DataStore
		commentsDataStore:SetAsync(key, existingComments)
	end)

	if success then
		print("Comment saved successfully for Place:", placeId, "Player:", playerUser)
	else
		warn("Failed to save comment for Place:", placeId, "Player:", playerUser, "Error:", errorMessage)
	end
end

-- Function to get all comments for a specific game (place)
local function getComments(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, comments = pcall(function()
		return commentsDataStore:GetAsync(key)
	end)

	if success then
		if comments and #comments > 0 then
			-- Return the comments data
			return comments
		else
			-- Return an empty table if no comments are found
			return {}
		end
	else
		warn("Failed to retrieve comments for Place:", placeId, "Error:", comments)
		return nil, "Error: " .. tostring(comments) -- Return nil and an error message
	end
end

-- Function to print all comments for a specific game (place)
local function printComments(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)
	local success, comments = pcall(function()
		return commentsDataStore:GetAsync(key)
	end)

	if success then
		if comments and #comments > 0 then
			-- Iterate through comments and print each one
			for i, comment in ipairs(comments) do
				local timeAgo = os.time() - comment.timestamp
				local formattedTime = string.format("%d seconds ago", timeAgo) -- You can customize the time format
				print(string.format("[%s] %s: %s", formattedTime, comment.nickname, comment.text))
			end
		else
			print("No comments found for Place:", placeId)
		end
	else
		warn("Failed to retrieve comments for Place:", placeId, "Error:", comments)
	end
end

-- Function to clear all comments for a specific game (place)
local function clearComments(placeId)
	local key = "Place_" .. tostring(placeId) -- Unique key per game (place)

	local success, errorMessage = pcall(function()
		-- Set the comments array to empty
		commentsDataStore:SetAsync(key, {})
	end)

	if success then
		print("All comments cleared for Place:", placeId)
	else
		warn("Failed to clear comments for Place:", placeId, "Error:", errorMessage)
	end
end

-- Export functions for external access
local CommentsModule = {}
CommentsModule.SaveComment = saveComment
CommentsModule.GetComments = getComments
CommentsModule.PrintComments = printComments
CommentsModule.ClearComments = clearComments
return CommentsModule




