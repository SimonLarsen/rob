Robot = {}
Robot.__index = Robot

-- {1,1, 1,5, 5,5, 5,1}

function Robot.create(points)
	local self = {}
	setmetatable(self,Robot)

	--self.x, self.y = x,y
	self.x, self.y = (0.5+points[1][1])*CELLW, (0.5+points[1][2])*CELLH
	self.frame = 0
	self.points = points
	self.point = 1
	self:getDir()
	-- dir: 0 - right, 1 - up, 2 - left, 3 - down

	return self
end

function Robot:update(dt)
	self.frame = (self.frame+dt*4)%4

	local toMove = dt*ROBOT_SPEED
	local newDir = false
	if toMove > self.dist then
		toMove = self.dist
		newDir = true
	end

	if self.dir == 0 then
		self.x = self.x + toMove
	elseif self.dir == 1 then
		self.y = self.y - toMove
	elseif self.dir == 2 then
		self.x = self.x - toMove
	elseif self.dir == 3 then
		self.y = self.y + toMove
	end
	self.dist = self.dist - toMove

	if newDir then
		self.point = (self.point % #self.points) + 1
		self:getDir()
	end

	if self:canSeePlayer(pl1) then
		print(math.random())
	end
	if self:canSeePlayer(pl2) then
		print(math.random())
	end
end

function Robot:canSeePlayer(pl)
	local toplx = pl.x - self.x
	local toply = pl.y - self.y

	if math.pow(toplx,2)+math.pow(toply,2) > 64*64 then return false end

	local fromx, fromy = mymath.dirToVector(self.dir)
	local angle = mymath.angle(toplx,toply,fromx,fromy)

	if angle > 0.2 or angle < -0.2 then
		return false
	end

	return true
end

function Robot:draw()
	if self.dir == 0 then
		love.graphics.drawq(imgSprites,quadRobot[8+math.floor(self.frame)],self.x,self.y,0,1,1,5.5,31)
	elseif self.dir == 1 then
		love.graphics.drawq(imgSprites,quadRobot[4+math.floor(self.frame)],self.x,self.y,0,1,1,5.5,31)
	elseif self.dir == 2 then
		love.graphics.drawq(imgSprites,quadRobot[8+math.floor(self.frame)],self.x,self.y,0,-1,1,5.5,31)
	elseif self.dir == 3 then
		love.graphics.drawq(imgSprites,quadRobot[math.floor(self.frame)],self.x,self.y,0,1,1,5.5,31)
	end
end

function Robot:getDir()
	local nextpoint = (self.point % #self.points) + 1
	local x1, y1 = self.points[self.point][1], self.points[self.point][2]
	local x2, y2 = self.points[nextpoint][1], self.points[nextpoint][2]

	if x2 > x1 then
		self.dir = 0
		self.dist = (x2 - x1)*CELLW
	elseif x2 < x1 then
		self.dir = 2
		self.dist = (x1 - x2)*CELLW
	elseif y2 > y1 then
		self.dir = 3
		self.dist = (y2 - y1)*CELLH
	elseif y2 < y1 then
		self.dir = 1
		self.dist = (y1 - y2)*CELLH
	end
end
