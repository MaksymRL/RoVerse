local DataStoreService = game:GetService("DataStoreService")
local replyCommentsDataStore = DataStoreService:GetDataStore("PlayerReplyComments")

local function saveReplyComment(placeId, playerUser, commentText, commentName, replyto)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		local existingComments = replyCommentsDataStore:GetAsync(key) or {}

		table.insert(existingComments, {
			text = commentText,
			timestamp = os.time(),
			nickname = playerUser,
			name = commentName,
			replyTo = replyto,
		})

		replyCommentsDataStore:SetAsync(key, existingComments)
	end)

	if success then
		print("Comment saved successfully for Place:", placeId, "Player:", playerUser)
	else
		warn("Failed to save comment for Place:", placeId, "Player:", playerUser, "Error:", errorMessage)
	end
end

local function getReplyComments(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, comments = pcall(function()
		return replyCommentsDataStore:GetAsync(key)
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

local function printReplyComments(placeId)
	local key = "Place_" .. tostring(placeId)
	local success, comments = pcall(function()
		return replyCommentsDataStore:GetAsync(key)
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

local function clearReplyComments(placeId)
	local key = "Place_" .. tostring(placeId)

	local success, errorMessage = pcall(function()
		replyCommentsDataStore:SetAsync(key, {})
	end)

	if success then
		print("All comments cleared for Place:", placeId)
	else
		warn("Failed to clear comments for Place:", placeId, "Error:", errorMessage)
	end
end

local CommentsModule = {}
CommentsModule.SaveReplyComment = saveReplyComment
CommentsModule.GetReplyComments = getReplyComments
CommentsModule.PrintReplyComments = printReplyComments
CommentsModule.ClearReplyComments = clearReplyComments
return CommentsModule
