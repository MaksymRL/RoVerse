local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TutorialsDataEvent = ReplicatedStorage:WaitForChild("TutorialDataEvent")

local function sendGameDataToClient(player, tutorial)
	local text = tutorial.text
	local nickname = tutorial.nickname
	local currentTime = os.time()
	local timeDifference = os.difftime(currentTime, tutorial.timestamp)
	local title = tutorial.title

	local timeString
	if timeDifference < 60 then
		timeString = string.format("%d seconds ago", timeDifference)
	elseif timeDifference < 3600 then
		timeString = string.format("%d minutes ago", math.floor(timeDifference / 60))
	elseif timeDifference < 86400 then
		timeString = string.format("%d hours ago", math.floor(timeDifference / 3600))
	else
		timeString = string.format("%d days ago", math.floor(timeDifference / 86400))
	end

	if player and player.Parent then
		print("Tutorial sent to client with")
		TutorialsDataEvent:FireClient(player, text, nickname, timeString, tutorial.timestamp, title)
	end
end

TutorialsDataEvent.OnServerEvent:Connect(function(player, placeId)
	local tutorialsManager = require(game.ServerScriptService.Server:WaitForChild("TutorialsManager"))

	tutorialsManager.PrintTutorial(placeId)
	local arrayTutorials = tutorialsManager.GetTutorials(placeId, player.DisplayName)
	print("Tutorials count: " .. #arrayTutorials)

	for i, tutorial in ipairs(arrayTutorials) do
		task.wait(0.5)
		if not player or not player.Parent then
			print("Player left during data transmission")
			break
		end

		sendGameDataToClient(player, tutorial)
	end
end)
