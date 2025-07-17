local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local gameScrollingFrame = guisPlaceDetails:WaitForChild("GamesScrollingFrame")
local reviewsSection = gameScrollingFrame:WaitForChild("ReviewsSection")
local topFrameReview = reviewsSection:WaitForChild("TopFrame")
local newReviewButton = topFrameReview:WaitForChild("NewReviewButtonFrame"):WaitForChild("NewReviewButton")
local newReviewFrame = guisPlaceDetails:WaitForChild("NewReviewFrame")
local reviewText = newReviewFrame:WaitForChild("Review"):WaitForChild("ReviewContent")
local reviewTitle = newReviewFrame:WaitForChild("ReviewTitle"):WaitForChild("ReviewTitleContent")
local reviewRating = newReviewFrame:WaitForChild("Rating")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTrigger = ReplicatedStorage:WaitForChild("SaveReviewRequest")
local SharedIpModule = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))
local buttonSendReview = newReviewFrame:WaitForChild("SubmitReview")
local buttonCancelReview = newReviewFrame:WaitForChild("CancelReview")
local reviewStarOne = reviewRating:WaitForChild("RatingFrame"):WaitForChild("StarOne")
local reviewStarTwo = reviewRating:WaitForChild("RatingFrame"):WaitForChild("StarTwo")
local reviewStarThree = reviewRating:WaitForChild("RatingFrame"):WaitForChild("StarThree")
local reviewStarFour = reviewRating:WaitForChild("RatingFrame"):WaitForChild("StarFour")
local reviewStarFive = reviewRating:WaitForChild("RatingFrame"):WaitForChild("StarFive")

local function onSendButtonClick()
	local placeid = SharedIpModule.getSharedData()
	local rating
	if reviewStarFive.Image == "rbxassetid://95720319646844" then
		rating = 5
	elseif reviewStarFour.Image == "rbxassetid://95720319646844" then
		rating = 4
	elseif reviewStarThree.Image == "rbxassetid://95720319646844" then
		rating = 3
	elseif reviewStarTwo.Image == "rbxassetid://95720319646844" then
		rating = 2
	elseif reviewStarOne.Image == "rbxassetid://95720319646844" then
		rating = 1
	else
		rating = 1
		print("Missing Rating!")
	end

	if string.len(reviewText.Text) > 0 and string.len(reviewText.Text) < 1000 then
		ServerTrigger:FireServer(reviewText.Text, placeid, reviewTitle.Text, rating)
	end
end

local function onCancelButtonClick()
	gameScrollingFrame.Visible = true
	newReviewFrame.Visible = false
	gameScrollingFrame.ScrollingEnabled = true
end

buttonCancelReview.MouseButton1Click:Connect(onCancelButtonClick)

buttonSendReview.MouseButton1Click:Connect(onSendButtonClick)
