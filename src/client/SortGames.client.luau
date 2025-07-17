local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local launcherGui = PlayerGui:WaitForChild("LauncherGUI")
local guisPlace = launcherGui:WaitForChild("GuisPlace")
local ManageBar = guisPlace:WaitForChild("ManageBar")
local sortFrame = ManageBar:WaitForChild("SortFrame")
local mainButton = sortFrame:WaitForChild("SortTextButton")
local dropdownMenu = sortFrame:WaitForChild("ScrollingFrame")
local fontFace =
	Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
dropdownMenu.Visible = false
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ListDataEvent = ReplicatedStorage:WaitForChild("ListDataEvent")
local count = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))
local gameScrollingFrame = guisPlace:WaitForChild("GamesScrollingFrame")
local LoadingFrame = guisPlace:WaitForChild("Loading")

local function SortGamesBasedOn(ByWhat)
	local allChildsOfGames = gameScrollingFrame:WaitForChild("Games"):GetChildren()
	for i, child in ipairs(allChildsOfGames) do
		if
			child.Name == "ChangePage"
			or child.Name == "GameTemplate"
			or child.Name == "PaddingFrameBottom(useless)"
			or child.Name == "PaddingFrameTop(useless)"
			or child.Name == "UIListLayout"
		then
			print("No need to destroy")
		else
			child:Destroy()
		end
	end
	count.setSharedCount(0)
	LoadingFrame.Visible = true
	gameScrollingFrame.Visible = false

	if ByWhat == "Featured" then
		ListDataEvent:FireServer(1, "Name")
	elseif ByWhat == "Last Update" then
		ListDataEvent:FireServer(1, "Updated")
	elseif ByWhat == "Visits" then
		ListDataEvent:FireServer(1, "Visits")
	elseif ByWhat == "Bookmarks" then
		ListDataEvent:FireServer(1, "Bookmarks")
	elseif ByWhat == "Active Players" then
		ListDataEvent:FireServer(1, "ActivePlayers")
	elseif ByWhat == "Name" then
		ListDataEvent:FireServer(1, "Name")
	elseif ByWhat == "Rating" then
		ListDataEvent:FireServer(1, "Rating")
	end
end

local options = { "Featured", "Last Update", "Visits", "Bookmarks", "Active Players", "Name", "Rating" }
for i, option in ipairs(options) do
	local optionButton = Instance.new("TextButton")
	optionButton.Size = UDim2.new(1, 0, 0.14, 0)
	optionButton.BackgroundColor3 = Color3.fromRGB(22, 20, 20)
	optionButton.BorderColor3 = Color3.fromRGB(22, 20, 20)
	optionButton.Text = option
	optionButton.TextColor3 = Color3.new(255, 255, 255)
	optionButton.Parent = dropdownMenu
	optionButton.FontFace = fontFace
	optionButton.TextSize = 10
	optionButton.TextScaled = true

	optionButton.MouseButton1Click:Connect(function()
		mainButton.Text = "Sort: " .. option
		dropdownMenu.Visible = false
		SortGamesBasedOn(option)
	end)
end

dropdownMenu.CanvasSize = UDim2.new(0, 0, 0, #options * 30)

mainButton.MouseButton1Click:Connect(function()
	dropdownMenu.Visible = not dropdownMenu.Visible
end)
