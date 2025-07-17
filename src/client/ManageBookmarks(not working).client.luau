local button = script.Parent
local scrollingframebookmarks = button.Parent.Parent:WaitForChild("ScrollingFrameBookmarks")
local pressed = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BookmarksDataEvent = ReplicatedStorage:WaitForChild("BookmarksDataEvent")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local frameBookmarks = scrollingframebookmarks:WaitForChild("Bookmark")
local keepNames = { "Bookmark", "UIListLayout" }

BookmarksDataEvent.OnClientEvent:Connect(function(gameName, thumbnailUrl, placeId)
	print("Received game data from server")

	local gameEntryClone = frameBookmarks:Clone()
	gameEntryClone.Name = gameName .. "_" .. placeId .. "_Entry"
	gameEntryClone.Parent = scrollingframebookmarks
	gameEntryClone.Visible = true

	local cloneNameLabel = gameEntryClone:WaitForChild("Name")
	local cloneThumbnailImage = gameEntryClone:WaitForChild("Thumbnail")
	cloneNameLabel.Text = gameName
	cloneThumbnailImage.Image = thumbnailUrl or "rbxassetid://12345678"

	print("Added game:", gameName)
end)

button.MouseButton1Click:Connect(function()
	if pressed then
		print("Hiding bookmarks")
		pressed = false
		scrollingframebookmarks.Visible = false

		for _, child in pairs(scrollingframebookmarks:GetChildren()) do
			if not table.find(keepNames, child.Name) then
				child:Destroy()
			end
		end
	else
		print("Showing bookmarks")
		pressed = true
		scrollingframebookmarks.Visible = true

		BookmarksDataEvent:FireServer()
	end
end)
