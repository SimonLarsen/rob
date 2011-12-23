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
		love.graphics.drawq(imgSprites,quadHerbie[1+math.floor(self.frame)],self.x,self.y,0,self.xdir,1,7,21)
	else
		love.graphics.drawq(imgSprites,quadHerbie[0],self.x,self.y,0,self.xdir,1,7,21)
	end

	love.graphics.setColor(255,0,0)
	love.graphics.circle("fill",self.x,self.y,1,8)
	love.graphics.setColor(255,255,255)
end
