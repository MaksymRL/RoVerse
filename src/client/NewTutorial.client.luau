
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlaceDetails = launcherGui:WaitForChild("GuisPlaceDetails")
local gameScrollingFrame = guisPlaceDetails:WaitForChild("GamesScrollingFrame")
local tutorialsSectionFrame = gameScrollingFrame:WaitForChild("TutorialsSection")
local topFrameTutorials = tutorialsSectionFrame:WaitForChild("TopFrame")
local newTutorialButtonFrame = topFrameTutorials:WaitForChild("NewTutorialButtonFrame")
local newTutorialButton = newTutorialButtonFrame:WaitForChild("NewTutorialButton")
local newTutorialFrame = guisPlaceDetails:WaitForChild("NewTutorialFrame")




local function OnNewTutorialClicked()
	gameScrollingFrame.Visible = false
	newTutorialFrame.Visible = true
	gameScrollingFrame.ScrollingEnabled = false
end



newTutorialButton.MouseButton1Click:Connect(OnNewTutorialClicked)
