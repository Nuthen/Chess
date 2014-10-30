Board = class('Board')

function Board:initialize(width, height)
	self.width = width
	self.height = height
	
	self.tileWidth = 64
	self.tileHeight = 64
	
	self.realWidth = self.width * self.tileWidth
	self.realHeight = self.height * self.tileHeight
	
	local scrnWidth, scrnHeight = love.graphics.getDimensions()
	self.offsetX, self.offsetY = scrnWidth/2 - self.realWidth/2, scrnHeight/2 - self.realHeight/2
	
	self.tiles = {}
	for iy = 1, self.height do
		self.tiles[iy] = {}
		for ix = 1, self.width do
			-- y is inverted so that (1, 1)/(A, 1) will be in the bottom-left corner of the board
			self.tiles[iy][ix] = {x = (ix-1)*self.tileWidth, y = (self.height-iy)*self.tileHeight, state = 'none'}
		
			local tile = 1
			if ix % 2 == 1 and iy % 2 == 0 or ix % 2 == 0 and iy % 2 == 1 then
				tile = 0
			end
			
			self.tiles[iy][ix].tile = tile
		end
	end
end

function Board:draw()
	local x, y = self.offsetX, self.offsetY
	
	for iy = 1, self.height do
		for ix = 1, self.width do
			local tile = self.tiles[iy][ix]
			local r, g, b, a = 157, 100, 232, 255
			
			if tile.tile == 0 then
				r, g, b = 240, 224, 161
			elseif tile.tile == 1 then
				r, g, b = 176, 123, 9
			end
			
			if tile.state == 'selected' then
				local f = .8
				r = r*(1-f) + 242*f
				g = g*(1-f) + 220*f
				b = b*(1-f) + 94*f
			elseif tile.state == 'movable' then
				local f = .8
				r = r*(1-f) + 39*f
				g = g*(1-f) + 165*f
				b = b*(1-f) + 219*f
			elseif tile.state == 'capturable' then
				local f = .8
				r = r*(1-f) + 230*f
				g = g*(1-f) + 45*f
				b = b*(1-f) + 32*f
			end
			
			love.graphics.setColor(r, g, b, a)
			love.graphics.rectangle('fill', x + tile.x, y + tile.y, self.tileWidth, self.tileHeight)
			love.graphics.setColor(255, 255, 255)
			love.graphics.rectangle('line', x + tile.x, y + tile.y, self.tileWidth, self.tileHeight)
		end
	end
end


function Board:getTile(x, y)
	local tileX, tileY = math.ceil((x - self.offsetX)/self.tileWidth), self.height - math.ceil((y - self.offsetY)/self.tileHeight) + 1
	if tileX >= 1 and tileX <= self.width and tileY >= 1 and tileY <= self.height then
		return tileX, tileY
	else
		return nil
	end
end