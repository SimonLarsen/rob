function loadMapFromImage(name)
	-- get map dimensions
	local mapData = love.image.newImageData("maps/"..name..".png")
	MAPW = mapData:getWidth()
	MAPH = mapData:getHeight()

	-- clear entities and objects
	entities = {}
	for i=0,MAPH-1 do
		entities[i] = {}
	end
	robots = {}
	cameras = {}

	map = {}
	for i = -1,MAPW do
		map[i] = {}
	end

	-- load tiles from image
	for ix = 0, MAPW-1 do
		for iy = 0, MAPH-1 do
			r,g,b = mapData:getPixel(ix,iy)
			-- FLOOR TILES
			if r == 127 and g == 0 and b == 0 then -- dark floor
				map[ix][iy] = TILE_DARKFLOOR
			elseif r == 102 and g == 102 and b == 102 then -- tiles
				map[ix][iy] = TILE_TILEFLOOR
			elseif r == 255 and g == 255 and b == 0 then -- wooden floor
				map[ix][iy] = TILE_WOODFLOOR
			-- MISC
			elseif r == 0 and g == 0 and b == 255 then	-- door
				map[ix][iy] = TILE_DOOR
				if map[ix-1][iy] == TILE_WALL then
					table.insert(entities[iy],Door.create(ix,iy,0))
				else
					table.insert(entities[iy],Door.create(ix,iy,1))
				end

			elseif r == 255 and g == 255 and b == 255 then -- wall
				map[ix][iy] = TILE_WALL
			elseif r == 255 and g == 128 and b == 0 then -- crate
				map[ix][iy] = TILE_CRATE
			elseif r == 255 and g == 56 and b == 0 then -- double crate
				map[ix][iy] = TILE_DOUBLECRATE
			elseif r == 128 and g == 64 and b == 0 then -- table
				map[ix][iy] = TILE_TABLE
			elseif r == 0 and g == 255 and b == 0 then -- kitchen table
				map[ix][iy] = TILE_KITCHEN

			-- default to black cell
			else
				map[ix][iy] = 0
			end
		end
	end

	-- load entities and objects
	local conf = love.filesystem.load("maps/"..name..".lua")
	conf()
end

-- Map helper functions
add = {}
function add.door(x,y,dir,lock)
	table.insert(entities[y],Door.create(x,y,dir,lock))
end

-- Entities
function add.vent(x,y,dir,id,dest)
	table.insert(entities[y],Vent.create(x,y,dir,id,dest)) end

-- Containers
function add.cabinet(x,y,storage)
	table.insert(entities[y],Cabinet.create(x,y,storage))
end
function add.locker(x,y,storage)
	table.insert(entities[y],Locker.create(x,y,storage))
end
function add.fridge(x,y,storage)
	table.insert(entities[y],Fridge.create(x,y,storage))
end

-- Table decors
function add.sink(x,y)
	table.insert(entities[y],TableDecor.create(x,y,0))
end
function add.oven(x,y)
	table.insert(entities[y],TableDecor.create(x,y,7))
end

-- Decoration stuff
function add.painting(x,y,id)
	table.insert(entities[y],Painting.create(x,y,id))
end
function add.entrance(x,y)
	table.insert(entities[y],Entrance.create(x,y))
end
