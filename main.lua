require "libs/class"
require "libs/misc"
require "libs/angle"
require "imgManager"
require "inputManager"
require "audioManager"
require "debugger"
require "game"
require "coffee"

function love.load()

	math.randomseed(os.time())

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

end

function love.update(dt)

	input:update(dt)

	gameScreen:update(dt)
	coffeeScreen:update(dt)

	debugger:update(dt)

end

function love.draw()

	gameScreen:draw(dt)
	coffeeScreen:draw(dt)

	debugger:draw()

end

function love.keypressed(key)

	gameScreen:keypressed(key)
	coffeeScreen:keypressed(key)

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