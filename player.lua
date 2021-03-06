keybinds = {}
keybinds[1] = {"up","down","left","right","return"}
keybinds[2] =  {"w","s","a","d"," "}

Player = {}
Player.__index = Player

function Player.create(player)
	local self = {}
	setmetatable(self,Player)

	self.xdir = 1 -- 1 = right, -1 = left
	self.frame = 0
	self.moving = false
	self.skin = 1
	self.player = player
	self.actiontype = 0 -- indicates type of action to perform if any (0 for none)
	self.keys = {}
	self.state = 0
	-- 0 = walking
	-- 1 = crawling into vent (only Jamal)
	-- 2 = crawling out of vent (only Jamal)
	-- 3 = rolling (only Herbie)
	-- 4 = falling animation
	return self
end

function Player:update(dt)
	self:updateplayer(dt)
end

function Player:reset()
	self.frame = 0
	self.xdir = 1
	self.actiontype = 0
	self.state = 0
	self.keys = {}
end

function Player:addKey(num)
	addMessage("# You found a key!",self.player)
	self.keys[num] = true
end

function Player:updateplayer(dt)
	self.moving = false
	local oldx, oldy = self.x, self.y

	if love.keyboard.isDown(keybinds[self.player][1]) then
		self.y = self.y - PLAYER_SPEED*dt
		self.moving = true
	elseif love.keyboard.isDown(keybinds[self.player][2]) then
		self.y = self.y + PLAYER_SPEED*dt
		self.moving = true
	end

	if self:collideWalls() or self:collideEntities() then
		self.y = oldy
	end

	if love.keyboard.isDown(keybinds[self.player][3]) then
		self.xdir = -1
		self.x = self.x - PLAYER_SPEED*dt
		self.moving = true elseif love.keyboard.isDown(keybinds[self.player][4]) then
		self.xdir = 1
		self.x = self.x + PLAYER_SPEED*dt
		self.moving = true
	end

	if self:collideWalls() or self:collideEntities() then
		self.x = oldx
	end

	self.frame = (self.frame+dt*PLAYER_FRAMESPEED)%4

	-- find current action
	local e = self:findActionEntity()
	self.actiontype = 0
	if e ~= nil then
		if self.isHerbie and e.herbieEnabled == false or
		   self.isJamal  and e.jamalEnabled == false then
			self.actiontype = 6
		else
				self.actiontype = e.actiontype
		end
	end
end

function Player:keypressed(k)
	if k == keybinds[self.player][5] and self.state == 0 then
		self:action()
	end
end

function Player:collideWalls()
	local x1, x2 = math.floor((self.x-7)/CELLW), math.floor((self.x+7)/CELLW)
	local y1, y2 = math.floor((self.y-2)/CELLH), math.floor((self.y+2)/CELLH)

	if map[x1][y1] < 10 and map[x2][y1] < 10 and map[x1][y2] < 10 and map[x2][y2] < 10 then
		return false
	end

	return true
end

function Player:collideEntities()
	for iy = 0, MAPH-1 do
		for i=1,#entities[iy] do
			if entities[iy][i].solid and self:collideBox(entities[iy][i]:getCollisionBox()) then
				return true
			end
		end
	end
	return false
end

function Player:collideBox(e)
	if self.x-7 > e.x+e.w or self.x+7 < e.x or
	self.y-3 > e.y+e.h or self.y+3 < e.y then
		return false
	else
		return true
	end
end

function Player:findActionEntity()
	for iy = 0, MAPH-1 do
		for i = 1, #entities[iy] do
			if entities[iy][i].interactive and self:collideBox(entities[iy][i]:getActionBox()) then
				return entities[iy][i]
			end
		end
	end
	return nil
end

function Player:action()
	local e = self:findActionEntity()
	if e ~= nil then
		e:action(self,false)
	end
end

function Player:lose()
	if self.state ~= 4 then
		self.frame = 0
		self.state = 4
	end
end
