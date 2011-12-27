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
