Herbie = {}
Herbie.__index = Herbie
setmetatable(Herbie,Player)

function Herbie.create(x,y,player)
	local self = Player.create(x,y,player)
	setmetatable(self,Herbie)
	return self
end

function Herbie:draw()
	if self.moving then
		love.graphics.drawq(imgSprites,quadHerbie[1+math.floor(self.frame)],self.x,self.y,0,self.xdir,1,7,20)
	else
		love.graphics.drawq(imgSprites,quadHerbie[0],self.x,self.y,0,self.xdir,1,7,20)
	end
	if self.actiontype > 0 then
		love.graphics.drawq(imgSprites,quadAction[self.actiontype],self.x,self.y,0,1,1,4.5,32)
	end
end
