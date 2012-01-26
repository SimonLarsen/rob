p1start = {7,7}
p2start = {8,7}

local las1 = addLaser(11,4,11,8)
local sw1 = add("switch",10,3,{las1})
local sw2 = add("switch",10,1,{sw1})
local sw3 = add("switch",8,2,{sw2})

addTimedLaser(5,10,7,10,0.05,0.05)
