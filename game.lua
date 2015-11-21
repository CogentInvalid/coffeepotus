require "paperwork"
require "speech"
require "ent/gameObject"
require "ent/cursor"

game = class:new()

function game:init()
	--timestep related stuff
	dt = 0.01
	accum = 0
	pause = false

	self.canvas = love.graphics.newCanvas(500,600)

	--components
	self.component = {}

	--gameplay stuff
	self.minigames = {paperwork, speech}
	local randgame = randomSelect(self.minigames)
	self.currentMinigame = randgame:new(self)

	self.wobble = 1
	self.timer = 10
	self.endTimer = 0
	self.paperTimer = 0

	self.endPaper = {x=0, y=600}
	self.news = imgMan:getImage("newspaper")
	self.headline = "???"
	self.subtitle = "..."

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

		if self.currentMinigame.finished then
			if self.timer ~= 0 then
				self.timer = 0
				self.endTimer = 1.5
			end
		end

		if self.timer > 0 then
			self.timer = self.timer - dt
			if self.timer <= 0 then
				self.endTimer = 1.5
			end
		end
		if self.timer < 0 then self.timer = 0 end

		if self.endTimer > 0 then
			self.endTimer = self.endTimer - dt
			if self.endTimer <= 0 then
				if self.currentMinigame.state == 'win' then
					sfx['yay']:play()
				else
					sfx['boo']:play()
				end
				self.endTimer = 0
				self.paperTimer = 3
				--set paper
				self.headline = self.currentMinigame.headline
				self.subtitle = self.currentMinigame.subtitle
			end
		end

		if self.paperTimer > 0 then
			self.paperTimer = self.paperTimer - dt
			if self.paperTimer <= 0 then
				local randgame = randomSelect(self.minigames)
				self.currentMinigame = randgame:new(self)
				self.timer = 10
			end

			self.endPaper.y = self.endPaper.y - (self.endPaper.y - 0)*10*dt
		else
			self.endPaper.y = self.endPaper.y - (self.endPaper.y - 600)*10*dt
		end

		accum = accum - 0.01
	end
	if accum>0.1 then accum = 0 end

end

function game:draw()

	love.graphics.setCanvas(self.canvas)
	self.canvas:clear()
	self.currentMinigame:draw()

	--timer
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill",10,10,(self.timer/10)*400,50)

	love.graphics.setColor(255,255,255)
	--end paper
	love.graphics.draw(self.news, self.endPaper.x, self.endPaper.y)
	love.graphics.setCanvas()
	love.graphics.draw(self.canvas, 0, 0)

	--text
	love.graphics.setColor(89,89,89)
	love.graphics.setFont(bigfont)
	love.graphics.printf(self.headline, self.endPaper.x+50, self.endPaper.y+80, 400)
	love.graphics.setFont(font)
	love.graphics.printf(self.subtitle, self.endPaper.x+50, self.endPaper.y+180, 400)

end

function game:keypressed(key)
	self.currentMinigame:keypressed(key)
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