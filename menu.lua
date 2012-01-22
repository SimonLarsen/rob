Menu = {}
Menu.__index = Menu

function Menu.create(title,names,functions,parent)
	assert(#names == #functions)
	local self = {}
	setmetatable(self,Menu)
	self.title = title
	self.names = names
	self.functions = functions
	self.parent = parent

	self.selected = 1
	self.length = #names
	return self
end

local lg = love.graphics
function Menu:draw()
	lg.setColor(0,0,0,227)
	lg.rectangle("fill",0,0,WIDTH,HEIGHT)
	lg.setColor(255,255,255,255)
	drawTitle(self.title,true)
	lg.push()
	lg.scale(2)
	lg.setFont(serifFont)
	for i = 1,self.length do
		lg.printf(self.names[i],0,40+30*i,WIDTH/2,"center")
		if i == self.selected then
			local selw = serifFont:getWidth(self.names[i])
			lg.drawq(imgSprites,quadMarker,WIDTH/4-selw/2-42,40+30*i,0,1,1,25,0)
			lg.drawq(imgSprites,quadMarker,WIDTH/4+selw/2+36,40+30*i,0,-1,1,25,0)
		end
	end
	lg.pop()
end

function Menu:keypressed(k,uni)
	if k == "up" then
		self.selected = self.selected - 1
		if self.selected <= 0 then self.selected = self.length end
	elseif k == "down" then
		self.selected = self.selected + 1
		if self.selected > self.length then self.selected = 1 end
	elseif k == "return" then
		self.functions[self.selected](self)
	elseif k == "escape" then
		if self.parent ~= nil then
			current_menu = self.parent
		else
			if gamestate == STATE_INGAME_MENU then
				gamestate = STATE_INGAME
			end
		end
	end
end

local parent_function = function(self) current_menu = self.parent end

ingame_menu = Menu.create("Paused",
	{"Resume","Settings","Load level", "Exit game"},
	{function() gamestate = STATE_INGAME end,
	 function() current_menu = settings_menu end,
	 function() current_menu = loadlevel_menu end,
	 function() love.event.push("q") end})

loadlevel_menu = Menu.create("Load level",
	{"Load \"home\"","Load \"test\"","Back"},
	{function() loadMap("home") end, function() loadMap("test") end, parent_function}, ingame_menu)

settings_menu = Menu.create("Settings",
	{"Controls","Volume","Resolution","Back"},
	{function() end, function() end, function() end, parent_function},
	 ingame_menu)
