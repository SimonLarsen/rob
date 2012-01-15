p1start = {6, 2}
p2start = {7, 2}

-- Doors
add.door(4,4,"left")
add.door(9,4,"right")
add.door(7,6,"vert")
add.door(10,10,"right")

-- Furniture
table.insert(entities[11],Sofa.create(2,11,"back"))
table.insert(entities[7],Fridge.create(11,7,"skinblackmetal"))
table.insert(entities[1],Closet.create(1,1))
table.insert(entities[1],Bed.create(2,1))
table.insert(entities[1],Toilet.create(14,1,"skinpoo"))
table.insert(entities[1],Shower.create(13,1))
table.insert(entities[7],RecordPlayer.create(1,7))
table.insert(entities[7],Television.create(3,7))

-- Table decoration
add.sink(12,7)
add.oven(13,7)

-- Misc. decorations
add.painting(9,7,5) -- clock
add.painting(11,1,6) -- bathroom mirror
