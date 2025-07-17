local button = script.Parent
local scrollingframebookmarks = button.Parent.Parent:WaitForChild("ScrollingFrameBookmarks")
local pressed = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BookmarksDataEvent = ReplicatedStorage:WaitForChild("BookmarksDataEvent") -- Ensure the event matches the server
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local frameBookmarks = scrollingframebookmarks:WaitForChild("Bookmark")
local keepNames = { "Bookmark", "UIListLayout" }
-- Ensure this connection happens once
BookmarksDataEvent.OnClientEvent:Connect(function(gameName, thumbnailUrl, placeId)
	print("Received game data from server")

	-- Clone the template for the scrolling frame
	local gameEntryClone = frameBookmarks:Clone()
	gameEntryClone.Name = gameName .. "_" .. placeId .. "_Entry" -- Unique name for each clone
	gameEntryClone.Parent = scrollingframebookmarks -- Set the parent to the scrolling frame
	gameEntryClone.Visible = true -- Ensure the cloned entry is visible

	-- Update the cloned template
	local cloneNameLabel = gameEntryClone:WaitForChild("Name")
	local cloneThumbnailImage = gameEntryClone:WaitForChild("Thumbnail")
	cloneNameLabel.Text = gameName
	cloneThumbnailImage.Image = thumbnailUrl or "rbxassetid://12345678" -- Default image if thumbnailUrl is missing

	print("Added game:", gameName)
end)

button.MouseButton1Click:Connect(function()
	if pressed then
		print("Hiding bookmarks")
		pressed = false
		scrollingframebookmarks.Visible = false
		
		for _, child in pairs(scrollingframebookmarks:GetChildren()) do
			-- Check if the child's name is NOT in the keepNames list
			if not table.find(keepNames, child.Name) then
				child:Destroy() -- Remove the child
			end
		end
	else
		print("Showing bookmarks")
		pressed = true
		scrollingframebookmarks.Visible = true

		-- Fire the event to request data (only once)
		BookmarksDataEvent:FireServer()
	end
end)

