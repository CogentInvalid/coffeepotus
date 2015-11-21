handsAndBabies = class:new()

function handsAndBabies:init(parent)

	self.parent = parent

	self.state = "wait"

	self.finished = false
	self.headline = "PRESIDENT HATES BABIES"
	self.subtitle = "ALSO HANDSHAKES"

	self.pres = {}
	self.pres.ar = 0 -- arm rotation
	self.pres.tr = 0 -- torso rotation
	self.pres.arl = 0 -- local arm rotation
end

function handsAndBabies:keypressed(key)
end

function handsAndBabies:update(dt)
	if love.keyboard.isDown('w') then
		self.pres.arl = self.pres.arl + math.pi*dt
	end
	if love.keyboard.isDown('s') then
		self.pres.arl = self.pres.arl - math.pi*dt
	end
	if love.keyboard.isDown('d') then
		self.pres.tr = self.pres.tr + math.pi*dt
	end
	if love.keyboard.isDown('a') then
		self.pres.tr = self.pres.tr - math.pi*dt
	end
	self.pres.ar = self.pres.tr + self.pres.arl
end

function handsAndBabies:draw()

	love.graphics.setColor(50,35,0)
	love.graphics.rectangle("fill", 0, 0, 500, 600)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(imgMan:getImage('pres-legs'), 350, 350)
	love.graphics.draw(imgMan:getImage('pres-torso'), 390, 350, self.pres.tr, 1, 1, 40, 160)
	love.graphics.draw(imgMan:getImage('pres-arm'), 380 + math.sin(self.pres.tr)*50, 360 - math.cos(self.pres.tr)*60, self.pres.ar, 1, 1, 15, 15)
end

function handsAndBabies:finish()
	self.finished = true
end