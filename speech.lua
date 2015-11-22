speech = class:new()

function speech:init(parent)

	self.parent = parent

	local options = {"games", "jews", "colors", "allegations", "guns", "taxes", "geneology", "food", "policy", "war", "guy", "nsa", "education"}
	self:getThing(randomSelect(options))

	self.state = "wait"

	self.answerTimer = 1

	if currentLevel >= 2 then
		self.garbleRate = (self.parent.wobble - 0.2)/2.5	
	else
		self.garbleRate = 0.05
	end
	
	self.finishTime = 2

	self.finished = false
	self.headline = "PRESIDENT HAS GONE MUTE"
	self.subtitle = "COULD NOT BE REACHED FOR COMMENT, OBVIOUSLY"

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
		self.winPaper = {"PRESIDENT ENDORSES GAMES", "GOOD JUDGMENT LAUDED BY ALL"}
		self.losePaper = {"PRESIDENT HATES GAMES", "IGNORES THE HIDDEN VALUE OF THE MEDIUM"}
	end

	if thing == "jews" then
		self.question = "PRESIDENT MAN WHAT YOU THINK OF HITLER?"
		op[1] = {"I want to kiss all the\njews.", true, 2}
		op[2] = {"What kind of question is\nthat? You're a terrible\njournalist.", true, 3}
		op[3] = {"Hitler? I'm a hitler...", false, 2}
		self.winString = "OK WHATEVER DUDE"
		self.loseString = "WHAT! A HITLER!!!"
		self.winPaper = {"PRES NOT HITLER", "THIS SURPRISES NO ONE"}
		self.losePaper = {"PRESIDENT LITERALLY HITLER", "NATION MOURNS"}
	end

	if thing == "colors" then
		self.question = "Isn't it false that your favorite colors aren't red, white, and blue?"
		op[1] = {"Nope!", false, 1}
		op[2] = {"NO!!!1", false, 1}
		op[3] = {"Yeah dude!", true, 1}
		self.winString = "A true American!"
		self.loseString = "He must be a socialist!"
		self.winPaper = {"GOD BLESS AMERICA", "EAGLE TEARS RAIN OVER WHITE HOUSE"}
		self.losePaper = {"PRES CONFIRMED COMMUNIST", "COULD NOT BE REACHED FOR COMMENT"}
	end

	if thing == "allegations" then
		self.question = "What do you say to the allegations levied against you?"
		op[1] = {"I believe with full\nconviction that the\nalligators are false!", false, 3}
		op[2] = {"LOL what a joke! I'm\nthe coolest president ever.", true, 2}
		op[3] = {"I allege that there\nARE no allegations.", true, 2}
		self.winString = "Huh, I never thought of it like that."
		self.loseString = "How insulting! Some of my best friends are alligators!"
		self.winPaper = {"CONTROVERSY AVERTED", "ONLY SPOTS ON PRESIDENT'S RECORD ARE COFFEE STAINS"}
		self.losePaper = {"PRESIDENT HATES ALLIGATORS!", "THE PEOPLE'S SUSPICIONS WERE TRUE AFTER ALL"}
	end
	
	if thing == "guns" then
		self.question = "What is your stance on gun control?"
		op[1] = {"I am strongly opposed to\nthe arming of bears.", false, 2}
		op[2] = {"Reasonable restrictions\nshould be placed on guns", true, 2}
		op[3] = {"The right to bear arms is\nsacred", true, 2}
		self.winString = "A reasonable stance."
		self.loseString = "The bears would hardly approve"
		self.winPaper = {"GUN CONTROL DEBATE ENDS","DEBATE MOVES ONTO EXPLOSIVES CONTROL DEBATES"}
		self.losePaper = {"PRESIDENT HATES BEARS", "POLLING DROPS AMONG BEAR DEMOGRAPHIC"}
	end
		
	if thing == "taxes" then
		self.question = "What is your opinion on taxes?"
		op[1] = {"I shall keep the taxes\nas low as possible.", true, 2}
		op[2] = {"Death to the taxes!", true, 1}
		op[3] = {"Death to the poor, via\ntaxes!", false, 2}
		self.winString = "Popular stance"
		self.loseString = "But the poor..."
		self.winPaper = {"PRES PROMISES LOW TAXES", "PEOPLE CELEBRATE"}
		self.losePaper = {"PRES HATES THE POOR", "DRAMATIC TAX INCREASES ON THE POOR"}
	end
	
	if thing == "geneology" then
		self.question = "Which world leader would you most like to be related to?"
		op[1] = {"Adolf Hitler", false,1}
		op[2] = {"Abraham Lincoln", true, 1}
		op[3] = {"Nicholas Cage", true, 1}
		self.winString = "An admirable role model."
		self.loseString = "A NAZI!"
		self.winPaper = {"PRES RECOGNIZES A TRUE HERO", "CELEBRITIES OFFER THEIR APPROVAL"}
		self.losePaper = {"PRES HOPES TO BE LITERALLY HITLER", "POLITICAL ANALYSTS 'DID NAZI THAT COMING'"}
	end
		
	if thing == "food" then
		self.question = "What is your favorite food?"
		op[1] = {"Hamburger", true, 1}
		op[2] = {"Pizza", true, 1}
		op[3] = {"Whale", false, 1}
		self.winString = "An American classic."
		self.loseString = "The poor whales..."
		self.winPaper = {"PRES HAS GOOD TASTE IN FOOD", "FEW ARE SURPRISED"}
		self.losePaper = {"PRESIDENT EATS WHALES", "ANIMAL CONSERVATIONISTS HORRIFIED"}
	end

	if thing == "policy" then
		self.question = "Tell us about your plans for foreign trade policy, especially in the Middle East. Our dependence on foreign oil has long been a decisive factor in our trade policy; do you intend on changing this fact and if so, how?"
		op[1] = {"That's a very good\nquestion. 9/11.", true, 2}
		op[2] = {"What? I... I don't know.\nWhat do you want me\nto say?", false, 3}
		op[3] = {"Maybe... maybe bomb\neveryone?", false, 2}
		self.winString = "(standing ovation)"
		self.loseString = "WOW. You're so bad at this."
		self.winPaper = {"PRESIDENT MENTIONS 9/11", "PRESIDENT MENTIONS 9/11"}
		self.losePaper = {"PRESIDENT UNINFORMED", "ARE THEY EVEN FIT TO LEAD OUR NATION? (NO)"}
	end
	
	if thing == "war" then
		self.question = "How do you plan to wage the war on terror?"
		op[1] = {"With careful calculation\nand strategy", true, 2}
		op[2] = {"With rapid, unrelenting\nstrikes", true, 2}
		op[3] = {"By deploying more trolls", false, 1}
		self.winString = "A good plan"
		self.loseString = "A strange plan..."
		self.winPaper = {"PRESIDENT PLANS BOLD OFFENSIVE", "MORALE OF TROOPS INCREASES"}
		self.losePaper = {"TROLL ENLISTMENT PLANNED", "THE TROLLS HAVE NOT YET BEEN LOCATED"}
	end
	
	if thing == "guy" then
		self.question = "hey why cant i be the president i promise ill do a good job"
		op[1] = {"No, you can be the\npresident.", false, 2}
		op[2] = {"I'm pretty sure you have\nto get elected first.", true, 2}
		op[3] = {"Absolutely not.", true, 1}
		self.winString = "aw come on dude i really want to be president"
		self.loseString = "haha thanks man i promise i wont let you down"
		self.winPaper = {"PRES REFUSES TO GIVE UP JOB", "PROOF THAT THEY STILL HAVE COMMAND OF THEIR MENTAL FACULTIES"}
		self.losePaper = {"RANDOM GUY MADE PRESIDENT", "CALLS JOB 'TOO HARD', GIVES IT BACK TO ORIGINAL PRESIDENT WITHIN THE MONTH"}
	end

	if thing == "nsa" then
		self.question = "Will you dismantle the NSA's internet surveillence program?"
		op[1] = {"Not after reading\nYOUR emails.", false, 2}
		op[2] = {"Even if I did, you\nwouldn't believe me.", false, 2}
		op[3] = {"It's important to stop\nterrorists.", true, 2}
		self.winString = "You're darn right it is!"
		self.loseString = "Wait what."
		self.winPaper = {"PRESIDENT TOUGH ON TERRORISTS", "WHAT WERE WE TALKING ABOUT AGAIN?"}
		self.losePaper = {"PRESIDENT SPIES ON EVERYONE", "DID SNOWDEN TEACH US NOTHING?"}
	end

	if thing == "education" then
		self.question = "Agree or disagree: You would disagree with decreasing education funding."
		op[1] = {"Disagree.", false, 1}
		op[2] = {"Dis I agree with.", true, 1}
		op[3] = {"This I disagree with.", false, 1}
		self.winString = "Good decision, Mr. President."
		self.loseString = "But... think of the children!"
		self.winPaper = {"PRES PROTECTS EDUCATION", "NATION UNAWARE EDUCATION WAS UNDER ATTACK"}
		self.losePaper = {"PRES HATES EDUCATION", "WANTS TO MURDER REASON ITSELF"}
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

	self.x1 = -480
	self.x2 = -480
	self.x3 = -480

end

function speech:update(dt)

	if not self.finished then
		if math.random(3) == 1 then self.a1 = self:garble(self.answer[1][1], self.garbleRate) end
		if math.random(3) == 1 then self.a2 = self:garble(self.answer[2][1], self.garbleRate) end
		if math.random(3) == 1 then self.a3 = self:garble(self.answer[3][1], self.garbleRate) end
	end

	self.answerTimer = self.answerTimer - dt
	if self.answerTimer <= 0 then
		self.x1 = self.x1 - (self.x1 - 20)*5*dt
		self.x2 = self.x2 - (self.x2 - 20)*4*dt
		self.x3 = self.x3 - (self.x3 - 20)*3*dt
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

	love.graphics.setColor(250,250,250)
	love.graphics.draw(imgMan:getImage('speech-bg'), 0, 0)

	-- question
	local r = 0; local g = 0; local b = 0
	local str = ""
	if self.state == "win" then
		r=0; g=255; b=0
		str = self.winString
	end
	if self.state == "lose" then
		r=255; g=0; b=0
		str = self.loseString
	end
	if self.state == "wait" then
		r=255; g=255; b=255
		str = self.question
	end
	love.graphics.setColor(r,g,b)
	love.graphics.printf(str, 50, 75, 400)

	-- answers
	love.graphics.setColor(255, 255, 255)
	if self.choice == 1 then
		if self.answer[1][2] then love.graphics.setColor(0,255,0) else love.graphics.setColor(255,0,0) end
	end
	love.graphics.print("1. " .. self.a1, self.x1, self.y1)

	love.graphics.setColor(255, 255, 255)
	if self.choice == 2 then
		if self.answer[2][2] then love.graphics.setColor(0,255,0) else love.graphics.setColor(255,0,0) end
	end
	love.graphics.print("2. " .. self.a2, self.x2, self.y2)

	love.graphics.setColor(255, 255, 255)
	if self.choice == 3 then
		if self.answer[3][2] then love.graphics.setColor(0,255,0) else love.graphics.setColor(255,0,0) end
	end
	love.graphics.print("3. " .. self.a3, self.x3, self.y3)


	love.graphics.setFont(font)
end

function speech:keypressed(key)

	if not self.finished then
		if key=="1" or key=="2" or key=="3" then
			local fx = math.random(3)
			sfx['speaking-'..fx]:play()
			self.choice = tonumber(key)
			if self.answer[self.choice][2] then
				self.state = "win"
				self.headline = self.winPaper[1]
				self.subtitle = self.winPaper[2]
			else
				self.state = "lose"
				self.headline = self.losePaper[1]
				self.subtitle = self.losePaper[2]
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