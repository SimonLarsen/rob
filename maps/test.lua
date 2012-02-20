p1start = {2,2}
p2start = {3,2}
add("door",5.0,17.0,"right",nil)
add("door",12.0,17.0,"left",nil)
addTimedLaser(7.0,16.0,7.0,18.0,1.0,1.0)
addTimedLaser(10.0,16.0,10.0,18.0,1.0,1.0)
add("entrance",2.0,1.0)
add("door",5.0,4.0,"right",nil)
add("vent",2.0,8.0,"vert",1.0,2.0)
add("vent",2.0,10.0,"vert",2.0,1.0)
local door1 = add("door",5.0,11.0,"right",1234.0)
add("pressureplate",4.0,12.0,{door1})
add("cabinet",3.0,10.0,nil)

addRobot({{6,2},{6,13},{8,13},{8,2}})
