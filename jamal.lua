Jamal = {}
Jamal.__index = Jamal
setmetatable(Jamal,Player)

function Jamal.create(x,y,player)
	local self = Player.create(x,y,player)
	setmetatable(self,Jamal)
	return self
end

function Jamal:draw()
	if self.moving then
		love.graphics.drawq(imgSprites,quadJamal[1+math.floor(self.frame)],self.x,self.y,0,self.xdir,1,5.5,26)
	else
		love.graphics.drawq(imgSprites,quadJamal[0],self.x,self.y,0,self.xdir,1,5.5,26)
	end
	if self.actiontype > 0 then
		love.graphics.drawq(imgSprites,quadAction[self.actiontype],self.x,self.y,0,1,1,4.5,36)
	end
end

function Jamal:collideWalls()
	local x1, x2 = math.floor((self.x-6)/CELLW), math.floor((self.x+6)/CELLW)
	local y1, y2 = math.floor((self.y-3)/CELLH), math.floor((self.y+3)/CELLH)

	if map[x1][y1] < 5 and map[x2][y1] < 5 and map[x1][y2] < 5 and map[x2][y2] < 5 then
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
