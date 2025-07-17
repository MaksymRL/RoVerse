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
		local gameEntryClone = launcherGameEntryTemplateFrame:Clone()
		gameEntryClone.Name = gameName .. "_" .. placeId .. "_Entry"
		gameEntryClone.Parent = launcherGamesFolder
		gameEntryClone.Visible = true
		gameEntryClone.LayoutOrder = count.getSharedCount()

		local cloneNameLabel = gameEntryClone:WaitForChild("NameAndCreator")
		local cloneThumbnailImage = gameEntryClone:WaitForChild("Thumbnail")
		local cloneDescriptionLabel = gameEntryClone:WaitForChild("Description")
		local cloneStatsLabel = gameEntryClone:WaitForChild("Stats")
		local firstNewLineIndex = string.find(gameDescription, "\n")

		if firstNewLineIndex then
			if firstNewLineIndex > 80 then
				cloneDescriptionLabel.Text = string.sub(gameDescription, 1, 80) .. "..."
			else
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
		cloneThumbnailImage.Image = thumbnailUrl or "rbxassetid://12345678"

		local intermediate = count.getSharedCount() + 1
		count.setSharedCount(intermediate)
	end
)
