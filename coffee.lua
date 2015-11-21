coffee = class:new()

function coffee:init()
	self.canvas = love.graphics.newCanvas(500,600)
	self.meter = 1
	self.drainRate = 0.04
	self.sipsLeft = 3

	self.clickables = {}

	self.bgPos = -178

	self.hasPot = false
	self.hasMaker = false

	self.filling = false
	self.fillTimer = 0

	self.clickables.cup = self:newCup(150, 400)
end

function coffee:update(dt)
	self.meter = self.meter - self.drainRate*dt
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
	love.graphics.rectangle("fill",10,10,self.meter*400,100)
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
		if math.random() > 0.90 then
			cup.destY = 700
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
	end

	return cup
end

function coffee:newPot(x, y)
	local pot = self:newClickable(imgMan:getImage('coffee-pot-2'), 600, 200)
	pot.cupsLeft = 2
	pot.destX = x
	pot.destY = y

	function pot.onClick()
		if pot.cupsLeft >= 1 then
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
	end

	return pot
end

function coffee:newMaker(x, y)
	local maker = self:newClickable(imgMan:getImage('coffee-maker'), 900, 100)
	maker.fixed = true
	maker.destX = x
	maker.destY = y

	function maker.onClick()
		if self.clickables.pot.cupsLeft < 2 then
			self.clickables.pot.destX = maker.x + 75
			self.filling = true
			self.fillTimer = 0
		end
	end

	function maker.update(dt)
		maker.x = maker.x - (maker.x - maker.destX)*4*dt

		if self.filling then
			self.fillTimer = self.fillTimer + dt
			if self.fillTimer > 2 then
				self.clickables.pot.cupsLeft = self.clickables.pot.cupsLeft + 1
				self.clickables.pot.sprite = imgMan:getImage('coffee-pot-'..self.clickables.pot.cupsLeft)
				self.fillTimer = 0
			end
			if self.clickables.pot.cupsLeft >= 2 then
				self.clickables.pot.destX = 20
				self.filling = false
			end
		end
	end

	return maker
end