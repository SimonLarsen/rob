Jamal = { isJamal = true }
Jamal.__index = Jamal
setmetatable(Jamal,Player)

function Jamal.create(x,y,player)
	local self = Player.create(x,y,player)
	setmetatable(self,Jamal)
	return self
end

function Jamal:update(dt)
	if self.state == 0 then
		self:updateplayer(dt)
	elseif self.state == 1 then
		self.frame = self.frame + dt
		if self.frame >= 1 then
			self.x, self.y = self.crawlToX, self.crawlToY
			self.frame = 0
			self.state = 2
		end
	elseif self.state == 2 then
		self.frame = self.frame + dt
		if self.frame >= 1 then
			self.frame = 0
			self.state = 0
		end
	end
end

function Jamal:crawlVent(dest,dir)
	self.x = math.floor(self.x/16)*16+8
	self.y = math.floor(self.y/8)*8+4

	if dir == 0 then self.xdir = 1
	elseif dir == 2 then self.xdir = -1 end

	self.crawlToX = dest.x*CELLW+8
	self.crawlToY = dest.y*CELLH+4
	self.frame = 0
	self.state = 1
	self.crawldir = dir
end

function Jamal:draw()
	if self.state == 0 then -- normal state
		if self.moving then
			love.graphics.drawq(imgSkins[self.skin],quadJamal[1+math.floor(self.frame)],self.x,self.y,0,self.xdir,1,5.5,26)
		else
			love.graphics.drawq(imgSkins[self.skin],quadJamal[0],self.x,self.y,0,self.xdir,1,5.5,26)
		end
		if self.actiontype > 0 then
			love.graphics.drawq(imgSprites,quadAction[self.actiontype],self.x,self.y,0,1,1,4.5,36)
		end
	elseif self.state == 1 then -- crawling into vent
		if self.crawldir == 0 or self.crawldir == 2 then
			love.graphics.drawq(imgSkins[self.skin],quadJamalIntoVentSide[math.floor(self.frame*8)],self.x,self.y,0,self.xdir,1,8,26)
		else
			love.graphics.drawq(imgSkins[self.skin],quadJamalIntoVentFront[math.floor(self.frame*8)],self.x,self.y,0,self.xdir,1,8,26)
		end
	elseif self.state == 2 then -- crawling out of vent
		if self.crawldir == 0 or self.crawldir == 2 then
			love.graphics.drawq(imgSkins[self.skin],quadJamalOutVentSide[math.floor(self.frame*8)],self.x,self.y,0,self.xdir,1,8,26)
		else
			love.graphics.drawq(imgSkins[self.skin],quadJamalOutVentFront[math.floor(self.frame*8)],self.x,self.y,0,self.xdir,1,8,26)
		end
	end
end

function Jamal:collideWalls()
	local x1, x2 = math.floor((self.x-6)/CELLW), math.floor((self.x+6)/CELLW)
	local y1, y2 = math.floor((self.y-3)/CELLH), math.floor((self.y+3)/CELLH)

	if map[x1][y1] < 10 and map[x2][y1] < 10 and map[x1][y2] < 10 and map[x2][y2] < 10 then
		return false
	end

	return true
end

function Jamal:collideBox(e)
	if self.x-6 > e.x+e.w or self.x+6 < e.x or
	self.y-3 > e.y+e.h or self.y+3 < e.y then
		return false
	else
		return true
	end
end
