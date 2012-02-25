function love.keypressed(k,uni)
	if k == 'f1' then
		SCALE = 1
	elseif k == 'f2' then
		SCALE = 2
	elseif k == 'f3' then
		SCALE = 3
	elseif k == 'f4' then
		SCALE = 4
	elseif k == 'f5' then
		gamestate = STATE_INGAME
	elseif k == 'f6' then
		openSkinSelection()
	elseif k == "tab" then
		local tmp1 = keybinds[1]
		keybinds[1] = keybinds[2]
		keybinds[2] = tmp1
	end

	-- STATE_INGAME
	if gamestate == STATE_INGAME then
		if k == 'm' then
			addMessage(getSwearword() .. "!")
		elseif k == 'f1' then
			fow = not fow
		elseif k == 'escape' then
			current_menu = ingame_menu
			gamestate = STATE_INGAME_MENU
		elseif k == '+' then
			alarms = alarms+1
		else
			pl1:keypressed(k)
			pl2:keypressed(k)
		end
	-- STATE INGAME MENU
	elseif gamestate == STATE_INGAME_MENU then
		current_menu:keypressed(k,uni)
	-- STATE INGAME LOST
	elseif gamestate == STATE_INGAME_LOST then
		lost_menu:keypressed(k,uni)
	-- STATE SKIN SELECTION MENU
	elseif gamestate == STATE_SKINS then
		if k == keybinds[1][3] then
			selectSkin(pl1,-1)
		elseif k == keybinds[1][4] then
			selectSkin(pl1,1)
		elseif k == keybinds[1][5] then
			skinsel[1].confirmed = not skinsel[1].confirmed
		elseif k == keybinds[2][3] then
			selectSkin(pl2,-1)
		elseif k == keybinds[2][4] then
			selectSkin(pl2,1)
		elseif k == keybinds[2][5] then
			skinsel[2].confirmed = not skinsel[2].confirmed
		end
	elseif gamestate == STATE_MAINMENU then
		current_menu:keypressed(k,uni)
	end
end

function alarm()
	if alarmtime <= 0 and alarms > 0 then
		addMessage(swearwords[math.random(1,#swearwords)].."! You set off the alarm!")
		alarmtime = 4.2
		alarms = alarms - 1
		if alarms == 0 then
			pl1:lose()
			pl2:lose()
			gamestate = STATE_INGAME_LOST
			current_menu = lost_menu
			fade = 0
		end
		return true
	else
		return false
	end
end

function selectSkin(pl,dir)
	if skinsel[pl.player].scroll > 0 or skinsel[pl.player].confirmed == true then return end
	skinsel[pl.player].last = pl.skin
	skinsel[pl.player].scroll = 1
	local cur = pl.skin

	for i = 0,#skins do
		cur = cur+dir
		if cur < 1 then cur = #skins end
		if cur > #skins then cur = 1 end
		if hasSkin[cur] then 
			pl.skin = cur
			return
		end
	end
end

function unlockSkin(skin)
	if skin == "suit" then hasSkin[2] = true
	elseif skin == "blackmetal" then hasSkin[3] = true
	end
	addMessage("You unlocked the "..skin.." skin!")
end

function addMessage(text,color)
	for i = NUM_MESSAGES-1,1,-1 do
		messages[i] = messages[i-1]
		messagecolor[i] = messagecolor[i-1]
	end
	messages[0] = text
	messagefade = 0.25

	if type(color) == "number" then messagecolor[0] = color
	elseif color == "herbie" then messagecolor[0] = 1
	elseif color == "jamal" then messagecolor[0] = 2
	else messagecolor[0] = nil end
end

function openSkinSelection()
	gamestate = STATE_SKINS
	skinsel[1].confirmed, skinsel[2].confirmed = false, false
	skinsel[1].scroll, skinsel[2].scroll = 0, 0
end

function restartLevel()
	pl1:reset()
	pl2:reset()

	pl1.x, pl1.y = p1start[1]*CELLW+8, p1start[2]*CELLH+4
	pl2.x, pl2.y = p2start[1]*CELLW+8, p2start[2]*CELLH+4

	gamestate = STATE_INGAME

	alarmtime = 0
	fow = true

	messages, messagecolor = {}, {}
	messagefade = 0
	fade = 0
end
