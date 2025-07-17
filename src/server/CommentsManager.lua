local DataStoreService = game:GetService("DataStoreService")
local commentsDataStore = DataStoreService:GetDataStore("PlayerComments")

local function saveComment(placeId, playerUser, commentText)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		local existingComments = commentsDataStore:GetAsync(key) or {}

		table.insert(existingComments, {
			text = commentText,
			timestamp = os.time(),
			nickname = playerUser,
		})

		commentsDataStore:SetAsync(key, existingComments)
	end)

	if success then
		print("Comment saved successfully for Place:", placeId, "Player:", playerUser)
	else
		warn("Failed to save comment for Place:", placeId, "Player:", playerUser, "Error:", errorMessage)
	end
end

local function getComments(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, comments = pcall(function()
		return commentsDataStore:GetAsync(key)
	end)

	if success then
		if comments and #comments > 0 then
			return comments
		else
			return {}
		end
	else
		warn("Failed to retrieve comments for Place:", placeId, "Error:", comments)
		return nil, "Error: " .. tostring(comments)
	end
end

local function printComments(placeId)
	local key = "Place_" .. tostring(placeId)
	local success, comments = pcall(function()
		return commentsDataStore:GetAsync(key)
	end)

	if success then
		if comments and #comments > 0 then
			for i, comment in ipairs(comments) do
				local timeAgo = os.time() - comment.timestamp
				local formattedTime = string.format("%d seconds ago", timeAgo)
				print(string.format("[%s] %s: %s", formattedTime, comment.nickname, comment.text))
			end
		else
			print("No comments found for Place:", placeId)
		end
	else
		warn("Failed to retrieve comments for Place:", placeId, "Error:", comments)
	end
end

local function clearComments(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		commentsDataStore:SetAsync(key, {})
	end)

	if success then
		print("All comments cleared for Place:", placeId)
	else
		warn("Failed to clear comments for Place:", placeId, "Error:", errorMessage)
	end
end

local CommentsModule = {}
CommentsModule.SaveComment = saveComment
CommentsModule.GetComments = getComments
CommentsModule.PrintComments = printComments
CommentsModule.ClearComments = clearComments
return CommentsModule
