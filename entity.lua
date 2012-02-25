Entity = { actiontype = 0, solid = false, interactive = false }
Entity.__index = Entity

function Entity.create(x,y)
	local self = {}
	setmetatable(self,Entity)

	self.x = x
	self.y = y
	self.cbox = {x = 0, y = 0, w = 0, h = 0}
	self.abox = {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH}

	return self
end

function Entity:getCollisionBox()
	return self.cbox
end

function Entity:getActionBox()
	return self.abox
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
	if self.dir == 1 then
		self.cboxcl = {x = self.x*CELLW, y = self.y*CELLH+3, w = 16, h = 3}
	elseif self.dir == 0 then
		self.cboxcl = {x = self.x*CELLW, y = self.y*CELLH, w = 3, h = CELLH}
	else
		self.cboxcl = {x = self.x*CELLW+13, y = self.y*CELLH, w = 3, h = CELLH}
	end
	self.abox = {x = self.x*CELLW-3, y = self.y*CELLH-3, w = CELLW+6, h = CELLH+6}

	return self
end

function Door:draw()
	if self.dir == 1 then
		if self.open then love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW+12,self.y*CELLH-23)
		else love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH) end
	else
		if self.dir == 0 then
			if self.open then love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
			else love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW-1,self.y*CELLH-21) end
		elseif self.dir == 2 then
			if self.open then love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
			else love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW+17,self.y*CELLH-21,0,-1,1) end
		end
		love.graphics.drawq(imgTiles,quadDoorGradient,self.x*CELLW-3,self.y*CELLH,0,-1,1,3)
		love.graphics.drawq(imgTiles,quadDoorGradient,(self.x+1)*CELLW,self.y*CELLH)
	end
end

function Door:getCollisionBox()
	if self.open then
		return self.cbox
	else
		return self.cboxcl
	end
end

function Door:action(pl,force)
	if self.open == true and (self.lock == 0 or force == true) then
		self.open = false
		map[self.x][self.y] = TILE_DOOR
		self:movePlayer(pl1)
		self:movePlayer(pl2)
	elseif self.open == false then
		if self.lock == 0 or force == true then
			self.open = true
			map[self.x][self.y] = TILE_DARKFLOOR
		elseif pl.keys[self.lock] then
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

GlassDoor = {}
GlassDoor.__index = GlassDoor
setmetatable(GlassDoor,Door)

function GlassDoor.create(...)
	local self = Door.create(...)
	setmetatable(self,GlassDoor)
	return self
end

function GlassDoor:draw()
	if self.dir == 1 then
		if self.open then love.graphics.drawq(imgTiles,quadGlassDoorOpen,self.x*CELLW+12,self.y*CELLH-23)
		else love.graphics.drawq(imgTiles,quadGlassDoorClosed,self.x*CELLW,(self.y-3)*CELLH) end
	else
		if self.dir == 0 then
			if self.open then love.graphics.drawq(imgTiles,quadGlassDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
			else love.graphics.drawq(imgTiles,quadGlassDoorOpen,self.x*CELLW-1,self.y*CELLH-21) end
		elseif self.dir == 2 then
			if self.open then love.graphics.drawq(imgTiles,quadGlassDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
			else love.graphics.drawq(imgTiles,quadGlassDoorOpen,self.x*CELLW+17,self.y*CELLH-21,0,-1,1) end
		end
		love.graphics.drawq(imgTiles,quadDoorGradient,self.x*CELLW-3,self.y*CELLH,0,-1,1,3)
		love.graphics.drawq(imgTiles,quadDoorGradient,(self.x+1)*CELLW,self.y*CELLH)
	end
end

Vent = { actiontype = 4, solid = false, interactive = true, herbieEnabled = false }
Vent.__index = Vent
setmetatable(Vent,Entity)

function Vent.create(x,y,dir,id,dest)
	local self = Entity.create(x,y)
	setmetatable(self,Vent)
	self.isVent = true
	self.id = id
	self.dest = dest
	self.dir = mymath.strToDir(dir)
	self.abox = {x = self.x*CELLW+8, y = self.y*CELLH+4, w = 1, h = 1}

	return self
end

function Vent:draw()
	if self.dir == 1 then
		love.graphics.drawq(imgTiles,quadVentFront,self.x*CELLW,(self.y-1)*CELLH)
	elseif self.dir == 2 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH+1,0,1,1)
	elseif self.dir == 0 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH+1,0,-1,1,16)
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

Closet = { actiontype = 1, solid = true, interactive = true }
Closet.__index = Closet
setmetatable(Closet,Entity)

function Closet.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Closet)
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH-1}
	self.abox = {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH+2}
	return self
end

function Closet:draw()
	love.graphics.drawq(imgTiles,quadCloset,self.x*CELLW,self.y*CELLH-24)
end

function Closet:action()
	openSkinSelection()
end

RecordPlayer = { actiontype = 5, solid = true, interactive = true }
RecordPlayer.__index = RecordPlayer
setmetatable(RecordPlayer,Entity)

function RecordPlayer.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,RecordPlayer)
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH}
	self.abox = {x = self.x*CELLW-2, y = self.y*CELLH-2, w = CELLW+4, h = CELLH+4}
	return self
end

function RecordPlayer:draw()
	love.graphics.drawq(imgTiles,quadRecordPlayer,self.x*CELLW,self.y*CELLH-17)
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
	self.cbox = {x = self.x*CELLW+3, y = self.y*CELLH+2, w = 10, h = 4}
	return self
end

function Telephone:draw()
	love.graphics.drawq(imgTiles,quadTelephone,self.x*CELLW+3,self.y*CELLH-6)
end

function Telephone:action()

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
				self.objs[i]:action(nil,true)
			elseif type(self.objs[i]) == "function" then
				self.objs[i](self.state)
			end
		end
	end
end

Laser = { solid = false, realtime = true, interactive = false }
Laser.__index = Laser
setmetatable(Laser,Entity)

function Laser.create(x0,y0,x1,y1)
	assert(x0 == x1 or y0 == y1)
	local self = Entity.create(math.min(x0,x1),math.min(y0,y1))
	setmetatable(self,Laser)

	self.length = math.abs(x0-x1)+math.abs(y0-y1)
	self.on = true
	if x0 ~= x1 then
		self.dir = 0 -- left to right
		self.cbox = {x = self.x*CELLW, y = self.y*CELLH+3, w = (self.length+1)*CELLW, h = 1}
	else
		self.dir = 3 -- vertical, far to near
		self.cbox = {x = self.x*CELLW+4, y = self.y*CELLH, w = 7, h = (self.length+1)*CELLH}
	end

	return self
end

function Laser:update(dt)
	if self.on then
		if pl1:collideBox(self.cbox) or pl2:collideBox(self.cbox) then
			alarm()
		end
	end
end

function Laser:draw()
	if self.dir == 0 then
		local iy = self.y*CELLH-16
		if self.on then
			for ix = self.x, self.x+self.length,1 do
				love.graphics.drawq(imgTiles,quadLaserSide,ix*CELLW,iy)
			end
		end
		love.graphics.drawq(imgTiles,quadLaserStartSide,self.x*CELLW,iy-1)
		love.graphics.drawq(imgTiles,quadLaserStartSide,(self.x+self.length)*CELLW,iy-1,0,-1,1,16)
	else -- 3
		love.graphics.drawq(imgTiles,quadLaserStartVert,self.x*CELLW+3,self.y*CELLH-22)
		if self.on then
			local ix = self.x*CELLW+4
			for iy = self.y, self.y+self.length, 1 do
				love.graphics.drawq(imgTiles,quadLaserVert,ix,iy*CELLH-20)
			end
		end
	end
end

function Laser:action()
	self.on = not self.on
end

TimedLaser = { solid = false, interactive = false, realtime = true }
TimedLaser.__index = TimedLaser
setmetatable(TimedLaser,Laser)

function TimedLaser.create(x0,y0,x1,y1,ontime,offtime)
	local self = Laser.create(x0,y0,x1,y1)
	setmetatable(self,TimedLaser)
	self.ontime = ontime
	self.offtime = offtime
	self.time = 0
	return self
end

function TimedLaser:update(dt)
	self.time = self.time + dt
	if (self.on == true and self.time > self.ontime)
	or (self.on == false and self.time > self.offtime) then
		self.on = not self.on
		self.time = 0
	end
	if self.on then
		if pl1:collideBox(self.cbox) or pl2:collideBox(self.cbox) then
			alarm()
		end
	end
end

Switch = { actiontype = 2, solid = false, interactive = true }
Switch.__index = Switch
setmetatable(Switch,Entity)

function Switch.create(x,y,objs)
	local self = Entity.create(x,y)
	setmetatable(self,Switch)
	self.objs = objs
	self.state = false
	self.abox = {x = self.x*CELLW+4, y = self.y*CELLH+2, w = 8, h = 4}
	if map[x][y-1] >= 10 then self.dir = 3
	elseif map[x-1][y] >= 10 then self.dir = 2
	elseif map[x+1][y] >= 10 then self.dir = 0
	else self.dir = 3 end

	return self
end

function Switch:draw()
	local ysc = self.state and 1 or -1
	if self.dir == 3 then
		love.graphics.drawq(imgTiles,quadSwitchFront,self.x*CELLW+5,self.y*CELLH-16)
		love.graphics.drawq(imgTiles,quadSwitchFrontHandle,self.x*CELLW+7,self.y*CELLH-12,0,1,ysc,0,2)
	elseif self.dir == 2 then
		love.graphics.drawq(imgTiles,quadSwitchSide,self.x*CELLW,self.y*CELLH-8,0,1,1,0,4)
		love.graphics.drawq(imgTiles,quadSwitchSideHandle,self.x*CELLW+1,self.y*CELLH-8,0,1,ysc,0,1)
	elseif self.dir == 0 then
		love.graphics.drawq(imgTiles,quadSwitchSide,self.x*CELLW,self.y*CELLH-8,0,-1,1,16,4)
		love.graphics.drawq(imgTiles,quadSwitchSideHandle,self.x*CELLW-1,self.y*CELLH-8,0,-1,ysc,16,1)
	end
end

function Switch:action(pl)
	self.state = not self.state
	for i=1,#self.objs do
		if type(self.objs[i]) == "table" then
			self.objs[i]:action(pl,true)
		elseif type(self.objs[i]) == "function" then
			self.objs[i](self.state)
		end
	end
end

Sign = { actiontype = 2, solid = false, interactive = true }
Sign.__index = Sign
setmetatable(Sign,Entity)

function Sign.create(x,y,msg)
	local self = Entity.create(x,y)
	setmetatable(self,Sign)
	self.msg = msg
	return self
end

function Sign:draw()
	love.graphics.drawq(imgTiles,quadSign,self.x*CELLW+2,self.y*CELLH-8)
end

function Sign:action()
	addMessage(self.msg)
end
