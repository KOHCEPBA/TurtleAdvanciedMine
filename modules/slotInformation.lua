require "modules/torchController";
require "modules/chestController";

slotInformation = {}

local slotsCount = 16
local maxFilledSlots = 13

local slotsInfo = {}
local tech = "tech"

function checkNewSlotNumber(slotNumber)
	return slotNumber >= 1 and slotNumber <= slotsCount
end

function slotInformation.init()
	slotsInfo[torchController.torchSlot] = tech
	slotsInfo[chestController.chestSlot] = tech
end

local function hasSpace()
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

local function dropItems(dropFunction)
	for i = slotsCount, 1, -1 do
		if (slotsInfo[i] ~= tech) then
			turtle.select(i)
			dropFunction()
		end
	end
end

local function moveAndDrop()
	turtle.back()
	turnDirection[tonelDirection]()
	turtle.dig()
	turtle.forward()
	turtle.digUp()
	turtle.back()
	chestController.placeChest()
	dropItems(turtle.drop)
	turnDirection[otherDirection[tonelDirection]]()
	turtle.forward()
	if (not chestController.hasChests) then
		error("No more chests")
	end
end

function slotInformation.checkSpace()
	if (not hasSpace()) then
		moveAndDrop()
	end
end