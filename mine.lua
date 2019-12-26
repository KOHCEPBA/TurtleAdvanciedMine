-- Static varables --
--Tech varables
debug = true
debugLevel = 0

stepDeep = 6
jumperDeep = 3
digSleepTime = 0.5

slotsCount = 16
maxFilledSlots = 13

torchSlot = 1
hasTorches = true
chestSlot = 2
hasChests = true

blockTable = {}

--------------

slotsInfo = {}
tech = "tech"

left = "left"
right = "right"
direction = right
otherDirection = {
	[left] = right,
	[right] = left
}

up = "up"
forward = "forward"
down = "down"

turnDirection = {
	[right] = turtle.turnRight,
	[left] = turtle.turnLeft
}

function debugPrint(level, message)
	if (debug and level <= debugLevel) then
		print("Debug: ", message)
	end
end


-- Invite --
print("Welcome to Digging programm!")
if (debug) then
	debugPrint(0, "debug enabled")
end

-- Program body --

function addBlockInformation(name)
	
end

function inspect(inspectFunction)
	local success, data = inspectFunction()
	if (not success) then
		return false
	end
	if (blockTable[data.name] == nil) then
		addBlockInformation(data.name)
	end
	return blockTable[data.name] == true
end

function inspectAround()
	
end

function digForward()
	while (turtle.dig()) do
		sleep(digSleepTime)
	end
	turtle.forward()
end

function digTonelForward()
	if (debug) then
		debugPrint(6, "digTonelForward called")
	end
	digForward()
	turtle.digUp()
	turtle.digDown()
end

function findTorchesInInventory()
	if (debug) then
		debugPrint(4, "findTorchesInInventory called")
	end
	for i = 1, slotsCount, 1 do
		turtle.select(i)
		turtle.compareDown()
	end
end

function getTorchCount()
	return turtle.getItemCount(torchSlot)
end

function processEmptyTorchSlot()
	debugPrint(0, "Last torch. Stop Torch Installation.")
	hasTorches = false
end

function placeTorch()
	if (not hasTorches) then
		return hasTorches
	end
	if (debug) then
		debugPrint(4, "setTorch called")
		debugPrint(1, "Torches left: " .. getTorchCount())
	end
	turtle.select(torchSlot)
	turtle.placeDown()
	if (turtle.getItemCount(torchSlot) == 0) then
		processEmptyTorchSlot()
	end
	return hasTorches
end

function getChestCount()
	return turtle.getItemCount(chestSlot)
end

function processEmptyChestSlot()
	debugPrint(0, "Last chest. Stop Chest Installation.")
	hasChests = false
end

function placeChest()
	if (not hasChests) then
		return hasChests
	end
	if (debug) then
		debugPrint(4, "placeChest called")
		debugPrint(1, "Cests left: " .. getChestCount())
	end
	turtle.select(chestSlot)
	turtle.place()
	if (turtle.getItemCount(chestSlot) == 0) then
		processEmptyChestSlot()
	end
	return hasChests
end

function dropItems(dropFunction)
	for i = slotsCount, 1, -1 do
		if (slotsInfo[i] ~= tech) then
			turtle.select(i)
			dropFunction()
		end
	end
end

function moveAndDrop()
	turtle.back()
	turnDirection[direction]()
	turtle.dig()
	turtle.up()
	turtle.dig()
	turtle.down()
	placeChest()
	dropItems(turtle.drop)
	turnDirection[otherDirection[direction]]()
	turtle.forward()
	if (not hasChests) then
		error("No more chests")
	end
end

function checkSpace()
	if (not hasSpace()) then
		moveAndDrop()
	end
end

function makeStep(deep)
	if (debug) then
		debugPrint(5, "makeStep called")
	end
	for i = 1, deep, 1 do
		digTonelForward()
	end
	checkSpace()
end

function hasSpace()
	minEmptySlots = slotsCount - maxFilledSlots
	emptySlots = 0
	for i = slotsCount, 1, -1 do
		if (turtle.getItemCount(i) == 0) then
			emptySlots = emptySlots + 1
		end
		if (emptySlots >= minEmptySlots) then
			return true
		end
	end
	return false
end

function makeTonel()
	if (debug) then
		debugPrint(4, "makeTonel called")
	end
	for i = 1, startStep, 1 do
		makeStep(stepDeep)
		placeTorch()
	end
end

function digConnector(direction)
	turnDirection[direction]()
	digTonelForward()
	turnDirection[direction]()
	turnDirection[direction]()
	turtle.forward()
	turnDirection[direction]()
end

function makeJumper(direction, deep)
	turnDirection[direction]()
	makeStep(deep)
	turnDirection[direction]()
	placeTorch()
end

function makeArk(direction)
	if (debug) then
		debugPrint(4, "makeArk called")
		debugPrint(1, "direction = " .. direction)
	end
	digConnector(direction)
	makeTonel()
	makeJumper(direction, jumperDeep)
	makeTonel()
	digConnector(direction)
end

function digLevel()
	if (debug) then
		debugPrint(4, "digLevel called")
	end
	makeArk(direction)
	direction = otherDirection[direction]
	makeArk(direction)
	direction = otherDirection[direction]
end

function mine()
	while startStep < endStep do
		debugPrint(1, "step = " .. startStep)
		digLevel()
		startStep = startStep + 1
	end
end

function prepair()
	write("Enter start step (length = step * " .. stepDeep .. "):")
	startStep = read() + 0

	write("Enter end step:")
	endStep = read() + 0

	slotsInfo[torchSlot] = tech
	slotsInfo[chestSlot] = tech
end

prepair()
local complete, status = pcall(mine)
if (complete) then 
	print("Completed!")
else
	print("Completed with errors:")
	print(status)
end