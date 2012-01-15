local lg = love.graphics

function love.draw()
	if gamestate == STATE_INGAME then
		drawIngame()
	elseif gamestate == STATE_SKINS then
		drawIngame()
		drawSkinSelection()
	end
end

function drawSkinSelection()
	
end

function drawIngame()
	lg.push()

	local cx = (pl1.x+pl2.x)/2
	local cy = (pl1.y+pl2.y)/2

	-- Clear light framebuffer
	lg.setRenderTarget(fb)
	lg.setColor(255,255,255,235)
	lg.rectangle("fill",0,0,fbw,fbh)
	lg.setColor(255,255,255)
	-- scale and draw light cones
	lg.scale(SCALE)
	lg.translate(-cx+(WIDTH/2)/SCALE, -cy+(HEIGHT/2)/SCALE)
	lg.draw(imgLight,pl1.x,pl1.y,0,1,1,128,128)
	lg.draw(imgLight,pl2.x,pl2.y,0,1,1,128,128)

	-- Reset to screen and draw stuff
	lg.setRenderTarget()
	local pl1y, pl2y = math.floor(pl1.y/CELLH), math.floor(pl2.y/CELLH)

	-- draw all floor stuff first:
	for iy = 0,MAPH-1 do
		for ix = 0,MAPW-1 do
			if map[ix][iy] < 10 then
				lg.drawq(imgTiles,quadTiles[map[ix][iy]],ix*CELLW,iy*CELLH)
			end
		end
	end

	-- draw walls, decorations and entities
	for iy = 0,MAPH-1 do
		for ix = 0,MAPW-1 do
			if map[ix][iy] == TILE_WALL then
				drawWall(ix,iy)
			elseif map[ix][iy] == TILE_CRATE then
				lg.drawq(imgTiles,quadCrate,ix*CELLW,(iy-2)*CELLH)
			elseif map[ix][iy] == TILE_DOUBLECRATE then
				lg.drawq(imgTiles,quadCrate,ix*CELLW,iy*CELLH-16)
				lg.drawq(imgTiles,quadCrate,ix*CELLW,iy*CELLH-31)
			elseif map[ix][iy] == TILE_TABLE then
				drawTable(ix,iy)
			elseif map[ix][iy] == TILE_KITCHEN then
				drawKitchenTable(ix,iy)
			end
		end

		-- draw entities
		for i=1,#entities[iy] do
			entities[iy][i]:draw()
		end

		-- draw robots
		for i=1,#robots do
			if math.floor(robots[i].y/CELLH) == iy then
				robots[i]:draw()
			end
		end
		-- draw cameras
		for i=1,#cameras do
			if cameras[i].y == iy then
				cameras[i]:draw()
			end
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
	end

	lg.pop()
	-- draw alarm blink if any
	if alarmtime > 0 then
		--lg.setColor(255,0,0,64*(math.sin(4*time)/2+0.5))
		lg.setColor(255,0,0,64*(math.sin(4*alarmtime)/2+0.5))
		lg.rectangle("fill",0,0,WIDTH,HEIGHT)
		lg.setColor(255,255,255,255)
	end

	-- apply light to screen
	lg.setBlendMode("subtractive")
	lg.draw(fb,0,0)
	lg.setBlendMode("alpha")
	
	-- draw messages
	for i=0,NUM_MESSAGES-1 do
		if messages[i] ~= nil then
			lg.setColor(255,255,255,255-i*80)
			lg.print(messages[i],15,HEIGHT-30-i*24+messagefade*96)
		end
	end
end

function drawWall(x,y)
	local topx, topy = x*CELLW, (y-3)*CELLH

	if x > 0 and map[x-1][y] == TILE_WALL then
		lg.drawq(imgTiles, quadWall[1], topx, topy)
	else
		lg.drawq(imgTiles, quadWall[0], topx, topy)
	end
	if x < MAPW-1 and map[x+1][y] == TILE_WALL then
		lg.drawq(imgTiles, quadWall[1], topx+CELLW/2, topy)
	else
		lg.drawq(imgTiles, quadWall[2], topx+CELLW/2, topy)
	end

	-- fix top
	lg.setColor(0,0,0)
	if y > 0 and map[x][y-1] == TILE_WALL then
		-- lg.line(topx+1,topy+0.5,(x+1)*CELLW-1,(y-3)*CELLH+0.5) end
		lg.rectangle("fill",topx+1,topy,CELLW-2,1) end
	if y < MAPH-1 and map[x][y+1] == TILE_WALL then
		lg.rectangle("fill",topx+1,topy+CELLH-1,CELLW-2,1) end

	lg.setColor(255,255,255)
end

function drawTable(x,y)
	if x > 0 and map[x-1][y] == TILE_TABLE then
		if x < MAPW-1 and map[x+1][y] == TILE_TABLE then
			lg.drawq(imgTiles,quadTable[1],x*CELLW,y*CELLH-9)
		else
			--lg.drawq(imgTiles,quadTable[2],x*CELLW,y*CELLH-9)
			lg.drawq(imgTiles,quadTable[0],x*CELLW,y*CELLH-9,0,-1,1,16)
		end
	else
		lg.drawq(imgTiles,quadTable[0],x*CELLW,y*CELLH-9)
	end
end

function drawKitchenTable(x,y)
	if x > 0 and map[x-1][y] == TILE_KITCHEN then
		lg.drawq(imgTiles,quadKitchenTableNoLine,x*CELLW,(y-2)*CELLH)
	else
		lg.drawq(imgTiles,quadKitchenTableLined,x*CELLW,(y-2)*CELLH)
	end

	if x < MAPW-1 and map[x+1][y] == TILE_KITCHEN then
		lg.drawq(imgTiles,quadKitchenTableNoLine,x*CELLW+8,(y-2)*CELLH)
	else
		lg.drawq(imgTiles,quadKitchenTableLined,x*CELLW+8,(y-2)*CELLH,0,-1,1,8)
	end
end
