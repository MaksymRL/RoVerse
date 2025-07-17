local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local guisPlace = launcherGui:WaitForChild("GuisPlace")
local gameScrollingFrame = guisPlace:WaitForChild("GamesScrollingFrame")
local changePage = gameScrollingFrame:WaitForChild("Games"):WaitForChild("ChangePage")
local GoOneAfter = changePage:WaitForChild("GoOneAfter")
local GoToTheEnd = changePage:WaitForChild("GoToTheEnd")
local GoOneBefore = changePage:WaitForChild("GoOneBefore")
local GoToTheStart = changePage:WaitForChild("GoToTheStart")
local CentralNumber = changePage:WaitForChild("CentralNumber")
local OneNumberBefore = changePage:WaitForChild("OneNumberBefore")
local OneNumberAfter = changePage:WaitForChild("OneNumberAfter")
local TwoNumbersBefore = changePage:WaitForChild("TwoNumbersBefore")
local TwoNumbersAfter = changePage:WaitForChild("TwoNumbersAfter")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local amountPages = 9
local savedNumber = 1
local ListDataEvent = ReplicatedStorage:WaitForChild("ListDataEvent")
local LoadingFrame = guisPlace:WaitForChild("Loading")
local ChangePageRequest = ReplicatedStorage:WaitForChild("ChangePageRequest")
local count = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))
local function loadGames(indexToAdd)
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
	ListDataEvent:FireServer(indexToAdd)
end

local function howManyPages(amountPages)
	if amountPages == 2 then
		TwoNumbersBefore.Visible = true
	elseif amountPages == 3 then
		TwoNumbersBefore.Visible = true
		OneNumberBefore.Visible = true
	elseif amountPages == 4 then
		TwoNumbersBefore.Visible = true
		OneNumberBefore.Visible = true
		OneNumberAfter.Visible = true
	elseif amountPages >= 5 then
		TwoNumbersBefore.Visible = true
		OneNumberBefore.Visible = true
		OneNumberAfter.Visible = true
		TwoNumbersAfter.Visible = true
	end
end

local function goOneBefore()
	if savedNumber == 2 then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 2
		CentralNumber.Text = 1
		TwoNumbersBefore.Text = 2
		TwoNumbersBefore.LayoutOrder = 3
		OneNumberBefore.LayoutOrder = 4
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		savedNumber = 1
	elseif savedNumber == 3 then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 3
		CentralNumber.Text = 2
		OneNumberBefore.Text = 3
		OneNumberBefore.LayoutOrder = 4
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		savedNumber = 2
	elseif savedNumber > 3 and savedNumber < amountPages then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 4
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		CentralNumber.Text = savedNumber - 1
		OneNumberBefore.Text = savedNumber - 2
		TwoNumbersBefore.Text = savedNumber - 3
		OneNumberAfter.Text = savedNumber
		TwoNumbersAfter.Text = savedNumber + 1
		savedNumber = savedNumber - 1
	elseif savedNumber == amountPages and savedNumber ~= 1 then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 5
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = savedNumber - 1
		OneNumberAfter.Text = savedNumber - 2
		TwoNumbersAfter.Text = savedNumber
		OneNumberBefore.Text = savedNumber - 3
		TwoNumbersBefore.Text = savedNumber - 4
		savedNumber = amountPages - 1
	end

	loadGames(savedNumber)
end

local function goToTheEnd()
	print("Number Clicked :" .. savedNumber)
	CentralNumber.LayoutOrder = 6
	OneNumberAfter.LayoutOrder = 4
	TwoNumbersAfter.LayoutOrder = 5
	OneNumberBefore.LayoutOrder = 3
	TwoNumbersBefore.LayoutOrder = 2
	if amountPages == 2 then
		CentralNumber.Text = amountPages
		TwoNumbersBefore.Text = amountPages - 1
	elseif amountPages == 3 then
		CentralNumber.Text = amountPages
		OneNumberBefore.Text = amountPages - 1
		TwoNumbersBefore.Text = amountPages - 2
	elseif amountPages == 4 then
		CentralNumber.Text = amountPages
		OneNumberAfter.Text = amountPages - 1
		OneNumberBefore.Text = amountPages - 2
		TwoNumbersBefore.Text = amountPages - 3
	else
		CentralNumber.Text = amountPages
		OneNumberAfter.Text = amountPages - 2
		TwoNumbersAfter.Text = amountPages - 1
		OneNumberBefore.Text = amountPages - 3
		TwoNumbersBefore.Text = amountPages - 4
	end
	savedNumber = amountPages
	loadGames(savedNumber)
end

local function goToTheStart()
	print("Number Clicked :" .. savedNumber)
	CentralNumber.LayoutOrder = 2
	CentralNumber.Text = 1
	TwoNumbersBefore.Text = 2
	TwoNumbersBefore.LayoutOrder = 3
	OneNumberBefore.LayoutOrder = 4
	OneNumberAfter.LayoutOrder = 5
	TwoNumbersAfter.LayoutOrder = 6
	OneNumberBefore.Text = 3
	OneNumberAfter.Text = 4
	TwoNumbersAfter.Text = 5
	savedNumber = 1
	loadGames(savedNumber)
end

local function startPage()
	print("Number Clicked :" .. savedNumber)
	CentralNumber.LayoutOrder = 2
	CentralNumber.Text = 1
	TwoNumbersBefore.Text = 2
	TwoNumbersBefore.LayoutOrder = 3
	OneNumberBefore.LayoutOrder = 4
	OneNumberAfter.LayoutOrder = 5
	TwoNumbersAfter.LayoutOrder = 6
	OneNumberBefore.Text = 3
	OneNumberAfter.Text = 4
	TwoNumbersAfter.Text = 5
	savedNumber = 1
end

local function goOneAfter()
	if savedNumber == 1 and amountPages ~= 1 then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 3
		CentralNumber.Text = 2
		TwoNumbersBefore.Text = 1
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberBefore.LayoutOrder = 4
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		savedNumber = 2
	elseif savedNumber == 2 and amountPages ~= 2 then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 4
		CentralNumber.Text = 3
		OneNumberBefore.Text = 2
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		savedNumber = 3
	elseif savedNumber >= 3 and savedNumber < amountPages - 2 and amountPages ~= savedNumber then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 4
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		CentralNumber.Text = savedNumber + 1
		OneNumberBefore.Text = savedNumber
		TwoNumbersBefore.Text = savedNumber - 1
		OneNumberAfter.Text = savedNumber + 2
		TwoNumbersAfter.Text = savedNumber + 3
		savedNumber = savedNumber + 1
	elseif savedNumber == amountPages - 2 and amountPages ~= savedNumber then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 5
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = savedNumber + 1
		OneNumberAfter.Text = savedNumber
		TwoNumbersAfter.Text = savedNumber + 2
		OneNumberBefore.Text = savedNumber - 1
		TwoNumbersBefore.Text = savedNumber - 2
		savedNumber = savedNumber + 1
	elseif savedNumber == amountPages - 1 and amountPages ~= savedNumber then
		print("Number Clicked :" .. savedNumber)
		CentralNumber.LayoutOrder = 6
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 5
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = savedNumber + 1
		OneNumberAfter.Text = savedNumber - 1
		TwoNumbersAfter.Text = savedNumber
		OneNumberBefore.Text = savedNumber - 2
		TwoNumbersBefore.Text = savedNumber - 3
		savedNumber = savedNumber + 1
	end
	loadGames(savedNumber)
end

local function onOneNumberBeforeclick()
	if tonumber(OneNumberBefore.Text) == 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberBefore.Text)
		CentralNumber.LayoutOrder = 2
		CentralNumber.Text = 1
		TwoNumbersBefore.Text = 2
		TwoNumbersBefore.LayoutOrder = 3
		OneNumberBefore.LayoutOrder = 4
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.Text = 3
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif tonumber(OneNumberBefore.Text) == 2 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberBefore.Text)
		CentralNumber.LayoutOrder = 3
		CentralNumber.Text = 2
		OneNumberBefore.Text = 3
		OneNumberBefore.LayoutOrder = 4
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		TwoNumbersBefore.Text = 1
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif tonumber(OneNumberBefore.Text) == 3 and amountPages == 3 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberBefore.Text)
		CentralNumber.LayoutOrder = 4
		CentralNumber.Text = 3
		OneNumberBefore.Text = 2
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		TwoNumbersBefore.Text = 1
	elseif tonumber(OneNumberBefore.Text) >= 3 and tonumber(OneNumberBefore.Text) < amountPages - 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberBefore.Text)
		CentralNumber.LayoutOrder = 4
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		CentralNumber.Text = savedNumber
		OneNumberBefore.Text = savedNumber - 1
		TwoNumbersBefore.Text = savedNumber - 2
		OneNumberAfter.Text = savedNumber + 1
		TwoNumbersAfter.Text = savedNumber + 2
	elseif tonumber(OneNumberBefore.Text) == amountPages - 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberBefore.Text)
		CentralNumber.LayoutOrder = 5
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = savedNumber
		OneNumberAfter.Text = savedNumber - 1
		TwoNumbersAfter.Text = savedNumber + 1
		OneNumberBefore.Text = savedNumber - 2
		TwoNumbersBefore.Text = savedNumber - 3
	elseif tonumber(OneNumberBefore.Text) == amountPages then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberBefore.Text)
		CentralNumber.LayoutOrder = 6
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 5
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = amountPages
		OneNumberAfter.Text = savedNumber - 2
		TwoNumbersAfter.Text = savedNumber - 1
		OneNumberBefore.Text = savedNumber - 3
		TwoNumbersBefore.Text = savedNumber - 4
	end
	loadGames(savedNumber)
end

local function onTwoNumbersBeforeclick()
	if tonumber(TwoNumbersBefore.Text) == 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersBefore.Text)
		CentralNumber.LayoutOrder = 2
		CentralNumber.Text = 1
		TwoNumbersBefore.Text = 2
		TwoNumbersBefore.LayoutOrder = 3
		OneNumberBefore.LayoutOrder = 4
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.Text = 3
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif tonumber(TwoNumbersBefore.Text) == 2 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersBefore.Text)
		CentralNumber.LayoutOrder = 3
		CentralNumber.Text = 2
		OneNumberBefore.Text = 3
		OneNumberBefore.LayoutOrder = 4
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		TwoNumbersBefore.Text = 1
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif tonumber(TwoNumbersBefore.Text) >= 3 and tonumber(TwoNumbersBefore.Text) < amountPages - 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersBefore.Text)
		CentralNumber.LayoutOrder = 4
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		CentralNumber.Text = savedNumber
		OneNumberBefore.Text = savedNumber - 1
		TwoNumbersBefore.Text = savedNumber - 2
		OneNumberAfter.Text = savedNumber + 1
		TwoNumbersAfter.Text = savedNumber + 2
	elseif tonumber(TwoNumbersBefore.Text) == amountPages - 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersBefore.Text)
		CentralNumber.LayoutOrder = 5
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = savedNumber
		OneNumberAfter.Text = savedNumber - 1
		TwoNumbersAfter.Text = savedNumber + 1
		OneNumberBefore.Text = savedNumber - 2
		TwoNumbersBefore.Text = savedNumber - 3
	elseif tonumber(TwoNumbersBefore.Text) == amountPages then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersBefore.Text)
		CentralNumber.LayoutOrder = 6
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 5
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = amountPages
		OneNumberAfter.Text = savedNumber - 2
		TwoNumbersAfter.Text = savedNumber - 1
		OneNumberBefore.Text = savedNumber - 3
		TwoNumbersBefore.Text = savedNumber - 4
	end
	loadGames(savedNumber)
end

local function onOneNumberAfterclick()
	if tonumber(OneNumberAfter.Text) == 1 and amountPages ~= 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberAfter.Text)
		CentralNumber.LayoutOrder = 2
		CentralNumber.Text = 1
		TwoNumbersBefore.Text = 2
		TwoNumbersBefore.LayoutOrder = 3
		OneNumberBefore.LayoutOrder = 4
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.Text = 3
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif tonumber(OneNumberAfter.Text) == 2 and amountPages ~= 2 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberAfter.Text)
		CentralNumber.LayoutOrder = 3
		CentralNumber.Text = 2
		OneNumberBefore.Text = 3
		OneNumberBefore.LayoutOrder = 4
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		TwoNumbersBefore.Text = 1
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif
		tonumber(OneNumberAfter.Text) >= 3
		and tonumber(OneNumberAfter.Text) < amountPages - 1
		and amountPages ~= tonumber(OneNumberAfter.Text)
	then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberAfter.Text)
		CentralNumber.LayoutOrder = 4
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		CentralNumber.Text = savedNumber
		OneNumberBefore.Text = savedNumber - 1
		TwoNumbersBefore.Text = savedNumber - 2
		OneNumberAfter.Text = savedNumber + 1
		TwoNumbersAfter.Text = savedNumber + 2
	elseif tonumber(OneNumberAfter.Text) == amountPages - 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberAfter.Text)
		CentralNumber.LayoutOrder = 5
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = savedNumber
		OneNumberAfter.Text = savedNumber - 1
		TwoNumbersAfter.Text = savedNumber + 1
		OneNumberBefore.Text = savedNumber - 2
		TwoNumbersBefore.Text = savedNumber - 3
	elseif tonumber(OneNumberAfter.Text) == amountPages then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(OneNumberAfter.Text)
		CentralNumber.LayoutOrder = 6
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 5
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = amountPages
		OneNumberAfter.Text = savedNumber - 2
		TwoNumbersAfter.Text = savedNumber - 1
		OneNumberBefore.Text = savedNumber - 3
		TwoNumbersBefore.Text = savedNumber - 4
	end
	loadGames(savedNumber)
end

local function onTwoNumbersAfterclick()
	if tonumber(TwoNumbersAfter.Text) == 1 and amountPages ~= tonumber(OneNumberAfter.Text) then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersAfter.Text)
		CentralNumber.LayoutOrder = 2
		CentralNumber.Text = 1
		TwoNumbersBefore.Text = 2
		TwoNumbersBefore.LayoutOrder = 3
		OneNumberBefore.LayoutOrder = 4
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.Text = 3
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif tonumber(TwoNumbersAfter.Text) == 2 and amountPages ~= tonumber(OneNumberAfter.Text) then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersAfter.Text)
		CentralNumber.LayoutOrder = 3
		CentralNumber.Text = 2
		OneNumberBefore.Text = 3
		OneNumberBefore.LayoutOrder = 4
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		TwoNumbersBefore.Text = 1
		OneNumberAfter.Text = 4
		TwoNumbersAfter.Text = 5
	elseif
		tonumber(TwoNumbersAfter.Text) >= 3
		and tonumber(TwoNumbersAfter.Text) < amountPages - 1
		and amountPages ~= tonumber(OneNumberAfter.Text)
	then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersAfter.Text)
		CentralNumber.LayoutOrder = 4
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		OneNumberAfter.LayoutOrder = 5
		TwoNumbersAfter.LayoutOrder = 6
		CentralNumber.Text = savedNumber
		OneNumberBefore.Text = savedNumber - 1
		TwoNumbersBefore.Text = savedNumber - 2
		OneNumberAfter.Text = savedNumber + 1
		TwoNumbersAfter.Text = savedNumber + 2
	elseif tonumber(TwoNumbersAfter.Text) == amountPages - 1 then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersAfter.Text)
		CentralNumber.LayoutOrder = 5
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 6
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = savedNumber
		OneNumberAfter.Text = savedNumber - 1
		TwoNumbersAfter.Text = savedNumber + 1
		OneNumberBefore.Text = savedNumber - 2
		TwoNumbersBefore.Text = savedNumber - 3
	elseif tonumber(TwoNumbersAfter.Text) == amountPages then
		print("Number Clicked :" .. savedNumber)
		savedNumber = tonumber(TwoNumbersAfter.Text)
		CentralNumber.LayoutOrder = 6
		OneNumberAfter.LayoutOrder = 4
		TwoNumbersAfter.LayoutOrder = 5
		OneNumberBefore.LayoutOrder = 3
		TwoNumbersBefore.LayoutOrder = 2
		CentralNumber.Text = amountPages
		OneNumberAfter.Text = savedNumber - 2
		TwoNumbersAfter.Text = savedNumber - 1
		OneNumberBefore.Text = savedNumber - 3
		TwoNumbersBefore.Text = savedNumber - 4
	end
	loadGames(savedNumber)
end

ChangePageRequest.OnClientEvent:Connect(function(pagesAmount)
	howManyPages(pagesAmount)
	amountPages = pagesAmount
	startPage()
end)

OneNumberBefore.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		onOneNumberBeforeclick()
	end
end)

TwoNumbersBefore.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		onTwoNumbersBeforeclick()
	end
end)

OneNumberAfter.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		onOneNumberAfterclick()
	end
end)

TwoNumbersAfter.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		onTwoNumbersAfterclick()
	end
end)

GoOneBefore.MouseButton1Click:Connect(goOneBefore)

GoOneAfter.MouseButton1Click:Connect(goOneAfter)

GoToTheEnd.MouseButton1Click:Connect(goToTheEnd)

GoToTheStart.MouseButton1Click:Connect(goToTheStart)
