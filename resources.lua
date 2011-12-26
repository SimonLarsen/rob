keys = {}
keys[1] = {"up","down","left","right","return"}
keys[2] =  {"w","s","a","d"," "}

local lg = love.graphics

function loadImages()
	imgTiles = 	lg.newImage("res/tiles.png")
	imgTiles:setFilter("nearest","nearest")
	quadTiles = {}

	local tilew,tileh = imgTiles:getWidth(), imgTiles:getHeight()
	for ix = 0,15 do
		quadTiles[ix] = lg.newQuad(ix*CELLW,0,CELLW,CELLH,tilew,tileh)
	end

	quadWall = {}
	quadWall[0] = lg.newQuad(0, 128, 8, 32, tilew, tileh)
	quadWall[1] = lg.newQuad(4, 128, 8, 32, tilew, tileh)
	quadWall[2] = lg.newQuad(8, 128, 8, 32, tilew, tileh)

	imgSprites = lg.newImage("res/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	sprw, sprh = imgSprites:getWidth(), imgSprites:getHeight()

	quadHerbie = {}
	quadJamal = {}
	for i=0,5 do
		quadHerbie[i] = lg.newQuad(i*16,0,14,21,sprw,sprh)
		quadJamal[i] = lg.newQuad(80+i*16,0,11,27,sprw,sprh)
	end

	-- entity quads
	quadDoorOpen   = lg.newQuad(32,128,16,32,tilew,tileh)
	quadDoorClosed = lg.newQuad(16,128,16,32,tilew,tileh)
	quadTable      = lg.newQuad( 0,160,32,16,tilew,tileh)
	quadSafeClosed = lg.newQuad(48,128,16,24,tilew,tileh)
	quadSafeOpen   = lg.newQuad(64,128,16,24,tilew,tileh)
	quadCabinet    = lg.newQuad(64,152,32,24,tilew,tileh)
	quadCrate      = lg.newQuad(80,128,16,24,tilew,tileh)
	quadVentFront  = lg.newQuad(32,160,16, 8,tilew,tileh)
	quadVentSide   = lg.newQuad(32,168,16, 8,tilew,tileh)

	-- decor quads
	quadPainting = {}
	for i = 0,3 do
		quadPainting[i] = lg.newQuad(i*16,176,16,16,tilew,tileh)
	end

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
			if r == 255 and g == 255 and b == 255 then
				map[ix][iy] = 10
			elseif r == 127 and g == 0 and b == 0 then
				map[ix][iy] = 1
			elseif r == 255 and g == 255 and b == 0 then
				map[ix][iy] = 3
			elseif r == 102 and g == 102 and b == 102 then
				map[ix][iy] = 2
			elseif r == 0 and g == 0 and b == 255 then
				map[ix][iy] = 1
				if map[ix-1][iy] == 10 then
					table.insert(entities[iy],Door.create(ix,iy,0))
				else
					table.insert(entities[iy],Door.create(ix,iy,1))
				end
			else
				map[ix][iy] = 0
			end
		end
	end
	table.insert(entities[13],Table.create(3,13))
	table.insert(entities[13],Table.create(8,13))
	table.insert(entities[16],Table.create(3,16))
	table.insert(entities[16],Table.create(8,16))

	table.insert(entities[22],Safe.create(17,22))

	table.insert(entities[11],Painting.create(2,11,0))
	table.insert(entities[11],Painting.create(4,11,1))

	table.insert(entities[11],Cabinet.create(10,11))

	table.insert(entities[3],Crate.create(16,3))
	table.insert(entities[3],Crate.create(15,3))

	table.insert(entities[6],Crate.create(16,6))
	table.insert(entities[6],Crate.create(15,6))

	table.insert(entities[3],Crate.create(21,3))
	table.insert(entities[3],Crate.create(20,3))

	table.insert(entities[6],Crate.create(21,6))
	table.insert(entities[6],Crate.create(20,6))

	table.insert(entities[1],Vent.create(4,1,0,0))
	table.insert(entities[1],Vent.create(12,1,0,1))
	table.insert(entities[1],Vent.create(14,1,0,-1))
end
