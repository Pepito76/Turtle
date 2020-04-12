if not turtle then
    error( "Cannot load turtle API on computer", 2 )
end
native = turtle.native or turtle

local function addCraftMethod( object )
    if peripheral.getType( "left" ) == "workbench" then
        object.craft = function( ... )
            return peripheral.call( "left", "craft", ... )
        end
    elseif peripheral.getType( "right" ) == "workbench" then
        object.craft = function( ... )
            return peripheral.call( "right", "craft", ... )
        end
    else
        object.craft = nil
    end
end

-- Put commands into environment table
local env = _ENV
for k,v in pairs( native ) do
    if k == "equipLeft" or k == "equipRight" then
        env[k] = function( ... )
            local result, err = v( ... )
            addCraftMethod( turtle )
            return result, err
        end
    else
        env[k] = v
    end
end
addCraftMethod( env )


local facing = 0
local pos = {x = 0, y = 0, z = 0}
local version = 0.0.1

function getVersion()
	return version
end

function getPos()
	return {x = pos.x, y = pos.y, z = pos.z}
end

function getFacing()
	return facing
end

local function update(move)
	if(move == "forward") then
		if(facing == 0) then
			pos.x = pos.x + 1
		elseif (facing == 1) then
			pos.z = pos.z + 1
		elseif (facing == 2) then
			pos.x = pos.x - 1
		elseif (facing == 3) then
			pos.z = pos.z - 1
		end
	elseif(move == "backward") then
		if(facing == 0) then
			pos.x = pos.x - 1
		elseif (facing == 1) then
			pos.z = pos.z - 1
		elseif (facing == 2) then
			pos.x = pos.x + 1
		elseif (facing == 3) then
			pos.z = pos.z + 1
		end
	elseif(move == "up") then
		pos.y = pos.y + 1
	elseif(move == "down") then
		pos.y = pos.y - 1
	end
end

function getStatus()
	return facing, pos
end

function turnLeft(n)
	n = n or 1
	for i=1, n do
		turtle.native.turnLeft()
		facing = facing - 1
		if(facing == -1) then
			facing = 3
		end
	end
end

function turnRight(n)
	n = n or 1
	for i=1, n do
		turtle.native.turnRight()
		facing = facing + 1
		if(facing == 4) then
			facing = 0
		end
	end
end

function forward(n)
	n = n or 1
	for i = 1, n do
		while not turtle.native.forward() do
			turtle.native.dig()
		end
		update("forward")
	end
end

function back(n)
	n = n or 1
	for i = 1, n do
		if(turtle.native.back())then
			update("backward")
		end
	end
end

function up(n)
	n = n or 1
	for i = 1, n do
		while not turtle.native.up() do
			turtle.native.digUp()
		end
		update("up")
	end
end

function down(n)
	n = n or 1
	for i = 1, n do
		while not turtle.native.down() do
			turtle.native.digDown()
		end
		update("down")
	end
end

function goFacing(dir)
	if(facing == 0) then
		if(dir == 1) then
			turnRight()
		elseif(dir == 2) then
			turnRight(2)
		elseif(dir == 3) then
			turnLeft(1)
		end
	elseif(facing == 1) then
		if(dir == 0) then
			turnLeft()
		elseif(dir == 2) then
			turnRight()
		elseif(dir == 3) then
			turnRight(2)
		end
	elseif(facing == 2) then
		if(dir == 0) then
			turnRight(2)
		elseif(dir == 1) then
			turnLeft()
		elseif(dir == 3) then
			turnRight()
		end
	elseif(facing == 3) then
		if(dir == 0) then
			turnRight()
		elseif(dir == 1) then
			turnRight(2)
		elseif(dir == 2) then
			turnLeft()
		end
	end
end


function go(x, y, z, dir)
	x   = x   or 0
	y   = y   or 0
	z   = z   or 0

	x = x - pos.x
	if(x < 0) then
		goFacing(2)
		forward(math.abs(x))
	elseif(x > 0) then
		goFacing(0)
		forward(x)
	end

	z = z - pos.z
	if(z < 0) then
		goFacing(3)
		forward(math.abs(z))
	elseif(z > 0) then
		goFacing(1)
		forward(z)
	end

	y = y - pos.y
	if(y < 0) then
		down(math.abs(y))
	elseif(y > 0) then
		up(y)
	end
end
