p1start = {7, 2}
p2start = {8, 2}

-- special items
add("entrance",7,1)
add("telephone",9,1)

-- Doors
add("door",5,2,"left")
add("door",10,2,"right")
add("door",7,6,"vert")
add("door",10,10,"right")

-- Furniture
add("sofa",2,11,"back")
add("fridge",11,7, function() unlockSkin("blackmetal") end)
add("closet",1,1)
add("bed",3,1)

add("toilet",14,1, function() addMessage("You found a poo!") end)

add("shower",13,1)
add("recordplayer",1,7)
add("television",3,7)

-- Table decoration
add("sink",12,7)
add("oven",13,7)

-- Misc. decorations
add("painting",9,7,5) -- clock
add("painting",11,1,6) -- bathroom mirror
add("projector",5,11)
