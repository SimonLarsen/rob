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

	if self:canSeePlayer(pl1) or self:canSeePlayer(pl2) then
		alarm()
	end
end

function Robot:canSeePlayer(pl)
	local toplx = pl.x - self.x
	local toply = pl.y - self.y

	if math.pow(toplx,2)+math.pow(toply,2) > 64*64 then return false end

	local fromx, fromy = mymath.dirToVector(self.dir)
	local angle = mymath.angle(toplx,toply,fromx,fromy)

	if angle > 0.3 or angle < -0.3 then
		return false
	end

	return Robot.canSee(math.floor(self.x/CELLW),math.floor(self.y/CELLH),
		math.floor(pl.x/CELLW), math.floor(pl.y/CELLH))
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

function Robot.canSee(x0,y0,x1,y1)
	local dx, dy = math.abs(x1-x0), math.abs(y1-y0)
	local sx,sy,e2
	if x0 < x1 then sx = 1 else sx = -1 end
	if y0 < y1 then sy = 1 else sy = -1 end
	local err = dx-dy

	while true do
		local val = map[x0][y0]
		if val == TILE_WALL or val == TILE_DOOR
		or val == TILE_CRATE or val == TILE_DOUBLECRATE then
			return false
		end

		if x0 == x1 and y0 == y1 then return true end
		e2 = 2*err
		if e2 > -dy then
			err = err - dy
			x0 = x0 + sx
		end
		if e2 < dx then
			err = err + dx
			y0 = y0 + sy
		end
	end
end
