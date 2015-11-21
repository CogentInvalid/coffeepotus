audioManager = class:new()

function audioManager:init()
	--load all sounds from /resources

	local soundFiles = love.filesystem.getDirectoryItems("resources/audio/")

	sfx = {} --load sfx
	for i,name in ipairs(soundFiles) do
		if string.find(name, ".ogg") then
			name = string.gsub(name, ".ogg", "")
			sfx[name] = love.audio.newSource("/resources/audio/" .. name .. ".ogg", "stream")
		end
	end

	currentTrack = sfx['thirdlevel']
end

function audioManager:update(dt)

end

function audioManager:switchMusic(source)
	currentTrack:stop()
	currentTrack = source
	currentTrack:setLooping(true)
	currentTrack:play()
end