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
	self.cbox = {x = self.x*CELLW+5, y = self.y*CELLH+3, w = 5, h = 3}
	return self
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
	self.cbox = {x = self.x*CELLW+3, y = self.y*CELLH+1, w = 11, h = 6}
	return self
end

function Watercooler:draw()
	love.graphics.drawq(imgTiles,quadWatercooler,self.x*CELLW+3,self.y*CELLH-17)
end

Sofa = { solid = true, interactive = false }
Sofa.__index = Sofa
setmetatable(Sofa,Entity)

function Sofa.create(x,y,dir)
	local self = Entity.create(x,y)
	setmetatable(self,Sofa)
	self.dir = mymath.strToDir(dir) -- 1 = back, 3 = front
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = 2*CELLW, h = CELLH}
	return self
end

function Sofa:draw()
	if self.dir == 3 then
		love.graphics.drawq(imgTiles,quadSofaFront,self.x*CELLW,self.y*CELLH-11)
	elseif self.dir == 1 then
		love.graphics.drawq(imgTiles,quadSofaBack,self.x*CELLW,self.y*CELLH-9)
	end
end

BossDesk = { solid = true, interactive = false }
BossDesk.__index = BossDesk
setmetatable(BossDesk,Entity)

function BossDesk.create(x,y,dir)
	local self = Entity.create(x,y)
	setmetatable(self,BossDesk)
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH+3, w = 3*CELLW, h = 13}
	self.dir = mymath.strToDir(dir)
	return self
end

function BossDesk:draw()
	if self.dir == 3 then
		love.graphics.drawq(imgTiles,quadBossDeskFront,self.x*CELLW,self.y*CELLH-13)
	elseif self.dir == 1 then
		love.graphics.drawq(imgTiles,quadBossDeskBack,self.x*CELLW,self.y*CELLH-7)
	end
end

Bed = { solid = true, interactive = false }
Bed.__index = Bed
setmetatable(Bed,Entity)
	
function Bed.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Bed)
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = 2*CELLW, h = CELLH-1}
	return self
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
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH}
	return self
end

function Shower:draw()
	love.graphics.drawq(imgTiles,quadShower,self.x*CELLW,self.y*CELLH-24)
end

Television = { actiontype = 2, solid = true, interactive = true, realtime = true }
Television.__index = Television
setmetatable(Television,Entity)

function Television.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Television)
	self.on = false
	self.frame = 0
	self.cbox = {x = self.x*CELLW, y = self.y*CELLH+1, w = CELLW, h = CELLH-2}
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

Entrance = { solid = false, interactive = false }
Entrance.__index = Entrance

function Entrance.create(x,y)
	local self = Entity.create(x,y)
	print("Entrance y: " .. y)
	setmetatable(self,Entrance)
	return self
end

function Entrance:draw()
	love.graphics.drawq(imgTiles,quadEntrance,self.x*CELLW-1,self.y*CELLH-32)
end

Projector = { actiontype = 2, solid = true, interactive = true }
Projector.__index = Projector
setmetatable(Projector,Entity)

function Projector.create(x,y)
	local self = Entity.create(x,y)
	setmetatable(self,Projector)
	for iy = y,0,-1 do
		if map[x][iy] >= 10 then
			self.image = add("projectorimage",x,iy)
			break
		end
	end
	self.cbox = {x = self.x*CELLW+3, y = self.y*CELLH+2, w = 10, h = 4}
	return self
end

function Projector:draw()
	love.graphics.drawq(imgTiles,quadProjector,self.x*CELLW+1,self.y*CELLH-14)
end

function Projector:action()
	self.image:switch()
end

ProjectorImage = { solid = false, interactive = false }
ProjectorImage.__index = ProjectorImage
setmetatable(ProjectorImage,Entity)

function ProjectorImage.create(x,y)
	local self = Entity.create(x,y)
	self.image = 0
	setmetatable(self,ProjectorImage)
	return self
end

function ProjectorImage:draw()
	love.graphics.drawq(imgTiles,quadProjectorImage[self.image],self.x*CELLW-7,self.y*CELLH-14)
end

function ProjectorImage:switch()
	self.image = (self.image+1)%3
end

Stall = { solid = true, interactive = true, actiontype = 2 }
Stall.__index = Stall
setmetatable(Stall,Entity)

function Stall.create(x,y,open)
	local self = Entity.create(x,y)
	if open then self.open = open
	else self.open = false end
	self.cbox = { x = self.x*CELLW, y = self.y*CELLH, w = CELLW, h = CELLH }
	self.abox = { x = self.x*CELLW+2, y = self.y*CELLH, w = CELLW-4, h = CELLH+2 }
	setmetatable(self,Stall)
	return self
end

function Stall:action()
	self.open = not self.open
end

function Stall:draw()
	if self.open then
		love.graphics.drawq(imgTiles,quadStallOpen,self.x*CELLW,self.y*CELLH-23)
	else
		love.graphics.drawq(imgTiles,quadStallClosed,self.x*CELLW,self.y*CELLH-23)
	end
end
