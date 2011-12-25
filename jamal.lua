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
