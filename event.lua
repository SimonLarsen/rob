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
	elseif k == 'm' then
		addMessage(swearwords[math.random(1,#swearwords)].."!")
	elseif k == 'f1' then
		addKey(1)
	elseif k == "tab" then
		local tmp1 = keybinds[1]
		keybinds[1] = keybinds[2]
		keybinds[2] = tmp1
	else
		pl1:keypressed(k)
		pl2:keypressed(k)
	end
end

function addMessage(text)
	for i = NUM_MESSAGES-1,1,-1 do
		messages[i] = messages[i-1]
	end
	messages[0] = text
	messagefade = 0.25
end

function addKey(num)
	addMessage("You found a key!")
	keys[num] = true
end
