function alarm()
	if alarmtime <= 0 then
		print("alarm triggered")
		alarmtime = 4.2
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
	else
		pl1:keypressed(k)
		pl2:keypressed(k)
	end
end
