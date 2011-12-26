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

function Door.create(x,y,dir)
	local self = Entity.create(x,y)
	setmetatable(self,Door)

	self.open = false
	self.dir = dir -- 0 = horizontal, 1 = vertical

	return self
end

function Door:draw()
	if self.dir == 0 then
		if self.open then
			love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW,(self.y-3)*CELLH)
		else
			love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
		end
	elseif self.dir == 1 then
		if self.open then
			love.graphics.drawq(imgTiles,quadDoorClosed,self.x*CELLW,(self.y-3)*CELLH)
		else
			love.graphics.drawq(imgTiles,quadDoorOpen,self.x*CELLW-13,(self.y-3)*CELLH-1)
		end
	end
end

function Door:getCollisionBox()
	if self.open then
		return {x = 0, y = 0, w = 0, h = 0}
	else
		if self.dir == 0 then
			return {x = self.x*CELLW, y = self.y*CELLH+3, w = 16, h = 3}
		else
			return {x = self.x*CELLW, y = self.y*CELLH, w = 3, h = CELLH}
		end
	end
end

function Door:getActionBox()
	return {x = self.x*CELLW-2, y = self.y*CELLH-2, w = CELLW+4, h = CELLH+4}
end

function Door:action()
	self.open = not self.open

	if self.open == false then
		if pl1:collideBox(self:getCollisionBox())
		or pl2:collideBox(self:getCollisionBox()) then
			self.open = true
		end
	end
end

Table = { solid = true, interactive = false }
Table.__index = Table
setmetatable(Table,Entity)

function Table.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Table)
	return self
end

function Table:draw()
	love.graphics.drawq(imgTiles,quadTable,self.x*CELLW,(self.y-1)*CELLH)
end

function Table:getCollisionBox()
	return {x = self.x*CELLW+1, y = self.y*CELLH+4, w = CELLW+CELLW-2, h = CELLH-5}
end

Safe = { actiontype = 1, solid = true, interactive = true }
Safe.__index = Safe
setmetatable(Safe,Entity)

function Safe.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Safe)

	self.open = false

	return self
end

function Safe:draw()
	if self.open then
		love.graphics.drawq(imgTiles,quadSafeOpen,self.x*CELLW,(self.y-2)*CELLH)
	else
		love.graphics.drawq(imgTiles,quadSafeClosed,self.x*CELLW,(self.y-2)*CELLH)
	end
end

function Safe:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH-3}
end

function Safe:getActionBox()
	return {x = self.x*CELLW, y = (self.y+1)*CELLH, w = CELLW, h = CELLH/2}
end

function Safe:action()
	self.open = not self.open
end

Cabinet = { actiontype = 1, solid = true, interactive = true }
Cabinet.__index = Cabinet
setmetatable(Cabinet,Entity)

function Cabinet.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Cabinet)
	return self
end

function Cabinet:draw()
	love.graphics.drawq(imgTiles,quadCabinet,self.x*CELLW,self.y*CELLH-18)
end

function Cabinet:getCollisionBox()
	return {x = self.x*CELLW,y = self.y*CELLH, w = CELLW+CELLW, h = CELLH-2}
end

function Cabinet:getActionBox()
	return {x = self.x*CELLW+5, y = self.y*CELLH, w = CELLW+CELLW-10, h = CELLH}
end

Painting = { actiontype = 3, solid = false, interactive = true }
Painting.__index = Painting
setmetatable(Painting,Entity)

function Painting.create(x,y,id)
	local self = Entity.create(x,y)
	setmetatable(self,Painting)

	self.id = id

	return self
end

function Painting:draw()
	love.graphics.drawq(imgTiles,quadPainting[self.id],self.x*CELLW,(self.y-3)*CELLH)
end

function Painting:action()
	self.id = (self.id+1)%4
	-- TODO: Add code for hiding stuff (e.g. safes, ...)
	-- behind paintings rather than cycling through them
end

function Painting:getActionBox()
	return {x = self.x*CELLW+4, y = self.y*CELLH, w = CELLW-8, h = CELLH}
end

Crate = { solid = true, interactive = false }
Crate.__index = Crate
setmetatable(Crate,Entity)

function Crate.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Crate)
	return self	
end

function Crate:draw()
	love.graphics.drawq(imgTiles,quadCrate,self.x*CELLW,(self.y-2)*CELLH)
end

function Crate:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH+1, w = CELLW, h = CELLH-2}
end

Vent = { actiontype = 4, solid = false, interactive = true }
Vent.__index = Vent
setmetatable(Vent,Entity)

function Vent.create(x,y,id,dir)
	local self = Entity.create(x,y)
	setmetatable(self,Vent)
	self.id = id
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
