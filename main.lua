require "libs/class"
require "libs/misc"
require "libs/angle"
require "imgManager"
require "inputManager"
require "audioManager"
require "debugger"
require "game"
require "coffee"
require "intermission"

function love.load()

	math.randomseed(os.time())

	currentLevel = 1
	ratings = 100
	ratingsHistory = {100}

	love.graphics.setBackgroundColor(0,0,0)
	font = love.graphics.newFont(16)
	bigfont = love.graphics.newFont(40)
	love.graphics.setFont(font)
	mono = love.graphics.newImageFont("img/c64.png", "@abcdefghijklmnopqrstuvwxyz[$]^^ !\"#$%&'()*+,-./0123456789:;<=>?_ABCDEFGHIJKLMNOPQRSTUVWXYZ+^^^^")

	debugger = debugger:new()
	imgMan = imgManager:new()
	input = inputManager:new()
	audio = audioManager:new()

	gameScreen = game:new()
	coffeeScreen = coffee:new()
	interScreen = intermission:new()

	tut = {}
	tut[1] = {y=600,img=imgMan:getImage("tut1")}
	tut[2] = {y=600,img=imgMan:getImage("tut2")}
	tut[3] = {y=600,img=imgMan:getImage("tut3")}
	spaceprompt = imgMan:getImage("spaceprompt")
	promptx = 400
	sfx['paper']:play()
	currentTut = 1
	gameStarted = false
	titleDismissed = false

	intermission = false

	-- comment these out to give playtesters an easy time
	--nextLevel()

end

function love.update(dt)

	input:update(dt)

	if not gameStarted then
		if titleDismissed then
			for i=1, currentTut do
				tut[i].y = tut[i].y - (tut[i].y-0)*5*dt
				promptx = promptx - (promptx - (50+350*currentTut))*3*dt
			end
		end
	else
		if not intermission then
			gameScreen:update(dt)
			coffeeScreen:update(dt)
		end
		if intermission then
			interScreen:update(dt)
		end
		if gameScreen.gamesPlayed >= 6 then
			nextLevel()
		end
	end

	debugger:update(dt)

end

function nextLevel()
	intermission = true
	interScreen:setGraph(ratingsHistory)
	ratingsHistory = {ratings}
	currentLevel = currentLevel + 1
	gameScreen.gamesPlayed = 0
	gameScreen.wobble = gameScreen.wobble + 0.15
	coffeeScreen.meter = 1
	coffeeScreen.drainRate = coffeeScreen.drainRate + 0.005
end

function love.draw()

	if not intermission then
		gameScreen:draw()
		coffeeScreen:draw()
	else
		interScreen:draw()
	end

	if not gameStarted then
		love.graphics.setColor(50,35,0)
		love.graphics.rectangle("fill", 0, 0, 1000, 600)
		love.graphics.setColor(255,255,255)
		if not titleDismissed then
			love.graphics.draw(imgMan:getImage('title'), 0, 0)
			love.graphics.draw(spaceprompt, 400, 450)
		else
			for i=1, 3 do
				love.graphics.draw(tut[i].img, 0, tut[i].y)
			end
			love.graphics.draw(spaceprompt, promptx, 250)
		end
	end

	debugger:draw()

end

function love.keypressed(key)

	if key == " " and intermission then
		intermission = false
	else
		if not gameStarted then
			if not titleDismissed then
				titleDismissed = true
			else
				if key == " " then currentTut = currentTut + 1; sfx['paper']:play() end
				if currentTut == 4 then gameStarted = true end
			end
		else
			gameScreen:keypressed(key)
			coffeeScreen:keypressed(key)
		end

	end

	--if key == "1" then currentMode = gameMode end

	if key == "m" then --mute audio
		if love.audio.getVolume() == 1 then love.audio.setVolume(0)
			else love.audio.setVolume(1) end
	end

	if key == "escape" then love.event.quit() end

end

function love.mousepressed(x, y, button)

	coffeeScreen:mousepressed(x, y, button)

end

function love.resize(w, h)
	--gameMode.cam:setDimensions(w,h)
end

function setFullscreen()

	love.window.setMode(love.window.getDesktopDimensions())
	love.window.setFullscreen(true)

end

function getImg(name)
	return imgMan:getImage(name)
end

function debug(message, time)
	debugger:print(message, time)
end