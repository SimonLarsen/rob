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
	self.id = (self.id+1)%7
end

function Painting:getActionBox()
	return {x = self.x*CELLW+4, y = self.y*CELLH, w = CELLW-8, h = CELLH-7}
end

Plant = { solid = true, interactive = false }
Plant.__index = Plant
setmetatable(Plant,Entity)

function Plant.create(x,y,id)
	local self = Entity.create(x,y)
	setmetatable(self,Plant)
	self.id = id
	return self
end

function Plant:getCollisionBox()
	return {x = self.x*CELLW+5, y = self.y*CELLH+3, w = 5, h = 3}
end

function Plant:draw()
	love.graphics.drawq(imgTiles,quadPlant[self.id],self.x*CELLW,(self.y-2)*CELLH)
end

TableDecor = { solid = false, interactive = false }
TableDecor.__index = TableDecor
setmetatable(TableDecor,Entity)

function TableDecor.create(x,y,id)
	local self = Entity.create(x,y)
	setmetatable(self,TableDecor)
	self.id = id
	return self
end

function TableDecor:draw()
	love.graphics.drawq(imgTiles,quadTableDecor[self.id],self.x*CELLW,(self.y-2)*CELLH)
end

Watercooler = { solid = true, interactive = false }
Watercooler.__index = Watercooler
setmetatable(Watercooler,Entity)

function Watercooler.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Watercooler)
	return self
end

function Watercooler:draw()
	love.graphics.drawq(imgTiles,quadWatercooler,self.x*CELLW+3,self.y*CELLH-17)
end

function Watercooler:getCollisionBox()
	return {x = self.x*CELLW+3, y = self.y*CELLH+1, w = 11, h = 6}
end

Sofa = { solid = true, interactive = false }
Sofa.__index = Sofa
setmetatable(Sofa,Entity)

function Sofa.create(x,y,dir)
	local self = Entity.create(x,y)
	setmetatable(self,Sofa)
	self.dir = mymath.strToDir(dir) -- 1 = back, 3 = front
	return self
end

function Sofa:draw()
	if self.dir == 3 then
		love.graphics.drawq(imgTiles,quadSofaFront,self.x*CELLW,self.y*CELLH-11)
	elseif self.dir == 1 then
		love.graphics.drawq(imgTiles,quadSofaBack,self.x*CELLW,self.y*CELLH-9)
	end
end

function Sofa:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = 2*CELLW, h = CELLH}
end

Bed = { solid = true, interactive = false }
Bed.__index = Bed
setmetatable(Bed,Entity)
	
function Bed.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Bed)
	return self
end

function Bed:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = 2*CELLW, h = CELLH}
end

function Bed:draw()
	love.graphics.drawq(imgTiles,quadBed,self.x*CELLW,self.y*CELLH-17)
end
