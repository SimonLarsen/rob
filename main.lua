require("defines")
require("resources")
require("drawing")
require("player")
require("herbie")
require("jamal")
require("entity")

function love.load()
	love.graphics.setMode(WIDTH,HEIGHT)
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineWidth(SCALE)
	loadImages()

	entities = {}
	for i=0,MAPH-1 do
		entities[i] = {}
	end

	loadMapFromImage("maps/level0.png")

	pl1 = Herbie.create(112,40,1)
	pl2 = Jamal.create(96,40,2)
end

function love.update(dt)
	pl1:update(dt)
	pl2:update(dt)
end

function love.keypressed(k,uni)
	if k == 'escape' then
		love.event.push('q')
	else
		pl1:keypressed(k)
		pl2:keypressed(k)
	end
end
