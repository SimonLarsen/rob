local lg = love.graphics

function love.draw()
	lg.scale(SCALE)
	local cx = (pl1.x+pl2.x)/2
	local cy = (pl1.y+pl2.y)/2
	lg.translate(-cx+(WIDTH/2)/SCALE, -cy+(HEIGHT/2)/SCALE)

	local pl1y, pl2y = math.floor(pl1.y/CELLH), math.floor(pl2.y/CELLH)

	lg.setColor(255,255,255)
	for iy = 0,MAPH-1 do
		for ix = 0,MAPW-1 do
			if map[ix][iy] == 10 then
				drawWall(ix,iy)
			elseif map[ix][iy] == 11 then
				lg.drawq(imgTiles,quadCrate,ix*CELLW,(iy-2)*CELLH)
			elseif map[ix][iy] == 12 then
				drawTable(ix,iy)
			else
				lg.drawq(imgTiles,quadTiles[map[ix][iy]],ix*CELLW,iy*CELLH)
			end
		end

		-- draw entities
		for i=1,#entities[iy] do
			entities[iy][i]:draw()
		end

		-- draw players
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

		-- draw robots
		for i=1,#robots do
			if math.floor(robots[i].y/CELLH) == iy then
				robots[i]:draw()
			end
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

function drawTable(x,y)
	if x > 0 and map[x-1][y] == 12 then
		if x < MAPH-1 and map[x+1][y] == 12 then
			lg.drawq(imgTiles,quadTable[1],x*CELLW,y*CELLH-9)
		else
			lg.drawq(imgTiles,quadTable[2],x*CELLW,y*CELLH-9)
		end
	else
		lg.drawq(imgTiles,quadTable[0],x*CELLW,y*CELLH-9)
	end
end
