function alarm()
	if alarmtime <= 0 then
		addMessage(swearwords[math.random(1,#swearwords)].."! You set off the alarm!")
		alarmtime = 4.2
		return true
	else
		return false
	end
end

function love.keypressed(k,uni)
	if k == 'escape' then
		love.event.push('q')
	elseif k == '1' then
		SCALE = 1
	elseif k == '2' then
		SCALE = 2
	elseif k == '4' then
		SCALE = 4
	elseif k == 'f5' then
		gamestate = STATE_INGAME
	elseif k == 'f6' then
		gamestate = STATE_SKINS
	end

	if gamestate == STATE_INGAME then
		if k == 'm' then
			addMessage(swearwords[math.random(1,#swearwords)].."!")
		elseif k == 'f1' then
			fow = not fow
		elseif k == "tab" then
			local tmp1 = keybinds[1]
			keybinds[1] = keybinds[2]
			keybinds[2] = tmp1
		else
			pl1:keypressed(k)
			pl2:keypressed(k)
		end
	elseif gamestate == STATE_SKINS then
		if k == keybinds[1][3] then
			pl1.skin = findSkin(pl1.skin,-1)
		elseif k == keybinds[1][4] then
			pl1.skin = findSkin(pl1.skin,1)
		elseif k == keybinds[1][5] then
			has1Selected = not has1Selected

		elseif k == keybinds[2][3] then
			pl2.skin = findSkin(pl2.skin,-1)
		elseif k == keybinds[2][4] then
			pl2.skin = findSkin(pl2.skin,1)
		elseif k == keybinds[2][5] then
			has2Selected = not has2Selected
		end
	end
end

function findSkin(cur,dir)
	for i = 0,#skins do
		cur = cur+dir
		if cur < 1 then cur = #skins end
		if cur > #skins then cur = 1 end
		if hasSkin[cur] then return cur end
	end
	return 1
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

function addKey(num)
	addMessage("You found a key!")
	keys[num] = true
end

function openSkinSelection()
	gamestate = STATE_SKINS
	has1Selected = false
	has2Selected = false
end
