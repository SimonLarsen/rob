Entity = { actiontype = 0, solid = false, interactive = false }
Entity.__index = Entity

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
	print("This message shouldn't appear.")
end

Door = { actiontype = 1, solid = true, interactive = true }
Door.__index = Door
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
	if self.open == true then
		self.open = false
		map[self.x][self.y] = TILE_DOOR
	else
		self.open = true
		map[self.x][self.y] = TILE_DARKFLOOR
	end

	if self.open == false then
		if pl1:collideBox(self:getCollisionBox())
		or pl2:collideBox(self:getCollisionBox()) then
			self.open = true
			map[self.x][self.y] = TILE_DARKFLOOR
		end
	end
end

Vent = { actiontype = 4, solid = false, interactive = true }
Vent.__index = Vent
setmetatable(Vent,Entity)

function Vent.create(x,y,id,dest,dir)
	local self = Entity.create(x,y)
	setmetatable(self,Vent)
	self.isVent = true
	self.id = id
	self.dest = dest
	self.dir = dir -- 0 - front, -1 - left wall, 1 - right wall
	return self
end

function Vent:draw()
	if self.dir == 0 then
		love.graphics.drawq(imgTiles,quadVentFront,self.x*CELLW,(self.y-1)*CELLH)
	elseif self.dir == -1 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH,0,1,1)
	elseif self.dir == 1 then
		love.graphics.drawq(imgTiles,quadVentSide,self.x*CELLW,self.y*CELLH,0,-1,1,16)
	end
end

function Vent:action(pl)
	if pl.isJamal then
		for iy=0,MAPH-1 do
			for i=1,#entities[iy] do
				if entities[iy][i].isVent and entities[iy][i].id == self.dest then
					pl.x = (entities[iy][i].x+0.5)*CELLW
					pl.y = (entities[iy][i].y+0.5)*CELLH
					return
				end
			end
		end
	end
end
