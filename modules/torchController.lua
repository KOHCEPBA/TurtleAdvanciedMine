torchController = {}

torchController.torchSlot = 1
torchController.hasTorches = true

local function findTorchesInInventory()
	if (debug) then
		LOGGER.debugPrint(4, "findTorchesInInventory called")
	end
	for i = 1, slotsCount, 1 do
		turtle.select(i)
		turtle.compareDown()
	end
end

local function getTorchCount()
	return turtle.getItemCount(torchController.torchSlot)
end

local function processEmptyTorchSlot()
	LOGGER.debugPrint(0, "Last torch. Stop Torch Installation.")
	hasTorches = false
end

function torchController.placeTorch()
	if (not torchController.hasTorches) then
		return hasTorches
	end
	if (debug) then
		LOGGER.debugPrint(4, "setTorch called")
		LOGGER.debugPrint(1, "Torches left: " .. getTorchCount())
	end
	turtle.select(torchController.torchSlot)
	turtle.placeDown()
	if (turtle.getItemCount(torchController.torchSlot) == 0) then
		processEmptyTorchSlot()
	end
	return hasTorches
end

function torchController.setTorchSlot(slotNumer)
	-- if (checkNewSlotNumber(slotNumer)) then
	-- 	torchSlot = slotNumer or torchSlot
	-- 	return true
	-- else
	-- 	return false
	-- end
end