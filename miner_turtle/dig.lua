local SLOT_COUNT = 16
local EMPTY_INV_COUNT = 16
local d = "north"
local width, depth, height = 10, 10, 2

if (#arg == 3) then
	width = tonumber(arg[1])
	depth = tonumber(arg[2])
	height = tonumber(arg[3])
else
	print('None or Malformed Size Given, Defaulting to 10x10x2 down')
end


DROPPED_ITEMS = {
	"minecraft:stone",
	"minecraft:dirt",
	"minecraft:cobblestone",
	"minecraft:sand",
	"minecraft:gravel",
	"minecraft:clay_ball",
	"railcraft:ore_metal",
	"extrautils2:ingredients",
	"thaumcraft:nugget",
	"thaumcraft:curio",
	"thaumcraft:crystal_essence",
	"thaumcraft:amber",
	"thermalfoundation:material",
	"projectred-core:resource_item",
	"thaumcraft:ore_cinnabar",
	"deepresonance:resonating_crystal",
	"forestry:apatite",
	"chisel:basalt2",
	"chisel:limestone2",
	"chisel:marble2",
	"astralsorcery:blockmarble",
	"rustic:slate",
	"forestry:apatite"
}

function dropItems()
	print("Purging Inventory...")
	for slot = 1, SLOT_COUNT, 1 do
		local item = turtle.getItemDetail(slot)
		if(item ~= nil) then
			for filterIndex = 1, #DROPPED_ITEMS, 1 do
				if(item["name"] == DROPPED_ITEMS[filterIndex]) then
					print("Dropping - " .. item["name"])
					turtle.select(slot)
					turtle.dropDown()
				end
			end
		end
	end
end


function mergeCoal()
	local firstCoal = nil
	for slot = 1, SLOT_COUNT, 1 do
		local item = turtle.getItemDetail(slot)
		if(item ~= nil) then
			if(item["name"] == "minecraft:coal") then
				if(firstCoal == nil) then
					firstCoal = slot
				end
				
				turtle.select(slot)
				turtle.transferTo(firstCoal)
			end
		end
	end
	
	return firstCoal
end



function getEnderIndex()
	for slot = 1, SLOT_COUNT, 1 do
		local item = turtle.getItemDetail(slot)
		if(item ~= nil) then
			if(item["name"] == "enderstorage:ender_storage") then
				return slot
			end
		end
	end
	return nil
end

function manageInventory()
	dropItems()
	enderIndex = getEnderIndex()
	coalIndex = mergeCoal()
	
	if(enderIndex ~= nil) then
		turtle.select(enderIndex)
		turtle.digUp()	  
		turtle.placeUp()  
	end
	-- Chest is now deployed
	for slot = 1, SLOT_COUNT, 1 do
		local item = turtle.getItemDetail(slot)
		if(item ~= nil) then
			if(item["name"] ~= "minecraft:coal" or slot ~= coalIndex) then
				turtle.select(slot)
				turtle.dropUp()
			end
		end
	end
	-- Items are now stored

	turtle.digUp()
end

function checkFuel()
	turtle.select(1)
	
	if(turtle.getFuelLevel() < 50) then
		print("Attempting Refuel...")
		for slot = 1, SLOT_COUNT, 1 do
			turtle.select(slot)
			if(turtle.refuel(1)) then
				return true
			end
		end

		return false
	else
		return true
	end
end


function detectAndDig()
	while(turtle.detect()) do
		turtle.dig()
		turtle.digUp()
		turtle.digDown()
	end
end

function forward()
	detectAndDig()
	turtle.forward()
end

function leftTurn()
	turtle.turnLeft()
	detectAndDig()
	turtle.forward()
	turtle.turnLeft()
	detectAndDig()
end


function rightTurn()
	turtle.turnRight()
	detectAndDig()
	turtle.forward()
	turtle.turnRight()
	detectAndDig()
end

function flipDirection()
	if(d == "north") then
		d = "south"
	elseif(d == "south") then
		d = "north"
	elseif(d == "west") then
		d = "east"
	elseif(d == "east") then
		d = "west"
	end
	
end

function turnAround(tier)
	if(tier % 2 == 1) then
		if(d == "north" or d == "east") then
			rightTurn()
		elseif(d == "south" or d == "west") then
			leftTurn()
		end
	else
		if(d == "north" or d == "east") then
			leftTurn()
		elseif(d == "south" or d == "west") then
			rightTurn()
		end
	end
	flipDirection()
end


function dropTier()
	if(turtle.detectDown()) then
		local success, block = turtle.inspectDown()
		if(success and block["name"] == "minecraft:bedrock") then
			return false
		end
	end

	turtle.turnRight()
	turtle.turnRight()
	flipDirection()
	turtle.digDown()
	turtle.down()
	return true
end



function returnToTop(tiersLowered)
	for tier = 0, tiersLowered, 1 do
		turtle.digUp()
		turtle.up()
	end
end



function start()
	local blocksMoved = 0
	local tiersLowered = 0
	
	for tier = 1, height, 1 do
		for col = 1, width, 1 do
			for row = 1, depth - 1, 1 do
				if(not checkFuel()) then
					print("Turtle is out of fuel, Powering Down...")
					return
				end
				forward()
				print(string.format("Row: %d   Col: %d", row, col))

				blocksMoved = blocksMoved + 1
				if(blocksMoved == EMPTY_INV_COUNT) then
					manageInventory()
					blocksMoved = 0
				end
			end
			if(col ~= width) then
				turnAround(tier)
			end
		end
		local success = dropTier()
		if(not success) then
			break
		end
		tiersLowered = tiersLowered + 1
	end

	returnToTop(tiersLowered)
	manageInventory()
end

start()

