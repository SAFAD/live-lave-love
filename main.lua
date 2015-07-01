io.stdout:setvbuf("no")

function love.load()
	mouseSquareKey = 1
	love.window.setMode(500,500)
	background = love.graphics.newImage('assets/background.png')
	X = love.graphics.newImage('assets/X.png')
	O = love.graphics.newImage('assets/O.png')
	squares = {{35, 40},{190, 40},{345, 40},{35, 190},{190, 190},{345, 190},{35, 345},{190, 345},{345, 345}}
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(X, squares[mouseSquareKey][1], squares[mouseSquareKey][2])
    --NOTE : spacing between columns is 155
    --love.graphics.draw(X,   35, 40)
    --love.graphics.draw(O,  190, 40)
    --love.graphics.draw(X,  345, 40)
    --love.graphics.draw(O,  35, 190)
    --love.graphics.draw(X, 190, 190)
    --love.graphics.draw(O, 345, 190)
    --love.graphics.draw(X,  35, 345)
    --love.graphics.draw(O, 190, 345)
    --love.graphics.draw(O, 345, 345)
end


function love.mousereleased(x,y,button)
	if button == 'l' then
	    squareKey = checkMouseHit(x,y)
	    if squareKey ~= null then
	    	mouseSquareKey = squareKey
	    end
	end
end

function checkMouseHit(mouseX, mouseY)
	squareKey = null
	for key,value in pairs(squares) do
		if mouseX < value[1]+115 and
		   mouseY < value[2]+115 and
		   value[1] < mouseX and
		   value[2] < mouseY then
		   
		   squareKey = key
		   break
		end
	end
	return squareKey
end