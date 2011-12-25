Decor = {}
Decor.__index = Decor

function Decor.create(x,y)
	local self = {}
	setmetatable(self,Decor)

	self.x = x
	self.y = y
	
	return self
end
