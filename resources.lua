keys = {}
keys[1] = {"up","down","left","right","return"}
keys[2] =  {"w","s","a","d"," "}

local lg = love.graphics

function loadImages()
	imgTiles = 	lg.newImage("res/tiles.png")
	imgTiles:setFilter("nearest","nearest")
	local tilew,tileh = imgTiles:getWidth(), imgTiles:getHeight()

	imgSprites = lg.newImage("res/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	local sprw, sprh = imgSprites:getWidth(), imgSprites:getHeight()

	imgLight = lg.newImage("res/lightbig.png")
	imgLight:setFilter("nearest","nearest")
	imgLightSmall = lg.newImage("res/lightsmall.png")
	imgLightSmall:setFilter("nearest","nearest")

	quadTiles = {}
	for ix = 0,15 do
		quadTiles[ix] = lg.newQuad(ix*CELLW,0,CELLW,CELLH,tilew,tileh)
	end

	quadWall = {}
	quadWall[0] = lg.newQuad(0, 128, 8, 32, tilew, tileh)
	quadWall[1] = lg.newQuad(4, 128, 8, 32, tilew, tileh)
	quadWall[2] = lg.newQuad(8, 128, 8, 32, tilew, tileh)

	quadHerbie = {}
	quadJamal = {}
	for i=0,5 do
		quadHerbie[i] = lg.newQuad(i*16,0,14,21,sprw,sprh)
		quadJamal[i] = lg.newQuad(80+i*16,0,11,27,sprw,sprh)
	end

	quadRobot = {}
	for i=0,11 do
		quadRobot[i] = lg.newQuad(i*16,32,11,32,sprw,sprh)
	end

	-- entity quads
	quadDoorOpen   = lg.newQuad(32,128,16,32,tilew,tileh)
	quadDoorClosed = lg.newQuad(16,128,16,32,tilew,tileh)
	quadSafeClosed = lg.newQuad(48,128,16,24,tilew,tileh)
	quadSafeOpen   = lg.newQuad(64,128,16,24,tilew,tileh)
	quadCabinet    = lg.newQuad(64,152,32,24,tilew,tileh)
	quadFridgeClosed = lg.newQuad(96,128,16,32,tilew,tileh)
	quadFridgeOpen   = lg.newQuad(112,128,16,32,tilew,tileh)
	quadCrate      = lg.newQuad( 0, 16,16,24,tilew,tileh)
	quadVentFront  = lg.newQuad(32,160,16, 8,tilew,tileh)
	quadVentSide   = lg.newQuad(32,168,16, 8,tilew,tileh)
	quadTable = {}
	quadTable[0]   = lg.newQuad(16,16,16,17,tilew,tileh)
	quadTable[1]   = lg.newQuad(24,16,16,17,tilew,tileh)
	quadKitchenTableLined = lg.newQuad(80,128,8,24,tilew,tileh)
	quadKitchenTableNoLine = lg.newQuad(88,128,8,24,tilew,tileh)
	quadPainting = {}
	for i = 0,4 do
		quadPainting[i] = lg.newQuad(i*16,176,16,16,tilew,tileh)
	end
	quadTableDecor = {}
	for i = 0,7 do
		quadTableDecor[i] = lg.newQuad(i*16,208,16,24,tilew,tileh)
	end
	quadPlant = {}
	for i = 0,1 do
		quadPlant[i] = lg.newQuad(i*16,96,16,24,tilew,tileh)
	end
	-- camera quads
	quadCameraSide = lg.newQuad(0,200,9,7,tilew,tileh)
	quadCameraSideShadow = lg.newQuad(9,200,8,3,tilew,tileh)
	quadCameraDown = lg.newQuad(17,200,3,8,tilew,tileh)
	quadCameraDownShadow = lg.newQuad(20,200,3,6,tilew,tileh)
	quadCameraDown = lg.newQuad(17,200,3,8,tilew,tileh)
	quadCameraUp = lg.newQuad(23,200,3,8,tilew,tileh)

	-- action quads
	quadAction = {}
	for i = 1,4 do
		quadAction[i] = lg.newQuad((i-1)*16,64,9,9,sprw,sprh)
	end
end

function loadMapFromImage(filename)
	local mapData = love.image.newImageData(filename)
	MAPW = mapData:getWidth()
	MAPH = mapData:getHeight()

	map = {}
	for i = -1,MAPW do
		map[i] = {}
	end

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

			else
				map[ix][iy] = 0
			end
		end
	end

	table.insert(entities[22],Safe.create(17,22))

	table.insert(entities[11],Painting.create(2,11,0))
	table.insert(entities[11],Painting.create(4,11,1))

	table.insert(entities[11],Cabinet.create(10,11))

	table.insert(entities[1],Vent.create(12,1,0,1,1))
	table.insert(entities[1],Vent.create(14,1,1,0,-1))

	table.insert(entities[9], Vent.create(3, 9,2,3,1337))
	table.insert(entities[11],Vent.create(3,11,3,2,0))

	table.insert(entities[11],Plant.create(1,11,0))
	table.insert(entities[11],Plant.create(12,11,1))

	table.insert(entities[1],TableDecor.create(3,1,0))
	table.insert(entities[1],TableDecor.create(2,1,7))

	table.insert(entities[13],TableDecor.create(2,13,1))
	table.insert(entities[14],TableDecor.create(3,14,2))
	table.insert(entities[17],TableDecor.create(3,17,2))
	table.insert(entities[14],TableDecor.create(9,14,2))
	table.insert(entities[17],TableDecor.create(9,17,2))
	table.insert(entities[16],TableDecor.create(4,16,3))
	table.insert(entities[16],TableDecor.create(8,16,4))
	table.insert(entities[16],TableDecor.create(10,16,5))

	table.insert(entities[1],Fridge.create(4,1))

	table.insert(entities[14],TableDecor.create(16,14,2))
	table.insert(entities[14],TableDecor.create(18,14,2))
	table.insert(entities[14],TableDecor.create(20,14,2))
	table.insert(entities[13],TableDecor.create(16,13,6))
	table.insert(entities[13],TableDecor.create(18,13,6))
	table.insert(entities[13],TableDecor.create(20,13,6))
end
