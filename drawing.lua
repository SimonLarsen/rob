local lg = love.graphics

function love.draw()
	lg.scale(SCALE)
	local cx = (pl1.x+pl2.x)/2
	local cy = (pl1.y+pl2.y)/2
	lg.translate(-cx+(WIDTH/2)/SCALE, -cy+(HEIGHT/2)/SCALE)

	local pl1x,pl1y = math.floor(pl1.x/CELLW), math.floor(pl1.y/CELLH)
	local pl2x,pl2y = math.floor(pl2.x/CELLW), math.floor(pl2.y/CELLH)

	lg.setColor(255,255,255)
	for iy = 0,MAPH-1 do
		for ix = 0,MAPW-1 do
			if map[ix][iy] >= 10 then
				drawWall(ix,iy)
			else
				lg.drawq(imgTiles,quadTiles[map[ix][iy]],ix*CELLW,iy*CELLH)
			end
		end

		for i=1,#entities[iy] do
			entities[iy][i]:draw()
		end

		if iy == pl1y then
			if iy == pl2y then
				if pl1.y < pl2.y then
					pl1:draw()
					pl2:draw()
				else
					pl2:draw()
					pl1:draw()
				end
			else
				pl1:draw()
			end
		elseif iy == pl2y then
			pl2:draw()
		end

	end
end

function drawWall(x,y)
	local topx, topy = x*CELLW, (y-3)*CELLH

	if x > 0 and map[x-1][y] >= 10 then
		lg.drawq(imgTiles, quadWall[1], topx, topy)
	else
		lg.drawq(imgTiles, quadWall[0], topx, topy)
	end
	if x < MAPW-1 and map[x+1][y] >= 10 then
		lg.drawq(imgTiles, quadWall[1], topx+CELLW/2, topy)
	else
		lg.drawq(imgTiles, quadWall[2], topx+CELLW/2, topy)
	end

	-- fix top
	lg.setColor(0,0,0)
	if y > 0 and map[x][y-1] >= 10 then
		-- lg.line(topx+1,topy+0.5,(x+1)*CELLW-1,(y-3)*CELLH+0.5) end
		lg.rectangle("fill",topx+1,topy,CELLW-2,1) end
	if y < MAPH-1 and map[x][y+1] >= 10 then
		lg.rectangle("fill",topx+1,topy+CELLH-1,CELLW-2,1) end

	lg.setColor(255,255,255)
end
