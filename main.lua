require("defines")
require("mymath")
require("resources")
require("drawing")
require("player")
require("herbie")
require("jamal")
require("robot")
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
	robots = {}
	table.insert(robots,Robot.create({{14,2},{14,8},{22,8},{22,2}}))
	table.insert(robots,Robot.create({{22,8},{22,2},{14,2},{14,8}}))

	loadMapFromImage("maps/level0.png")

	pl1 = Herbie.create(112,40,1)
	pl2 = Jamal.create(96,40,2)
end

function love.update(dt)
	pl1:update(dt)
	pl2:update(dt)

	for i=1,#robots do
		robots[i]:update(dt)
	end
end

function love.keypressed(k,uni)
	if k == 'escape' then
		love.event.push('q')
	elseif k == '2' then
		SCALE = 2
	elseif k == '4' then
		SCALE = 4
	else
		pl1:keypressed(k)
		pl2:keypressed(k)
	end
end
