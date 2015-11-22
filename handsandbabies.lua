handsAndBabies = class:new()

function handsAndBabies:init(parent)

	self.parent = parent

	self.state = "wait"

	self.finished = false
	self.headline = "PRES REFUSES TO SHAKE HANDS"
	self.subtitle = "IS HE RACIST?"

	self.pres = {}
	self.pres.ar = 0 -- arm rotation
	self.pres.tr = 0 -- torso rotation
	self.pres.arl = 0 -- local arm rotation
	self.pres.ard = 0 -- arm rotation destination
	self.pres.trd = 0 --torso rotation destination

	self.shaking = false
	self.leaning = false

	self.betweenShakers = false

	self.shakerSays = ''

	if currentLevel >= 3 then
		local str = 'abcdefghijklmnopqrstuvwxyz1234567890'	
		local pos = math.random(str:len())
		self.shakeKey = str:sub(pos,pos)
		while str:sub(pos, pos) == self.shakeKey do 
			pos = math.random(str:len())
		end
		self.leanKey = str:sub(pos, pos)
	else
		self.shakeKey = math.random(2)
		self.leanKey = ''..(3 - self.shakeKey)
		self.shakeKey = self.shakeKey..''
	end

	self.positions = {-120, 50, 220, 800, 800, 800}
	if currentLevel >= 2 then
		self.types = {'adult', 'child'}
	else
		self.types = {'adult'}
	end
	self.currentShaker = 3

	self.queue = {}
	for i = 1, 3 do
		self.queue[i] = self:newShaker(self.types[math.random(#self.types)], self.positions[i], i)
	end
end

function handsAndBabies:keypressed(key)
end

function handsAndBabies:update(dt)
	if love.keyboard.isDown(self.shakeKey) then
		self.pres.ard = math.pi/2
	else
		self.pres.ard = 0
	end

	if self.pres.arl > math.pi/3 then
		self.shaking = true
	else
		self.shaking = false
	end

	if love.keyboard.isDown(self.leanKey) and not self.finished then
		self.pres.trd = -math.pi/5
	else
		self.pres.trd = 0
	end

	if self.pres.tr < -math.pi/7 then
		self.leaning = true
	else
		self.leaning = false
	end 

	self.pres.arl = self.pres.arl + (self.pres.ard - self.pres.arl)*20*dt
	self.pres.tr = self.pres.tr + (self.pres.trd - self.pres.tr)*20*dt
	self.pres.ar = self.pres.tr + self.pres.arl

	if not self.betweenShakers and not self.finished then
		if self.queue[self.currentShaker].type == 'child' then
			if self.leaning and self.shaking then
				self.shakerSays = '"I want to be just like you!"'
				sfx['child']:play()
				self:continue()
			elseif self.shaking and not self.leaning then
				sfx['slap']:play()
				self.shakerSays = '*crying*'
				self.headline = "PRESIDENT SLAPS INNOCENT CHILD"
				self.subtitle = '"HE SHOULD HAVE LEANED DOWN FIRST", SAYS CONCERNED MOTHER.'
				self:fail()
			end
		else
			if self.shaking and not self.leaning then
				self.shakerSays = '"Good speech, Mr. President"'
				sfx['hmm-'..math.random(3)]:play()
				self:continue()
			elseif self.leaning then
				sfx['slap']:play()
				self.shakerSays = '"Why, Mr. President? Why?"'
				self.headline = "PRESIDENT HEAD- BUTTS CITIZEN"
				self.subtitle = "IS HE STARTING A WAR ON FOREHEADS?"
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

	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(imgMan:getImage('handshake-bg'), 0, 0)

	love.graphics.setFont(mono)
	love.graphics.print(self.shakerSays, 20, 120)
	

	love.graphics.print(self.shakeKey..': Shake hand\n'..self.leanKey..': Lean down', 20, 50)
	love.graphics.draw(imgMan:getImage('pres-legs'), 350, 350)
	love.graphics.draw(imgMan:getImage('pres-torso'), 390, 380, self.pres.tr, 1, 1, 37, 213)
	love.graphics.draw(imgMan:getImage('pres-arm'), 390 + math.sin(self.pres.tr)*120, 360 - math.cos(self.pres.tr)*100, self.pres.ar, 1, 1, 15, 15)

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
		self.subtitle = "BUT NOT IN, LIKE, A JAZZ HANDS WAY."
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
		shaker.y = 190
		shaker.sprite = imgMan:getImage('handshaker')
	elseif type == 'child' then
		shaker.y = 290
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