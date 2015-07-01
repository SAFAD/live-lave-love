io.stdout:setvbuf("no") -- to print on the console realtime (sublime text)

require("AI")

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
	depth = 0
end

function love.update(dt)
	if turn == 2 then
		depth = depth+1
	    AIMove = minmax(turns,depth, isWon,turn)[2]
	    --print(AIMove)
	    table.insert(symbols,{drawables[turn], AIMove, turn}) --inserts the square for drawing

    	turns[AIMove] = turn --tell our match state logic that we used a square

    	isWon, turn = checkBoard(turns, isWon, turn) -- now we check if someone won the game
	end
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

	    	isWon, turn = checkBoard(turns, isWon, turn) -- now we check if someone won the game

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
