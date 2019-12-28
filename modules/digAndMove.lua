stepDeep = 6
jumperDeep = 3
digSleepTime = 0.5

local bottomLevel = 1
local topLevel = 3
local level = bottomLevel

local comfortableHeight = 2

local top = "top"
local bottom = "bottom"
local otherPosition = {
	[top] = bottom,
	[bottom] = top
}

local verticalDiraction = top

digAndMove = {}

local movePredicates = {
	[top] = function ()
		return level < topLevel
	end,
	[bottom] = function ()
		return level > bottomLevel
	end
}
local verticalMoves = {
	[top] = function (moveFunction)
		moveFunction(turtle.digUp, turtle.up)
		level = level + 1
		if (movePredicates.top) then
			verticalDiraction = bottom
		end
	end,
	[bottom] = function (moveFunction)
		moveFunction(turtle.digDown, turtle.down)
		level = level - 1
		if (movePredicates.bottom) then
			verticalDiraction = top
		end
	end
}

tonelDirection = right

local function setStartHeight(height)
	if (height < bottomLevel or height > topLevel) then
		error("Uncorrect height: " .. height)
	end
	if (height == topLevel) then
		verticalDiraction = bottom
	end
	level = height or level
end

function turnAround()
	if (debug) then
		LOGGER.debugWrite(4, "turnAround called")
	end
		turtle.turnLeft()
		turtle.turnLeft()
end

function moveDiraction(digFunction, moveFunction)
	if (debug) then
		LOGGER.debugWrite(4, "moveDiraction called")
	end
	while (digFunction()) do
		sleep(digSleepTime)
	end
	moveFunction()
end

function digDiraction(digFunction, moveFunction)
	if (debug) then
		LOGGER.debugWrite(4, "digDiraction called")
	end
	moveDiraction(digFunction, moveFunction)
	inspector.inspectAround()
end

local function moveForwardToDeep(deep)
	if (debug) then
		LOGGER.debugWrite(4, "direction called")
		LOGGER.debugWrite(1, "deep = " .. deep)
	end
	for i = 1, deep, 1 do
		moveDiraction(turtle.dig, turtle.forward)
	end
end

local function digForward()
	if (debug) then
		LOGGER.debugWrite(4, "digForward called")
	end
	digDiraction(turtle.dig, turtle.forward)
end

local function verticalMove(diraction, action)
	while movePredicates[diraction]() do
		verticalMoves[diraction](action)
	end
end

local function verticalAction(action)
	if (debug) then
		LOGGER.debugWrite(4, "verticalAction called")
	end
	verticalMove(verticalDiraction, action)
end

local function digTonelForward()
	if (debug) then
		LOGGER.debugWrite(4, "digTonelForward called")
	end
	digForward()
	verticalAction(digDiraction)
end

local function moveToComfortableHeight()
	while level ~= comfortableHeight do
		if (level < comfortableHeight) then
			verticalMoves.top(moveDiraction)
		else
			verticalMoves.bottom(moveDiraction)
		end
	end
end

local function makeStep(deep)
	if (debug) then
		LOGGER.debugWrite(4, "makeStep called")
	end
	for i = 1, deep, 1 do
		digTonelForward()
	end
	moveToComfortableHeight()
	torchController.placeTorch()
	slotInformation.checkSpace()
	verticalMove(top, moveDiraction)
end

local function makeTonel(step)
	if (debug) then
		LOGGER.debugWrite(4, "makeTonel called")
		LOGGER.debugWrite(1, "step = " .. step)
	end
	for i = 1, step, 1 do
		makeStep(stepDeep)
	end
end

local function digConnector(direction, deep)
	if (debug) then
		LOGGER.debugWrite(4, "digConnector called")
		LOGGER.debugWrite(1, "direction = " .. direction)
		LOGGER.debugWrite(1, "deep = " .. deep)
	end
	turnDirection[direction]()
	makeStep(deep - 1)
	turnDirection[direction]()
	turnDirection[direction]()
	moveForwardToDeep(deep - 1)
	turnDirection[direction]()
end

local function makeJumper(direction, deep)
	if (debug) then
		LOGGER.debugWrite(4, "direction called")
		LOGGER.debugWrite(1, "direction = " .. direction)
		LOGGER.debugWrite(1, "deep = " .. deep)
	end
	turnDirection[direction]()
	makeStep(deep)
	turnDirection[direction]()
end

local function makeArk(direction, step)
	if (debug) then
		LOGGER.debugWrite(4, "makeArk called")
		LOGGER.debugWrite(1, "direction = " .. direction)
		LOGGER.debugWrite(1, "step = " .. step)
	end
	digConnector(direction, jumperDeep)
	makeTonel(step)
	makeJumper(direction, jumperDeep)
	makeTonel(step)
end

local function digLevel(step)
	if (debug) then
		LOGGER.debugWrite(4, "digLevel called")
		LOGGER.debugWrite(1, "step = " .. step)
	end
	makeArk(tonelDirection, step)
	tonelDirection = otherDirection[tonelDirection]
	makeArk(tonelDirection, step)
	tonelDirection = otherDirection[tonelDirection]
end

function digAndMove.mine(startStep, endStep, startHeight)
	if (debug) then
		LOGGER.debugWrite(4, "digAndMove.mine called")
		LOGGER.debugWrite(1, "startStep = " .. startStep)
		LOGGER.debugWrite(1, "endStep = " .. endStep)
		LOGGER.debugWrite(1, "startHeight = " .. startHeight)
	end
	setStartHeight(startHeight)
	moveToComfortableHeight()
	torchController.placeTorch()
	verticalMove(top, moveDiraction)
	while startStep < endStep do
		LOGGER.debugWrite(1, "step = " .. startStep)
		digLevel(startStep)
		startStep = startStep + 1
	end
end