Pawn = class('Pawn', Piece)

function Pawn:initialize(x, y, color)
	self.canMove = function(x, y)
		if not game.board.tiles[y][x].piece then
			if self.color == 1 then
				if self.x == x then
					if y == self.y + 1 then
						return true
					end
				end
			elseif self.color == 2 then
				if self.x == x then
					if y == self.y - 1 then
						return true
					end
				end
			end
		end
	end
	
	self.canCapture = function(x, y)
		if game.board.tiles[y][x].piece and game.board.tiles[y][x].piece.color ~= self.color then
			if self.color == 1 then
				if x == self.x - 1 or x == self.x + 1 then
					if y == self.y + 1 then
						return true
					end
				end
			elseif self.color == 2 then
				if x == self.x - 1 or x == self.x + 1 then
					if y == self.y - 1 then
						return true
					end
				end
			end
		end
	end
	
	self.image = love.graphics.newImage('img/pumpkin.png')
	
	Piece.initialize(self, x, y, color)
end