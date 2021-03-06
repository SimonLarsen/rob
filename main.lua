require("defines")
require("mymath")
require("event")
require("resources")
require("drawing")
require("sound") require("TEsound")
require("player")
require("herbie")
require("jamal")
require("camera")
require("robot")
require("entity")
require("decoration")
require("container")
require("map")
require("menu")

function love.load(arg)
	math.randomseed(os.time())
	applyMode()

	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setLineWidth(SCALE)

	loadResources()
	updateVolume()
	nextSong()

	current_map = "home"

	pl1 = Herbie.create(1)
	pl2 =  Jamal.create(2)

	if arg[2] then
		loadMap(arg[2])
	else
		gamestate = STATE_MAINMENU
		current_menu = main_menu
	end

	hasSkin = {true, true, false}
	skinsel = { {confirmed = false, last = 1, scroll = 0 }, {confirmed = false, last = 1, scroll = 0 }}
end

function love.update(dt)
	updateSound()

	-- TURBO MODE CHEAT
	if love.keyboard.isDown("-") then
		dt = 3*dt
	end

	-- STATE_INGAME
	if gamestate == STATE_INGAME then
		updateIngame(dt)
	-- STATE_SKINS - SKIN SELECTION SCREEN
	elseif gamestate == STATE_SKINS then
		if skinsel[1].confirmed == true and skinsel[2].confirmed == true then
			gamestate = STATE_INGAME
		end
		if skinsel[1].scroll > 0 then skinsel[1].scroll = skinsel[1].scroll - dt end
		if skinsel[2].scroll > 0 then skinsel[2].scroll = skinsel[2].scroll - dt end
	-- STATE_INGAME_LOST - RETRY SCREEN WHEN BEING CAUGHT
	elseif gamestate == STATE_INGAME_LOST then
		fade = fade + dt
		updateIngame(dt)
	end
end

function updateIngame(dt)
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
	for iy=0,MAPH-1 do
		for i=1,#entities[iy] do
			if entities[iy][i].realtime then
				entities[iy][i]:update(dt)
			end
		end
	end
end
