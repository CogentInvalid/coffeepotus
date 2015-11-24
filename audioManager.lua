audioManager = class:new()

function audioManager:init()
	--load all sounds from /resources

	local soundFiles = love.filesystem.getDirectoryItems("audio/")

	sfx = {} --load sfx
	for i,name in ipairs(soundFiles) do
		if string.find(name, ".ogg") then
			name = string.gsub(name, ".ogg", "")
			sfx[name] = love.audio.newSource("audio/" .. name .. ".ogg", "stream")
		end
	end

	sfx['yay']:setVolume(0.5)
	currentTrack = sfx['bg-music']
	currentTrack:play()
	currentTrack:setLooping(true)
	currentTrack:setVolume(0.2)
end

function audioManager:update(dt)

end

function audioManager:switchMusic(source)
	currentTrack:stop()
	currentTrack = source
	currentTrack:setLooping(true)
	currentTrack:play()
end