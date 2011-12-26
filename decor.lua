Decor = {}
Decor.__index = Decor

function Decor.create(x,y)
	local self = {}
	setmetatable(self,Decor)

	self.x = x
	self.y = y
	self.solid = false
	
	return self
end

function Decor:getCollisionBox()
	return {x = 0, y = 0, w = 0, h = 0}
end

Crate = { solid = true }
Crate.__index = Crate
setmetatable(Crate,Decor)

function Crate.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Crate)
	return self	
end

function Crate:draw()
	love.graphics.drawq(imgTiles,quadCrate,self.x*CELLW,(self.y-2)*CELLH)
end
