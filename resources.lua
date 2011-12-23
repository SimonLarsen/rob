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
end
