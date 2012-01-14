Camera = {}
Camera.__index = Camera

function Camera.create(x,y,dir)
	local self = {}
	setmetatable(self,Camera)
	self.x = x
	self.y = y
	self.dir = mymath.strToDir(dir)
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
		if alarm() then
			print("Camera at " .. self.x .. "," .. self.y .. " triggered alarm")
		end
	end
end

function Camera:canSeePlayer(pl)
	local toplx = pl.x - ((self.x+0.5)*CELLW)
	local toply = pl.y - ((self.y+0.5)*CELLH)

	if math.pow(toplx,2)+math.pow(toply,2) > 6000 then return false end

	local fromx, fromy = mymath.dirToVector(self.dir)
	local angle = mymath.angle(toplx,toply,fromx,fromy)

	if angle > 0.15 or angle < -0.15 then
		return false
	end

	return self:canSee(self.x,self.y,
		math.floor(pl.x/CELLW), math.floor(pl.y/CELLH),pl)
end

local fl = math.floor
function Camera:canSee(x0,y0,x1,y1,pl)
	local xvec, yvec = x1-x0, y1-y0
	local steps = 2*math.ceil(math.sqrt(math.pow(xvec,2) + math.pow(yvec,2)))
	if steps <= 0 then return false end

	local xstep, ystep = xvec/steps, yvec/steps
	local ox, oy = -1,-1
	local ix, iy = x0, y0

	for i = 0,steps do
		if fl(ix) ~= fl(ox) or fl(iy) ~= fl(oy) then
			local val = map[fl(ix)][fl(iy)]

			if val == TILE_WALL or val == TILE_DOOR
			or val == TILE_DOUBLECRATE or (pl.isHerbie and val == TILE_CRATE) then
				return false
			end
		end
		ox, oy = ix, iy
		ix = ix + xstep
		iy = iy + ystep
	end
	return true
end
