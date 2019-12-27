stepDeep = 6
jumperDeep = 3
digSleepTime = 0.5

digAndMove = {}

local tonelDirection = right

function turnAround()
		turtle.turnLeft()
		turtle.turnLeft()
end

function digDiraction(digFunction, moveFunction)
	while (digFunction()) do
		sleep(digSleepTime)
	end
	moveFunction()
end

local function digForward()
	digDiraction(turtle.dig, turtle.forward)
end

local function digTonelForward()
	if (debug) then
		LOGGER.debugPrint(6, "digTonelForward called")
	end
	digForward()
	inspector.inspectAround()
	turtle.digUp()
	turtle.digDown()
end

local function makeStep(deep)
	if (debug) then
		LOGGER.debugPrint(5, "makeStep called")
	end
	for i = 1, deep, 1 do
		digTonelForward()
	end
	slotInformation.checkSpace()
end

local function makeTonel()
	if (debug) then
		LOGGER.debugPrint(4, "makeTonel called")
	end
	for i = 1, startStep, 1 do
		makeStep(stepDeep)
		torchController.placeTorch()
	end
end

local function digConnector(direction)
	turnDirection[direction]()
	digTonelForward()
	turnDirection[direction]()
	turnDirection[direction]()
	turtle.forward()
	turnDirection[direction]()
end

local function makeJumper(direction, deep)
	turnDirection[direction]()
	makeStep(deep)
	turnDirection[direction]()
	torchController.placeTorch()
end

local function makeArk(direction)
	if (debug) then
		LOGGER.debugPrint(4, "makeArk called")
		LOGGER.debugPrint(1, "direction = " .. direction)
	end
	digConnector(direction)
	makeTonel()
	makeJumper(direction, jumperDeep)
	makeTonel()
	digConnector(direction)
end

function digAndMove.digLevel()
	if (debug) then
		LOGGER.debugPrint(4, "digLevel called")
	end
	makeArk(tonelDirection)
	direction = otherDirection[tonelDirection]
	makeArk(direction)
	direction = otherDirection[tonelDirection]
end