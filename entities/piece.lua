Piece = class('Piece')

function Piece:initialize(x, y, color)
	self.board = {tileWidth = game.board.tileWidth, tileHeight = game.board.tileHeight}
	self:setLocation(x, y, true)
	
	self.offsetX = game.board.offsetX
	self.offsetY = game.board.offsetY
	
	self.width = 50
	self.height = 50
	
	if self.img then
		self.width = self.image:getWidth()
		self.height = self.image:getHeight()
	end
	
	self.color = color
	
	self.state = 'alive'
	
	self.selected = false
end

function Piece:draw()
	if self.state ~= 'captured' then
		local r, g, b, a = 0, 0, 255, 255
		
		if self.color == 1 then
			r, g, b = 149, 50, 173
		elseif self.color == 2 then
			r, g, b = 255, 132, 31
		end
		
		if self.selected then
			r = r*.6 + 255*.6
			b = b*.6 + 255*.6
		end
		
		love.graphics.setColor(r, g, b, a)
		
		if self.image then
			love.graphics.draw(self.image, self.realX-self.width/2 + self.offsetX, self.realY-self.height/2 + self.offsetY)
		else
			love.graphics.rectangle('fill', self.realX-self.width/2 + self.offsetX, self.realY-self.height/2 + self.offsetY, self.width, self.height)
		end
	end
end


function Piece:setLocation(x, y, first)
	-- LOTS of redundancy here
	if first or self.x ~= x or self.y ~= y then
		if first or self.canMove(x, y) or self.canCapture(x, y) then
			if not first and not game.board.tiles[y][x].piece or first or self.canCapture(x, y)then
				local capture = false
			
				-- redundant check
				if self.canCapture(x, y) then
					game.board.tiles[y][x].piece.x = 0
					game.board.tiles[y][x].piece.y = 0
					game.board.tiles[y][x].piece.state = 'captured'
					game.board.tiles[y][x].piece = nil
					
					--capture = 
				end
				
				if self.x and self.y then
					game.board.tiles[self.y][self.x].piece = nil
				end
				
				self:decolorTiles()

				self.x = x
				self.y = y
				self.tile = game.board.tiles[y][x]
				self.realX = self.tile.x + self.board.tileWidth/2
				self.realY = self.tile.y + self.board.tileHeight/2
				
				game.board.tiles[self.y][self.x].piece = self
				
				self.selected = false
				
				return true
			end
		end
	end
end

-- Checks if a screen coordinate is over anywhere on the pieces tile, not just the drawn image of a piece
function Piece:isHover(x, y)
	if x >= self.tile.x + self.offsetX and x < self.tile.x + self.offsetX + self.board.tileWidth and y >= self.tile.y + self.offsetY and  y < self.tile.y + self.offsetY + self.board.tileHeight then
		return true
	else
		return false
	end
end

function Piece:clicked(button)
	if not self.selected and self.color == game.color then
		return true
	else
		return false
	end
end

function Piece:deselect()
	self.selected = false
	self:decolorTiles()
end

function Piece:select()
	self.selected = true
	self:colorTiles()
end

function Piece:decolorTiles()
	for iy = 1, #game.board.tiles do
		for ix = 1, #game.board.tiles[iy] do
			game.board.tiles[iy][ix].state = 'none'
		end
	end
end

function Piece:colorTiles()
	-- colors tile piece is currently on
	game.board.tiles[self.y][self.x].state = 'selected'
	
	-- colors tiles piece may move to
	for iy = 1, #game.board.tiles do
		for ix = 1, #game.board.tiles[iy] do
			if self.canMove(ix, iy) then
				game.board.tiles[iy][ix].state = 'movable'
			elseif self.canCapture(ix, iy) then
				game.board.tiles[iy][ix].state = 'capturable'
			end
		end
	end
end