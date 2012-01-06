mymath = {}

local dirToVectorX = {1,0,-1,0}
local dirToVectorY = {0,-1,0,1}

function mymath.dotP(x1,y1,x2,y2)
	return x1*x2 + y1*y2
end

function mymath.dirToVector(dir)
	return dirToVectorX[dir+1], dirToVectorY[dir+1]
end

function mymath.angle(x1,y1,x2,y2)
	local dist1, dist2 = mymath.abs(x1,y1), mymath.abs(x2,y2)
	return math.acos(mymath.dotP(x1,y1,x2,y2)/(dist1*dist2))
end

function mymath.abs(x,y)
	return math.sqrt(x*x+y*y)
end
