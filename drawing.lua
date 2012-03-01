local lg = love.graphics

function love.draw()
	if gamestate == STATE_INGAME then
		drawIngame()
	elseif gamestate == STATE_INGAME_MENU then
		drawIngame()
		current_menu:draw()
	elseif gamestate == STATE_INGAME_LOST then
		drawIngame()
		if fade > 1.2 then
			local fadealpha = math.min((fade-1.2)*0.5*255,255)
			lost_menu:draw(fadealpha)
		end
	elseif gamestate == STATE_SKINS then
		drawIngame()
		drawSkinSelection()
	elseif gamestate == STATE_MAINMENU then
		drawMainMenu()
		current_menu:draw()
	end
end

function drawIngame()
	lg.push()

	-- Calculate center of screen
	local cx = (pl1.x+pl2.x)/2
	local cy = (pl1.y+pl2.y)/2

	-- Find the corners of the furthest visible tiles on screen
	local stx = math.max(math.floor((cx - (WIDTH/SCALE)/2)/16)-3, 0)
	local edx = math.min(math.floor((cx + (WIDTH/SCALE)/2)/16)+3, MAPW-1)
	local sty = math.max(math.floor((cy - (HEIGHT/SCALE)/2)/8)-3, 0)
	local edy = math.min(math.floor((cy + (HEIGHT/SCALE)/2)/8)+3, MAPH-1)

	-- Clear light framebuffer
	lg.setRenderTarget(fb)
	lg.setColor(235,235,235,255)
	lg.rectangle("fill",0,0,fbw,fbh)
	lg.setColor(255,255,255,255)
	-- scale and draw light cones
	lg.scale(SCALE)
	lg.translate(-cx+(WIDTH/2)/SCALE, -cy+(HEIGHT/2)/SCALE)
	lg.draw(imgLight,pl1.x,pl1.y,0,1,1,128,128)
	lg.draw(imgLight,pl2.x,pl2.y,0,1,1,128,128)

	-- Reset to screen and draw stuff
	lg.setRenderTarget()
	local pl1y, pl2y = math.floor(pl1.y/CELLH), math.floor(pl2.y/CELLH)

	-- draw all floor stuff first:
	for iy = sty,edy do
		for ix = stx,edx do
			if map[ix][iy] < 10 then
				lg.drawq(imgTiles,quadTiles[map[ix][iy]],ix*CELLW,iy*CELLH)
			end
		end
	end

	-- draw walls, decorations and entities
	for iy = sty,edy do
		for ix = stx,edx do
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
			elseif map[ix][iy] == TILE_WINDOW  then
				lg.drawq(imgTiles,quadWindowWall,ix*CELLW,iy*CELLH-24)
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
	if fow then
		lg.setBlendMode("subtractive")
		lg.draw(fb,0,0)
		lg.setBlendMode("alpha")
	end

	if draw_hud == true then
		lg.push()
		lg.scale(2)
		lg.setFont(serifFont)
		lg.print(math.floor(time/60)..":"..string.format("%02d",math.floor(time%60)) ,10,10)
		lg.printf("! "..alarms.."/"..alarms_allowed,WIDTH/4-10,10,WIDTH/4,"right")
		lg.pop()
	end

	drawMessages()
end

function drawTitle(str,lines)
	lg.push()
	lg.scale(2)
	lg.setFont(serifFont)
	lg.printf(str,0,20,WIDTH/2,"center")
	lg.pop()
	if lines then
		local strw = serifFont:getWidth(str) + 25
		lg.rectangle("fill",WIDTH/2-strw-4,32,2*strw,2)
		lg.rectangle("fill",WIDTH/2-strw-4,78,2*strw,2)
	end
end

function drawSkinSelection()
	lg.setColor(0,0,0,247)
	lg.rectangle("fill",0,0,WIDTH,HEIGHT)
	lg.setColor(255,255,255,255)

	drawTitle("Select your attire, gentlemen", true)
	
	-- player 1
	if skinsel[1].confirmed == true then lg.setColor(255,255,255,108) end

	lg.drawq(imgSprites,quadTriangle,(WIDTH/2)+50,HEIGHT-256,0,2,2,7.5,0)
	lg.drawq(imgSprites,quadTriangle,(WIDTH/2)+345,HEIGHT-256,0,-2,2,7.5,0)
	if skinsel[1].scroll <= 0 then
		lg.drawq(imgSkinPreviews[pl1.skin],quadSkinHerbie,(WIDTH/2)+200,HEIGHT-512,0,2,2,64,0)
	elseif skinsel[1].scroll > 0.5 then
		lg.drawq(imgSkinPreviews[skinsel[1].last],quadSkinHerbie,
			(WIDTH/2)+200,HEIGHT-(skinsel[1].scroll-0.5)*1024,0,2,2,64,0)
	else
		lg.drawq(imgSkinPreviews[pl1.skin],quadSkinHerbie,
			(WIDTH/2)+200,HEIGHT-(0.5-skinsel[1].scroll)*1024,0,2,2,64,0)
	end

	-- player 2
	if skinsel[2].confirmed == false then lg.setColor(255,255,255,255)
	else lg.setColor(255,255,255,108) end

	lg.drawq(imgSprites,quadTriangle,(WIDTH/2)-330,HEIGHT-256,0,2,2,7.5,0)
	lg.drawq(imgSprites,quadTriangle,(WIDTH/2)-60,HEIGHT-256,0,-2,2,7.5,0)
	if skinsel[2].scroll <= 0 then
		lg.drawq(imgSkinPreviews[pl2.skin],quadSkinJamal,(WIDTH/2)-200,HEIGHT-512,0,2,2,64,0)
	elseif skinsel[2].scroll > 0.5 then
		lg.drawq(imgSkinPreviews[skinsel[2].last],quadSkinJamal,
			(WIDTH/2)-200,HEIGHT-(skinsel[2].scroll-0.5)*1024,0,2,2,64,0)
	else
		lg.drawq(imgSkinPreviews[pl2.skin],quadSkinJamal,
			(WIDTH/2)-200,HEIGHT-(0.5-skinsel[2].scroll)*1024,0,2,2,64,0)
	end
end

function drawMainMenu()
	lg.push()
	lg.scale(2)
	lg.drawq(imgMainMenu,quadMainMenu,(WIDTH-864)/4,0)
	lg.pop()
end

function drawMessages()
	lg.setFont(sansFont)
	-- draw messages
	for i=0,NUM_MESSAGES-1 do
		if messages[i] ~= nil then
			lg.setColor(0,0,0,255-i*80)
			lg.print(messages[i],17,HEIGHT-28-i*24+messagefade*96)

			if messagecolor[i] == nil then lg.setColor(255,255,255,255-i*80)
			elseif messagecolor[i] == 1 then lg.setColor(0,160,176,255-i*80) -- herbie
			elseif messagecolor[i] == 2 then lg.setColor(235,80,65,255-i*80) -- jamal
			end
			lg.print(messages[i],15,HEIGHT-30-i*24+messagefade*96)
		end
	end
	lg.setColor(255,255,255,255)
end

function drawWall(x,y)
	local topx, topy = x*CELLW, (y-3)*CELLH

	if x > 0 and map[x-1][y] == TILE_WALL or map[x-1][y] == TILE_WINDOW then
		lg.drawq(imgTiles, quadWall[1], topx, topy)
	else
		lg.drawq(imgTiles, quadWall[0], topx, topy)
	end
	if x < MAPW-1 and map[x+1][y] == TILE_WALL or map[x+1][y] == TILE_WINDOW then
		lg.drawq(imgTiles, quadWall[1], topx+CELLW/2, topy)
	else
		lg.drawq(imgTiles, quadWall[2], topx+CELLW/2, topy)
	end

	-- fix top
	lg.setColor(0,0,0)
	if y > 0 and map[x][y-1] == TILE_WALL then
		lg.rectangle("fill",topx+1,topy,CELLW-2,1) end
	if y < MAPH-1 and map[x][y+1] == TILE_WALL then
		lg.rectangle("fill",topx+1,topy+CELLH-1,CELLW-2,1) end

	lg.setColor(255,255,255)

	-- add wall gradients
	if x < MAPW-1 and y < MAPH-1 and map[x+1][y+1] == TILE_WALL then 
		lg.drawq(imgTiles,quadWallGrad,topx+13,topy+12)
	end
	if x > 0 and y < MAPH-1 and map[x-1][y+1] == TILE_WALL then
		lg.drawq(imgTiles,quadWallGrad,topx-13,topy+12,0,-1,1,16,0)
	end
end

function drawTable(x,y)
	if x > 0 and map[x-1][y] == TILE_TABLE then
		if x < MAPW-1 and map[x+1][y] == TILE_TABLE then
			lg.drawq(imgTiles,quadTable[1],x*CELLW,y*CELLH-9)
		else
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

function applyMode()
	lg.setMode(WIDTH,HEIGHT,FULLSCREEN,true,0)

	fbw = math.pow(2,math.ceil(math.log(WIDTH)/math.log(2)))
	fbh = math.pow(2,math.ceil(math.log(HEIGHT)/math.log(2)))
	fb = love.graphics.newFramebuffer(fbw,fbh)
end
