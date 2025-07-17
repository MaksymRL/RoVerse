local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CommentsDataEvent = ReplicatedStorage:WaitForChild("CommentsDataEvent")
local ReplyCommentsDataEvent = ReplicatedStorage:WaitForChild("ReplyCommentDataEvent")
-- Function to send game data to client
local function sendGameDataToClient(player, comment)
	local text = comment.text
	local nickname = comment.nickname
	local currentTime = os.time()
	local timeDifference = os.difftime(currentTime, comment.timestamp)
	print(text)
	print(nickname)
	print(timeDifference)

	-- Convert the time difference into a readable format (seconds, minutes, hours, days)
	local timeString
	if timeDifference < 60 then
		timeString = string.format("%d seconds ago", timeDifference)
	elseif timeDifference < 3600 then
		timeString = string.format("%d minutes ago", math.floor(timeDifference / 60))
	elseif timeDifference < 86400 then
		timeString = string.format("%d hours ago", math.floor(timeDifference / 3600))
	else
		timeString = string.format("%d days ago", math.floor(timeDifference / 86400))
	end

	-- Check if the player is still in the game
	if player and player.Parent then
		print("Whjauhrqurwhq")
		CommentsDataEvent:FireClient(player, text, nickname, timeString, comment.timestamp)
	end
end

local function sendReplyCommentGameDataToClient(player, comment)
	local text = comment.text
	local nickname = comment.nickname
	local currentTime = os.time()
	local timeDifference = os.difftime(currentTime, comment.timestamp)
	print(text)
	print(nickname)
	print(timeDifference)
	local commentToReply = comment.name

	-- Convert the time difference into a readable format (seconds, minutes, hours, days)
	local timeString
	if timeDifference < 60 then
		timeString = string.format("%d seconds ago", timeDifference)
	elseif timeDifference < 3600 then
		timeString = string.format("%d minutes ago", math.floor(timeDifference / 60))
	elseif timeDifference < 86400 then
		timeString = string.format("%d hours ago", math.floor(timeDifference / 3600))
	else
		timeString = string.format("%d days ago", math.floor(timeDifference / 86400))
	end

	-- Check if the player is still in the game
	if player and player.Parent then
		print("Whjauhrqurwhq")
		ReplyCommentsDataEvent:FireClient(
			player,
			text,
			nickname,
			timeString,
			comment.timestamp,
			comment.name,
			comment.replyTo
		)
	end
end

CommentsDataEvent.OnServerEvent:Connect(function(player, placeId)
	local commentsManager = require(game.ServerScriptService.Server:WaitForChild("CommentsManager"))

	-- Ensure data is loaded
	commentsManager.PrintComments(placeId, player.DisplayName)
	print("Fetching comments...")
	local arrayComments = commentsManager.GetComments(placeId, player.DisplayName)
	print("Comments count: " .. #arrayComments)

	-- Send each comment to the client
	for i, comment in ipairs(arrayComments) do
		task.wait(0.5) -- Avoid overwhelming the client
		if not player or not player.Parent then
			print("Player left during data transmission")
			break
		end
		-- Send comment data to the client
		sendGameDataToClient(player, comment)
	end

	-- Send reply comments if necessary
	local replyCommentsManager = require(game.ServerScriptService.Server:WaitForChild("ReplyCommentsManager"))

	local replyArrayComments = replyCommentsManager.GetReplyComments(placeId, player.Name)
	for i, comment in ipairs(replyArrayComments) do
		task.wait(0.5) -- Avoid overwhelming the client
		if not player or not player.Parent then
			print("Player left during data transmission")
			break
		end
		-- Send reply comment data to the client
		sendReplyCommentGameDataToClient(player, comment)
	end
end)
