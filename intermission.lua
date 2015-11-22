intermission = class:new()

function intermission:init()

	self.paper = {x=0, y=0}
	self.paperImg = imgMan:getImage("inter-news")

	self.graph = {}

end

function intermission:update(dt)

end

function intermission:setGraph(pts)

	local x = 520; local y = 330
	local w = 360; local h = 180

	for i,pt in ipairs(pts) do

		local px = x+(i-1)*(w/(#pts-1))
		local py = y+(200-(pt/100)*200)

		self.graph[i] = {px,py}

	end

	if ratingsHistory[#ratingsHistory] >= ratingsHistory[#ratingsHistory - 6] then
		self.headline = "PRESIDENT'S RATINGS SOAR"
	else
		self.headline = "PRESIDENT'S RATINGS PLUMMET"
	end

end

function intermission:draw()
	love.graphics.setColor(50,35,0)
	love.graphics.rectangle("fill", 0, 0, 1000, 600)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.paperImg, self.paper.x, self.paper.y)

	love.graphics.setColor(89,89,89)
	love.graphics.setFont(bigfont)
	love.graphics.printf(self.headline, self.paper.x+100, self.paper.y+180, 800)
	love.graphics.setFont(font)
	love.graphics.printf("PRESS SPACE TO CONTINUE", 100, 270, 800)

	love.graphics.setColor(230,230,230)
	love.graphics.rectangle("fill", 500, 320, 400, 200)

	love.graphics.setLineWidth(5)
	love.graphics.setColor(89,89,89)
	for i,pt in ipairs(self.graph) do
		love.graphics.circle("fill", pt[1], pt[2], 6)
	end

	for i=1, #self.graph-1 do
		love.graphics.line(self.graph[i][1], self.graph[i][2], self.graph[i+1][1], self.graph[i+1][2])
	end
end