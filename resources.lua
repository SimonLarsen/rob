swearwords = {"Poppycock", "Whippersnapper", "Scallywag", "Wallydrag", "Mollygrub", "Tattlebasket", "Nincompoop", "Flimflammery", "Ragamuffin", "Dagnabbit", "Bugger"}

skins = {"default", "naked", "blackmetal"}

local lg = love.graphics

function loadImages()
	imgTiles = 	lg.newImage("res/tiles.png")
	imgTiles:setFilter("nearest","nearest")

	imgSprites = lg.newImage("res/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	imgLight = lg.newImage("res/lightbig.png")
	imgLight:setFilter("nearest","nearest")

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
	serifFont = lg.newImageFont(serifFontImage," 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!-.,$")
	lg.setFont(sansFont)
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

	quadHerbie = {}
	quadJamal = {}
	for i=0,5 do
		quadHerbie[i] = lg.newQuad(i*16,0,14,21,sprw,sprh)
		quadJamal[i] = lg.newQuad(80+i*16,0,11,27,sprw,sprh)
	end
	-- vent animations
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
	-- robot
	quadRobot = {}
	for i=0,11 do
		quadRobot[i] = lg.newQuad(i*16,0,11,32,sprw,sprh)
	end

	-- entity quads
	quadDoorOpen     = lg.newQuad(44,132,4,28,tilew,tileh)
	quadDoorClosed   = lg.newQuad(16,128,16,32,tilew,tileh)
	quadSafeClosed   = lg.newQuad(48,128,16,24,tilew,tileh)
	quadSafeOpen     = lg.newQuad(64,128,16,24,tilew,tileh)
	quadCabinet      = lg.newQuad(0,48,32,24,tilew,tileh)
	quadCabinetOpen  = lg.newQuad(32,48,32,27,tilew,tileh)
	quadLocker       = lg.newQuad(80,48,32,32,tilew,tileh)
	quadLockerDoor   = lg.newQuad(112,48,12,29,tilew,tileh)
	quadFridgeClosed = lg.newQuad(96,128,16,32,tilew,tileh)
	quadFridgeOpen   = lg.newQuad(112,128,16,35,tilew,tileh)
	quadCloset       = lg.newQuad(64,48,16,31,tilew,tileh)
	quadWatercooler  = lg.newQuad(48,152,11,24,tilew,tileh)
	quadCrate        = lg.newQuad( 0, 16,16,24,tilew,tileh)
	quadVentFront    = lg.newQuad(32,160,16, 8,tilew,tileh)
	quadVentSide     = lg.newQuad(32,168,16, 8,tilew,tileh)
	quadSofaFront    = lg.newQuad(128,128,32,19,tilew,tileh)
	quadSofaBack     = lg.newQuad(128,147,32,17,tilew,tileh)
	quadBed          = lg.newQuad(160,128,32,25,tilew,tileh)
	quadToiletOpen   = lg.newQuad(64,158,7,18,tilew,tileh)
	quadToiletClosed = lg.newQuad(72,158,7,18,tilew,tileh)
	quadRecordPlayer = lg.newQuad(128,48,16,25,tilew,tileh)
	quadShower       = lg.newQuad(144,48,16,32,tilew,tileh)
	quadEntrance     = lg.newQuad(160,88,34,40,tilew,tileh)
	quadTelephone    = lg.newQuad(160,156,10,12,tilew,tileh)
	quadPressurePlateUp = lg.newQuad(176,160,10,7,tilew,tileh)
	quadPressurePlateDown = lg.newQuad(176,167,10,7,tilew,tileh)
	quadTable = {}
	quadTable[0]     = lg.newQuad(16,16,16,17,tilew,tileh)
	quadTable[1]     = lg.newQuad(24,16,16,17,tilew,tileh)
	quadKitchenTableLined = lg.newQuad(80,128,8,24,tilew,tileh)
	quadKitchenTableNoLine = lg.newQuad(88,128,8,24,tilew,tileh)
	quadTelevision  = lg.newQuad(80,156,16,20,tilew,tileh)

	quadTVFrames = {}
	quadTVFrames[0] = lg.newQuad(96,163,6,5,tilew,tileh)
	for i=0,6 do
		quadTVFrames[i+1] = lg.newQuad(96+i*7,171,6,5,tilew,tileh)
	end

	quadPainting = {}
	for i = 0,6 do
		quadPainting[i] = lg.newQuad(i*16,176,16,16,tilew,tileh)
	end
	quadTableDecor = {}
	for i = 0,7 do
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

	-- action quads
	quadAction = {}
	for i = 1,5 do
		quadAction[i] = lg.newQuad((i-1)*16,32,9,9,sprw,sprh)
	end

	-- big skin previews
	quadSkinJamal  = lg.newQuad(0,0,128,256,256,256)
	quadSkinHerbie = lg.newQuad(128,0,128,256,256,256)
	quadTriangle   = lg.newQuad(224,0,15,29,sprw,sprh)
end
