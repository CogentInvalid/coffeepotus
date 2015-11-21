speech = class:new()

function speech:init(parent)

	self.parent = parent

	local options = {"games"}
	self:getThing(randomSelect(options))

	self.state = "wait"

	self.finished = false

end

function speech:getThing(thing)
	local op = {}
	if thing == "games" then
		self.question = "Mr. President, what are your thoughts on video games?"
		op[1] = {"Video games cause violins!", true, 1}
		op[2] = {"Guns don't kill people,\nvideo games kill people.", false, 2}
		op[3] = {"Video games are the last\nlight in a dying world!", true, 2}
		self.winString = "Acceptable!"
		self.loseString = "Appalling!"
	end

	local ugh = {false,false,false}
	self.answer = {}

	for i=1, 3 do
		local found = false
		local x = 0
		while not found do
			x = math.random(3)
			if not ugh[x] then
				found = true
				ugh[x] = true
			end
		end

		self.answer[i] = op[x]
	end

	self.a1 = self.answer[1][1]
	self.a2 = self.answer[2][1]
	self.a3 = self.answer[3][1]

	self.y1 = 250
	self.y2 = self.y1 + 16 + 16*self.answer[1][3]
	self.y3 = self.y2 + 16 + 16*self.answer[2][3]

end

function speech:update(dt)

	if not self.finished then
		if math.random(3) == 1 then self.a1 = self:garble(self.answer[1][1], 0.2) end
		if math.random(3) == 1 then self.a2 = self:garble(self.answer[2][1], 0.2) end
		if math.random(3) == 1 then self.a3 = self:garble(self.answer[3][1], 0.2) end
	end

end

function speech:garble(str, rate)
	local result = ""
	for i=1, string.len(str) do
		if math.random() < rate then
			if str:sub(i,i) ~= "\n" then
				result = result .. self:randChar()
			else
				result = result .. str:sub(i,i)
			end
		else
			result = result .. str:sub(i,i)
		end
	end
	return result
end

function speech:randChar()
	local str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890~!@#$%^&*()-+=/?.,<>"
	local pos = math.random(str:len())
	return str:sub(pos,pos)
end

function speech:draw()

	love.graphics.setFont(mono)

	love.graphics.setColor(250,250,200)
	love.graphics.rectangle("fill", 0, 0, 500, 600)

	-- question
	local r = 0; local g = 0; local b = 0
	local str = ""
	if self.state == "win" then
		r=0; g=150; b=0
		str = self.winString
	end
	if self.state == "lose" then
		r=255; g=0; b=0
		str = self.loseString
	end
	if self.state == "wait" then
		str = self.question
	end
	love.graphics.setColor(r,g,b)
	love.graphics.printf(str, 200, 400, 250)

	-- answers
	love.graphics.setColor(0,0,0)
	if self.choice == 1 then
		if self.answer[1][2] then love.graphics.setColor(0,150,0) else love.graphics.setColor(255,0,0) end
	end
	love.graphics.print("1. " .. self.a1, 20, self.y1)

	love.graphics.setColor(0,0,0)
	if self.choice == 2 then
		if self.answer[2][2] then love.graphics.setColor(0,150,0) else love.graphics.setColor(255,0,0) end
	end
	love.graphics.print("2. " .. self.a2, 20, self.y2)

	love.graphics.setColor(0,0,0)
	if self.choice == 3 then
		if self.answer[3][2] then love.graphics.setColor(0,150,0) else love.graphics.setColor(255,0,0) end
	end
	love.graphics.print("3. " .. self.a3, 20, self.y3)


	love.graphics.setFont(font)
end

function speech:keypressed(key)

	if not self.finished then
		if key=="1" or key=="2" or key=="3" then
			self.choice = tonumber(key)
			if self.answer[self.choice][2] then
				self.state = "win"
			else
				self.state = "lose"
			end
			self:finish()
		end
	end

end

function speech:finish()
	self.finished = true
	self.a1 = self.answer[1][1]
	self.a2 = self.answer[2][1]
	self.a3 = self.answer[3][1]
end