local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ListDataEvent = ReplicatedStorage:WaitForChild("ListDataEvent")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local launcherGui = playerGui:WaitForChild("LauncherGUI")
if not launcherGui then
	warn("LauncherGUI is missing!")
	return
end
local count = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))

-- Reference the UI elements
local launcherGuisFrame = launcherGui:WaitForChild("GuisPlace")
local launcherGameScrollingFrame = launcherGuisFrame:WaitForChild("GamesScrollingFrame")
local launcherGamesFolder = launcherGameScrollingFrame:WaitForChild("Games")
local launcherGameEntryTemplateFrame = launcherGamesFolder:WaitForChild("GameTemplate")

ListDataEvent.OnClientEvent:Connect(
	function(
		gameName,
		gameDescription,
		gameCreator,
		thumbnailUrl,
		gameVisits,
		gameGenre,
		gameActive,
		placeId,
		gameBookmarks,
		gameRating
	)
		-- Clone the template for the scrolling frame

		local gameEntryClone = launcherGameEntryTemplateFrame:Clone()
		gameEntryClone.Name = gameName .. "_" .. placeId .. "_Entry" -- Unique name for each clone
		gameEntryClone.Parent = launcherGamesFolder -- Set the parent to the scrolling frame
		gameEntryClone.Visible = true -- Ensure the cloned entry is visible
		gameEntryClone.LayoutOrder = count.getSharedCount()
		-- Update the cloned template
		local cloneNameLabel = gameEntryClone:WaitForChild("NameAndCreator")
		local cloneThumbnailImage = gameEntryClone:WaitForChild("Thumbnail")
		local cloneDescriptionLabel = gameEntryClone:WaitForChild("Description")
		local cloneStatsLabel = gameEntryClone:WaitForChild("Stats")
		local firstNewLineIndex = string.find(gameDescription, "\n")

		if firstNewLineIndex then
			if firstNewLineIndex > 80 then
				-- Show only the first 40 characters of the description
				cloneDescriptionLabel.Text = string.sub(gameDescription, 1, 80) .. "..."
			else
				-- Show everything up to the newline
				cloneDescriptionLabel.Text = string.sub(gameDescription, 1, firstNewLineIndex - 1) .. "..."
			end
		else
			if #gameDescription > 80 then
				cloneDescriptionLabel.Text = string.sub(gameDescription, 1, 80) .. "..."
			else
				cloneDescriptionLabel.Text = gameDescription
			end
		end
		cloneStatsLabel.Text = "Active : "
			.. gameActive
			.. " | Visits : "
			.. gameVisits
			.. " | Bookmarked : "
			.. gameBookmarks
			.. " | Genre : "
			.. gameGenre
		cloneNameLabel.Text = gameName .. " | By " .. gameCreator
		cloneThumbnailImage.Image = thumbnailUrl or "rbxassetid://12345678" -- Default image if thumbnailUrl is missing

		local intermediate = count.getSharedCount() + 1
		count.setSharedCount(intermediate)
	end
)
