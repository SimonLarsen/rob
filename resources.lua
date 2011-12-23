keys = {}
keys[1] = {"up","down","left","right"}
keys[2] =  {"w","s","a","d"}

function loadImages()
	imgTiles = 	love.graphics.newImage("res/tiles.png")
	imgTiles:setFilter("nearest","nearest")
	quadTiles = {}

	local imgw,imgh = imgTiles:getWidth(), imgTiles:getHeight()
	for ix = 0,15 do
		for iy = 0,15 do
			quadTiles[ix+iy*16] = love.graphics.newQuad(ix*CELLW,iy*CELLH,CELLW,CELLH,imgw,imgh)
		end
	end

	quadWall = {}
	quadWall[0] = love.graphics.newQuad(0, 128, 8, 32, imgw, imgh)
	quadWall[1] = love.graphics.newQuad(4, 128, 8, 32, imgw, imgh)
	quadWall[2] = love.graphics.newQuad(8, 128, 8, 32, imgw, imgh)

	imgSprites = love.graphics.newImage("res/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	imgw, imgh = imgSprites:getWidth(), imgSprites:getHeight()

	quadHerbie = {}
	quadJamal = {}
	for i=0,5 do
		quadHerbie[i] = love.graphics.newQuad(i*16,0,14,21,imgw,imgh)
		quadJamal[i] = love.graphics.newQuad(80+i*16,0,11,27,imgw,imgh)
	end
end
