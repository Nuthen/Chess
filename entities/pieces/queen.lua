Queen = class('Bishop', Piece)

function Queen:initialize(x, y, color)
	self.canMove = function(x, y)
		if x ~= self.x or y ~= self.y then
			if not game.board.tiles[y][x].piece then
				if math.abs(self.x-x) == math.abs(self.y-y) then -- diagonal
					if (x-self.x) > 0 and (y-self.y) > 0 then -- up-right
						for i = 0, math.abs(self.y-y)-1 do
							if game.board.tiles[y-i][x-i].piece then
								return false
							end
						end
						return true
					elseif (x-self.x) > 0 and (y-self.y) < 0 then -- down-right
						for i = 0, math.abs(self.y-y)-1 do
							if game.board.tiles[y+i][x-i].piece then
								return false
							end
						end
						return true
					elseif (x-self.x) < 0 and (y-self.y) > 0 then -- up-left
						for i = 0, math.abs(self.y-y)-1 do
							if game.board.tiles[y-i][x+i].piece then
								return false
							end
						end
						return true
					elseif (x-self.x) < 0 and (y-self.y) < 0 then -- down-left
						for i = 0, math.abs(self.y-y)-1 do
							if game.board.tiles[y+i][x+i].piece then
								return false
							end
						end
						return true
					end
					
				elseif x == self.x then -- horizontal
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
					
				elseif y == self.y then -- vertical
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
				if math.abs(self.x-x) == math.abs(self.y-y) then -- diagonal
					if (x-self.x) > 0 and (y-self.y) > 0 then -- up-right
						for i = 1, math.abs(self.y-y)-1 do
							if game.board.tiles[y-i][x-i].piece then
								return false
							end
						end
						return true
					elseif (x-self.x) > 0 and (y-self.y) < 0 then -- down-right
						for i = 1, math.abs(self.y-y)-1 do
							if game.board.tiles[y+i][x-i].piece then
								return false
							end
						end
						return true
					elseif (x-self.x) < 0 and (y-self.y) > 0 then -- up-left
						for i = 1, math.abs(self.y-y)-1 do
							if game.board.tiles[y-i][x+i].piece then
								return false
							end
						end
						return true
					elseif (x-self.x) < 0 and (y-self.y) < 0 then -- down-left
						for i = 1, math.abs(self.y-y)-1 do
							if game.board.tiles[y+i][x+i].piece then
								return false
							end
						end
						return true
					end
				
				elseif x == self.x then -- horizontal
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
					
				elseif y == self.y then -- vertical
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
	
	self.image = love.graphics.newImage('img/cat.png')
	
	Piece.initialize(self, x, y, color)
end