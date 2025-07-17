local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local newReviewFrame = guisPlaceDetails:WaitForChild("NewReviewFrame")
local RatingStarsFrame = newReviewFrame:WaitForChild("Rating"):WaitForChild("RatingFrame")
local StarOneButton = RatingStarsFrame:WaitForChild("StarOne")
local StarTwoButton = RatingStarsFrame:WaitForChild("StarTwo")
local StarThreeButton = RatingStarsFrame:WaitForChild("StarThree")
local StarFourButton = RatingStarsFrame:WaitForChild("StarFour")
local StarFiveButton = RatingStarsFrame:WaitForChild("StarFive")


local function onStarOneClicked()
	StarOneButton.Image = "rbxassetid://72488721749777"
	StarTwoButton.Image = "rbxassetid://95720319646844"
	StarThreeButton.Image = "rbxassetid://95720319646844"
	StarFourButton.Image ="rbxassetid://95720319646844"
	StarFiveButton.Image ="rbxassetid://95720319646844"
end

local function onStarTwoClicked()
	StarOneButton.Image = "rbxassetid://72488721749777"
	StarTwoButton.Image = "rbxassetid://72488721749777"
	StarThreeButton.Image = "rbxassetid://95720319646844"
	StarFourButton.Image ="rbxassetid://95720319646844"
	StarFiveButton.Image ="rbxassetid://95720319646844"
end

local function onStarThreeClicked()
	StarOneButton.Image = "rbxassetid://72488721749777"
	StarTwoButton.Image = "rbxassetid://72488721749777"
	StarThreeButton.Image = "rbxassetid://72488721749777"
	StarFourButton.Image ="rbxassetid://95720319646844"
	StarFiveButton.Image ="rbxassetid://95720319646844"
end

local function onStarFourClicked()
	StarOneButton.Image = "rbxassetid://72488721749777"
	StarTwoButton.Image = "rbxassetid://72488721749777"
	StarThreeButton.Image = "rbxassetid://72488721749777"
	StarFourButton.Image ="rbxassetid://72488721749777"
	StarFiveButton.Image ="rbxassetid://95720319646844"
end

local function onStarFiveClicked()
	StarOneButton.Image = "rbxassetid://72488721749777"
	StarTwoButton.Image = "rbxassetid://72488721749777"
	StarThreeButton.Image = "rbxassetid://72488721749777"
	StarFourButton.Image ="rbxassetid://72488721749777"
	StarFiveButton.Image ="rbxassetid://72488721749777"
end

StarOneButton.MouseButton1Click:Connect(onStarOneClicked)

StarTwoButton.MouseButton1Click:Connect(onStarTwoClicked)

StarThreeButton.MouseButton1Click:Connect(onStarThreeClicked)

StarFourButton.MouseButton1Click:Connect(onStarFourClicked)

StarFiveButton.MouseButton1Click:Connect(onStarFiveClicked)

