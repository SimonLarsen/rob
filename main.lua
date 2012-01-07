require("defines")
require("mymath")
require("event")
require("resources")
require("drawing")
require("player")
require("herbie")
require("jamal")
require("camera")
require("robot")
require("entity")
	require("decoration")
	require("container")

function love.load()
	love.graphics.setMode(WIDTH,HEIGHT,false)
	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineWidth(SCALE)
	loadImages()

	fbw = math.pow(2,math.ceil(math.log(WIDTH)/math.log(2)))
	fbh = math.pow(2,math.ceil(math.log(HEIGHT)/math.log(2)))
	fb = love.graphics.newFramebuffer(fbw,fbh)

	loadMapFromImage("level1")

	pl1 = Herbie.create(p1start[1],p1start[2],1)
	pl2 = Jamal.create(p2start[1],p2start[2],2)

	time = 0
	alarmtime = 0
end

function love.update(dt)
	time = time + dt
	if alarmtime > 0 then alarmtime = alarmtime - dt end

	pl1:update(dt)
	pl2:update(dt)

	for i=1,#robots do
		robots[i]:update(dt)
	end
	for i=1,#cameras do
		cameras[i]:update(dt)
	end
end
