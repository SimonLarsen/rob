p1start = {9,3}
p2start = {8,3}

-- start zone
add("entrance",8,1)
add("painting",10,1,6) -- clock
add("door",12,3,"left")
add("door",9,7,"vert")
add("door",15,24,"vert")
add("painting",8,8,8)
add("painting",10,8,9)

add("vent",7,13,"left",1,2)
add("vent",5,13,"right",2,1)

add("locker",11,8,"right")
add("locker",11,9,"right")
add("locker",11,10,"right")
add("watercooler",7,8)

addCamera(7,12,"right")

-- laser corridor
local las1 = addLaser(2,20,4,20)
local las2 = addLaser(13,25,13,29)
addTimedLaser(6,25,6,29,1.0,1.0)

-- button room
add("pressureplate",17,8,{las1,las2})
addRobot({{17,6},{21,6},{21,3},{17,3}})
addRobot({{22,12},{22,8},{19,8},{19,12}})
add("door",24,6,"right")

-- table room
addRobot({{18,18},{25,18}})
add("chair",17,18,"down") add("chair",18,18,"down") add("chair",19,18,"down")
add("chairfront",17,17,"down") add("chairfront",18,17,"down") add("chairfront",19,17,"down")
add("chair",17,21,"down") add("chair",18,21,"down") add("chair",19,21,"down")
add("chairfront",17,20,"down") add("chairfront",18,20,"down") add("chairfront",19,20,"down")
add("chair",23,18,"down") add("chair",24,18,"down") add("chair",25,18,"down")
add("chairfront",23,17,"down") add("chairfront",24,17,"down") add("chairfront",25,17,"down")
add("chair",23,21,"down") add("chair",24,21,"down") add("chair",25,21,"down")
add("chairfront",23,20,"down") add("chairfront",24,20,"down") add("chairfront",25,20,"down")
add("plate",17,17) add("plate",18,20) add("plate",24,17) add("plate",25,20) add("plate",24,20)
addCamera(21,16,"down")
add("cabinet",13,16)
add("painting",18,16,3)
add("painting",24,16,4)

-- kitchen
add("fridge",7,19,function(b,pl) pl:addKey(1) end)
add("door",12,21,"left")
add("oven",10,19)
add("sink",9,19)

-- right of table room
add("glassdoor",31,15,"vert")

-- meeting room
addCamera(39,5,"down")
addCamera(45,5,"down")
addRobot({{39,9},{39,14},{40,14},{40,9}})
addRobot({{44,9},{44,14},{45,14},{45,9}})
add("door",28,17,"right")
add("door",33,17,"left")

-- hallway
add("plant",25,5,1)
add("cabinet",26,5)
add("painting",29,5,0)
add("painting",31,5,1)
add("plant",32,5,2)
add("door",33,6,"left",1)

-- big meeting room
add("projector",42,7)
add("watercooler",34,5)
add("chair",37,8) add("chair",38,11) add("chair",37,14) add("chair",37,17)
add("typewriter",37,13) add("desklamp",38,13)
add("chair",42,11) add("chair",43,11) add("chair",42,14) add("chair",42,17)
add("chair",47,8) add("chair",47,14) add("chair",47,17)
add("book",41,13) add("telephone",43,16) add("typewriter",47,10) add("typewriter",46,13)
add("typewriter",43,10) add("desklamp",48,16)

-- right hall
add("door",50,16,"right")
local halllaser = addLaser(52,25,54,25)

-- top right
add("door",50,6,"right")
add("switch",53,5,{halllaser,function(state) if state == true then addMessage("You hear lasers turning off somewhere") end end})
add("locker",51,5,"front")
add("locker",52,5,"front")

-- laser corridor 2
add("door",50,23,"left")
add("door",37,26,"vert")
local tlas1 = addLaser(40,22,40,25)
local tlas2 = addLaser(44,22,44,25)
local tlas3 = addLaser(48,22,48,25)
add("glassdoor",15,30,"vert",666)

-- big button crate lol room of pasta galore
add("door",50,31,"left")
add("door",34,27,"left")
add("pressureplate",35,31,{tlas1})
add("pressureplate",44,28,{tlas2})
add("pressureplate",48,32,{tlas3})

addRotatingRobot({{43,33},{43,35},{45,35},{45,33}})
addRobot({{40,38},{46,38}})
addRobot({{38,33},{38,38}})

-- final room
add("bossdesk",30,31,"up")
add("safe",29,27, function() addMessage("You got the loot!") end)
add("painting",31,27,6) -- clock
