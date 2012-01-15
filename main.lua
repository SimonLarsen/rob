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
require("map")

function love.load()
	math.randomseed(os.time())
	love.graphics.setMode(WIDTH,HEIGHT,false)

	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineWidth(SCALE)
	loadImages()
	createQuads()

	fbw = math.pow(2,math.ceil(math.log(WIDTH)/math.log(2)))
	fbh = math.pow(2,math.ceil(math.log(HEIGHT)/math.log(2)))
	fb = love.graphics.newFramebuffer(fbw,fbh)

	loadMapFromImage("home")

	pl1 = Herbie.create(p1start[1]*CELLW+8, p1start[2]*CELLH+4, 1)
	pl2 =  Jamal.create(p2start[1]*CELLW+8, p2start[2]*CELLH+4, 2)

	gamestate = STATE_INGAME

	alarmtime = 0
	time = 0
	fow = true

	messages = {}
	messagecolor = {}
	messagefade = 0
	keys = {}
	hasSkin = {true, true, false}
end

function love.update(dt)
	if gamestate == STATE_INGAME then
		time = time + dt
		if alarmtime > 0 then alarmtime = alarmtime - dt end
		if messagefade > 0 then messagefade = messagefade - dt end

		pl1:update(dt)
		pl2:update(dt)

		for i=1,#robots do
			robots[i]:update(dt)
		end
		for i=1,#cameras do
			cameras[i]:update(dt)
		end
	elseif gamestate == STATE_SKINS then
		if has1Selected == true and has2Selected == true then
			gamestate = STATE_INGAME
		end
	end
end
