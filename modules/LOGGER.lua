LOGGER = {}
local logLevel = 4
local logLevels = {"Info", "Debug", "2", "3", "Trace"}
if (debug) then
	local logFile = io.open("resuorces/log.txt", "a")
end

function LOGGER.setLogLevel(level)
	logLevel = level or logLevel
end

function LOGGER.debugPrint(level, message)
	level = level or 4
	if (debug and level <= logLevel) then
		logFile:write(
			"[" 
			.. (logLevels[level + 1] or "unknow") 
			.. "]" .. ": " 
			.. message 
			.. "\n"
		)
	end
end

function LOGGER.onStop()
	if (debug) then
		logFile:close()
	end
end