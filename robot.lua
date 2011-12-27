Robot = {}
Robot.__index = Robot

-- {1,1, 1,5, 5,5, 5,1}

function Robot.create(x,y,points)
	local self = {}
	setmetatable(self,Robot)

	self.x, self.y = x,y
	self.frame = 0
	self.points = points
	self.point = 1
	self:getDir()
	-- dir: 0 - right, 1 - up, 2 - left, 3 - down

	return self
end

function Robot:update(dt)
	self.frame = (self.frame+dt*4)%4
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
		self.dist = x2 - x1
	elseif x2 < x1 then
		self.dir = 2
		self.dist = x1 - x2
	elseif y2 > y1 then
		self.dir = 3
		self.dist = y2 - y1
	elseif y2 < y1 then
		self.dir = 1
		self.dist = y1 - y2
	end
end
