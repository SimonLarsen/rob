p1start = {3,4}
p2start = {3,5}

add("closet",1,1)

add("locker",2,1,"front")

add("locker",1,6,"left")
add("locker",1,7,"left")

add("locker",5,8,"right")
add("locker",5,9,"right")

add("door",6,6,"left")
add("door",18,6,"left")

addRobot({{9,6},{15,6}})
addRobot({{12,3},{12,9}})

add("vent",4,11,"down",1,2)
add("vent",4,13,"up",2,1)

local dr1 = add("door",21,12,"vert",1337)
local tv1= add("television",24,13)
tv1.interactive = false
add("pressureplate",22,13,{dr1,tv1})

add("chair",4,16)
add("chair",4,19)
add("chair",9,16)
add("chair",9,19)
add("watercooler",1,13)
addRotatingRobot({{7,15},{7,18}})

add("cabinet",19,1, function() addKey(1) end)
add("locker",21,1,"front")

add("door",24,6,"right",1)
add("bossdesk",27,4)
add("safe",30,1, function() addMessage("lolrofl") end)

addCamera(25,4,"right")
