p1start = {3, 1}
p2start = {2, 1}

local add = add

add.entrance(2,1)

-- Doors
add.door(5,5,"left")
add.door(17,6,"left")
add.door(36,9,"vert",1)
add.door(34,13,"right")
add.door(19,14,"left")
add.door(34,23,"right")
add.door(22,27,"right")
add.door(4,20,"vert")

-- Storage roomso
add.vent(18,8,"down",1,2)

-- Cantina
add.cabinet(20,10,"key1")

-- Kitchen
add.vent(18,10,"up",2,1)

add.fridge(15,10)
add.fridge(16,10,"msgThese guys sure like sausage","jamal")
add.fridge(17,10)

add.sink(13,10)
add.oven(12,10)

add.sink(13,13)
add.sink(15,13)
add.sink(13,16)
add.sink(15,16)
