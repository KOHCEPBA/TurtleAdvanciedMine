-- Static varables --
--Tech varables
debug = true
logLevel = 4
logLevels = {"Info", "Debug", "2", "3", "Trace"}
if (debug) then
	logFile = io.open("log.txt", "a")
end

stepDeep = 6
jumperDeep = 3
digSleepTime = 0.5

slotsCount = 16
maxFilledSlots = 13

torchSlot = 1
hasTorches = true
chestSlot = 2
hasChests = true

blockInfoFileName = "blockInfo.txt"
addBlockInfoFileName = "newBlockInfo.txt"

blockTable = {}

--------------

slotsInfo = {}
tech = "tech"

left = "left"
right = "right"
up = "up"
down = "down"
forward = "forward"
back = "back"

otherDirection = {
	[left] = right,
	[right] = left,
	[up] = down,
	[down] = up,
	[forward] = back,
	[back] = forward
}
tonelDirection = right

turnDirection = {
	[right] = turtle.turnRight,
	[left] = turtle.turnLeft
}

separators = {
	[" "] = "[^%s]+"
}

toBoolean = {
    ["true"] = true,
    ["false"] = false
}

newBlockInfoFile = nil

function debugPrint(level, message)
	if (debug and level <= logLevel) then
		logFile:write("[" .. (logLevels[level + 1] or "unknow") .. "]" .. ": " .. message .. "\n")
	end
end

function string:split(line, pat)
    local words = {}
    for token in string.gmatch(line, pat) do
        table.insert(words, token) 
    end
    return words
end

function prepairBlockInforation(file, sep)

	if (debug) then
		debugPrint(4, "prepairBlockInforation called with params: "
			.. "\nfileName = " .. tostring(file)
			.. "\nsep = " .. sep 
		)
	end

	for line in file:lines () do

		debugPrint(1, "[prepairBlockInforation] " .. line)

		r = string:split(line, sep)

		debugPrint(1, "[prepairBlockInforation] " 
			.. "\nname = " .. r[1] 
			.. "\nattribute = " .. r[2]
		)
		blockTable[r[1]] = toBoolean[r[2]]
	end

	if (debug) then
		debugPrint(4, "prepairBlockInforation ended")
	end
end



-- Invite --
print("Welcome to Digging programm!")
if (debug) then
	debugPrint(0, "debug enabled")
end

-- Program body --

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

function addBlockInformation(name)
	if (newBlockInfoFile == nil) then
		newBlockInfoFile = io.open(addBlockInfoFileName, "a")
	end
	newBlockInfoFile:write(name .. " \n")
	blockTable[name] = false
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

inspectFunctions = {
	[forward] = turtle.inspect,
	[up] = turtle.inspectUp,
	[down] = turtle.inspectDown
}
digFunctions = {
	[forward] = turtle.dig,
	[back] = function ()
				turnAround()
				turtle.dig()
				turnAround()
			end,
	[up] = turtle.digUp,
	[down] = turtle.digDown
}
moveFunctions = {
	[forward] = turtle.forward,
	[back] = turtle.back,
	[up] = turtle.up,
	[down] = turtle.down
}

function inspectDiraction(diraction)
	if (debug) then
		debugPrint(4, "inspectDiraction called with diraction = " .. diraction)
	end
	if (inspect(inspectFunctions[diraction])) then
		digDiraction(
			digFunctions[diraction], 
			moveFunctions[diraction]
		)
		inspectAround()
		digDiraction(
			digFunctions[otherDirection[diraction]], 
			moveFunctions[otherDirection[diraction]]
		)
	end
end

function inspectAround()
	inspectDiraction(up)
	inspectDiraction(down)
	for i = 1, 4, 1 do
		inspectDiraction(forward)
		turtle.turnRight()
	end
end

function digForward()
	digDiraction(turtle.dig, turtle.forward)
end

function digTonelForward()
	if (debug) then
		debugPrint(6, "digTonelForward called")
	end
	digForward()
	inspectAround()
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
	turnDirection[tonelDirection]()
	turtle.dig()
	turtle.up()
	turtle.dig()
	turtle.down()
	placeChest()
	dropItems(turtle.drop)
	turnDirection[otherDirection[tonelDirection]]()
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
	makeArk(tonelDirection)
	direction = otherDirection[tonelDirection]
	makeArk(direction)
	direction = otherDirection[tonelDirection]
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


	file = io.open(blockInfoFileName, "r")
	prepairBlockInforation(file, separators[" "])
end

prepair()
local complete, status = pcall(mine)

--Ending--
if (complete) then 
	print("Completed!")
else
	print("Completed with errors:")
	print(status)
end

--Exit preparations
if (newBlockInfoFile ~= nil) then
	newBlockInfoFile:close()
end
if (debug) then
	logFile:close()
end