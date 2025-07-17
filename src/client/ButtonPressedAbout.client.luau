
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local gameScrollingFrame = guisPlaceDetails:WaitForChild("GamesScrollingFrame")
local aboutSection = gameScrollingFrame:WaitForChild("AboutSection")
local gameSections = gameScrollingFrame:WaitForChild("GameSections")
local children = gameSections:GetChildren()
local buttonAbout = gameSections:WaitForChild("About"):WaitForChild("About")

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
	buttonAbout.Text = "<u>" .. buttonAbout.Text .. "</u>"
	buttonAbout.RichText = true  -- Enable RichText so the <u> tag works

	-- Get the UIStroke of the button's parent and set its thickness
	local buttonUIStroke = buttonAbout.Parent:WaitForChild("UIStroke")
	if buttonUIStroke then
		buttonUIStroke.Thickness = 4
	end

	chatsSection.Visible = false
	commentsSection.Visible = false
	reviewsSection.Visible = false
	tutorialsSection.Visible = false
	aboutSection.Visible = true
end

-- Connect the button click event to the function
buttonAbout.MouseButton1Click:Connect(onButtonClick)