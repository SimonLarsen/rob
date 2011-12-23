require("defines")
require("resources")
require("drawing")
require("player")
require("herbie")
require("jamal")

function love.load()
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineWidth(SCALE)
	genMap()
	loadImages()

	pl1 = Herbie.create(64,80,1)
	pl2 = Jamal.create(64,24,2)
end

function love.update(dt)
	pl1:update(dt)
	pl2:update(dt)
end

function genMap()
	map = {}
	for i = -1,MAPW do
		map[i] = {}
	end

	for ix = 0, MAPW-1 do
		for iy = 0, MAPH-1 do
			if iy == 0 or ix == 0 or iy == MAPH-1 or ix == MAPW-1 then
				map[ix][iy] = 5
			elseif iy < 6 then
				map[ix][iy] = 2
			elseif iy == 6 then
				map[ix][iy] = 5
			else
				map[ix][iy] = 3
			end
		end
	end
end
