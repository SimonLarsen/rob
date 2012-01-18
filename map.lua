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
local consts = {
	-- Special entities
	door = Door.create,
	closet = Closet.create,
	recordplayer = RecordPlayer.create,
	telephone = Telephone.create,
	vent = Vent.create,
	-- Containers
	toilet = Toilet.create,
	fridge = Fridge.create,
	cabinet = Cabinet.create,
	locker = Locker.create,
	safe = Safe.create,
	-- Furniture
	sofa = Sofa.create,
	bed = Bed.create,
	-- Decoration
	painting = Painting.create,
	shower = Shower.create,
	entrance = Entrance.create,
	television = Television.create,
	plant = Plant.create,
	watercooler = Watercooler.create,
	-- Table decorations
	sink = function(x,y) return TableDecor.create(x,y,0) end,
	typewriter = function(x,y) return TableDecor.create(x,y,1) end,
	chair = function(x,y) return TableDecor.create(x,y,2) end,
	desktelephone = function(x,y) return TableDecor.create(x,y,3) end,
	book = function(x,y) return TableDecor.create(x,y,4) end,
	desklamp = function(x,y) return TableDecor.create(x,y,5) end,
	chairfront = function(x,y) return TableDecor.create(x,y,6) end,
	oven = function(x,y) return TableDecor.create(x,y,7) end,
}

function add(t,x,y,...)
	local e = consts[t](x,y,...)
	table.insert(entities[y],e)
	return e
end
