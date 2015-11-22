handsAndBabies = class:new()

function handsAndBabies:init(parent)

	self.parent = parent

	self.state = "wait"

	self.finished = false
	self.headline = "PRES REFUSES TO SHAKE HANDS"
	self.subtitle = "Is he racist?"

	self.pres = {}
	self.pres.ar = 0 -- arm rotation
	self.pres.tr = 0 -- torso rotation
	self.pres.arl = 0 -- local arm rotation
	self.pres.ard = 0 -- arm rotation destination
	self.pres.trd = 0 --torso rotation destination

	self.shaking = false
	self.leaning = false

	self.betweenShakers = false

	self.shakeKey = '1'
	self.leanKey = '2'

	self.positions = {-250, -50, 150, 800, 800, 800}
	self.types = {'adult', 'child'}
	self.currentShaker = 3

	self.queue = {}
	for i = 1, 3 do
		self.queue[i] = self:newShaker(self.types[math.random(2)], self.positions[i], i)
	end
end

function handsAndBabies:keypressed(key)
end

function handsAndBabies:update(dt)
	if love.keyboard.isDown(self.shakeKey) then
		self.pres.ard = math.pi/2
		self.shaking = true
	else
		self.pres.ard = 0
		self.shaking = false
	end

	if love.keyboard.isDown(self.leanKey) then
		self.pres.trd = -math.pi/5
		self.leaning = true
	else
		self.pres.trd = 0
		self.leaning = false
	end

	self.pres.arl = self.pres.arl + (self.pres.ard - self.pres.arl)*10*dt
	self.pres.tr = self.pres.tr + (self.pres.trd - self.pres.tr)*10*dt
	self.pres.ar = self.pres.tr + self.pres.arl

	if not self.betweenShakers and not self.finished then
		if self.queue[self.currentShaker].type == 'child' then
			if self.leaning and self.shaking then
				self:continue()
			elseif self.shaking and not self.leaning then
				self.headline = "PRESIDENT SLAPS INNOCENT CHILD"
				self.subtitle = '"I didn\'t think he had it in him", says concerned mother.'
				self:fail()
			end
		else
			if self.shaking and not self.leaning then
				self:continue()
			elseif self.leaning then
				self.headline = "PRESIDENT HEAD- BUTTS CITIZEN"
				self.subtitle = "Is he starting a War On Foreheads?"
				self:fail()
			end
		end
	end

	for i, v in ipairs(self.queue) do
		v.update(dt)
	end
end

function handsAndBabies:fail()
	self.state = 'lose'
	self.finished = true
end

function handsAndBabies:draw()

	love.graphics.setColor(50,35,0)
	love.graphics.rectangle("fill", 0, 0, 500, 600)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(imgMan:getImage('pres-legs'), 350, 350)
	love.graphics.draw(imgMan:getImage('pres-torso'), 390, 350, self.pres.tr, 1, 1, 40, 160)
	love.graphics.draw(imgMan:getImage('pres-arm'), 380 + math.sin(self.pres.tr)*50, 360 - math.cos(self.pres.tr)*60, self.pres.ar, 1, 1, 15, 15)

	for i, v in ipairs(self.queue) do
		love.graphics.draw(v.sprite, v.x, v.y)
	end
end

function handsAndBabies:continue()
	self.queue[self.currentShaker].done = true
	self.currentShaker = self.currentShaker - 1
	for i, v in ipairs(self.queue) do
		v.position = v.position + 1
		v.destX = self.positions[v.position]
	end
	self.betweenShakers = true
	if self.currentShaker == 0 then
		self.headline = "PRESIDENT SHAKES HANDS"
		self.subtitle = "But not in, like, a jazz hands way."
		self.state = "win"
		self.finished = true
	end
end

function handsAndBabies:newShaker(type, x, position)
	local shaker = {}
	shaker.x = x
	shaker.destX = x
	shaker.type = type
	shaker.done = false
	shaker.position = position
	if type == 'adult' then
		shaker.y = 200
		shaker.sprite = imgMan:getImage('handshaker')
	elseif type == 'child' then
		shaker.y = 300
		shaker.sprite = imgMan:getImage('handshaker-child')
	end

	function shaker.update(dt)
		shaker.x = shaker.x + (shaker.destX - shaker.x)*4*dt
		if self.betweenShakers and not shaker.done and shaker.x > self.positions[3] - 10 then
			self.betweenShakers = false
		end
	end

	function shaker.move()
	end

	return shaker
end