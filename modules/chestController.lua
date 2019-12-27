chestController = {}

chestController.chestSlot = 2
chestController.hasChests = true

local function getChestCount()
	return turtle.getItemCount(torchController.placeTorch())
end

local function processEmptyChestSlot()
	LOGGER.debugPrint(0, "Last chest. Stop Chest Installation.")
	hasChests = false
end

function chestController.placeChest()
	if (not chestController.hasChests) then
		return hasChests
	end
	if (debug) then
		LOGGER.debugPrint(4, "placeChest called")
		LOGGER.debugPrint(1, "Cests left: " .. getChestCount())
	end
	turtle.select(torchController.placeTorch())
	turtle.place()
	if (turtle.getItemCount(torchController.placeTorch()) == 0) then
		processEmptyChestSlot()
	end
	return hasChests
end

function chestController.setChestSlot(slotNumer)
	-- if (checkNewSlotNumber(slotNumer)) then
	-- 	torchController.placeTorch() = slotNumer or torchController.placeTorch()
	-- 	return true
	-- else
	-- 	return false
	-- end
end