local sharedIp = 0
local count = 0

local function getSharedCount()
	return count
end

local function setSharedCount(value)
	count = value
end

local function getSharedData()
	return sharedIp
end

local function setSharedData(value)
	sharedIp = value
end

return {
	getSharedData = getSharedData,
	setSharedData = setSharedData,
	getSharedCount = getSharedCount,
	setSharedCount = setSharedCount,
}
