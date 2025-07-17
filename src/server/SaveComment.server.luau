local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("SaveCommentRequest")
local commentManager = require(game.ServerScriptService.Server:WaitForChild("CommentsManager"))

-- Function to handle the event and save the comment
ServerTriggerEvent.OnServerEvent:Connect(function(player, comment, placeid)
	print(player.Name .. " triggered the event with comment: " .. tostring(comment))

	-- Ensure the SaveComment function matches your expected parameters
	commentManager.SaveComment(placeid, player.DisplayName, comment) -- Adjusted to pass player.UserId
	commentManager.PrintComments(placeid, player.DisplayName)
end)
