Herbie = { isHerbie = true }
Herbie.__index = Herbie
setmetatable(Herbie,Player)

function Herbie.create(x,y,player)
	local self = Player.create(x,y,player)
	setmetatable(self,Herbie)
	return self
end

function Herbie:update(dt)
	if self.state == 0 then
		self:updateplayer(dt)
	elseif self.state == 3 then
		local oldx, oldy = self.x, self.y

		if self.rolldir == 0 then
			self.x = self.x + 2*PLAYER_SPEED*dt
		elseif self.rolldir == 1 then
			self.y = self.y - 1.5*PLAYER_SPEED*dt
		elseif self.rolldir == 2 then
			self.x = self.x - 2*PLAYER_SPEED*dt
		else
			self.y = self.y + 1.5*PLAYER_SPEED*dt
		end
		
		if self:collideWalls() or self:collideEntities() then
			self.x, self.y = oldx, oldy
		end

		self.rolltime = self.rolltime - dt
		if self.rolltime <= 0 then
			self.state = 0
		end
	end
end

function Herbie:draw()
	if self.state == 0 then
		if self.moving then
			love.graphics.drawq(imgSkins[self.skin],quadHerbie[1+math.floor(self.frame)],self.x,self.y,0,self.xdir,1,7,20)
		else
			love.graphics.drawq(imgSkins[self.skin],quadHerbie[0],self.x,self.y,0,self.xdir,1,7,20)
		end
		if self.actiontype > 0 then
			love.graphics.drawq(imgSprites,quadAction[self.actiontype],self.x,self.y,0,1,1,4.5,32)
		end
	elseif self.state == 3 then
		local fr = math.floor(self.rolltime*16)
		if self.rolldir == 0 then -- right
			love.graphics.drawq(imgSkins[self.skin],quadHerbieRollSide[fr],self.x,self.y,0,1,1,7.5,19)
		elseif self.rolldir == 1 then -- up
			love.graphics.drawq(imgSkins[self.skin],quadHerbieRollBack[fr],self.x,self.y,0,1,1,7,19)
		elseif self.rolldir == 2 then --left
			love.graphics.drawq(imgSkins[self.skin],quadHerbieRollSide[fr],self.x,self.y,0,-1,1,7.5,19)
		elseif self.rolldir == 3 then -- down
			love.graphics.drawq(imgSkins[self.skin],quadHerbieRollFront[fr],self.x,self.y,0,1,1,7,19)
		end
	end
end

function Herbie:roll()
	self.state = 3
	self.rolltime = 0.75
	if love.keyboard.isDown(keybinds[self.player][1]) then self.rolldir = 1
	elseif love.keyboard.isDown(keybinds[self.player][2]) then self.rolldir = 3
	elseif love.keyboard.isDown(keybinds[self.player][3]) then self.rolldir = 2
	elseif love.keyboard.isDown(keybinds[self.player][4]) then self.rolldir = 0
	else self.state = 0 end
end

function Herbie:action()
	local e = self:findActionEntity()
	if e ~= nil then
		e:action(self)
	else
		self:roll()
	end
end
