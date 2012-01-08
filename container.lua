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

Locker = { actiontype = 1, solid = true, interactive = true }
Locker.__index = Locker
setmetatable(Locker,Entity)

function Locker.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Locker)
	return self
end

function Locker:draw()
	love.graphics.drawq(imgTiles,quadLocker,self.x*CELLW,self.y*CELLH-25)
end

function Locker:getCollisionBox()
	return {x = self.x*CELLW,y = self.y*CELLH, w = CELLW+CELLW, h = CELLH-1}
end

function Locker:getActionBox()
	return {x = self.x*CELLW+5, y = self.y*CELLH, w = CELLW+CELLW-10, h = CELLH}
end

Fridge = { actiontype = 1, solid = true, interactive = true }
Fridge.__index = Fridge
setmetatable(Fridge,Entity)

function Fridge.create(x,y)
	local self = Entity.create(x,y)
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

function Fridge:action(pl)
	self.open = not self.open
end
