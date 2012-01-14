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

function mymath.strToDir(str)
	if str == "right" then return 0
	elseif str == "up" then return 1
	elseif str == "left" then return 2
	elseif str == "down" then return 3
	
	elseif str == "vert" then return 1
	elseif str == "back" then return 1
	elseif str == "front" then return 3

	else return -1
	end
end
