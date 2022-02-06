-- Static varables --
--Tech varables
require "modules/LOGGER";
require "modules/directions";
require "modules/digAndMove";
require "modules/inspector";
require "modules/slotInformation";
require "settingsModule/configuration";
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
	local properties = configuration.ReadPropertiesFile(PropertiesPath, {})
	print("Загруженные настройки:")
	configuration.Print_Table(properties)

	startStep = tonumber(properties[PropertiesName.startStep])
	local count = tonumber(properties[PropertiesName.count])
	endStep = startStep + count
	startHeight = tonumber(properties[PropertiesName.startHeight])

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