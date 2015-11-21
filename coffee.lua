coffee = class:new()

function coffee:init()
	self.canvas = love.graphics.newCanvas(500,600)
	self.meter = 1
	self.drainRate = 0.04
	self.sipsLeft = 3

	self.clickables = {}

	table.insert(self.clickables, self:newCup(100, 400))
end

function coffee:update(dt)
	self.meter = self.meter - self.drainRate*dt
end

function coffee:draw()
	love.graphics.setCanvas(self.canvas)
	self.canvas:clear()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(imgMan:getImage('coffee-bg'), 0, 0)
	for i, v in ipairs(self.clickables) do
		love.graphics.draw(v.sprite, v.x, v.y)
	end
	love.graphics.rectangle("fill",10,10,self.meter*400,100)
	love.graphics.setCanvas()
	love.graphics.draw(self.canvas, 500, 0)
	debug(love.mouse.getX()..', '..love.mouse.getY())
end

function coffee:keypressed(key)

end

function coffee:mousepressed(x, y, b)
	for i, v in ipairs(self.clickables) do
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

	return clickable
end

function coffee:newCup(x, y)
	local cup = self:newClickable(imgMan:getImage('coffee-cup-3'), x, y)
	cup.sipsLeft = 3

	function cup.onClick()
		if cup.sipsLeft >= 1 then
			self.meter = math.min(self.meter + 0.3, 1)
			cup.sipsLeft = cup.sipsLeft - 1
			cup.sprite = imgMan:getImage('coffee-cup-'..cup.sipsLeft)
		end
	end

	return cup
end