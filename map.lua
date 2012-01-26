function createMaplist()
	maplist = {}
	local files = love.filesystem.enumerate("maps/")
	for i,v in ipairs(files) do
		local a,b,name = string.find(v,"(.*).lua")
		if name ~= nil then
			table.insert(maplist,name)
		end
	end
	print("Found " .. #maplist .." maps:")
	for i,v in ipairs(maplist) do
		print("- " .. v)
	end
end

function loadMap(name)
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

	-- Perform full garbage collection
	collectgarbage("collect")

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
			elseif r == 0 and g == 255 and b == 255 then -- test floor
				map[ix][iy] = TILE_TESTFLOOR
			elseif r == 0 and g == 128 and b == 0 then -- grass
				map[ix][iy] = TILE_GRASS
			elseif r == 0 and g == 0 and b == 255 then -- slab
				map[ix][iy] = TILE_SLABS
			elseif r == 255 and g == 0 and b == 255 then -- window wall
				map[ix][iy] = TILE_WINDOW

			-- default to black cell
			else map[ix][iy] = 0
			end
		end
	end

	-- load entities and objects
	local conf = love.filesystem.load("maps/"..name..".lua")
	conf()

	restartLevel()
	print("Loaded map \""..name.."\"...")
end

-- Map helper functions
local consts = {
	-- Special entities
	door = Door.create,
	closet = Closet.create,
	recordplayer = RecordPlayer.create,
	telephone = Telephone.create,
	vent = Vent.create,
	pressureplate = PressurePlate.create,
	switch = Switch.create,
	-- Containers
	toilet = Toilet.create,
	fridge = Fridge.create,
	cabinet = Cabinet.create,
	locker = Locker.create,
	safe = Safe.create,
	-- Furniture
	sofa = Sofa.create,
	bed = Bed.create,
	bossdesk = BossDesk.create,
	-- Decoration
	painting = Painting.create,
	projector = Projector.create,
	projectorimage = ProjectorImage.create,
	shower = Shower.create,
	entrance = Entrance.create,
	television = Television.create,
	plant = Plant.create,
	watercooler = Watercooler.create,
	-- Table decorations
	tabledecor = TableDecor.create,
	sink = function(x,y) return TableDecor.create(x,y,0) end,
	typewriter = function(x,y) return TableDecor.create(x,y,1) end,
	chair = function(x,y) return TableDecor.create(x,y,2) end,
	desktelephone = function(x,y) return TableDecor.create(x,y,3) end,
	book = function(x,y) return TableDecor.create(x,y,4) end,
	desklamp = function(x,y) return TableDecor.create(x,y,5) end,
	chairfront = function(x,y) return TableDecor.create(x,y,6) end,
	oven = function(x,y) return TableDecor.create(x,y,7) end,
	plate = function(x,y) return TableDecor.create(x,y,8) end,
}

function add(t,x,y,...)
	local e = consts[t](x,y,...)
	table.insert(entities[y],e)
	return e
end

function addRobot(points)
	local rob = Robot.create(points)
	table.insert(robots,rob)
	return rob
end

function addRotatingRobot(points)
	local rob = RotatingRobot.create(points)
	table.insert(robots,rob)
	return rob
end

function addCamera(...)
	local cam = Camera.create(...)
	table.insert(cameras,cam)
	return cam
end

function addLaser(x0,y0,x1,y1)
	local laser = Laser.create(x0,y0,x1,y1)
	table.insert(entities[math.min(y0,y1)],laser)
	return laser
end

function addTimedLaser(x0,y0,x1,y1,...)
	local tlaser = TimedLaser.create(x0,y0,x1,y1,...)
	table.insert(entities[math.min(y0,y1)],tlaser)
	return tlaser
end
