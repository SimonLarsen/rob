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
	fow = true

	messages = {}
	messagecolor = {}
	messagefade = 0
	keys = {}
	hasSkin = {true, true, true}
	skinsel = { {confirmed = false, last = 1, scroll = 0 }, {confirmed = false, last = 1, scroll = 0 }}
end

function love.update(dt)
	-- STATE_INGAME
	if gamestate == STATE_INGAME then
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
		for iy=0,MAPH-1 do
			for i=1,#entities[iy] do
				if entities[iy][i].realtime then
					entities[iy][i]:update(dt)
				end
			end
		end
	-- STATE_SKINS - SKIN SELECTION SCREEN
	elseif gamestate == STATE_SKINS then
		if skinsel[1].confirmed == true and skinsel[2].confirmed == true then
			gamestate = STATE_INGAME
		end
		if skinsel[1].scroll > 0 then skinsel[1].scroll = skinsel[1].scroll - dt end
		if skinsel[2].scroll > 0 then skinsel[2].scroll = skinsel[2].scroll - dt end
	end
end
