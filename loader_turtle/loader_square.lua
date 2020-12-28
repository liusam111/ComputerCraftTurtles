local SLOT_COUNT = 16
local numTurtles = tonumber(arg[1])
local digSquareSize = tonumber(arg[2])
local willTurnRight = true
	
if(numTurtles == nil or digSquareSize == nil) then
	print("None of malformed inputs given")
	print()
	print("Usage: load_turtle_square <num_turtles_one_side> <dig_square_size>")
	return
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

function dropItems()
	print("Purging Inventory...")
	for slot = 1, SLOT_COUNT, 1 do
		local item = turtle.getItemDetail(slot)
		if(item ~= nil) then
			if(item["name"] ~= "minecraft:coal" and item["name"] ~= "enderstorage:ender_storage") then
				turtle.select(slot)
				turtle.drop()
			end
		end
	end
end


function loadTurtle()
	enderIndex = getEnderIndex()

	if(enderIndex == nil) then
		return
	end
	
	turtle.select(enderIndex)
	turtle.digUp()	
	turtle.placeUp()  
	turtle.suckUp(64)
	turtle.suckUp(1)
	
	enderIndex = getEnderIndex()
	coalIndex = mergeCoal()
	
	turtle.select(enderIndex)
	turtle.dropDown()
	turtle.select(coalIndex)
	turtle.dropDown()
	
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

function forward()
	for position = 1, digSquareSize, 1 do
		if(turtle.detect()) then
			turtle.dig()
		end
		turtle.forward()
	end
end

function turn()
	if(willTurnRight) then
		turtle.turnRight()
	else
		turtle.turnLeft()
	end
end

function start()
	for row = 1, numTurtles, 1 do
		for col = 1, numTurtles, 1 do
			if(not checkFuel()) then
				print("Turtle is out of fuel, Powering Down...")
				return
			end
		
			loadTurtle()
			dropItems()
			
			
			if(col ~= numTurtles) then
				forward()
			end
		end
		
		if(row ~= numTurtles) then
			turn()
			forward()
			turn()
			willTurnRight = not willTurnRight
		end
	end
end

start()
