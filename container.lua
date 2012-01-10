Container = { actiontype = 1 }
Container.__index = Container
setmetatable(Container,Entity)

function Container.create(x,y,storage)
	local self = Entity.create(x,y)
	self.open = false
	self.storage = storage
	return self
end

function Container:action()
	self.open = not self.open
	if self.storage then
		if self.storage:sub(1,3) == "key" then
			addKey(tonumber(self.storage:sub(4)))
		end
		-- TODO: Add support for getting skins
		self.storage = nil
	end
end

Safe = { actiontype = 1, solid = true, interactive = true }
Safe.__index = Safe
setmetatable(Safe,Container)

function Safe.create(x,y,storage)
	local self = Container.create(x,y,storage)
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

Cabinet = { actiontype = 1, solid = true, interactive = true }
Cabinet.__index = Cabinet
setmetatable(Cabinet,Container)

function Cabinet.create(x,y,storage)
	local self = Container.create(x,y,storage)
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

Locker = { actiontype = 1, solid = true, interactive = true }
Locker.__index = Locker
setmetatable(Locker,Container)

function Locker.create(x,y,storage)
	local self = Container.create(x,y,storage)
	setmetatable(self,Locker)
	self.open = false
	return self
end

function Locker:draw()
	love.graphics.drawq(imgTiles,quadLocker,self.x*CELLW,self.y*CELLH-25)
	if self.open then
		love.graphics.drawq(imgTiles,quadLockerDoor,self.x*CELLW+9,self.y*CELLH-18)
	end
end

function Locker:getCollisionBox()
	return {x = self.x*CELLW,y = self.y*CELLH, w = CELLW+CELLW, h = CELLH-1}
end

function Locker:getActionBox()
	return {x = self.x*CELLW+17, y = self.y*CELLH+2, w = 1, h = CELLH}
end

Fridge = { actiontype = 1, solid = true, interactive = true }
Fridge.__index = Fridge
setmetatable(Fridge,Container)

function Fridge.create(x,y,storage)
	local self = Container.create(x,y,storage)
	setmetatable(self,Fridge)
	self.open = false
	map[x][y] = TILE_DOOR
	return self
end

function Fridge:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH-2}
end

function Fridge:getActionBox()
	return {x = self.x*CELLW+4, y = (self.y+1)*CELLH, w = CELLW-8, h = CELLH-2}
end

function Fridge:draw()
	if self.open then
		love.graphics.drawq(imgTiles,quadFridgeOpen,self.x*CELLW,(self.y-3)*CELLH)
	else
		love.graphics.drawq(imgTiles,quadFridgeClosed,self.x*CELLW,(self.y-3)*CELLH)
	end
end