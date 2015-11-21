coffee = class:new()

function coffee:init()
	self.canvas = love.graphics.newCanvas(500,600)
	self.meter = 1
	self.drainRate = 0.04

	self.clickables = {}

	self.bgPos = -178

	self.hasCup = true
	self.hasPot = false
	self.hasMaker = false

	self.filling = false
	self.fixed = true
	self.fixing = false

	self.clickables.cup = self:newCup(150, 400)
end

function coffee:update(dt)
	self.meter = self.meter - self.drainRate*dt
	if self.meter < 0 then self.meter = 0 end
	self.bgPos = self.bgPos + 100*dt
	if self.bgPos > 0 then self.bgPos = -178 end

	for k, v in pairs(self.clickables) do
		v.update(dt)
	end
end

function coffee:draw()
	love.graphics.setCanvas(self.canvas)
	self.canvas:clear()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(imgMan:getImage('coffee-bg'), 0, self.bgPos)
	for k, v in pairs(self.clickables) do
		v.draw()
	end
	love.graphics.setCanvas()
	love.graphics.draw(self.canvas, 500, 0)
end

function coffee:keypressed(key)

end

function coffee:mousepressed(x, y, b)
	for k, v in pairs(self.clickables) do
		if x-500 > v.x and x-500 < v.x+v.w and y > v.y and y < v.y+v.h then
			v.onClick()
		end
	end
end

function coffee:newClickable(sprite, x, y)
	local clickable = {}

	clickable.x = x
	clickable.y = y
	clickable.sprite = sprite
	clickable.w, clickable.h = sprite:getDimensions()

	function clickable.update(dt)

	end

	function clickable.draw()
		love.graphics.draw(clickable.sprite, clickable.x, clickable.y)
	end

	return clickable
end

function coffee:newCup(x, y)
	local cup = self:newClickable(imgMan:getImage('coffee-cup-3'), 600, 400)
	cup.sipsLeft = 3
	cup.destX = x
	cup.destY = y

	function cup.onClick()
		if math.random() > 0.95 then
			cup.destY = 700
			self.hasCup = false
		elseif cup.sipsLeft >= 1 then
			if cup.sipsLeft == 1 and not self.hasPot then
				self.clickables.pot = self:newPot(20, 200)
				self.hasPot = true
			end
			sfx['gulp']:play()
			self.meter = math.min(self.meter + 0.3, 1)
			cup.sipsLeft = cup.sipsLeft - 1
			cup.sprite = imgMan:getImage('coffee-cup-'..cup.sipsLeft)
		end
	end

	function cup.update(dt)
		cup.x = cup.x - (cup.x - cup.destX)*4*dt
		if cup.y < cup.destY then
			cup.y = cup.y + 1000*dt
			if cup.y > cup.destY then
				sfx['shatter']:play()
				cup.x = 999999999
				cup.y = 400
				cup.destX = 150
				cup.destY = 400
				cup.sipsLeft = 0
				cup.sprite = imgMan:getImage('coffee-cup-'..cup.sipsLeft)

				if not self.hasPot then
					self.clickables.pot = self:newPot(20, 200)
					self.hasPot = true
				end
			end
		end

		if not self.hasCup and cup.x < cup.destX + 100 and cup.y == 400 then
			self.hasCup = true
		end
	end

	return cup
end

function coffee:newPot(x, y)
	local pot = self:newClickable(imgMan:getImage('coffee-pot-2'), 600, 200)
	pot.cupsLeft = 2
	pot.destX = x
	pot.destY = y

	function pot.onClick()
		if pot.cupsLeft >= 1 and self.hasCup and not self.filling then
			if self.clickables.cup.sipsLeft < 3 then
				sfx['pour']:play()
				self.clickables.cup.sipsLeft = 3
				self.clickables.cup.sprite = imgMan:getImage('coffee-cup-3')
				pot.cupsLeft = pot.cupsLeft - 1
				pot.sprite = imgMan:getImage('coffee-pot-'..pot.cupsLeft)
			end
		end
		if pot.cupsLeft == 0 and not self.hasMaker then
			self.clickables.maker = self:newMaker(200, 100)
			self.hasMaker = true
		end
	end

	function pot.update(dt)
		pot.x = pot.x - (pot.x - pot.destX)*4*dt
		pot.y = pot.y - (pot.y - pot.destY)*4*dt

		if pot.y < -400 then
			sfx['shatter']:play()
			pot.y = 200
			pot.x = 999999999
			pot.destY = 200
			pot.destX = 20
			pot.cupsLeft = 0
			pot.sprite = imgMan:getImage('coffee-pot-'..pot.cupsLeft)
		end
	end

	return pot
end

function coffee:newMaker(x, y)
	local maker = self:newClickable(imgMan:getImage('coffee-maker'), 900, 100)
	self.clickables.fixer = self:newFixer()
	maker.destX = x
	maker.destY = y
	maker.fillTimer = 0

	function maker.onClick()
		if self.clickables.pot.cupsLeft < 1 and not self.filling and self.clickables.pot.x < maker.x and not self:overFixer() then
			self.clickables.pot.destX = maker.x + 75
			self.filling = true
			sfx['maker']:play()
			sfx['maker']:setLooping(true)
			maker.fillTimer = 0
		end
	end

	function maker.update(dt)
		maker.x = maker.x - (maker.x - maker.destX)*4*dt

		if self.filling then
			maker.fillTimer = maker.fillTimer + dt
			if maker.fillTimer > 2 then
				if not self.fixed then
					self.clickables.pot.destY = -500
					self.filling = false
					sfx['boing']:play()
					sfx['maker']:stop()
				else
					self.clickables.pot.cupsLeft = self.clickables.pot.cupsLeft + 1
					self.clickables.pot.sprite = imgMan:getImage('coffee-pot-'..self.clickables.pot.cupsLeft)
					maker.fillTimer = 0
				end
			end
			if self.clickables.pot.cupsLeft >= 2 then
				self.clickables.pot.destX = 20
				self.filling = false
				sfx['maker']:stop()
			end
		end
	end

	return maker
end

function coffee:overFixer()
	return love.mouse.getX()-500 > self.clickables.fixer.x and 
	love.mouse.getX()-500 < self.clickables.fixer.x+self.clickables.fixer.w and 
	love.mouse.getY() > self.clickables.fixer.y and 
	love.mouse.getY() < self.clickables.fixer.y+self.clickables.fixer.h
end

function coffee:newFixer()
	local fixer = self:newClickable(imgMan:getImage('maker-fixer'), 500, 0)

	fixer.lights = imgMan:getImage('maker-status-fixed')

	fixer.timer = 0

	function fixer.update(dt)
		fixer.x = self.clickables.maker.x + 200
		fixer.y = self.clickables.maker.y + 30

		fixer.timer = fixer.timer + dt
		if fixer.timer > 1 and self.fixed then
			if math.random() > 0.95 and not self.filling then
				self.fixed = false
				fixer.lights = imgMan:getImage('maker-status-broken')
			end
			fixer.timer = 0
		end
		self.fixing = false
	end

	function fixer.onClick()
		if not self.filling then
			self.fixed = true
			sfx['ding']:play()
			fixer.lights = imgMan:getImage('maker-status-fixed')
			self.fixing = true
		end
	end

	function fixer.draw()
		love.graphics.draw(fixer.sprite, fixer.x, fixer.y)
		love.graphics.draw(fixer.lights, fixer.x - 150, fixer.y)
	end
	
	return fixer

end