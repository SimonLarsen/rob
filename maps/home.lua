p1start = {6*16+8, 2*8+4}
p2start = {7*16+8, 2*8+4}

-- Doors
table.insert(entities[4],Door.create(4,4,"left"))
table.insert(entities[4],Door.create(9,4,"right"))
table.insert(entities[6],Door.create(7,6,"vert"))
table.insert(entities[10],Door.create(10,10,"right"))

-- Furniture
table.insert(entities[11],Sofa.create(2,11,"back"))
table.insert(entities[7],Fridge.create(11,7))
table.insert(entities[1],Closet.create(1,1))
table.insert(entities[1],Bed.create(2,1))
table.insert(entities[1],Toilet.create(14,1,"skinpoo"))
table.insert(entities[1],Shower.create(13,1))
table.insert(entities[7],RecordPlayer.create(1,7))
table.insert(entities[7],Television.create(3,7))

-- Table decoration
table.insert(entities[7],TableDecor.create(12,7,0))
table.insert(entities[7],TableDecor.create(13,7,7))

-- Misc. decorations
table.insert(entities[7],Painting.create(9,7,5)) -- clock
table.insert(entities[1],Painting.create(11,1,6)) -- bathroom mirror/sink
