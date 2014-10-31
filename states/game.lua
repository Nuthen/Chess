game = {}

function game:enter(prev, hosting)
	local width, height = 8, 8
    self.board = Board:new(width, height)
	
	self.pieces = {}
	for x = 1, width do
		table.insert(self.pieces, Pawn:new(x, 2, 1))
		table.insert(self.pieces, Pawn:new(x, height-1, 2))
	end
	
	table.insert(self.pieces, Rook:new(1, 1, 1))
	table.insert(self.pieces, Rook:new(width, 1, 1))
	table.insert(self.pieces, Rook:new(1, height, 2))
	table.insert(self.pieces, Rook:new(width, height, 2))
	
	table.insert(self.pieces, Knight:new(2, 1, 1))
	table.insert(self.pieces, Knight:new(width-1, 1, 1))
	table.insert(self.pieces, Knight:new(2, height, 2))
	table.insert(self.pieces, Knight:new(width-1, height, 2))
	
	table.insert(self.pieces, Bishop:new(3, 1, 1))
	table.insert(self.pieces, Bishop:new(width-2, 1, 1))
	table.insert(self.pieces, Bishop:new(3, height, 2))
	table.insert(self.pieces, Bishop:new(width-2, height, 2))
	
	table.insert(self.pieces, Queen:new(4, 1, 1))
	table.insert(self.pieces, Queen:new(4, height, 2))
	
	table.insert(self.pieces, King:new(5, 1, 1))
	table.insert(self.pieces, King:new(5, height, 2))
	
	self.color = 1
	
	self.selected = nil
	
	
	-- networking
	self.hosting = hosting
	
	self.state = 'waiting'
	
	
	self.winner = nil
	
	if self.hosting then -- server setup
		self.ip = '*'
		self.port = '22122'
		
		self.host = enet.host_create(self.ip..':'..self.port, 1)
		
		if self.host == nil then
			error("Couldn't initialize host, there is probably another server running on that port")
		end
		
		self.host:compress_with_range_coder()
		self.timer = 0
		
		self.lastEvent = nil
		self.peer = nil
	
	else -- client setup
		self.host = enet.host_create()
		self.server = self.host:connect('69.137.215.69:22122')
		--self.server = self.host:connect('localhost:22122')
		self.host:compress_with_range_coder()
		
		self.timer = 0
	end
end

function game:update(dt)
	-- networking
	if self.hosting then
		self.timer = self.timer + dt
		
		-- check some events, 100ms timeout
		local event = self.host:service(0)
		
		if event then
			self.lastEvent = event
			self.peer = event.peer
			
			if event.type == 'connect' then
				--self.host:broadcast('t|'..math.floor(self.timer*100))
				self.state = 'run'
				self.timer = 0
				
				self.host:broadcast('c| 2') -- set other player's color to 2
			elseif event.type == 'receive' then
				if string.find(event.data, 'p|') == 1 then -- True if it is piece movement data
					local str = string.gsub(event.data, 'p|', '')
					local pieceTable = stringToTable(str)
					
					local index = tonumber(pieceTable[1])
					local x = tonumber(pieceTable[2])
					local y = tonumber(pieceTable[3])
					
					self.pieces[index]:setLocation(x, y, true)
				end
				
			elseif event.type == 'disconnect' then
				state.switch(menu, 'hostDisconnect')
			end
		end
		
		--[[
		if self.tick >= self.tock then
			self.tick = 0
			self.host:broadcast('t|'..math.floor(self.timer*100))
		end
		]]
	else
		self.timer = self.timer + dt
		
		-- check some events, 100ms timeout
		local event = self.host:service(0)

		if event then
			--event.peer:ping_interval(1000)
			self.lastEvent = event
			self.peer = event.peer
			
			if event.type == 'connect' then
				self.state = 'run'
				self.timer = 0
			
			elseif event.type == 'receive' then
				if string.find(event.data, 'p|') == 1 then -- True if it is piece movement data
					local str = string.gsub(event.data, 'p|', '')
					local pieceTable = stringToTable(str)
					
					local index = tonumber(pieceTable[1])
					local x = tonumber(pieceTable[2])
					local y = tonumber(pieceTable[3])
					
					self.pieces[index]:setLocation(x, y, true)
				elseif string.find(event.data, 'c|') == 1 then -- True if it is piece movement data
					local str = string.gsub(event.data, 'c|', '')
					self.color = tonumber(str)
				end
				
			elseif event.type == 'disconnect' then
				state.switch(menu, 'clientDisconnect')
			end
		end
	end
end

function game:keypressed(key, isrepeat)
    if console.keypressed(key) then
        return
    end
end

function game:mousepressed(x, y, mbutton)
    if console.mousepressed(x, y, mbutton) then
        return
    end
	
	if self.state == 'run' then -- cannot move pieces unless the game has started
		self.selected = nil
		
		for i, piece in ipairs(self.pieces) do
			-- if no piece is selected or this piece is selected
			
			if piece.color == self.color and piece:isHover(x, y) then
				-- if a piece is selected, then self.selected is set to the piece's index. else set to nil
				if not self.selected or self.selected == i then
					if piece:clicked(mbutton) then
						self.selected = i
					end
				end
			elseif piece.selected then
				local tileX, tileY = self.board:getTile(x, y)
				if tileX and tileY then
					local moved = piece:setLocation(tileX, tileY)
					if moved then
						self:sendMove(i, tileX, tileY)
					end
				end
			end
			
			--piece.color == self.color

			if piece.color ~= self.color then
				-- only show information about it, no movement or selecting
			end
			
		end
		
		-- guarentees all pieces are deselected
		for i, piece in ipairs(self.pieces) do
			piece:deselect()
		end
		
		-- selects a piece if needed
		if self.selected then
			self.pieces[self.selected]:select()
		end
	end
end

function game:draw()
    love.graphics.setFont(font[48])
	
	self.board:draw()
	
	for k, piece in pairs(self.pieces) do
		piece:draw()
	end
	
	
	
	love.graphics.setFont(fontBold[16])
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(love.timer.getFPS()..'FPS', 5, 5)
	
	
	-- networking
	if self.hosting then
		love.graphics.print('Running server on ' .. self.ip .. ':' .. self.port, 5, 25)
		love.graphics.print('Server Time: '..math.floor(self.timer*100)/100, 5, 45)
		love.graphics.print('Sent: '..self.host:total_sent_data()*.000001 ..'MB; Received: '..self.host:total_received_data()*.000001 ..'MB', 5, 85)
	else
		love.graphics.print('Server Time: '..math.floor(self.timer*100)/100, 5, 45)
		love.graphics.print('Sent: '..self.host:total_sent_data()*.000001 ..'MB; Received: '..self.host:total_received_data()*.000001 ..'MB', 5, 85)
	end
	
	if self.lastEvent then
        local msg = 'Last message: '..tostring(self.lastEvent.data)..' from '..tostring(self.peer:index())
        love.graphics.print(msg, 5, 65)
    end
	
	if self.peer then
		love.graphics.print(self.peer:round_trip_time()..'ms', 5, 105)
	end
end


function game:sendMove(index, x, y)
	if self.hosting then
		self.host:broadcast('p|'..index..' '..x..' '..y)
	elseif self.peer then
		self.peer:send('p|'..index..' '..x..' '..y)
	end
end