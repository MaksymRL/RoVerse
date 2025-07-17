local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui.GuisPlaceDetails
local gameScrollingFrame = guisPlaceDetails.GamesScrollingFrame
local aboutSection = gameScrollingFrame.AboutSection
local gameSections = gameScrollingFrame.GameSections
local children = gameSections:GetChildren()
local buttonTutorials = gameSections.Tutorials.Tutorials

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

	buttonTutorials.Text = "<u>" .. buttonTutorials.Text .. "</u>"
	buttonTutorials.RichText = true

	local buttonUIStroke = buttonTutorials.Parent.UIStroke
	if buttonUIStroke then
		buttonUIStroke.Thickness = 4
	end

	chatsSection.Visible = false
	commentsSection.Visible = false
	reviewsSection.Visible = false
	tutorialsSection.Visible = true
	aboutSection.Visible = false
end

buttonTutorials.MouseButton1Click:Connect(onButtonClick)
