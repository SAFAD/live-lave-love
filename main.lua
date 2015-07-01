io.stdout:setvbuf("no") -- to print on the console realtime (sublime text)

function love.load()
	love.window.setMode(500,500)
	draw = love.graphics.newImage('assets/draw.png') --show the draw window
	winner = love.graphics.newImage('assets/winner.png') --show the winner
	background = love.graphics.newImage('assets/background.png') -- a neat chalkboard object
	drawables = {love.graphics.newImage('assets/X.png'), love.graphics.newImage('assets/O.png')} -- our X and O as drawable objects
	turns = {0,0,0,0,0,0,0,0,0} -- exclusive for the match state logic (neutral/win/draw)
	symbols = {} --example on a symbol array == {drawble, squareKey,turn}
	squares = {{35, 40},{190, 40},{345, 40},{35, 190},{190, 190},{345, 190},{35, 345},{190, 345},{345, 345}} -- our board hitboxes
	turn = 1
	isWon = -1 -- no = -1, win = 1, draw = 2
end

function love.draw()
	if isWon == -1 then --while the game is still not won continue drawing
	    love.graphics.draw(background, 0, 0)
	    --NOTE : spacing between columns is 155
	    --love.graphics.draw(X, 35, 40)

	    for i,v in ipairs(symbols) do
	    	love.graphics.draw(symbols[i][1], squares[symbols[i][2]][1], squares[symbols[i][2]][2])
	    end
	else 
		if isWon == 1 then --if the game is won by a player, show so
			love.graphics.draw(winner, 0, 0)
	    	love.graphics.draw(drawables[turn],192,192)
		else
			love.graphics.draw(draw, 0, 0) -- else, it a draw
		end
	end	
end


function love.mousereleased(x,y,button)
	if button == 'l' then
	    squareKey = checkMouseHit(x,y) --check if the mouse hits one of our drawable squares

	    if squareKey ~= null and
	    	validateInput(squareKey) then --now we check if its a usable square

	    	table.insert(symbols,{drawables[turn], squareKey, turn}) --inserts the square for drawing

	    	turns[squareKey] = turn --tell our match state logic that we used a square

	    	checkBoard() -- now we check if someone won the game

	    end
	end
end

function checkMouseHit(mouseX, mouseY)
	local squareKey = null
	for key,value in pairs(squares) do
		if mouseX < value[1]+115 and
		   mouseY < value[2]+115 and
		   value[1] < mouseX and
		   value[2] < mouseY then -- simply put, check if the clicked mouse location is inside the square
		   
		   squareKey = key
		   break
		end
	end
	return squareKey
end

function validateInput(squareKey)
	local isValid = true
	for i,v in ipairs(symbols) do
		if v[2] == squareKey then -- loop through the drawn symbols, if we match something, break to return false
		    isValid = false
		    break
		end
	end
	return isValid
end

function checkBoard()

	for i=7,1,-3 do
		--print(i,i+1,i+2) --uncomment to understand the loops functionality
		if (turns[i] == 1 and turns[i+1] == 1 and turns[i+2] == 1) or (turns[i] == 2 and turns[i+1] == 2 and turns[i+2] == 2) then
			print('here 1')
		    --checks for horizontal win
		    isWon = 1
		end
	end

	for i=1,3 do
		--[[uncomment the two lines below to understand how these work
			print(i,i+3,i+6)
			print('-------')
			]]--
		if (turns[i] == 1 and turns[i+3] == 1 and turns[i+6] == 1) or (turns[i] == 2 and turns[i+3] == 2 and turns[i+6] == 2) then
		    --checks for vertical win
		    print('here 2')
		    isWon = 1
		end
	end

	for i=3,1,-2 do
		--[[uncomment the two lines below to understand how these work
			print('-------')
			print(i,5,10-i)]]--
		if (turns[i] == 1 and turns[5] == 1 and turns[10-i] == 1) or (turns[i] == 2 and turns[5] == 2 and turns[10-i] == 2) then
		    --checks for a Cross win
		    print('here 3')
		    isWon = 1
		end
	end

	
	--now we check for draw
	if table.getn(symbols) == 9 and isWon == -1 then
	    --its a draw fellas
	    isWon = 2
	end

	if isWon == -1 then
	    if turn > 1 then --switch turns
    	    turn = 1
    	else
    	    turn = 2
    	end
	end
end