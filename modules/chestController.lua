chestController = {}

chestController.chestSlot = 2
chestController.hasChests = true

local function getChestCount()
	return turtle.getItemCount(chestController.chestSlot)
end

local function processEmptyChestSlot()
	LOGGER.debugWrite(0, "Last chest. Stop Chest Installation.")
	hasChests = false
end

function chestController.placeChest()
	if (not chestController.hasChests) then
		return hasChests
	end
	if (debug) then
		LOGGER.debugWrite(4, "placeChest called")
		LOGGER.debugWrite(1, "Cests left: " .. getChestCount())
	end
	turtle.select(chestController.chestSlot)
	turtle.place()
	if (turtle.getItemCount(chestController.chestSlot) == 0) then
		processEmptyChestSlot()
	end
	return hasChests
end

function chestController.setChestSlot(slotNumer)
	-- if (checkNewSlotNumber(slotNumer)) then
	-- 	chestController.chestSlot = slotNumer or chestController.chestSlot
	-- 	return true
	-- else
	-- 	return false
	-- end
end