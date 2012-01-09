p1start = {112,40}
p2start = {96,40}

table.insert(entities[22],Safe.create(17,22))

table.insert(entities[11],Painting.create(2,11,0))
table.insert(entities[11],Painting.create(4,11,1))

table.insert(entities[11],Cabinet.create(10,11))
table.insert(entities[22],Locker.create(12,22))

table.insert(entities[1],Vent.create(12,1,0,1,1))
table.insert(entities[1],Vent.create(14,1,1,0,-1))

table.insert(entities[9], Vent.create(3, 9,2,3,1337))
table.insert(entities[11],Vent.create(3,11,3,2,0))

table.insert(entities[11],Plant.create(1,11,0))
table.insert(entities[11],Plant.create(12,11,1))

table.insert(entities[1],TableDecor.create(3,1,0))
table.insert(entities[1],TableDecor.create(2,1,7))

table.insert(entities[13],TableDecor.create(2,13,1))
table.insert(entities[14],TableDecor.create(3,14,2))
table.insert(entities[17],TableDecor.create(3,17,2))
table.insert(entities[14],TableDecor.create(9,14,2))
table.insert(entities[17],TableDecor.create(9,17,2))
table.insert(entities[16],TableDecor.create(4,16,3))
table.insert(entities[16],TableDecor.create(8,16,4))
table.insert(entities[16],TableDecor.create(10,16,5))

table.insert(entities[1],Fridge.create(4,1))

table.insert(entities[11],Watercooler.create(22,11))

table.insert(entities[14],TableDecor.create(16,14,2))
table.insert(entities[14],TableDecor.create(18,14,2))
table.insert(entities[14],TableDecor.create(20,14,2))
table.insert(entities[13],TableDecor.create(16,13,6))
table.insert(entities[13],TableDecor.create(18,13,6))
table.insert(entities[13],TableDecor.create(20,13,6))

-- Robots
table.insert(robots,Robot.create({{14,2},{14,8},{22,8},{22,2}}))
table.insert(robots,Robot.create({{22,8},{22,2},{14,2},{14,8}}))
table.insert(robots,Robot.create({{17,3},{17,6},{19,6},{19,3}}))

-- Cameras
table.insert(cameras,Camera.create(1,8,0))
table.insert(cameras,Camera.create(1,17,0))
table.insert(cameras,Camera.create(12,17,2))
table.insert(cameras,Camera.create(8,1,3))
table.insert(cameras,Camera.create(9,9,1))

-- Sofa
table.insert(entities[1],Sofa.create(9,1,3))
table.insert(entities[4],Sofa.create(9,4,1))
