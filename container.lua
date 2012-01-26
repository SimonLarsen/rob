Container = { actiontype = 1 }
Container.__index = Container
setmetatable(Container,Entity)

function Container.create(x,y,storage)
	local self = Entity.create(x,y)
	self.open = false
	self.storage = storage
	return self
end

function Container:action(pl)
	self.open = not self.open
	if self.storage and type(self.storage) == "function" then
		if self.storage(self.open) ~= true then
			self.storage = nil
		end
	end
end

Safe = { actiontype = 1, solid = true, interactive = true }
Safe.__index = Safe
setmetatable(Safe,Container)

function Safe.create(x,y,storage)
	local self = Container.create(x,y,storage)
	setmetatable(self,Safe)
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH-3}
	self.abox = {x = self.x*CELLW, y = (self.y+1)*CELLH, w = CELLW, h = CELLH/2}

	return self
end

function Safe:draw()
	if self.open then
		love.graphics.drawq(imgTiles,quadSafeOpen,self.x*CELLW,(self.y-2)*CELLH)
	else
		love.graphics.drawq(imgTiles,quadSafeClosed,self.x*CELLW,(self.y-2)*CELLH)
	end
end

Cabinet = { actiontype = 1, solid = true, interactive = true }
Cabinet.__index = Cabinet
setmetatable(Cabinet,Container)

function Cabinet.create(x,y,storage)
	local self = Container.create(x,y,storage)
	setmetatable(self,Cabinet)
	self.cbox = {x = self.x*CELLW,y = self.y*CELLH, w = CELLW+CELLW, h = CELLH-1}
	self.abox = {x = self.x*CELLW+5, y = self.y*CELLH, w = CELLW+CELLW-10, h = CELLH}
	return self
end

function Cabinet:draw()
	if self.open then
		love.graphics.drawq(imgTiles,quadCabinetOpen,self.x*CELLW,self.y*CELLH-18)
	else
		love.graphics.drawq(imgTiles,quadCabinet,self.x*CELLW,self.y*CELLH-18)
	end
end

Locker = { actiontype = 1, solid = true, interactive = true }
Locker.__index = Locker
setmetatable(Locker,Container)

function Locker.create(x,y,dir,storage)
	local self = Container.create(x,y,storage)
	setmetatable(self,Locker)
	self.dir = mymath.strToDir(dir)
	if self.dir == 3 then -- front
		self.cbox = {x = self.x*CELLW,y = self.y*CELLH, w = CELLW, h = CELLH-1}
	elseif self.dir == 2 then -- left
		self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = 12, h = 8}
	else -- right
		self.cbox = {x = self.x*CELLW+4, y = self.y*CELLH, w = 12, h = 8}
	end
	return self
end

function Locker:draw()
	if self.dir == 3 then -- front
		love.graphics.drawq(imgTiles,quadLockerFront,self.x*CELLW+1,self.y*CELLH-23)
		if self.open then
			love.graphics.drawq(imgTiles,quadLockerFrontDoor,self.x*CELLW+2,self.y*CELLH-16)
		end
	elseif self.dir == 2 then --left
		love.graphics.drawq(imgTiles,quadLockerSide,self.x*CELLW,self.y*CELLH-24)
		if self.open then
			love.graphics.drawq(imgTiles,quadLockerSideDoor,self.x*CELLW+12,self.y*CELLH-23)
		end
	elseif self.dir == 0 then --right
		love.graphics.drawq(imgTiles,quadLockerSide,self.x*CELLW+4,self.y*CELLH-24)
		if self.open then
			love.graphics.drawq(imgTiles,quadLockerSideDoor,self.x*CELLW,self.y*CELLH-23,0,-1,1,4)
		end
	end
end

Fridge = { actiontype = 1, solid = true, interactive = true }
Fridge.__index = Fridge
setmetatable(Fridge,Container)

function Fridge.create(x,y,storage)
	local self = Container.create(x,y,storage)
	setmetatable(self,Fridge)
	map[x][y] = TILE_DOOR
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH}
	self.abox = {x = self.x*CELLW+4, y = (self.y+1)*CELLH, w = CELLW-8, h = CELLH-2}
	return self
end

function Fridge:draw()
	if self.open then
		love.graphics.drawq(imgTiles,quadFridgeOpen,self.x*CELLW,(self.y-3)*CELLH)
	else
		love.graphics.drawq(imgTiles,quadFridgeClosed,self.x*CELLW,(self.y-3)*CELLH)
	end
end

Toilet = { actiontype = 2, solid = true, interactive = true }
Toilet.__index = Toilet
setmetatable(Toilet, Container)

function Toilet.create(x,y,storage)
	local self = Container.create(x,y,storage)
	setmetatable(self,Toilet)
	self.cbox = { x = self.x*CELLW+4, y = self.y*CELLH, w = 7, h = 6 }
	self.abox = {x = self.x*CELLW+4, y = self.y*CELLH, w = 7, h = CELLH+2}
	return self
end

function Toilet:draw()
	if self.open then
		love.graphics.drawq(imgTiles,quadToiletOpen,self.x*CELLW+4,self.y*CELLH-15)
	else
		love.graphics.drawq(imgTiles,quadToiletClosed,self.x*CELLW+4,self.y*CELLH-15)
	end
end
