io.stdout:setvbuf("no") -- to print on the console realtime (sublime text)
require("AI")
require("Game")

function love.load()
	love.window.setMode(500,500)
	draw = love.graphics.newImage('assets/draw.png') --show the draw window
	winner = love.graphics.newImage('assets/winner.png') --show the winner
	background = love.graphics.newImage('assets/background.png') -- a neat chalkboard object
	drawables = {love.graphics.newImage('assets/X.png'), love.graphics.newImage('assets/O.png')} -- our X and O as drawable objects
	--now we initiate our Game class
	mainGame = Game:new({0,0,0,0,0,0,0,0,0},-- exclusive for the match state logic (neutral/win/draw)
						1, -- turn
						{},--example on a symbol array == {drawble, squareKey,turn}
						0, -- depth
						{{35, 40},{190, 40},{345, 40},{35, 190},{190, 190},{345, 190},{35, 345},{190, 345},{345, 345}}) --board hitboxes
end

function love.update(dt)
	local status = mainGame:status()
	if status == -1 and mainGame.turn == 2 then

		    AI = AI:new(mainGame, 0)
		    symbols = mainGame.symbols
	    	choice = AI:getChoice()
	    	table.insert(symbols,{drawables[mainGame.turn], choice, mainGame.turn}) --inserts the square for drawing
	    	mainGame:setVariable('symbols', symbols)
	    	mainGame:setVariable('turns', mainGame.turn, choice)

	    	mainGame:switchTurns()
	    	mainGame:resetVariablesTable()
	end
	
end
function love.draw()
	local status = mainGame:status()
	if status == -1 then --while the game is still not won continue drawing
	    love.graphics.draw(background, 0, 0)
	    --NOTE : spacing between columns is 155
	    --love.graphics.draw(X, 35, 40)
	    symbols = mainGame.symbols
	    squares = mainGame.squares
	    for i,v in ipairs(symbols) do
	    	love.graphics.draw(symbols[i][1], squares[symbols[i][2]][1], squares[symbols[i][2]][2])
	    end
	else 
		if status == 1 then --if the game is won by a player, show so
			love.graphics.draw(winner, 0, 0)
	    	love.graphics.draw(drawables[turn],192,192)
		else
			love.graphics.draw(draw, 0, 0) -- else, it a draw
		end
	end	
end


function love.mousereleased(x,y,button)
	if button == 'l' then
	    squareKey = mainGame:checkMouseHit(x,y) --check if the mouse hits one of our drawable squares
	    if mainGame:validateInput(squareKey) then --now we check if its a usable square
	    	symbols = mainGame.symbols
	    	turn = mainGame.turn
	    	table.insert(symbols,{drawables[turn], squareKey, turn}) --inserts the square for drawing
	    	mainGame:setVariable('symbols', symbols)
	    	mainGame:setVariable('turns', turn,squareKey)

	    	mainGame:switchTurns()
	    	mainGame:resetVariablesTable()
	    end
	end
end
