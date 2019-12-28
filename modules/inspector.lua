inspector = {}

local blockInfoFileName = "resuorces/blockInfo.txt"
local addBlockInfoFileName = "resuorces/newBlockInfo.txt"
function inspector.setBlockInfoFileName(name)
	blockInfoFileName = name or blockInfoFileName
end
function inspector.setBlockNewInfoFileName(name)
	addBlockInfoFileName = name or addBlockInfoFileName
end
local newBlockInfoFile = nil

local blockTable = {}

separators = {
	[" "] = "[^%s]+"
}

toBoolean = {
    ["true"] = true,
    ["false"] = false
}

function string:split(line, pat)
    local words = {}
    for token in string.gmatch(line, pat) do
        table.insert(words, token) 
    end
    return words
end

local function prepairBlockInforation(file, sep)

	if (debug) then
		LOGGER.debugWrite(4, "prepairBlockInforation called with params: "
			.. "\nfileName = " .. tostring(file)
			.. "\nsep = " .. sep 
		)
	end

	for line in file:lines () do

		LOGGER.debugWrite(1, "[prepairBlockInforation] " .. line)

		r = string:split(line, sep)

		LOGGER.debugWrite(1, "[prepairBlockInforation] " 
			.. "\nname = " .. r[1] 
			.. "\nattribute = " .. r[2]
		)
		blockTable[r[1]] = toBoolean[r[2]]
	end

	if (debug) then
		LOGGER.debugWrite(4, "prepairBlockInforation ended")
	end
end

local function addBlockInformation(name)
	if (debug) then
		LOGGER.debugWrite(4, "addBlockInformation calles")
		LOGGER.debugWrite(1, "name = " .. name)
	end
	if (newBlockInfoFile == nil) then
		newBlockInfoFile = io.open(addBlockInfoFileName, "a")
	end
	newBlockInfoFile:write(name .. " \n")
	blockTable[name] = false
end

local function inspect(inspectFunction)
	local success, data = inspectFunction()
	if (not success) then
		return false
	end
	if (blockTable[data.name] == nil) then
		addBlockInformation(data.name)
	end
	return blockTable[data.name] == true
end

local inspectFunctions = {
	[forward] = turtle.inspect,
	[up] = turtle.inspectUp,
	[down] = turtle.inspectDown
}
local digFunctions = {
	[forward] = turtle.dig,
	[back] = function ()
				turnAround()
				turtle.dig()
				turnAround()
			end,
	[up] = turtle.digUp,
	[down] = turtle.digDown
}
local moveFunctions = {
	[forward] = turtle.forward,
	[back] = turtle.back,
	[up] = turtle.up,
	[down] = turtle.down
}

local function inspectDiraction(diraction)
	if (debug) then
		LOGGER.debugWrite(4, "inspectDiraction called with diraction = " .. diraction)
	end
	if (inspect(inspectFunctions[diraction])) then
		digDiraction(
			digFunctions[diraction], 
			moveFunctions[diraction]
		)
		digDiraction(
			digFunctions[otherDirection[diraction]], 
			moveFunctions[otherDirection[diraction]]
		)
	end
end

function inspector.inspectAround()
	inspectDiraction(up)
	inspectDiraction(down)
	for i = 1, 4, 1 do
		inspectDiraction(forward)
		turtle.turnRight()
	end
end

function inspector.init()
	file = io.open(blockInfoFileName, "r")
	prepairBlockInforation(file, separators[" "])
end

function inspector.onStop()
	if (newBlockInfoFile ~= nil) then
		newBlockInfoFile:close()
	end
end