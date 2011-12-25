Entity = {}
Entity.__index = Entity
Entity.actiontype = 0

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
	
end

Door = {}
Door.__index = Door
Door.actiontype = 1

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

Table = {}
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

Safe = {}
Safe.__index = Safe
Safe.actiontype = 2
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

Painting = {}
Painting.__index = Painting
Painting.actiontype = 3
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
end
