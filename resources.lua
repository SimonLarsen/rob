swearwords = {"Poppycock", "Whippersnapper", "Scallywag", "Wallydrag", "Mollygrub", "Tattlebasket", "Nincompoop", "Flimflammery", "Ragamuffin", "Dagnabbit", "Bugger"}

skins = {"default", "naked", "blackmetal"}

local lg = love.graphics

function loadResources()
	createMaplist()
	loadImages()
	loadSounds()
	createQuads()
	createMenus()
end

function loadImages()
	imgTiles = 	lg.newImage("res/tiles.png")
	imgTiles:setFilter("nearest","nearest")

	imgSprites = lg.newImage("res/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	imgLight = lg.newImage("res/lightbig.png")
	imgLight:setFilter("nearest","nearest")

	imgMainMenu = lg.newImage("res/title.png")
	imgMainMenu:setFilter("nearest","nearest")

	imgSkins = {}
	imgSkinPreviews = {}
	for i=1,#skins do
		imgSkins[i] = lg.newImage("res/skins/"..skins[i]..".png")
		imgSkins[i]:setFilter("nearest","nearest")

		imgSkinPreviews[i] = lg.newImage("res/skins/"..skins[i].."-preview.png")
		imgSkinPreviews[i]:setFilter("nearest","nearest")
	end

	sansFontImage = lg.newImage("res/font-white-big.png")
	sansFontImage:setFilter("nearest","nearest")
	sansFont = lg.newImageFont(sansFontImage," 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!-.,$%")

	serifFontImage = lg.newImage("res/font-serif.png")
	serifFontImage:setFilter("nearest","nearest")
	serifFont = lg.newImageFont(serifFontImage," 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!-.,$\":_-/")
	lg.setFont(sansFont)

	print("Images loaded...")
end

function createQuads()
	local tilew,tileh = imgTiles:getWidth(), imgTiles:getHeight()
	local sprw, sprh = imgSprites:getWidth(), imgSprites:getHeight()
	local skinw, skinh = 256,256

	quadTiles = {}
	for ix = 0,15 do
		quadTiles[ix] = lg.newQuad(ix*CELLW,0,CELLW,CELLH,tilew,tileh)
	end

	quadWall = {}
	quadWall[0] = lg.newQuad(0, 128, 8, 32, tilew, tileh)
	quadWall[1] = lg.newQuad(4, 128, 8, 32, tilew, tileh)
	quadWall[2] = lg.newQuad(8, 128, 8, 32, tilew, tileh)
	quadWindowWall = lg.newQuad(48,16,16,32,tilew,tileh)

	quadHerbie = {}
	quadJamal = {}
	for i=0,5 do
		quadHerbie[i] = lg.newQuad(i*16,0,14,21,sprw,sprh)
		quadJamal[i] = lg.newQuad(80+i*16,0,11,27,sprw,sprh)
	end
	-- Jamal vent animations
	quadJamalIntoVentSide = {}
	quadJamalIntoVentFront = {}
	quadJamalOutVentSide = {}
	quadJamalOutVentFront = {}
	for i = 0,7 do
		quadJamalIntoVentSide[i] = lg.newQuad(i*16,32,16,27,sprw,sprh)
		quadJamalOutVentSide[i] = lg.newQuad(128+i*16,32,16,27,sprw,sprh)
		quadJamalOutVentFront[i] = lg.newQuad(128+i*16,64,16,30,sprw,sprh)
		quadJamalIntoVentFront[i] = lg.newQuad(i*16,64,16,30,sprw,sprh)
	end
	-- Herbie roll animations
	quadHerbieRollSide = {}
	quadHerbieRollFront = {}
	quadHerbieRollBack = {}
	for i=0,11 do
		quadHerbieRollSide[i] = lg.newQuad(i*15,96,15,20,sprw,sprh)
		quadHerbieRollFront[i] = lg.newQuad(i*14,128,14,20,sprw,sprh)
		quadHerbieRollBack[i] = lg.newQuad(i*14,160,14,20,sprw,sprh)
	end
	-- Falling animations
	quadHerbieFall = {}
	quadJamalFall = {}
	for i=0,17 do
		quadHerbieFall[i] = lg.newQuad(i*14,224,14,23,sprw,sprh)
		quadJamalFall[i] = lg.newQuad(i*13,192,13,29,sprw,sprh)
	end

	-- robot
	quadRobot = {}
	for i=0,11 do
		quadRobot[i] = lg.newQuad(i*16,0,11,32,sprw,sprh)
	end
	quadRobotBlink = {}
	for i=0,11 do
		quadRobotBlink[i] = lg.newQuad(i*15,97,15,22,sprw,sprh)
	end
	quadRotRobotBody = {}
	for i=0,11 do
		quadRotRobotBody[i] = lg.newQuad(i*16,48,11,14,sprw,sprh)
	end
	quadRotRobotHead = {}
	for i=0,15 do
		quadRotRobotHead[i] = lg.newQuad(i*16,73,15,23,sprw,sprh)
	end

	-- entity quads
	quadDoorClosed   = lg.newQuad(16,128,16,32,tilew,tileh)
	quadDoorOpen     = lg.newQuad(44,132,4,28,tilew,tileh)
	quadDoorGradient = lg.newQuad(33,168,3,8,tilew,tileh)

	quadGlassDoorClosed   = lg.newQuad(96,80,16,32,tilew,tileh)
	quadGlassDoorOpen     = lg.newQuad(124,82,4,28,tilew,tileh)

	quadSafeClosed   = lg.newQuad(48,128,16,24,tilew,tileh)
	quadSafeOpen     = lg.newQuad(64,128,16,24,tilew,tileh)

	quadCabinet      = lg.newQuad(0,48,32,24,tilew,tileh)
	quadCabinetOpen  = lg.newQuad(32,48,32,27,tilew,tileh)

	quadLockerFront  = lg.newQuad(80,48,14,49,tilew,tileh)
	quadLockerFrontDoor = lg.newQuad(94,48,13,27,tilew,tileh)
	quadLockerSide   = lg.newQuad(107,48,12,32,tilew,tileh)
	quadLockerSideDoor = lg.newQuad(119,49,8,24,tilew,tileh)

	quadFridgeClosed = lg.newQuad(96,128,16,32,tilew,tileh)
	quadFridgeOpen   = lg.newQuad(112,128,16,35,tilew,tileh)

	quadCloset       = lg.newQuad(64,48,16,31,tilew,tileh)

	quadWatercooler  = lg.newQuad(48,152,11,24,tilew,tileh)

	quadCrate        = lg.newQuad( 0, 16,16,24,tilew,tileh)

	quadVentFront    = lg.newQuad(32,160,16, 8,tilew,tileh)
	quadVentSide     = lg.newQuad(32,169,7,6,tilew,tileh)

	quadSofaFront    = lg.newQuad(128,128,32,19,tilew,tileh)
	quadSofaBack     = lg.newQuad(128,147,32,17,tilew,tileh)

	quadBed          = lg.newQuad(160,128,32,25,tilew,tileh)

	quadToiletOpen   = lg.newQuad(64,158,7,18,tilew,tileh)
	quadToiletClosed = lg.newQuad(72,158,7,18,tilew,tileh)

	quadStallOpen    = lg.newQuad(176,48,16,34,tilew,tileh)
	quadStallClosed  = lg.newQuad(192,48,16,31,tilew,tileh)

	quadRecordPlayer = lg.newQuad(128,48,16,25,tilew,tileh)

	quadShower       = lg.newQuad(144,48,16,32,tilew,tileh)

	quadEntrance     = lg.newQuad(160,88,34,40,tilew,tileh)

	quadTelephone    = lg.newQuad(160,156,10,12,tilew,tileh)

	quadBossDeskFront= lg.newQuad(80,19,48,28,tilew,tileh)
	quadBossDeskBack = lg.newQuad(128,16,48,22,tilew,tileh)

	quadPressurePlateUp = lg.newQuad(176,160,10,7,tilew,tileh)
	quadPressurePlateDown = lg.newQuad(176,167,10,7,tilew,tileh)

	quadSwitchFront = lg.newQuad(192,160,7,8,tilew,tileh)
	quadSwitchFrontHandle = lg.newQuad(200,160,3,4,tilew,tileh)
	quadSwitchSide  = lg.newQuad(192,168,1,8,tilew,tileh)
	quadSwitchSideHandle = lg.newQuad(193,171,3,3,tilew,tileh)

	quadTable = {}
	quadTable[0]     = lg.newQuad(16,16,16,17,tilew,tileh)
	quadTable[1]     = lg.newQuad(24,16,16,17,tilew,tileh)

	quadKitchenTableLined = lg.newQuad(80,128,8,24,tilew,tileh)
	quadKitchenTableNoLine = lg.newQuad(88,128,8,24,tilew,tileh)

	quadTelevision  = lg.newQuad(80,156,16,20,tilew,tileh)

	quadSign = lg.newQuad(161,69,12,14,tilew,tileh)

	quadProjectorImage = {}
	for i=0,2 do
		quadProjectorImage[i] = lg.newQuad(i*27,237,27,19,tilew,tileh)
	end
	quadProjector    = lg.newQuad(160,48,12,20,tilew,tileh)

	quadTVFrames = {}
	quadTVFrames[0] = lg.newQuad(96,163,6,5,tilew,tileh)
	for i=0,6 do
		quadTVFrames[i+1] = lg.newQuad(96+i*7,171,6,5,tilew,tileh)
	end

	quadPainting = {}
	for i = 0,9 do
		quadPainting[i] = lg.newQuad(i*16,176,16,16,tilew,tileh)
	end

	quadTableDecor = {}
	for i = 0,8 do
		quadTableDecor[i] = lg.newQuad(i*16,208,16,24,tilew,tileh)
	end

	quadPlant = {}
	for i = 0,2 do
		quadPlant[i] = lg.newQuad(i*16,96,16,24,tilew,tileh)
	end
	-- camera quads
	quadCameraSide = lg.newQuad(0,200,9,7,tilew,tileh)
	quadCameraSideShadow = lg.newQuad(9,200,8,3,tilew,tileh)
	quadCameraDown = lg.newQuad(17,200,3,8,tilew,tileh)
	quadCameraDownShadow = lg.newQuad(20,200,3,6,tilew,tileh)
	quadCameraDown = lg.newQuad(17,200,3,8,tilew,tileh)
	quadCameraUp = lg.newQuad(23,200,3,8,tilew,tileh)

	-- laser quads
	quadLaserStartVert = lg.newQuad(176,16,9,24,tilew,tileh)
	quadLaserVert = lg.newQuad(192,16,7,23,tilew,tileh)
	quadLaserSide = lg.newQuad(208,17,16,19,tilew,tileh)
	quadLaserStartSide = lg.newQuad(206,16,2,21,tilew,tileh)

	-- action quads
	quadAction = {}
	for i = 1,6 do
		quadAction[i] = lg.newQuad((i-1)*16,32,9,9,sprw,sprh)
	end
	quadActionDisabled = lg.newQuad(112,32,9,9,sprw,sprh)

	-- big skin previews and menu stuff
	quadSkinJamal  = lg.newQuad(0,0,128,256,256,256)
	quadSkinHerbie = lg.newQuad(128,0,128,256,256,256)
	quadTriangle   = lg.newQuad(224,0,15,29,sprw,sprh)
	quadMarker     = lg.newQuad(206,32,50,20,sprw,sprh)
	quadMainMenu   = lg.newQuad(0,0,432,339,512,512)

	print("Quads created...")
end

local ls = love.sound
function loadSounds()
	TEsound.volume("music",0.5)
	TEsound.volume("sfx",0.75)

	sndAlarm = ls.newSoundData("res/sfx/alarm.wav")
	sndDoor  = ls.newSoundData("res/sfx/door.wav")
end

local lastswear = -1
function getSwearword()
	local w = lastswear
	while w == lastswear do w = math.random(1,#swearwords) end
	lastswear = w
	return swearwords[w]
end
