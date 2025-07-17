local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui.GuisPlaceDetails
local gameScrollingFrame = guisPlaceDetails.GamesScrollingFrame
local aboutSection = gameScrollingFrame.AboutSection
local gameSections = gameScrollingFrame.GameSections
local children = gameSections:GetChildren()
local buttonReviews = gameSections.Reviews.Reviews

local chatsSection = gameScrollingFrame.ChatsSection
local commentsSection = gameScrollingFrame.CommentsSection
local reviewsSection = gameScrollingFrame.ReviewsSection
local tutorialsSection = gameScrollingFrame.TutorialsSection
local function onButtonClick()
	for _, child in ipairs(children) do
		local nestedChildren = child:GetChildren()
		for _, nestedChild in ipairs(nestedChildren) do
			if nestedChild:IsA("TextButton") then
				local extractedText = string.match(nestedChild.Text, "<u>(.-)</u>")
				if extractedText then
					nestedChild.Text = extractedText
				end
			end

			if nestedChild:IsA("UIStroke") then
				nestedChild.Thickness = 0
			end
		end
	end

	buttonReviews.Text = "<u>" .. buttonReviews.Text .. "</u>"
	buttonReviews.RichText = true

	local buttonUIStroke = buttonReviews.Parent.UIStroke
	if buttonUIStroke then
		buttonUIStroke.Thickness = 4
	end

	chatsSection.Visible = false
	commentsSection.Visible = false
	reviewsSection.Visible = true
	tutorialsSection.Visible = false
	aboutSection.Visible = false
end

buttonReviews.MouseButton1Click:Connect(onButtonClick)
