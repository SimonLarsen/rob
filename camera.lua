Camera = {}
Camera.__index = Camera

function Camera.create(x,y,dir)
	local self = {}
	setmetatable(self,Camera)
	self.x = x
	self.y = y
	self.dir = dir
	-- dir: 0 - right, 1 - up, 2 - left, 3 - down
	return self
end

function Camera:draw()
	if self.dir == 0 then -- right
		love.graphics.drawq(imgTiles,quadCameraSide,self.x*CELLW+1,self.y*CELLH-32)
		love.graphics.drawq(imgTiles,quadCameraSideShadow,self.x*CELLW+1,self.y*CELLH+3)
	elseif self.dir == 1 then -- up
		love.graphics.drawq(imgTiles,quadCameraUp,self.x*CELLW+6,self.y*CELLH-31)
		love.graphics.drawq(imgTiles,quadCameraDownShadow,self.x*CELLW+6,self.y*CELLH+1,0,1,-1,0,6)
	elseif self.dir == 2 then -- left
		love.graphics.drawq(imgTiles,quadCameraSide,self.x*CELLW+6,self.y*CELLH-32,0,-1,1,9)
		love.graphics.drawq(imgTiles,quadCameraSideShadow,self.x*CELLW+7,self.y*CELLH+3,0,-1,1,8)
	else 					-- down
		love.graphics.drawq(imgTiles,quadCameraDown,self.x*CELLW+6,self.y*CELLH-31)
		love.graphics.drawq(imgTiles,quadCameraDownShadow,self.x*CELLW+6,self.y*CELLH+1)
	end
end

function Camera:update(dt)
	if self:canSeePlayer(pl1) or self:canSeePlayer(pl2) then
		alarm()
	end
end

function Camera:canSeePlayer(pl)
	local toplx = pl.x - ((self.x+0.5)*CELLW)
	local toply = pl.y - ((self.y+0.5)*CELLH)

	if math.pow(toplx,2)+math.pow(toply,2) > 16000 then return false end

	local fromx, fromy = mymath.dirToVector(self.dir)
	local angle = mymath.angle(toplx,toply,fromx,fromy)

	if angle > 0.1 or angle < -0.1 then
		return false
	end

	return self:canSee(self.x,self.y,
		math.floor(pl.x/CELLW), math.floor(pl.y/CELLH),pl)
end

function Camera:canSee(x0,y0,x1,y1,pl)
	local dx, dy = math.abs(x1-x0), math.abs(y1-y0)
	local sx,sy,e2
	if x0 < x1 then sx = 1 else sx = -1 end
	if y0 < y1 then sy = 1 else sy = -1 end
	local err = dx-dy

	while true do
		local val = map[x0][y0]
		if val == TILE_WALL or val == TILE_DOOR
		or val == TILE_DOUBLECRATE or (pl.isHerbie and val == TILE_CRATE) then
			if x0 ~= self.x or y0 ~= self.y then
				return false
			end
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
