paperwork = class:new()

function paperwork:init(parent)

	self.parent = parent

	self.cursor = cursor:new({x=200,y=300})

	local options = {"peas", "budget", "peas-reverse", "candy", "peas-quad", "war", "debt", "nuke", "debtReverse"}
	self.papx = math.random(50,150); self.papy = math.random(100,200) --target paper position
	self:getThing(randomSelect(options))

	self.state = "wait"

	self.finished = false
	self.headline = "PRES IS LAZY"
	self.subtitle = "FAILS TO TAKE ACTION ON CRITICAL ISSUE"

end

function paperwork:getThing(thing)

	local xpos = math.random(0,200)
	local ypos = 600

	sfx['paper']:play()

	self.paper = {img=imgMan:getImage(thing), x=xpos, y=ypos}
	if thing == "peas" then
		self.successZone = {85,227,129,274}
		self.failZone = {141,227,178,269}
		self.winString = "PEAS ACHIEVED"
		self.loseString = "PEAS DESTROYED"
		self.losePaper = {"WORLD WAR 3 BEGINS", "'ALL BECAUSE OF THE PRESIDENT'S DEADLY CLUMSINESS' SAYS GENERAL"}
		self.winPaper = {"WORLD PEAS UPHOLDED", "WHAT EVEN IS 'WORLD PEAS', IS IT LIKE A VEGETABLE OR SOMETHING"}
	end
	if thing == "peas-reverse" then
		self.successZone = {141,227,178,269}
		self.failZone = {85,227,129,274}
		self.winString = "PEAS ACHIEVED"
		self.loseString = "PEAS DESTROYED"
		self.losePaper = {"WORLD WAR 3 BEGINS", "'ALL BECAUSE OF THE PRESIDENT'S DEADLY CLUMSINESS' SAYS GENERAL"}
		self.winPaper = {"WORLD PEAS UPHOLDED", "WHAT EVEN IS 'WORLD PEAS', IS IT LIKE A VEGETABLE OR SOMETHING"}
	end
	if thing == "peas-quad" then
		self.successZone = {175,70,302,147}
		self.failZone = {21,92,172,124}
		self.winString = "PEAS ACHIEVED"
		self.loseString = "PEAS DESTROYED"
		self.losePaper = {"WORLD WAR 3 BEGINS", "GENERAL CITES PRESIDENT'S INABILITY TO PARSE QUADRUPLE NEGATIVES"}
		self.winPaper = {"WORLD PEAS UPHOLDED", "DELICIOUS PEAS FOR PEOPLE OF ALL NATIONS"}
	end
	if thing == "budget" then
		self.successZone = {118,147,158,196}
		self.failZone = {55,131,224,194}
		self.winString = "BUDGET PASSED"
		self.loseString = "BUDGET UNPASSED"
		self.losePaper = {"MILLIONS LOSE THEIR JOBS", "PRESIDENT ONLY PERSON LEFT EMPLOYED"}
		self.winPaper = {"ROUTINE BUDGET PASSED", "NOTHING ELSE HAPPENS. WHAT CAN I SAY; IT'S A SLOW NEWS DAY"}
	end
	if thing == "candy" then
		self.successZone = {25,17,54,50}
		self.failZone = {25,153,236,195}
		self.winString = "CANDY SAVED"
		self.loseString = "DREAMS CRUSHED"
		self.winPaper = {"'A CANDY FOR EVERY CHILD'", "PRES PROBABLY CAN'T DELIVER ON HIS PROMISE BUT IT'S THE THOUGHT THAT COUNTS"}
		self.losePaper = {"CANDY OUTLAWED", "MILLIONS OF SMALL CHILDREN STARVE TO DEATH"}
	end
	if thing == "war" then
		self.failZone = {85,227,129,274}
		self.successZone = {141,227,178,269}
		self.winString = "WAR AVOIDED"
		self.loseString = "WORLD WAR PEA BEGINS"
		self.winPaper = {"WORLD WAR PEA PREVENTED", "MINOR WAR PEA GROWERS REJOICE"}
		self.losePaper = {"PRESIDENT CAUSES WORLD WAR PEA", "CITIZENS SUSPECT THE INTERFERENCE OF PEA LOBBYISTS"}
	end
		
	if thing == "debt" then
		self.successZone = {141,227,178,269}
		self.failZone = {85,227,129,274}
		self.winString = "DEBT CRISIS AVOIDED"
		self.loseString = "DEBT CRISIS CREATED"
		self.winPaper = {"PRESIDENT AVOIDS DEBT CRISIS", "POPULACE RELIEVED"}
		self.losePaper = {"DEBT CRISIS CREATED", "ANALYSTS BLAME A CLERICAL ERROR"}
	end
	
	if thing == "debtReverse" then
		self.failZone = {141,227,178,269}
		self.successZone = {85,227,129,274}
		self.winString = "DEBT CRISIS SOLVED"
		self.loseString = "DEBT CRISIS CONTINUES"
		self.winPaper = {"PRESIDENT SOLVES DEBT CRISIS", "THE POPULACE IS RELIEVED"}
		self.losePaper = {"DEBT CRISIS CONTINUES", "PEOPLE BEGIN TO QUESTION WHETHER THIS CONSTITUTES NEWS"}
	end

	if thing == "nuke" then
		self.successZone = {90,138,127,170}
		self.failZone = {130,141,170,174}
		self.loseString = "MISSILE LAUNCHED"
		self.winString = "WAR AVERTED"
		self.winPaper = {"NOTHING BAD HAPPENS", "LOREM IPSUM DOLOR SID AMET, CONSECITUR ADIPISCING ELIT"}
		self.losePaper = {"US DECLARES WAR ON CHINA", "ECONOMY CRASHES AS IMPORTS SLOW TO A CRAWL"}
	end
end

function paperwork:update(dt)

	if self.cursor ~= nil and not self.finished then
		self.cursor.wobble = self.parent.wobble
		self.cursor:update(dt)
	end

	debug(love.mouse.getX()-self.paper.x..', '..love.mouse.getY()-self.paper.y)

	self.paper.x = self.paper.x - (self.paper.x - self.papx)*5*dt
	self.paper.y = self.paper.y - (self.paper.y - self.papy)*5*dt

end

function paperwork:draw()

	love.graphics.setColor(50,35,0)
	love.graphics.rectangle("fill", 0, 0, 500, 600)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.paper.img, self.paper.x, self.paper.y, 0, 30/50, 30/50)

	local r = 255; local g = 255; local b = 255
	local x = 100; local y = 550
	local str = ""

	if self.state == "win" then
		r=0; g=255; b=0
		str = self.winString
	end
	if self.state == "lose" then
		r=255; g=0; b=0
		str = self.loseString
	end
--	if self.state == "miss" then
--		r=255; g=255; b=0
--		str = "YA GOTTA TRY AGAIN SON"
--	end

	love.graphics.setColor(r,g,b)
	love.graphics.printf(str, x, y, 300, "center")
	if self.cursor ~= nil then
		love.graphics.setColor(255,255,255)
		self.cursor.img:draw(self.cursor.phys.x, self.cursor.phys.y, 30/50, 30/50)
	end

	love.graphics.setColor(255,0,0)
	love.graphics.setColor(255,255,255)
end

function paperwork:keypressed(key)
	if input:keyIs("interact", key) and not self.finished then
		local phys = self.cursor.phys
		local x = phys.x+phys.w/2; local y = phys.y+phys.h/2

		--test success zone
		if x>self.successZone[1]+self.paper.x and y>self.paper.y+self.successZone[2]
		and x<self.paper.x+self.successZone[3] and y<self.paper.y+self.successZone[4] then
			sfx['stamp']:play()
			self.state = "win"
			self.headline = self.winPaper[1]
			self.subtitle = self.winPaper[2]
			self:finish()
		else
			--test fail zone
			if x>self.failZone[1]+self.paper.x and y>self.paper.y+self.failZone[2]
			and x<self.paper.x+self.failZone[3] and y<self.paper.y+self.failZone[4] then
				sfx['stamp']:play()
				self.state = "lose"
				self.headline = self.losePaper[1]
				self.subtitle = self.losePaper[2]
				self:finish()
			else
				self.state = "miss"
			end
		end

	end
end

function paperwork:finish()
	self.finished = true
	self.cursor.img = self.cursor:addComponent(image:new("check"))
end