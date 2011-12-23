Player = {}
Player.__index = Player

function Player:update(dt)
	self.moving = false
	local oldx, oldy = self.x, self.y

	if love.keyboard.isDown(keys[self.player][1]) then
		self.ydir = -1
		self.y = self.y - PLAYER_SPEED*dt
		self.moving = true
	elseif love.keyboard.isDown(keys[self.player][2]) then
		self.ydir = 1
		self.y = self.y + PLAYER_SPEED*dt
		self.moving = true
	end

	if self:collideWalls() then
		self.y = oldy
	end

	if love.keyboard.isDown(keys[self.player][3]) then
		self.xdir = -1
		self.x = self.x - PLAYER_SPEED*dt
		self.moving = true
	elseif love.keyboard.isDown(keys[self.player][4]) then
		self.xdir = 1
		self.x = self.x + PLAYER_SPEED*dt
		self.moving = true
	end

	if self:collideWalls() then
		self.x = oldx
	end

	self.frame = (self.frame+dt*PLAYER_FRAMESPEED)%4
end

function Player:collideWalls()
	local x1, x2 = math.floor((self.x-7)/CELLW), math.floor((self.x+7)/CELLW)
	local y1, y2 = math.floor((self.y-4)/CELLH), math.floor((self.y+4)/CELLH)

	if map[x1][y1] < 5 and map[x2][y1] < 5 and map[x2][y1] < 5 and map[x2][y2] < 5 then
		return false
	end

	return true
end
