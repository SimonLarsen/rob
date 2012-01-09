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
	math.randomseed(os.time())
	--[[
	modes = love.graphics.getModes()
	table.sort(modes, function(a,b) return a.width*a.height > b.width*b.height end) -- descending order
	WIDTH, HEIGHT = modes[1].width, modes[1].height
	--]]
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

	messages = {}
	messagefade = 0
	keys = {}
end

function love.update(dt)
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
end
