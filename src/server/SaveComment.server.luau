local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveCommentRequest")
local commentManager = require(game.ServerScriptService.Server:WaitForChild("CommentsManager"))

ServerTriggerEvent.OnServerEvent:Connect(function(player, comment, placeid)
	print(player.Name .. " triggered the event with comment: " .. tostring(comment))

	commentManager.SaveComment(placeid, player.DisplayName, comment)
	commentManager.PrintComments(placeid, player.DisplayName)
end)
