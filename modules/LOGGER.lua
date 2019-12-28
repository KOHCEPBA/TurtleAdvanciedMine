LOGGER = {}
local logLevel = 2
local logLevels = {"Info", "Debug", "2", "3", "Trace"}
local logFile = nil

function LOGGER.setLogLevel(level)
	logLevel = level or logLevel
end

function LOGGER.debugWrite(level, message)
	level = level or 4
	if (debug and level <= logLevel) then
		if (logFile == nil) then
			logFile = io.open("resuorces/log.txt", "a")
		end 
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