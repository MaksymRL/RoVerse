local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local gameScrollingFrame = guisPlaceDetails:WaitForChild("GamesScrollingFrame")
local commentsSection = gameScrollingFrame:WaitForChild("CommentsSection")
local writeSection = commentsSection:WaitForChild("WriteComment")
local commentText = writeSection:WaitForChild("WriteComment")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTrigger = ReplicatedStorage:WaitForChild("SaveCommentRequest")
local SharedIpModule = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))
local buttonSendComment = writeSection:WaitForChild("SendComment")
local buttonCancelComment = writeSection:WaitForChild("CloseComment")

local startPosCommentText = commentText.Position
local startSizeCommentText = commentText.Size
local startSizeWriteSection = writeSection.Size
-- Function that gets called when Enter is pressed
local function onSendButtonClick()
	-- Get the shared place ID by calling the function from the SharedIpModule
	local placeid = SharedIpModule.getSharedData()

	if string.len(commentText.Text) > 0 and string.len(commentText.Text) < 1000 then
		-- Fire the server event with the comment text and the place ID
		ServerTrigger:FireServer(commentText.Text, placeid)
	end
end

local function onTextBoxClick()
	buttonSendComment.Visible = true
	buttonCancelComment.Visible = true
	commentText.Position = UDim2.new(0.031, 0, 0.086, 0)
	commentText.Size = UDim2.new(0.958, 0, 0.574, 0)
	writeSection.Size = UDim2.new(0.959, 0, 0.2, 0)
end

local function onCancelButtonClick()
	buttonSendComment.Visible = false
	buttonCancelComment.Visible = false
	commentText.Position = startPosCommentText
	commentText.Size = startSizeCommentText
	writeSection.Size = startSizeWriteSection
end

buttonCancelComment.MouseButton1Click:Connect(onCancelButtonClick)
commentText.Focused:Connect(onTextBoxClick)

buttonSendComment.MouseButton1Click:Connect(onSendButtonClick)
