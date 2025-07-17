-- Create a ComboBox GUI
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local launcherGui = PlayerGui:WaitForChild("LauncherGUI")
local guisPlace = launcherGui:WaitForChild("GuisPlace")
local ManageBar = guisPlace:WaitForChild("ManageBar")
local filterFrame = ManageBar:WaitForChild("FilterFrame")
local mainButton = filterFrame:WaitForChild("FilterTextButton")
local filterSpecs = filterFrame:WaitForChild("FilterSpecs")
local chooseGenre = filterSpecs:WaitForChild("ByGenre"):WaitForChild("ChooseGenre")
local dropdownMenu = chooseGenre:WaitForChild("ScrollingFrame")
local genreButton = chooseGenre:WaitForChild("GenreTextButton")
local fontFace =
	Font.new("rbxasset://fonts/families/HighwayGothic.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local fromCreation = filterSpecs:WaitForChild("ByCreationDate"):WaitForChild("FromFrame"):WaitForChild("From")
local toCreation = filterSpecs:WaitForChild("ByCreationDate"):WaitForChild("ToFrame"):WaitForChild("To")
local fromUpdate = filterSpecs:WaitForChild("ByUpdateDate"):WaitForChild("FromFrame"):WaitForChild("From")
local toUpdate = filterSpecs:WaitForChild("ByUpdateDate"):WaitForChild("ToFrame"):WaitForChild("To")
local fromRating = filterSpecs:WaitForChild("ByRating"):WaitForChild("FromFrame"):WaitForChild("From")
local toRating = filterSpecs:WaitForChild("ByRating"):WaitForChild("ToFrame"):WaitForChild("To")
local myLibraryFavorites = filterSpecs:WaitForChild("ByMyLibrary"):WaitForChild("FavoriteCheckBox")
local myLibraryPlaying = filterSpecs:WaitForChild("ByMyLibrary"):WaitForChild("PlayingCheckBox")
local myLibraryDropped = filterSpecs:WaitForChild("ByMyLibrary"):WaitForChild("DroppedCheckBox")
local myLibraryPlanning = filterSpecs:WaitForChild("ByMyLibrary"):WaitForChild("PlanningCheckBox")
local resetButton = filterSpecs:WaitForChild("FilterButtons"):WaitForChild("ResetButton")
local applyButton = filterSpecs:WaitForChild("FilterButtons"):WaitForChild("ApplyButton")
local randomButton = filterSpecs:WaitForChild("FilterButtons"):WaitForChild("RandomButton")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local filterRequest = ReplicatedStorage:WaitForChild("FilterRequest")
local LoadingFrame = guisPlace:WaitForChild("Loading")
local gameScrollingFrame = guisPlace:WaitForChild("GamesScrollingFrame")
local count = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))
dropdownMenu.Visible = false -- Hidden by default
filterSpecs.Visible = false
-- Populate Dropdown Menu
local options = {
	"All",
	"Action",
	"Adventure",
	"Education",
	"Entertainment",
	"Obby & Platformer",
	"Party & Casual",
	"Puzzle",
	"RPG",
	"Roleplay & Avatar Sim",
	"Shooter",
	"Shopping",
	"Simulation",
	"Social",
	"Sports & Racing",
	"Strategy",
	"Survival",
	"Utility & Other",
}
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
	-- Click Event for Each Option
	optionButton.MouseButton1Click:Connect(function()
		genreButton.Text = option -- Update main button text
		dropdownMenu.Visible = false -- Hide dropdown
	end)
end

local function onApplyClick()
	local genre = genreButton.Text
	local creationFrom = fromCreation.Text
	local creationTo = toCreation.Text
	local updateFrom = fromUpdate.Text
	local updateTo = toUpdate.Text
	local ratingFrom = fromRating.Text
	local ratingTo = toRating.Text
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
	filterRequest:FireServer(genre, creationFrom, creationTo, updateFrom, updateTo, ratingFrom, ratingTo)
end

local function onResetClick()
	genreButton.Text = "All"
	toCreation.Text = ""
	fromCreation.Text = ""
	toUpdate.Text = ""
	fromUpdate.Text = ""
	toRating.Text = ""
	fromRating.Text = ""
	myLibraryPlaying.BackgroundTransparency = 1
	myLibraryDropped.BackgroundTransparency = 1
	myLibraryPlanning.BackgroundTransparency = 1
	myLibraryFavorites.BackgroundTransparency = 1
	local myPlaystroke = myLibraryPlaying:WaitForChild("UIStroke")
	local myDropstroke = myLibraryDropped:WaitForChild("UIStroke")
	local myPlanstroke = myLibraryPlanning:WaitForChild("UIStroke")
	local myFavstroke = myLibraryFavorites:WaitForChild("UIStroke")
	myPlaystroke.Color = Color3.fromRGB(255, 255, 255)
	myDropstroke.Color = Color3.fromRGB(255, 255, 255)
	myPlanstroke.Color = Color3.fromRGB(255, 255, 255)
	myFavstroke.Color = Color3.fromRGB(255, 255, 255)
end

local function onRandomClick()
	local randGenre = math.random(1, #options)
	genreButton.Text = options[randGenre]

	-- Constants for oldest and current year
	local oldest = 2006
	local youngest = tonumber(os.date("%Y"))
	local fromCreate = math.random(oldest, youngest)

	local toCreate = (fromCreate == youngest) and "" or math.random(fromCreate + 1, youngest)
	fromCreation.Text = tostring(fromCreate)
	toCreation.Text = tostring(toCreate)

	-- Generate Random Update Years
	local fromUpdated
	if toCreate == "" then
		fromUpdated = youngest
	else
		fromUpdated = math.random(fromCreate, toCreate)
	end

	local toUpdated
	if fromUpdated == youngest then
		toUpdated = ""
	elseif fromUpdated == toCreate then
		toUpdated = ""
	elseif fromUpdated == youngest - 1 then
		toUpdated = youngest
	else
		print(fromUpdated .. ": From update")
		print(toCreate .. ": To create")
		toUpdated = math.random(fromUpdated + 1, toCreate)
	end

	fromUpdate.Text = tostring(fromUpdated)
	toUpdate.Text = tostring(toUpdated)
	-- Generate Random Ratings
	local randomRating = math.random(1, 5)
	fromRating.Text = tostring(randomRating)

	if randomRating == 5 then
		toRating.Text = ""
	else
		local secondRand = math.random(randomRating + 1, 5)
		toRating.Text = tostring(secondRand)
	end

	local randomRating = math.random(1, 5)
	if randomRating == 5 then
		fromRating.Text = 5
		toRating.Text = ""
	else
		fromRating.Text = randomRating
		local secondRand = math.random(randomRating + 1, 5)
		toRating.Text = secondRand
	end

	local randomMyList = math.random(1, 4)
	local list = { myLibraryPlaying, myLibraryDropped, myLibraryPlanning, myLibraryFavorites }
	if randomMyList == 1 then
		local secondRandoMyList = math.random(1, 4)
		for i, MyListItem in ipairs(list) do
			MyListItem.BackgroundTransparency = 1
			local mylistStroke = MyListItem:WaitForChild("UIStroke")
			mylistStroke.Color = Color3.fromRGB(255, 255, 255)
			if i == #list then
				break
			end
		end

		list[secondRandoMyList].BackgroundTransparency = 0
		local listUiStroke = list[secondRandoMyList]:WaitForChild("UIStroke")
		listUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[secondRandoMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	elseif randomMyList == 2 then
		local secondRandoMyList = math.random(1, 4)
		local thirdRandomMyList
		repeat
			thirdRandomMyList = math.random(1, 4)
		until thirdRandomMyList ~= secondRandoMyList

		for i, MyListItem in ipairs(list) do
			MyListItem.BackgroundTransparency = 1
			local mylistStroke = MyListItem:WaitForChild("UIStroke")
			mylistStroke.Color = Color3.fromRGB(255, 255, 255)
			if i == #list then
				break
			end
		end

		list[secondRandoMyList].BackgroundTransparency = 0
		local listUiStroke = list[secondRandoMyList]:WaitForChild("UIStroke")
		listUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[secondRandoMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

		list[thirdRandomMyList].BackgroundTransparency = 0
		local listSecondUiStroke = list[thirdRandomMyList]:WaitForChild("UIStroke")
		listSecondUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[thirdRandomMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	elseif randomMyList == 3 then
		local secondRandoMyList = math.random(1, 4)
		local thirdRandomMyList
		repeat
			thirdRandomMyList = math.random(1, 4)
		until thirdRandomMyList ~= secondRandoMyList

		local anotherRandomMyList
		repeat
			anotherRandomMyList = math.random(1, 4)
		until anotherRandomMyList ~= secondRandoMyList and anotherRandomMyList ~= thirdRandomMyList

		for i, MyListItem in ipairs(list) do
			MyListItem.BackgroundTransparency = 1
			local mylistStroke = MyListItem:WaitForChild("UIStroke")
			mylistStroke.Color = Color3.fromRGB(255, 255, 255)
			if i == #list then
				break
			end
		end

		list[secondRandoMyList].BackgroundTransparency = 0
		local listUiStroke = list[secondRandoMyList]:WaitForChild("UIStroke")
		listUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[secondRandoMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

		list[thirdRandomMyList].BackgroundTransparency = 0
		local listSecondUiStroke = list[thirdRandomMyList]:WaitForChild("UIStroke")
		listSecondUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[thirdRandomMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

		list[anotherRandomMyList].BackgroundTransparency = 0
		local listAnotherUiStroke = list[anotherRandomMyList]:WaitForChild("UIStroke")
		listAnotherUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[anotherRandomMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	elseif randomMyList == 4 then
		local secondRandoMyList = math.random(1, 4)
		local thirdRandomMyList
		repeat
			thirdRandomMyList = math.random(1, 4)
		until thirdRandomMyList ~= secondRandoMyList

		local anotherRandomMyList
		repeat
			anotherRandomMyList = math.random(1, 4)
		until anotherRandomMyList ~= secondRandoMyList and anotherRandomMyList ~= thirdRandomMyList

		local lastRandomMyList
		repeat
			lastRandomMyList = math.random(1, 4)
		until lastRandomMyList ~= secondRandoMyList
			and lastRandomMyList ~= thirdRandomMyList
			and lastRandomMyList ~= anotherRandomMyList

		for i, MyListItem in ipairs(list) do
			MyListItem.BackgroundTransparency = 1
			local mylistStroke = MyListItem:WaitForChild("UIStroke")
			mylistStroke.Color = Color3.fromRGB(255, 255, 255)
			if i == #list then
				break
			end
		end

		list[secondRandoMyList].BackgroundTransparency = 0
		local listUiStroke = list[secondRandoMyList]:WaitForChild("UIStroke")
		listUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[secondRandoMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

		list[thirdRandomMyList].BackgroundTransparency = 0
		local listSecondUiStroke = list[thirdRandomMyList]:WaitForChild("UIStroke")
		listSecondUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[thirdRandomMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

		list[anotherRandomMyList].BackgroundTransparency = 0
		local listAnotherUiStroke = list[anotherRandomMyList]:WaitForChild("UIStroke")
		listAnotherUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[anotherRandomMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)

		list[lastRandomMyList].BackgroundTransparency = 0
		local listLastUiStroke = list[lastRandomMyList]:WaitForChild("UIStroke")
		listLastUiStroke.Color = Color3.fromRGB(0, 0, 0)
		list[lastRandomMyList].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end

mainButton.MouseButton1Click:Connect(function()
	filterSpecs.Visible = not filterSpecs.Visible
end)

applyButton.MouseButton1Click:Connect(onApplyClick)

resetButton.MouseButton1Click:Connect(onResetClick)

randomButton.MouseButton1Click:Connect(onRandomClick)
-- Toggle Dropdown Visibility
genreButton.MouseButton1Click:Connect(function()
	dropdownMenu.Visible = not dropdownMenu.Visible
end)
