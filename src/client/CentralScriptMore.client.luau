local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Guis = launcherGui:WaitForChild("GuisPlaceDetails")
local GameScrollingFrame = Guis:WaitForChild("GamesScrollingFrame")
local DetailsDataEvent = ReplicatedStorage:WaitForChild("DetailsDataEvent")
local CommentsDataEvent = ReplicatedStorage:WaitForChild("CommentsDataEvent")

local DescriptionFrame = GameScrollingFrame:WaitForChild("AboutSection"):WaitForChild("Description")
local GameStats = GameScrollingFrame:WaitForChild("AboutSection"):WaitForChild("GameStats")
local ThumbnailFrame = GameScrollingFrame:WaitForChild("ThumbnailFrame")

local GameName = ThumbnailFrame:WaitForChild("GameName")
local Description = DescriptionFrame:WaitForChild("DescriptionValueContainer"):WaitForChild("DescriptionValue")
local Thumbnail = ThumbnailFrame:WaitForChild("Thumbnail")
local ThumbnailBackground = ThumbnailFrame:WaitForChild("BackgroundImage")
local Active = GameStats:WaitForChild("Active"):WaitForChild("ActiveValue")
local Camera = GameStats:WaitForChild("Camera"):WaitForChild("CameraValue")
local CreatedDate = GameStats:WaitForChild("CreatedDate"):WaitForChild("CreationValue")
local Favorites = GameStats:WaitForChild("Favorites"):WaitForChild("FavoritesValue")
local Genre = GameStats:WaitForChild("Genre"):WaitForChild("GenreValue")
local ServerSize = GameStats:WaitForChild("ServerSize"):WaitForChild("ServerSizeValue")
local UpdatedDate = GameStats:WaitForChild("UpdatedDate"):WaitForChild("UpdatedValue")
local Visits = GameStats:WaitForChild("Visits"):WaitForChild("VisitsValue")
local VoiceChat = GameStats:WaitForChild("VoiceChat"):WaitForChild("VoiceChatValue")
local CommentsScrollingFrame = GameScrollingFrame:WaitForChild("CommentsSection"):WaitForChild("CommentsScrollingFrame")
local CommentTemplate = CommentsScrollingFrame:WaitForChild("Comment")
local Count = 0
local ReplyCommentsDataEvent = ReplicatedStorage:WaitForChild("ReplyCommentDataEvent")
local ReplyCommentTemplate = CommentsScrollingFrame:WaitForChild("ReplyCommentTemplate")
local ReviewsDataEvent = ReplicatedStorage:WaitForChild("ReviewDataEvent")
local ReviewSection = GameScrollingFrame:WaitForChild("ReviewsSection")
local ReviewFolder = ReviewSection:WaitForChild("ReviewsScrollingFrame")
local ReviewTemplate = ReviewFolder:WaitForChild("ReviewFrame")
local TutorialsDataEvent = ReplicatedStorage:WaitForChild("TutorialDataEvent")
local TutorialsSection = GameScrollingFrame:WaitForChild("TutorialsSection")
local TutorialsFolder = TutorialsSection:WaitForChild("TutorialsScrollingFrame")
local TutorialTemplate = TutorialsFolder:WaitForChild("TutorialFrame")

local function formatDate(dateString)
	return string.sub(dateString, 6, 7) .. "/" .. string.sub(dateString, 9, 10) .. "/" .. string.sub(dateString, 1, 4)
end

local commentsArray = {}

local function updateGameDetails(data)
	GameName.Text = data.gameName or "Unknown"
	Description.Text = data.gameDescription or "No description available."
	Thumbnail.Image = data.thumbnailUrl
	ThumbnailBackground.Image = data.thumbnailUrl
	Active.Text = data.gameActive or "N/A"
	Camera.Text = data.gameCamera or "N/A"
	CreatedDate.Text = formatDate(data.gameCreated) or "N/A"
	Favorites.Text = data.gameFavorites or "N/A"
	Genre.Text = data.gameGenre or "N/A"
	ServerSize.Text = data.gameServerSize or "N/A"
	UpdatedDate.Text = formatDate(data.gameUpdated) or "N/A"
	Visits.Text = data.gameVisits or "N/A"
	VoiceChat.Text = data.gameVoiceChat or "N/A"
	print(CreatedDate.Text)
	print(UpdatedDate.Text)
end

CommentsDataEvent.OnClientEvent:Connect(function(text, nickname, timediff, actualtimestamp)
	local gameEntryClone = CommentTemplate:Clone()
	gameEntryClone.Parent = CommentsScrollingFrame
	gameEntryClone.Visible = true
	gameEntryClone.Name = "Comment_"
		.. nickname:gsub("_", "")
		.. "_"
		.. string.sub(text, 1, 20):gsub("_", "")
		.. "_"
		.. actualtimestamp
	gameEntryClone.LayoutOrder = gameEntryClone.LayoutOrder + Count
	local commentText = gameEntryClone:WaitForChild("CommentText")
	local Nickname = gameEntryClone:WaitForChild("Nickname")
	local TimeAgo = gameEntryClone:WaitForChild("TimeAgo")

	commentText.Text = text
	Nickname.Text = nickname
	TimeAgo.Text = timediff
	Count += 1

	print("Count: " .. Count)
end)

DetailsDataEvent.OnClientEvent:Connect(updateGameDetails)

ReplyCommentsDataEvent.OnClientEvent:Connect(
	function(text, nickname, timediff, actualtimestamp, commentToReply, replyTo)
		local gameEntryClone = CommentTemplate:Clone()
		gameEntryClone.Parent = CommentsScrollingFrame
		gameEntryClone.Visible = true
		gameEntryClone.Name = "Comment_"
			.. nickname:gsub("_", "")
			.. "_"
			.. string.sub(text, 1, 20):gsub("_", "")
			.. "_"
			.. actualtimestamp

		local childToReplyTo = CommentsScrollingFrame:FindFirstChild(commentToReply)
		if childToReplyTo then
			gameEntryClone.LayoutOrder = childToReplyTo.LayoutOrder
		else
			gameEntryClone.LayoutOrder = #CommentsScrollingFrame:GetChildren() + 1
		end

		gameEntryClone.BackgroundTransparency = 0
		local commentText = gameEntryClone:WaitForChild("CommentText")
		local Nickname = gameEntryClone:WaitForChild("Nickname")
		local TimeAgo = gameEntryClone:WaitForChild("TimeAgo")

		commentText.Text = "@" .. replyTo .. " " .. text
		Nickname.Text = nickname
		TimeAgo.Text = timediff
	end
)

ReviewsDataEvent.OnClientEvent:Connect(
	function(reviewText, nickname, timediff, actualtimestamp, reviewTitle, reviewRating)
		local reviewClone = ReviewTemplate:Clone()
		reviewClone.Visible = true
		reviewClone.Parent = ReviewFolder
		reviewClone.Name = "Review_"
			.. nickname:gsub("_", "")
			.. "_"
			.. string.sub(reviewText, 1, 20):gsub("_", "")
			.. "_"
			.. actualtimestamp
		reviewClone.LayoutOrder = reviewClone.LayoutOrder + Count

		local UserNickname = reviewClone:WaitForChild("Nickname")
		UserNickname.Text = nickname
		local Title = reviewClone:WaitForChild("Title")
		Title.Text = reviewTitle
		local ReviewText = reviewClone:WaitForChild("ReviewText")
		ReviewText.Text = reviewText
		local TimeAgo = reviewClone:WaitForChild("TimeAgo")
		TimeAgo.Text = timediff
		local Rating = reviewClone:WaitForChild("RatingAmount")
		Rating.Text = reviewRating * 2 .. "/10" .. "Final Rating"
	end
)

TutorialsDataEvent.OnClientEvent:Connect(function(tutorialText, nickname, timediff, actualtimestamp, tutorialTitle)
	local tutorialClone = TutorialTemplate:Clone()
	tutorialClone.Visible = true
	tutorialClone.Parent = TutorialsFolder
	tutorialClone.Name = "Tutorial_"
		.. nickname:gsub("_", "")
		.. "_"
		.. string.sub(tutorialText, 1, 20):gsub("_", "")
		.. "_"
		.. actualtimestamp
	tutorialClone.LayoutOrder = tutorialClone.LayoutOrder + Count

	local UserNickname = tutorialClone:WaitForChild("Nickname")
	UserNickname.Text = nickname
	local Title = tutorialClone:WaitForChild("Title")
	Title.Text = tutorialTitle
	local TutorialText = tutorialClone:WaitForChild("TutorialText")
	TutorialText.Text = tutorialText
	local TimeAgo = tutorialClone:WaitForChild("TimeAgo")
	TimeAgo.Text = timediff
end)
