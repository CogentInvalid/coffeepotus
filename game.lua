--require "camera"
--require "collisionManager"
require "paperwork"
require "ent/gameObject"
require "ent/cursor"

game = class:new()

function game:init()
	--timestep related stuff
	dt = 0.01
	accum = 0
	pause = false

	--components
	self.component = {}
	--self.colMan = self:addComponent(collisionManager)
	--self.cam = self:addComponent(camera)

	--self.drawOrder = {"back", "front"}

	self.minigames = {}
	self.currentMinigame = paperwork:new()

	self.canvas = love.graphics.newCanvas(500,600)

	self:start()
end

function game:start()

end

function game:update(delta)

	if pause == false then accum = accum + delta end
	if accum > 0.05 then accum = 0.05 end
	while accum >= delta do

		--update components
		for i,comp in ipairs(self.component) do
			if comp.update ~= nil then comp:update(dt) end
		end

		self.currentMinigame:update(dt)

		accum = accum - 0.01
	end
	if accum>0.1 then accum = 0 end

end

function game:draw()

	love.graphics.setCanvas(self.canvas)
	self.canvas:clear()
	self.currentMinigame:draw()
	love.graphics.setCanvas()
	love.graphics.draw(self.canvas, 0, 0)

end

function game:keypressed(key)

end

function game:mousepressed(x, y, b)

end

function game:addComponent(comp)
	self.component[#self.component+1] = comp:new(self)
	return self.component[#self.component]
end

function game:getComp(name) --locate a component by name.
	for i=1, #self.component do
		if self.component[i].id == name then
			return self.component[i]
		end
	end
	return false
end