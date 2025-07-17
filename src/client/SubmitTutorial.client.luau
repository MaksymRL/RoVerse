local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local gameScrollingFrame = guisPlaceDetails:WaitForChild("GamesScrollingFrame")
local tutorialsSection = gameScrollingFrame:WaitForChild("TutorialsSection")
local topFrameTutorials = tutorialsSection:WaitForChild("TopFrame")
local newTutorialButton = topFrameTutorials:WaitForChild("NewTutorialButtonFrame"):WaitForChild("NewTutorialButton")
local newTutorialFrame = guisPlaceDetails:WaitForChild("NewTutorialFrame")
local tutorialText = newTutorialFrame:WaitForChild("Tutorial"):WaitForChild("TutorialContent")
local tutorialTitle = newTutorialFrame:WaitForChild("TutorialTitle"):WaitForChild("TutorialTitleContent")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerTrigger = ReplicatedStorage:WaitForChild("SaveTutorialRequest")
local SharedIpModule = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))
local buttonSendTutorial = newTutorialFrame:WaitForChild("SubmitTutorial")
local buttonCancelTutorial = newTutorialFrame:WaitForChild("CancelTutorial")

local function onSendButtonClick()
	local placeid = SharedIpModule.getSharedData()

	if string.len(tutorialText.Text) > 0 and string.len(tutorialText.Text) < 1000 then
		ServerTrigger:FireServer(tutorialText.Text, placeid, tutorialTitle.Text)
	end
end

local function onCancelButtonClick()
	gameScrollingFrame.Visible = true
	newTutorialFrame.Visible = false
	gameScrollingFrame.ScrollingEnabled = true
end

buttonCancelTutorial.MouseButton1Click:Connect(onCancelButtonClick)

buttonSendTutorial.MouseButton1Click:Connect(onSendButtonClick)
