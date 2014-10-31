Rook = class('Rook', Piece)

function Rook:initialize(x, y, color)
	self.canMove = function(x, y)
		if x ~= self.x or y ~= self.y then
			if not game.board.tiles[y][x].piece then
				if x == self.x then
					if y > self.y then
						for i = 0, math.abs(self.y-y)-1 do
							if game.board.tiles[y-i][x].piece then
								return false
							end
						end
					elseif y < self.y then
						for i = 0, math.abs(self.y-y)-1 do
							if game.board.tiles[y+i][x].piece then
								return false
							end
						end
					end
					return true
				elseif y == self.y then
					if x > self.x then
						for i = 0, math.abs(self.x-x)-1 do
							if game.board.tiles[y][x-i].piece then
								return false
							end
						end
					elseif x < self.x then
						for i = 0, math.abs(self.x-x)-1 do
							if game.board.tiles[y][x+i].piece then
								return false
							end
						end
					end
					return true
				end
			end
		end
	end
	
	self.canCapture = function(x, y)
		if x ~= self.x or y ~= self.y then
			if game.board.tiles[y][x].piece and game.board.tiles[y][x].piece.color ~= self.color then
				if x == self.x then
					if y > self.y then
						for i = 1, math.abs(self.y-y)-1 do
							if game.board.tiles[y-i][x].piece then
								return false
							end
						end
					elseif y < self.y then
						for i = 1, math.abs(self.y-y)-1 do
							if game.board.tiles[y+i][x].piece then
								return false
							end
						end
					end
					return true
				elseif y == self.y then
					if x > self.x then
						for i = 1, math.abs(self.x-x)-1 do
							if game.board.tiles[y][x-i].piece then
								return false
							end
						end
					elseif x < self.x then
						for i = 1, math.abs(self.x-x)-1 do
							if game.board.tiles[y][x+i].piece then
								return false
							end
						end
					end
					return true
				end
			end
		end
	end
	
	self.image = love.graphics.newImage('img/frankenstein.png')
	
	Piece.initialize(self, x, y, color)
end