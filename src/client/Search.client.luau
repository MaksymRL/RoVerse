local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local launcherGui = playerGui:WaitForChild("LauncherGUI")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Guis = launcherGui:WaitForChild("GuisPlace")
local ManageBar = Guis:WaitForChild("ManageBar")
local SearchFrame = ManageBar:WaitForChild("SearchFrame")
local SearchBar = SearchFrame:WaitForChild("SearchBar")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerTriggerEvent = ReplicatedStorage:WaitForChild("AddPlaceRequest")
local gameScrollingFrame = Guis:WaitForChild("GamesScrollingFrame")
local count = require(ReplicatedStorage.Shared:WaitForChild("SharedPlaceId"))
local LoadingFrame = Guis:WaitForChild("Loading")
local searchRequest = ReplicatedStorage:WaitForChild("SearchRequest")
local function checkPlaceExists(placeId)
	local success, productInfo = pcall(function()
		return MarketplaceService:GetProductInfo(placeId)
	end)

	if success then
		if productInfo.AssetTypeId == 9 then
			print("Place exists:", productInfo.Name, "- Place ID:", placeId)
			ServerTriggerEvent:FireServer(placeId)
		else
			print("The ID does not correspond to a place.")
		end
	else
		print("Place ID does not exist or an error occurred.")
	end
end

SearchBar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
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
		searchRequest:FireServer(SearchBar.Text)
	end
end)
