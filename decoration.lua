Painting = { solid = false, interactive = false }
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

Shower = { solid = true, interactive = false }
Shower.__index = Shower
setmetatable(Shower,Entity)

function Shower.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Shower)
	return self
end

function Shower:draw()
	love.graphics.drawq(imgTiles,quadShower,self.x*CELLW,self.y*CELLH-24)
end

function Shower:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH}
end

Television = { actiontype = 2, solid = true, interactive = true, realtime = true }
Television.__index = Television
setmetatable(Television,Entity)

function Television.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Television)
	self.on = false
	self.frame = 0
	return self
end

function Television:action()
	self.on = not self.on
end

function Television:update(dt)
	self.frame = (self.frame + dt*10)%7
end

function Television:draw()
	if self.on then
		love.graphics.drawq(imgTiles,quadTVFrames[1+math.floor(self.frame)],self.x*CELLW+3, self.y*CELLH-5)
	else
		love.graphics.drawq(imgTiles,quadTVFrames[0],self.x*CELLW+3, self.y*CELLH-5)
	end
	love.graphics.drawq(imgTiles,quadTelevision,self.x*CELLW, self.y*CELLH-13)
end

function Television:getCollisionBox()
	return {x = self.x*CELLW, y = self.y*CELLH+1, w = CELLW, h = CELLH-2}
end

Entrance = { solid = false, interactive = false }
Entrance.__index = Entrance

function Entrance.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Entrance)
	return self
end

function Entrance:draw()
	love.graphics.drawq(imgTiles,quadEntrance,self.x*CELLW-1,self.y*CELLW-40)
end
