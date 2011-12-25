require("defines")
require("resources")
require("drawing")
require("player")
require("herbie")
require("jamal")
require("entity")
require("decor")

function love.load()
	love.graphics.setMode(WIDTH,HEIGHT)
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineWidth(SCALE)
	loadImages()

	entities = {}
	for i=0,MAPH-1 do
		entities[i] = {}
	end
	--genMap()
	loadMapFromImage("maps/level0.png")

	pl1 = Herbie.create(32,24,1)
	pl2 = Jamal.create(48,24,2)
end

function love.update(dt)
	pl1:update(dt)
	pl2:update(dt)
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
	table.insert(entities[12],Table.create(3,12))
	table.insert(entities[12],Table.create(8,12))
	table.insert(entities[15],Table.create(3,15))
	table.insert(entities[15],Table.create(8,15))
	table.insert(entities[18],Table.create(3,18))
	table.insert(entities[18],Table.create(8,18))

	table.insert(entities[22],Safe.create(17,22))

	table.insert(entities[11],Painting.create(2,11,0))
	table.insert(entities[11],Painting.create(4,11,1))
end

function love.keypressed(k,uni)
	if k == 'escape' then
		love.event.push('q')
	else
		pl1:keypressed(k)
		pl2:keypressed(k)
	end
end
