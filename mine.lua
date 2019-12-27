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
	LOGGER.debugPrint(0, "debug enabled")
end

-- Program body --

function main()
	while startStep < endStep do
		LOGGER.debugPrint(1, "step = " .. startStep)
		digAndMove.digLevel()
		startStep = startStep + 1
	end
end

function init()
	write("Enter start step (length = step * " .. stepDeep .. "):")
	startStep = read() + 0

	write("Enter end step:")
	endStep = read() + 0

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