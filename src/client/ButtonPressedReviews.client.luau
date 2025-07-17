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
			-- Check if it's a TextButton and modify its text if it matches the pattern
			if nestedChild:IsA("TextButton") then
				-- Extract the text between <u> and </u> using string.match
				local extractedText = string.match(nestedChild.Text, "<u>(.-)</u>")
				if extractedText then
					nestedChild.Text = extractedText -- Update the TextButton's text
				end
			end

			-- Check if it's a UIStroke and set its thickness to 0
			if nestedChild:IsA("UIStroke") then
				nestedChild.Thickness = 0
			end
		end
	end

	-- Add <u> around the button's text to underline it
	buttonReviews.Text = "<u>" .. buttonReviews.Text .. "</u>"
	buttonReviews.RichText = true -- Enable RichText so the <u> tag works

	-- Get the UIStroke of the button's parent and set its thickness
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

-- Connect the button click event to the function
buttonReviews.MouseButton1Click:Connect(onButtonClick)
