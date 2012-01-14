p1start = {8*16, 3*8}
p2start = {9*16, 21*8}

-- Doors
table.insert(entities[5],Door.create(6,5,"left"))
table.insert(entities[5],Door.create(11,5,"right",1))
table.insert(entities[11],Door.create(5,11,"left"))
table.insert(entities[16],Door.create(11,16,"right"))
table.insert(entities[29],Door.create(8,29,"vert"))
table.insert(entities[10],Door.create(16,10,"vert"))

table.insert(entities[1],TableDecor.create(4,1,0))
table.insert(entities[1],Fridge.create(1,1,"key1"))
table.insert(entities[1],Painting.create(2,1,1))

table.insert(entities[1],Cabinet.create(14,1,"msgPoop banana monkey jazz"))
table.insert(entities[1],Cabinet.create(16,1))

table.insert(entities[10],Locker.create(1,10,"msgNothing but dirty socks in there"))
table.insert(entities[10],Painting.create(4,10,2))
table.insert(entities[11],Painting.create(15,11,0))
table.insert(entities[30],Painting.create(5,30,3))

table.insert(entities[11],Plant.create(14,11,0))
table.insert(entities[11],Watercooler.create(17,11))

table.insert(entities[11],Cabinet.create(12,11))
table.insert(entities[30],Cabinet.create(2,30))

table.insert(entities[16],TableDecor.create(14,16,2))
table.insert(entities[19],TableDecor.create(15,19,2))

table.insert(entities[15],TableDecor.create(14,15,1))
table.insert(entities[18],TableDecor.create(14,18,1))

table.insert(robots,Robot.create({{13,13},{13,20},{17,20},{17,13}}))

table.insert(entities[28],Vent.create(1,28,"down",1,2))
table.insert(entities[30],Vent.create(1,30,"up",2,1))

table.insert(cameras,Camera.create(6,10,"down"))
table.insert(cameras,Camera.create(10,15,"left"))

table.insert(cameras,Camera.create(6,30,"down"))
table.insert(cameras,Camera.create(7,35,"up"))

table.insert(entities[30],Safe.create(16,30,"goalrare Supernintendo game"))

table.insert(entities[21],Vent.create(4,21,"right",4,5))
table.insert(entities[21],Vent.create(6,21,"left",5,4))
