strategy = class:new()

function strategy:init(parent)

	self.parent = parent

	self.cursor = cursor:new({x=200,y=300,img="dot"})

	local options = {"map1", "map2", "map3"}

	if currentLevel >= 2 then
		options = {"map2", "map3"}
	else
		options = {"map1"}
	end
	self:getThing(randomSelect(options))

	self.state = "wait"

	self.path = {}
	self.pathTimer = 0.1

	self.finished = false
	self.headline = "MILITARY GETS NOTHING DONE"
	self.subtitle = "ORDERED TO WANDER AROUND IN CIRCLES FOR HOURS"

end

function strategy:getThing(thing)

	self.map = {img=imgMan:getImage(thing), x=-500, y=0}
	self.mask = love.image.newImageData("img/"..thing.."-mask.png")
	if thing == "map1" then
		self.cursor.phys:setPos(300-self.cursor.phys.w/2,477-self.cursor.phys.h/2)
		self.winHeadline = "CRUSHING MILITARY SUCCESS"
		self.winSubtitle = "GENERAL: 'THE KEY TO OUR VICTORY WAS WALKING AROUND THE OCEAN'"
	end
	if thing == "map2" then
		self.cursor.phys:setPos(92-self.cursor.phys.w/2,430-self.cursor.phys.h/2)
		self.winHeadline = "ARMY TAKES PENINSULA"
		self.winSubtitle = "GENERAL: 'IT WAS TOUGH, BUT WE MANAGED TO AVOID STUMBLING HEADLONG INTO THE WATER'"
	end
	if thing == "map3" then
		self.cursor.phys:setPos(61-self.cursor.phys.w/2,300-self.cursor.phys.h/2)
		self.winHeadline = "ARMY CORRECTLY IDENTIFIES TARGET"
		self.winSubtitle = "GENERAL: 'NO, WE DON'T MEAN THE STORE'"
	end

end

function strategy:update(dt)

	--debug(love.mouse.getX() .. ", " .. love.mouse.getY())

	if self.cursor ~= nil and not self.finished then
		self.cursor.wobble = self.parent.wobble*0.67
		self.cursor:update(dt)
	end

	self.map.x = self.map.x - (self.map.x - 0)*7*dt

	if not self.finished then
		self.pathTimer = self.pathTimer - dt
		if self.pathTimer <= 0 then
			self.pathTimer = 0.2
			local phys = self.cursor.phys
			self:addPoint(phys.x+phys.w/2, phys.y+phys.h/2)
		end
	end

end

function strategy:addPoint(x, y)
	self.path[#self.path+1] = {x, y, true}
	x = math.floor(x)
	y = math.floor(y)
	local r = 12; local g = 12; local b = 12
	if x > 0 and x < 500 and y > 0 and y < 600 then
		r, g, b = self.mask:getPixel(x,y)
		if r==0 and g==0 and b==0 then
			self.state = "lose"
			self.headline = "THOUSANDS OF SOLDIERS DROWN"
			self.subtitle = "BRAVELY GAVE THEIR LIVES WHEN ORDERED TO MARCH STRAIGHT INTO THE WATER"
			self:finish()
		end
		if r==255 and g==0 and b==255 then
			self.state = "lose"
			self.headline = "ENTIRE US MILITARY LOST"
			self.subtitle = "'THEY WALKED OFF THE EDGE OF THE MAP' SAYS PRESIDENT"
			self:finish()
		end
		if r==255 and g==0 and b==0 then
			self.state = "win"
			self.headline = self.winHeadline
			self.subtitle = self.winSubtitle
			self:finish()
		end
	else
		self.state = "lose"
		self.headline = "ENTIRE US MILITARY LOST"
		self.subtitle = "'THEY WALKED OFF THE EDGE OF THE MAP' SAYS PRESIDENT"
		self:finish()
	end
	
end

function strategy:draw()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(imgMan:getImage('desk'), 0, 0)

	love.graphics.draw(self.map.img, self.map.x, self.map.y)

	local r = 255; local g = 255; local b = 255
	local x = 100; local y = 550
	local str = ""

--	if self.state == "win" then
--		r=0; g=255; b=0
--		str = self.winString
--	end
--	if self.state == "lose" then
--		r=255; g=0; b=0
--		str = self.loseString
--	end

	love.graphics.setColor(r,g,b)
	love.graphics.printf(str, x, y, 300, "center")

	for i,pt in ipairs(self.path) do
		love.graphics.draw(imgMan:getImage("dot"), pt[1]-2, pt[2]-2)
	end

	--cursor
	if self.cursor ~= nil then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(imgMan:getImage("dot"), self.cursor.phys.x+self.cursor.phys.w/2, self.cursor.phys.y+self.cursor.phys.h/2)
	end

end

function strategy:keypressed(key)
	if input:keyIs("interact", key) and not self.finished then

	end
end

function strategy:finish()
	self.finished = true
	self.cursor.img = self.cursor:addComponent(image:new("check"))
end