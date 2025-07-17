
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local gameScrollingFrame = guisPlaceDetails:WaitForChild("GamesScrollingFrame")
local reviewsSectionFrame = gameScrollingFrame:WaitForChild("ReviewsSection")
local topFrameReview = reviewsSectionFrame:WaitForChild("TopFrame")
local newReviewButtonFrame = topFrameReview:WaitForChild("NewReviewButtonFrame")
local newReviewButton = newReviewButtonFrame:WaitForChild("NewReviewButton")
local newReviewFrame = guisPlaceDetails:WaitForChild("NewReviewFrame")




local function OnNewReviewClicked()
	gameScrollingFrame.Visible = false
	newReviewFrame.Visible = true
	gameScrollingFrame.ScrollingEnabled = false
end



newReviewButton.MouseButton1Click:Connect(OnNewReviewClicked)