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
	elseif k == "return" or k == ' ' then
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

function createMenus()
	ingame_menu = Menu.create("Paused",
		{"Resume","Settings","Load level", "Exit game"},
		{function() gamestate = STATE_INGAME end,
		 function() current_menu = settings_menu end,
		 function() current_menu = loadlevel_menu end,
		 function() love.event.push("q") end})

	loadlevel_menu = Menu.create("Load level",
		{"Load \"home\"","Load \"los\"","Back"},
		{function() loadMap("home") end, function() loadMap("los") end,
		parent_function}, ingame_menu)

	settings_menu = Menu.create("Settings",
		{"Controls","Video options","Sound options","Back"},
		{function() end, function() current_menu = resolution_menu end, function() end,
		 parent_function}, ingame_menu)

	local resolution_menu_names, resolution_menu_functions = {}, {}
	local modes = love.graphics.getModes()
	if modes ~= nil then
		table.sort(modes, function(a,b) return a.width*a.height > b.width*b.height end)
		for i = 6,1,-1 do
			if modes[i].width >= 800 and modes[i].height >= 600 then
				table.insert(resolution_menu_names, modes[i].width .. "x" .. modes[i].height)
				local set_res_func = function() WIDTH,HEIGHT = modes[i].width,modes[i].height applyMode() end
				table.insert(resolution_menu_functions, set_res_func)
			end
		end
	end
	table.insert(resolution_menu_names, "Custom resolution")
	table.insert(resolution_menu_functions, function() current_menu = custom_res_menu end)
	table.insert(resolution_menu_names, "Toggle fullscreen")
	table.insert(resolution_menu_functions, function() FULLSCREEN = not FULLSCREEN applyMode() end)
	table.insert(resolution_menu_names, "Back")
	table.insert(resolution_menu_functions, parent_function)
	resolution_menu = Menu.create("Resolution",
	resolution_menu_names, resolution_menu_functions, settings_menu)

	custom_res_menu = Menu.create("Custom resolution",
	{"Width: " .. WIDTH, "Height: " .. HEIGHT, "Apply", "Back"},
	{function(self) self.selected = self.selected+1 end, function(self) self.selected = self.selected+1 end,
	 function(self) WIDTH = self.newwidth HEIGHT = self.newheight applyMode() end,
	 function(self) self.newwidth = WIDTH self.newheight = HEIGHT self:updatenames() parent_function(self) end},
	 resolution_menu)
	custom_res_menu.newwidth  = tostring(WIDTH)
	custom_res_menu.newheight = tostring(HEIGHT)

	custom_res_menu.oldkeypressed = custom_res_menu.keypressed
	function custom_res_menu:keypressed(k,uni)
		if uni >= 48 and uni <= 57 then
			if self.selected == 1 then -- WIDTH selected
				self.newwidth = self.newwidth .. tostring(uni - 48)
				self:updatenames()
			elseif self.selected == 2 then -- HEIGHT selected
				self.newheight = self.newheight .. tostring(uni - 48)
				self:updatenames()
			end
		elseif k == 'backspace' then
			if self.selected == 1 and self.newwidth:len() > 0 then
				self.newwidth = self.newwidth:sub(1,self.newwidth:len()-1)
				self:updatenames()
			elseif self.selected == 2 and self.newheight:len() > 0 then
				self.newheight = self.newheight:sub(1,self.newheight:len()-1)
				self:updatenames()
			end
		elseif k == 'escape' then
			 self.newwidth = WIDTH self.newheight = HEIGHT self:updatenames() parent_function(self)
		else
			self:oldkeypressed(k,uni)
		end
	end
	
	function custom_res_menu:updatenames()
		self.names[1] = "Width: " .. self.newwidth
		self.names[2] = "Height: " .. self.newheight
	end
end
