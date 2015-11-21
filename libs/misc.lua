--misc. helpful functions

function string:split(delimiter) --definitely not stolen from anything else
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end

function mergeTables(t1,t2) --also 100% original
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function keyDown(key)
	return love.keyboard.isDown(key)
end

function mouseDown(b)
	return love.mouse.isDown(b)
end

function mouseX()
	return love.mouse.getX()
end

function mouseY()
	return love.mouse.getY()
end

function randSign() --returns 1 or -1
	if math.random(2) == 1 then return -1 else return 1 end
end

function randomSelect(name) --return random entry from name
	return name[math.random(#name)]
end

function weightedRandom(name, rand) --return random entry from name, based on weights defined in rand
	local total = 0
	for i=1, table.getn(rand) do
		total = total + rand[i]
	end
	local r = math.random()*total
	local i = 0
	local counter = 0
	while counter < r do
		i = i + 1
		counter = counter + rand[i]
	end
	return name[i]
end

function round(x,num) --round x to the nearest num
	num = num or 1
	x = x/num
	if x%1 > 0.5 then x = math.ceil(x) else x = math.floor(x) end
	x = x*num
	return x
end

function magnitude(x,y) --returns the pythagorean distance b/w x and y
	return math.sqrt(x*x+y*y)
end

function getHue(x) --gets hue from number 0-255
	while x<0 do x = x + 255 end
	x = x * 6
	r=255; g=0; b=0
	while x>0 do
		if x>=255 then g = g + 255; x = x - 255
		else g = g + x; x = 0 end
		if x>=255 then r = r - 255; x = x - 255
		else r = r - x; x = 0 end
		if x>=255 then b = b + 255; x = x - 255
		else b = b + x; x = 0 end
		if x>=255 then g = g - 255; x = x - 255
		else g = g - x; x = 0 end
		if x>=255 then r = r + 255; x = x - 255
		else r = r + x; x = 0 end
		if x>=255 then b = b - 255; x = x - 255
		else b = b - x; x = 0 end
	end
	return r, g, b
end

function desaturate(r,g,b,amt)
	amt = 1 - amt
	r = r + (255-r)*amt
	g = g + (255-g)*amt
	b = b + (255-b)*amt
	return r, g, b
end

function darken(r,g,b,amt)
	r = r * amt
	g = g * amt
	b = b * amt
	return r, g, b
end

function crash(message) --ghetto debugs yo
	message = message or "crash() called"
	assert(false, message)
end