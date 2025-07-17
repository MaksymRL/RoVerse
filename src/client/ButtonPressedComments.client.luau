
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local gameScrollingFrame = guisPlaceDetails:WaitForChild("GamesScrollingFrame")
local aboutSection = gameScrollingFrame:WaitForChild("AboutSection")
local gameSections = gameScrollingFrame:WaitForChild("GameSections")
local children = gameSections:GetChildren()
local buttonComments = gameSections:WaitForChild("Comments"):WaitForChild("Comments")

local chatsSection =  gameScrollingFrame:WaitForChild("ChatsSection")
local commentsSection =  gameScrollingFrame:WaitForChild("CommentsSection")
local reviewsSection =  gameScrollingFrame:WaitForChild("ReviewsSection")
local tutorialsSection =  gameScrollingFrame:WaitForChild("TutorialsSection")
local function onButtonClick()
	for _, child in ipairs(children) do
		local nestedChildren = child:GetChildren()
		for _, nestedChild in ipairs(nestedChildren) do
			-- Check if it's a TextButton and modify its text if it matches the pattern
			if nestedChild:IsA("TextButton") then
				-- Extract the text between <u> and </u> using string.match
				local extractedText = string.match(nestedChild.Text, "<u>(.-)</u>")
				if extractedText then
					nestedChild.Text = extractedText  -- Update the TextButton's text
				end
			end

			-- Check if it's a UIStroke and set its thickness to 0
			if nestedChild:IsA("UIStroke") then
				nestedChild.Thickness = 0
			end
		end
	end

	-- Add <u> around the button's text to underline it
	buttonComments.Text = "<u>" .. buttonComments.Text .. "</u>"
	buttonComments.RichText = true  -- Enable RichText so the <u> tag works

	-- Get the UIStroke of the button's parent and set its thickness
	local buttonUIStroke = buttonComments.Parent:WaitForChild("UIStroke")
	if buttonUIStroke then
		buttonUIStroke.Thickness = 4
	end

	chatsSection.Visible = false
	commentsSection.Visible = true
	reviewsSection.Visible = false
	tutorialsSection.Visible = false
	aboutSection.Visible = false
end

-- Connect the button click event to the function
buttonComments.MouseButton1Click:Connect(onButtonClick)