local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveReplyCommentRequest")
local replyCommentManager = require(game.ServerScriptService.Server:WaitForChild("ReplyCommentsManager"))

-- Function to handle the event and save the comment
ServerTriggerEvent.OnServerEvent:Connect(function(player, comment, placeid, commentName, replyto)
	print(player.Name .. " triggered the event with comment: " .. tostring(comment))
	print(
		"Player name : "
			.. player.Name
			.. "Comment :"
			.. comment
			.. "placeid : "
			.. placeid
			.. "CommentName : "
			.. commentName
			.. "Reply To :"
			.. replyto
	)
	-- Ensure the SaveComment function matches your expected parameters
	replyCommentManager.SaveReplyComment(placeid, player.Name, comment, commentName, replyto) -- Adjusted to pass player.UserId
	replyCommentManager.PrintReplyComments(placeid, player.Name)
end)
