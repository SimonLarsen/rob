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

	map[x][y] = TILE_DOOR
	self.open = false
	self.dir = mymath.strToDir(dir)
	-- 0 = horizontal, 1 = left, -1 = right
	if lock then
		self.lock = lock
	else
		self.lock = 0
	end

	return self
end

function Door:draw()
	if self.dir == 1 then
		if self.open then
			love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW+12,self.y*CELLH-23)
		else
			love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
		end
	elseif self.dir == 0 then
		if self.open then
			love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
		else
			love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW-1,self.y*CELLH-21)
		end
	elseif self.dir == 2 then
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
		if self.dir == 1 then
			return {x = self.x*CELLW, y = self.y*CELLH+3, w = 16, h = 3}
		elseif self.dir == 0 then
			return {x = self.x*CELLW, y = self.y*CELLH, w = 3, h = CELLH}
		elseif self.dir == 2 then
			return {x = self.x*CELLW+13, y = self.y*CELLH, w = 3, h = CELLH}
		end
	end
end

function Door:getActionBox()
	return {x = self.x*CELLW-3, y = self.y*CELLH-3, w = CELLW+6, h = CELLH+6}
end

function Door:action(force)
	if self.open == true then
		self.open = false
		map[self.x][self.y] = TILE_DOOR
		self:movePlayer(pl1)
		self:movePlayer(pl2)
	elseif self.open == false then
		if self.lock == 0 or force == true then
			self.open = true
			map[self.x][self.y] = TILE_DARKFLOOR
		elseif keys[self.lock] then
			addMessage("You unlocked the door")
			self.lock = 0
			self.open = true
			map[self.x][self.y] = TILE_DARKFLOOR
		else
			addMessage("This door is locked")
		end
	end
end

function Door:movePlayer(pl)
	if pl:collideBox(self:getCollisionBox()) then
		if self.dir == 1 then
			local ydist = self.y*CELLH - pl.y + 5
			if ydist > 0 then pl.y = pl.y - 6 + ydist
			else pl.y = pl.y + 6 + ydist end
		elseif self.dir == 0 then
			local xdist = self.x*CELLW - pl.x + 1
			if xdist < 0 then pl.x = pl.x + 10 + xdist
			else pl.x = pl.x - 9 + xdist end
		elseif self.dir == 2 then
			local xdist = self.x*CELLW - pl.x + 15
			if xdist < 0 then pl.x = pl.x + 9 + xdist
			else pl.x = pl.x - 9.5 + xdist end
		end
	end
end

Vent = { actiontype = 4, solid = false, interactive = true }
Vent.__index = Vent
setmetatable(Vent,Entity)

function Vent.create(x,y,dir,id,dest)
	local self = Entity.create(x,y)
	setmetatable(self,Vent)
	self.isVent = true
	self.id = id
	self.dest = dest
	self.dir = mymath.strToDir(dir)
	return self
end

function Vent:draw()
	if self.dir == 1 then
		love.graphics.drawq(imgTiles,quadVentFront,self.x*CELLW,(self.y-1)*CELLH)
	elseif self.dir == 2 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH,0,1,1)
	elseif self.dir == 0 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH,0,-1,1,16)
	end
end

function Vent:action(pl)
	if pl.isJamal then
		for iy=0,MAPH-1 do
			for i=1,#entities[iy] do
				if entities[iy][i].isVent and entities[iy][i].id == self.dest then
					pl:crawlVent(entities[iy][i],self.dir)
					return
				end
			end
		end
	elseif pl.isHerbie then
		addMessage("Herbie, your head is too big to crawl through vents!",pl.player)
	end
end

function Vent:getActionBox()
	return {x = self.x*CELLW+8, y = self.y*CELLH+4, w = 1, h = 1}
end

Closet = { actiontype = 1, solid = true, interactive = true }
Closet.__index = Closet
setmetatable(Closet,Entity)

function Closet.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Closet)
	return self
end

function Closet:draw()
	love.graphics.drawq(imgTiles,quadCloset,self.x*CELLW,self.y*CELLH-24)
end

function Closet:action()
	openSkinSelection()
end

function Closet:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH-1}
end

function Closet:getActionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH+2}
end

RecordPlayer = { actiontype = 5, solid = true, interactive = true }
RecordPlayer.__index = RecordPlayer
setmetatable(RecordPlayer,Entity)

function RecordPlayer.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,RecordPlayer)
	return self
end

function RecordPlayer:draw()
	love.graphics.drawq(imgTiles,quadRecordPlayer,self.x*CELLW,self.y*CELLH-17)
end

function RecordPlayer:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH}
end

function RecordPlayer:getActionBox()
	return {x = self.x*CELLW-2, y = self.y*CELLH-2, w = CELLW+4, h = CELLH+4}
end

function RecordPlayer:action()
	addMessage("% TODO Skip song %")
end

Telephone = { actiontype = 2, solid = true, interactive = true }
Telephone.__index = Telephone
setmetatable(Telephone,Entity)

function Telephone.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Telephone)
	return self
end

function Telephone:draw()
	love.graphics.drawq(imgTiles,quadTelephone,self.x*CELLW+3,self.y*CELLH-6)
end

function Telephone:getCollisionBox()
	return {x = self.x*CELLW+3, y = self.y*CELLH+2, w = 10, h = 4}
end

function Telephone:action()
	addMessage("TODO Add telephone menu stuff")
end

PressurePlate = { solid = false, realtime = true, interactive = false }
PressurePlate.__index = PressurePlate
setmetatable(PressurePlate,Entity)

function PressurePlate.create(x,y,objs)
	local self = Entity.create(x,y)
	setmetatable(self,PressurePlate)
	self.objs = objs -- list of objects to update
	self.state = false
	return self
end

function PressurePlate:draw()
	if self.state == false then
		love.graphics.drawq(imgTiles,quadPressurePlateUp,self.x*CELLW+3,self.y*CELLH)
	else
		love.graphics.drawq(imgTiles,quadPressurePlateDown,self.x*CELLW+3,self.y*CELLH)
	end
end

function PressurePlate:update(dt)
	local nstate = pl1:collideBox({x=self.x*CELLW+8,y=self.y*CELLH+4,w=1,h=1}) or
	pl2:collideBox({x=self.x*CELLW+8,y=self.y*CELLH+4,w=1,h=1})

	if nstate ~= self.state then
		self.state = nstate
		for i=1,#self.objs do
			if type(self.objs[i]) == "table" then
				self.objs[i]:action(true)
			elseif type(self.objs[i]) == "function" then
				self.objs[i](self.state)
			end
		end
	end
end
