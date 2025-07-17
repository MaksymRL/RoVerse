-- Get the necessary services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local Guis = launcherGui:WaitForChild("GuisPlace")
local topBar = Guis:WaitForChild("TopBar")
local sectionBar = topBar:WaitForChild("SectionBar")
local myButton = sectionBar:WaitForChild("Places")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("ListDataEvent")
local clicked = false
local pageLayout = launcherGui:WaitForChild("UIPageLayout")
local gameScrollingFrame = Guis:WaitForChild("GamesScrollingFrame")
local ManageBar =  Guis:WaitForChild("ManageBar")
local LoadingFrame = Guis:WaitForChild("Loading")
local LoadingStopRequest = ReplicatedStorage:WaitForChild("LoadingStopRequest")
-- Function to handle the button click event
local function onButtonClick()
	if clicked == false then
		
		ServerTriggerEvent:FireServer(1,"Name")
		clicked = true
		LoadingFrame.Visible = true
		
	else
		pageLayout:Previous()
	end
	
end

local function stopLoading()
	LoadingFrame.Visible = false
	gameScrollingFrame.Visible = true
	ManageBar.Visible = true
end
-- Listen for the button click event
myButton.MouseButton1Click:Connect(onButtonClick)  -- Detects left-click on the button
LoadingStopRequest.OnClientEvent:Connect(stopLoading)