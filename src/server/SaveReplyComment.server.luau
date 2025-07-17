local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveReplyCommentRequest")
local replyCommentManager = require(game.ServerScriptService.Server:WaitForChild("ReplyCommentsManager"))

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

	replyCommentManager.SaveReplyComment(placeid, player.Name, comment, commentName, replyto)
	replyCommentManager.PrintReplyComments(placeid, player.Name)
end)
