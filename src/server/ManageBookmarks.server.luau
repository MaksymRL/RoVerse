local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("AddBookmarkRequest")
local bookmarksManager = require(game.ServerScriptService:WaitForChild("BookmarksManager"))

ServerTriggerEvent.OnServerEvent:Connect(function(player, data, salva)
	if salva == true then
		bookmarksManager.AddPlaceId(data)
		bookmarksManager.PrintPlaceIds()
	end
end)

ServerTriggerEvent.OnServerEvent:Connect(function(player, data, salva)
	if salva == false then
		bookmarksManager.RemovePlaceId(data)
		bookmarksManager.PrintPlaceIds()
	end
end)
