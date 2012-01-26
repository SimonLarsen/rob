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

	if math.pow(toplx,2)+math.pow(toply,2) > 128*128 then return false end

	local fromx, fromy = mymath.dirToVector(self.dir)
	local angle = mymath.angle(toplx,toply,fromx,fromy)

	if angle > 0.2 or angle < -0.2 then
		return false
	end

	return self:canSee(math.floor(self.x/CELLW),math.floor(self.y/CELLH),
		math.floor(pl.x/CELLW), math.floor(pl.y/CELLH),pl)
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

local fl = math.floor
function Robot:canSee(x0,y0,x1,y1,pl)
	local xvec, yvec = x1-x0, y1-y0
	local steps = 4*math.ceil(math.sqrt(math.pow(xvec,2) + math.pow(yvec,2)))
	if steps <= 0 then return true end

	local xstep, ystep = xvec/steps, yvec/steps
	local ox, oy = -1,-1
	local ix, iy = x0, y0

	for i = 0,steps do
		if fl(ix) ~= fl(ox) or fl(iy) ~= fl(oy) then
			local val = map[fl(ix)][fl(iy)]

			if val >= 9 and val < 20 or (pl.isHerbie and val == TILE_CRATE) then
				return false
			end
		end
		ox, oy = ix, iy
		ix = ix + xstep
		iy = iy + ystep
	end
	return true
end

RotatingRobot = {}
RotatingRobot.__index = RotatingRobot
setmetatable(RotatingRobot,Robot)

function RotatingRobot.create(points)
	local self = Robot.create(points)
	setmetatable(self,RotatingRobot)
	self.rot = 0
	return self
end

function RotatingRobot:update(dt)
	self.frame = (self.frame+dt*4)%4
	self.rot = (self.rot + dt)%8

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

function RotatingRobot:canSeePlayer(pl)
	local toplx = pl.x - self.x
	local toply = pl.y - self.y

	if math.pow(toplx,2)+math.pow(toply,2) > 128*128 then return false end

	local fromx, fromy = mymath.dirToVector(math.floor(self.rot)%4)
	local angle = mymath.angle(toplx,toply,fromx,fromy)

	if angle > 0.2 or angle < -0.2 then
		return false
	end

	return self:canSee(math.floor(self.x/CELLW),math.floor(self.y/CELLH),
		math.floor(pl.x/CELLW), math.floor(pl.y/CELLH),pl)
end

function RotatingRobot:draw()
	-- Draw body
	if self.dir == 0 then
		love.graphics.drawq(imgSprites,quadRotRobotBody[8+math.floor(self.frame)],self.x,self.y,0,1,1,5.5,13)
	elseif self.dir == 1 then
		love.graphics.drawq(imgSprites,quadRotRobotBody[4+math.floor(self.frame)],self.x,self.y,0,1,1,5.5,13)
	elseif self.dir == 2 then
		love.graphics.drawq(imgSprites,quadRotRobotBody[8+math.floor(self.frame)],self.x,self.y,0,-1,1,5.5,13)
	elseif self.dir == 3 then
		love.graphics.drawq(imgSprites,quadRotRobotBody[math.floor(self.frame)],self.x,self.y,0,1,1,5.5,13)
	end
	-- Draw rotating head
	if self.rot % 1 < 0.9 then
		love.graphics.drawq(imgSprites,quadRotRobotHead[2*math.floor(self.rot)],self.x,self.y,0,1,1,7.5,36)
	else
		love.graphics.drawq(imgSprites,quadRotRobotHead[2*math.floor(self.rot)+1],self.x,self.y,0,1,1,7.5,36)
	end
end
