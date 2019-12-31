-- Static varables --
--Tech varables
require "modules/LOGGER";
require "modules/directions";
require "modules/digAndMove";
require "modules/inspector";
require "modules/slotInformation";
debug = false

-- Invite --
print("Welcome to Digging programm!")
if (debug) then
	LOGGER.debugWrite(0, "debug enabled")
end

-- Program body --
local startStep
local endStep = 0
local startHeight = 2

function main()
	digAndMove.mine(startStep, endStep, startHeight)
end

function init()
	write("Enter start step (length = step * " .. stepDeep .. "):")
	startStep = tonumber(read())

	write("Enter step count:")
	local count = tonumber(read())
	endStep = startStep + count

	write("Enter start height:")
	startHeight = tonumber(read())

	slotInformation.init()
	inspector.init()
end

function stop()
	inspector.onStop()
	LOGGER.onStop()
end

init()
local complete, status = pcall(main)

--Ending--
if (complete) then 
	print("Completed!")
else
	print("Completed with errors:")
	print(status)
end

--Exit preparations
stop()