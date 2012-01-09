Entity = { actiontype = 0, solid = false, interactive = false }
Entity.__index = Entity

function Entity.create(x,y)
	local self = {}
	setmetatable(self,Entity)

	self.x = x
	self.y = y

	return self
end

function Entity:getCollisionBox()
	return {x = 0, y = 0, w = 0, h = 0}
end

function Entity:getActionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH}
end

function Entity:action()
	print("This message shouldn't appear.")
end

Door = { actiontype = 1, solid = true, interactive = true }
Door.__index = Door
setmetatable(Door,Entity)

function Door.create(x,y,dir,lock)
	local self = Entity.create(x,y)
	setmetatable(self,Door)

	self.open = false
	self.dir = dir -- 0 = horizontal, 1 = left, -1 = right
	if lock then
		self.lock = lock
	else
		self.lock = 0
	end

	return self
end

function Door:draw()
	if self.dir == 0 then
		if self.open then
			love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW+12,self.y*CELLH-23)
		else
			love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
		end
	elseif self.dir == 1 then
		if self.open then
			love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
		else
			love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW-1,self.y*CELLH-21)
		end
	elseif self.dir == -1 then
		if self.open then
			love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
		else
			love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW+17,self.y*CELLH-21,0,-1,1)
		end
	end
end

function Door:getCollisionBox()
	if self.open then
		return {x = 0, y = 0, w = 0, h = 0}
	else
		if self.dir == 0 then
			return {x = self.x*CELLW, y = self.y*CELLH+3, w = 16, h = 3}
		elseif self.dir == 1 then
			return {x = self.x*CELLW, y = self.y*CELLH, w = 3, h = CELLH}
		else
			return {x = self.x*CELLW+13, y = self.y*CELLH, w = 3, h = CELLH}
		end
	end
end

function Door:getActionBox()
	return {x = self.x*CELLW-3, y = self.y*CELLH-3, w = CELLW+6, h = CELLH+6}
end

function Door:action()
	if self.open == true then
		self.open = false
		map[self.x][self.y] = TILE_DOOR
		self:movePlayer(pl1)
		self:movePlayer(pl2)
	elseif self.open == false then
		if self.lock == 0 or keys[self.lock] then
			self.open = true
			map[self.x][self.y] = TILE_DARKFLOOR
		else
			addMessage("This door is locked")
		end
	end
end

function Door:movePlayer(pl)
	if pl:collideBox(self:getCollisionBox()) then
		if self.dir == 0 then
			local ydist = self.y*CELLH - pl.y + 5
			if ydist > 0 then pl.y = pl.y - 6 + ydist
			else pl.y = pl.y + 6 + ydist end
		elseif self.dir == 1 then
			local xdist = self.x*CELLW - pl.x + 1
			if xdist < 0 then pl.x = pl.x + 10 + xdist
			else pl.x = pl.x - 9 + xdist end
		elseif self.dir == -1 then
			local xdist = self.x*CELLW - pl.x + 15
			if xdist < 0 then pl.x = pl.x + 9 + xdist
			else pl.x = pl.x - 9.5 + xdist end
		end
	end
end

Vent = { actiontype = 4, solid = false, interactive = true }
Vent.__index = Vent
setmetatable(Vent,Entity)

function Vent.create(x,y,id,dest,dir)
	local self = Entity.create(x,y)
	setmetatable(self,Vent)
	self.isVent = true
	self.id = id
	self.dest = dest
	self.dir = dir -- 0 - front, -1 - left wall, 1 - right wall
	return self
end

function Vent:draw()
	if self.dir == 0 then
		love.graphics.drawq(imgTiles,quadVentFront,self.x*CELLW,(self.y-1)*CELLH)
	elseif self.dir == -1 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH,0,1,1)
	elseif self.dir == 1 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH,0,-1,1,16)
	end
end

function Vent:action(pl)
	if pl.isJamal then
		for iy=0,MAPH-1 do
			for i=1,#entities[iy] do
				if entities[iy][i].isVent and entities[iy][i].id == self.dest then
					pl.x = (entities[iy][i].x+0.5)*CELLW
					pl.y = (entities[iy][i].y+0.5)*CELLH
					return
				end
			end
		end
	elseif pl.isHerbie then
		addMessage("Herbie, your head is too big to crawl through vents!")
	end
end
